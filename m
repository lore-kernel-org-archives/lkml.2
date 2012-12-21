Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751567Ab2LUIlT (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Dec 2012 03:41:19 -0500
Received: from mail.windriver.com ([147.11.1.11]:37133 "EHLO
	mail.windriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751091Ab2LUIlP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Dec 2012 03:41:15 -0500
From: Fan Du <fan.du@windriver.com>
To: <fan.du@windriver.com>
CC: <linux-fsdevel@vger.kernel.org>, <linux-kernel@vger.kernel.org>
Subject: [PATCH] Disable preempt when acquire i_size_seqcount write lock
Date: Fri, 21 Dec 2012 16:41:13 +0800
Message-ID: <1356079273-10796-1-git-send-email-fan.du@windriver.com>
X-Mailer: git-send-email 1.7.0.5
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Two rt tasks bind to one CPU core.

The higher priority rt task A preempts a lower priority rt task B which
has already taken the write seq lock, and then the higher priority
rt task A try to acquire read seq lock, it's doomed to lockup.

rt task A with lower priority: call write
i_size_write                                        rt task B with higher priority: call sync, and preempt task A
  write_seqcount_begin(&inode->i_size_seqcount);    i_size_read  
  inode->i_size = i_size;                             read_seqcount_begin <-- lockup here... 


So disable preempt when acquiring every i_size_seqcount *write* lock will
cure the problem.

Signed-off-by: Fan Du <fan.du@windriver.com>
---
 include/linux/fs.h |    2 ++
 1 files changed, 2 insertions(+), 0 deletions(-)

diff --git a/include/linux/fs.h b/include/linux/fs.h
index db84f77..1b69e87 100644
--- a/include/linux/fs.h
+++ b/include/linux/fs.h
@@ -758,9 +758,11 @@ static inline loff_t i_size_read(const struct inode *inode)
 static inline void i_size_write(struct inode *inode, loff_t i_size)
 {
 #if BITS_PER_LONG==32 && defined(CONFIG_SMP)
+	preempt_disable();
 	write_seqcount_begin(&inode->i_size_seqcount);
 	inode->i_size = i_size;
 	write_seqcount_end(&inode->i_size_seqcount);
+	preempt_enable();
 #elif BITS_PER_LONG==32 && defined(CONFIG_PREEMPT)
 	preempt_disable();
 	inode->i_size = i_size;
-- 
1.7.0.5

