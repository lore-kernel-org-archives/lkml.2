Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932284Ab0G3Rfa (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Jul 2010 13:35:30 -0400
Received: from kroah.org ([198.145.64.141]:35606 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759351Ab0G3ReT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Jul 2010 13:34:19 -0400
X-Mailbox-Line: From gregkh@clark.site Fri Jul 30 10:31:05 2010
Message-Id: <20100730173105.550947222@clark.site>
User-Agent: quilt/0.48-11.2
Date: Fri, 30 Jul 2010 10:29:56 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Mikulas Patocka <mpatocka@redhat.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: [031/140] ide: Fix IDE taskfile with cfq scheduler
In-Reply-To: <20100730173205.GA22581@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.33-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Mikulas Patocka <mpatocka@redhat.com>

commit 720fc22a7af79d91ec460c80efa92c65c12d105e upstream.

When ide taskfile access is being used (for example with hdparm --security
commands) and cfq scheduler is selected, the scheduler crashes on BUG in
cfq_put_request.

The reason is that the cfq scheduler is tracking counts of read and write
requests separately; the ide-taskfile subsystem allocates a read request and
then flips the flag to make it a write request. The counters in cfq will
mismatch.

This patch changes ide-taskfile to allocate the READ or WRITE request as
required and don't change the flag later.

Signed-off-by: Mikulas Patocka <mpatocka@redhat.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/ide/ide-taskfile.c |    6 ++----
 1 file changed, 2 insertions(+), 4 deletions(-)

--- a/drivers/ide/ide-taskfile.c
+++ b/drivers/ide/ide-taskfile.c
@@ -428,13 +428,11 @@ int ide_raw_taskfile(ide_drive_t *drive,
 {
 	struct request *rq;
 	int error;
+	int rw = !(cmd->tf_flags & IDE_TFLAG_WRITE) ? READ : WRITE;
 
-	rq = blk_get_request(drive->queue, READ, __GFP_WAIT);
+	rq = blk_get_request(drive->queue, rw, __GFP_WAIT);
 	rq->cmd_type = REQ_TYPE_ATA_TASKFILE;
 
-	if (cmd->tf_flags & IDE_TFLAG_WRITE)
-		rq->cmd_flags |= REQ_RW;
-
 	/*
 	 * (ks) We transfer currently only whole sectors.
 	 * This is suffient for now.  But, it would be great,


