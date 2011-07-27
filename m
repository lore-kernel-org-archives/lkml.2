Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754307Ab1G0Alp (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Jul 2011 20:41:45 -0400
Received: from mga09.intel.com ([134.134.136.24]:52724 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753421Ab1G0Ae6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Jul 2011 20:34:58 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.67,272,1309762800"; 
   d="scan'208";a="32380205"
From: Andi Kleen <andi@firstfloor.org>
References: <20110726534.972201586@firstfloor.org>
In-Reply-To: <20110726534.972201586@firstfloor.org>
To: segoon@openwall.com, airlied@redhat.com, ak@linux.intel.com,
        linux-kernel@vger.kernel.org, stable@kernel.org, tim.bird@am.sony.com,
        linux-kernel@vger.kernel.org, stable@vger.kernel.org
Subject: [PATCH] [6/98] agp: fix OOM and buffer overflow
Message-Id: <20110727003458.178482403FF@tassilo.jf.intel.com>
Date: Tue, 26 Jul 2011 17:34:58 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.35-longterm review patch.  If anyone has any objections, please let me know.

------------------
From: Vasiliy Kulikov <segoon@openwall.com>

[ upstream commit b522f02184b413955f3bc952e3776ce41edc6355 ]

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
Signed-off-by: Dave Airlie <airlied@redhat.com>
Signed-off-by: Andi Kleen <ak@linux.intel.com>

Index: linux-2.6.35.y/drivers/char/agp/generic.c
===================================================================
--- linux-2.6.35.y.orig/drivers/char/agp/generic.c
+++ linux-2.6.35.y/drivers/char/agp/generic.c
@@ -122,6 +122,9 @@ static struct agp_memory *agp_create_use
 	struct agp_memory *new;
 	unsigned long alloc_size = num_agp_pages*sizeof(struct page *);
 
+	if (INT_MAX/sizeof(struct page *) < num_agp_pages)
+		return NULL;
+
 	new = kzalloc(sizeof(struct agp_memory), GFP_KERNEL);
 	if (new == NULL)
 		return NULL;
@@ -241,11 +244,14 @@ struct agp_memory *agp_allocate_memory(s
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
