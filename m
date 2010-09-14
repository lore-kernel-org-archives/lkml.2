Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755314Ab0INTze (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Sep 2010 15:55:34 -0400
Received: from moutng.kundenserver.de ([212.227.126.171]:57153 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755213Ab0INTz3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Sep 2010 15:55:29 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: linux-kernel@vger.kernel.org
Subject: [PATCH 17/18] rtmutex-tester: make it build without BKL
Date: Tue, 14 Sep 2010 21:55:23 +0200
Message-Id: <1284494124-7384-8-git-send-email-arnd@arndb.de>
X-Mailer: git-send-email 1.7.1
In-Reply-To: <1284493213-7263-1-git-send-email-arnd@arndb.de>
References: <1284493213-7263-1-git-send-email-arnd@arndb.de>
X-Provags-ID: V02:K0:rofTKGh+2gykNR4EKLfhL+n+5BMO+/q1jhF0wSkcdx9
 OpcGxHPm/IG8HW2eNksFSLOCOKW9Z9L9DAuqA7YO4WI9D9tRz/
 0zFMUEouyEygfe17KXNOPOxJHjRTA9tJE8AHWtisG+uVe9g9vy
 jZniWXIYdKk8kJ1+v0gX2nmPIHA17MY3fv1pCNCR5s3VfLV/eU
 8EGxeQrz1dNEdtJ2PUW9w==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The big kernel lock is going away, so make sure
that if it is disabled by Kconfig, we do not
try to validate it, which would result in
compile errors.

Signed-off-by: Arnd Bergmann <arnd@arndb.de>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Arjan van de Ven <arjan@linux.intel.com>
Cc: Andrew Morton <akpm@linux-foundation.org>
---
 kernel/rtmutex-tester.c |    6 ++++++
 1 files changed, 6 insertions(+), 0 deletions(-)

diff --git a/kernel/rtmutex-tester.c b/kernel/rtmutex-tester.c
index a56f629..66cb89b 100644
--- a/kernel/rtmutex-tester.c
+++ b/kernel/rtmutex-tester.c
@@ -76,7 +76,9 @@ static int handle_op(struct test_thread_data *td, int lockwakeup)
 		}
 
 		if (!lockwakeup && td->bkl == 4) {
+#ifdef CONFIG_LOCK_KERNEL
 			unlock_kernel();
+#endif
 			td->bkl = 0;
 		}
 		return 0;
@@ -133,14 +135,18 @@ static int handle_op(struct test_thread_data *td, int lockwakeup)
 		if (td->bkl)
 			return 0;
 		td->bkl = 1;
+#ifdef CONFIG_LOCK_KERNEL
 		lock_kernel();
+#endif
 		td->bkl = 4;
 		return 0;
 
 	case RTTEST_UNLOCKBKL:
 		if (td->bkl != 4)
 			break;
+#ifdef CONFIG_LOCK_KERNEL
 		unlock_kernel();
+#endif
 		td->bkl = 0;
 		return 0;
 
-- 
1.7.1

