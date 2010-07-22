Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755059Ab0GVGqx (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Jul 2010 02:46:53 -0400
Received: from gate.crashing.org ([63.228.1.57]:37056 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751370Ab0GVGqv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Jul 2010 02:46:51 -0400
Subject: Possible Oprofile crash/race when stopping
From: Benjamin Herrenschmidt <benh@kernel.crashing.org>
To: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Cc: Robert Richter <robert.richter@amd.com>, "Carl E. Love" <cel@us.ibm.com>,
        Michael Ellerman <michaele@au1.ibm.com>
Content-Type: text/plain; charset="UTF-8"
Date: Thu, 22 Jul 2010 15:14:40 +1000
Message-ID: <1279775680.1970.13.camel@pasglop>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi folks !

We've hit a strange crash internally, that we -think- we have tracked
down to an oprofile bug. It's hard to hit, so I can't guarantee yet that
we have fully smashed it but I'd like to share our findings in case you
guys have a better idea.

So the initial observation is a spinlock bad magic followed by a crash
in the spinlock debug code:

[ 1541.586531] BUG: spinlock bad magic on CPU#5, events/5/136
[ 1541.597564] Unable to handle kernel paging request for data at address 0x6b6b6b6b6b6b6d03

Backtrace looks like:

	spin_bug+0x74/0xd4
	._raw_spin_lock+0x48/0x184
	._spin_lock+0x10/0x24
	.get_task_mm+0x28/0x8c
	.sync_buffer+0x1b4/0x598
	.wq_sync_buffer+0xa0/0xdc
	.worker_thread+0x1d8/0x2a8
	.kthread+0xa8/0xb4
	.kernel_thread+0x54/0x70

So we are accessing a freed task struct in the work queue when
processing the samples.

Now that shouldn't happen since we should be handed off the dying tasks
via our task handoff notifier, and only free them after all the events
have been processed.

However I also observed using xmon that at the point of the crash, the
task_free_notifier structure had nothing attached to it.

Thus my tentative explanation:

When we stop oprofile, we call sync_stop() which I copied below:

void sync_stop(void)
{
	unregister_module_notifier(&module_load_nb);
	profile_event_unregister(PROFILE_MUNMAP, &munmap_nb);
	profile_event_unregister(PROFILE_TASK_EXIT, &task_exit_nb);
	task_handoff_unregister(&task_free_nb);
	end_sync();
	free_cpumask_var(marked_cpus);
}

You see the call to task_handoff_unregister(). This is when we take
ourselves off the list. So any task freed after that point will not be
retained by oprofile.

However, we have done nothing to clear the pending sample buffers yes.
So if we have a buffer with samples for a task, and that task gets
destroyed just after we have done the handoff, and before we have
cancelled the work queue, then we can potentially access a stale task
struct.

Now, end_sync() does that cancelling, as you see, -after- we removed the
handoff:

static void end_sync(void)
{
	end_cpu_work(); <--- This is where we stop the workqueues
	/* make sure we don't leak task structs */
	process_task_mortuary();
	process_task_mortuary();
}

I think the right sequence however requires breaking up end_sync. Ie, we
need to do in that order:

  - cancel the workqueues
  - unregister the notifier
  - process the mortuary

What do you think ?

Cheers,
Ben.


