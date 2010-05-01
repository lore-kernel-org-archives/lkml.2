Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753962Ab0EAO0o (ORCPT <rfc822;w@1wt.eu>);
	Sat, 1 May 2010 10:26:44 -0400
Received: from tarap.cc.columbia.edu ([128.59.29.7]:63108 "EHLO
	tarap.cc.columbia.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753286Ab0EAO0k (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 1 May 2010 10:26:40 -0400
From: Oren Laadan <orenl@cs.columbia.edu>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: containers@lists.linux-foundation.org, linux-kernel@vger.kernel.org,
       Serge Hallyn <serue@us.ibm.com>, Matt Helsley <matthltc@us.ibm.com>,
       Pavel Emelyanov <xemul@openvz.org>,
       Sukadev Bhattiprolu <sukadev@linux.vnet.ibm.com>,
       linux-api@vger.kernel.org, x86@kernel.org, linux-s390@vger.kernel.org,
       linuxppc-dev@ozlabs.org
Subject: [PATCH v21 001/100] eclone (1/11): Factor out code to allocate pidmap page
Date: Sat,  1 May 2010 10:14:43 -0400
Message-Id: <1272723382-19470-2-git-send-email-orenl@cs.columbia.edu>
X-Mailer: git-send-email 1.6.3.3
In-Reply-To: <1272723382-19470-1-git-send-email-orenl@cs.columbia.edu>
References: <1272723382-19470-1-git-send-email-orenl@cs.columbia.edu>
X-No-Spam-Score: Local
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Sukadev Bhattiprolu <sukadev@linux.vnet.ibm.com>

To simplify alloc_pidmap(), move code to allocate a pid map page to a
separate function.

Changelog[v4]:
	- [Oren Laadan] Adapt to kernel 2.6.33-rc5
Changelog[v3]:
	- Earlier version of patchset called alloc_pidmap_page() from two
	  places. But now its called from only one place. Even so, moving
	  this code out into a separate function simplifies alloc_pidmap().
Changelog[v2]:
	- (Matt Helsley, Dave Hansen) Have alloc_pidmap_page() return
	  -ENOMEM on error instead of -1.

Cc: linux-api@vger.kernel.org
Cc: x86@kernel.org
Cc: linux-s390@vger.kernel.org
Cc: linuxppc-dev@ozlabs.org
Signed-off-by: Sukadev Bhattiprolu <sukadev@linux.vnet.ibm.com>
Acked-by: Serge E. Hallyn <serue@us.ibm.com>
Tested-by: Serge E. Hallyn <serue@us.ibm.com>
Reviewed-by: Oren Laadan <orenl@cs.columbia.edu>
---
 kernel/pid.c |   41 ++++++++++++++++++++++++++---------------
 1 files changed, 26 insertions(+), 15 deletions(-)

diff --git a/kernel/pid.c b/kernel/pid.c
index aebb30d..52a371a 100644
--- a/kernel/pid.c
+++ b/kernel/pid.c
@@ -122,6 +122,30 @@ static void free_pidmap(struct upid *upid)
 	atomic_inc(&map->nr_free);
 }
 
+static int alloc_pidmap_page(struct pidmap *map)
+{
+	void *page;
+
+	if (likely(map->page))
+		return 0;
+
+	page = kzalloc(PAGE_SIZE, GFP_KERNEL);
+	/*
+	 * Free the page if someone raced with us installing it:
+	 */
+	spin_lock_irq(&pidmap_lock);
+	if (!map->page) {
+		map->page = page;
+		page = NULL;
+	}
+	spin_unlock_irq(&pidmap_lock);
+	kfree(page);
+	if (unlikely(!map->page))
+		return -1;
+
+	return 0;
+}
+
 static int alloc_pidmap(struct pid_namespace *pid_ns)
 {
 	int i, offset, max_scan, pid, last = pid_ns->last_pid;
@@ -134,22 +158,9 @@ static int alloc_pidmap(struct pid_namespace *pid_ns)
 	map = &pid_ns->pidmap[pid/BITS_PER_PAGE];
 	max_scan = (pid_max + BITS_PER_PAGE - 1)/BITS_PER_PAGE - !offset;
 	for (i = 0; i <= max_scan; ++i) {
-		if (unlikely(!map->page)) {
-			void *page = kzalloc(PAGE_SIZE, GFP_KERNEL);
-			/*
-			 * Free the page if someone raced with us
-			 * installing it:
-			 */
-			spin_lock_irq(&pidmap_lock);
-			if (!map->page) {
-				map->page = page;
-				page = NULL;
-			}
-			spin_unlock_irq(&pidmap_lock);
-			kfree(page);
-			if (unlikely(!map->page))
+		if (unlikely(!map->page))
+			if (alloc_pidmap_page(map) < 0)
 				break;
-		}
 		if (likely(atomic_read(&map->nr_free))) {
 			do {
 				if (!test_and_set_bit(offset, map->page)) {
-- 
1.6.3.3

