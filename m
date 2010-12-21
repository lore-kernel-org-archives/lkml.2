Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933731Ab0LUJyB (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Dec 2010 04:54:01 -0500
Received: from cn.fujitsu.com ([222.73.24.84]:53091 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S933696Ab0LUJx7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Dec 2010 04:53:59 -0500
Message-ID: <4D107986.1010302@cn.fujitsu.com>
Date: Tue, 21 Dec 2010 17:55:18 +0800
From: Lai Jiangshan <laijs@cn.fujitsu.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.1.9) Gecko/20100423 Thunderbird/3.0.4
MIME-Version: 1.0
To: Peter Zijlstra <peterz@infradead.org>, John Kacur <jkacur@redhat.com>,
        James Bottomley <James.Bottomley@suse.de>, Ingo Molnar <mingo@elte.hu>,
        "Rafael J. Wysocki" <rjw@sisk.pl>,
        Thomas Gleixner <tglx@linutronix.de>,
        Darren Hart <dvhart@linux.intel.com>,
        Namhyung Kim <namhyung@gmail.com>, linux-kernel@vger.kernel.org,
        Steven Rostedt <rostedt@goodmis.org>
Subject: [PATCH 4/4] plist: priority list test
References: <4D09E8AD.60201@cn.fujitsu.com>
In-Reply-To: <4D09E8AD.60201@cn.fujitsu.com>
X-MIMETrack: Itemize by SMTP Server on mailserver/fnst(Release 8.5.1FP4|July 25, 2010) at
 2010-12-21 17:53:42,
	Serialize by Router on mailserver/fnst(Release 8.5.1FP4|July 25, 2010) at
 2010-12-21 17:53:47,
	Serialize complete at 2010-12-21 17:53:47
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Add test code for checking plist when the kernel is booting.

Signed-off-by:  Lai Jiangshan <laijs@cn.fujitsu.com>
---
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
