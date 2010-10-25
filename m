Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755110Ab0JYMdK (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Oct 2010 08:33:10 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:49128 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751903Ab0JYMdI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Oct 2010 08:33:08 -0400
Date: Mon, 25 Oct 2010 14:32:48 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Steven Rostedt <rostedt@goodmis.org>, Jason Baron <jbaron@redhat.com>,
        LKML <linux-kernel@vger.kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>,
        Arnaldo Carvalho de Melo <acme@redhat.com>,
        masami.hiramatsu.pt@hitachi.com
Subject: Re: [PATCH][GIT PULL] tracing: Fix compile issue for
 trace_sched_wakeup.c
Message-ID: <20101025123248.GA5398@elte.hu>
References: <20101022182433.GA24637@elte.hu>
 <20101022183900.GG6498@redhat.com>
 <20101023200216.GA19324@elte.hu>
 <1287881618.16971.657.camel@gandalf.stny.rr.com>
 <20101024112540.GA21267@elte.hu>
 <20101025085927.GA11025@elte.hu>
 <20101025093045.GA21997@elte.hu>
 <20101025114501.GA2000@elte.hu>
 <20101025121059.GA3063@elte.hu>
 <1288009103.15336.58.camel@twins>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1288009103.15336.58.camel@twins>
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


* Peter Zijlstra <a.p.zijlstra@chello.nl> wrote:

> > i.e. the 'fn(timer)' call crashed.
> 
> Right, and its doing an indirect function call from the first stack entry.. which 
> would seem to suggest someone scribbled our stack..

The ESP value itself seems generally sane:

> > [   11.980010] ESI: f65bdf50 EDI: f6806a00 EBP: f6806a30 ESP: c13dff04
> > [   11.980010] Process swapper (pid: 0, ti=c13de000 task=c13e2f20 task.ti=c13de000

As task.ti is 8K aligned (as it should be), and ESP is just a tad off the top of the 
stack (as it should be: a light timer irq interrupted the idle task).

The relevant stack section looks like this:

[   11.980010]  c103d297 00000000 c10460c1 c13dff4c ca105369 00000002 ffffffff 7fffffff
[   11.980010]  c103d52b ca105369 00000002 ca105369 0000002c f6806a00 00000000 f6806a04
[   11.980010]  ca105369 00000002 ca105369 00000002 00000000 f6805dac 00000000 c1420788

and that 00000000 value after c103d297 seems to be the called fn().

The stack content looks sane as well - we have the NULL entry, then various other, 
good looking entries that dont look corrupted per se. So either there's a 4 byte 
corruption of the stack, or the place where we took 'fn' from got corrupted: either 
the timer structure or the hrtimer per-cpu data area.

(More exotic crash scenarios as possible as well, if we consider .text corruption.)

Thanks,

	Ingo
