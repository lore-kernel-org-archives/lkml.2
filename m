Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932222Ab0E0PXZ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 May 2010 11:23:25 -0400
Received: from smtp.nokia.com ([192.100.122.233]:42557 "EHLO
	mgw-mx06.nokia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755034Ab0E0PXX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 May 2010 11:23:23 -0400
Subject: Re: [PATCHv4 17/17] writeback: lessen sync_supers wakeup count
From: Artem Bityutskiy <dedekind1@gmail.com>
Reply-To: dedekind1@gmail.com
To: Nick Piggin <npiggin@suse.de>
Cc: Al Viro <viro@ZenIV.linux.org.uk>, LKML <linux-kernel@vger.kernel.org>,
       Jens Axboe <jens.axboe@oracle.com>, linux-fsdevel@vger.kernel.org
In-Reply-To: <20100527120737.GN22536@laptop>
References: <1274795352-3551-1-git-send-email-dedekind1@gmail.com>
	 <1274795352-3551-18-git-send-email-dedekind1@gmail.com>
	 <20100527065041.GA31073@ZenIV.linux.org.uk> <20100527072240.GM22536@laptop>
	 <1274957469.13159.20.camel@localhost>  <20100527120737.GN22536@laptop>
Content-Type: text/plain; charset="UTF-8"
Date: Thu, 27 May 2010 18:21:33 +0300
Message-ID: <1274973693.15516.67.camel@localhost>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 (2.28.3-1.fc12) 
Content-Transfer-Encoding: 8bit
X-OriginalArrivalTime: 27 May 2010 15:23:05.0310 (UTC) FILETIME=[80F51FE0:01CAFDB0]
X-Nokia-AV: Clean
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2010-05-27 at 22:07 +1000, Nick Piggin wrote:
> 1. sb->s_dirty = 1; /* store */
> 2. if (!supers_timer_armed) /* load */
> 3.   supers_timer_armed = 1; /* store */
> 
> and
> 
> A. supers_timer_armed = 0; /* store */
> B. if (sb->s_dirty) /* load */
> C.   sb->s_dirty = 0 /* store */
> 
> If these two sequences are executed, it must result in
> sb->s_dirty == 1 iff supers_timer_armed
> 
> * If 2 is executed before 1 is visible, then 2 may miss A before B sees 1.
> * If B is executed before A is visible, then B may miss 1 before 2 sees A.
> 
> So we need smp_mb() between 1/2 and A/B (I missed the 2nd one).

Yes, thanks for elaboration.

> How about something like this?

It looks good, many thanks! But I have few small notes.

> Index: linux-2.6/mm/backing-dev.c
> ===================================================================
> --- linux-2.6.orig/mm/backing-dev.c
> +++ linux-2.6/mm/backing-dev.c
> @@ -45,6 +45,7 @@ LIST_HEAD(bdi_pending_list);
>  
>  static struct task_struct *sync_supers_tsk;
>  static struct timer_list sync_supers_timer;
> +static unsigned long supers_dirty __read_mostly;
>  
>  static int bdi_sync_supers(void *);
>  static void sync_supers_timer_fn(unsigned long);
> @@ -251,7 +252,6 @@ static int __init default_bdi_init(void)
>  
>  	init_timer(&sync_supers_timer);
>  	setup_timer(&sync_supers_timer, sync_supers_timer_fn, 0);
> -	bdi_arm_supers_timer();
>  
>  	err = bdi_init(&default_backing_dev_info);
>  	if (!err)
> @@ -362,17 +362,28 @@ static int bdi_sync_supers(void *unused)
>  
>  	while (!kthread_should_stop()) {
>  		set_current_state(TASK_INTERRUPTIBLE);
> -		schedule();
> +		if (!supers_dirty)
> +			schedule();
> +		else
> +			__set_current_state(TASK_RUNNING);

I think this will change the behavior of 'sync_supers()' too much. ATM,
it makes only one SB pass, then sleeps, then another one, then sleeps.
And we should probably preserve this behavior. So I'd rather make it:

if (supers_dirty)
	bdi_arm_supers_timer();
set_current_state(TASK_INTERRUPTIBLE);
schedule();

This way we will keep the behavior closer to the original.

> +		supers_dirty = 0;
>  		/*
> -		 * Do this periodically, like kupdated() did before.
> +		 * supers_dirty store must be visible to mark_sb_dirty (below)
> +		 * before sync_supers runs (which loads sb->s_dirty).
>  		 */

Very minor, but the code tends to change quickly, and this note (below)
will probably become out-of-date soon.

> +		smp_mb();

There is spin_lock(&sb_lock) in sync_supers(), so strictly speak this
'smp_mb()' is not needed if we move supers_dirty = 0 into
'sync_supers()' and add a comment that a mb is required, in case some
one modifies the code later?

Or this is not worth it?

>  		sync_supers();
>  	}
>  
>  	return 0;
>  }
>  
> +static void sync_supers_timer_fn(unsigned long unused)
> +{
> +	wake_up_process(sync_supers_tsk);
> +}
> +
>  void bdi_arm_supers_timer(void)
>  {
>  	unsigned long next;
> @@ -384,9 +395,17 @@ void bdi_arm_supers_timer(void)
>  	mod_timer(&sync_supers_timer, round_jiffies_up(next));
>  }
>  
> -static void sync_supers_timer_fn(unsigned long unused)
> +void mark_sb_dirty(struct super_block *sb)
>  {
> -	wake_up_process(sync_supers_tsk);
> +	sb->s_dirty = 1;
> +	/*
> +	 * sb->s_dirty store must be visible to sync_supers (above) before we
> +	 * load supers_dirty in case we need to re-arm the timer.
> +	 */
Similar for the "(above)" note.

> +	smp_mb();
> +	if (likely(supers_dirty))
> +		return;
> +	supers_dirty = 1;
>  	bdi_arm_supers_timer();
>  }

