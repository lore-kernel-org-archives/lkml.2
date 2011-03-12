Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753783Ab1CLK7S (ORCPT <rfc822;w@1wt.eu>);
	Sat, 12 Mar 2011 05:59:18 -0500
Received: from hera.kernel.org ([140.211.167.34]:43896 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753352Ab1CLK7Q (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 12 Mar 2011 05:59:16 -0500
Date: Sat, 12 Mar 2011 10:59:02 GMT
From: tip-bot for Lai Jiangshan <laijs@cn.fujitsu.com>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
        rostedt@goodmis.org, tglx@linutronix.de, laijs@cn.fujitsu.com
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
        rostedt@goodmis.org, tglx@linutronix.de, laijs@cn.fujitsu.com
In-Reply-To: <4D107986.1010302@cn.fujitsu.com>
References: <4D107986.1010302@cn.fujitsu.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:core/futexes] plist: Add priority list test
Message-ID: <tip-6d55da53db3d9b911f69f2ce1e5fb8943eafe057@git.kernel.org>
Git-Commit-ID: 6d55da53db3d9b911f69f2ce1e5fb8943eafe057
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org> to get blacklisted from these emails
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Sat, 12 Mar 2011 10:59:02 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  6d55da53db3d9b911f69f2ce1e5fb8943eafe057
Gitweb:     http://git.kernel.org/tip/6d55da53db3d9b911f69f2ce1e5fb8943eafe057
Author:     Lai Jiangshan <laijs@cn.fujitsu.com>
AuthorDate: Tue, 21 Dec 2010 17:55:18 +0800
Committer:  Steven Rostedt <rostedt@goodmis.org>
CommitDate: Fri, 11 Mar 2011 15:14:48 -0500

plist: Add priority list test

Add test code for checking plist when the kernel is booting.

Signed-off-by:  Lai Jiangshan <laijs@cn.fujitsu.com>
LKML-Reference: <4D107986.1010302@cn.fujitsu.com>
Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
---
 lib/plist.c |   81 ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++-
 1 files changed, 80 insertions(+), 1 deletions(-)

diff --git a/lib/plist.c b/lib/plist.c
index 8c614d0..0ae7e64 100644
--- a/lib/plist.c
+++ b/lib/plist.c
@@ -28,6 +28,8 @@
 
 #ifdef CONFIG_DEBUG_PI_LIST
 
+static struct plist_head test_head;
+
 static void plist_check_prev_next(struct list_head *t, struct list_head *p,
 				  struct list_head *n)
 {
@@ -54,7 +56,7 @@ static void plist_check_list(struct list_head *top)
 
 static void plist_check_head(struct plist_head *head)
 {
-	WARN_ON(!head->rawlock && !head->spinlock);
+	WARN_ON(head != &test_head && !head->rawlock && !head->spinlock);
 	if (head->rawlock)
 		WARN_ON_SMP(!raw_spin_is_locked(head->rawlock));
 	if (head->spinlock)
@@ -135,3 +137,80 @@ void plist_del(struct plist_node *node, struct plist_head *head)
 
 	plist_check_head(head);
 }
+
+#ifdef CONFIG_DEBUG_PI_LIST
+#include <linux/sched.h>
+#include <linux/module.h>
+#include <linux/init.h>
+
+static struct plist_node __initdata test_node[241];
+
+static void __init plist_test_check(int nr_expect)
+{
+	struct plist_node *first, *prio_pos, *node_pos;
+
+	if (plist_head_empty(&test_head)) {
+		BUG_ON(nr_expect != 0);
+		return;
+	}
+
+	prio_pos = first = plist_first(&test_head);
+	plist_for_each(node_pos, &test_head) {
+		if (nr_expect-- < 0)
+			break;
+		if (node_pos == first)
+			continue;
+		if (node_pos->prio == prio_pos->prio) {
+			BUG_ON(!list_empty(&node_pos->prio_list));
+			continue;
+		}
+
+		BUG_ON(prio_pos->prio > node_pos->prio);
+		BUG_ON(prio_pos->prio_list.next != &node_pos->prio_list);
+		prio_pos = node_pos;
+	}
+
+	BUG_ON(nr_expect != 0);
+	BUG_ON(prio_pos->prio_list.next != &first->prio_list);
+}
+
+static int  __init plist_test(void)
+{
+	int nr_expect = 0, i, loop;
+	unsigned int r = local_clock();
+
+	printk(KERN_INFO "start plist test\n");
+	plist_head_init(&test_head, NULL);
+	for (i = 0; i < ARRAY_SIZE(test_node); i++)
+		plist_node_init(test_node + i, 0);
+
+	for (loop = 0; loop < 1000; loop++) {
+		r = r * 193939 % 47629;
+		i = r % ARRAY_SIZE(test_node);
+		if (plist_node_empty(test_node + i)) {
+			r = r * 193939 % 47629;
+			test_node[i].prio = r % 99;
+			plist_add(test_node + i, &test_head);
+			nr_expect++;
+		} else {
+			plist_del(test_node + i, &test_head);
+			nr_expect--;
+		}
+		plist_test_check(nr_expect);
+	}
+
+	for (i = 0; i < ARRAY_SIZE(test_node); i++) {
+		if (plist_node_empty(test_node + i))
+			continue;
+		plist_del(test_node + i, &test_head);
+		nr_expect--;
+		plist_test_check(nr_expect);
+	}
+
+	printk(KERN_INFO "end plist test\n");
+	return 0;
+}
+
+module_init(plist_test);
+
+#endif
