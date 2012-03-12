Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754852Ab2CLAxn (ORCPT <rfc822;w@1wt.eu>);
	Sun, 11 Mar 2012 20:53:43 -0400
Received: from 1wt.eu ([62.212.114.60]:63113 "EHLO 1wt.eu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754619Ab2CLAs4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 11 Mar 2012 20:48:56 -0400
Message-Id: <20120312004411.845404654@1wt.eu>
User-Agent: quilt/0.48-1
Date: Mon, 12 Mar 2012 01:44:24 +0100
From: Willy Tarreau <w@1wt.eu>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Dan Carpenter <dan.carpenter@oracle.com>, Jens Axboe <axboe@kernel.dk>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: [ 13/13] cdrom: use copy_to_user() without the underscores
In-Reply-To: <fec4dd6c17083169f2e217caca7375ef@local>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.27-longterm review patch.  If anyone has any objections, please let me know.

------------------

From: Dan Carpenter <dan.carpenter@oracle.com>

commit 822bfa51ce44f2c63c300fdb76dc99c4d5a5ca9f upstream.

"nframes" comes from the user and "nframes * CD_FRAMESIZE_RAW" can wrap
on 32 bit systems.  That would have been ok if we used the same wrapped
value for the copy, but we use a shifted value.  We should just use the
checked version of copy_to_user() because it's not going to make a
difference to the speed.

Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/cdrom/cdrom.c |    8 +-------
 1 files changed, 1 insertions(+), 7 deletions(-)

diff --git a/drivers/cdrom/cdrom.c b/drivers/cdrom/cdrom.c
index 59cccc9..a4592ec 100644
--- a/drivers/cdrom/cdrom.c
+++ b/drivers/cdrom/cdrom.c
@@ -2057,11 +2057,6 @@ static int cdrom_read_cdda_old(struct cdrom_device_info *cdi, __u8 __user *ubuf,
 	if (!nr)
 		return -ENOMEM;
 
-	if (!access_ok(VERIFY_WRITE, ubuf, nframes * CD_FRAMESIZE_RAW)) {
-		ret = -EFAULT;
-		goto out;
-	}
-
 	cgc.data_direction = CGC_DATA_READ;
 	while (nframes > 0) {
 		if (nr > nframes)
@@ -2070,7 +2065,7 @@ static int cdrom_read_cdda_old(struct cdrom_device_info *cdi, __u8 __user *ubuf,
 		ret = cdrom_read_block(cdi, &cgc, lba, nr, 1, CD_FRAMESIZE_RAW);
 		if (ret)
 			break;
-		if (__copy_to_user(ubuf, cgc.buffer, CD_FRAMESIZE_RAW * nr)) {
+		if (copy_to_user(ubuf, cgc.buffer, CD_FRAMESIZE_RAW * nr)) {
 			ret = -EFAULT;
 			break;
 		}
@@ -2078,7 +2073,6 @@ static int cdrom_read_cdda_old(struct cdrom_device_info *cdi, __u8 __user *ubuf,
 		nframes -= nr;
 		lba += nr;
 	}
-out:
 	kfree(cgc.buffer);
 	return ret;
 }
-- 
1.7.2.1.45.g54fbc



