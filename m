Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754626Ab2DEPEA (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Apr 2012 11:04:00 -0400
Received: from nat28.tlf.novell.com ([130.57.49.28]:42688 "EHLO
	nat28.tlf.novell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753230Ab2DEPD6 convert rfc822-to-8bit (ORCPT
	<rfc822;groupwise-linux-kernel@vger.kernel.org:5:1>);
	Thu, 5 Apr 2012 11:03:58 -0400
Message-Id: <4F7DD0B4020000780007CBF0@nat28.tlf.novell.com>
X-Mailer: Novell GroupWise Internet Agent 12.0.0 
Date: Thu, 05 Apr 2012 16:04:52 +0100
From: "Jan Beulich" <JBeulich@suse.com>
To: "Jeremy Fitzhardinge" <jeremy@goop.org>,
        "Konrad Rzeszutek Wilk" <konrad.wilk@oracle.com>
Cc: "Jens Axboe" <axboe@kernel.dk>, "xen-devel" <xen-devel@lists.xen.org>,
        <linux-kernel@vger.kernel.org>
Subject: [PATCH] xen-blkfront: module exit handling adjustments
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The blkdev major must be released upon exit, or else the module can't
attach to devices using the same majors upon being loaded again. Also
avoid leaking the minor tracking bitmap.

Signed-off-by: Jan Beulich <jbeulich@suse.com>

---
 drivers/block/xen-blkfront.c |    4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

--- 3.4-rc1/drivers/block/xen-blkfront.c
+++ 3.4-rc1-xen-blkfront-exit-cleanup/drivers/block/xen-blkfront.c
@@ -1497,7 +1497,9 @@ module_init(xlblk_init);
 
 static void __exit xlblk_exit(void)
 {
-	return xenbus_unregister_driver(&blkfront_driver);
+	xenbus_unregister_driver(&blkfront_driver);
+	unregister_blkdev(XENVBD_MAJOR, DEV_NAME);
+	kfree(minors);
 }
 module_exit(xlblk_exit);
 



