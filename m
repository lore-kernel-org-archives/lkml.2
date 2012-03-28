Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757782Ab2C1As0 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Mar 2012 20:48:26 -0400
Received: from mga09.intel.com ([134.134.136.24]:51417 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755999Ab2C1Arm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Mar 2012 20:47:42 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.67,351,1309762800"; 
   d="scan'208";a="125867368"
From: Andi Kleen <andi@firstfloor.org>
To: akpm@linux-foundation.org
Cc: linux-kernel@vger.kernel.org, Andi Kleen <ak@linux.intel.com>,
        Andy Whitcroft <apw@canonical.com>
Subject: [PATCH 13/13] checkpatch: Check for spin_is_locked
Date: Tue, 27 Mar 2012 17:47:17 -0700
Message-Id: <1332895637-32572-14-git-send-email-andi@firstfloor.org>
X-Mailer: git-send-email 1.7.7.6
In-Reply-To: <1332895637-32572-1-git-send-email-andi@firstfloor.org>
References: <1332895637-32572-1-git-send-email-andi@firstfloor.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Andi Kleen <ak@linux.intel.com>

spin_is_locked is usually misued. In checkpatch.pl

- warn when it is used at all
- error out when it is asserted on free, because that's usually broken
(e.g. doesn't work on on uni processor builds). Recommend
lockdep_assert_held() instead.

v2: improvements from Joe Perches
Cc: Andy Whitcroft <apw@canonical.com>
Signed-off-by: Andi Kleen <ak@linux.intel.com>
---
 scripts/checkpatch.pl |   14 ++++++++++++++
 1 files changed, 14 insertions(+), 0 deletions(-)

diff --git a/scripts/checkpatch.pl b/scripts/checkpatch.pl
index a3b9782..002bce3 100755
--- a/scripts/checkpatch.pl
+++ b/scripts/checkpatch.pl
@@ -3330,6 +3330,20 @@ sub process {
 			}
 		}
 
+# spin_is_locked is usually misused. warn about it.
+		if ($line =~ /\bspin_is_locked\s*\(/) {
+			# BUG_ON/WARN_ON(!spin_is_locked() is generally a bug
+			if ($line =~ /(BUG_ON|WARN_ON|ASSERT)\s*\(!spin_is_locked/) {
+				ERROR("SPIN_IS_LOCKED",
+				     "Use lockdep_assert_held() instead of asserts on !spin_is_locked\n"
+				      . $herecurr);
+			} else {
+				WARN("SPIN_IS_LOCKED",
+			     "spin_is_locked is usually misused. See Documentation/spinlocks.txt\n"
+					. $herecurr)
+			}
+		}
+
 # check for lockdep_set_novalidate_class
 		if ($line =~ /^.\s*lockdep_set_novalidate_class\s*\(/ ||
 		    $line =~ /__lockdep_no_validate__\s*\)/ ) {
-- 
1.7.7.6

