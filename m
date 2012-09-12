Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932595Ab2IMAQg (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Sep 2012 20:16:36 -0400
Received: from mail-ob0-f174.google.com ([209.85.214.174]:36222 "EHLO
	mail-ob0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932503Ab2ILXhl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Sep 2012 19:37:41 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Greg KH <gregkh@linuxfoundation.org>, Al Viro <viro@zeniv.linux.org.uk>,
        Linus Torvalds <torvalds@linux-foundation.org>
Subject: [ 17/85] vfs: missed source of ->f_pos races
Date: Wed, 12 Sep 2012 16:36:00 -0700
Message-Id: <20120912233543.549880880@linuxfoundation.org>
X-Mailer: git-send-email 1.7.10.1.362.g242cab3
In-Reply-To: <20120912233541.747973832@linuxfoundation.org>
References: <20120912233541.747973832@linuxfoundation.org>
User-Agent: quilt/0.60-2.1.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Greg KH <gregkh@linuxfoundation.org>

3.4-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Al Viro <viro@ZenIV.linux.org.uk>

commit 0e665d5d1125f9f4ccff56a75e814f10f88861a2 upstream.

compat_sys_{read,write}v() need the same "pass a copy of file->f_pos" thing
as sys_{read,write}{,v}().

Signed-off-by: Al Viro <viro@zeniv.linux.org.uk>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 fs/compat.c |   10 ++++++++--
 1 file changed, 8 insertions(+), 2 deletions(-)

--- a/fs/compat.c
+++ b/fs/compat.c
@@ -1160,11 +1160,14 @@ compat_sys_readv(unsigned long fd, const
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
@@ -1226,11 +1229,14 @@ compat_sys_writev(unsigned long fd, cons
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


