Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755228Ab1HZUfJ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Aug 2011 16:35:09 -0400
Received: from cantor2.suse.de ([195.135.220.15]:37042 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755216Ab1HZUe3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Aug 2011 16:34:29 -0400
From: Greg Kroah-Hartman <gregkh@suse.de>
To: linux-kernel@vger.kernel.org
Cc: Pavan Savoy <pavan_savoy@ti.com>, Greg Kroah-Hartman <gregkh@suse.de>
Subject: [PATCH 10/13] drivers:misc: ti-st: reinit completion before send
Date: Fri, 26 Aug 2011 13:33:51 -0700
Message-Id: <1314390834-3411-10-git-send-email-gregkh@suse.de>
X-Mailer: git-send-email 1.7.6.1
In-Reply-To: <1314390834-3411-1-git-send-email-gregkh@suse.de>
References: <20110826191130.GA5557@kroah.com>
 <1314390834-3411-1-git-send-email-gregkh@suse.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Pavan Savoy <pavan_savoy@ti.com>

download firmware behaves differently at different times, when logs are
enabled and the system is loaded, the wait_for_completion is able to wait for
every send, However during other times the wait does not happen.

So, for reliability reinitializing the completion before every send, makes
sure the wait happens for every send.

Signed-off-by: Pavan Savoy <pavan_savoy@ti.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
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
1.7.6.1

