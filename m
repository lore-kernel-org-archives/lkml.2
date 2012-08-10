Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758262Ab2HJJW7 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Aug 2012 05:22:59 -0400
Received: from mga11.intel.com ([192.55.52.93]:58472 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757948Ab2HJJW4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Aug 2012 05:22:56 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.77,744,1336374000"; 
   d="scan'208";a="196487130"
Date: Fri, 10 Aug 2012 17:22:23 +0800
From: Fengguang Wu <fengguang.wu@intel.com>
To: Mauro Carvalho Chehab <mchehab@redhat.com>
Cc: Dave Peterson <dsp@llnl.gov>, kernel-janitors@vger.kernel.org,
        Doug Thompson <dougthompson@xmission.com>, linux-edac@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH] edac_mc: fix kfree calls in the error path
Message-ID: <20120810092223.GA27375@localhost>
References: <20120809135416.GA13100@localhost>
 <5023F360.2050409@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <5023F360.2050409@redhat.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

We need to free up memory in this order: 

  free csrows[i]->channels[j]
  free csrows[i]->channels
  free csrows[i]
  free csrows

Signed-off-by: Fengguang Wu <fengguang.wu@intel.com>
---
 drivers/edac/edac_mc.c |   12 +++++++-----
 1 file changed, 7 insertions(+), 5 deletions(-)

--- linux.orig/drivers/edac/edac_mc.c	2012-08-10 17:16:14.444794060 +0800
+++ linux/drivers/edac/edac_mc.c	2012-08-10 17:16:19.048794169 +0800
@@ -419,14 +419,16 @@ error:
 		kfree(mci->dimms);
 	}
 	if (mci->csrows) {
-		for (chn = 0; chn < tot_channels; chn++) {
-			csr = mci->csrows[chn];
+		for (row = 0; row < tot_csrows; row++) {
+			csr = mci->csrows[row];
 			if (csr) {
-				for (chn = 0; chn < tot_channels; chn++)
-					kfree(csr->channels[chn]);
+				if (csr->channels) {
+					for (chn = 0; chn < tot_channels; chn++)
+						kfree(csr->channels[chn]);
+					kfree(csr->channels);
+				}
 				kfree(csr);
 			}
-			kfree(mci->csrows[i]);
 		}
 		kfree(mci->csrows);
 	}
