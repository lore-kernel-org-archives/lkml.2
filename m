Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757219Ab0DRRIC (ORCPT <rfc822;w@1wt.eu>);
	Sun, 18 Apr 2010 13:08:02 -0400
Received: from fg-out-1718.google.com ([72.14.220.158]:38879 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756216Ab0DRRH4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 18 Apr 2010 13:07:56 -0400
From: Manfred Spraul <manfred@colorfullife.com>
To: LKML <linux-kernel@vger.kernel.org>
Cc: Chris Mason <chris.mason@oracle.com>, Zach Brown <zach.brown@oracle.com>,
       Jens Axboe <jens.axboe@oracle.com>, Nick Piggin <npiggin@suse.de>,
       Manfred Spraul <manfred@colorfullife.com>
Subject: [PATCH 3/3] [PATCH] ipc/sem.c: cacheline align the ipc spinlock for semaphores
Date: Sun, 18 Apr 2010 19:07:17 +0200
Message-Id: <1271610437-2312-4-git-send-email-manfred@colorfullife.com>
X-Mailer: git-send-email 1.6.6.1
In-Reply-To: <1271610437-2312-3-git-send-email-manfred@colorfullife.com>
References: <1271610437-2312-1-git-send-email-manfred@colorfullife.com>
 <1271610437-2312-2-git-send-email-manfred@colorfullife.com>
 <1271610437-2312-3-git-send-email-manfred@colorfullife.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch cacheline aligns the spinlock for sysv semaphores:
Without the patch, the spinlock and sem_otime [written by
every semop that modified the array] and sem_base [read in the
hot path of try_atomic_semop()] can be in the same cacheline.
---
 include/linux/sem.h |    4 +++-
 1 files changed, 3 insertions(+), 1 deletions(-)

diff --git a/include/linux/sem.h b/include/linux/sem.h
index 8a4adbe..f2961af 100644
--- a/include/linux/sem.h
+++ b/include/linux/sem.h
@@ -79,6 +79,7 @@ struct  seminfo {
 #ifdef __KERNEL__
 #include <asm/atomic.h>
 #include <linux/rcupdate.h>
+#include <linux/cache.h>
 
 struct task_struct;
 
@@ -91,7 +92,8 @@ struct sem {
 
 /* One sem_array data structure for each set of semaphores in the system. */
 struct sem_array {
-	struct kern_ipc_perm	sem_perm;	/* permissions .. see ipc.h */
+	struct kern_ipc_perm	____cacheline_aligned_in_smp
+				sem_perm;	/* permissions .. see ipc.h */
 	time_t			sem_otime;	/* last semop time */
 	time_t			sem_ctime;	/* last change time */
 	struct sem		*sem_base;	/* ptr to first semaphore in array */
-- 
1.6.6.1

