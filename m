Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756712Ab0D1TGn (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Apr 2010 15:06:43 -0400
Received: from fg-out-1718.google.com ([72.14.220.153]:60231 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756643Ab0D1TGk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Apr 2010 15:06:40 -0400
From: Manfred Spraul <manfred@colorfullife.com>
To: LKML <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>
Cc: Chris Mason <chris.mason@oracle.com>, Zach Brown <zach.brown@oracle.com>,
       Jens Axboe <jens.axboe@oracle.com>, Nick Piggin <npiggin@suse.de>,
       Manfred Spraul <manfred@colorfullife.com>
Subject: [PATCH 3/3] [PATCH] ipc/sem.c: cacheline align the ipc spinlock for semaphores
Date: Wed, 28 Apr 2010 21:06:28 +0200
Message-Id: <1272481588-1941-4-git-send-email-manfred@colorfullife.com>
X-Mailer: git-send-email 1.6.6.1
In-Reply-To: <1272481588-1941-3-git-send-email-manfred@colorfullife.com>
References: <1272481588-1941-1-git-send-email-manfred@colorfullife.com>
 <1272481588-1941-2-git-send-email-manfred@colorfullife.com>
 <1272481588-1941-3-git-send-email-manfred@colorfullife.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch cacheline aligns the spinlock for sysv semaphores:
Without the patch, the spinlock and sem_otime [written by
every semop that modified the array] and sem_base [read in the
hot path of try_atomic_semop()] can be in the same cacheline.

Signed-off-by: Manfred Spraul <manfred@colorfullife.com>
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

