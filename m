Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756747Ab1FFRke (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Jun 2011 13:40:34 -0400
Received: from merlin.infradead.org ([205.233.59.134]:56626 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754511Ab1FFRkd convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Jun 2011 13:40:33 -0400
Subject: Re: [PATCH] perf, core: Fix initial task_ctx/event installation
From: Peter Zijlstra <peterz@infradead.org>
To: Jiri Olsa <jolsa@redhat.com>
Cc: paulus@samba.org, mingo@elte.hu, linux-kernel@vger.kernel.org,
        oleg@redhat.com
In-Reply-To: <1307371095-10141-1-git-send-email-jolsa@redhat.com>
References: <1307371095-10141-1-git-send-email-jolsa@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
Date: Mon, 06 Jun 2011 19:40:26 +0200
Message-ID: <1307382026.2322.226.camel@twins>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

It helps if you actually use the right email address for me ;-)

On Mon, 2011-06-06 at 16:38 +0200, Jiri Olsa wrote:
> hi,
> 
> I think I found a bug in the __perf_install_in_context. The attached
> patch fixies the problem for me, but I'm not sure it did not break
> anything else.. ;)
> 
> thanks,
> jirka
> 
> ---
> The __perf_install_in_context function does not install context
> events in case there's no active task context.
> 
> This might cause incorrect counts if application opens counter
> in its own task context. 
> 
> Following scenario leads to wrong counts:
> (this is the case for "perf test - test__open_syscall_event
> which counts sys_enter_open calls)
> 
> 1  - application is scheduled in
> 2  - application enters perf_event_open syscall with its own pid
> 3  - event/context is created
> 4  - __perf_install_in_context is called
> 5  - cpuctx->task_ctx is NULL
> 6  - perf_event_sched_in gets called with ctx == NULL, new event is not scheduled in
> 7  - application leaves the perf_event_open syscall
> 8  - application running code leading to increment the event counter
>      !!! this is where we lost the counts, since the event is not scheduled in !!!
> 9  - application is scheduled out
> 11 - application is scheduled in
> 12 - event is properly sceduled in
> 13 - event counter is now incremented
> 
> If the task is scheduled out and back in after the context is installed,
> but before it exits the perf_event_open syscall, the task_ctx gets
> properly set and event is properly scheduled in. In this case
> the perf test returns proper counts.
> 
> Attached patch changed this behaviour to install new task_ctx
> even if the current task_ctx is NULL.
> 
> Tested by succesfully running perf test command.

Right, so I have those bits as per https://lkml.org/lkml/2011/4/10/17,
they got lost in the commit due to a quilt refresh boo-boo.

With these bits it works on my dual core, but I still get lockups on my
24-cpu wsm machine.

