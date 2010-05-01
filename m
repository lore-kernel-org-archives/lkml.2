Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754346Ab0EASMU (ORCPT <rfc822;w@1wt.eu>);
	Sat, 1 May 2010 14:12:20 -0400
Received: from mail.skyhub.de ([78.46.96.112]:48426 "EHLO mail.skyhub.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751934Ab0EASMS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 1 May 2010 14:12:18 -0400
Date: Sat, 1 May 2010 20:12:12 +0200
From: Borislav Petkov <bp@alien8.de>
To: Ingo Molnar <mingo@elte.hu>, Frederic Weisbecker <fweisbec@gmail.com>,
       Steven Rostedt <rostedt@goodmis.org>,
       Peter Zijlstra <peterz@infradead.org>
Cc: lkml <linux-kernel@vger.kernel.org>
Subject: perf, ftrace and MCEs
Message-ID: <20100501181212.GA25352@liondog.tnic>
Mail-Followup-To: Borislav Petkov <bp@alien8.de>,
	Ingo Molnar <mingo@elte.hu>,
	Frederic Weisbecker <fweisbec@gmail.com>,
	Steven Rostedt <rostedt@goodmis.org>,
	Peter Zijlstra <peterz@infradead.org>,
	lkml <linux-kernel@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

so I finally had some spare time to stare at perf/ftrace code and ponder
on how to use those facilities for MCE collecting and reporting. Btw, I
have to say, it took me quite a while to understand what goes where - my
suggestion to anyone who tries to understand how perf/ftrace works is
to do make <file.i> where there is at least one trace_XXX emit record
function call and start untangling code paths from there.

So anyway, here are some questions I had, I just as well may've missed
something so please correct me if I'm wrong:

1. Since machine checks can happen at any time, we need to have the
MCE tracepoint (trace_mce_record() in <include/trace/events/mce.h>)
always enabled. This, in turn, means that we need the ftrace/perf
infrastructure always compiled in (lockless ring buffer, perf_event.c
stuff) on any x86 system so that MCEs can be handled at anytime. Is this
going to be ok to be enabled on _all_ machines, hmmm... I dunno, maybe
only a subset of those facilites at least.

2. Tangential to 1., we need that "thin" software layer prepared for
decoding and reporting them as early as possible. event_trace_init() is
an fs_initcall and executed too late, IMHO. The ->perf_event_enable in
the ftrace_event_call is enabled even later on the perf init path over
the sys_perf_even_open which is at userspace time. In our case, this is
going be executed by the error logging and decoding daemon I guess.

3. Since we want to listen for MCEs all the time, the concept of
enabling and disabling those events does not apply in the sense of
performance profiling. IOW, MCEs need to be able to be logged to the
ring buffer at any time. I guess this is easily done - we simply enable
MCE events at the earliest moment possible and disable them on shutdown;
done.

So yeah, some food for thought but what do you guys think?

Thanks.

-- 
Regards/Gruss,
    Boris.
