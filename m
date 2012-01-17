Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752715Ab2AQJya (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Jan 2012 04:54:30 -0500
Received: from mx3.mail.elte.hu ([157.181.1.138]:56192 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751255Ab2AQJy2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Jan 2012 04:54:28 -0500
Date: Tue, 17 Jan 2012 10:54:18 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: LKML <linux-kernel@vger.kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Frederic Weisbecker <fweisbec@gmail.com>
Subject: Re: [PATCH][GIT PULL][v3.3] tracing: Add header wrappers
 event_headers_start.h and event_headers_end.h
Message-ID: <20120117095418.GG10397@elte.hu>
References: <1326754637.7642.177.camel@gandalf.stny.rr.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1326754637.7642.177.camel@gandalf.stny.rr.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-ELTE-SpamScore: -2.0
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-2.0 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.3.1
	-2.0 BAYES_00               BODY: Bayes spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Steven Rostedt <rostedt@goodmis.org> wrote:

> 
> Ingo,
> 
> This is actually a special pull request. This patch adds two new files
> that are not used by anyone. The rational for this is, they will be
> required for v3.4 and I want to make the transition in linux-next as
> smooth as possible. Let me explain the situation.
> 
> There has been more and more cases where trace/events/*.h headers have
> been showing up in normal header files. This is fine unless one of these
> normal header files ends up included in another trace/events/*.h file.
> What happens then, is when the CREATE_TRACE_POINTS is defined both
> headers get evaluated. This means the C functions to create the
> tracepoints are created for both the initial trace/events/*.h header, as
> well as the one that got included by the normal header file. This makes
> the build fail. We've already had to fix this up a few times to handle
> these cases.
> 
> I added two header files:
> 
>  include/trace/event_headers_start.h
>  include/trace/event_headers_end.h
> 
> These headers add some macro magic to handle the nested tracepoint event
> headers that was described above.
> 
> The way this works is that all tracepoint event headers must include
> these two headers around their other includes. For example trace/sched.h
> will now have:
> 
> #include <trace/event_headers_start.h>
> #include <linux/sched.h>
> #include <linux/tracepoint.h>
> #include <trace/event_headers_end.h>
> 
> I've already updated all the tracepoint headers inside the latest
> kernel. I searched all headers with "TRACE_EVENT" in them to catch
> headers outside of trace/events/ that define trace event headers.
> 
> The issue I see, and why I want this patch into 3.3 is that I have a
> warning that will print if someone adds a new tracepoint event header
> and doesn't add these files. If this warning goes into linux-next, and
> someone adds a new tracepoint event header, they will start getting this
> warning. The only way for them to stop it, is to include the above
> wrappers. The problem is, the wrappers will not exist in the kernel that
> gets pulled into linux-next, unless we push them now into 3.3.
> 
> Now if you feel this is too much and do not want to include files into
> 3.3 that are not being used, I can hold off the warning patch until 3.5,
> and then we may have a mixture of files with and without these header
> wrappers in 3.4.
> 
> What's your thoughts on this?

Hm, i don't really like the extra complexity - this code 
*really* does not need any more complexity ...

How about the low-tech solution of adding some text between
'/* */' markers to warns that these headers should not be 
included in ordinary headers?

The build error will pinpoint the bug anyway, it's not like the 
kernel can be broken in any dangerous way.

Thanks,

	Ingo
