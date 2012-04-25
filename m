Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758299Ab2DYTwF (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Apr 2012 15:52:05 -0400
Received: from smtp5-g21.free.fr ([212.27.42.5]:55284 "EHLO smtp5-g21.free.fr"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758229Ab2DYTwE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Apr 2012 15:52:04 -0400
From: Jim Meyering <jim@meyering.net>
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Cc: Josef Bacik <josef@redhat.com>
Subject: [PATCH] Btrfs: avoid buffer overrun in mount option handling
Date: Wed, 25 Apr 2012 21:51:53 +0200
Message-ID: <87mx5z1teu.fsf@rho.meyering.net>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


There is an off-by-one error: allocating room for a maximal result
string but without room for a trailing NUL.  That, can lead to
returning a transformed string that is not NUL-terminated, and then
to a caller reading beyond end of the malloc'd buffer.

Worse still, we could write one non-NUL byte beyond the end of that
malloc'd result buffer when given a mount option of "subvol=," (i.e.,
no arg after the "=") because here the replacement "subvolid=0" is 3
bytes longer, not just 2.

Also changed: s/kzalloc/kmalloc/, remove unwarranted use of strncpy
(the result is guaranteed to fit), remove dead strlen at end, and
change a few variable names and comments.

Signed-off-by: Jim Meyering <meyering@redhat.com>
---
Hi Josef,

I took the liberty of rewriting this function.
If you would prefer a smaller patch, let me know.

Also, while this removes more lines than it adds, it could easily remove
two more if only we could rely on the stpcpy function, but alas, I think
that's not an option, since these would be the first two uses:

@@ -952,12 +952,10 @@ static char *setup_root_args(char *args)
 	 */
 	if (src != args) {
 		*src++ = '\0';
-		strcpy(buf, args);
-		dst += strlen(args);
+		dst = stpcpy(buf, args);
 	}

-	strcpy(dst, "subvolid=0");
-	dst += strlen("subvolid=0");
+	dst = stpcpy(dst, "subvolid=0");

 	/*
 	 * If there is a "," after the original subvol=... string,


 fs/btrfs/super.c |   67 +++++++++++++++++++++---------------------------------
 1 file changed, 26 insertions(+), 41 deletions(-)

diff --git a/fs/btrfs/super.c b/fs/btrfs/super.c
index 8d5d380..eca8dea 100644
--- a/fs/btrfs/super.c
+++ b/fs/btrfs/super.c
@@ -926,63 +926,48 @@ static inline int is_subvolume_inode(struct inode *inode)
  */
 static char *setup_root_args(char *args)
 {
-	unsigned copied = 0;
-	unsigned len = strlen(args) + 2;
-	char *pos;
-	char *ret;
+	unsigned len = strlen(args) + 3 + 1;
+	char *src, *dst, *buf;

 	/*
-	 * We need the same args as before, but minus
+	 * We need the same args as before, but with this substitution:
+	 * s!subvol=[^,]*!subvolid=0!
 	 *
-	 * subvol=a
-	 *
-	 * and add
-	 *
-	 * subvolid=0
-	 *
-	 * which is a difference of 2 characters, so we allocate strlen(args) +
-	 * 2 characters.
+	 * Since the replacement string is up to 3 bytes longer than the
+	 * original, allocate strlen(args) + 3 + 1 bytes.
 	 */
-	ret = kzalloc(len * sizeof(char), GFP_NOFS);
-	if (!ret)
-		return NULL;
-	pos = strstr(args, "subvol=");

+	src = strstr(args, "subvol=");
 	/* This shouldn't happen, but just in case.. */
-	if (!pos) {
-		kfree(ret);
+	if (!src)
+		return NULL;
+
+	buf = dst = kmalloc(len, GFP_NOFS);
+	if (!buf)
 		return NULL;
-	}

 	/*
-	 * The subvol=<> arg is not at the front of the string, copy everybody
-	 * up to that into ret.
+	 * If the subvol= arg is not at the start of the string,
+	 * copy whatever precedes it into buf.
 	 */
-	if (pos != args) {
-		*pos = '\0';
-		strcpy(ret, args);
-		copied += strlen(args);
-		pos++;
+	if (src != args) {
+		*src++ = '\0';
+		strcpy(buf, args);
+		dst += strlen(args);
 	}

-	strncpy(ret + copied, "subvolid=0", len - copied);
-
-	/* Length of subvolid=0 */
-	copied += 10;
+	strcpy(dst, "subvolid=0");
+	dst += strlen("subvolid=0");

 	/*
-	 * If there is no , after the subvol= option then we know there's no
-	 * other options and we can just return.
+	 * If there is a "," after the original subvol=... string,
+	 * copy that suffix into our buffer.  Otherwise, we're done.
 	 */
-	pos = strchr(pos, ',');
-	if (!pos)
-		return ret;
+	src = strchr(src, ',');
+	if (src)
+		strcpy(dst, src);

-	/* Copy the rest of the arguments into our buffer */
-	strncpy(ret + copied, pos, len - copied);
-	copied += strlen(pos);
-
-	return ret;
+	return buf;
 }

 static struct dentry *mount_subvol(const char *subvol_name, int flags,
--
1.7.10.335.g879d8
