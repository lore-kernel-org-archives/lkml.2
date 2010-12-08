Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755577Ab0LHPFo (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Dec 2010 10:05:44 -0500
Received: from mx1.redhat.com ([209.132.183.28]:64448 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755529Ab0LHPFl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Dec 2010 10:05:41 -0500
Date: Wed, 8 Dec 2010 10:05:09 -0500
From: Mike Snitzer <snitzer@redhat.com>
To: Sergei Shtylyov <sshtylyov@mvista.com>
Cc: Hannes Reinecke <hare@suse.de>, k-ueda@ct.jp.nec.com, michaelc@cs.wisc.edu,
        tytso@mit.edu, linux-scsi@vger.kernel.org, jaxboe@fusionio.com,
        jack@suse.cz, linux-fsdevel@vger.kernel.org,
        linux-kernel@vger.kernel.org, swhiteho@redhat.com,
        linux-raid@vger.kernel.org, linux-ide@vger.kernel.org,
        dm-devel@redhat.com, James.Bottomley@suse.de,
        konishi.ryusuke@lab.ntt.co.jp, j-nomura@ce.jp.nec.com, vst@vlnb.net,
        rwheeler@redhat.com, hch@lst.de, chris.mason@oracle.com, tj@kernel.org
Subject: [PATCH v2 3/3] block: improve detail in I/O error messages
Message-ID: <20101208150509.GB14056@redhat.com>
References: <1291763802-8251-1-git-send-email-snitzer@redhat.com>
 <1291763802-8251-4-git-send-email-snitzer@redhat.com>
 <4CFF6BE0.4090109@ru.mvista.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4CFF6BE0.4090109@ru.mvista.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Classify severity of I/O errors for target and transport errors.

Signed-off-by: Mike Snitzer <snitzer@redhat.com>
---
 block/blk-core.c |   20 +++++++++++++++++---
 1 file changed, 17 insertions(+), 3 deletions(-)

Index: linux-2.6/block/blk-core.c
===================================================================
--- linux-2.6.orig/block/blk-core.c
+++ linux-2.6/block/blk-core.c
@@ -2028,9 +2028,23 @@ bool blk_update_request(struct request *
 
 	if (error && req->cmd_type == REQ_TYPE_FS &&
 	    !(req->cmd_flags & REQ_QUIET)) {
-		printk(KERN_ERR "end_request: I/O error, dev %s, sector %llu\n",
-				req->rq_disk ? req->rq_disk->disk_name : "?",
-				(unsigned long long)blk_rq_pos(req));
+		char *error_type;
+
+		switch (error) {
+		case -ENOLINK:
+			error_type = "recoverable transport";
+			break;
+		case -EREMOTEIO:
+			error_type = "critical target";
+			break;
+		case -EIO:
+		default:
+			error_type = "I/O";
+			break;
+		}
+		printk(KERN_ERR "end_request: %s error, dev %s, sector %llu\n",
+		       error_type, req->rq_disk ? req->rq_disk->disk_name : "?",
+		       (unsigned long long)blk_rq_pos(req));
 	}
 
 	blk_account_io_completion(req, nr_bytes);
