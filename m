Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753388Ab0G0UzG (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Jul 2010 16:55:06 -0400
Received: from mx1.redhat.com ([209.132.183.28]:7999 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752943Ab0G0UzB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Jul 2010 16:55:01 -0400
Date: Tue, 27 Jul 2010 16:54:36 -0400
From: Jason Baron <jbaron@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: mingo@elte.hu, mathieu.desnoyers@polymtl.ca, hpa@zytor.com,
        tglx@linutronix.de, rostedt@goodmis.org, andi@firstfloor.org,
        roland@redhat.com, rth@redhat.com, mhiramat@redhat.com,
        fweisbec@gmail.com, avi@redhat.com, davem@davemloft.net,
        vgoyal@redhat.com, sam@ravnborg.org, tony@bakeyournoodle.com
Message-Id: <59e3532f43294252ff34468bbbf0444c589f0956.1280263065.git.jbaron@redhat.com>
In-Reply-To: <cover.1280263065.git.jbaron@redhat.com>
References: <cover.1280263065.git.jbaron@redhat.com>
Subject: [PATCH 07/12] jump label v10: use lib/sort.c
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Make use of the the kernel's generic sort routines.

Signed-off-by: Jason Baron <jbaron@redhat.com>
---
 kernel/jump_label.c |   37 ++++++++++++++++---------------------
 1 files changed, 16 insertions(+), 21 deletions(-)

diff --git a/kernel/jump_label.c b/kernel/jump_label.c
index 10fb17f..faef97e 100644
--- a/kernel/jump_label.c
+++ b/kernel/jump_label.c
@@ -12,6 +12,7 @@
 #include <linux/jhash.h>
 #include <linux/slab.h>
 #include <linux/err.h>
+#include <linux/sort.h>
 
 #ifdef HAVE_JUMP_LABEL
 
@@ -38,33 +39,27 @@ struct jump_label_module_entry {
 	struct module *mod;
 };
 
-static void swap_jump_label_entries(struct jump_entry *previous, struct jump_entry *next)
+static int jump_label_cmp(const void *a, const void *b)
 {
-	struct jump_entry tmp;
+	const struct jump_entry *jea = a;
+	const struct jump_entry *jeb = b;
 
-	tmp = *next;
-	*next = *previous;
-	*previous = tmp;
+	if (jea->key < jeb->key)
+		return -1;
+
+	if (jea->key > jeb->key)
+		return 1;
+
+	return 0;
 }
 
 static void sort_jump_label_entries(struct jump_entry *start, struct jump_entry *stop)
 {
-	int swapped = 0;
-	struct jump_entry *iter;
-	struct jump_entry *iter_next;
-
-	do {
-		swapped = 0;
-		iter = start;
-		iter_next = start;
-		iter_next++;
-		for (; iter_next < stop; iter++, iter_next++) {
-			if (iter->key > iter_next->key) {
-				swap_jump_label_entries(iter, iter_next);
-				swapped = 1;
-			}
-		}
-	} while (swapped == 1);
+	unsigned long size;
+
+	size = (((unsigned long)stop - (unsigned long)start)
+					/ sizeof(struct jump_entry));
+	sort(start, size, sizeof(struct jump_entry), jump_label_cmp, NULL);
 }
 
 static struct jump_label_entry *get_jump_label_entry(jump_label_t key)
-- 
1.7.1

