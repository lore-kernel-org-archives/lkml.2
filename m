Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752335Ab2ALGxF (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Jan 2012 01:53:05 -0500
Received: from mail-ww0-f44.google.com ([74.125.82.44]:32784 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751804Ab2ALGxB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Jan 2012 01:53:01 -0500
Message-ID: <1326351173.2741.3.camel@edumazet-laptop>
Subject: Re: [PATCH 1/2] x86, amd: factor out MMCONFIG discovery
From: Eric Dumazet <eric.dumazet@gmail.com>
To: Bjorn Helgaas <bhelgaas@google.com>
Cc: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>, stable@kernel.org#2.6.34+,
        Borislav Petkov <borislav.petkov@amd.com>,
        linux-kernel@vger.kernel.org, linux-acpi@vger.kernel.org,
        Yinghai Lu <yinghai@kernel.org>, Len Brown <lenb@kernel.org>
Date: Thu, 12 Jan 2012 07:52:53 +0100
In-Reply-To: <20120105212719.3965.40406.stgit@bhelgaas.mtv.corp.google.com>
References: <20120105212719.3965.40406.stgit@bhelgaas.mtv.corp.google.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.1- 
Content-Transfer-Encoding: 8bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Le jeudi 05 janvier 2012 à 14:27 -0700, Bjorn Helgaas a écrit :
> This factors out the AMD native MMCONFIG discovery so we can use it
> outside amd_bus.c.
> 
> amd_bus.c reads AMD MSRs so it can remove the MMCONFIG area from the
> PCI resources.  We may also need the MMCONFIG information to work
> around BIOS defects in the ACPI MCFG table.
> 
> Cc: Borislav Petkov <borislav.petkov@amd.com>
> Cc: Yinghai Lu <yinghai@kernel.org>
> Cc: stable@kernel.org       # 2.6.34+
> Signed-off-by: Bjorn Helgaas <bhelgaas@google.com>
> ---
>  arch/x86/include/asm/amd_nb.h |    2 ++
>  arch/x86/kernel/amd_nb.c      |   31 ++++++++++++++++++++++++++++++
>  arch/x86/pci/amd_bus.c        |   42 +++++++++++------------------------------
>  3 files changed, 44 insertions(+), 31 deletions(-)

>  /**
> @@ -85,6 +57,9 @@ static int __init early_fill_mp_bus_info(void)
>  	u64 val;
>  	u32 address;
>  	bool found;
> +	struct resource fam10h_mmconf_res, *fam10h_mmconf;
> +	u64 fam10h_mmconf_start;
> +	u64 fam10h_mmconf_end;
>  
>  	if (!early_pci_allowed())
>  		return -1;
> @@ -211,12 +186,17 @@ static int __init early_fill_mp_bus_info(void)
>  		subtract_range(range, RANGE_NUM, 0, end);
>  
>  	/* get mmconfig */
> -	get_pci_mmcfg_amd_fam10h_range();
> +	fam10h_mmconf = amd_get_mmconfig_range(&fam10h_mmconf_res);
>  	/* need to take out mmconf range */

This adds following link error if "# CONFIG_CPU_SUP_AMD is not set"

  LD      .tmp_vmlinux1
arch/x86/pci/built-in.o: In function `early_fill_mp_bus_info':
/opt/src/linux/arch/x86/pci/amd_bus.c:189: undefined reference to
`amd_get_mmconfig_range'
make: *** [.tmp_vmlinux1] Error 1



