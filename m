Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753317Ab3AGPaf (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Jan 2013 10:30:35 -0500
Received: from g1t0029.austin.hp.com ([15.216.28.36]:45453 "EHLO
	g1t0029.austin.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752745Ab3AGPae (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Jan 2013 10:30:34 -0500
Subject: [PATCH] cciss: use lun reset not target reset
To: jens.axboe@kernel.dk
From: "Stephen M. Cameron" <scameron@beardog.cce.hp.com>
Cc: stephenmcameron@gmail.com, akpm@linux-foundation.org,
        mikem@beardog.cce.hp.com, linux-kernel@vger.kernel.org,
        thenzl@redhat.com
Date: Mon, 07 Jan 2013 10:30:30 -0600
Message-ID: <20130107163030.5072.17662.stgit@beardog.cce.hp.com>
User-Agent: StGit/0.15
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Stephen M. Cameron <scameron@beardog.cce.hp.com>

In the scsi part of the driver (for tape drives and medium changers)
the device reset error handler attempts to use a target reset rather
than a lun reset.  If there is some shared tape drive library, this
could be potentially disruptive to other hosts trying to use the
tape library.  Use lun reset instead to only reset the lun not the
whole target.

Signed-off-by: Stephen M. Cameron <scameron@beardog.cce.hp.com>
---
 drivers/block/cciss.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/block/cciss.c b/drivers/block/cciss.c
index 6526157..64d1d82 100644
--- a/drivers/block/cciss.c
+++ b/drivers/block/cciss.c
@@ -2632,7 +2632,7 @@ static int fill_cmd(ctlr_info_t *h, CommandList_struct *c, __u8 cmd, void *buff,
 			c->Request.Timeout = 0;
 			memset(&c->Request.CDB[0], 0, sizeof(c->Request.CDB));
 			c->Request.CDB[0] = cmd;	/* reset */
-			c->Request.CDB[1] = CCISS_RESET_TYPE_TARGET;
+			c->Request.CDB[1] = CCISS_RESET_TYPE_LUN;
 			break;
 		case CCISS_NOOP_MSG:
 			c->Request.CDBLen = 1;
@@ -2674,7 +2674,7 @@ static int __devinit cciss_send_reset(ctlr_info_t *h, unsigned char *scsi3addr,
 		return -ENOMEM;
 	return_status = fill_cmd(h, c, CCISS_RESET_MSG, NULL, 0, 0,
 		CTLR_LUNID, TYPE_MSG);
-	c->Request.CDB[1] = reset_type; /* fill_cmd defaults to target reset */
+	c->Request.CDB[1] = reset_type; /* fill_cmd defaults to lun reset */
 	if (return_status != IO_OK) {
 		cmd_special_free(h, c);
 		return return_status;

