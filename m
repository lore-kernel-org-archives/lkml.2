Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932213Ab2F2POt (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Jun 2012 11:14:49 -0400
Received: from a.ns.miles-group.at ([95.130.255.143]:47843 "EHLO radon.swed.at"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932154Ab2F2POq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Jun 2012 11:14:46 -0400
From: Richard Weinberger <richard@nod.at>
To: linux-mtd@lists.infradead.org
Cc: linux-kernel@vger.kernel.org, adrian.hunter@intel.com,
        Heinz.Egger@linutronix.de, thomas.wucher@linutronix.de,
        shmulik.ladkani@gmail.com, tglx@linutronix.de, tim.bird@am.sony.com,
        Marius.Mazarel@ugal.ro, artem.bityutskiy@linux.intel.com,
        nyoushchenko@mvista.com, Richard Weinberger <richard@nod.at>
Subject: [PATCH 09/11] ubi: fastmap: Do not free 'ai' in 'scan_all()'
Date: Fri, 29 Jun 2012 17:14:27 +0200
Message-Id: <1340982869-77042-10-git-send-email-richard@nod.at>
X-Mailer: git-send-email 1.7.6.5
In-Reply-To: <1340982869-77042-1-git-send-email-richard@nod.at>
References: <1340982869-77042-1-git-send-email-richard@nod.at>
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
Signed-off-by: Richard Weinberger <richard@nod.at>
---
 drivers/mtd/ubi/attach.c |    4 +---
 1 files changed, 1 insertions(+), 3 deletions(-)

diff --git a/drivers/mtd/ubi/attach.c b/drivers/mtd/ubi/attach.c
index c30a0f6..a343a41 100644
--- a/drivers/mtd/ubi/attach.c
+++ b/drivers/mtd/ubi/attach.c
@@ -1237,7 +1237,7 @@ static int scan_all(struct ubi_device *ubi, struct ubi_attach_info *ai, int star
 
 	ech = kzalloc(ubi->ec_hdr_alsize, GFP_KERNEL);
 	if (!ech)
-		goto out_ai;
+		return err;
 
 	vidh = ubi_zalloc_vid_hdr(ubi, GFP_KERNEL);
 	if (!vidh)
@@ -1298,8 +1298,6 @@ out_vidh:
 	ubi_free_vid_hdr(ubi, vidh);
 out_ech:
 	kfree(ech);
-out_ai:
-	destroy_ai(ai);
 	return err;
 }
 
-- 
1.7.6.5

