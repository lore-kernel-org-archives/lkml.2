Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758388Ab0E1UaA (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 May 2010 16:30:00 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:53989 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756549Ab0E1U37 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 May 2010 16:29:59 -0400
Date: Fri, 28 May 2010 13:29:53 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Artem Bityutskiy <dedekind1@gmail.com>
Cc: Al Viro <viro@ZenIV.linux.org.uk>, LKML <linux-kernel@vger.kernel.org>,
       Jens Axboe <jens.axboe@oracle.com>, linux-fsdevel@vger.kernel.org
Subject: Re: [PATCHv4 17/17] writeback: lessen sync_supers wakeup count
Message-Id: <20100528132953.7af88c08.akpm@linux-foundation.org>
In-Reply-To: <1274795352-3551-18-git-send-email-dedekind1@gmail.com>
References: <1274795352-3551-1-git-send-email-dedekind1@gmail.com>
	<1274795352-3551-18-git-send-email-dedekind1@gmail.com>
X-Mailer: Sylpheed 2.4.8 (GTK+ 2.12.9; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 25 May 2010 16:49:12 +0300
Artem Bityutskiy <dedekind1@gmail.com> wrote:

> From: Artem Bityutskiy <Artem.Bityutskiy@nokia.com>
> 
> The 'sync_supers' thread wakes up every 5 seconds (by default) and
> writes back all super blocks. It keeps waking up even if there
> are no dirty super-blocks. For many file-systems the superblock
> becomes dirty very rarely, if ever, so 'sync_supers' does not do
> anything most of the time.
> 
> This patch improves 'sync_supers' and makes sleep if all superblocks
> are clean and there is nothing to do. This helps saving the power.
> This optimization is important for small battery-powered devices.
> 
> Signed-off-by: Artem Bityutskiy <Artem.Bityutskiy@nokia.com>
> ---
>  include/linux/fs.h |    5 +----
>  mm/backing-dev.c   |   36 +++++++++++++++++++++++++++++++++++-
>  2 files changed, 36 insertions(+), 5 deletions(-)
> 
> diff --git a/include/linux/fs.h b/include/linux/fs.h
> index c2ddeee..2d2560b 100644
> --- a/include/linux/fs.h
> +++ b/include/linux/fs.h
> @@ -1786,10 +1786,7 @@ extern void simple_set_mnt(struct vfsmount *mnt, struct super_block *sb);
>   * Note, VFS does not provide any serialization for the super block clean/dirty
>   * state changes, file-systems should take care of this.
>   */
> -static inline void mark_sb_dirty(struct super_block *sb)
> -{
> -	sb->s_dirty = 1;
> -}
> +void mark_sb_dirty(struct super_block *sb);
>  static inline void mark_sb_clean(struct super_block *sb)
>  {
>  	sb->s_dirty = 0;
> diff --git a/mm/backing-dev.c b/mm/backing-dev.c
> index 660a87a..14f3eb7 100644
> --- a/mm/backing-dev.c
> +++ b/mm/backing-dev.c
> @@ -45,6 +45,8 @@ LIST_HEAD(bdi_pending_list);
>  
>  static struct task_struct *sync_supers_tsk;
>  static struct timer_list sync_supers_timer;
> +static int supers_timer_armed;

This thing's a bit ugly.

> +static DEFINE_SPINLOCK(supers_timer_lock);
>  
>  static int bdi_sync_supers(void *);
>  static void sync_supers_timer_fn(unsigned long);
> @@ -355,6 +357,11 @@ static void bdi_flush_io(struct backing_dev_info *bdi)
>   * or we risk deadlocking on ->s_umount. The longer term solution would be
>   * to implement sync_supers_bdi() or similar and simply do it from the
>   * bdi writeback tasks individually.
> + *
> + * Historically this thread woke up periodically, regardless of whether
> + * there was any dirty superblock. However, nowadays it is optimized to
> + * wake up only when there is something to synchronize - this helps to save
> + * power.
>   */
>  static int bdi_sync_supers(void *unused)
>  {
> @@ -364,10 +371,24 @@ static int bdi_sync_supers(void *unused)
>  		set_current_state(TASK_INTERRUPTIBLE);
>  		schedule();
>  
> +		spin_lock(&supers_timer_lock);
> +		/* Indicate that 'sync_supers' is in progress */
> +		supers_timer_armed = -1;
> +		spin_unlock(&supers_timer_lock);
> +
>  		/*
>  		 * Do this periodically, like kupdated() did before.
>  		 */
>  		sync_supers();
> +
> +		spin_lock(&supers_timer_lock);
> +		if (supers_timer_armed == 1)
> +			/* A super block was marked as dirty meanwhile */
> +			bdi_arm_supers_timer();
> +		else
> +			/* No more dirty superblocks - we've synced'em all */
> +			supers_timer_armed = 0;
> +		spin_unlock(&supers_timer_lock);
>  	}

I suspect the spinlock could be removed if you switched to bitops:
test_and_set_bit(0, supers_timer_armed);

Ahother possibility is to nuke supers_timer_armed() and use
timer_pending(), mod_timer(), etc directly.


>  	return 0;
> @@ -387,9 +408,22 @@ void bdi_arm_supers_timer(void)
>  static void sync_supers_timer_fn(unsigned long unused)
>  {
>  	wake_up_process(sync_supers_tsk);
> -	bdi_arm_supers_timer();
>  }
>  
> +void mark_sb_dirty(struct super_block *sb)
> +{
> +	sb->s_dirty = 1;
> +
> +	spin_lock(&supers_timer_lock);
> +	if (!supers_timer_armed) {
> +		bdi_arm_supers_timer();
> +		supers_timer_armed = 1;
> +	} else if (supers_timer_armed == -1)
> +		supers_timer_armed = 1;
> +	spin_unlock(&supers_timer_lock);
> +}
> +EXPORT_SYMBOL(mark_sb_dirty);

This looks inefficient.  Could we not do

void mark_sb_dirty(struct super_block *sb)
{
	sb->s_dirty = 1;

	if (!supers_timer_armed) {
		spin_lock(&supers_timer_lock);
		if (!supers_timer_armed) {
			bdi_arm_supers_timer();
			supers_timer_armed = 1;
		}
	} else if (supers_timer_armed == -1)
		spin_lock(&supers_timer_lock);
		if (supers_timer_armed == -1)
			supers_timer_armed = 1;
		spin_unlock(&supers_timer_lock);
	}
}

I didn't try very hard there, but you get the idea: examine the state
before taking that expensive global spinlock, so we only end up taking
the lock once per five seconds, rather than once per possible
superblock dirtying.  That's like a six-orders-of-magnitude reduction
in locking frequency, which is worth putting some effort into.

