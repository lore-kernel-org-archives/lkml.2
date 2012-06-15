Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932527Ab2FOPqh (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Jun 2012 11:46:37 -0400
Received: from mx1.redhat.com ([209.132.183.28]:12872 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932135Ab2FOPqf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Jun 2012 11:46:35 -0400
Date: Fri, 15 Jun 2012 17:43:53 +0200
From: Oleg Nesterov <oleg@redhat.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: Ananth N Mavinakayanahalli <ananth@in.ibm.com>,
        Anton Arapov <anton@redhat.com>, Peter Zijlstra <peterz@infradead.org>,
        Srikar Dronamraju <srikar@linux.vnet.ibm.com>,
        linux-kernel@vger.kernel.org
Subject: [PATCH 12/15] uprobes: simplify the usage of uprobe->pending_list
Message-ID: <20120615154353.GA9614@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120615154241.GA9524@redhat.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

uprobe->pending_list is only used to create the temporary list,
it has no meaning after we drop uprobes_mmap_hash(inode).

No need to initialize this node or remove it from tmp_list, and
we can use list_for_each_entry().

Signed-off-by: Oleg Nesterov <oleg@redhat.com>
---
 kernel/events/uprobes.c |   12 ++++--------
 1 files changed, 4 insertions(+), 8 deletions(-)

diff --git a/kernel/events/uprobes.c b/kernel/events/uprobes.c
index b9c61bd..7d5c78f 100644
--- a/kernel/events/uprobes.c
+++ b/kernel/events/uprobes.c
@@ -513,7 +513,6 @@ static struct uprobe *alloc_uprobe(struct inode *inode, loff_t offset)
 	uprobe->inode = igrab(inode);
 	uprobe->offset = offset;
 	init_rwsem(&uprobe->consumer_rwsem);
-	INIT_LIST_HEAD(&uprobe->pending_list);
 
 	/* add to uprobes_tree, sorted on inode:offset */
 	cur_uprobe = insert_uprobe(uprobe);
@@ -1037,7 +1036,7 @@ static void build_probe_list(struct inode *inode, struct list_head *head)
 int uprobe_mmap(struct vm_area_struct *vma)
 {
 	struct list_head tmp_list;
-	struct uprobe *uprobe, *u;
+	struct uprobe *uprobe;
 	struct inode *inode;
 	int ret, count;
 
@@ -1055,10 +1054,9 @@ int uprobe_mmap(struct vm_area_struct *vma)
 	ret = 0;
 	count = 0;
 
-	list_for_each_entry_safe(uprobe, u, &tmp_list, pending_list) {
+	list_for_each_entry(uprobe, &tmp_list, pending_list) {
 		loff_t vaddr;
 
-		list_del(&uprobe->pending_list);
 		if (!ret) {
 			vaddr = vma_address(vma, uprobe->offset);
 
@@ -1106,7 +1104,7 @@ int uprobe_mmap(struct vm_area_struct *vma)
 void uprobe_munmap(struct vm_area_struct *vma, unsigned long start, unsigned long end)
 {
 	struct list_head tmp_list;
-	struct uprobe *uprobe, *u;
+	struct uprobe *uprobe;
 	struct inode *inode;
 
 	if (!atomic_read(&uprobe_events) || !valid_vma(vma, false))
@@ -1123,12 +1121,10 @@ void uprobe_munmap(struct vm_area_struct *vma, unsigned long start, unsigned lon
 	mutex_lock(uprobes_mmap_hash(inode));
 	build_probe_list(inode, &tmp_list);
 
-	list_for_each_entry_safe(uprobe, u, &tmp_list, pending_list) {
+	list_for_each_entry(uprobe, &tmp_list, pending_list) {
 		loff_t vaddr;
 
-		list_del(&uprobe->pending_list);
 		vaddr = vma_address(vma, uprobe->offset);
-
 		if (vaddr >= start && vaddr < end) {
 			/*
 			 * An unregister could have removed the probe before
-- 
1.5.5.1

