Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758586Ab0LNJ41 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Dec 2010 04:56:27 -0500
Received: from e32.co.us.ibm.com ([32.97.110.150]:52299 "EHLO
	e32.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758073Ab0LNJ40 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Dec 2010 04:56:26 -0500
Date: Tue, 14 Dec 2010 15:24:59 +0530
From: "Suzuki K. Poulose" <suzuki@in.ibm.com>
To: "Suzuki K. Poulose" <suzuki@in.ibm.com>
Cc: linux-kernel@vger.kernel.org,
        Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>,
        Christoph Hellwig <hch@lst.de>, Masami Hiramatsu <mhiramat@redhat.com>,
        Ananth N Mavinakayanahalli <ananth@in.ibm.com>,
        Daisuke HATAYAMA <d.hatayama@jp.fujitsu.com>,
        Andi Kleen <andi@firstfloor.org>, Roland McGrath <roland@redhat.com>,
        Amerigo Wang <amwang@redhat.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
        Oleg Nesterov <oleg@redhat.com>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: [Patch 1/21] Reuse freezable() predicate
Message-ID: <20101214152459.581ec3f0@suzukikp>
In-Reply-To: <20101214152259.67896960@suzukikp>
References: <20101214152259.67896960@suzukikp>
Organization: IBM
X-Mailer: Claws Mail 3.7.6 (GTK+ 2.22.0; i386-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Export the freezable() predicate.

Signed-off-by: Suzuki K. Poulose <suzuki@in.ibm.com>
---
 include/linux/freezer.h |   12 ++++++++++++
 kernel/power/process.c  |    9 ---------
 2 files changed, 12 insertions(+), 9 deletions(-)

Index: linux-2.6.36-rc7/include/linux/freezer.h
===================================================================
--- linux-2.6.36-rc7.orig/include/linux/freezer.h
+++ linux-2.6.36-rc7/include/linux/freezer.h
@@ -8,6 +8,18 @@
 
 #ifdef CONFIG_FREEZER
 /*
+ * Check if the task is freezeable ?
+ */
+static inline int freezeable(struct task_struct * p)
+{
+	if ((p == current) ||
+	    (p->flags & PF_NOFREEZE) ||
+	    (p->exit_state != 0))
+		return 0;
+	return 1;
+}
+
+/*
  * Check if a process has been frozen
  */
 static inline int frozen(struct task_struct *p)
Index: linux-2.6.36-rc7/kernel/power/process.c
===================================================================
--- linux-2.6.36-rc7.orig/kernel/power/process.c
+++ linux-2.6.36-rc7/kernel/power/process.c
@@ -22,15 +22,6 @@
  */
 #define TIMEOUT	(20 * HZ)
 
-static inline int freezeable(struct task_struct * p)
-{
-	if ((p == current) ||
-	    (p->flags & PF_NOFREEZE) ||
-	    (p->exit_state != 0))
-		return 0;
-	return 1;
-}
-
 static int try_to_freeze_tasks(bool sig_only)
 {
 	struct task_struct *g, *p;
