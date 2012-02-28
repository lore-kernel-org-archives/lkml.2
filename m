Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965362Ab2B1BQE (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Feb 2012 20:16:04 -0500
Received: from mail-pw0-f46.google.com ([209.85.160.46]:58461 "EHLO
	mail-pw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965305Ab2B1BM2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Feb 2012 20:12:28 -0500
Authentication-Results: mr.google.com; spf=pass (google.com: domain of gregkh@linuxfoundation.org designates 10.68.135.66 as permitted sender) smtp.mail=gregkh@linuxfoundation.org
MIME-Version: 1.0
Message-Id: <20120228010435.741044219@linuxfoundation.org>
User-Agent: quilt/0.51-17.1
Date: Mon, 27 Feb 2012 17:05:41 -0800
From: Greg KH <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org,
        alan@lxorguk.ukuu.org.uk, Dan Carpenter <dan.carpenter@oracle.com>,
        Jens Axboe <axboe@kernel.dk>
Subject: [ 72/72] cdrom: use copy_to_user() without the underscores
In-Reply-To: <20120228010511.GA8453@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2-stable review patch.  If anyone has any objections, please let me know.

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
 1 file changed, 1 insertion(+), 7 deletions(-)

--- a/drivers/cdrom/cdrom.c
+++ b/drivers/cdrom/cdrom.c
@@ -2120,11 +2120,6 @@ static int cdrom_read_cdda_old(struct cd
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
@@ -2133,7 +2128,7 @@ static int cdrom_read_cdda_old(struct cd
 		ret = cdrom_read_block(cdi, &cgc, lba, nr, 1, CD_FRAMESIZE_RAW);
 		if (ret)
 			break;
-		if (__copy_to_user(ubuf, cgc.buffer, CD_FRAMESIZE_RAW * nr)) {
+		if (copy_to_user(ubuf, cgc.buffer, CD_FRAMESIZE_RAW * nr)) {
 			ret = -EFAULT;
 			break;
 		}
@@ -2141,7 +2136,6 @@ static int cdrom_read_cdda_old(struct cd
 		nframes -= nr;
 		lba += nr;
 	}
-out:
 	kfree(cgc.buffer);
 	return ret;
 }


