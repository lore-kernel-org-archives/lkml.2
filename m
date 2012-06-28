Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754123Ab2F1Opz (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Jun 2012 10:45:55 -0400
Received: from mail-we0-f174.google.com ([74.125.82.174]:58579 "EHLO
	mail-we0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751036Ab2F1Opx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Jun 2012 10:45:53 -0400
Date: Thu, 28 Jun 2012 17:45:46 +0300
From: Shmulik Ladkani <shmulik.ladkani@gmail.com>
To: Richard Weinberger <richard@nod.at>
Cc: Artem Bityutskiy <artem.bityutskiy@linux.intel.com>,
        linux-kernel@vger.kernel.org, Adrian Hunter <adrian.hunter@intel.com>,
        <Heinz.Egger@linutronix.de>, thomas.wucher@linutronix.de,
        tglx@linutronix.de, tim.bird@am.sony.com, Marius.Mazarel@ugal.ro,
        nyoushchenko@mvista.com, linux-mtd@lists.infradead.org
Subject: [PATCH] ubi: fastmap: Do not free 'ai' in 'scan_all()'
Message-ID: <20120628174546.491954e2@pixies.home.jungo.com>
In-Reply-To: <20120628165239.52cffc64@pixies.home.jungo.com>
References: <20120628165239.52cffc64@pixies.home.jungo.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Shmulik Ladkani <shmulik.ladkani@gmail.com>

Do not call 'destroy_ai(ai)' at error handling of 'scan_all', since:
- 'ai' is allocated in 'ubi_attach' (the caller of scan_all) and
  provided as an argument. It's not scan_all's responsibility to free it
- It is not consistent with scan_all's sister function
  'ubi_attach_fastmap()' which does not free the given 'ai'
- It will cause a double free as 'ubi_attach' (the caller of scan_all)
  already destroys 'ai' in case of an error

Signed-off-by: Shmulik Ladkani <shmulik.ladkani@gmail.com>
---
- compile tested

diff --git a/drivers/mtd/ubi/attach.c b/drivers/mtd/ubi/attach.c
index 019fbd3..8a339e4 100644
--- a/drivers/mtd/ubi/attach.c
+++ b/drivers/mtd/ubi/attach.c
@@ -1152,11 +1152,11 @@ static int scan_all(struct ubi_device *ubi, struct ubi_attach_info *ai)
 					       sizeof(struct ubi_ainf_peb),
 					       0, 0, NULL);
 	if (!ai->aeb_slab_cache)
-		goto out_ai;
+		return -ENOMEM;
 
 	ech = kzalloc(ubi->ec_hdr_alsize, GFP_KERNEL);
 	if (!ech)
-		goto out_ai;
+		return -ENOMEM;
 
 	vidh = ubi_zalloc_vid_hdr(ubi, GFP_KERNEL);
 	if (!vidh)
@@ -1218,8 +1218,6 @@ out_vidh:
 	ubi_free_vid_hdr(ubi, vidh);
 out_ech:
 	kfree(ech);
-out_ai:
-	destroy_ai(ai);
 	return err;
 }
 
