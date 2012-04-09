Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756957Ab2DIKPP (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Apr 2012 06:15:15 -0400
Received: from mail-iy0-f174.google.com ([209.85.210.174]:62678 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755277Ab2DIKPM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Apr 2012 06:15:12 -0400
Date: Mon, 9 Apr 2012 03:15:08 -0700 (PDT)
From: David Rientjes <rientjes@google.com>
X-X-Sender: rientjes@chino.kir.corp.google.com
To: Linus Torvalds <torvalds@linux-foundation.org>
cc: Andrew Morton <akpm@linux-foundation.org>, werner <w.landgraf@ru.ru>,
        Rik van Riel <riel@redhat.com>, Hugh Dickins <hughd@google.com>,
        linux-kernel@vger.kernel.org, Oleg Nesterov <oleg@redhat.com>,
        Rabin Vincent <rabin.vincent@stericsson.com>,
        Christian Bejram <christian.bejram@stericsson.com>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Anton Vorontsov <anton.vorontsov@linaro.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org
Subject: Re: v3.4-rc2 out-of-memory problems (was Re: 3.4-rc1
 sticks-and-crashs)
In-Reply-To: <CA+55aFw7GsiZbNW84WVMUMT6C0Sw82jxaYxeaaB8qq=41Ep5Wg@mail.gmail.com>
Message-ID: <alpine.DEB.2.00.1204090235350.14879@chino.kir.corp.google.com>
References: <CA+55aFwTFXtMLhXo7g9F7uyHc3W8SCw7z1gTm9jbWXM3Nqc_ZA@mail.gmail.com> <20120408195044.13ea6c8e.akpm@linux-foundation.org> <CA+55aFw7GsiZbNW84WVMUMT6C0Sw82jxaYxeaaB8qq=41Ep5Wg@mail.gmail.com>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 8 Apr 2012, Linus Torvalds wrote:

> Or does anybody see anything that keeps thread counts raised so that
> "free_task()" doesn't get done. kernel/profoe.c does that
> "profile_handoff_task()" thing - but only oprofile and the android
> low-memory-killer logic seems to use it though. But that's exactly the
> kind of thing that Werner's "configure everything" might enable -
> Werner?
> 

I think you nailed it.

I suspect the problem is 1eda5166c764 ("staging: android/lowmemorykiller: 
Don't unregister notifier from atomic context") merged during the 3.4 
merge window and, unfortunately, backported to stable.

Werner's config has CONFIG_ANDROID_LOW_MEMORY_KILLER=y so we never 
actually unregister the callback for the task handoff as a result of the 
patch.  It's supposed to take responsibility for doing free_task() itself 
when it's good and ready, usually by putting it into a list to free, but 
now we're just doing this:

	struct task_struct *task = data;

	if (task == lowmem_deathpending)
		lowmem_deathpending = NULL;

	return NOTIFY_OK;

whenever put_task_struct() decrements the refcount to 0 and thus they get 
leaked and bad things happen.

This is confirmed by Werner's oom log that shows extremely small values 
for the oom score of the task chosen to oom kill.  His first log showed X 
being killed with a score of 29.  That means it is the most memory-hogging 
task on the system and is only using 2.9% of total system memory.

I can't actually see how the lowmemorykiller actually ever freed any 
task_struct after unregistering the notifier during the callback.  It 
seems like this has always leaked memory but it used to happen much more 
slowly because, prior to the patch, we did task_handoff_unregister() in 
the callback.  So I think the code was always wrong but now it's out of 
control because the notifier remains enabled indefinitely.  I can't say 
the 1eda5166c764 ("staging: android/lowmemorykiller: Don't unregister 
notifier from atomic context") commit is fully to blame, it just made the 
error much more egregious.

As it sits in 3.4-rc2, this whole lowmem_deathpending business seems to be 
storing a pointer to the task_struct of something sent a SIGKILL and it 
remains that way until the lowmem_deathpending_timeout expires and 
something else is killed instead.  lowmem_deathpending gets cleared on the 
task handoff if the task selected for kill just exited.  This ensures we 
only kill one thread at a time.

That's all fine and good but it seems like we're never freeing the 
task_struct itself on exit.  This seems like the most obvious fix but it 
would be really nice to revisit this and remove the dependency on 
CONFIG_PROFILING and just check if the lowmem_deathpending thread is found 
in the iteration for lowmem_shrink() prior to killing.


android, lowmemorykiller: free task struct on profiling handoff

The lowmemorykiller stores a pointer to a killed thread's task_struct in 
lowmem_deathpending when profiling is enabled.  When put_task_struct() 
results in the refcount going to 0, the task_notify_func() callback clears 
lowmem_deathpending if it is the thread that was killed last.  This 
prevents additional killing until lowmem_deathpending_timeout elapses.

The responsibility of every task handoff notifier is to free the tasks 
handed off to it, however, and this was being neglected, which results 
in a massive memory leak since no task_struct ever gets freed.

Fix that by freeing the task_struct since we no longer need a reference to 
it.

Reported-by: werner <w.landgraf@ru.ru>
Cc: stable@vger.kernel.org
Signed-off-by: David Rientjes <rientjes@google.com>
---
 drivers/staging/android/lowmemorykiller.c |    1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/staging/android/lowmemorykiller.c b/drivers/staging/android/lowmemorykiller.c
--- a/drivers/staging/android/lowmemorykiller.c
+++ b/drivers/staging/android/lowmemorykiller.c
@@ -78,6 +78,7 @@ task_notify_func(struct notifier_block *self, unsigned long val, void *data)
 
 	if (task == lowmem_deathpending)
 		lowmem_deathpending = NULL;
+	free_task(task);
 
 	return NOTIFY_OK;
 }
