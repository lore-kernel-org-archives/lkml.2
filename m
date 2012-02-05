Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754569Ab2BEWip (ORCPT <rfc822;w@1wt.eu>);
	Sun, 5 Feb 2012 17:38:45 -0500
Received: from 1wt.eu ([62.212.114.60]:62060 "EHLO 1wt.eu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754119Ab2BEW0u (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 5 Feb 2012 17:26:50 -0500
Message-Id: <20120205220952.826423599@pcw.home.local>
User-Agent: quilt/0.48-1
Date: Sun, 05 Feb 2012 23:11:08 +0100
From: Willy Tarreau <w@1wt.eu>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Jiri Slaby <jirislaby@gmail.com>,
        James Bottomley <James.Bottomley@suse.de>,
        Greg KH <gregkh@linuxfoundation.org>
Subject: [PATCH 79/91] SCSI: scsi_lib: fix potential NULL dereference
In-Reply-To: <0635750f5f06ed2ca212b91fcb5c4483@local>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.27-longterm review patch.  If anyone has any objections, please let us know.

------------------

commit 03b147083a2f9a2a3fbbd2505fa88ffa3c6ab194 upstream.

Stanse found a potential NULL dereference in scsi_kill_request.

Instead of triggering BUG() in 'if (unlikely(cmd == NULL))' branch,
the kernel will Oops earlier on cmd dereference.

Move the dereferences after the if.

[ WT: starget is not set in 2.6.27 ]

Signed-off-by: Jiri Slaby <jirislaby@gmail.com>
Signed-off-by: James Bottomley <James.Bottomley@suse.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
---
 drivers/scsi/scsi_lib.c |    9 ++++++---
 1 files changed, 6 insertions(+), 3 deletions(-)

Index: longterm-2.6.27/drivers/scsi/scsi_lib.c
===================================================================
--- longterm-2.6.27.orig/drivers/scsi/scsi_lib.c	2012-02-05 22:34:42.697916475 +0100
+++ longterm-2.6.27/drivers/scsi/scsi_lib.c	2012-02-05 22:34:46.142917247 +0100
@@ -1389,8 +1389,8 @@
 static void scsi_kill_request(struct request *req, struct request_queue *q)
 {
 	struct scsi_cmnd *cmd = req->special;
-	struct scsi_device *sdev = cmd->device;
-	struct Scsi_Host *shost = sdev->host;
+	struct scsi_device *sdev;
+	struct Scsi_Host *shost;
 
 	blkdev_dequeue_request(req);
 
@@ -1400,6 +1400,8 @@
 		BUG();
 	}
 
+	sdev = cmd->device;
+	shost = sdev->host;
 	scsi_init_cmd_errh(cmd);
 	cmd->result = DID_NO_CONNECT << 16;
 	atomic_inc(&cmd->device->iorequest_cnt);


