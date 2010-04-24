Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758590Ab0DXA4N (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Apr 2010 20:56:13 -0400
Received: from mx1.redhat.com ([209.132.183.28]:61179 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756801Ab0DXA4L (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Apr 2010 20:56:11 -0400
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
From: Roland McGrath <roland@redhat.com>
To: Masami Hiramatsu <mhiramat@redhat.com>
X-Fcc: ~/Mail/linus
Cc: Andrew Morton <akpm@linux-foundation.org>,
       lkml <linux-kernel@vger.kernel.org>,
       systemtap <systemtap@sources.redhat.com>,
       DLE <dle-develop@lists.sourceforge.net>,
       Oleg Nesterov <oleg@redhat.com>, Jason Baron <jbaron@redhat.com>,
       Ingo Molnar <mingo@elte.hu>,
       KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Subject: Re: [PATCH -mm v6] tracepoint: Add signal coredump tracepoint
In-Reply-To: Masami Hiramatsu's message of  Wednesday, 21 April 2010 10:31:21 -0400 <4BCF0C39.1080907@redhat.com>
References: <20100412164830.514.85103.stgit@localhost6.localdomain6>
	<20100421001856.83743D10E@magilla.sf.frob.com>
	<4BCF0C39.1080907@redhat.com>
X-Zippy-Says: I'm encased in the lining of a pure pork sausage!!
Message-Id: <20100424001423.2AA831909E@magilla.sf.frob.com>
Date: Fri, 23 Apr 2010 17:14:23 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> > The "retval" encoding seems a bit arcane.  I wonder if it might be better
> > to just have separate tracepoints for successful and failed dump attempts.
> > Note that whether or not the dump succeeded is already available in
> > (task->signal->group_exit_code & 0x80) as seen at exit or death tracing
> > events.
> 
> OK, please read the previous discussion and tell me what you think about...

I don't have a strong opinion about this particular aspect.

> > The purposes you mention seem to be served well enough by this tracepoint.
> > But I recall having the impression that one of the original motivating
> > interests for tracing core-dump details was to understand when a giant core
> > dump was responsible for huge amounts of i/o and/or memory thrashing.
> > (Once you notice that happening, you might adjust coredump_filter settings
> > to reduce the problem.)  Your new tracepoint doesn't help directly with
> > tracking those sorts of issues, because it only happens after all the work
> > is done.  If you are monitoring trace_signal_deliver, then you can filter
> > those for SIG_DFL cases of sig_kernel_coredump() signals and recognize that
> > as the beginning of the coredump.  Still, it might be preferable to have
> > explicit start-core-dump and end-core-dump tracepoints.
> 
> No, that's not our interests. We are just interested in recording
> coredump parameters when the coredump is done. After dumping core
> (or failing to dump), we'd like to check what was wrong (wrong filter setting?),
> or correctly dumped (and removed after).
> 
> > Furthermore, I can see potential use for tracepoints before and after
> > coredump_wait(), which synchronizes other threads before actually starting
> > to calculate and write the dump.  The window after coredump_wait() and
> > before the post-dump tracepoint is where the actual work of writing the
> > core file takes place, in case you want to monitor i/o load between those
> > marks or suchlike.
> 
> Hmm, currently, we don't mention that.

I know that's not your interest now.  But I do recall someone somewhere at
some point asking about tracepoints in the context of observing unexpected
i/o and paging loads and tracking down that they were due to core dumping.
It's also certainly the case that there have been people spending time
diagnosing long delays due to coredump_wait() logic and/or actual deadlocks
due to bugs in the exit path interactions with coredump_wait().  Having
separate before-wait, after-wait, and after-dump tracepoints could well
make that sort of diagnosis trivial in the future, especially when doing
"flight recorder" style analysis.


Thanks,
Roland
