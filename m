Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933128Ab0FQXQk (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Jun 2010 19:16:40 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:44290 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S933077Ab0FQXQi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Jun 2010 19:16:38 -0400
Date: Thu, 17 Jun 2010 16:15:39 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Tejun Heo <tj@kernel.org>
Cc: Daniel Walker <dwalker@codeaurora.org>, mingo@elte.hu, awalls@radix.net,
       linux-kernel@vger.kernel.org, jeff@garzik.org, rusty@rustcorp.com.au,
       cl@linux-foundation.org, dhowells@redhat.com, arjan@linux.intel.com,
       johannes@sipsolutions.net, oleg@redhat.com, axboe@kernel.dk
Subject: Re: Overview of concurrency managed workqueue
Message-Id: <20100617161539.d4ea62c0.akpm@linux-foundation.org>
In-Reply-To: <4C1901E9.2080907@kernel.org>
References: <1276551467-21246-1-git-send-email-tj@kernel.org>
	<4C17C598.7070303@kernel.org>
	<1276631037.6432.9.camel@c-dwalke-linux.qualcomm.com>
	<4C18BF40.40607@kernel.org>
	<1276694825.9309.12.camel@m0nster>
	<4C18D1FD.9060804@kernel.org>
	<1276695665.9309.17.camel@m0nster>
	<4C18D574.1040903@kernel.org>
	<1276697146.9309.27.camel@m0nster>
	<4C18DC69.10704@kernel.org>
	<1276698880.9309.44.camel@m0nster>
	<4C18E4B7.5040702@kernel.org>
	<1276701074.9309.60.camel@m0nster>
	<4C18F2B8.9060805@kernel.org>
	<1276705838.9309.94.camel@m0nster>
	<4C1901E9.2080907@kernel.org>
X-Mailer: Sylpheed 2.4.8 (GTK+ 2.12.9; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 16 Jun 2010 18:55:05 +0200
Tejun Heo <tj@kernel.org> wrote:

> It was about using wq for cpu intensive / RT stuff.  Linus said,
> 
>   So stop arguing about irrelevancies. Nobody uses workqueues for RT
>   or for CPU-intensive crap. It's not what they were designed for, or
>   used for.

kernel/padata.c uses workqueues for cpu-intensive work, as I understand
it.

I share Daniel's concerns here.  Being able to set a worker thread's
priority or policy isn't a crazy thing.  Also one might want to specify
that a work item be executed on one of a node's CPUs, or within a
cpuset's CPUs, maybe other stuff.  I have vague feelings that there's
already code in the kernel somewhere which does some of these things.

(Please remind me what your patches did about create_rt_workqueue and
stop_machine?)

(Please note that drivers/media/video/ivtv/ivtv-irq.c is currently
running sched_setscheduler() against a workqueue thread of its own
creation, so we have precedent).

If someone wants realtime service for a work item then at present, the
way to do that is to create your own kernel threads, set their policy
and start feeding them work items.  That sounds like a sensible
requirement and implementation to me.  But how does it translate into
the new implementation?

The priority/policy logically attaches to the work itself, not to the
thread which serves it.  So one would want to be able to provide that
info at queue_work()-time.  Could the workqueue core then find a thread,
set its policy/priority, schedule it and then let the CPU scheduler do
its usual thing with it?

That doesn't sound too bad?  Add policy/priority/etc fields to the
work_struct?
