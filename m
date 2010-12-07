Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754606Ab0LGXRg (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Dec 2010 18:17:36 -0500
Received: from mx1.redhat.com ([209.132.183.28]:8940 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753412Ab0LGXRc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Dec 2010 18:17:32 -0500
From: Mike Snitzer <snitzer@redhat.com>
To: Hannes Reinecke <hare@suse.de>
Cc: k-ueda@ct.jp.nec.com, michaelc@cs.wisc.edu, tytso@mit.edu,
        sshtylyov@mvista.com, linux-scsi@vger.kernel.org, jaxboe@fusionio.com,
        jack@suse.cz, linux-fsdevel@vger.kernel.org,
        linux-kernel@vger.kernel.org, swhiteho@redhat.com,
        linux-raid@vger.kernel.org, linux-ide@vger.kernel.org,
        dm-devel@redhat.com, James.Bottomley@suse.de,
        konishi.ryusuke@lab.ntt.co.jp, j-nomura@ce.jp.nec.com, vst@vlnb.net,
        rwheeler@redhat.com, hch@lst.de, chris.mason@oracle.com, tj@kernel.org
Subject: [RFC PATCH 3/3] block: improve detail in I/O error messages
Date: Tue,  7 Dec 2010 18:16:42 -0500
Message-Id: <1291763802-8251-4-git-send-email-snitzer@redhat.com>
In-Reply-To: <1291763802-8251-1-git-send-email-snitzer@redhat.com>
References: <1291763802-8251-1-git-send-email-snitzer@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Classify severity of I/O errors for target and transport errors.

Signed-off-by: Mike Snitzer <snitzer@redhat.com>
---
 block/blk-core.c |   12 +++++++++---
 1 files changed, 9 insertions(+), 3 deletions(-)

diff --git a/block/blk-core.c b/block/blk-core.c
index 4ce953f..ab8c776 100644
--- a/block/blk-core.c
+++ b/block/blk-core.c
@@ -2028,9 +2028,15 @@ bool blk_update_request(struct request *req, int error, unsigned int nr_bytes)
 
 	if (error && req->cmd_type == REQ_TYPE_FS &&
 	    !(req->cmd_flags & REQ_QUIET)) {
-		printk(KERN_ERR "end_request: I/O error, dev %s, sector %llu\n",
-				req->rq_disk ? req->rq_disk->disk_name : "?",
-				(unsigned long long)blk_rq_pos(req));
+		char *error_type = "I/O";
+
+		if (error == -ENOLINK)
+			error_type = "recoverable transport";
+		else if (error == -EREMOTEIO)
+			error_type = "critical target";
+		printk(KERN_ERR "end_request: %s error, dev %s, sector %llu\n",
+		       error_type, req->rq_disk ? req->rq_disk->disk_name : "?",
+		       (unsigned long long)blk_rq_pos(req));
 	}
 
 	blk_account_io_completion(req, nr_bytes);
-- 
1.7.2.3

