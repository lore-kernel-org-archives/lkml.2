Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756992Ab2INVfS (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Sep 2012 17:35:18 -0400
Received: from g4t0015.houston.hp.com ([15.201.24.18]:40355 "EHLO
	g4t0015.houston.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756641Ab2INVfQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Sep 2012 17:35:16 -0400
Subject: [PATCH] cciss: fix handling of protocol error
To: axboe@kernel.dk
From: "Stephen M. Cameron" <scameron@beardog.cce.hp.com>
Cc: stephenmcameron@gmail.com, akpm@linux-foundation.org,
        mikem@beardog.cce.hp.com, linux-kernel@vger.kernel.org,
        thenzl@redhat.com
Date: Fri, 14 Sep 2012 16:35:10 -0500
Message-ID: <20120914213510.12067.52801.stgit@beardog.cce.hp.com>
User-Agent: StGit/0.15
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Stephen M. Cameron <scameron@beardog.cce.hp.com>

If a command completes with a status of CMD_PROTOCOL_ERR, this
information should be conveyed to the SCSI mid layer, not dropped
on the floor.  Unlike a similar bug in the hpsa driver, this bug
only affects tape drives and CD and DVD ROM drives in the cciss
driver, and to induce it, you have to disconnect (or damage) a
cable, so it is not a very likely scenario (which would explain
why the bug has gone undetected for the last 10 years.)

Signed-off-by: Stephen M. Cameron <scameron@beardog.cce.hp.com>
Cc: stable@vger.kernel.org
---
 drivers/block/cciss_scsi.c |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/drivers/block/cciss_scsi.c b/drivers/block/cciss_scsi.c
index 38aa6dd..da33111 100644
--- a/drivers/block/cciss_scsi.c
+++ b/drivers/block/cciss_scsi.c
@@ -795,6 +795,7 @@ static void complete_scsi_command(CommandList_struct *c, int timeout,
 				}
 			break;
 			case CMD_PROTOCOL_ERR:
+				cmd->result = DID_ERROR << 16;
 				dev_warn(&h->pdev->dev,
 					"%p has protocol error\n", c);
                         break;

