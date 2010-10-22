Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758812Ab0JVSu4 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Oct 2010 14:50:56 -0400
Received: from kroah.org ([198.145.64.141]:45720 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756772Ab0JVSig (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Oct 2010 14:38:36 -0400
X-Mailbox-Line: From gregkh@clark.site Fri Oct 22 11:35:58 2010
Message-Id: <20101022183558.821174052@clark.site>
User-Agent: quilt/0.48-11.2
Date: Fri, 22 Oct 2010 11:34:56 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Joel Becker <joel.becker@oracle.com>
Subject: [29/66] ocfs2: Dont walk off the end of fast symlinks.
In-Reply-To: <20101022183711.GA23214@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.32-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Joel Becker <joel.becker@oracle.com>

commit 1fc8a117865b54590acd773a55fbac9221b018f0 upstream.

ocfs2 fast symlinks are NUL terminated strings stored inline in the
inode data area.  However, disk corruption or a local attacker could, in
theory, remove that NUL.  Because we're using strlen() (my fault,
introduced in a731d1 when removing vfs_follow_link()), we could walk off
the end of that string.

Signed-off-by: Joel Becker <joel.becker@oracle.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 fs/ocfs2/symlink.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/fs/ocfs2/symlink.c
+++ b/fs/ocfs2/symlink.c
@@ -128,7 +128,7 @@ static void *ocfs2_fast_follow_link(stru
 	}
 
 	/* Fast symlinks can't be large */
-	len = strlen(target);
+	len = strnlen(target, ocfs2_fast_symlink_chars(inode->i_sb));
 	link = kzalloc(len + 1, GFP_NOFS);
 	if (!link) {
 		status = -ENOMEM;


