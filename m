Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754629Ab2AYJUV (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Jan 2012 04:20:21 -0500
Received: from mail-tul01m020-f174.google.com ([209.85.214.174]:45115 "EHLO
	mail-tul01m020-f174.google.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751104Ab2AYJUQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Jan 2012 04:20:16 -0500
Date: Wed, 25 Jan 2012 10:20:11 +0100
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Arun Sharma <asharma@fb.com>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>, linux-kernel@vger.kernel.org,
        Arnaldo Carvalho de Melo <acme@infradead.org>,
        Andrew Vagin <avagin@openvz.org>, Ingo Molnar <mingo@elte.hu>,
        Steven Rostedt <rostedt@goodmis.org>
Subject: Re: [PATCH] trace: reset sleep/block start time on task switch
Message-ID: <20120125092008.GB20878@somewhere>
References: <1327026020-32376-1-git-send-email-asharma@fb.com>
 <1327318449.2446.5.camel@twins>
 <4F1DA9D0.6090208@fb.com>
 <1327352631.2446.22.camel@twins>
 <4F1DE6FE.4000603@fb.com>
 <1327415255.2614.33.camel@laptop>
 <4F1F26CC.4040109@fb.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4F1F26CC.4040109@fb.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jan 24, 2012 at 01:46:52PM -0800, Arun Sharma wrote:
> On 1/24/12 6:27 AM, Peter Zijlstra wrote:
> 
> >Bah, you're right. Also yes your proposal is too intrusive, but that can
> >be fixed, I actually did, but then I noticed its broken too, it doesn't
> >matter if the schedule that schedules a task back in preempted another
> >task or not, what matters is if the task we're scheduling back in was
> >itself preempted or recently woken. And we simply don't know.
> 
> Yes - we'd need an extra bit in the task_struct to do this right.
> 
> >I'm tempted to revert 1ac9bc69 for now, userspace will simply have to
> >correlate trace_sched_switch() and trace_sched_stat_{sleep,blocked}(),
> >which shouldn't be too hard.
> 
> We tried it and it didn't work very well. Especially when used with
> perf record -g. There are too many uninteresting
> trace_sched_switch() events.

You mean context switches happening when the prev task doesn't need
to block or so? As it happens with preemption for example?

In this case you can use filters to drop context switches for
which the prev state is not S or D.

> 
> Other possibilites: make a copy of {sleep,block}_start somewhere
> else in the perf_events subsystem in the sleep/wakeup path and leave
> sched_statistics untouched.
> 
>  -Arun
> 
> 
