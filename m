Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932710Ab2JAXAl (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Oct 2012 19:00:41 -0400
Received: from 1wt.eu ([62.212.114.60]:35197 "EHLO 1wt.eu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932686Ab2JAXAi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Oct 2012 19:00:38 -0400
Message-Id: <20121001225203.036802554@1wt.eu>
User-Agent: quilt/0.48-1
Date: Tue, 02 Oct 2012 00:54:05 +0200
From: Willy Tarreau <w@1wt.eu>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Al Viro <viro@zeniv.linux.org.uk>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Willy Tarreau <w@1wt.eu>
Subject: [ 128/180] vfs: missed source of ->f_pos races
In-Reply-To: <6a854f579a99b4fe2efaca1057e8ae22@local>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.32-longterm review patch.  If anyone has any objections, please let me know.

------------------

From: Al Viro <viro@ZenIV.linux.org.uk>

commit 0e665d5d1125f9f4ccff56a75e814f10f88861a2 upstream.

compat_sys_{read,write}v() need the same "pass a copy of file->f_pos" thing
as sys_{read,write}{,v}().

Signed-off-by: Al Viro <viro@zeniv.linux.org.uk>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Willy Tarreau <w@1wt.eu>
---
 fs/compat.c |   10 ++++++++--
 1 files changed, 8 insertions(+), 2 deletions(-)

diff --git a/fs/compat.c b/fs/compat.c
index d1e2411..46b93d1 100644
--- a/fs/compat.c
+++ b/fs/compat.c
@@ -1208,11 +1208,14 @@ compat_sys_readv(unsigned long fd, const struct compat_iovec __user *vec,
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
@@ -1265,11 +1268,14 @@ compat_sys_writev(unsigned long fd, const struct compat_iovec __user *vec,
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
-- 
1.7.2.1.45.g54fbc



