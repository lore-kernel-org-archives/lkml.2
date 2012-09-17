Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755224Ab2IQBY7 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 16 Sep 2012 21:24:59 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:33523 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753182Ab2IQAtz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 16 Sep 2012 20:49:55 -0400
Message-Id: <20120917003644.714488075@decadent.org.uk>
User-Agent: quilt/0.60-1
Date: Mon, 17 Sep 2012 01:38:39 +0100
From: Ben Hutchings <ben@decadent.org.uk>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org,
        alan@lxorguk.ukuu.org.uk
Subject: [ 134/135] VFS: make vfs_fstat() use f[get|put]_light()
In-Reply-To: <20120917003625.784119135@decadent.org.uk>
X-SA-Exim-Connect-IP: 2001:470:1f08:1539:21c:bfff:fe03:f805
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Linus Torvalds <torvalds@linux-foundation.org>

commit e994defb7b6813ba6fa7a2a36e86d2455ad1dc35 upstream.

Use the *_light() versions that properly avoid doing the file user count
updates when they are unnecessary.

Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 fs/stat.c |    5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/fs/stat.c b/fs/stat.c
index c733dc5..88b36c7 100644
--- a/fs/stat.c
+++ b/fs/stat.c
@@ -57,12 +57,13 @@ EXPORT_SYMBOL(vfs_getattr);
 
 int vfs_fstat(unsigned int fd, struct kstat *stat)
 {
-	struct file *f = fget(fd);
+	int fput_needed;
+	struct file *f = fget_light(fd, &fput_needed);
 	int error = -EBADF;
 
 	if (f) {
 		error = vfs_getattr(f->f_path.mnt, f->f_path.dentry, stat);
-		fput(f);
+		fput_light(f, fput_needed);
 	}
 	return error;
 }


