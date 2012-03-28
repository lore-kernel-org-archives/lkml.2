Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757657Ab2C1AsE (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Mar 2012 20:48:04 -0400
Received: from mga09.intel.com ([134.134.136.24]:61333 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757531Ab2C1Arm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Mar 2012 20:47:42 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.67,351,1309762800"; 
   d="scan'208";a="125867366"
From: Andi Kleen <andi@firstfloor.org>
To: akpm@linux-foundation.org
Cc: linux-kernel@vger.kernel.org, Andi Kleen <ak@linux.intel.com>
Subject: [PATCH 11/13] Add a discussion on why spin_is_locked() is bad to spinlocks.txt
Date: Tue, 27 Mar 2012 17:47:15 -0700
Message-Id: <1332895637-32572-12-git-send-email-andi@firstfloor.org>
X-Mailer: git-send-email 1.7.7.6
In-Reply-To: <1332895637-32572-1-git-send-email-andi@firstfloor.org>
References: <1332895637-32572-1-git-send-email-andi@firstfloor.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Andi Kleen <ak@linux.intel.com>

Signed-off-by: Andi Kleen <ak@linux.intel.com>
---
 Documentation/spinlocks.txt |   43 +++++++++++++++++++++++++++++++++++++++++++
 1 files changed, 43 insertions(+), 0 deletions(-)

diff --git a/Documentation/spinlocks.txt b/Documentation/spinlocks.txt
index 9dbe885..1787229 100644
--- a/Documentation/spinlocks.txt
+++ b/Documentation/spinlocks.txt
@@ -146,6 +146,49 @@ indeed), while write-locks need to protect themselves against interrupts.
 
 ----
 
+spin_is_locked is a bad idea
+
+spin_is_locked checks if a lock is currently hold.  On uniprocessor kernels
+it always returns 0. In general this function should be avoided because most 
+uses of it are either redundant or broken.
+
+People often use spin_is_locked() to check if a particular lock is hold when a function
+is called to enforce a locking discipline, like
+
+	WARN_ON(!spin_is_locked(!my_lock))
+
+or 
+
+	BUG_ON(!spin_is_locked(!my_lock))
+
+or some variant of those.
+
+This does not work on uniprocessor kernels because they will always fail.
+While there are ways around that they are ugly and not recommended.
+Better use lockdep_assert_held(). This also only checks on a lock debugging
+kernel (which you should occasionally run on your code anyways because
+it catches many more problems). 
+
+In generally this would be better done with static annotation anyways 
+(there's some support for it in sparse)
+
+	BUG_ON(spin_is_locked(obj->lock));
+	kfree(obj);
+
+Another usage is checking whether a lock is not hold when freeing an object.
+However this is redundant because lock debugging supports this anyways
+without explicit code. Just delete the BUG_ON.
+
+A third usage is to check in a console function if a lock is hold, to get
+a panic crash dump out even when some other thread died in it.
+This is better implemented with spin_try_lock() et.al. and a timeout.
+
+Other usages are usually simply races.
+
+In summary just don't use it.
+
+----
+
 Reference information:
 
 For dynamic initialization, use spin_lock_init() or rwlock_init() as
-- 
1.7.7.6

