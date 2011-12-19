Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752223Ab1LSDg1 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 18 Dec 2011 22:36:27 -0500
Received: from e28smtp05.in.ibm.com ([122.248.162.5]:54456 "EHLO
	e28smtp05.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752079Ab1LSDgZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 18 Dec 2011 22:36:25 -0500
Message-ID: <1324265775.25089.20.camel@mengcong>
Subject: [PATCH] VFS: br_write_lock locks on possible CPUs other than online
 CPUs
From: mengcong <mc@linux.vnet.ibm.com>
Reply-To: mc@linux.vnet.ibm.com
To: Alexander Viro <viro@zeniv.linux.org.uk>
Cc: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        Nick Piggin <npiggin@kernel.dk>
Date: Mon, 19 Dec 2011 11:36:15 +0800
Organization: LTC, IBM
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.1- 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
x-cbid: 11121903-8256-0000-0000-0000008AEB35
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

In a heavily loaded system, when frequently turning on and off CPUs, the
kernel will detect soft-lockups on multiple CPUs. The detailed bug report
is at https://lkml.org/lkml/2011/8/24/185.

The root cause is that brlock functions, i.e. br_write_lock() and
br_write_unlock(), only locks/unlocks the per-CPU spinlock of CPUs that
are online, which means, if one online CPU is locked and then goes
offline, any later unlocking operation happens during its offline state
will not touch it; and when it goes online again, it has the incorrect
brlock state. This has been verified in current kernel.

I can reproduce this bug on the intact 3.1 kernel. After my patch applied, 
I've ran an 8-hours long test(test script provided by the bug reporter), 
and no soft lockup happened again.

Signed-off-by: Cong Meng <mc@linux.vnet.ibm.com>
Reported-by: Srivatsa S. Bhat <srivatsa.bhat@linux.vnet.ibm.com>
---
 include/linux/lglock.h |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/include/linux/lglock.h b/include/linux/lglock.h
index f549056..08b9e84 100644
--- a/include/linux/lglock.h
+++ b/include/linux/lglock.h
@@ -27,8 +27,8 @@
 #define br_lock_init(name)	name##_lock_init()
 #define br_read_lock(name)	name##_local_lock()
 #define br_read_unlock(name)	name##_local_unlock()
-#define br_write_lock(name)	name##_global_lock_online()
-#define br_write_unlock(name)	name##_global_unlock_online()
+#define br_write_lock(name)	name##_global_lock()
+#define br_write_unlock(name)	name##_global_unlock()

 #define DECLARE_BRLOCK(name)	DECLARE_LGLOCK(name)
 #define DEFINE_BRLOCK(name)	DEFINE_LGLOCK(name)
-- 
1.7.5.4



