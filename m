Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932211Ab1CMXYu (ORCPT <rfc822;w@1wt.eu>);
	Sun, 13 Mar 2011 19:24:50 -0400
Received: from zeniv.linux.org.uk ([195.92.253.2]:54526 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755720Ab1CMXYs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 13 Mar 2011 19:24:48 -0400
Date: Sun, 13 Mar 2011 23:24:46 +0000
From: Al Viro <viro@ZenIV.linux.org.uk>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH] compat breakage in preadv() and pwritev()
Message-ID: <20110313232446.GJ22723@ZenIV.linux.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

	Fix for a dumb preadv()/pwritev() compat bug - unlike the native
variants, compat_... ones forget to check FMODE_P{READ,WRITE}, so e.g.
on pipe the native preadv() will fail with -ESPIPE and compat one will
act as readv() and succeed.  Not critical, but it's a clear bug with trivial
fix, so IMO it's OK for -final.

Signed-off-by: Al Viro <viro@zeniv.linux.org.uk>
---
 fs/compat.c |    8 ++++++--
 1 file changed, 6 insertions(+), 2 deletions(-)

diff --git a/fs/compat.c b/fs/compat.c
index f6fd0a0..691c3fd 100644
--- a/fs/compat.c
+++ b/fs/compat.c
@@ -1228,7 +1228,9 @@ compat_sys_preadv(unsigned long fd, const struct compat_iovec __user *vec,
 	file = fget_light(fd, &fput_needed);
 	if (!file)
 		return -EBADF;
-	ret = compat_readv(file, vec, vlen, &pos);
+	ret = -ESPIPE;
+	if (file->f_mode & FMODE_PREAD)
+		ret = compat_readv(file, vec, vlen, &pos);
 	fput_light(file, fput_needed);
 	return ret;
 }
@@ -1285,7 +1287,9 @@ compat_sys_pwritev(unsigned long fd, const struct compat_iovec __user *vec,
 	file = fget_light(fd, &fput_needed);
 	if (!file)
 		return -EBADF;
-	ret = compat_writev(file, vec, vlen, &pos);
+	ret = -ESPIPE;
+	if (file->f_mode & FMODE_PWRITE)
+		ret = compat_writev(file, vec, vlen, &pos);
 	fput_light(file, fput_needed);
 	return ret;
 }
