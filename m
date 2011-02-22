Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752084Ab1BVUOk (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Feb 2011 15:14:40 -0500
Received: from g4t0017.houston.hp.com ([15.201.24.20]:39290 "EHLO
	g4t0017.houston.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751755Ab1BVUOh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Feb 2011 15:14:37 -0500
Subject: [PATCH 5/6] cciss: fix missed command status value CMD_UNABORTABLE
To: axboe@kernel.dk
From: "Stephen M. Cameron" <scameron@beardog.cce.hp.com>
Cc: mikem@beardog.cce.hp.com, akpm@linux-foundation.org, thenzl@redhat.com,
        linux-kernel@vger.kernel.org, smcameron@yahoo.com
Date: Tue, 22 Feb 2011 14:14:37 -0600
Message-ID: <20110222201437.21961.85261.stgit@beardog.cce.hp.com>
In-Reply-To: <20110222201025.21961.82560.stgit@beardog.cce.hp.com>
References: <20110222201025.21961.82560.stgit@beardog.cce.hp.com>
User-Agent: StGit/0.15
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Stephen M. Cameron <scameron@beardog.cce.hp.com>

and fix a nearby typo, "do" that should have been "due"

Signed-off-by: Stephen M. Cameron <scameron@beardog.cce.hp.com>
---
 drivers/block/cciss.c      |   11 +++++++++++
 drivers/block/cciss_scsi.c |   13 +++++++++++--
 2 files changed, 22 insertions(+), 2 deletions(-)

diff --git a/drivers/block/cciss.c b/drivers/block/cciss.c
index 6110918..c7f073b 100644
--- a/drivers/block/cciss.c
+++ b/drivers/block/cciss.c
@@ -2652,6 +2652,10 @@ static int process_sendcmd_error(ctlr_info_t *h, CommandList_struct *c)
 			c->Request.CDB[0]);
 		return_status = IO_NEEDS_RETRY;
 		break;
+	case CMD_UNABORTABLE:
+		dev_warn(&h->pdev->dev, "cmd unabortable\n");
+		return_status = IO_ERROR;
+		break;
 	default:
 		dev_warn(&h->pdev->dev, "cmd 0x%02x returned "
 		       "unknown status %x\n", c->Request.CDB[0],
@@ -3102,6 +3106,13 @@ static inline void complete_command(ctlr_info_t *h, CommandList_struct *cmd,
 			(cmd->rq->cmd_type == REQ_TYPE_BLOCK_PC) ?
 				DID_PASSTHROUGH : DID_ERROR);
 		break;
+	case CMD_UNABORTABLE:
+		dev_warn(&h->pdev->dev, "cmd %p unabortable\n", cmd);
+		rq->errors = make_status_bytes(SAM_STAT_GOOD,
+			cmd->err_info->CommandStatus, DRIVER_OK,
+			cmd->rq->cmd_type == REQ_TYPE_BLOCK_PC ?
+				DID_PASSTHROUGH : DID_ERROR);
+		break;
 	default:
 		dev_warn(&h->pdev->dev, "cmd %p returned "
 		       "unknown status %x\n", cmd,
diff --git a/drivers/block/cciss_scsi.c b/drivers/block/cciss_scsi.c
index 727d022..df79380 100644
--- a/drivers/block/cciss_scsi.c
+++ b/drivers/block/cciss_scsi.c
@@ -824,13 +824,18 @@ static void complete_scsi_command(CommandList_struct *c, int timeout,
 			break;
 			case CMD_UNSOLICITED_ABORT:
 				cmd->result = DID_ABORT << 16;
-				dev_warn(&h->pdev->dev, "%p aborted do to an "
+				dev_warn(&h->pdev->dev, "%p aborted due to an "
 					"unsolicited abort\n", c);
 			break;
 			case CMD_TIMEOUT:
 				cmd->result = DID_TIME_OUT << 16;
 				dev_warn(&h->pdev->dev, "%p timedout\n", c);
 			break;
+			case CMD_UNABORTABLE:
+				cmd->result = DID_ERROR << 16;
+				dev_warn(&h->pdev->dev, "c %p command "
+					"unabortable\n", c);
+			break;
 			default:
 				cmd->result = DID_ERROR << 16;
 				dev_warn(&h->pdev->dev,
@@ -1007,11 +1012,15 @@ cciss_scsi_interpret_error(ctlr_info_t *h, CommandList_struct *c)
 		break;
 		case CMD_UNSOLICITED_ABORT:
 			dev_warn(&h->pdev->dev,
-				"%p aborted do to an unsolicited abort\n", c);
+				"%p aborted due to an unsolicited abort\n", c);
 		break;
 		case CMD_TIMEOUT:
 			dev_warn(&h->pdev->dev, "%p timedout\n", c);
 		break;
+		case CMD_UNABORTABLE:
+			dev_warn(&h->pdev->dev,
+				"%p unabortable\n", c);
+		break;
 		default:
 			dev_warn(&h->pdev->dev,
 				"%p returned unknown status %x\n",

