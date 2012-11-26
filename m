Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932134Ab2KZRDb (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Nov 2012 12:03:31 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:47290 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932110Ab2KZRDZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Nov 2012 12:03:25 -0500
From: Herton Ronaldo Krzesinski <herton.krzesinski@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: "K. Y. Srinivasan" <kys@microsoft.com>,
        James Bottomley <JBottomley@Parallels.com>,
        Herton Ronaldo Krzesinski <herton.krzesinski@canonical.com>
Subject: [PATCH 058/270] storvsc: Account for in-transit packets in the RESET path
Date: Mon, 26 Nov 2012 14:55:48 -0200
Message-Id: <1353949160-26803-59-git-send-email-herton.krzesinski@canonical.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1353949160-26803-1-git-send-email-herton.krzesinski@canonical.com>
References: <1353949160-26803-1-git-send-email-herton.krzesinski@canonical.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.5.7u1 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: "K. Y. Srinivasan" <kys@microsoft.com>

commit 5c1b10ab7f93d24f29b5630286e323d1c5802d5c upstream.

Properly account for I/O in transit before returning from the RESET call.
In the absense of this patch, we could have a situation where the host may
respond to a command that was issued prior to the issuance of the RESET
command at some arbitrary time after responding to the RESET command.
Currently, the host does not do anything with the RESET command.

Signed-off-by: K. Y. Srinivasan <kys@microsoft.com>
Signed-off-by: James Bottomley <JBottomley@Parallels.com>
Signed-off-by: Herton Ronaldo Krzesinski <herton.krzesinski@canonical.com>
---
 drivers/scsi/storvsc_drv.c |    5 +++++
 1 file changed, 5 insertions(+)

diff --git a/drivers/scsi/storvsc_drv.c b/drivers/scsi/storvsc_drv.c
index 528d52b..0144078 100644
--- a/drivers/scsi/storvsc_drv.c
+++ b/drivers/scsi/storvsc_drv.c
@@ -1221,7 +1221,12 @@ static int storvsc_host_reset_handler(struct scsi_cmnd *scmnd)
 	/*
 	 * At this point, all outstanding requests in the adapter
 	 * should have been flushed out and return to us
+	 * There is a potential race here where the host may be in
+	 * the process of responding when we return from here.
+	 * Just wait for all in-transit packets to be accounted for
+	 * before we return from here.
 	 */
+	storvsc_wait_to_drain(stor_device);
 
 	return SUCCESS;
 }
-- 
1.7.9.5

