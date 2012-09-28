Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1031324Ab2I1U0z (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Sep 2012 16:26:55 -0400
Received: from mail-pa0-f46.google.com ([209.85.220.46]:43081 "EHLO
	mail-pa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1032498Ab2I1U0w (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Sep 2012 16:26:52 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, alan@lxorguk.ukuu.org.uk,
        "Stephen M. Cameron" <scameron@beardog.cce.hp.com>,
        James Bottomley <JBottomley@Parallels.com>
Subject: [ 098/218] SCSI: hpsa: fix handling of protocol error
Date: Fri, 28 Sep 2012 13:15:15 -0700
Message-Id: <20120928201512.802091005@linuxfoundation.org>
X-Mailer: git-send-email 1.7.12.1.428.g652398a
In-Reply-To: <20120928201501.208384923@linuxfoundation.org>
References: <20120928201501.208384923@linuxfoundation.org>
User-Agent: quilt/0.60-2.1.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.4-stable review patch.  If anyone has any objections, please let me know.

------------------

From: "Stephen M. Cameron" <scameron@beardog.cce.hp.com>

commit 256d0eaac87da1e993190846064f339f4c7a63f5 upstream.

If a command status of CMD_PROTOCOL_ERR is received, this
information should be conveyed to the SCSI mid layer, not
dropped on the floor.  CMD_PROTOCOL_ERR may be received
from the Smart Array for any commands destined for an external
RAID controller such as a P2000, or commands destined for tape
drives or CD/DVD-ROM drives, if for instance a cable is
disconnected.  This mostly affects multipath configurations, as
disconnecting a cable on a non-multipath configuration is not
going to do anything good regardless of whether CMD_PROTOCOL_ERR
is handled correctly or not.  Not handling CMD_PROTOCOL_ERR
correctly in a multipath configaration involving external RAID
controllers may cause data corruption, so this is quite a serious
bug.  This bug should not normally cause a problem for direct
attached disk storage.

Signed-off-by: Stephen M. Cameron <scameron@beardog.cce.hp.com>
Signed-off-by: James Bottomley <JBottomley@Parallels.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/scsi/hpsa.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

--- a/drivers/scsi/hpsa.c
+++ b/drivers/scsi/hpsa.c
@@ -1264,8 +1264,9 @@ static void complete_scsi_command(struct
 	}
 		break;
 	case CMD_PROTOCOL_ERR:
+		cmd->result = DID_ERROR << 16;
 		dev_warn(&h->pdev->dev, "cp %p has "
-			"protocol error \n", cp);
+			"protocol error\n", cp);
 		break;
 	case CMD_HARDWARE_ERR:
 		cmd->result = DID_ERROR << 16;


