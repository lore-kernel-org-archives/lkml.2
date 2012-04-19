Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964909Ab2DSVOY (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Apr 2012 17:14:24 -0400
Received: from mail-gy0-f174.google.com ([209.85.160.174]:61429 "EHLO
	mail-gy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S964880Ab2DSVOT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Apr 2012 17:14:19 -0400
Message-Id: <20120419210615.671059149@linuxfoundation.org>
User-Agent: quilt/0.60-19.1
Date: Thu, 19 Apr 2012 14:07:04 -0700
From: Greg KH <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org,
        alan@lxorguk.ukuu.org.uk, NeilBrown <neilb@suse.de>
Subject: [ 53/59] md/bitmap: prevent bitmap_daemon_work running while initialising bitmap
In-Reply-To: <20120419210623.GA12156@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.0-stable review patch.  If anyone has any objections, please let me know.

------------------

From: NeilBrown <neilb@suse.de>

commit afbaa90b80b1ec66e5137cc3824746bfdf559b18 upstream.

If a bitmap is added while the array is active, it is possible
for bitmap_daemon_work to run while the bitmap is being
initialised.
This is particularly a problem if bitmap_daemon_work sees
bitmap->filemap as non-NULL before it has been filled in properly.
So hold bitmap_info.mutex while filling in ->filemap
to prevent problems.

This patch is suitable for any -stable kernel, though it might not
apply cleanly before about 3.1.

Signed-off-by: NeilBrown <neilb@suse.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/md/bitmap.c |    2 ++
 1 file changed, 2 insertions(+)

--- a/drivers/md/bitmap.c
+++ b/drivers/md/bitmap.c
@@ -1897,7 +1897,9 @@ int bitmap_load(mddev_t *mddev)
 			 * re-add of a missing device */
 			start = mddev->recovery_cp;
 
+		mutex_lock(&mddev->bitmap_info.mutex);
 		err = bitmap_init_from_disk(bitmap, start);
+		mutex_unlock(&mddev->bitmap_info.mutex);
 	}
 	if (err)
 		goto out;


