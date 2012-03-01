Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965642Ab2CAVyq (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Mar 2012 16:54:46 -0500
Received: from mail-pz0-f46.google.com ([209.85.210.46]:35253 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965497Ab2CAVub (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Mar 2012 16:50:31 -0500
Authentication-Results: mr.google.com; spf=pass (google.com: domain of gregkh@linuxfoundation.org designates 10.68.130.7 as permitted sender) smtp.mail=gregkh@linuxfoundation.org
MIME-Version: 1.0
Message-Id: <20120301213926.572915059@linuxfoundation.org>
User-Agent: quilt/0.51-17.1
Date: Thu, 01 Mar 2012 13:39:49 -0800
From: Greg KH <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org,
        alan@lxorguk.ukuu.org.uk, Dan Carpenter <dan.carpenter@oracle.com>,
        Jens Axboe <axboe@kernel.dk>
Subject: [ 27/34] cdrom: use copy_to_user() without the underscores
In-Reply-To: <20120301214654.GA13231@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.32-longterm review patch.  If anyone has any objections, please let me know.

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
@@ -2057,11 +2057,6 @@ static int cdrom_read_cdda_old(struct cd
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
@@ -2070,7 +2065,7 @@ static int cdrom_read_cdda_old(struct cd
 		ret = cdrom_read_block(cdi, &cgc, lba, nr, 1, CD_FRAMESIZE_RAW);
 		if (ret)
 			break;
-		if (__copy_to_user(ubuf, cgc.buffer, CD_FRAMESIZE_RAW * nr)) {
+		if (copy_to_user(ubuf, cgc.buffer, CD_FRAMESIZE_RAW * nr)) {
 			ret = -EFAULT;
 			break;
 		}
@@ -2078,7 +2073,6 @@ static int cdrom_read_cdda_old(struct cd
 		nframes -= nr;
 		lba += nr;
 	}
-out:
 	kfree(cgc.buffer);
 	return ret;
 }


