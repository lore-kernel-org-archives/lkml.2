Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932203Ab2JVTBr (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Oct 2012 15:01:47 -0400
Received: from mx1.redhat.com ([209.132.183.28]:17785 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932115Ab2JVTBq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Oct 2012 15:01:46 -0400
From: Jeff Moyer <jmoyer@redhat.com>
To: axboe@kernel.dk, linux-kernel@vger.kernel.org,
        SCSI Mailing List <linux-scsi@vger.kernel.org>
Subject: [patch/rfc/rft] sd: allocate request_queue on device's local numa node
X-PGP-KeyID: 1F78E1B4
X-PGP-CertKey: F6FE 280D 8293 F72C 65FD  5A58 1FF8 A7CA 1F78 E1B4
X-PCLoadLetter: What the f**k does that mean?
Date: Mon, 22 Oct 2012 15:01:42 -0400
Message-ID: <x49pq4axre1.fsf@segfault.boston.devel.redhat.com>
User-Agent: Gnus/5.110011 (No Gnus v0.11) Emacs/23.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

All of the infrastructure is available to allocate a request_queue on a
particular numa node, but it isn't being utilized at all.  Wire up the
sd driver to allocate the request_queue on the HBA's local numa node.

This is a request for comments and testing (I've built and booted it,
nothing more).  I believe that this should be a performance win, but I
have no numbers to back it up as yet.  Suggestions for workloads to test
are welcome.

Cheers,
Jeff

Signed-off-by: Jeff Moyer <jmoyer@redhat.com>

diff --git a/drivers/scsi/scsi_lib.c b/drivers/scsi/scsi_lib.c
index da36a3a..7986483 100644
--- a/drivers/scsi/scsi_lib.c
+++ b/drivers/scsi/scsi_lib.c
@@ -1664,7 +1664,8 @@ struct request_queue *__scsi_alloc_queue(struct Scsi_Host *shost,
 	struct request_queue *q;
 	struct device *dev = shost->dma_dev;
 
-	q = blk_init_queue(request_fn, NULL);
+	q = blk_init_queue_node(request_fn, NULL,
+				dev_to_node(&shost->shost_dev));
 	if (!q)
 		return NULL;
 
