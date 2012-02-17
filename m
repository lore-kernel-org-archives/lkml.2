Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756875Ab2BQBFr (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Feb 2012 20:05:47 -0500
Received: from out5-smtp.messagingengine.com ([66.111.4.29]:42256 "EHLO
	out5-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756756Ab2BQA75 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Feb 2012 19:59:57 -0500
X-Sasl-enc: iPYXb0yrsSxjwAJHWyE2naMJr0Jrs50iCu1ndcyRZGnd 1329440395
X-Mailbox-Line: From gregkh@linuxfoundation.org Thu Feb 16 16:55:36 2012
Message-Id: <20120217005536.149425322@linuxfoundation.org>
User-Agent: quilt/0.51-15.1
Date: Thu, 16 Feb 2012 16:55:49 -0800
From: Greg KH <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org,
        alan@lxorguk.ukuu.org.uk, Rabin Vincent <rabin@rab.in>,
        Wu Fengguang <fengguang.wu@intel.com>
Subject: [15/28] writeback: fix NULL bdi->dev in trace writeback_single_inode
In-Reply-To: <20120217005609.GA17081@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Wu Fengguang <fengguang.wu@intel.com>

commit 15eb77a07c714ac80201abd0a9568888bcee6276 upstream.

bdi_prune_sb() resets sb->s_bdi to default_backing_dev_info when the
tearing down the original bdi. Fix trace_writeback_single_inode to
use sb->s_bdi=default_backing_dev_info rather than bdi->dev=NULL for a
teared down bdi.

Reported-by: Rabin Vincent <rabin@rab.in>
Tested-by: Rabin Vincent <rabin@rab.in>
Signed-off-by: Wu Fengguang <fengguang.wu@intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 fs/fs-writeback.c                |   16 ++++++++--------
 include/trace/events/writeback.h |    2 +-
 2 files changed, 9 insertions(+), 9 deletions(-)

--- a/fs/fs-writeback.c
+++ b/fs/fs-writeback.c
@@ -48,14 +48,6 @@ struct wb_writeback_work {
 };
 
 /*
- * Include the creation of the trace points after defining the
- * wb_writeback_work structure so that the definition remains local to this
- * file.
- */
-#define CREATE_TRACE_POINTS
-#include <trace/events/writeback.h>
-
-/*
  * We don't actually have pdflush, but this one is exported though /proc...
  */
 int nr_pdflush_threads;
@@ -87,6 +79,14 @@ static inline struct inode *wb_inode(str
 	return list_entry(head, struct inode, i_wb_list);
 }
 
+/*
+ * Include the creation of the trace points after defining the
+ * wb_writeback_work structure and inline functions so that the definition
+ * remains local to this file.
+ */
+#define CREATE_TRACE_POINTS
+#include <trace/events/writeback.h>
+
 /* Wakeup flusher thread or forker thread to fork it. Requires bdi->wb_lock. */
 static void bdi_wakeup_flusher(struct backing_dev_info *bdi)
 {
--- a/include/trace/events/writeback.h
+++ b/include/trace/events/writeback.h
@@ -418,7 +418,7 @@ DECLARE_EVENT_CLASS(writeback_single_ino
 
 	TP_fast_assign(
 		strncpy(__entry->name,
-			dev_name(inode->i_mapping->backing_dev_info->dev), 32);
+			dev_name(inode_to_bdi(inode)->dev), 32);
 		__entry->ino		= inode->i_ino;
 		__entry->state		= inode->i_state;
 		__entry->dirtied_when	= inode->dirtied_when;


