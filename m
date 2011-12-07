Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757492Ab1LGREF (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Dec 2011 12:04:05 -0500
Received: from cantor2.suse.de ([195.135.220.15]:39440 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754671Ab1LGREB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Dec 2011 12:04:01 -0500
X-Mailbox-Line: From gregkh@clark.kroah.org Wed Dec  7 08:56:02 2011
Message-Id: <20111207165602.002157755@clark.kroah.org>
User-Agent: quilt/0.50-23.1
Date: Wed, 07 Dec 2011 08:54:52 -0800
From: Greg KH <gregkh@suse.de>
To: <linux-kernel@vger.kernel.org>, <stable@vger.kernel.org>
Cc: <torvalds@linux-foundation.org>, <akpm@linux-foundation.org>,
        <alan@lxorguk.ukuu.org.uk>, Jiri Slaby <jirislaby@gmail.com>,
        James Bottomley <James.Bottomley@suse.de>
Subject: [19/27] SCSI: scsi_lib: fix potential NULL dereference
In-Reply-To: <20111207165611.GA19872@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.32-longterm review patch.  If anyone has any objections, please let me know.

------------------

From: Jiri Slaby <jirislaby@gmail.com>

commit 03b147083a2f9a2a3fbbd2505fa88ffa3c6ab194 upstream.

Stanse found a potential NULL dereference in scsi_kill_request.

Instead of triggering BUG() in 'if (unlikely(cmd == NULL))' branch,
the kernel will Oops earlier on cmd dereference.

Move the dereferences after the if.

Signed-off-by: Jiri Slaby <jirislaby@gmail.com>
Signed-off-by: James Bottomley <James.Bottomley@suse.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/scsi/scsi_lib.c |    9 ++++++---
 1 file changed, 6 insertions(+), 3 deletions(-)

--- a/drivers/scsi/scsi_lib.c
+++ b/drivers/scsi/scsi_lib.c
@@ -1370,9 +1370,9 @@ static int scsi_lld_busy(struct request_
 static void scsi_kill_request(struct request *req, struct request_queue *q)
 {
 	struct scsi_cmnd *cmd = req->special;
-	struct scsi_device *sdev = cmd->device;
-	struct scsi_target *starget = scsi_target(sdev);
-	struct Scsi_Host *shost = sdev->host;
+	struct scsi_device *sdev;
+	struct scsi_target *starget;
+	struct Scsi_Host *shost;
 
 	blk_start_request(req);
 
@@ -1382,6 +1382,9 @@ static void scsi_kill_request(struct req
 		BUG();
 	}
 
+	sdev = cmd->device;
+	starget = scsi_target(sdev);
+	shost = sdev->host;
 	scsi_init_cmd_errh(cmd);
 	cmd->result = DID_NO_CONNECT << 16;
 	atomic_inc(&cmd->device->iorequest_cnt);


