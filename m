Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754877Ab2GIOtE (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Jul 2012 10:49:04 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:38122 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754326Ab2GIOh7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Jul 2012 10:37:59 -0400
Message-Id: <20120709143123.494694140@decadent.org.uk>
User-Agent: quilt/0.60-1
Date: Mon, 09 Jul 2012 15:32:04 +0100
From: Ben Hutchings <ben@decadent.org.uk>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org,
        alan@lxorguk.ukuu.org.uk,
        =?ISO-8859-15?q?=D0=BE=D0=BB=D1=8C=D0=B3=D0=B0=20=D0=BA=D1=80=D1=8B=D0=B6=D0=B0=D0=BD=D0=BE=D0=B2=D1=81=D0=BA=D0=B0=D1=8F?= 
	<olga.kryzhanovska@gmail.com>,
        Al Viro <viro@zeniv.linux.org.uk>
Subject: [ 48/48] vfs: make O_PATH file descriptors usable for fchdir()
In-Reply-To: <20120709143116.348975190@decadent.org.uk>
X-SA-Exim-Connect-IP: 2001:470:1f08:1539:21c:bfff:fe03:f805
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2-stable review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 fs/open.c |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/fs/open.c b/fs/open.c
index d6c79a0..1540632 100644
--- a/fs/open.c
+++ b/fs/open.c
@@ -397,10 +397,10 @@ SYSCALL_DEFINE1(fchdir, unsigned int, fd)
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
 
@@ -414,7 +414,7 @@ SYSCALL_DEFINE1(fchdir, unsigned int, fd)
 	if (!error)
 		set_fs_pwd(current->fs, &file->f_path);
 out_putf:
-	fput(file);
+	fput_light(file, fput_needed);
 out:
 	return error;
 }


