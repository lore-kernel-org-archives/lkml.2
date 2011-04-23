Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751496Ab1DWFKm (ORCPT <rfc822;w@1wt.eu>);
	Sat, 23 Apr 2011 01:10:42 -0400
Received: from mail-pz0-f46.google.com ([209.85.210.46]:44904 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750920Ab1DWFKl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 23 Apr 2011 01:10:41 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer;
        b=wp0PsJUGcmU/o9QFCldXnM2tBITCeJ4ISCbYenk7KfBd/wjDed4StCeqjUMeGevlf0
         bycTZnAIGqPJInkOMgUUua98IyOgoVudB6akvuGoEy5DYl3OUE5OiqCaMzyFnb81Vurc
         cOcSumuwoojF9GUzLF+XOhDBtgxnAsqhzay4Y=
From: Pavan Savoy <pavan.savoy@gmail.com>
To: greg@kroah.com, linux-kernel@vger.kernel.org
Cc: pavan_savoy@sify.com, Victor Goldenshtein <victorg@ti.com>,
        Pavan Savoy <pavan_savoy@ti.com>
Subject: [PATCH] drivers:misc:ti-st: fix skip remote baud logic
Date: Sat, 23 Apr 2011 10:38:17 +0530
Message-Id: <1303535297-2586-1-git-send-email-pavan_savoy@ti.com>
X-Mailer: git-send-email 1.7.0.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Victor Goldenshtein <victorg@ti.com>

Texas Instruments WiLink connectivity combo chipsets support custom baud
rates over its UART interface.
This can be achieved by sending the change remote baud rate command.
Since the baud rate can be properly set by the user-space on shared
transport the remote chip-side and local host-side baud rate is change
by the User Space Init Manager.

This patch when encounters the same command inside the firmware,
attempts to skip such command since it is handled by the user-space.
The logic to skip the command when it is un-commented is fixed by this
patch.

Signed-off-by: Pavan Savoy <pavan_savoy@ti.com>
Signed-off-by: Victor Goldenshtein <victorg@ti.com>
Author:    Victor Goldenshtein <victorg@ti.com>
---
 drivers/misc/ti-st/st_kim.c |    6 ++++--
 1 files changed, 4 insertions(+), 2 deletions(-)

diff --git a/drivers/misc/ti-st/st_kim.c b/drivers/misc/ti-st/st_kim.c
index b4488c8..57c71fa 100644
--- a/drivers/misc/ti-st/st_kim.c
+++ b/drivers/misc/ti-st/st_kim.c
@@ -244,9 +244,9 @@ void skip_change_remote_baud(unsigned char **ptr, long *len)
 		pr_err("invalid action after change remote baud command");
 	} else {
 		*ptr = *ptr + sizeof(struct bts_action) +
-			((struct bts_action *)nxt_action)->size;
+			((struct bts_action *)cur_action)->size;
 		*len = *len - (sizeof(struct bts_action) +
-				((struct bts_action *)nxt_action)->size);
+				((struct bts_action *)cur_action)->size);
 		/* warn user on not commenting these in firmware */
 		pr_warn("skipping the wait event of change remote baud");
 	}
@@ -385,6 +385,8 @@ static long download_firmware(struct kim_data_s *kim_gdata)
 	}
 	/* fw download complete */
 	release_firmware(kim_gdata->fw_entry);
+	if (len != 0)
+		pr_err("%s:failed, script not parsed completely", __func__);
 	return 0;
 }
 
-- 
1.7.0.4

