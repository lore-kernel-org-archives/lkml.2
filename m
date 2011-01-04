Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752429Ab1ADIs6 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Jan 2011 03:48:58 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:59023 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750953Ab1ADIs5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Jan 2011 03:48:57 -0500
Date: Tue, 4 Jan 2011 09:48:47 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Yinghai Lu <yinghai@kernel.org>
Cc: "H. Peter Anvin" <hpa@linux.intel.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] x86, 64bit: Always make MAX_APICS to 32768
Message-ID: <20110104084847.GB26209@elte.hu>
References: <4D1D2C4D.4090806@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4D1D2C4D.4090806@kernel.org>
User-Agent: Mutt/1.5.20 (2009-08-17)
X-ELTE-SpamScore: -2.0
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-2.0 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.5
	-2.0 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Yinghai Lu <yinghai@kernel.org> wrote:

> 
> Found one x2apic pre-enabled system, x2apic_mode suddenly get corrupted
> after register some cpus. when compiled CONFIG_NR_CPUS=255 instead of 512
> 
> It turns out that generic_processor_info() ==> phyid_set(apicid, phys_cpu_present_map) cause the problem.
> 
> phys_cpu_present_map is with MAX_APICS bits. and pre-enabled system some cpus apic id > 255.
> 
> the variable after phys_cpu_present_map may get corrupted.... siliently...
> 
> ffffffff828e8420 B phys_cpu_present_map
> ffffffff828e8440 B apic_verbosity
> ffffffff828e8444 B local_apic_timer_c2_ok
> ffffffff828e8448 B disable_apic
> ffffffff828e844c B x2apic_mode
> ffffffff828e8450 B x2apic_disabled
> ffffffff828e8454 B num_processors
> ...
> 
> Actually phys_cpu_present_map is referenced via apic id, instead index. we should use
> MAX_LOCAL_APIC instead MAX_APICIS. but that is another header.
> 
> So just let MAX_APICS equal to MAX_LOCAL_APIC at this point.
> esp for 64 bit will be 32768 in all cases.
> 
> Signed-off-by: Yinghai Lu <yinghai@kernel.org>
> 
> ---
>  arch/x86/include/asm/mpspec_def.h |    6 +-----
>  1 file changed, 1 insertion(+), 5 deletions(-)
> 
> Index: linux-2.6/arch/x86/include/asm/mpspec_def.h
> ===================================================================
> --- linux-2.6.orig/arch/x86/include/asm/mpspec_def.h
> +++ linux-2.6/arch/x86/include/asm/mpspec_def.h
> @@ -17,11 +17,7 @@
>  # define MAX_MPC_ENTRY 1024
>  # define MAX_APICS      256
>  #else
> -# if NR_CPUS <= 255
> -#  define MAX_APICS     255
> -# else
> -#  define MAX_APICS   32768
> -# endif
> +# define MAX_APICS    32768
>  #endif
>  
>  /* Intel MP Floating Pointer Structure */

Please fix the real bug first: the lack of boundary checks when we set 
phys_cpu_present_map!

Then, once that bitmap op is not corrupting nearby variables silently but triggers a 
fail-safe logic instead (ignoring apics that go outside the supported range? 
printk-ing a warning?) can we think about upping the limit.

But even with the limit upping, please show (in the changelog) a before/after 'size 
vmlinux' comparison, to make sure that this rather drastic change of the limit does 
not waste unreasonable amounts of memory.

Thanks,

	Ingo
