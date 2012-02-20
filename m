Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752520Ab2BTAO3 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 19 Feb 2012 19:14:29 -0500
Received: from terminus.zytor.com ([198.137.202.10]:57223 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751567Ab2BTAO1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 19 Feb 2012 19:14:27 -0500
From: "H. Peter Anvin" <hpa@zytor.com>
To: linux-kernel@vger.kernel.org, linux-arch@vger.kernel.org
Cc: mingo@kernel.org, tglx@linutronix.de, hpa@zytor.com,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        hjl.tools@gmail.com
Subject: [PATCH 12/30] compat: Create compat_sys_p{read,write}v64
Date: Sun, 19 Feb 2012 16:07:50 -0800
Message-Id: <1329696488-16970-13-git-send-email-hpa@zytor.com>
X-Mailer: git-send-email 1.7.6.5
In-Reply-To: <1329696488-16970-1-git-send-email-hpa@zytor.com>
References: <1329696488-16970-1-git-send-email-hpa@zytor.com>
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.6 (terminus.zytor.com [127.0.0.1]); Sun, 19 Feb 2012 16:14:22 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: "H. J. Lu" <hjl.tools@gmail.com>

For 32-bit ABIs which have real 64-bit registers, we don't want to
break the position argument into two.  However, we still need compat
support to deal with 32-bit pointers, so we can't just use
sys_p{read,write} directly.

Signed-off-by: H. Peter Anvin <hpa@zytor.com>
---
 fs/compat.c |   26 ++++++++++++++++++++------
 1 files changed, 20 insertions(+), 6 deletions(-)

diff --git a/fs/compat.c b/fs/compat.c
index fa9d721..83d751c 100644
--- a/fs/compat.c
+++ b/fs/compat.c
@@ -1177,10 +1177,9 @@ compat_sys_readv(unsigned long fd, const struct compat_iovec __user *vec,
 }
 
 asmlinkage ssize_t
-compat_sys_preadv(unsigned long fd, const struct compat_iovec __user *vec,
-		  unsigned long vlen, u32 pos_low, u32 pos_high)
+compat_sys_preadv64(unsigned long fd, const struct compat_iovec __user *vec,
+		    unsigned long vlen, loff_t pos)
 {
-	loff_t pos = ((loff_t)pos_high << 32) | pos_low;
 	struct file *file;
 	int fput_needed;
 	ssize_t ret;
@@ -1197,6 +1196,14 @@ compat_sys_preadv(unsigned long fd, const struct compat_iovec __user *vec,
 	return ret;
 }
 
+asmlinkage ssize_t
+compat_sys_preadv(unsigned long fd, const struct compat_iovec __user *vec,
+		  unsigned long vlen, u32 pos_low, u32 pos_high)
+{
+	loff_t pos = ((loff_t)pos_high << 32) | pos_low;
+	return compat_sys_preadv64(fd, vec, vlen, pos);
+}
+
 static size_t compat_writev(struct file *file,
 			    const struct compat_iovec __user *vec,
 			    unsigned long vlen, loff_t *pos)
@@ -1236,10 +1243,9 @@ compat_sys_writev(unsigned long fd, const struct compat_iovec __user *vec,
 }
 
 asmlinkage ssize_t
-compat_sys_pwritev(unsigned long fd, const struct compat_iovec __user *vec,
-		   unsigned long vlen, u32 pos_low, u32 pos_high)
+compat_sys_pwritev64(unsigned long fd, const struct compat_iovec __user *vec,
+		     unsigned long vlen, loff_t pos)
 {
-	loff_t pos = ((loff_t)pos_high << 32) | pos_low;
 	struct file *file;
 	int fput_needed;
 	ssize_t ret;
@@ -1256,6 +1262,14 @@ compat_sys_pwritev(unsigned long fd, const struct compat_iovec __user *vec,
 	return ret;
 }
 
+asmlinkage ssize_t
+compat_sys_pwritev(unsigned long fd, const struct compat_iovec __user *vec,
+		   unsigned long vlen, u32 pos_low, u32 pos_high)
+{
+	loff_t pos = ((loff_t)pos_high << 32) | pos_low;
+	return compat_sys_pwritev64(fd, vec, vlen, pos);
+}
+
 asmlinkage long
 compat_sys_vmsplice(int fd, const struct compat_iovec __user *iov32,
 		    unsigned int nr_segs, unsigned int flags)
-- 
1.7.6.5

