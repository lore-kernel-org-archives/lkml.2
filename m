Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754291Ab1ERUrd (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 May 2011 16:47:33 -0400
Received: from na3sys009aog107.obsmtp.com ([74.125.149.197]:36309 "EHLO
	na3sys009aog107.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753781Ab1ERUrc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 May 2011 16:47:32 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=nanometrics.ca; s=google;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=ifpiLZ6+hRjHBkhlSnWTXBQPxvGwL53Rs2VD3xqHrHmG5sjdd0ueba6osdYvXBT4nw
         FkBd9+nar3aA5asE00OUaN4AwU6n5fnTa7YaUT7e1eq8Zvup0GrzVjnMe0sh5yfJimSh
         2ylr5wYzLuItTbe4CJyxhk5ONGICNw0xn2q9U=
From: Ben Gardiner <bengardiner@nanometrics.ca>
To: Artem Bityutskiy <dedekind1@gmail.com>
Cc: Adrian Hunter <adrian.hunter@nokia.com>, linux-mtd@lists.infradead.org,
        linux-kernel@vger.kernel.org, "Matthew L. Creech" <mlcreech@gmail.com>
Subject: [PATCH] UBIFS: don't fail on -EBADMSG when fixing free space
Date: Wed, 18 May 2011 16:47:27 -0400
Message-Id: <1305751647-3122-1-git-send-email-bengardiner@nanometrics.ca>
X-Mailer: git-send-email 1.7.4.1
In-Reply-To: <1305196419.2713.84.camel@localhost>
References: <1305196419.2713.84.camel@localhost>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The free space fixup was introduced so that UBIFS on NAND flashes where the
empty pages at the end need to be dropped when flashing or else -74
(aka -EBADMSG) failures will occur -- but due to the limited functionality of
flash-programming facilities the emtpy pages cannot be dropped.

In fixup_leb, which is called during free space fixup, the now-expected return
code of -EBADMSG is treated as a failure.

Don't fail when -EBADMSG is encountered during ubi_read.

Signed-off-by: Ben Gardiner <bengardiner@nanometrics.ca>
CC: Matthew L. Creech <mlcreech@gmail.com>

---
I tested this patch on-top-of l2 head : 'bbf2b37 UBIFS: fix extremely rare
mount failure' using Matthew's 'mkfs.ubifs: add "-F" option for "free-space
fixup"' patch to create the UBIFS image with the flag set.

The test system was a da850evm, the image was flashed with U-boot's plain-old
'nand write' and the rootfs is mounted with 'ubi.mtd=X,2048 root=ubi0:rootfs
rootfstype=ubifs' bootargs.

Without this patch the first attemp to start fixing free space fails
with -EBADMSG:

UBIFS: start fixing up free space
UBI error: ubi_io_read: error -74 (ECC error) while reading 4096 bytes from PEB 18:4096, read 4096 bytes
VFS: Cannot open root device "ubi0:rootfs" or unknown-block(0,0)
[...]

---
 fs/ubifs/sb.c |    8 +++++++-
 1 files changed, 7 insertions(+), 1 deletions(-)

diff --git a/fs/ubifs/sb.c b/fs/ubifs/sb.c
index c606f01..6e7da54 100644
--- a/fs/ubifs/sb.c
+++ b/fs/ubifs/sb.c
@@ -1,3 +1,4 @@
+#define DEBUG
 /*
  * This file is part of UBIFS.
  *
@@ -679,7 +680,12 @@ static int fixup_leb(struct ubifs_info *c, int lnum, int len)
 
 	dbg_mnt("fixup LEB %d, data len %d", lnum, len);
 	err = ubi_read(c->ubi, lnum, c->sbuf, 0, len);
-	if (err)
+	/*
+	 * Don't fail on -EBADMSG since these are precisely the error codes that
+	 * are returned by ubi_red in the cases where free-space fix-ups are
+	 * required.
+	 */
+	if (err && err != -EBADMSG)
 		return err;
 
 	return ubi_leb_change(c->ubi, lnum, c->sbuf, len, UBI_UNKNOWN);
-- 
1.7.4.1

