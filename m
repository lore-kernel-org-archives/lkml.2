Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759222Ab2INSFh (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Sep 2012 14:05:37 -0400
Received: from mail.digium.com ([216.207.245.2]:50928 "EHLO mail.digium.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753413Ab2INSFe (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Sep 2012 14:05:34 -0400
From: Shaun Ruffell <sruffell@digium.com>
To: Mauro Carvalho Chehab <mchehab@redhat.com>
Cc: linux-kernel@vger.kernel.org, linux-edac@vger.kernel.org
Subject: [PATCH v2 1/3] edac_mc: fix kfree calls in the error path
Date: Fri, 14 Sep 2012 12:58:16 -0500
Message-Id: <1347645498-21215-2-git-send-email-sruffell@digium.com>
X-Mailer: git-send-email 1.7.11.2
In-Reply-To: <1347645498-21215-1-git-send-email-sruffell@digium.com>
References: <1345349484-31552-1-git-send-email-sruffell@digium.com>
 <1347645498-21215-1-git-send-email-sruffell@digium.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Fengguang Wu <fengguang.wu@intel.com>

From: Fengguang Wu <fengguang.wu@intel.com>

We need to free up memory in this order:

  free csrows[i]->channels[j]
  free csrows[i]->channels
  free csrows[i]
  free csrows

Signed-off-by: Fengguang Wu <fengguang.wu@intel.com>
---
 drivers/edac/edac_mc.c | 12 +++++++-----
 1 file changed, 7 insertions(+), 5 deletions(-)

diff --git a/drivers/edac/edac_mc.c b/drivers/edac/edac_mc.c
index 616d90b..9037ffa 100644
--- a/drivers/edac/edac_mc.c
+++ b/drivers/edac/edac_mc.c
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
-- 
1.7.11.2

