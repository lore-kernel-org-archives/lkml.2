Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754662Ab0GFXtw (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Jul 2010 19:49:52 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.124]:45878 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751545Ab0GFXtv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Jul 2010 19:49:51 -0400
X-Authority-Analysis: v=1.1 cv=aMplT6I4JJ0P4CS7sRSHqoj9En8aKfIxSsimYOJhsMQ= c=1 sm=0 a=mS1qFslhlkkA:10 a=uEzv4HemXiYA:10 a=7U3hwN5JcxgA:10 a=Q9fys5e9bTEA:10 a=gMqfjgEr1zLu/65IO0LwxA==:17 a=d20viHe1xTBUM-jf0bQA:9 a=9Uo7S9gMD7KyrWPXhbYA:7 a=AXH0ztLCoY_4phveKfYzc9Ao4UMA:4 a=PUjeQqilurYA:10 a=gMqfjgEr1zLu/65IO0LwxA==:117
X-Cloudmark-Score: 0
X-Originating-IP: 74.67.89.75
Subject: Re: [PATCH 2/2] sched: make sched_param arugment static variables
 in some sched_setscheduler() caller
From: Steven Rostedt <rostedt@goodmis.org>
Reply-To: rostedt@goodmis.org
To: Andrew Morton <akpm@linux-foundation.org>
Cc: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
       Ingo Molnar <mingo@elte.hu>, Peter Zijlstra <a.p.zijlstra@chello.nl>,
       LKML <linux-kernel@vger.kernel.org>, linux-mm <linux-mm@kvack.org>,
       Minchan Kim <minchan.kim@gmail.com>,
       David Rientjes <rientjes@google.com>,
       KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
       James Morris <jmorris@namei.org>
In-Reply-To: <20100706161253.79bfb761.akpm@linux-foundation.org>
References: <20100702144941.8fa101c3.akpm@linux-foundation.org>
	 <20100706091607.CCCC.A69D9226@jp.fujitsu.com>
	 <20100706095013.CCD9.A69D9226@jp.fujitsu.com>
	 <1278454438.1537.54.camel@gandalf.stny.rr.com>
	 <20100706161253.79bfb761.akpm@linux-foundation.org>
Content-Type: text/plain; charset="ISO-8859-15"
Organization: Kihon Technologies Inc.
Date: Tue, 06 Jul 2010 19:49:47 -0400
Message-ID: <1278460187.1537.107.camel@gandalf.stny.rr.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2010-07-06 at 16:12 -0700, Andrew Morton wrote:

> Well if we're so worried about resource wastage then how about making
> all boot-time-only text and data reside in __init and __initdata
> sections rather than hanging around uselessly in memory for ever?

That would be a patch I would like :-)

I could probably do that when I get some time.

> 
> Only that's going to be hard because we went and added pointers into
> .init.text from .data due to `struct tracer.selftest', which will cause
> a storm of section mismatch warnings.  Doh, should have invoked the
> selftests from initcalls.  That might open the opportunity of running
> the selftests by modprobing the selftest module, too.

They are called by initcalls. The initcalls register the tracers and
that is the time we call the selftest. No other time.

Is there a way that we set up a function pointer to let the section
checks know that it is only called at bootup?

> 
> And I _do_ wish the selftest module was modprobeable, rather than this
> monstrosity:

The selftests are done by individual tracers at boot up. It would be
hard to modprobe them at that time.


> #ifdef CONFIG_FTRACE_SELFTEST
> /* Let selftest have access to static functions in this file */
> #include "trace_selftest.c"
> #endif
> 
> Really?  Who had a tastebudectomy over there?  At least call it
> trace_selftest.inc or something, so poor schmucks don't go scrabbling
> around wondering "how the hell does this thing get built oh no they
> didn't really go and #include it did they?"


Well this is also the way sched.c adds all its extra code. Making it
trace_selftest.inc would make it hard to know what the hell it was. And
also hard for editors to know what type of file it is, or things can be
missed with a 'find . -name "*.[ch]" | xargs grep blahblah'

Yes, the self tests are ugly and can probably go with an overhaul. Since
we are trying to get away from the tracer plugins anyway, they will
start disappearing when the plugins do.

We should have some main selftests anyway. Those are for the TRACE_EVENT
tests (which are not even in the trace_selftest.c file, and the function
testing which currently are, as well as the latency testers.

The trace_selftest.c should eventually be replaced with more compact
tests for the specific types of tracing.

-- Steve


