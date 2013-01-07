Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754415Ab3AGRN5 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Jan 2013 12:13:57 -0500
Received: from e7.ny.us.ibm.com ([32.97.182.137]:59724 "EHLO e7.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753141Ab3AGRN4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Jan 2013 12:13:56 -0500
From: Corey Bryant <coreyb@linux.vnet.ibm.com>
To: linux-kernel@vger.kernel.org
Cc: linux-security-module@vger.kernel.org, jmorris@namei.org, wad@chromium.org,
        pmoore@redhat.com, otubo@linux.vnet.ibm.com
Subject: [PATCH v2 1/3] seccomp: Add SECCOMP_RET_INFO return value
Date: Mon,  7 Jan 2013 12:09:03 -0500
Message-Id: <1357578545-2396-1-git-send-email-coreyb@linux.vnet.ibm.com>
X-Mailer: git-send-email 1.7.11.7
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13010717-5806-0000-0000-00001DE5F519
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Adds a new return value to seccomp filters that causes an
informational kernel message to be printed.  The message
includes the system call number and architecture.

This can be used to learn the system calls that a process
is using.

Signed-off-by: Corey Bryant <coreyb@linux.vnet.ibm.com>
---
v2:
  - Add arch to message (wad@chromium.org)

 include/uapi/linux/seccomp.h | 1 +
 kernel/seccomp.c             | 6 ++++++
 2 files changed, 7 insertions(+)

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
index 5af44b5..954bb40 100644
--- a/kernel/seccomp.c
+++ b/kernel/seccomp.c
@@ -433,6 +433,12 @@ int __secure_computing(int this_syscall)
 				goto skip;  /* Explicit request to skip. */
 
 			return 0;
+		case SECCOMP_RET_INFO:
+			if (printk_ratelimit())
+				pr_info("seccomp: syscall=%d, arch=0x%X\n",
+					this_syscall,
+					syscall_get_arch(current, regs));
+			return 0;
 		case SECCOMP_RET_ALLOW:
 			return 0;
 		case SECCOMP_RET_KILL:
-- 
1.7.11.7

