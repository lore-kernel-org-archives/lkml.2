Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753850Ab1GABdb (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Jun 2011 21:33:31 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.123]:38866 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752597Ab1GABda (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Jun 2011 21:33:30 -0400
X-Authority-Analysis: v=1.1 cv=IOX921YOuPvYFce5aSLzPVIStpiCPR9M8R83dyHW74w= c=1 sm=0 a=ws2KCyzbm0YA:10 a=5SG0PmZfjMsA:10 a=Q9fys5e9bTEA:10 a=OPBmh+XkhLl+Enan7BmTLg==:17 a=T8ONZIejwpGI8540ym0A:9 a=PUjeQqilurYA:10 a=OPBmh+XkhLl+Enan7BmTLg==:117
X-Cloudmark-Score: 0
X-Originating-IP: 67.242.120.143
Subject: Re: [BUG] kprobes crashing because of preempt count
From: Steven Rostedt <rostedt@goodmis.org>
To: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
Cc: LKML <linux-kernel@vger.kernel.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@elte.hu>,
        yrl.pp-manager.tt@hitachi.com
In-Reply-To: <4E0D1EE3.6080607@hitachi.com>
References: <1309440213.26417.76.camel@gandalf.stny.rr.com>
	 <4E0D1EE3.6080607@hitachi.com>
Content-Type: text/plain; charset="ISO-8859-15"
Date: Thu, 30 Jun 2011 21:33:27 -0400
Message-ID: <1309484007.26417.121.camel@gandalf.stny.rr.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2011-07-01 at 10:12 +0900, Masami Hiramatsu wrote:

> > Do we really need to have preemption disabled throughout this? Is it
> > because we don't want to migrate or call schedule? Not sure what the
> > best way to fix this is. Perhaps we add a kprobe_preempt_disable() that
> > is checked as well?
> 
> I think the best way to do that is just removing preemption disabling
> code, because
> - breakpoint exception itself disables interrupt (at least on x86)
> - While single stepping, interrupts also be disabled.

I guess the above point is critical. If interrupts are disabled through
out the entire walk through, then we are fine, as that just guarantees
preemption is disabled anyway. But! if it does get enabled anywhere,
then we will have issues as the two traps require using the same state
data that is stored per cpu.

> (BTW, theoretically, boosted and optimized kprobes shouldn't have
> this problem, because those doesn't execute single-stepping)

Does the optimized kprobes even disable preemption?

> 
> So, I think there is no reason of disabling preemption.

That would be the best solution.

-- Steve


