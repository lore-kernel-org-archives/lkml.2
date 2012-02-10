Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758809Ab2BJADE (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Feb 2012 19:03:04 -0500
Received: from mx1.redhat.com ([209.132.183.28]:53031 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758731Ab2BJABk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Feb 2012 19:01:40 -0500
From: Mauro Carvalho Chehab <mchehab@redhat.com>
Cc: Mauro Carvalho Chehab <mchehab@redhat.com>,
        Linux Edac Mailing List <linux-edac@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: [PATCH v3 29/31] edac: Fix sysfs csrow?/*ce*count counters
Date: Thu,  9 Feb 2012 22:01:28 -0200
Message-Id: <1328832090-9166-30-git-send-email-mchehab@redhat.com>
In-Reply-To: <1328832090-9166-1-git-send-email-mchehab@redhat.com>
References: <1328832090-9166-1-git-send-email-mchehab@redhat.com>
To: unlisted-recipients:; (no To-header on input)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Fix a bug at the logic that were preventing error counts at the
same csrow/channel to be properly incremented.

Signed-off-by: Mauro Carvalho Chehab <mchehab@redhat.com>
---
 drivers/edac/edac_mc.c |   23 +++++++++++------------
 1 files changed, 11 insertions(+), 12 deletions(-)

diff --git a/drivers/edac/edac_mc.c b/drivers/edac/edac_mc.c
index 4145fa6..3f74ba9 100644
--- a/drivers/edac/edac_mc.c
+++ b/drivers/edac/edac_mc.c
@@ -1013,23 +1013,22 @@ void edac_mc_handle_error(const enum hw_event_mc_err_type type,
 			 * get csrow/channel of the dimm, in order to allow
 			 * incrementing the compat API counters
 			 */
-			if (mci->layers[i].is_csrow) {
-				if (row == -1)
-					row = dimm->csrow;
-				else if (row >= 0 && row != dimm->csrow)
-					row = -2;
-			} else {
-				if (chan == -1)
-					chan = dimm->cschannel;
-				else if (chan >= 0 && chan != dimm->cschannel)
-					chan = -2;
-			}
+			debugf4("%s: dimm csrows (%d,%d)\n",
+				__func__, dimm->csrow, dimm->cschannel);
+			if (row == -1)
+				row = dimm->csrow;
+			else if (row >= 0 && row != dimm->csrow)
+				row = -2;
+			if (chan == -1)
+				chan = dimm->cschannel;
+			else if (chan >= 0 && chan != dimm->cschannel)
+				chan = -2;
 		}
 	}
 	if (!enable_filter) {
 		strcpy(label, "any memory");
 	} else {
-		debugf4("%s: incrementing csrows (%d,%d)\n",
+		debugf4("%s: csrow/channel to increment: (%d,%d)\n",
 			__func__, row, chan);
 		if (type == HW_EVENT_ERR_CORRECTED) {
 			if (row >= 0) {
-- 
1.7.8

