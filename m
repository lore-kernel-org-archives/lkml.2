Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753603Ab0KASln (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Nov 2010 14:41:43 -0400
Received: from mail-gw0-f46.google.com ([74.125.83.46]:45912 "EHLO
	mail-gw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753356Ab0KASlj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Nov 2010 14:41:39 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=XFdLuu+rA8alcHKia9ixiwUUj+Ruq+4wZbQGVO1brG3+UPYEsqb/XY7sgPaplCGFMc
         I91AqixyUN2DUjZI7qDZeckUBtaDb+T5MqKwtYR0kQdyvvAYj9J8t6KuAV6sM+05hAPF
         KAhyzUjrGMs954IKZAAoQZTN5XCxm1okTS6+A=
From: Tracey Dent <tdent48227@gmail.com>
To: greg@kroah.com
Cc: manningc2@actrix.gen.nz, linux-kernel@vger.kernel.org,
        linux-fsdevel@vger.kernel.org, Tracey Dent <tdent48227@gmail.com>
Subject: [PATCH 05/29] Staging: yaffs2: yaffs_allocator: Add files
Date: Mon,  1 Nov 2010 14:40:53 -0400
Message-Id: <1288636877-7964-6-git-send-email-tdent48227@gmail.com>
X-Mailer: git-send-email 1.7.3.2.146.gca209
In-Reply-To: <1288636877-7964-1-git-send-email-tdent48227@gmail.com>
References: <1288636877-7964-1-git-send-email-tdent48227@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Adding files to yaffs2 directory.

Signed-off-by: Tracey Dent <tdent48227@gmail.com>
---
 drivers/staging/yaffs2/yaffs_allocator.c |  408 ++++++++++++++++++++++++++++++
 drivers/staging/yaffs2/yaffs_allocator.h |   30 +++
 2 files changed, 438 insertions(+), 0 deletions(-)
 create mode 100644 drivers/staging/yaffs2/yaffs_allocator.c
 create mode 100644 drivers/staging/yaffs2/yaffs_allocator.h

diff --git a/drivers/staging/yaffs2/yaffs_allocator.c b/drivers/staging/yaffs2/yaffs_allocator.c
new file mode 100644
index 0000000..024ee2a
--- /dev/null
+++ b/drivers/staging/yaffs2/yaffs_allocator.c
@@ -0,0 +1,408 @@
+/*
+ * YAFFS: Yet Another Flash File System. A NAND-flash specific file system.
+ *
+ * Copyright (C) 2002-2010 Aleph One Ltd.
+ *   for Toby Churchill Ltd and Brightstar Engineering
+ *
+ * Created by Charles Manning <charles@aleph1.co.uk>
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2 as
+ * published by the Free Software Foundation.
+ */
+
+
+
+#include "yaffs_allocator.h"
+#include "yaffs_guts.h"
+#include "yaffs_trace.h"
+#include "yportenv.h"
+
+#ifdef CONFIG_YAFFS_YMALLOC_ALLOCATOR
+
+void yaffs_deinit_raw_tnodes_and_objs(yaffs_dev_t *dev)
+{
+	dev = dev;
+}
+
+void yaffs_init_raw_tnodes_and_objs(yaffs_dev_t *dev)
+{
+	dev = dev;
+}
+
+yaffs_tnode_t *yaffs_alloc_raw_tnode(yaffs_dev_t *dev)
+{
+	return (yaffs_tnode_t *)YMALLOC(dev->tnode_size);
+}
+
+void yaffs_free_raw_tnode(yaffs_dev_t *dev, yaffs_tnode_t *tn)
+{
+	dev = dev;
+	YFREE(tn);
+}
+
+void yaffs_init_raw_objs(yaffs_dev_t *dev)
+{
+	dev = dev;
+}
+
+void yaffs_deinit_raw_objs(yaffs_dev_t *dev)
+{
+	dev = dev;
+}
+
+yaffs_obj_t *yaffs_alloc_raw_obj(yaffs_dev_t *dev)
+{
+	dev = dev;
+	return (yaffs_obj_t *) YMALLOC(sizeof(yaffs_obj_t));
+}
+
+
+void yaffs_free_raw_obj(yaffs_dev_t *dev, yaffs_obj_t *obj)
+{
+
+	dev = dev;
+	YFREE(obj);
+}
+
+#else
+
+struct yaffs_tnode_list {
+	struct yaffs_tnode_list *next;
+	yaffs_tnode_t *tnodes;
+};
+
+typedef struct yaffs_tnode_list yaffs_tnodelist_t;
+
+struct yaffs_obj_list_struct {
+	yaffs_obj_t *objects;
+	struct yaffs_obj_list_struct *next;
+};
+
+typedef struct yaffs_obj_list_struct yaffs_obj_list;
+
+
+struct yaffs_AllocatorStruct {
+	int n_tnodesCreated;
+	yaffs_tnode_t *freeTnodes;
+	int nFreeTnodes;
+	yaffs_tnodelist_t *allocatedTnodeList;
+
+	int n_objCreated;
+	yaffs_obj_t *freeObjects;
+	int nFreeObjects;
+
+	yaffs_obj_list *allocated_list;
+};
+
+typedef struct yaffs_AllocatorStruct yaffs_Allocator;
+
+
+static void yaffs_deinit_raw_tnodes(yaffs_dev_t *dev)
+{
+
+	yaffs_Allocator *allocator = (yaffs_Allocator *)dev->allocator;
+
+	yaffs_tnodelist_t *tmp;
+
+	if(!allocator){
+		YBUG();
+		return;
+	}
+
+	while (allocator->allocatedTnodeList) {
+		tmp = allocator->allocatedTnodeList->next;
+
+		YFREE(allocator->allocatedTnodeList->tnodes);
+		YFREE(allocator->allocatedTnodeList);
+		allocator->allocatedTnodeList = tmp;
+
+	}
+
+	allocator->freeTnodes = NULL;
+	allocator->nFreeTnodes = 0;
+	allocator->n_tnodesCreated = 0;
+}
+
+static void yaffs_init_raw_tnodes(yaffs_dev_t *dev)
+{
+	yaffs_Allocator *allocator = dev->allocator;
+
+	if(allocator){
+		allocator->allocatedTnodeList = NULL;
+		allocator->freeTnodes = NULL;
+		allocator->nFreeTnodes = 0;
+		allocator->n_tnodesCreated = 0;
+	} else
+		YBUG();
+}
+
+static int yaffs_create_tnodes(yaffs_dev_t *dev, int n_tnodes)
+{
+	yaffs_Allocator *allocator = (yaffs_Allocator *)dev->allocator;
+	int i;
+	yaffs_tnode_t *newTnodes;
+	__u8 *mem;
+	yaffs_tnode_t *curr;
+	yaffs_tnode_t *next;
+	yaffs_tnodelist_t *tnl;
+
+	if(!allocator){
+		YBUG();
+		return YAFFS_FAIL;
+	}
+
+	if (n_tnodes < 1)
+		return YAFFS_OK;
+
+
+	/* make these things */
+
+	newTnodes = YMALLOC(n_tnodes * dev->tnode_size);
+	mem = (__u8 *)newTnodes;
+
+	if (!newTnodes) {
+		T(YAFFS_TRACE_ERROR,
+			(TSTR("yaffs: Could not allocate Tnodes" TENDSTR)));
+		return YAFFS_FAIL;
+	}
+
+	/* New hookup for wide tnodes */
+	for (i = 0; i < n_tnodes - 1; i++) {
+		curr = (yaffs_tnode_t *) &mem[i * dev->tnode_size];
+		next = (yaffs_tnode_t *) &mem[(i+1) * dev->tnode_size];
+		curr->internal[0] = next;
+	}
+
+	curr = (yaffs_tnode_t *) &mem[(n_tnodes - 1) * dev->tnode_size];
+	curr->internal[0] = allocator->freeTnodes;
+	allocator->freeTnodes = (yaffs_tnode_t *)mem;
+
+	allocator->nFreeTnodes += n_tnodes;
+	allocator->n_tnodesCreated += n_tnodes;
+
+	/* Now add this bunch of tnodes to a list for freeing up.
+	 * NB If we can't add this to the management list it isn't fatal
+	 * but it just means we can't free this bunch of tnodes later.
+	 */
+
+	tnl = YMALLOC(sizeof(yaffs_tnodelist_t));
+	if (!tnl) {
+		T(YAFFS_TRACE_ERROR,
+		  (TSTR
+		   ("yaffs: Could not add tnodes to management list" TENDSTR)));
+		   return YAFFS_FAIL;
+	} else {
+		tnl->tnodes = newTnodes;
+		tnl->next = allocator->allocatedTnodeList;
+		allocator->allocatedTnodeList = tnl;
+	}
+
+	T(YAFFS_TRACE_ALLOCATE, (TSTR("yaffs: Tnodes added" TENDSTR)));
+
+	return YAFFS_OK;
+}
+
+
+yaffs_tnode_t *yaffs_alloc_raw_tnode(yaffs_dev_t *dev)
+{
+	yaffs_Allocator *allocator = (yaffs_Allocator *)dev->allocator;
+	yaffs_tnode_t *tn = NULL;
+
+	if(!allocator){
+		YBUG();
+		return NULL;
+	}
+
+	/* If there are none left make more */
+	if (!allocator->freeTnodes)
+		yaffs_create_tnodes(dev, YAFFS_ALLOCATION_NTNODES);
+
+	if (allocator->freeTnodes) {
+		tn = allocator->freeTnodes;
+		allocator->freeTnodes = allocator->freeTnodes->internal[0];
+		allocator->nFreeTnodes--;
+	}
+
+	return tn;
+}
+
+/* FreeTnode frees up a tnode and puts it back on the free list */
+void yaffs_free_raw_tnode(yaffs_dev_t *dev, yaffs_tnode_t *tn)
+{
+	yaffs_Allocator *allocator = dev->allocator;
+
+	if(!allocator){
+		YBUG();
+		return;
+	}
+
+	if (tn) {
+		tn->internal[0] = allocator->freeTnodes;
+		allocator->freeTnodes = tn;
+		allocator->nFreeTnodes++;
+	}
+	dev->checkpoint_blocks_required = 0; /* force recalculation*/
+}
+
+
+
+static void yaffs_init_raw_objs(yaffs_dev_t *dev)
+{
+	yaffs_Allocator *allocator = dev->allocator;
+
+	if(allocator) {
+		allocator->allocated_list = NULL;
+		allocator->freeObjects = NULL;
+		allocator->nFreeObjects = 0;
+	} else
+		YBUG();
+}
+
+static void yaffs_deinit_raw_objs(yaffs_dev_t *dev)
+{
+	yaffs_Allocator *allocator = dev->allocator;
+	yaffs_obj_list *tmp;
+
+	if(!allocator){
+		YBUG();
+		return;
+	}
+
+	while (allocator->allocated_list) {
+		tmp = allocator->allocated_list->next;
+		YFREE(allocator->allocated_list->objects);
+		YFREE(allocator->allocated_list);
+
+		allocator->allocated_list = tmp;
+	}
+
+	allocator->freeObjects = NULL;
+	allocator->nFreeObjects = 0;
+	allocator->n_objCreated = 0;
+}
+
+
+static int yaffs_create_free_objs(yaffs_dev_t *dev, int n_obj)
+{
+	yaffs_Allocator *allocator = dev->allocator;
+
+	int i;
+	yaffs_obj_t *newObjects;
+	yaffs_obj_list *list;
+
+	if(!allocator){
+		YBUG();
+		return YAFFS_FAIL;
+	}
+
+	if (n_obj < 1)
+		return YAFFS_OK;
+
+	/* make these things */
+	newObjects = YMALLOC(n_obj * sizeof(yaffs_obj_t));
+	list = YMALLOC(sizeof(yaffs_obj_list));
+
+	if (!newObjects || !list) {
+		if (newObjects){
+			YFREE(newObjects);
+			newObjects = NULL;
+		}
+		if (list){
+			YFREE(list);
+			list = NULL;
+		}
+		T(YAFFS_TRACE_ALLOCATE,
+		  (TSTR("yaffs: Could not allocate more objects" TENDSTR)));
+		return YAFFS_FAIL;
+	}
+
+	/* Hook them into the free list */
+	for (i = 0; i < n_obj - 1; i++) {
+		newObjects[i].siblings.next =
+				(struct ylist_head *)(&newObjects[i + 1]);
+	}
+
+	newObjects[n_obj - 1].siblings.next = (void *)allocator->freeObjects;
+	allocator->freeObjects = newObjects;
+	allocator->nFreeObjects += n_obj;
+	allocator->n_objCreated += n_obj;
+
+	/* Now add this bunch of Objects to a list for freeing up. */
+
+	list->objects = newObjects;
+	list->next = allocator->allocated_list;
+	allocator->allocated_list = list;
+
+	return YAFFS_OK;
+}
+
+yaffs_obj_t *yaffs_alloc_raw_obj(yaffs_dev_t *dev)
+{
+	yaffs_obj_t *obj = NULL;
+	yaffs_Allocator *allocator = dev->allocator;
+
+	if(!allocator) {
+		YBUG();
+		return obj;
+	}
+
+	/* If there are none left make more */
+	if (!allocator->freeObjects)
+		yaffs_create_free_objs(dev, YAFFS_ALLOCATION_NOBJECTS);
+
+	if (allocator->freeObjects) {
+		obj = allocator->freeObjects;
+		allocator->freeObjects =
+			(yaffs_obj_t *) (allocator->freeObjects->siblings.next);
+		allocator->nFreeObjects--;
+	}
+
+	return obj;
+}
+
+
+void yaffs_free_raw_obj(yaffs_dev_t *dev, yaffs_obj_t *obj)
+{
+
+	yaffs_Allocator *allocator = dev->allocator;
+
+	if(!allocator)
+		YBUG();
+	else {
+		/* Link into the free list. */
+		obj->siblings.next = (struct ylist_head *)(allocator->freeObjects);
+		allocator->freeObjects = obj;
+		allocator->nFreeObjects++;
+	}
+}
+
+void yaffs_deinit_raw_tnodes_and_objs(yaffs_dev_t *dev)
+{
+	if(dev->allocator){
+		yaffs_deinit_raw_tnodes(dev);
+		yaffs_deinit_raw_objs(dev);
+
+		YFREE(dev->allocator);
+		dev->allocator=NULL;
+	} else
+		YBUG();
+}
+
+void yaffs_init_raw_tnodes_and_objs(yaffs_dev_t *dev)
+{
+	yaffs_Allocator *allocator;
+
+	if(!dev->allocator){
+		allocator = YMALLOC(sizeof(yaffs_Allocator));
+		if(allocator){
+			dev->allocator = allocator;
+			yaffs_init_raw_tnodes(dev);
+			yaffs_init_raw_objs(dev);
+		}
+	} else
+		YBUG();
+}
+
+
+#endif
diff --git a/drivers/staging/yaffs2/yaffs_allocator.h b/drivers/staging/yaffs2/yaffs_allocator.h
new file mode 100644
index 0000000..777f3b0
--- /dev/null
+++ b/drivers/staging/yaffs2/yaffs_allocator.h
@@ -0,0 +1,30 @@
+/*
+ * YAFFS: Yet another Flash File System . A NAND-flash specific file system.
+ *
+ * Copyright (C) 2002-2010 Aleph One Ltd.
+ *   for Toby Churchill Ltd and Brightstar Engineering
+ *
+ * Created by Charles Manning <charles@aleph1.co.uk>
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU Lesser General Public License version 2.1 as
+ * published by the Free Software Foundation.
+ *
+ * Note: Only YAFFS headers are LGPL, YAFFS C code is covered by GPL.
+ */
+
+#ifndef __YAFFS_ALLOCATOR_H__
+#define __YAFFS_ALLOCATOR_H__
+
+#include "yaffs_guts.h"
+
+void yaffs_init_raw_tnodes_and_objs(yaffs_dev_t *dev);
+void yaffs_deinit_raw_tnodes_and_objs(yaffs_dev_t *dev);
+
+yaffs_tnode_t *yaffs_alloc_raw_tnode(yaffs_dev_t *dev);
+void yaffs_free_raw_tnode(yaffs_dev_t *dev, yaffs_tnode_t *tn);
+
+yaffs_obj_t *yaffs_alloc_raw_obj(yaffs_dev_t *dev);
+void yaffs_free_raw_obj(yaffs_dev_t *dev, yaffs_obj_t *obj);
+
+#endif
-- 
1.7.3.2.146.gca209

