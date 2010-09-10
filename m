Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755119Ab0IJXnx (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Sep 2010 19:43:53 -0400
Received: from hera.kernel.org ([140.211.167.34]:56896 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750997Ab0IJXnv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Sep 2010 19:43:51 -0400
Date: Fri, 10 Sep 2010 23:43:28 GMT
From: tip-bot for Venkatesh Pallipadi <venki@google.com>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
        suresh.b.siddha@intel.com, tglx@linutronix.de, hpa@linux.intel.com,
        venki@google.com
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
        suresh.b.siddha@intel.com, tglx@linutronix.de, hpa@linux.intel.com,
        venki@google.com
In-Reply-To: <1284159350-19841-2-git-send-email-venki@google.com>
References: <1284159350-19841-2-git-send-email-venki@google.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:x86/mtrr] x86, mtrr: Refactor MTRR type overlap check code
Message-ID: <tip-a7f07cfbaa1dd5bf9e615948f280c92e7928e6f7@git.kernel.org>
Git-Commit-ID: a7f07cfbaa1dd5bf9e615948f280c92e7928e6f7
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Fri, 10 Sep 2010 23:43:29 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  a7f07cfbaa1dd5bf9e615948f280c92e7928e6f7
Gitweb:     http://git.kernel.org/tip/a7f07cfbaa1dd5bf9e615948f280c92e7928e6f7
Author:     Venkatesh Pallipadi <venki@google.com>
AuthorDate: Fri, 10 Sep 2010 15:55:49 -0700
Committer:  H. Peter Anvin <hpa@linux.intel.com>
CommitDate: Fri, 10 Sep 2010 16:11:10 -0700

x86, mtrr: Refactor MTRR type overlap check code

Move the MTRR type overlap check into a new function. No functional change in
this patch. Just making it easier to add multiple region overlap check in
the following patch.

Signed-off-by: Venkatesh Pallipadi <venki@google.com>
LKML-Reference: <1284159350-19841-2-git-send-email-venki@google.com>
Reviewed-by: Suresh Siddha <suresh.b.siddha@intel.com>
Signed-off-by: H. Peter Anvin <hpa@linux.intel.com>
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
