Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756149Ab2FUTmA (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Jun 2012 15:42:00 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:34882 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755291Ab2FUTl7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Jun 2012 15:41:59 -0400
Date: Thu, 21 Jun 2012 12:41:58 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Artem Bityutskiy <dedekind1@gmail.com>
Cc: Al Viro <viro@ZenIV.linux.org.uk>,
        Linux FS Maling List <linux-fsdevel@vger.kernel.org>,
        Linux Kernel Maling List <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 4/4] hfsplus: get rid of write_super
Message-Id: <20120621124158.a7559ee3.akpm@linux-foundation.org>
In-Reply-To: <1339587471-2713-5-git-send-email-dedekind1@gmail.com>
References: <1339587471-2713-1-git-send-email-dedekind1@gmail.com>
	<1339587471-2713-5-git-send-email-dedekind1@gmail.com>
X-Mailer: Sylpheed 3.0.2 (GTK+ 2.20.1; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 13 Jun 2012 14:37:51 +0300
Artem Bityutskiy <dedekind1@gmail.com> wrote:

> From: Artem Bityutskiy <artem.bityutskiy@linux.intel.com>
> 
> This patch makes hfsplus stop using the VFS '->write_super()' method along with
> the 's_dirt' superblock flag, because they are on their way out.
> 
> The whole "superblock write-out" VFS infrastructure is served by the
> 'sync_supers()' kernel thread, which wakes up every 5 (by default) seconds and
> writes out all dirty superblocks using the '->write_super()' call-back.  But the
> problem with this thread is that it wastes power by waking up the system every
> 5 seconds, even if there are no diry superblocks, or there are no client
> file-systems which would need this (e.g., btrfs does not use
> '->write_super()'). So we want to kill it completely and thus, we need to make
> file-systems to stop using the '->write_super()' VFS service, and then remove
> it together with the kernel thread.
> 
> Tested using fsstress from the LTP project.
> 
>
> ...
>
> --- a/fs/hfsplus/hfsplus_fs.h
> +++ b/fs/hfsplus/hfsplus_fs.h
> @@ -153,8 +153,11 @@ struct hfsplus_sb_info {
>  	gid_t gid;
>  
>  	int part, session;
> -
>  	unsigned long flags;
> +
> +	int work_queued;               /* non-zero delayed work is queued */

This would be a little nicer if it had the bool type.

> +	struct delayed_work sync_work; /* FS sync delayed work */
> +	spinlock_t work_lock;          /* protects sync_work and work_queued */

I'm not sure that this lock really needs to exist.

> -static void hfsplus_write_super(struct super_block *sb)
> +static void delayed_sync_fs(struct work_struct *work)
>  {
> -	if (!(sb->s_flags & MS_RDONLY))
> -		hfsplus_sync_fs(sb, 1);
> -	else
> -		sb->s_dirt = 0;
> +	struct hfsplus_sb_info *sbi;
> +
> +	sbi = container_of(work, struct hfsplus_sb_info, sync_work.work);
> +
> +	spin_lock(&sbi->work_lock);
> +	sbi->work_queued = 0;
> +	spin_unlock(&sbi->work_lock);

Here it is "protecting" a single write.

> +	hfsplus_sync_fs(sbi->alloc_file->i_sb, 1);
> +}
> +
> +void hfsplus_mark_mdb_dirty(struct super_block *sb)
> +{
> +	struct hfsplus_sb_info *sbi = HFSPLUS_SB(sb);
> +	unsigned long delay;
> +
> +	if (sb->s_flags & MS_RDONLY)
> +	       return;
> +
> +	spin_lock(&sbi->work_lock);
> +	if (!sbi->work_queued) {
> +	       delay = msecs_to_jiffies(dirty_writeback_interval * 10);
> +	       queue_delayed_work(system_long_wq, &sbi->sync_work, delay);
> +	       sbi->work_queued = 1;
> +	}
> +	spin_unlock(&sbi->work_lock);
>  }

And I think it could be made to go away here, perhaps by switching to
test_and_set_bit or similar.


And I wonder about the queue_delayed_work().  iirc this does nothing to
align timer expiries, so someone who has a lot of filesystems could end
up with *more* timer wakeups.  Shouldn't we do something here to make
the system do larger amounts of work per timer expiry?  Such as the
timer-slack infrastructure?


It strikes me that this whole approach improves the small system with
little write activity, but makes things worse for the larger system
with a lot of filesystems?

