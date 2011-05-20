Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934669Ab1ETIMb (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 May 2011 04:12:31 -0400
Received: from casper.infradead.org ([85.118.1.10]:33966 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932489Ab1ETIM1 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 May 2011 04:12:27 -0400
Subject: Re: linux-next: manual merge of the tip tree with the sparc tree
From: Peter Zijlstra <peterz@infradead.org>
To: Daniel Hellstrom <daniel@gaisler.com>
Cc: Stephen Rothwell <sfr@canb.auug.org.au>,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@elte.hu>,
        "H. Peter Anvin" <hpa@zytor.com>, linux-next@vger.kernel.org,
        linux-kernel@vger.kernel.org, "David S. Miller" <davem@davemloft.net>
In-Reply-To: <4DD60530.6090900@gaisler.com>
References: <20110517131435.aceca54e.sfr@canb.auug.org.au>
	 <4DD51D37.3010907@gaisler.com> <1305819306.2466.7228.camel@twins>
	 <4DD60530.6090900@gaisler.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
Date: Fri, 20 May 2011 10:11:53 +0200
Message-ID: <1305879113.2466.7231.camel@twins>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2011-05-20 at 08:07 +0200, Daniel Hellstrom wrote:
> Peter Zijlstra wrote:
> 
> >On Thu, 2011-05-19 at 15:37 +0200, Daniel Hellstrom wrote:
> >
> >
> >  
> >
> >>diff --git a/arch/sparc/kernel/smp_32.c b/arch/sparc/kernel/smp_32.c
> >>index 41102c5..d5b3958 100644
> >>--- a/arch/sparc/kernel/smp_32.c
> >>+++ b/arch/sparc/kernel/smp_32.c
> >>@@ -156,11 +156,11 @@ void arch_send_call_function_ipi_mask(const struct 
> >>cpumask *mask)
> >>
> >> void smp_resched_interrupt(void)
> >> {
> >>+       irq_enter();
> >>+       scheduler_ipi();
> >>        local_cpu_data().irq_resched_count++;
> >>-       /*
> >>-        * do nothing, since it all was about calling re-schedule
> >>-        * routine called by interrupt return code.
> >>-        */
> >>+       irq_exit();
> >>+       /* re-schedule routine called by interrupt return code. */
> >> }
> >>    
> >>
> >
> >That doesn't look like an IPI, that looks like its calls the function on
> >the local cpu, which is completely pointless.
> >  
> >
> The above function is one of the IPI interrupt handlers.
> 
> The smp_send_reschedule() is called by the generic code, it is 
> responsible for sending an IRQ to the target CPU, that CPU comes into 
> smp_resched_interrupt above from the IRQ trap handler. So yes, the 
> scheduler_ipi() is called on the local CPU, but on the CPU taking the 
> IPI not the CPU sending the IPI.

Ah, clearly I cannot read well, I actually thought that was
smp_send_reschedule(). OK, if sparc32 is now actually sending IPIs and
the above is the handler, then you're completely right, sorry for the
confusion.

Also, since sparc32 now grew this IPI, you can remove:

+++ b/init/Kconfig
@@ -827,6 +827,11 @@ config SCHED_AUTOGROUP
          desktop applications.  Task group autogeneration is currently based
          upon task session.
 
+config SCHED_TTWU_QUEUE
+       bool
+       depends on !SPARC32
+       default y
+
 config MM_OWNER
        bool
 

