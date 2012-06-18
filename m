Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753833Ab2FRJAM (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Jun 2012 05:00:12 -0400
Received: from terminus.zytor.com ([198.137.202.10]:40578 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751511Ab2FRJAK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Jun 2012 05:00:10 -0400
Date: Mon, 18 Jun 2012 01:59:41 -0700
From: tip-bot for Oleg Nesterov <oleg@redhat.com>
Message-ID: <tip-449d0d7c9fb87277175db34c009c70cb348004a8@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@kernel.org,
        peterz@infradead.org, ananth@in.ibm.com, anton@redhat.com,
        srikar@linux.vnet.ibm.com, tglx@linutronix.de, oleg@redhat.com
Reply-To: mingo@kernel.org, hpa@zytor.com, linux-kernel@vger.kernel.org,
        peterz@infradead.org, ananth@in.ibm.com, anton@redhat.com,
        srikar@linux.vnet.ibm.com, tglx@linutronix.de, oleg@redhat.com
In-Reply-To: <20120615154353.GA9614@redhat.com>
References: <20120615154353.GA9614@redhat.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/core] uprobes: Simplify the usage of uprobe->
 pending_list
Git-Commit-ID: 449d0d7c9fb87277175db34c009c70cb348004a8
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.6 (terminus.zytor.com [127.0.0.1]); Mon, 18 Jun 2012 01:59:47 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  449d0d7c9fb87277175db34c009c70cb348004a8
Gitweb:     http://git.kernel.org/tip/449d0d7c9fb87277175db34c009c70cb348004a8
Author:     Oleg Nesterov <oleg@redhat.com>
AuthorDate: Fri, 15 Jun 2012 17:43:53 +0200
Committer:  Ingo Molnar <mingo@kernel.org>
CommitDate: Sat, 16 Jun 2012 09:10:48 +0200

uprobes: Simplify the usage of uprobe->pending_list

uprobe->pending_list is only used to create the temporary list,
it has no meaning after we drop uprobes_mmap_hash(inode).

No need to initialize this node or remove it from tmp_list, and
we can use list_for_each_entry().

Signed-off-by: Oleg Nesterov <oleg@redhat.com>
Cc: Ananth N Mavinakayanahalli <ananth@in.ibm.com>
Cc: Anton Arapov <anton@redhat.com>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Srikar Dronamraju <srikar@linux.vnet.ibm.com>
Link: http://lkml.kernel.org/r/20120615154353.GA9614@redhat.com
Signed-off-by: Ingo Molnar <mingo@kernel.org>
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
