Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756087Ab2IIX2e (ORCPT <rfc822;w@1wt.eu>);
	Sun, 9 Sep 2012 19:28:34 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:51280 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756036Ab2IIXQc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 9 Sep 2012 19:16:32 -0400
Message-Id: <20120909224159.613727579@decadent.org.uk>
User-Agent: quilt/0.60-1
Date: Sun, 09 Sep 2012 23:42:55 +0100
From: Ben Hutchings <ben@decadent.org.uk>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org,
        alan@lxorguk.ukuu.org.uk, Al Viro <viro@ZenIV.linux.org.uk>,
        Al Viro <viro@ZenIV.linux.org.uk>
Subject: [ 65/95] vfs: missed source of ->f_pos races
In-Reply-To: <20120909224150.641491654@decadent.org.uk>
X-SA-Exim-Connect-IP: 2001:470:1f08:1539:21c:bfff:fe03:f805
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Al Viro <viro@ZenIV.linux.org.uk>

commit 0e665d5d1125f9f4ccff56a75e814f10f88861a2 upstream.

compat_sys_{read,write}v() need the same "pass a copy of file->f_pos" thing
as sys_{read,write}{,v}().

Signed-off-by: Al Viro <viro@zeniv.linux.org.uk>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 fs/compat.c |   10 ++++++++--
 1 file changed, 8 insertions(+), 2 deletions(-)

diff --git a/fs/compat.c b/fs/compat.c
index 6161255..1bdb350 100644
--- a/fs/compat.c
+++ b/fs/compat.c
@@ -1155,11 +1155,14 @@ compat_sys_readv(unsigned long fd, const struct compat_iovec __user *vec,
 	struct file *file;
 	int fput_needed;
 	ssize_t ret;
+	loff_t pos;
 
 	file = fget_light(fd, &fput_needed);
 	if (!file)
 		return -EBADF;
-	ret = compat_readv(file, vec, vlen, &file->f_pos);
+	pos = file->f_pos;
+	ret = compat_readv(file, vec, vlen, &pos);
+	file->f_pos = pos;
 	fput_light(file, fput_needed);
 	return ret;
 }
@@ -1221,11 +1224,14 @@ compat_sys_writev(unsigned long fd, const struct compat_iovec __user *vec,
 	struct file *file;
 	int fput_needed;
 	ssize_t ret;
+	loff_t pos;
 
 	file = fget_light(fd, &fput_needed);
 	if (!file)
 		return -EBADF;
-	ret = compat_writev(file, vec, vlen, &file->f_pos);
+	pos = file->f_pos;
+	ret = compat_writev(file, vec, vlen, &pos);
+	file->f_pos = pos;
 	fput_light(file, fput_needed);
 	return ret;
 }


