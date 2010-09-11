Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753577Ab0IKBQN (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Sep 2010 21:16:13 -0400
Received: from smtp-out.google.com ([74.125.121.35]:63059 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750974Ab0IKBQB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Sep 2010 21:16:01 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:
	references:x-system-of-record;
	b=Blh+1ZWaTSYGMwwgGsP2GWPK2FmX/ouvCCSfMWKxmWRxyCFrdxUQrfp5aGh9eHeZq
	ic7L6S4m8fruZX2YGjMwg==
From: Venkatesh Pallipadi <venki@google.com>
To: Ingo Molnar <mingo@elte.hu>, "H. Peter Anvin" <hpa@zytor.com>,
        Thomas Gleixner <tglx@linutronix.de>, Yinghai Lu <yinghai@kernel.org>
Cc: Suresh Siddha <suresh.b.siddha@intel.com>,
        Mark Langsdorf <mark.langsdorf@amd.com>, linux-kernel@vger.kernel.org,
        Venkatesh Pallipadi <venki@google.com>
Subject: [PATCH 1/2] x86: refactor MTRR type overlap check code
Date: Fri, 10 Sep 2010 18:15:32 -0700
Message-Id: <1284167733-2683-2-git-send-email-venki@google.com>
X-Mailer: git-send-email 1.7.1
In-Reply-To: <1284167733-2683-1-git-send-email-venki@google.com>
References: <1284167733-2683-1-git-send-email-venki@google.com>
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Move the MTRR type overlap check into a new function. No functional change in
this patch. Just making it easier to add multiple region overlap check in
the following patch.

Signed-off-by: Venkatesh Pallipadi <venki@google.com>
Reviewed-by: Suresh Siddha <suresh.b.siddha@intel.com>

---
 arch/x86/kernel/cpu/mtrr/generic.c |   44 +++++++++++++++++++++++------------
 1 files changed, 29 insertions(+), 15 deletions(-)

diff --git a/arch/x86/kernel/cpu/mtrr/generic.c b/arch/x86/kernel/cpu/mtrr/generic.c
index 7d28d7d..14f4f0c 100644
--- a/arch/x86/kernel/cpu/mtrr/generic.c
+++ b/arch/x86/kernel/cpu/mtrr/generic.c
@@ -65,6 +65,33 @@ static inline void k8_check_syscfg_dram_mod_en(void)
 }
 
 /*
+ * Check and return the effective type for MTRR-MTRR type overlap.
+ * Returns 1 if the effective type is UNCACHEABLE, else returns 0
+ */
+static int check_type_overlap(u8 *prev, u8 *curr)
+{
+	if (*prev == MTRR_TYPE_UNCACHABLE || *curr == MTRR_TYPE_UNCACHABLE) {
+		*prev = MTRR_TYPE_UNCACHABLE;
+		*curr = MTRR_TYPE_UNCACHABLE;
+		return 1;
+	}
+
+	if ((*prev == MTRR_TYPE_WRBACK && *curr == MTRR_TYPE_WRTHROUGH) ||
+	    (*prev == MTRR_TYPE_WRTHROUGH && *curr == MTRR_TYPE_WRBACK)) {
+		*prev = MTRR_TYPE_WRTHROUGH;
+		*curr = MTRR_TYPE_WRTHROUGH;
+	}
+
+	if (*prev != *curr) {
+		*prev = MTRR_TYPE_UNCACHABLE;
+		*curr = MTRR_TYPE_UNCACHABLE;
+		return 1;
+	}
+
+	return 0;
+}
+
+/*
  * Returns the effective MTRR type for the region
  * Error returns:
  * - 0xFE - when the range is "not entirely covered" by _any_ var range MTRR
@@ -138,21 +165,8 @@ u8 mtrr_type_lookup(u64 start, u64 end)
 			continue;
 		}
 
-		if (prev_match == MTRR_TYPE_UNCACHABLE ||
-		    curr_match == MTRR_TYPE_UNCACHABLE) {
-			return MTRR_TYPE_UNCACHABLE;
-		}
-
-		if ((prev_match == MTRR_TYPE_WRBACK &&
-		     curr_match == MTRR_TYPE_WRTHROUGH) ||
-		    (prev_match == MTRR_TYPE_WRTHROUGH &&
-		     curr_match == MTRR_TYPE_WRBACK)) {
-			prev_match = MTRR_TYPE_WRTHROUGH;
-			curr_match = MTRR_TYPE_WRTHROUGH;
-		}
-
-		if (prev_match != curr_match)
-			return MTRR_TYPE_UNCACHABLE;
+		if (check_type_overlap(&prev_match, &curr_match))
+			return curr_match;
 	}
 
 	if (mtrr_tom2) {
-- 
1.7.1

