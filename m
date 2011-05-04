Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753034Ab1EDJmE (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 May 2011 05:42:04 -0400
Received: from mx1.redhat.com ([209.132.183.28]:18480 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752870Ab1EDJmA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 May 2011 05:42:00 -0400
From: Jiri Olsa <jolsa@redhat.com>
To: jbaron@redhat.com, rostedt@goodmis.org, mingo@elte.hu
Cc: linux-kernel@vger.kernel.org, Jiri Olsa <jolsa@redhat.com>
Subject: [PATCHv2 2/2] jump_label,x86: using static arrays before dynamic allocation is needed
Date: Wed,  4 May 2011 11:41:43 +0200
Message-Id: <1304502103-3228-3-git-send-email-jolsa@redhat.com>
In-Reply-To: <1304502103-3228-1-git-send-email-jolsa@redhat.com>
References: <1304023961-12741-1-git-send-email-jolsa@redhat.com>
 <1304502103-3228-1-git-send-email-jolsa@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Originally the queue array, which stores jump_label entries is
allocated/resized dynamically.

Due to the fact that many jump_label entries have low number
of callers, it seems appropriate to use static sized array
when the update starts and if needed (in case of high number
of jump_label entries) allocate/use the dynamic array.

The initial value of POKE_STATIC_CNT is set to 10.
This value is based on entries count for keys distribution
that I've got on Fedora kernel config and my current kernel
config.

Most of the keys have up to 10 entries, with few exceptions.

 # entries   # keys
 ------------------
 Fedora:
     1         201
     2           6
     3           1
     4           1
    82           1
 Mine:
     1         113
     2           6
     3           4
     4           1
     5           1
     8           1
    20           1
    69           1

Tested this on x86 and s390 archs.


Signed-off-by: Jiri Olsa <jolsa@redhat.com>
---
 arch/x86/kernel/jump_label.c |   73 +++++++++++++++++++++++++++++++++++-------
 1 files changed, 61 insertions(+), 12 deletions(-)

diff --git a/arch/x86/kernel/jump_label.c b/arch/x86/kernel/jump_label.c
index 7a4dd32..15f3a46 100644
--- a/arch/x86/kernel/jump_label.c
+++ b/arch/x86/kernel/jump_label.c
@@ -30,9 +30,19 @@ struct text_poke_buffer {
 };
 
 #define POKE_ALLOC_CNT 30
+#define POKE_STATIC_CNT 10
+#define IS_STATIC(cnt) ((cnt) < POKE_STATIC_CNT)
+#define WAS_STATIC(cnt) IS_STATIC(cnt - 1)
 
-static struct text_poke_param  *poke_pars;
-static struct text_poke_buffer *poke_bufs;
+static struct text_poke_param  poke_pars_static[POKE_STATIC_CNT];
+static struct text_poke_buffer poke_bufs_static[POKE_STATIC_CNT];
+
+/*
+ * Initially we start with static array and switch to dynamic
+ * once we reach POKE_STATIC_CNT number of entries
+ */
+static struct text_poke_param  *poke_pars = poke_pars_static;
+static struct text_poke_buffer *poke_bufs = poke_bufs_static;
 static int poke_cnt, poke_size;
 
 static void poke_setup(struct text_poke_param *param, u8 *buf,
@@ -58,7 +68,19 @@ static int poke_alloc(void)
 	struct text_poke_param  *pars;
 	struct text_poke_buffer *bufs;
 
-	if (poke_cnt % POKE_ALLOC_CNT)
+	/* So far, so static.. nothing to allocate. */
+	if (IS_STATIC(poke_cnt))
+		return 0;
+
+	/*
+	 * We just hit dynamic allocation count, so let's go through
+	 * and allocate the first round.
+	 * Otherwise return if we are inside the dynamic allocation.
+	 */
+	if (WAS_STATIC(poke_cnt)) {
+		poke_pars = NULL;
+		poke_bufs = NULL;
+	} else if (poke_cnt % POKE_ALLOC_CNT)
 		return 0;
 
 	poke_size += POKE_ALLOC_CNT;
@@ -66,28 +88,55 @@ static int poke_alloc(void)
 	pars = krealloc(poke_pars, poke_size * sizeof(*pars),
 			GFP_KERNEL);
 	if (!pars)
-		return -ENOMEM;
+		goto out_nomem;
 
 	bufs = krealloc(poke_bufs, poke_size * sizeof(*bufs),
 			GFP_KERNEL);
-	if (!bufs) {
-		kfree(pars);
-		return -ENOMEM;
-	}
+	if (!bufs)
+		goto out_nomem;
 
 	poke_pars = pars;
 	poke_bufs = bufs;
+
+	/*
+	 * If we just started dynamic allocation, copy the static
+	 * contents to new fresh dynamic array.
+	 */
+	if (WAS_STATIC(poke_cnt)) {
+		memcpy(poke_pars, poke_pars_static, sizeof(poke_pars_static));
+		memcpy(poke_bufs, poke_bufs_static, sizeof(poke_bufs_static));
+	}
 	return 0;
+
+ out_nomem:
+	kfree(pars);
+
+	if (WAS_STATIC(poke_cnt)) {
+		poke_pars = poke_pars_static;
+		poke_bufs = poke_bufs_static;
+	}
+	return -ENOMEM;
 }
 
 static void poke_free(void)
 {
-	kfree(poke_pars);
-	kfree(poke_bufs);
+	/*
+	 * Using WAS_STATIC, since poke_cnt was already incremented
+	 * for the last element.
+	 */
+	if (!WAS_STATIC(poke_cnt)) {
+		kfree(poke_pars);
+		kfree(poke_bufs);
+	}
 
 	poke_cnt = poke_size = 0;
-	poke_pars = NULL;
-	poke_bufs = NULL;
+
+	/*
+	 * Going from the start again, initialize to
+	 * static array.
+	 */
+	poke_pars = poke_pars_static;
+	poke_bufs = poke_bufs_static;
 }
 
 static void poke_process(struct text_poke_param *par, int cnt)
-- 
1.7.1

