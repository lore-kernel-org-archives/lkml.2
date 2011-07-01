Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756230Ab1GAMTx (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Jul 2011 08:19:53 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.123]:38539 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755084Ab1GAMTw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Jul 2011 08:19:52 -0400
X-Authority-Analysis: v=1.1 cv=IOX921YOuPvYFce5aSLzPVIStpiCPR9M8R83dyHW74w= c=1 sm=0 a=EAdfuy46jrwA:10 a=5SG0PmZfjMsA:10 a=Q9fys5e9bTEA:10 a=OPBmh+XkhLl+Enan7BmTLg==:17 a=igxzgkY5E_bLAZ8LYAsA:9 a=w-O5DQ1kx6RD1EGfNlYA:7 a=PUjeQqilurYA:10 a=OPBmh+XkhLl+Enan7BmTLg==:117
X-Cloudmark-Score: 0
X-Originating-IP: 67.242.120.143
Subject: Re: [RFC][PATCH] kprobes: Add separate preempt_disabling for
 kprobes
From: Steven Rostedt <rostedt@goodmis.org>
To: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
Cc: LKML <linux-kernel@vger.kernel.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@elte.hu>,
        Andrew Morton <akpm@linux-foundation.org>
In-Reply-To: <4E0D5682.3050806@hitachi.com>
References: <1309440213.26417.76.camel@gandalf.stny.rr.com>
	 <1309449117.26417.90.camel@gandalf.stny.rr.com>
	 <4E0D5682.3050806@hitachi.com>
Content-Type: text/plain; charset="ISO-8859-15"
Date: Fri, 01 Jul 2011 08:19:49 -0400
Message-ID: <1309522789.26417.128.camel@gandalf.stny.rr.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2011-07-01 at 14:09 +0900, Masami Hiramatsu wrote:

> BTW, on my tip tree, add_preempt_count (a.k.a. inc_preempt_count())
> is marked as __kprobes, so it can not be probed. Is there any change?
> 

That is when debug or preempt tracer is enabled. Otherwise it's
hardcoded into whatever calls it:

#if defined(CONFIG_DEBUG_PREEMPT) || defined(CONFIG_PREEMPT_TRACER)
  extern void add_preempt_count(int val);
  extern void sub_preempt_count(int val);
#else
# define add_preempt_count(val)	do { preempt_count() += (val); } while (0)
# define sub_preempt_count(val)	do { preempt_count() -= (val); } while (0)
#endif


Anyway, it still doesn't help the place that reads preempt_count() and
then later uses the result. I hit the crash in schedule_bug() where it
increments preempt count, then reads it to see if it is only 1.

-- Steve


