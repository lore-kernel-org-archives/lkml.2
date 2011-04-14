Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757699Ab1DNQza (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Apr 2011 12:55:30 -0400
Received: from mail-bw0-f46.google.com ([209.85.214.46]:52976 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757305Ab1DNQzZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Apr 2011 12:55:25 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:from:to:cc:subject:date:message-id:x-mailer;
        b=doxppPQAaqPR4oQL6YZeXlFBlnIohfsXSxFRTOmBB8fbxCBYmyB5PK5tJ6WPc4370A
         sDkidkHve0yXLP9276O7fWjWfz1V7d7Ct68imILzgHAqdLPO8F6/g7w/OJs0bdj4ev7H
         S/rBUrPWCh+xux+Jr1Aonb3lhe2WDQHFOmDBE=
From: Vasiliy Kulikov <segoon@openwall.com>
To: linux-kernel@vger.kernel.org
Cc: security@kernel.org, David Airlie <airlied@linux.ie>
Subject: [PATCH] char: agp: fix OOM and buffer overflow
Date: Thu, 14 Apr 2011 20:55:19 +0400
Message-Id: <1302800120-31560-1-git-send-email-segoon@openwall.com>
X-Mailer: git-send-email 1.7.0.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

page_count is copied from userspace.  agp_allocate_memory() tries to
check whether this number is too big, but doesn't take into account the
wrap case.  Also agp_create_user_memory() doesn't check whether
alloc_size is calculated from num_agp_pages variable without overflow.
This may lead to allocation of too small buffer with following buffer
overflow.

Another problem in agp code is not addressed in the patch - kernel memory
exhaustion (AGPIOC_RESERVE and AGPIOC_ALLOCATE ioctls).  It is not checked
whether requested pid is a pid of the caller (no check in agpioc_reserve_wrap()).
Each allocation is limited to 16KB, though, there is no per-process limit.
This might lead to OOM situation, which is not even solved in case of the
caller death by OOM killer - the memory is allocated for another (faked) process.

Signed-off-by: Vasiliy Kulikov <segoon@openwall.com>
---
 drivers/char/agp/generic.c |    8 +++++++-
 1 files changed, 7 insertions(+), 1 deletions(-)

diff --git a/drivers/char/agp/generic.c b/drivers/char/agp/generic.c
index 745e7ba..342df51 100644
--- a/drivers/char/agp/generic.c
+++ b/drivers/char/agp/generic.c
@@ -115,6 +115,9 @@ static struct agp_memory *agp_create_user_memory(unsigned long num_agp_pages)
 	struct agp_memory *new;
 	unsigned long alloc_size = num_agp_pages*sizeof(struct page *);
 
+	if (INT_MAX/sizeof(struct page *) < num_agp_pages)
+		return NULL;
+
 	new = kzalloc(sizeof(struct agp_memory), GFP_KERNEL);
 	if (new == NULL)
 		return NULL;
@@ -234,11 +237,14 @@ struct agp_memory *agp_allocate_memory(struct agp_bridge_data *bridge,
 	int scratch_pages;
 	struct agp_memory *new;
 	size_t i;
+	int cur_memory;
 
 	if (!bridge)
 		return NULL;
 
-	if ((atomic_read(&bridge->current_memory_agp) + page_count) > bridge->max_memory_agp)
+	cur_memory = atomic_read(&bridge->current_memory_agp);
+	if ((cur_memory + page_count > bridge->max_memory_agp) ||
+	    (cur_memory + page_count < page_count))
 		return NULL;
 
 	if (type >= AGP_USER_TYPES) {
-- 
1.7.0.4

