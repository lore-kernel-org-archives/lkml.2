Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755443Ab2DZJt2 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Apr 2012 05:49:28 -0400
Received: from smtp5-g21.free.fr ([212.27.42.5]:48229 "EHLO smtp5-g21.free.fr"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754123Ab2DZJt0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Apr 2012 05:49:26 -0400
From: Jim Meyering <jim@meyering.net>
To: Josef Bacik <josef@redhat.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [PATCH] Btrfs: avoid buffer overrun in mount option handling
In-Reply-To: <20120425200330.GC17006@localhost.localdomain> (Josef Bacik's
	message of "Wed, 25 Apr 2012 16:03:32 -0400")
References: <87mx5z1teu.fsf@rho.meyering.net>
	<20120425200330.GC17006@localhost.localdomain>
Date: Thu, 26 Apr 2012 11:49:17 +0200
Message-ID: <87r4vazuua.fsf@rho.meyering.net>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Josef Bacik wrote:
> On Wed, Apr 25, 2012 at 09:51:53PM +0200, Jim Meyering wrote:
>> There is an off-by-one error: allocating room for a maximal result
>> string but without room for a trailing NUL.  That, can lead to
>> returning a transformed string that is not NUL-terminated, and then
>> to a caller reading beyond end of the malloc'd buffer.
>>
>> Worse still, we could write one non-NUL byte beyond the end of that
>> malloc'd result buffer when given a mount option of "subvol=," (i.e.,
>> no arg after the "=") because here the replacement "subvolid=0" is 3
>> bytes longer, not just 2.
>
> So this can't happen, since it would be caught by btrfs_parse_early_options
> which expects subvolid=%d, and if it doesn't get that it would just error out,
> so while adding another byte isn't bad, it's not correct either, so fix that and
> I'd say it's good to go.  Thanks,

Hi Josef,

Thanks for the quick review.
Here's the incremental change, then the full revised commit:

diff --git a/fs/btrfs/super.c b/fs/btrfs/super.c
index eca8dea..5ddf172 100644
--- a/fs/btrfs/super.c
+++ b/fs/btrfs/super.c
@@ -926,15 +926,15 @@ static inline int is_subvolume_inode(struct inode *inode)
  */
 static char *setup_root_args(char *args)
 {
-	unsigned len = strlen(args) + 3 + 1;
+	unsigned len = strlen(args) + 2 + 1;
 	char *src, *dst, *buf;

 	/*
 	 * We need the same args as before, but with this substitution:
-	 * s!subvol=[^,]*!subvolid=0!
+	 * s!subvol=[^,]+!subvolid=0!
 	 *
-	 * Since the replacement string is up to 3 bytes longer than the
-	 * original, allocate strlen(args) + 3 + 1 bytes.
+	 * Since the replacement string is up to 2 bytes longer than the
+	 * original, allocate strlen(args) + 2 + 1 bytes.
 	 */

 	src = strstr(args, "subvol=");

>From 312b051535dea0fb208a7dcbe6ac6f30d948825e Mon Sep 17 00:00:00 2001
From: Jim Meyering <meyering@redhat.com>
Date: Wed, 25 Apr 2012 21:24:17 +0200
Subject: [PATCH] Btrfs: avoid buffer overrun in mount option handling

There is an off-by-one error: allocating room for a maximal result
string but without room for a trailing NUL.  That, can lead to
returning a transformed string that is not NUL-terminated, and
then to a caller reading beyond end of the malloc'd buffer.

Rewrite to s/kzalloc/kmalloc/, remove unwarranted use of strncpy
(the result is guaranteed to fit), remove dead strlen at end, and
change a few variable names and comments.

Reviewed-by: Josef Bacik <josef@redhat.com>
Signed-off-by: Jim Meyering <meyering@redhat.com>
---
 fs/btrfs/super.c |   67 +++++++++++++++++++++---------------------------------
 1 file changed, 26 insertions(+), 41 deletions(-)

diff --git a/fs/btrfs/super.c b/fs/btrfs/super.c
index 8d5d380..5ddf172 100644
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
+	unsigned len = strlen(args) + 2 + 1;
+	char *src, *dst, *buf;

 	/*
-	 * We need the same args as before, but minus
+	 * We need the same args as before, but with this substitution:
+	 * s!subvol=[^,]+!subvolid=0!
 	 *
-	 * subvol=a
-	 *
-	 * and add
-	 *
-	 * subvolid=0
-	 *
-	 * which is a difference of 2 characters, so we allocate strlen(args) +
-	 * 2 characters.
+	 * Since the replacement string is up to 2 bytes longer than the
+	 * original, allocate strlen(args) + 2 + 1 bytes.
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
