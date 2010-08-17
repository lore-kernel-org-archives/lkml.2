Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751472Ab0HQWYL (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Aug 2010 18:24:11 -0400
Received: from smtp-out.google.com ([216.239.44.51]:51157 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751182Ab0HQWYE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Aug 2010 18:24:04 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=date:from:x-x-sender:to:cc:subject:in-reply-to:message-id:
	references:user-agent:mime-version:content-type:x-system-of-record;
	b=kXuUlIQS56PWn7UedlHme++k66P+xrjtDQ/f/2ISCQHdEo4JOX2+meeqrfmYD4Scb
	Nn0JnamH6UScwlk4Mb4tw==
Date: Tue, 17 Aug 2010 15:23:56 -0700 (PDT)
From: Hugh Dickins <hughd@google.com>
X-X-Sender: hugh@sister.anvils
To: Tetsuo Handa <penguin-kernel@i-love.sakura.ne.jp>
cc: tim.c.chen@linux.intel.com, akpm@linux-foundation.org,
        torvalds@linux-foundation.org, viro@zeniv.linux.org.uk,
        linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org
Subject: Re: [2.6.36-rc1] List corruption when using initrd.
In-Reply-To: <201008170751.o7H7pmAl038739@www262.sakura.ne.jp>
Message-ID: <alpine.LSU.2.00.1008171523270.2106@sister.anvils>
References: <201008170517.o7H5HbCT002910@www262.sakura.ne.jp> <201008170751.o7H7pmAl038739@www262.sakura.ne.jp>
User-Agent: Alpine 2.00 (LSU 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 17 Aug 2010, Tetsuo Handa wrote:
> Tetsuo Handa wrote:
> > I get list_add corruption message when booting with initrd on Debian Sarge.
> 
> Bisection completed.
> 
> commit 7e496299d4d2ad8083effed6c5a18313a919edc6
> tmpfs: make tmpfs scalable with percpu_counter for used blocks

Thanks for reporting and bisecting.  Certainly there's a bug in shmem
(that we ought to have caught long before it reached 36-rc1: sorry),
and it is probably the cause of your crashes; but it's possible there's
a similar bug elsewhere too, something else messing up the percpu_counters
list - so please check if the patch below really does fix it for you.

I notice your dmesg also showed fs/inode.c:692 unlock_new_inode()
warnings from get_cramfs_inode(): those would be unrelated, and
probably from Al Viro's recent changes in cramfs/inode.c - Cc'ed.

Thanks,
Hugh


[PATCH] shmem: put_super must percpu_counter_destroy

list_add() corruption messages reported from shmem_fill_super()'s recently
introduced percpu_counter_init(): shmem_put_super() needs to remember to
percpu_counter_destroy().  And also check error from percpu_counter_init().

Reported-and-bisected-by: Tetsuo Handa <penguin-kernel@i-love.sakura.ne.jp>
Signed-off-by: Hugh Dickins <hughd@google.com>
---

 mm/shmem.c |    8 ++++++--
 1 file changed, 6 insertions(+), 2 deletions(-)

--- 2.6.36-rc1/mm/shmem.c	2010-08-16 00:18:01.000000000 -0700
+++ linux/mm/shmem.c	2010-08-17 14:42:56.000000000 -0700
@@ -2325,7 +2325,10 @@ static int shmem_show_options(struct seq
 
 static void shmem_put_super(struct super_block *sb)
 {
-	kfree(sb->s_fs_info);
+	struct shmem_sb_info *sbinfo = SHMEM_SB(sb);
+
+	percpu_counter_destroy(&sbinfo->used_blocks);
+	kfree(sbinfo);
 	sb->s_fs_info = NULL;
 }
 
@@ -2367,7 +2370,8 @@ int shmem_fill_super(struct super_block
 #endif
 
 	spin_lock_init(&sbinfo->stat_lock);
-	percpu_counter_init(&sbinfo->used_blocks, 0);
+	if (percpu_counter_init(&sbinfo->used_blocks, 0))
+		goto failed;
 	sbinfo->free_inodes = sbinfo->max_inodes;
 
 	sb->s_maxbytes = SHMEM_MAX_BYTES;
