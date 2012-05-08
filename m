Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754598Ab2EHMZ6 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 May 2012 08:25:58 -0400
Received: from mail-wi0-f178.google.com ([209.85.212.178]:50002 "EHLO
	mail-wi0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754503Ab2EHMZz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 May 2012 08:25:55 -0400
Date: Tue, 8 May 2012 14:25:49 +0200
From: Ingo Molnar <mingo@kernel.org>
To: hpa@zytor.com, linux-kernel@vger.kernel.org, shai@scalemp.com,
        tglx@linutronix.de, ido@wizery.com
Cc: linux-tip-commits@vger.kernel.org
Subject: Re: [tip:x86/platform] vsmp: Fix number of CPUs when vsmp is disabled
Message-ID: <20120508122548.GA5741@gmail.com>
References: <1336462455-22544-1-git-send-email-ido@wizery.com>
 <tip-824a6ae65f085255464155760cb9628a2f0deb29@git.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <tip-824a6ae65f085255464155760cb9628a2f0deb29@git.kernel.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* tip-bot for Shai Fultheim <shai@scalemp.com> wrote:

> Commit-ID:  824a6ae65f085255464155760cb9628a2f0deb29
> Gitweb:     http://git.kernel.org/tip/824a6ae65f085255464155760cb9628a2f0deb29
> Author:     Shai Fultheim <shai@scalemp.com>
> AuthorDate: Tue, 8 May 2012 10:34:15 +0300
> Committer:  Ingo Molnar <mingo@kernel.org>
> CommitDate: Tue, 8 May 2012 11:24:45 +0200
> 
> vsmp: Fix number of CPUs when vsmp is disabled
> 
> In case CONFIG_X86_VSMP is not set, limit the number of CPUs to
> the number of CPUs of the first board.
> 
> Signed-off-by: Shai Fultheim <shai@scalemp.com>
> [ido@wizery.com: rebased, fixed minor coding-style issues]
> Signed-off-by: Ido Yariv <ido@wizery.com>
> Link: http://lkml.kernel.org/r/1336462455-22544-1-git-send-email-ido@wizery.com
> Signed-off-by: Ingo Molnar <mingo@kernel.org>
> ---
>  arch/x86/kernel/vsmp_64.c |   43 +++++++++++++++++++++++++++++++++++++++++++
>  1 files changed, 43 insertions(+), 0 deletions(-)
> 
> diff --git a/arch/x86/kernel/vsmp_64.c b/arch/x86/kernel/vsmp_64.c
> index a1d804b..6aa0d59 100644
> --- a/arch/x86/kernel/vsmp_64.c
> +++ b/arch/x86/kernel/vsmp_64.c
> @@ -15,6 +15,7 @@
>  #include <linux/init.h>
>  #include <linux/pci_ids.h>
>  #include <linux/pci_regs.h>
> +#include <linux/smp.h>
>  
>  #include <asm/apic.h>
>  #include <asm/pci-direct.h>
> @@ -22,6 +23,8 @@
>  #include <asm/paravirt.h>
>  #include <asm/setup.h>
>  
> +#define TOPOLOGY_REGISTER_OFFSET 0x10
> +
>  #if defined CONFIG_PCI && defined CONFIG_PARAVIRT
>  /*
>   * Interrupt control on vSMPowered systems:
> @@ -149,12 +152,52 @@ int is_vsmp_box(void)
>  	return 0;
>  }
>  #endif
> +
> +static void __init vsmp_cap_cpus(void)
> +{
> +	void __iomem *address;
> +	unsigned int cfg, topology, node_shift, maxcpus;
> +
> +#ifdef CONFIG_X86_VSMP
> +	/* VSMP is enabled, no need to cap cpus */
> +	return;
> +#endif
> +
> +	/*
> +	 * CONFIG_X86_VSMP is not configured, so limit the number CPUs to the
> +	 * ones present in the first board, unless explicitly overridden by
> +	 * setup_max_cpus
> +	 */
> +	if (setup_max_cpus != NR_CPUS)
> +		return;
> +
> +	/* Read the vSMP Foundation topology register */
> +	cfg = read_pci_config(0, 0x1f, 0, PCI_BASE_ADDRESS_0);
> +	address = early_ioremap(cfg + TOPOLOGY_REGISTER_OFFSET, 4);
> +	if (WARN_ON(!address))
> +		return;
> +
> +	topology = readl(address);
> +	node_shift = (topology >> 16) & 0x7;
> +	if (!node_shift)
> +		/* The value 0 should be decoded as 8 */
> +		node_shift = 8;
> +	maxcpus = (topology & ((1 << node_shift) - 1)) + 1;
> +
> +	pr_info("vSMP CTL: Capping CPUs to %d (CONFIG_X86_VSMP is unset)\n",
> +		maxcpus);
> +	setup_max_cpus = maxcpus;
> +	early_iounmap(address, 4);

On !CONFIG_SMP this produces the following build failure:

 arch/x86/kernel/vsmp_64.c:171:6: error: ‘setup_max_cpus’ undeclared (first use in this function)

Do you want to keep vSMP on UP? If not then you could add a 
'depends on SMP' to the vSMP Kconfig entry, avoiding the whole 
UP problem space.

Thanks,

	Ingo
