Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752426Ab1HVOto (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Aug 2011 10:49:44 -0400
Received: from mgw2.diku.dk ([130.225.96.92]:56351 "EHLO mgw2.diku.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751636Ab1HVOtm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Aug 2011 10:49:42 -0400
Date: Mon, 22 Aug 2011 16:49:35 +0200 (CEST)
From: Julia Lawall <julia@diku.dk>
To: Jesper Juhl <jj@chaosbits.net>
Cc: Robert Love <robert.w.love@intel.com>, kernel-janitors@vger.kernel.org,
        "James E.J. Bottomley" <JBottomley@parallels.com>, devel@open-fcoe.org,
        linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/4] drivers/scsi/fcoe/fcoe.c: add missing test
In-Reply-To: <alpine.LNX.2.00.1108221632130.9774@swampdragon.chaosbits.net>
Message-ID: <Pine.LNX.4.64.1108221648560.10948@ask.diku.dk>
References: <1314021636-11528-2-git-send-email-julia@diku.dk>
 <alpine.LNX.2.00.1108221632130.9774@swampdragon.chaosbits.net>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>From nobody Mon Aug 22 15:57:42 CEST 2011
From: Julia Lawall <julia@diku.dk>
To: Robert Love <robert.w.love@intel.com>
Cc: "James E.J. Bottomley" <JBottomley@parallels.com>,devel@open-fcoe.org,linux-scsi@vger.kernel.org,linux-kernel@vger.kernel.org
Subject: [PATCH 2/4] drivers/scsi/fcoe/fcoe.c: add missing test

From: Julia Lawall <julia@diku.dk>

The initializations of both fcoe_nport_scsi_transport and
fcoe_vport_scsi_transport can fail, so test both of them.

The semantic match that finds this problem is as follows:
(http://coccinelle.lip6.fr/)

// <smpl>
@r@
identifier x,y,f!={PTR_ERR,ERR_PTR,ERR_CAST};
statement S;
@@

x = f(...);
(
if (\(x == NULL\|IS_ERR(x)\)) S
|
*if (\(y == NULL\|IS_ERR(y)\))
 { ... when != x
   return ...; }
)
// </smpl>

Signed-off-by: Julia Lawall <julia@diku.dk>

---
 drivers/scsi/fcoe/fcoe.c |   13 +++++++++++--
 1 file changed, 11 insertions(+), 2 deletions(-)

diff --git a/drivers/scsi/fcoe/fcoe.c b/drivers/scsi/fcoe/fcoe.c
index ba710e3..9f2e2f4 100644
--- a/drivers/scsi/fcoe/fcoe.c
+++ b/drivers/scsi/fcoe/fcoe.c
@@ -1093,11 +1093,20 @@ static int __init fcoe_if_init(void)
 	/* attach to scsi transport */
 	fcoe_nport_scsi_transport =
 		fc_attach_transport(&fcoe_nport_fc_functions);
+
+	if (!fcoe_nport_scsi_transport) {
+		printk(KERN_ERR
+		       "fcoe_nport: Failed to attach to the FC transport\n");
+		return -ENODEV;
+	}
+
 	fcoe_vport_scsi_transport =
 		fc_attach_transport(&fcoe_vport_fc_functions);
 
-	if (!fcoe_nport_scsi_transport) {
-		printk(KERN_ERR "fcoe: Failed to attach to the FC transport\n");
+	if (!fcoe_vport_scsi_transport) {
+		printk(KERN_ERR
+		       "fcoe_vport: Failed to attach to the FC transport\n");
+		fc_release_transport(fcoe_nport_scsi_transport);
 		return -ENODEV;
 	}
 
