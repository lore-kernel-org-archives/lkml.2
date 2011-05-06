Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932484Ab1EFAm0 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 May 2011 20:42:26 -0400
Received: from kroah.org ([198.145.64.141]:37222 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932375Ab1EFAZr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 May 2011 20:25:47 -0400
X-Mailbox-Line: From gregkh@clark.kroah.org Thu May  5 17:22:16 2011
Message-Id: <20110506002216.331500595@clark.kroah.org>
User-Agent: quilt/0.48-16.4
Date: Thu, 05 May 2011 17:21:38 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Hannes Reinecke <hare@suse.de>, Mike Christie <michaelc@cs.wisc.edu>,
        James Bottomley <James.Bottomley@suse.de>
Subject: [113/143] scsi_dh_emc: fix mode select request setup
In-Reply-To: <20110506002311.GA15354@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.32-longterm review patch.  If anyone has any objections, please let us know.

------------------

From: Hannes Reinecke <hare@suse.de>

commit 6c71dcb28ff9b63b814a0b76a256f5dae08d3e0d upstream.

This patch fixes the request setup code for mode selects. I got the fixes from
Hannes Reinecke while trying to hunt down some problems and merged it
into one patch. I am sending it because Hannes is busy with other things.

The patch fixes:
- setting of the length for mode selects.
- setting of the data direction for mode select 10.

Signed-off-by: Hannes Reinecke <hare@suse.de>
Signed-off-by: Mike Christie <michaelc@cs.wisc.edu>
Signed-off-by: James Bottomley <James.Bottomley@suse.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
---
 drivers/scsi/device_handler/scsi_dh_emc.c |    6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

--- a/drivers/scsi/device_handler/scsi_dh_emc.c
+++ b/drivers/scsi/device_handler/scsi_dh_emc.c
@@ -272,7 +272,7 @@ static struct request *get_req(struct sc
 	int len = 0;
 
 	rq = blk_get_request(sdev->request_queue,
-			(cmd == MODE_SELECT) ? WRITE : READ, GFP_NOIO);
+			(cmd != INQUIRY) ? WRITE : READ, GFP_NOIO);
 	if (!rq) {
 		sdev_printk(KERN_INFO, sdev, "get_req: blk_get_request failed");
 		return NULL;
@@ -286,14 +286,17 @@ static struct request *get_req(struct sc
 		len = sizeof(short_trespass);
 		rq->cmd_flags |= REQ_RW;
 		rq->cmd[1] = 0x10;
+		rq->cmd[4] = len;
 		break;
 	case MODE_SELECT_10:
 		len = sizeof(long_trespass);
 		rq->cmd_flags |= REQ_RW;
 		rq->cmd[1] = 0x10;
+		rq->cmd[8] = len;
 		break;
 	case INQUIRY:
 		len = CLARIION_BUFFER_SIZE;
+		rq->cmd[4] = len;
 		memset(buffer, 0, len);
 		break;
 	default:
@@ -301,7 +304,6 @@ static struct request *get_req(struct sc
 		break;
 	}
 
-	rq->cmd[4] = len;
 	rq->cmd_type = REQ_TYPE_BLOCK_PC;
 	rq->cmd_flags |= REQ_FAILFAST_DEV | REQ_FAILFAST_TRANSPORT |
 			 REQ_FAILFAST_DRIVER;


