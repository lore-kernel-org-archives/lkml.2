Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755209Ab1K2Wve (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Nov 2011 17:51:34 -0500
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:65262 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752261Ab1K2Wva (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Nov 2011 17:51:30 -0500
X-Authority-Analysis: v=2.0 cv=QqvcLCOd c=1 sm=0 a=ZycB6UtQUfgMyuk2+PxD7w==:17 a=x9VNfy9Nl58A:10 a=5SG0PmZfjMsA:10 a=IkcTkHD0fZMA:10 a=yfpCUIJ12KpPmU5B6hYA:9 a=Gr50fdKl-q_jCqrC4QcA:7 a=QEXdDO2ut3YA:10 a=ZycB6UtQUfgMyuk2+PxD7w==:117
X-Cloudmark-Score: 0
X-Originating-IP: 74.67.80.29
Subject: Re: Perhaps a side effect regarding NMI returns
From: Steven Rostedt <rostedt@goodmis.org>
To: Jason Baron <jbaron@redhat.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        Andi Kleen <andi@firstfloor.org>, LKML <linux-kernel@vger.kernel.org>,
        Ingo Molnar <mingo@redhat.com>, Peter Zijlstra <peterz@infradead.org>,
        "H. Peter Anvin" <hpa@linux.intel.com>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>,
        Paul Turner <pjt@google.com>
In-Reply-To: <20111129221419.GE6610@redhat.com>
References: <1322539673.17003.45.camel@frodo>
	 <CA+55aFwehof2kZCENTOFFobWqVvm04BZer6Cc-fQfVvcCE1NVQ@mail.gmail.com>
	 <m2r50qlmgk.fsf@firstfloor.org>
	 <CA+55aFxyBYFbx=AGgJ35Dx+U8KVPktesHetYnQrYpt1QGKTrbQ@mail.gmail.com>
	 <20111129203111.GQ24062@one.firstfloor.org>
	 <CA+55aFxUFkHGXk_eEN1GYsZWe5_G9uoCP6DkL6bw9+wWP2_fcw@mail.gmail.com>
	 <1322600301.17003.84.camel@frodo>  <20111129221419.GE6610@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 29 Nov 2011 17:51:26 -0500
Message-ID: <1322607086.17003.94.camel@frodo>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.3 (2.32.3-1.fc14) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2011-11-29 at 17:14 -0500, Jason Baron wrote:
> On Tue, Nov 29, 2011 at 03:58:21PM -0500, Steven Rostedt wrote:

> > But people don't like the overhead that stop_machine() causes, and I
> > have code that can make the modifications for ftrace with break points.
> > By adding a break point, syncing, then modifying the code and break
> 
> But if there's still has to be some sort of 'syncing' after we add a break
> point, how much are we going to save? Or I guess your're using an IPI? 

Well, anything is better than stop machine, event synchronize_sched() ;)

But the code I have in ftrace does bulk changes. It adds a break point
to all functions, then it does the sync, then it updates all the points
to the new code.

Looking at my code, here's what I did after setting up the breakpoints:

static void do_sync_core(void *data)
{
        sync_core();
}

static void run_sync(void)
{
        int enable_irqs = irqs_disabled();

        /* We may be called with interrupts disbled. */
        if (enable_irqs)
                local_irq_enable();
        on_each_cpu(do_sync_core, NULL, 1);
        if (enable_irqs)
                local_irq_disable();
}

Note, it's fine to enable interrupts here, it's only used by ftrace.

-- Steve


