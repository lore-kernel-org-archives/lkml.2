Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758921Ab2CGXjp (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Mar 2012 18:39:45 -0500
Received: from mx1.redhat.com ([209.132.183.28]:8162 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757034Ab2CGXjo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Mar 2012 18:39:44 -0500
Date: Wed, 7 Mar 2012 18:39:39 -0500
From: Dave Jones <davej@redhat.com>
To: Linux Kernel <linux-kernel@vger.kernel.org>
Cc: linux-mm@kvack.org
Subject: decode GFP flags in oom killer output.
Message-ID: <20120307233939.GB5574@redhat.com>
Mail-Followup-To: Dave Jones <davej@redhat.com>,
	Linux Kernel <linux-kernel@vger.kernel.org>, linux-mm@kvack.org
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Decoding these flags by hand in oom reports is tedious,
and error-prone.

Signed-off-by: Dave Jones <davej@redhat.com>

diff -durpN '--exclude-from=/home/davej/.exclude' -u src/git-trees/kernel/linux/include/linux/gfp.h linux-dj/include/linux/gfp.h
--- linux/include/linux/gfp.h	2012-01-11 16:54:21.736395499 -0500
+++ linux-dj/include/linux/gfp.h	2012-03-06 13:17:37.294692113 -0500
@@ -10,6 +10,7 @@
 struct vm_area_struct;
 
 /* Plain integer GFP bitmasks. Do not use this directly. */
+/* Update mm/oom_kill.c gfp_flag_texts when adding to/changing this list */
 #define ___GFP_DMA		0x01u
 #define ___GFP_HIGHMEM		0x02u
 #define ___GFP_DMA32		0x04u
diff -durpN '--exclude-from=/home/davej/.exclude' -u src/git-trees/kernel/linux/mm/oom_kill.c linux-dj/mm/oom_kill.c
--- linux/mm/oom_kill.c	2012-01-17 17:54:14.541881964 -0500
+++ linux-dj/mm/oom_kill.c	2012-03-06 13:17:44.071680535 -0500
@@ -416,13 +416,40 @@ static void dump_tasks(const struct mem_
 	}
 }
 
+static unsigned char *gfp_flag_texts[32] = {
+	"DMA", "HIGHMEM", "DMA32", "MOVABLE",
+	"WAIT", "HIGH", "IO", "FS",
+	"COLD", "NOWARN", "REPEAT", "NOFAIL",
+	"NORETRY", NULL, "COMP", "ZERO",
+	"NOMEMALLOC", "HARDWALL", "THISNODE", "RECLAIMABLE",
+	NULL, "NOTRACK", "NO_KSWAPD", "OTHER_NODE",
+};
+
+static void decode_gfp_mask(gfp_t gfp_mask, char *out_string)
+{
+	unsigned int i;
+
+	for (i = 0; i < 32; i++) {
+		if (gfp_mask & (1 << i)) {
+			if (gfp_flag_texts[i])
+				out_string += sprintf(out_string, "%s ", gfp_flag_texts[i]);
+			else
+				out_string += sprintf(out_string, "reserved! ");
+		}
+	}
+	out_string = "\0";
+}
+
 static void dump_header(struct task_struct *p, gfp_t gfp_mask, int order,
 			struct mem_cgroup *memcg, const nodemask_t *nodemask)
 {
+	char gfp_string[80];
 	task_lock(current);
-	pr_warning("%s invoked oom-killer: gfp_mask=0x%x, order=%d, "
+	decode_gfp_mask(gfp_mask, gfp_string);
+	pr_warning("%s invoked oom-killer: gfp_mask=0x%x [%s], order=%d, "
 		"oom_adj=%d, oom_score_adj=%d\n",
-		current->comm, gfp_mask, order, current->signal->oom_adj,
+		current->comm, gfp_mask, gfp_string,
+		order, current->signal->oom_adj,
 		current->signal->oom_score_adj);
 	cpuset_print_task_mems_allowed(current);
 	task_unlock(current);

