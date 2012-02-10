Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758801Ab2BJAC2 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Feb 2012 19:02:28 -0500
Received: from mx1.redhat.com ([209.132.183.28]:2101 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758733Ab2BJABk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Feb 2012 19:01:40 -0500
From: Mauro Carvalho Chehab <mchehab@redhat.com>
Cc: Mauro Carvalho Chehab <mchehab@redhat.com>,
        Linux Edac Mailing List <linux-edac@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: [PATCH v3 28/31] edac: don't OOPS if the csrow is not visible
Date: Thu,  9 Feb 2012 22:01:27 -0200
Message-Id: <1328832090-9166-29-git-send-email-mchehab@redhat.com>
In-Reply-To: <1328832090-9166-1-git-send-email-mchehab@redhat.com>
References: <1328832090-9166-1-git-send-email-mchehab@redhat.com>
To: unlisted-recipients:; (no To-header on input)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

[  119.831403] EDAC DEBUG: edac_mc_handle_error: edac_mc_handle_error: incrementing csrows (-1,0)
[  119.831418] BUG: unable to handle kernel paging request at 000000010000001b
[  119.838677] IP: [<ffffffffa0131276>] edac_mc_handle_error+0x45e/0x8c1 [edac_core]

Signed-off-by: Mauro Carvalho Chehab <mchehab@redhat.com>
---
 drivers/edac/edac_mc.c |    9 ++++++---
 1 files changed, 6 insertions(+), 3 deletions(-)

diff --git a/drivers/edac/edac_mc.c b/drivers/edac/edac_mc.c
index 91545a5..4145fa6 100644
--- a/drivers/edac/edac_mc.c
+++ b/drivers/edac/edac_mc.c
@@ -1029,11 +1029,14 @@ void edac_mc_handle_error(const enum hw_event_mc_err_type type,
 	if (!enable_filter) {
 		strcpy(label, "any memory");
 	} else {
+		debugf4("%s: incrementing csrows (%d,%d)\n",
+			__func__, row, chan);
 		if (type == HW_EVENT_ERR_CORRECTED) {
-			if (row >= 0)
+			if (row >= 0) {
 				mci->csrows[row].ce_count++;
-			if (chan >= 0)
-				mci->csrows[row].channels[chan].ce_count++;
+				if (chan >= 0)
+					mci->csrows[row].channels[chan].ce_count++;
+			}
 		} else
 			if (row >= 0)
 				mci->csrows[row].ue_count++;
-- 
1.7.8

