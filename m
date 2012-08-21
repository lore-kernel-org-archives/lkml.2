Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753972Ab2HUHVB (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Aug 2012 03:21:01 -0400
Received: from smtp5-g21.free.fr ([212.27.42.5]:52446 "EHLO smtp5-g21.free.fr"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753282Ab2HUHU5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Aug 2012 03:20:57 -0400
From: Jim Meyering <jim@meyering.net>
To: linux-kernel@vger.kernel.org
Cc: Eric Van Hensbergen <ericvh@gmail.com>, Ron Minnich <rminnich@sandia.gov>,
        Latchesar Ionkov <lucho@ionkov.net>,
        v9fs-developer@lists.sourceforge.net
Subject: [PATCHv2] fs/9p: avoid debug OOPS when reading a long symlink
In-Reply-To: <1345481724-30108-3-git-send-email-jim@meyering.net> (Jim
	Meyering's message of "Mon, 20 Aug 2012 18:55:21 +0200")
References: <1345481724-30108-1-git-send-email-jim@meyering.net>
	<1345481724-30108-3-git-send-email-jim@meyering.net>
Date: Tue, 21 Aug 2012 09:20:49 +0200
Message-ID: <87mx1ok8xa.fsf_-_@rho.meyering.net>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Reading a symlink longer than the given buffer, a p9_debug use would
try to print the link name (not NUL-terminated) using a %s format.
Use %.*s instead, and replace the strncpy+strnlen with functionally
equivalent strlen+memcpy.

Signed-off-by: Jim Meyering <meyering@redhat.com>
---
V1 provoked a warning due to strlen/buflen type differences (size_t/int)
and the "min" macro's type equality requirement.  This adds a cast to
avoid that warning:

-	retval = min(strlen(st->extension)+1, buflen);
+	retval = min(strlen(st->extension)+1, (size_t)buflen);

 fs/9p/vfs_inode.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/fs/9p/vfs_inode.c b/fs/9p/vfs_inode.c
index cbf9dbb..890bed5 100644
--- a/fs/9p/vfs_inode.c
+++ b/fs/9p/vfs_inode.c
@@ -1276,12 +1276,12 @@ static int v9fs_readlink(struct dentry *dentry, char *buffer, int buflen)
 	}

 	/* copy extension buffer into buffer */
-	strncpy(buffer, st->extension, buflen);
+	retval = min(strlen(st->extension)+1, (size_t)buflen);
+	memcpy(buffer, st->extension, retval);

-	p9_debug(P9_DEBUG_VFS, "%s -> %s (%s)\n",
-		 dentry->d_name.name, st->extension, buffer);
+	p9_debug(P9_DEBUG_VFS, "%s -> %s (%.*s)\n",
+		 dentry->d_name.name, st->extension, buflen, buffer);

-	retval = strnlen(buffer, buflen);
 done:
 	p9stat_free(st);
 	kfree(st);
--
1.7.12
