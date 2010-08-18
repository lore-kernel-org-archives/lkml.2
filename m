Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751297Ab0HRDdM (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Aug 2010 23:33:12 -0400
Received: from smtp-out.google.com ([216.239.44.51]:46477 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750741Ab0HRDdB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Aug 2010 23:33:01 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=date:from:x-x-sender:to:cc:subject:in-reply-to:message-id:
	references:user-agent:mime-version:content-type:x-system-of-record;
	b=WD22PXmSjCCPfAaZUXMpqpYIGJU6Juh6KZ5YhOAuTklPGvwS8hdgi1IxMcteMai2n
	F46t2l6T06DnXmBH8p0xw==
Date: Tue, 17 Aug 2010 20:32:57 -0700 (PDT)
From: Hugh Dickins <hughd@google.com>
X-X-Sender: hugh@sister.anvils
To: Linus Torvalds <torvalds@linux-foundation.org>
cc: Tetsuo Handa <penguin-kernel@i-love.sakura.ne.jp>,
        tim.c.chen@linux.intel.com, akpm@linux-foundation.org,
        viro@zeniv.linux.org.uk, linux-kernel@vger.kernel.org,
        linux-fsdevel@vger.kernel.org
Subject: [PATCH] shmem: fix percpu_counters list corruption
In-Reply-To: <alpine.LSU.2.00.1008172022140.2868@sister.anvils>
Message-ID: <alpine.LSU.2.00.1008172030320.2933@sister.anvils>
References: <201008170517.o7H5HbCT002910@www262.sakura.ne.jp> <201008170751.o7H7pmAl038739@www262.sakura.ne.jp> <alpine.LSU.2.00.1008171523270.2106@sister.anvils> <201008180113.o7I1DXg6077317@www262.sakura.ne.jp>
 <alpine.LSU.2.00.1008172022140.2868@sister.anvils>
User-Agent: Alpine 2.00 (LSU 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

list_add() corruption messages reported from shmem_fill_super()'s recently
introduced percpu_counter_init(): shmem_put_super() needs to remember to
percpu_counter_destroy().  And also check error from percpu_counter_init().

Reported to fix oopses in __free_pipe_info() but I cannot work that out!

Reported-and-bisected-by: Tetsuo Handa <penguin-kernel@i-love.sakura.ne.jp>
Signed-off-by: Hugh Dickins <hughd@google.com>
Tested-by: Tetsuo Handa <penguin-kernel@i-love.sakura.ne.jp>
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
