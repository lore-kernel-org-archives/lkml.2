Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934437Ab1KJD2N (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Nov 2011 22:28:13 -0500
Received: from cantor2.suse.de ([195.135.220.15]:42472 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S934912Ab1KJD2G (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Nov 2011 22:28:06 -0500
X-Mailbox-Line: From gregkh@clark.kroah.org Wed Nov  9 13:27:15 2011
Message-Id: <20111109212715.697553229@clark.kroah.org>
User-Agent: quilt/0.48-16.4
Date: Wed, 09 Nov 2011 13:27:52 -0800
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org,
        alan@lxorguk.ukuu.org.uk
Subject: [150/262] vfs: show O_CLOEXE bit properly in /proc/<pid>/fdinfo/<fd> files
In-Reply-To: <20111109212847.GA20838@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.0-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Linus Torvalds <torvalds@linux-foundation.org>

commit 1117f72ea0217ba0cc19f05adbbd8b9a397f5ab7 upstream.

The CLOEXE bit is magical, and for performance (and semantic) reasons we
don't actually maintain it in the file descriptor itself, but in a
separate bit array.  Which means that when we show f_flags, the CLOEXE
status is shown incorrectly: we show the status not as it is now, but as
it was when the file was opened.

Fix that by looking up the bit properly in the 'fdt->close_on_exec' bit
array.

Uli needs this in order to re-implement the pfiles program:

  "For normal file descriptors (not sockets) this was the last piece of
   information which wasn't available.  This is all part of my 'give
   Solaris users no reason to not switch' effort.  I intend to offer the
   code to the util-linux-ng maintainers."

Requested-by: Ulrich Drepper <drepper@akkadia.org>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 fs/proc/base.c |   10 +++++++++-
 1 file changed, 9 insertions(+), 1 deletion(-)

--- a/fs/proc/base.c
+++ b/fs/proc/base.c
@@ -1920,6 +1920,14 @@ static int proc_fd_info(struct inode *in
 		spin_lock(&files->file_lock);
 		file = fcheck_files(files, fd);
 		if (file) {
+			unsigned int f_flags;
+			struct fdtable *fdt;
+
+			fdt = files_fdtable(files);
+			f_flags = file->f_flags & ~O_CLOEXEC;
+			if (FD_ISSET(fd, fdt->close_on_exec))
+				f_flags |= O_CLOEXEC;
+
 			if (path) {
 				*path = file->f_path;
 				path_get(&file->f_path);
@@ -1929,7 +1937,7 @@ static int proc_fd_info(struct inode *in
 					 "pos:\t%lli\n"
 					 "flags:\t0%o\n",
 					 (long long) file->f_pos,
-					 file->f_flags);
+					 f_flags);
 			spin_unlock(&files->file_lock);
 			put_files_struct(files);
 			return 0;


