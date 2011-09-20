Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751678Ab1ITUKk (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Sep 2011 16:10:40 -0400
Received: from out4.smtp.messagingengine.com ([66.111.4.28]:56803 "EHLO
	out4.smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751154Ab1ITUKj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Sep 2011 16:10:39 -0400
X-Sasl-enc: 0mt43O9pDod2VRSdvJl1N11n6MYZRob4e+NvTt0ws9O9 1316549438
Date: Tue, 20 Sep 2011 13:09:56 -0700
From: Greg KH <gregkh@suse.de>
To: torvalds@linux-foundation.org
Cc: linux-kernel@vger.kernel.org, devel@driverdev.osuosl.org,
        Seth Jennings <sjenning@linux.vnet.ibm.com>,
        dan.magenheimer@oracle.com, francis.moro@gmail.com, ngupta@vflare.org
Subject: [patch 1/1] staging: zcache: fix cleancache crash
Message-ID: <20110920200956.GB8147@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110920200924.GA8147@kroah.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


From: Seth Jennings <sjenning@linux.vnet.ibm.com>

After commit, c5f5c4db, cleancache crashes on the first
successful get. This was caused by a remaining virt_to_page()
call in zcache_pampd_get_data_and_free() that only gets
run in the cleancache path.

The patch converts the virt_to_page() to struct page
casting like was done for other instances in c5f5c4db.


Signed-off-by: Seth Jennings <sjenning@linux.vnet.ibm.com>
Tested-By: Valdis Kletnieks <valdis.kletnieks@vt.edu>
Acked-by: Dan Magenheimer <dan.magenheimer@oracle.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/staging/zcache/zcache-main.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/staging/zcache/zcache-main.c
+++ b/drivers/staging/zcache/zcache-main.c
@@ -1242,7 +1242,7 @@ static int zcache_pampd_get_data_and_fre
 	int ret = 0;
 
 	BUG_ON(!is_ephemeral(pool));
-	zbud_decompress(virt_to_page(data), pampd);
+	zbud_decompress((struct page *)(data), pampd);
 	zbud_free_and_delist((struct zbud_hdr *)pampd);
 	atomic_dec(&zcache_curr_eph_pampd_count);
 	return ret;

