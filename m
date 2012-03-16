Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756164Ab2CPTBR (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Mar 2012 15:01:17 -0400
Received: from mga09.intel.com ([134.134.136.24]:20115 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755795Ab2CPTBM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Mar 2012 15:01:12 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.67,352,1309762800"; 
   d="scan'208";a="118439720"
From: Andi Kleen <andi@firstfloor.org>
To: linux-kernel@vger.kernel.org
Cc: Andi Kleen <ak@linux.intel.com>, Andy Whitcroft <apw@canonical.com>
Subject: [PATCH 11/11] checkpatch: Check for spin_is_locked
Date: Fri, 16 Mar 2012 12:01:04 -0700
Message-Id: <1331924464-18023-12-git-send-email-andi@firstfloor.org>
X-Mailer: git-send-email 1.7.7.6
In-Reply-To: <1331924464-18023-1-git-send-email-andi@firstfloor.org>
References: <1331924464-18023-1-git-send-email-andi@firstfloor.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Andi Kleen <ak@linux.intel.com>

spin_is_locked is usually misued. In checkpatch.pl

- warn when it is used at all
- error out when it is asserted on free, because that's usually broken
(e.g. doesn't work on on uni processor builds). Recommend
lockdep_assert_held() instead.

Cc: Andy Whitcroft <apw@canonical.com>
Signed-off-by: Andi Kleen <ak@linux.intel.com>
---
 scripts/checkpatch.pl |   14 ++++++++++++++
 1 files changed, 14 insertions(+), 0 deletions(-)

diff --git a/scripts/checkpatch.pl b/scripts/checkpatch.pl
index a3b9782..9904547 100755
--- a/scripts/checkpatch.pl
+++ b/scripts/checkpatch.pl
@@ -3330,6 +3330,20 @@ sub process {
 			}
 		}
 
+# spin_is_locked is usually misused. warn about it.
+		if ($line =~ /\bspin_is_locked\s*\(/) {
+			# BUG_ON/WARN_ON(!spin_is_locked() is generally a bug
+			if ($line =~ /(BUG_ON|WARN_ON|ASSERT)\s*\(!spin_is_locked/) {
+				ERROR("ASSERT_SPIN_IS_LOCKED",
+				     "Use lockdep_assert_held() instead of asserts on !spin_is_locked\n"
+				      . $herecurr);
+			} else {
+				WARN("SPIN_IS_LOCKED",
+				     "spin_is_locked is very rarely correctly used. Please reconsider\n"
+					. $herecurr)
+			}
+		}
+
 # check for lockdep_set_novalidate_class
 		if ($line =~ /^.\s*lockdep_set_novalidate_class\s*\(/ ||
 		    $line =~ /__lockdep_no_validate__\s*\)/ ) {
-- 
1.7.7.6

