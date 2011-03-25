Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754232Ab1CYQQs (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Mar 2011 12:16:48 -0400
Received: from va3ehsobe006.messaging.microsoft.com ([216.32.180.16]:16522
	"EHLO VA3EHSOBE009.bigfish.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1750853Ab1CYQQq convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Mar 2011 12:16:46 -0400
X-SpamScore: -21
X-BigFish: VPS-21(zzbb2cK146fK1432N98dN4015Lzz1202hzz8275bh8275dhz32i637h668h62h)
X-Spam-TCS-SCL: 1:0
X-Forefront-Antispam-Report: KIP:(null);UIP:(null);IPVD:NLI;H:ausb3twp02.amd.com;RD:none;EFVD:NLI
X-WSS-ID: 0LIMFVI-02-IIU-02
X-M-MSG: 
Date: Fri, 25 Mar 2011 17:16:28 +0100
From: Robert Richter <robert.richter@amd.com>
To: Ingo Molnar <mingo@elte.hu>
CC: Eric Dumazet <eric.dumazet@gmail.com>, Andi Kleen <andi@firstfloor.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Jack Steiner <steiner@sgi.com>, Jan Beulich <JBeulich@novell.com>,
        Borislav Petkov <bp@amd64.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Nick Piggin <npiggin@kernel.dk>, "x86@kernel.org" <x86@kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Andrew Morton <akpm@linux-foundation.org>,
        Ingo Molnar <mingo@redhat.com>, "tee@sgi.com" <tee@sgi.com>,
        Nikanth Karthikesan <knikanth@suse.de>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "H. Peter Anvin" <hpa@zytor.com>
Subject: Re: [PATCH RFC] x86: avoid atomic operation in
 test_and_set_bit_lock if possible
Message-ID: <20110325161628.GB12393@erda.amd.com>
References: <20110324173020.GA26761@sgi.com>
 <20110324200010.GB7957@elte.hu>
 <1300999682.2714.23.camel@edumazet-laptop>
 <20110324205422.GB2393@elte.hu>
 <1301000557.2714.33.camel@edumazet-laptop>
 <m2oc50kxg0.fsf@firstfloor.org>
 <AANLkTimib3TqemF9L=VNkcXT3uFam1gYmVtuA3wrAv1j@mail.gmail.com>
 <20110324235654.GM21838@one.firstfloor.org>
 <1301032040.2714.569.camel@edumazet-laptop>
 <20110325093228.GB13640@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset="iso-8859-1"
Content-Disposition: inline
In-Reply-To: <20110325093228.GB13640@elte.hu>
User-Agent: Mutt/1.5.20 (2009-06-14)
Content-Transfer-Encoding: 8BIT
X-OriginatorOrg: amd.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 25.03.11 05:32:28, Ingo Molnar wrote:
> 
> * Eric Dumazet <eric.dumazet@gmail.com> wrote:
> 
> > Le vendredi 25 mars 2011 à 00:56 +0100, Andi Kleen a écrit :
> > > > never EVER seen any good explanation of why that particular sh*t
> > > > argument would b true. It seems to be purely about politics, where
> > > > some idiotic vendor (namely HP) has convinced Intel that they really
> > > > need it. To the point where some engineers seem to have bought into
> > > > the whole thing and actually believe that fairy tale ("firmware can do
> > > > better" - hah! They must be feeding people some bad drugs at the
> > > > cafeteria)
> > > 
> > > For the record I don't think it's a good idea for the BIOS to do 
> > > this (and I'm not aware of any engineer who does),  
> > > but I think Linux should do better than just disabling PMU use when 
> > > this happens.
> > > 
> > > However I suspect taking over SCI would cause endless problems
> > > and is very likely not a good idea.
> > 
> > I tried many different changes in BIOS and all failed (the machine is
> > damn slow at boot, this takes age).
> > 
> > I am stuck :(
> 
> Could you please try the patch below?
> 
> Thanks,
> 
> 	Ingo
> 
> ------------------->
> From 14df27334ac47a5cec67fb2238d14499346acc38 Mon Sep 17 00:00:00 2001
> From: Ingo Molnar <mingo@elte.hu>
> Date: Fri, 25 Mar 2011 10:24:23 +0100
> Subject: [PATCH] perf, x86: Complain louder about BIOSen corrupting CPU/PMU state and continue
> 
> Eric Dumazet reported that hardware PMU events do not work on his
> system, due to the BIOS corrupting PMU state:
> 
>     Performance Events: PEBS fmt0+, Core2 events, Broken BIOS detected, using software events only.
>     [Firmware Bug]: the BIOS has corrupted hw-PMU resources (MSR 186 is 43003c)
> 
> Linus suggested that we continue in the face of such BIOS-induced CPU
> state corruption:
> 
>    http://lkml.org/lkml/2011/3/24/608
> 
> Such BIOSes will have to be fixed - developers rely on a working and fully
> capable PMU and BIOS interfering with CPU state is simply not acceptable.
> 
> So this patch changes perf to continue when it detects such BIOS
> interaction, some hardware events may be unreliable due to the BIOS writing
> and re-writing them - there's not much the kernel can do about that.
> 
> Reported-by: Eric Dumazet <eric.dumazet@gmail.com>
> Suggested-by: Linus Torvalds <torvalds@linux-foundation.org>
> Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
> Cc: Arnaldo Carvalho de Melo <acme@redhat.com>
> Cc: Frederic Weisbecker <fweisbec@gmail.com>
> Cc: Mike Galbraith <efault@gmx.de>
> Cc: Steven Rostedt <rostedt@goodmis.org>
> LKML-Reference: <new-submission>
> Signed-off-by: Ingo Molnar <mingo@elte.hu>
> ---
>  arch/x86/kernel/cpu/perf_event.c |    9 +++++++--
>  1 files changed, 7 insertions(+), 2 deletions(-)
> 
> diff --git a/arch/x86/kernel/cpu/perf_event.c b/arch/x86/kernel/cpu/perf_event.c
> index ec46eea..eb00677 100644
> --- a/arch/x86/kernel/cpu/perf_event.c
> +++ b/arch/x86/kernel/cpu/perf_event.c
> @@ -500,12 +500,17 @@ static bool check_hw_exists(void)
>  	return true;
>  
>  bios_fail:
> -	printk(KERN_CONT "Broken BIOS detected, using software events only.\n");
> +	/*
> +	 * We still allow the PMU driver to operate:
> +	 */
> +	printk(KERN_CONT "Broken BIOS detected, complain to your hardware vendor.\n");
>  	printk(KERN_ERR FW_BUG "the BIOS has corrupted hw-PMU resources (MSR %x is %Lx)\n", reg, val);
> -	return false;
> +
> +	return true;

Ingo, you jump out the loop here. This skips checks on other registers
and msr access. And if we want to continue anyway, checking msr access
becomes more important as the bios may block it.

-Robert

>  
>  msr_fail:
>  	printk(KERN_CONT "Broken PMU hardware detected, using software events only.\n");
> +
>  	return false;
>  }
>  
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
> 

-- 
Advanced Micro Devices, Inc.
Operating System Research Center