Here is the with my modifications. 

BTW, do you want me to keep you to be the patch author, add your
signed-off-by and my original commit message?

---
 fs/super.c       |    7 +++++++
 mm/backing-dev.c |   21 ++++++++++++++++++---
 2 files changed, 25 insertions(+), 3 deletions(-)

diff --git a/fs/super.c b/fs/super.c
index 2b418fb..c9ff6e2 100644
--- a/fs/super.c
+++ b/fs/super.c
@@ -364,6 +364,13 @@ void sync_supers(void)
 {
 	struct super_block *sb, *n;
 
+	supers_dirty = 0;
+	/* smp_mb();
+	 *
+	 * supers_dirty store must be visible to mark_sb_dirty before
+	 * sync_supers runs (which loads sb->s_dirty), so a barrier is needed
+	 * but there is a spin_lock, thus smp_mb is commented out.
+	 */
 	spin_lock(&sb_lock);
 	list_for_each_entry_safe(sb, n, &super_blocks, s_list) {
 		if (list_empty(&sb->s_instances))
diff --git a/mm/backing-dev.c b/mm/backing-dev.c
index 660a87a..be7f734 100644
--- a/mm/backing-dev.c
+++ b/mm/backing-dev.c
@@ -45,6 +45,7 @@ LIST_HEAD(bdi_pending_list);
 
 static struct task_struct *sync_supers_tsk;
 static struct timer_list sync_supers_timer;
+static unsigned long supers_dirty __read_mostly;
 
 static int bdi_sync_supers(void *);
 static void sync_supers_timer_fn(unsigned long);
@@ -251,7 +252,6 @@ static int __init default_bdi_init(void)
 
 	init_timer(&sync_supers_timer);
 	setup_timer(&sync_supers_timer, sync_supers_timer_fn, 0);
-	bdi_arm_supers_timer();
 
 	err = bdi_init(&default_backing_dev_info);
 	if (!err)
@@ -361,6 +361,8 @@ static int bdi_sync_supers(void *unused)
 	set_user_nice(current, 0);
 
 	while (!kthread_should_stop()) {
+		if (supers_dirty)
+			bdi_arm_supers_timer();
 		set_current_state(TASK_INTERRUPTIBLE);
 		schedule();
 
@@ -373,6 +375,11 @@ static int bdi_sync_supers(void *unused)
 	return 0;
 }
 
+static void sync_supers_timer_fn(unsigned long unused)
+{
+	wake_up_process(sync_supers_tsk);
+}
+
 void bdi_arm_supers_timer(void)
 {
 	unsigned long next;
@@ -384,9 +391,17 @@ void bdi_arm_supers_timer(void)
 	mod_timer(&sync_supers_timer, round_jiffies_up(next));
 }
 
-static void sync_supers_timer_fn(unsigned long unused)
+void mark_sb_dirty(struct super_block *sb)
 {
-	wake_up_process(sync_supers_tsk);
+	sb->s_dirty = 1;
+	/*
+	 * sb->s_dirty store must be visible to sync_supers before we load
+	 * supers_dirty in case we need to re-arm the timer.
+	 */
+	smp_mb();
+	if (likely(supers_dirty))
+		return;
+	supers_dirty = 1;
 	bdi_arm_supers_timer();
 }
 
-- 

-- 
Best Regards,
Artem Bityutskiy (Артём Битюцкий)

