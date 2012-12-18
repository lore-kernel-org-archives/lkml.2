Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755384Ab2LRVvU (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Dec 2012 16:51:20 -0500
Received: from e31.co.us.ibm.com ([32.97.110.149]:43638 "EHLO
	e31.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754569Ab2LRVvR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Dec 2012 16:51:17 -0500
From: Corey Bryant <coreyb@linux.vnet.ibm.com>
To: linux-kernel@vger.kernel.org
Cc: linux-security-module@vger.kernel.org, jmorris@namei.org, wad@chromium.org,
        pmoore@redhat.com, otubo@linux.vnet.ibm.com
Subject: [PATCH 1/3] seccomp: Add SECCOMP_RET_INFO return value
Date: Tue, 18 Dec 2012 16:50:47 -0500
Message-Id: <1355867449-3209-1-git-send-email-coreyb@linux.vnet.ibm.com>
X-Mailer: git-send-email 1.7.11.7
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 12121821-7282-0000-0000-00001233AA39
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Adds a new return value to seccomp filters that causes an
informational kernel message to be printed.  The message
includes the system call number.

This can be used to learn the system calls that a process
is using.

Signed-off-by: Corey Bryant <coreyb@linux.vnet.ibm.com>
---
 include/uapi/linux/seccomp.h | 1 +
 kernel/seccomp.c             | 4 ++++
 2 files changed, 5 insertions(+)

diff --git a/include/uapi/linux/seccomp.h b/include/uapi/linux/seccomp.h
index ac2dc9f..0086626 100644
--- a/include/uapi/linux/seccomp.h
+++ b/include/uapi/linux/seccomp.h
@@ -22,6 +22,7 @@
 #define SECCOMP_RET_TRAP	0x00030000U /* disallow and force a SIGSYS */
 #define SECCOMP_RET_ERRNO	0x00050000U /* returns an errno */
 #define SECCOMP_RET_TRACE	0x7ff00000U /* pass to a tracer or disallow */
+#define SECCOMP_RET_INFO	0x7ff70000U /* print info message and allow */
 #define SECCOMP_RET_ALLOW	0x7fff0000U /* allow */
 
 /* Masks for the return value sections. */
diff --git a/kernel/seccomp.c b/kernel/seccomp.c
index 5af44b5..854f628 100644
--- a/kernel/seccomp.c
+++ b/kernel/seccomp.c
@@ -433,6 +433,10 @@ int __secure_computing(int this_syscall)
 				goto skip;  /* Explicit request to skip. */
 
 			return 0;
+		case SECCOMP_RET_INFO:
+			if (printk_ratelimit())
+				pr_info("seccomp: syscall=%d\n", this_syscall);
+			return 0;
 		case SECCOMP_RET_ALLOW:
 			return 0;
 		case SECCOMP_RET_KILL:
-- 
1.7.11.7

