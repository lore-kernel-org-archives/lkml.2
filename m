Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754825Ab2A0CpT (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Jan 2012 21:45:19 -0500
Received: from mail.windriver.com ([147.11.1.11]:53814 "EHLO
	mail.windriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754729Ab2A0CpM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Jan 2012 21:45:12 -0500
From: Paul Gortmaker <paul.gortmaker@windriver.com>
To: torvalds@linux-foundation.org, akpm@linux-foundation.org, gregkh@suse.de,
        rmk+kernel@arm.linux.org.uk
Cc: linux-arch@vger.kernel.org, linux-kernel@vger.kernel.org,
        Paul Gortmaker <paul.gortmaker@windriver.com>,
        Thomas Gleixner <tglx@linutronix.de>
Subject: [PATCH 2/7] spinlock: macroize assert_spin_locked to avoid bug.h dependency
Date: Thu, 26 Jan 2012 21:44:27 -0500
Message-Id: <1327632272-12928-3-git-send-email-paul.gortmaker@windriver.com>
X-Mailer: git-send-email 1.7.7.2
In-Reply-To: <1327632272-12928-1-git-send-email-paul.gortmaker@windriver.com>
References: <1327632272-12928-1-git-send-email-paul.gortmaker@windriver.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

In spinlock_api_smp.h we find a define for assert_raw_spin_locked
[which uses BUG_ON].   Then assert_spin_locked (as an inline) uses
it, meaning we need bug.h  But rather than put linux/bug.h in such
a highly used file like spinlock.h, we can just make the un-raw
version also a macro.  Then the required bug.h presence is limited
just to those few files who are actually doing the assert testing.

Signed-off-by: Paul Gortmaker <paul.gortmaker@windriver.com>
CC: Thomas Gleixner <tglx@linutronix.de>
---
 include/linux/spinlock.h |    5 +----
 1 files changed, 1 insertions(+), 4 deletions(-)

diff --git a/include/linux/spinlock.h b/include/linux/spinlock.h
index 7df6c17..3632390 100644
--- a/include/linux/spinlock.h
+++ b/include/linux/spinlock.h
@@ -375,10 +375,7 @@ static inline int spin_can_lock(spinlock_t *lock)
 	return raw_spin_can_lock(&lock->rlock);
 }
 
-static inline void assert_spin_locked(spinlock_t *lock)
-{
-	assert_raw_spin_locked(&lock->rlock);
-}
+#define assert_spin_locked(lock)	assert_raw_spin_locked(&(lock)->rlock)
 
 /*
  * Pull the atomic_t declaration:
-- 
1.7.7.2

