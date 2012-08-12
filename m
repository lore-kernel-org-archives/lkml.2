Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752041Ab2HLKCk (ORCPT <rfc822;w@1wt.eu>);
	Sun, 12 Aug 2012 06:02:40 -0400
Received: from gerard.telenet-ops.be ([195.130.132.48]:43326 "EHLO
	gerard.telenet-ops.be" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751539Ab2HLKBn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 12 Aug 2012 06:01:43 -0400
From: Geert Uytterhoeven <geert@linux-m68k.org>
To: linux-arch@vger.kernel.org, linux-kernel@vger.kernel.org
Cc: Geert Uytterhoeven <geert@linux-m68k.org>,
        Martin Schwidefsky <schwidefsky@de.ibm.com>,
        Heiko Carstens <heiko.carstens@de.ibm.com>, linux-s390@vger.kernel.org
Subject: [PATCH 2/2] s390: Always use "long" for ssize_t to match size_t
Date: Sun, 12 Aug 2012 12:01:34 +0200
Message-Id: <1344765694-7465-2-git-send-email-geert@linux-m68k.org>
X-Mailer: git-send-email 1.7.0.4
In-Reply-To: <1344765694-7465-1-git-send-email-geert@linux-m68k.org>
References: <1344765694-7465-1-git-send-email-geert@linux-m68k.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On s390x-linux-gcc, __SIZE_TYPE__ expands to "long unsigned int" for both
32-bit s390 and 64-bit s390x, as
gcc-4.6.3-nolibc/s390x-linux/lib/gcc/s390x-linux/4.6.3/plugin/include/config/s390/linux.h
has

    #define SIZE_TYPE (TARGET_64BIT ? "long unsigned int" : "long unsigned int")

To match this, __kernel_size_t is always set to "long unsigned int".

But while __kernel_ssize_t is "long" on 64-bit s390x, it is "int" on 32-bit
s390, causing compiler warnings like:

    fs/quota/quota_tree.c:372:4: warning: format '%zd' expects argument of type 'signed size_t', but argument 4 has type 'ssize_t' [-Wformat]

To fix this, __kernel_ssize_t should be "long", irrespective of word size.

Signed-off-by: Geert Uytterhoeven <geert@linux-m68k.org>
Cc: Martin Schwidefsky <schwidefsky@de.ibm.com>
Cc: Heiko Carstens <heiko.carstens@de.ibm.com>
Cc: linux-s390@vger.kernel.org
---
 arch/s390/include/asm/posix_types.h |    3 +--
 1 files changed, 1 insertions(+), 2 deletions(-)

diff --git a/arch/s390/include/asm/posix_types.h b/arch/s390/include/asm/posix_types.h
index 7bcc14e..bf2a2ad 100644
--- a/arch/s390/include/asm/posix_types.h
+++ b/arch/s390/include/asm/posix_types.h
@@ -13,6 +13,7 @@
  */
 
 typedef unsigned long   __kernel_size_t;
+typedef long            __kernel_ssize_t;
 #define __kernel_size_t __kernel_size_t
 
 typedef unsigned short	__kernel_old_dev_t;
@@ -25,7 +26,6 @@ typedef unsigned short  __kernel_mode_t;
 typedef unsigned short  __kernel_ipc_pid_t;
 typedef unsigned short  __kernel_uid_t;
 typedef unsigned short  __kernel_gid_t;
-typedef int             __kernel_ssize_t;
 typedef int             __kernel_ptrdiff_t;
 
 #else /* __s390x__ */
@@ -35,7 +35,6 @@ typedef unsigned int    __kernel_mode_t;
 typedef int             __kernel_ipc_pid_t;
 typedef unsigned int    __kernel_uid_t;
 typedef unsigned int    __kernel_gid_t;
-typedef long            __kernel_ssize_t;
 typedef long            __kernel_ptrdiff_t;
 typedef unsigned long   __kernel_sigset_t;      /* at least 32 bits */
 
-- 
1.7.0.4

