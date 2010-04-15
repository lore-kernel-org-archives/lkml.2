Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753635Ab0DONAj (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Apr 2010 09:00:39 -0400
Received: from mail-bw0-f225.google.com ([209.85.218.225]:44171 "EHLO
	mail-bw0-f225.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753580Ab0DONAh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Apr 2010 09:00:37 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=SV/YKRv1/znjzQaAjvIO3kf9hHxmScMJbiBzbPRBkuFa7g+mhYsh+vNpe/6iAK5+F8
         ZOjeOJCvcr1I0CIigb4EQwakSQ23apcwD0UqYsM0fdPMdbpEMQLlePgjqM5TDLavDlDY
         yn1l0GGglQ9DCs+K4Ll/YC6iSrCFxPlaYdNKw=
Date: Thu, 15 Apr 2010 15:00:34 +0200
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: Stephen Rothwell <sfr@canb.auug.org.au>,
       Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>,
       Peter Zijlstra <peterz@infradead.org>, linux-next@vger.kernel.org,
       linux-kernel@vger.kernel.org, ppc-dev <linuxppc-dev@lists.ozlabs.org>
Subject: Re: linux-next: PowerPC WARN_ON_ONCE() after merge of the final
	tree (tip related)
Message-ID: <20100415130032.GA6789@nowhere>
References: <20100415161214.04637496.sfr@canb.auug.org.au> <20100415064940.GA9240@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100415064940.GA9240@elte.hu>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Apr 15, 2010 at 08:49:40AM +0200, Ingo Molnar wrote:
> 
> * Stephen Rothwell <sfr@canb.auug.org.au> wrote:
> 
> > Hi all,
> > 
> > Yesterday's (and today's) linux-next boot (PowerPC) failed like this:
> > 
> > ------------[ cut here ]------------
> > Badness at kernel/lockdep.c:2301
> > NIP: c0000000000a35c8 LR: c0000000000084c4 CTR: 0000000000000000
> > REGS: c000000000bf77e0 TRAP: 0700   Not tainted  (2.6.34-rc4-autokern1)
> > MSR: 8000000000021032 <ME,CE,IR,DR>  CR: 24000044  XER: 00000004
> > TASK = c000000000aa3d30[0] 'swapper' THREAD: c000000000bf4000 CPU: 0
> > GPR00: 0000000000000001 c000000000bf7a60 c000000000bf32f0 c0000000000084c4 
> > GPR04: 0000000000000000 0000000000000a00 0000000000000000 0000000000000068 
> > GPR08: 0000000000000008 c000000000c4fabe 0000000000000000 7265677368657265 
> > GPR12: 8000000000009032 c000000007691000 0000000001c00000 c000000000770bf8 
> > GPR16: c00000000076f390 0000000000000000 0000000000430000 00000000024876f0 
> > GPR20: c000000000887480 0000000002487480 c0000000008876f0 0000000001b5f8d0 
> > GPR24: c000000000770478 0000000003300000 c000000000c1f1c8 c000000000884610 
> > GPR28: c000000000c1b290 c0000000000084c4 c000000000b45068 c000000000aa3d30 
> > NIP [c0000000000a35c8] .trace_hardirqs_on_caller+0xb0/0x224
> > LR [c0000000000084c4] system_call_common+0xc4/0x114
> > Call Trace:
> > [c000000000bf7a60] [c000000000bf7ba0] init_thread_union+0x3ba0/0x4000 (unreliable)
> > [c000000000bf7af0] [c0000000000084c4] system_call_common+0xc4/0x114
> > --- Exception: c01 at .kernel_thread+0x28/0x70
> >     LR = .rest_init+0x34/0xf8
> > [c000000000bf7de0] [c00000000086916c] .proc_sys_init+0x20/0x64 (unreliable)
> > [c000000000bf7e50] [c0000000000099c0] .rest_init+0x20/0xf8
> > [c000000000bf7ee0] [c000000000848af0] .start_kernel+0x484/0x4a8
> > [c000000000bf7f90] [c0000000000083c0] .start_here_common+0x1c/0x5c
> > Instruction dump:
> > 409e0188 0fe00000 48000180 801f08d8 2f800000 41be0050 880d01da 2fa00000 
> > 41be0028 e93e8538 88090000 68000001 <0b000000> 2fa00000 41be0010 e93e8538 
> > ------------[ cut here ]------------
> > 
> > Caused by commit bd6d29c25bb1a24a4c160ec5de43e0004e01f72b ("lockstat:
> > Make lockstat counting per cpu").  This added a WARN_ON_ONCE to
> > debug_atomic_inc() which is called from trace_hardirqs_on_caller() with
> > irqs enabled.
> > 
> > Line 2301 is:
> > 
> >         if (unlikely(curr->hardirqs_enabled)) {
> >                 debug_atomic_inc(redundant_hardirqs_on);   <--- 2301
> >                 return;
> >         }
> > 
> > This is especially bad since on PowerPC, WARN_ON is a TRAP and the return
> > path from the TRAP also calls trace_hardirqs_on_caller(), so the TRAP
> > recurses ...
> 
> Ok, we'll fix the warning.
> 
> Btw., WARN_ON trapping on PowerPC is clearly a PowerPC bug - there's a good 
> reason we have WARN_ON versus BUG_ON - it should be fixed.


In this case, I guess the following fix should be sufficient?
I'm going to test it and provide a sane changelog.


diff --git a/kernel/lockdep.c b/kernel/lockdep.c
index 78325f8..65d4336 100644
--- a/kernel/lockdep.c
+++ b/kernel/lockdep.c
@@ -2298,7 +2298,11 @@ void trace_hardirqs_on_caller(unsigned long ip)
 		return;
 
 	if (unlikely(curr->hardirqs_enabled)) {
+		unsigned long flags;
+
+		raw_local_irq_save(flags);
 		debug_atomic_inc(redundant_hardirqs_on);
+		raw_local_irq_restore(flags);
 		return;
 	}
 	/* we'll do an OFF -> ON transition: */

