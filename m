Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753411Ab2G2SZ2 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 29 Jul 2012 14:25:28 -0400
Received: from mx1.redhat.com ([209.132.183.28]:59641 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753409Ab2G2SZ0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 29 Jul 2012 14:25:26 -0400
Date: Sun, 29 Jul 2012 20:22:29 +0200
From: Oleg Nesterov <oleg@redhat.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: Anton Arapov <anton@redhat.com>,
        Srikar Dronamraju <srikar@linux.vnet.ibm.com>,
        linux-kernel@vger.kernel.org
Subject: [PATCH 05/14] uprobes: uprobe_mmap/munmap needs
	list_for_each_entry_safe()
Message-ID: <20120729182229.GA20329@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120729182128.GA20269@redhat.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The bug was introduced by me in 449d0d7c "uprobes: Simplify the
usage of uprobe->pending_list".

Yes, we do not care about uprobe->pending_list after return and
nobody can remove the current list entry, but put_uprobe(uprobe)
can actually free it and thus we need list_for_each_safe().

Reported-by: Srikar Dronamraju <srikar@linux.vnet.ibm.com>
Signed-off-by: Oleg Nesterov <oleg@redhat.com>
Acked-by: Srikar Dronamraju <srikar.vnet.ibm.com>
---
 kernel/events/uprobes.c |    8 ++++----
 1 files changed, 4 insertions(+), 4 deletions(-)

diff --git a/kernel/events/uprobes.c b/kernel/events/uprobes.c
index 67697db..a93b6df 100644
--- a/kernel/events/uprobes.c
+++ b/kernel/events/uprobes.c
@@ -1010,7 +1010,7 @@ static void build_probe_list(struct inode *inode, struct list_head *head)
 int uprobe_mmap(struct vm_area_struct *vma)
 {
 	struct list_head tmp_list;
-	struct uprobe *uprobe;
+	struct uprobe *uprobe, *u;
 	struct inode *inode;
 	int ret, count;
 
@@ -1028,7 +1028,7 @@ int uprobe_mmap(struct vm_area_struct *vma)
 	ret = 0;
 	count = 0;
 
-	list_for_each_entry(uprobe, &tmp_list, pending_list) {
+	list_for_each_entry_safe(uprobe, u, &tmp_list, pending_list) {
 		if (!ret) {
 			loff_t vaddr = vma_address(vma, uprobe->offset);
 
@@ -1076,7 +1076,7 @@ int uprobe_mmap(struct vm_area_struct *vma)
 void uprobe_munmap(struct vm_area_struct *vma, unsigned long start, unsigned long end)
 {
 	struct list_head tmp_list;
-	struct uprobe *uprobe;
+	struct uprobe *uprobe, *u;
 	struct inode *inode;
 
 	if (!atomic_read(&uprobe_events) || !valid_vma(vma, false))
@@ -1093,7 +1093,7 @@ void uprobe_munmap(struct vm_area_struct *vma, unsigned long start, unsigned lon
 	mutex_lock(uprobes_mmap_hash(inode));
 	build_probe_list(inode, &tmp_list);
 
-	list_for_each_entry(uprobe, &tmp_list, pending_list) {
+	list_for_each_entry_safe(uprobe, u, &tmp_list, pending_list) {
 		loff_t vaddr = vma_address(vma, uprobe->offset);
 
 		if (vaddr >= start && vaddr < end) {
-- 
1.5.5.1

