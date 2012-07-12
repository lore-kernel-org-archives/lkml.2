Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1162848Ab2GLXNR (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Jul 2012 19:13:17 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:46543 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1162764Ab2GLXFL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Jul 2012 19:05:11 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Greg KH <gregkh@linuxfoundation.org>, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        =?UTF-8?q?=D0=BE=D0=BB=D1=8C=D0=B3=D0=B0=20=D0=BA=D1=80=D1=8B=D0=B6=D0=B0=D0=BD=D0=BE=D0=B2=D1=81=D0=BA=D0=B0=D1=8F?= 
	<olga.kryzhanovska@gmail.com>,
        Al Viro <viro@zeniv.linux.org.uk>
Subject: =?UTF-8?q?=5B=2042/68=5D=20vfs=3A=20make=20O=5FPATH=20file=20descriptors=20usable=20for=20fchdir=28=29?=
Date: Thu, 12 Jul 2012 16:02:16 -0700
Message-Id: <20120712175039.171791418@linuxfoundation.org>
X-Mailer: git-send-email 1.7.10.1.362.g242cab3
In-Reply-To: <20120712175035.530652872@linuxfoundation.org>
References: <20120712175057.GA9917@kroah.com>
 <20120712175035.530652872@linuxfoundation.org>
User-Agent: quilt/0.60-20.3
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Greg KH <gregkh@linuxfoundation.org>

3.0-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Linus Torvalds <torvalds@linux-foundation.org>

commit 332a2e1244bd08b9e3ecd378028513396a004a24 upstream.

We already use them for openat() and friends, but fchdir() also wants to
be able to use O_PATH file descriptors.  This should make it comparable
to the O_SEARCH of Solaris.  In particular, O_PATH allows you to access
(not-quite-open) a directory you don't have read persmission to, only
execute permission.

Noticed during development of multithread support for ksh93.

Reported-by: ольга крыжановская <olga.kryzhanovska@gmail.com>
Cc: Al Viro <viro@zeniv.linux.org.uk>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 fs/open.c |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

--- a/fs/open.c
+++ b/fs/open.c
@@ -396,10 +396,10 @@ SYSCALL_DEFINE1(fchdir, unsigned int, fd
 {
 	struct file *file;
 	struct inode *inode;
-	int error;
+	int error, fput_needed;
 
 	error = -EBADF;
-	file = fget(fd);
+	file = fget_raw_light(fd, &fput_needed);
 	if (!file)
 		goto out;
 
@@ -413,7 +413,7 @@ SYSCALL_DEFINE1(fchdir, unsigned int, fd
 	if (!error)
 		set_fs_pwd(current->fs, &file->f_path);
 out_putf:
-	fput(file);
+	fput_light(file, fput_needed);
 out:
 	return error;
 }


