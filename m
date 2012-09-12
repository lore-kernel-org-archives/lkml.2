Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757110Ab2ILX4l (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Sep 2012 19:56:41 -0400
Received: from mail-ob0-f174.google.com ([209.85.214.174]:36222 "EHLO
	mail-ob0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933123Ab2ILXmn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Sep 2012 19:42:43 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Greg KH <gregkh@linuxfoundation.org>, Miklos Szeredi <mszeredi@suse.cz>,
        "Richard W.M. Jones" <rjones@redhat.com>
Subject: [ 11/46] vfs: canonicalize create mode in build_open_flags()
Date: Wed, 12 Sep 2012 16:39:01 -0700
Message-Id: <20120912233818.840135743@linuxfoundation.org>
X-Mailer: git-send-email 1.7.10.1.362.g242cab3
In-Reply-To: <20120912233817.662663809@linuxfoundation.org>
References: <20120912233817.662663809@linuxfoundation.org>
User-Agent: quilt/0.60-2.1.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Greg KH <gregkh@linuxfoundation.org>

3.0-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Miklos Szeredi <mszeredi@suse.cz>

commit e68726ff72cf7ba5e7d789857fcd9a75ca573f03 upstream.

Userspace can pass weird create mode in open(2) that we canonicalize to
"(mode & S_IALLUGO) | S_IFREG" in vfs_create().

The problem is that we use the uncanonicalized mode before calling vfs_create()
with unforseen consequences.

So do the canonicalization early in build_open_flags().

Signed-off-by: Miklos Szeredi <mszeredi@suse.cz>
Tested-by: Richard W.M. Jones <rjones@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 fs/open.c |    7 ++++---
 1 file changed, 4 insertions(+), 3 deletions(-)

--- a/fs/open.c
+++ b/fs/open.c
@@ -900,9 +900,10 @@ static inline int build_open_flags(int f
 	int lookup_flags = 0;
 	int acc_mode;
 
-	if (!(flags & O_CREAT))
-		mode = 0;
-	op->mode = mode;
+	if (flags & O_CREAT)
+		op->mode = (mode & S_IALLUGO) | S_IFREG;
+	else
+		op->mode = 0;
 
 	/* Must never be set by userspace */
 	flags &= ~FMODE_NONOTIFY;


