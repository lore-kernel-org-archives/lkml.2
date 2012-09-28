Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1031521Ab2I1Tlg (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Sep 2012 15:41:36 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:33712 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932323Ab2I1S77 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Sep 2012 14:59:59 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Greg KH <gregkh@linuxfoundation.org>, alan@lxorguk.ukuu.org.uk,
        "Stephen M. Cameron" <scameron@beardog.cce.hp.com>,
        James Bottomley <JBottomley@Parallels.com>
Subject: [ 124/262] SCSI: hpsa: fix handling of protocol error
Date: Fri, 28 Sep 2012 11:50:53 -0700
Message-Id: <20120928183012.704081317@linuxfoundation.org>
X-Mailer: git-send-email 1.7.10.1.362.g242cab3
In-Reply-To: <20120928182957.993484211@linuxfoundation.org>
References: <20120928182957.993484211@linuxfoundation.org>
User-Agent: quilt/0.60-2.1.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Greg KH <gregkh@linuxfoundation.org>

3.5-stable review patch.  If anyone has any objections, please let me know.

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
@@ -1315,8 +1315,9 @@ static void complete_scsi_command(struct
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


