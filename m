Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754195Ab0DUA4b (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Apr 2010 20:56:31 -0400
Received: from mx1.redhat.com ([209.132.183.28]:39330 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753478Ab0DUA4a (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Apr 2010 20:56:30 -0400
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
In-Reply-To: Masami Hiramatsu's message of  Monday, 12 April 2010 12:48:30 -0400 <20100412164830.514.85103.stgit@localhost6.localdomain6>
References: <20100412164830.514.85103.stgit@localhost6.localdomain6>
X-Shopping-List: (1) Cheesy cow effluents
   (2) Mechanical Olympic snoozeers
   (3) Slanderous log ingredients
   (4) Diffident watch pajamas
   (5) Multitudinous picnics
Message-Id: <20100421001856.83743D10E@magilla.sf.frob.com>
Date: Tue, 20 Apr 2010 17:18:56 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> Add signal coredump tracepoint which shows signal number,
> mm->flags, core file size limitation, the result of
> coredump, and core file name.

The "retval" encoding seems a bit arcane.  I wonder if it might be better
to just have separate tracepoints for successful and failed dump attempts.
Note that whether or not the dump succeeded is already available in
(task->signal->group_exit_code & 0x80) as seen at exit or death tracing
events.

> This tracepoint requirement comes mainly from the viewpoint of
> administrators. [...]

The purposes you mention seem to be served well enough by this tracepoint.
But I recall having the impression that one of the original motivating
interests for tracing core-dump details was to understand when a giant core
dump was responsible for huge amounts of i/o and/or memory thrashing.
(Once you notice that happening, you might adjust coredump_filter settings
to reduce the problem.)  Your new tracepoint doesn't help directly with
tracking those sorts of issues, because it only happens after all the work
is done.  If you are monitoring trace_signal_deliver, then you can filter
those for SIG_DFL cases of sig_kernel_coredump() signals and recognize that
as the beginning of the coredump.  Still, it might be preferable to have
explicit start-core-dump and end-core-dump tracepoints.

Furthermore, I can see potential use for tracepoints before and after
coredump_wait(), which synchronizes other threads before actually starting
to calculate and write the dump.  The window after coredump_wait() and
before the post-dump tracepoint is where the actual work of writing the
core file takes place, in case you want to monitor i/o load between those
marks or suchlike.

> -	char corename[CORENAME_MAX_SIZE + 1];
> +	char corename[CORENAME_MAX_SIZE + 1] = "";

This initialization of a stack array means the same as:

	memset(corename, '\0', sizeof corename);

So the compiler generates that because those are the semantics.
All you need is:

	corename[0] = '\0';

since this is a string.


Thanks,
Roland
