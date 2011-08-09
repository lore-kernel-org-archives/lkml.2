Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752576Ab1HITlk (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Aug 2011 15:41:40 -0400
Received: from bear.ext.ti.com ([192.94.94.41]:38942 "EHLO bear.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751122Ab1HITjQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Aug 2011 15:39:16 -0400
From: <pavan_savoy@ti.com>
To: <gregkh@suse.de>, <linux-kernel@vger.kernel.org>
CC: <pavan_savoy@sify.com>, Pavan Savoy <pavan_savoy@ti.com>
Subject: [PATCH 5/8] drivers:misc: ti-st: reinit completion before send
Date: Tue, 9 Aug 2011 14:39:06 -0500
Message-ID: <1312918749-29627-15-git-send-email-pavan_savoy@ti.com>
X-Mailer: git-send-email 1.5.6.3
In-Reply-To: <1312918749-29627-14-git-send-email-pavan_savoy@ti.com>
References: <1312918749-29627-1-git-send-email-pavan_savoy@ti.com>
 <1312918749-29627-2-git-send-email-pavan_savoy@ti.com>
 <1312918749-29627-3-git-send-email-pavan_savoy@ti.com>
 <1312918749-29627-4-git-send-email-pavan_savoy@ti.com>
 <1312918749-29627-5-git-send-email-pavan_savoy@ti.com>
 <1312918749-29627-6-git-send-email-pavan_savoy@ti.com>
 <1312918749-29627-7-git-send-email-pavan_savoy@ti.com>
 <1312918749-29627-8-git-send-email-pavan_savoy@ti.com>
 <1312918749-29627-9-git-send-email-pavan_savoy@ti.com>
 <1312918749-29627-10-git-send-email-pavan_savoy@ti.com>
 <1312918749-29627-11-git-send-email-pavan_savoy@ti.com>
 <1312918749-29627-12-git-send-email-pavan_savoy@ti.com>
 <1312918749-29627-13-git-send-email-pavan_savoy@ti.com>
 <1312918749-29627-14-git-send-email-pavan_savoy@ti.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Pavan Savoy <pavan_savoy@ti.com>

download firmware behaves differently at different times, when logs are
enabled and the system is loaded, the wait_for_completion is able to wait for
every send, However during other times the wait does not happen.

So, for reliability reinitializing the completion before every send, makes
sure the wait happens for every send.

fixes: OMAPS00245110

Change-Id: Iff96d806a06338aadad65c43c272c205660c78d1
Signed-off-by: Pavan Savoy <pavan_savoy@ti.com>
---
 drivers/misc/ti-st/st_kim.c |    6 ++++++
 1 files changed, 6 insertions(+), 0 deletions(-)

diff --git a/drivers/misc/ti-st/st_kim.c b/drivers/misc/ti-st/st_kim.c
index e5639ca..1748a93 100644
--- a/drivers/misc/ti-st/st_kim.c
+++ b/drivers/misc/ti-st/st_kim.c
@@ -299,6 +299,7 @@ static long download_firmware(struct kim_data_s *kim_gdata)
 
 		switch (((struct bts_action *)ptr)->type) {
 		case ACTION_SEND_COMMAND:	/* action send */
+			pr_debug("S");
 			action_ptr = &(((struct bts_action *)ptr)->data[0]);
 			if (unlikely
 			    (((struct hci_command *)action_ptr)->opcode ==
@@ -336,6 +337,10 @@ static long download_firmware(struct kim_data_s *kim_gdata)
 				release_firmware(kim_gdata->fw_entry);
 				return -ETIMEDOUT;
 			}
+			/* reinit completion before sending for the
+			 * relevant wait
+			 */
+			INIT_COMPLETION(kim_gdata->kim_rcvd);
 
 			/*
 			 * Free space found in uart buffer, call st_int_write
@@ -362,6 +367,7 @@ static long download_firmware(struct kim_data_s *kim_gdata)
 			}
 			break;
 		case ACTION_WAIT_EVENT:  /* wait */
+			pr_debug("W");
 			if (!wait_for_completion_timeout
 					(&kim_gdata->kim_rcvd,
 					 msecs_to_jiffies(CMD_RESP_TIME))) {
-- 
1.7.4.1

