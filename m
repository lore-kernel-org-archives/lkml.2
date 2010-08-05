Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759893Ab0HEH7f (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Aug 2010 03:59:35 -0400
Received: from tx2ehsobe001.messaging.microsoft.com ([65.55.88.11]:53060 "EHLO
	TX2EHSOBE001.bigfish.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758822Ab0HEH7c (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Aug 2010 03:59:32 -0400
X-SpamScore: -34
X-BigFish: VS-34(zz1432N98dN936eM9371Pzz1202hzz15d4Rz32i2a8h87h61h)
X-Spam-TCS-SCL: 0:0
X-FB-SS: 0,
X-FB-DOMAIN-IP-MATCH: fail
X-WSS-ID: 0L6O5J0-01-7DM-02
X-M-MSG: 
Date: Thu, 5 Aug 2010 09:45:04 +0200
From: "Roedel, Joerg" <Joerg.Roedel@amd.com>
To: "H. Peter Anvin" <hpa@zytor.com>
CC: Borislav Petkov <bp@amd64.org>, "mingo@elte.hu" <mingo@elte.hu>,
        "tglx@linutronix.de" <tglx@linutronix.de>,
        "Herrmann3, Andreas" <Andreas.Herrmann3@amd.com>,
        "Seidel, Conny" <Conny.Seidel@amd.com>,
        "Sarathy, Bhavna" <Bhavna.Sarathy@amd.com>,
        "greg@kroah.com" <greg@kroah.com>, "x86@kernel.org" <x86@kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 1/2] x86-32: Fix crashes with CPU hotplug on AMD
 machines
Message-ID: <20100805074503.GI18307@amd.com>
References: <1280940316-7966-1-git-send-email-bp@amd64.org>
 <1280940316-7966-2-git-send-email-bp@amd64.org>
 <4C59F24B.1010702@zytor.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <4C59F24B.1010702@zytor.com>
Organization: Advanced Micro Devices =?iso-8859-1?Q?GmbH?=
	=?iso-8859-1?Q?=2C_Karl-Hammerschmidt-Str=2E_34=2C_85609_Dornach_bei_M=FC?=
	=?iso-8859-1?Q?nchen=2C_Gesch=E4ftsf=FChrer=3A_Thomas_M=2E_McCoy=2C_Giuli?=
	=?iso-8859-1?Q?ano_Meroni=2C_Andrew_Bowd=2C_Sitz=3A_Dornach=2C_Gemeinde_A?=
	=?iso-8859-1?Q?schheim=2C_Landkreis_M=FCnchen=2C_Registergericht_M=FCnche?=
	=?iso-8859-1?Q?n=2C?= HRB Nr. 43632
User-Agent: Mutt/1.5.20 (2009-06-14)
X-Reverse-DNS: ausb3extmailp02.amd.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Aug 04, 2010 at 07:05:47PM -0400, H. Peter Anvin wrote:
> On 08/04/2010 09:45 AM, Borislav Petkov wrote:
> > 
> >         2. Do not use swapper_pg_dir to boot secondary CPUs like 64-bit
> >         does.
> > 
> > This patch implements solution 2. It introduces a trampoline_pg_dir
> > which has the same layout as swapper_pg_dir with low_mappings. This page
> > table is used as the initial page table of the booting CPU. Later in the
> > bringup process, it switches to swapper_pg_dir and does a global TLB
> > flush. This fixes the crashes in our test cases.
> > 
> 
> I would like to keep around a page directory with the low mappings
> around -- and not use it for kernel threads -- at all times *anyway*.
> This means we can remove any current hacks that we have to do around S3
> entry and exit, for example.

Yeah, the page table with the low mappings is trampoline_pg_dir
introduced in this patch :-)

> --- a/arch/x86/kernel/head_32.S
> +++ b/arch/x86/kernel/head_32.S
> @@ -328,7 +328,7 @@ ENTRY(startup_32_smp)
>  /*
>   * Enable paging
>   */
> -	movl $pa(swapper_pg_dir),%eax
> +	movl pa(initial_page_table), %eax
>  	movl %eax,%cr3		/* set the page table pointer.. */
>  	movl %cr0,%eax
>  	orl  $X86_CR0_PG,%eax
> @@ -608,6 +608,8 @@ ignore_int:
>  .align 4
>  ENTRY(initial_code)
>  	.long i386_start_kernel
> +ENTRY(initial_page_table)
> +	.long pa(swapper_pg_dir)
> 
>  /*
>   * BSS section
> @@ -623,6 +625,10 @@ ENTRY(swapper_pg_dir)
>  #endif
>  swapper_pg_fixmap:
>  	.fill 1024,4,0
> +#ifdef CONFIG_X86_TRAMPOLINE
> +ENTRY(trampoline_pg_dir)
> +	.fill 1024,4,0
> +#endif
> 
> I don't really see why this makes sense, though.  It would make more
> sense that the initial page table we set up becomes trampoline_pg_dir;
> we can then set up and change to swapper_pg_dir almost immediately.

To make sure I understand correctly, you suggest to initialize
tramponline_pg_dir in the boot sequence of the first cpu and fork
swapper_pg_dir from it later on?

> I realize this isn't how the 64-bit code works at the moment, but in a
> lot of ways I think it would be better if it did.

Yeah, may make sense. This patch already brings the 32 bit
implementation closer to the 64 bit one. On 64 bit things are somewhat
simpler because the tramponline page table can be defined at
compile-time there (contains only 2 pgd_t entries) while on 32 bit we
have to initialize it at runtime.

	Joerg

-- 
AMD Operating System Research Center

Advanced Micro Devices GmbH Einsteinring 24 85609 Dornach
General Managers: Alberto Bozzo, Andrew Bowd
Registration: Dornach, Landkr. Muenchen; Registerger. Muenchen, HRB Nr. 43632

