Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753235Ab1J0HcB (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Oct 2011 03:32:01 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:59614 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750779Ab1J0HcA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Oct 2011 03:32:00 -0400
Date: Thu, 27 Oct 2011 09:30:29 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Daniel J Blueman <daniel@numascale-asia.com>
Cc: Jesse Barnes <jbarnes@virtuousgeek.org>,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
        H Peter Anvin <hpa@zytor.com>, Steffen Persvold <sp@numascale.com>,
        linux-kernel@vger.kernel.org, x86@kernel.org
Subject: Re: [PATCH 2/3] Add multi-node boot support
Message-ID: <20111027073029.GD15923@elte.hu>
References: <1319609230-18897-1-git-send-email-daniel@numascale-asia.com>
 <1319609230-18897-2-git-send-email-daniel@numascale-asia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1319609230-18897-2-git-send-email-daniel@numascale-asia.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-ELTE-SpamScore: -2.0
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-2.0 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.3.1
	-2.0 BAYES_00               BODY: Bayes spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Daniel J Blueman <daniel@numascale-asia.com> wrote:

> From: Steffen Persvold <sp@numascale.com>
> 
> From: Steffen Persvold <sp@numascale.com>
> 
> Fix booting multi-node systems with Numascale's NumaChip.
> 
> v2:
>  - [Daniel] rediffed and validated against 3.1-rc10
> 
> Signed-off-by: Steffen Persvold <sp@numascale.com>
> Signed-off-by: Daniel J Blueman <daniel@numascale-asia.com>
> ---
>  arch/x86/kernel/cpu/amd.c |    7 +++++++
>  1 files changed, 7 insertions(+), 0 deletions(-)
> 
> diff --git a/arch/x86/kernel/cpu/amd.c b/arch/x86/kernel/cpu/amd.c
> index b13ed39..4b551f5 100644
> --- a/arch/x86/kernel/cpu/amd.c
> +++ b/arch/x86/kernel/cpu/amd.c
> @@ -7,6 +7,7 @@
>  #include <asm/apic.h>
>  #include <asm/cpu.h>
>  #include <asm/pci-direct.h>
> +#include <asm/numachip/numachip.h>
>  
>  #ifdef CONFIG_X86_64
>  # include <asm/numa_64.h>
> @@ -350,6 +351,12 @@ static void __cpuinit srat_detect_node(struct cpuinfo_x86 *c)
>  	node = numa_cpu_node(cpu);
>  	if (node == NUMA_NO_NODE)
>  		node = per_cpu(cpu_llc_id, cpu);
> +	else if (is_numachip_system()) {
> +		/* fix for multi-node systems: set phys_proc_id and cpu_llc_id
> +		   to node number from ACPI SRAT table */

please use the customary (multi-line) comment style:

  /*
   * Comment .....
   * ...... goes here.
   */

specified in Documentation/CodingStyle.

> +		c->phys_proc_id = node;
> +		per_cpu(cpu_llc_id, cpu) = node;
> +	}

But more importantly, please first explain why the quirk is needed 
(the patch only explains what it does but does not explain why it 
needs these changes - other NUMA systems are able to boot without 
this quirk).

If it's absolutely needed then add a proper quirk handler instead of 
polluting the generic code.

Thanks,

	Ingo
