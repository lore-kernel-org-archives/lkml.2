Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757064Ab3AIDeY (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Jan 2013 22:34:24 -0500
Received: from mail1.windriver.com ([147.11.146.13]:59009 "EHLO
	mail1.windriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756898Ab3AIDeX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Jan 2013 22:34:23 -0500
From: Fan Du <fan.du@windriver.com>
To: <matthew@wil.cx>
CC: <fan.du@windriver.com>, <linux-fsdevel@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>
Subject: [PATCH] fs: Disable preempt when acquire i_size_seqcount write lock
Date: Wed, 9 Jan 2013 11:34:19 +0800
Message-ID: <1357702459-2718-1-git-send-email-fan.du@windriver.com>
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

