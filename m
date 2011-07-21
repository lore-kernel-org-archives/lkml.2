Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753016Ab1GUMx5 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Jul 2011 08:53:57 -0400
Received: from mail-ew0-f46.google.com ([209.85.215.46]:38626 "EHLO
	mail-ew0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752980Ab1GUMxv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Jul 2011 08:53:51 -0400
From: Vasiliy Kulikov <segoon@openwall.com>
To: linux-kernel@vger.kernel.org
Cc: Andrew Morton <akpm@linux-foundation.org>,
        Greg Kroah-Hartman <gregkh@suse.de>,
        David Howells <dhowells@redhat.com>, Jan Kara <jack@suse.cz>,
        Al Viro <viro@zeniv.linux.org.uk>, Ingo Molnar <mingo@elte.hu>,
        linux-mm@kvack.org, Thomas Gleixner <tglx@linutronix.de>
Subject: [RFC v3 4/5] char: mem: relax usercopy checks
Date: Thu, 21 Jul 2011 16:53:45 +0400
Message-Id: <1311252825-6840-1-git-send-email-segoon@openwall.com>
X-Mailer: git-send-email 1.7.0.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

RUNTIME_USER_COPY_CHECK restricts copy_*_user() to deny stack and slab
buffer overflows.  However, it is redundant for copying memory via
/dev/mem and /dev/kmem.  With STRICT_DEVMEM=n it should be possible to
copy any kernel memory without the checks.  So, use unchecked versions
of copy_*_user().

Include <linux/uaccess-check.h> is needed for architectures not yet
implementing DEBUG_RUNTIME_USER_COPY_CHECKS.

v3 - Simplified addition of new architectures.

Signed-off-by: Vasiliy Kulikov <segoon@openwall.com>
---
 drivers/char/mem.c |    9 +++++----
 1 files changed, 5 insertions(+), 4 deletions(-)

diff --git a/drivers/char/mem.c b/drivers/char/mem.c
index 8fc04b4..39e4aba 100644
--- a/drivers/char/mem.c
+++ b/drivers/char/mem.c
@@ -26,6 +26,7 @@
 #include <linux/bootmem.h>
 #include <linux/splice.h>
 #include <linux/pfn.h>
+#include <linux/uaccess-check.h>
 
 #include <asm/uaccess.h>
 #include <asm/io.h>
@@ -132,7 +133,7 @@ static ssize_t read_mem(struct file *file, char __user *buf,
 		if (!ptr)
 			return -EFAULT;
 
-		remaining = copy_to_user(buf, ptr, sz);
+		remaining = copy_to_user_unchecked(buf, ptr, sz);
 		unxlate_dev_mem_ptr(p, ptr);
 		if (remaining)
 			return -EFAULT;
@@ -190,7 +191,7 @@ static ssize_t write_mem(struct file *file, const char __user *buf,
 			return -EFAULT;
 		}
 
-		copied = copy_from_user(ptr, buf, sz);
+		copied = copy_from_user_unchecked(ptr, buf, sz);
 		unxlate_dev_mem_ptr(p, ptr);
 		if (copied) {
 			written += sz - copied;
@@ -428,7 +429,7 @@ static ssize_t read_kmem(struct file *file, char __user *buf,
 			 */
 			kbuf = xlate_dev_kmem_ptr((char *)p);
 
-			if (copy_to_user(buf, kbuf, sz))
+			if (copy_to_user_unchecked(buf, kbuf, sz))
 				return -EFAULT;
 			buf += sz;
 			p += sz;
@@ -498,7 +499,7 @@ static ssize_t do_write_kmem(unsigned long p, const char __user *buf,
 		 */
 		ptr = xlate_dev_kmem_ptr((char *)p);
 
-		copied = copy_from_user(ptr, buf, sz);
+		copied = copy_from_user_unchecked(ptr, buf, sz);
 		if (copied) {
 			written += sz - copied;
 			if (written)
--
