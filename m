Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754137Ab1DSIpO (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Apr 2011 04:45:14 -0400
Received: from mga02.intel.com ([134.134.136.20]:45250 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753788Ab1DSIpH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Apr 2011 04:45:07 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.64,238,1301900400"; 
   d="scan'208";a="735432103"
Subject: [PATCH 2/2]SATA: enable flush non-queueable
From: Shaohua Li <shaohua.li@intel.com>
To: lkml <linux-kernel@vger.kernel.org>, linux-ide <linux-ide@vger.kernel.org>
Cc: Jens Axboe <jaxboe@fusionio.com>, Jeff Garzik <jgarzik@pobox.com>,
        Christoph Hellwig <hch@infradead.org>, Tejun Heo <tj@kernel.org>
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 19 Apr 2011 16:44:49 +0800
Message-ID: <1303202689.3981.217.camel@sli10-conroe>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Set SATA queue flush non-queueable. Running below test with a AHCI controller and
ext4 filesystem, below patch gives around ~5% speedup.
sysbench --test fileio --file-test-mode rndrw --num-threads 16 \
--file-total-size 2500MB --max-requests 150000 --max-time 3000

Signed-off-by: Shaohua Li <shaohua.li@intel.com>
---
 drivers/ata/libata-scsi.c |    2 ++
 1 file changed, 2 insertions(+)

Index: linux/drivers/ata/libata-scsi.c
===================================================================
--- linux.orig/drivers/ata/libata-scsi.c	2011-04-19 14:54:37.000000000 +0800
+++ linux/drivers/ata/libata-scsi.c	2011-04-19 14:58:54.000000000 +0800
@@ -3424,7 +3424,9 @@ void ata_scsi_scan_host(struct ata_port
 			sdev = __scsi_add_device(ap->scsi_host, channel, id, 0,
 						 NULL);
 			if (!IS_ERR(sdev)) {
+				struct request_queue *q = sdev->request_queue;
 				dev->sdev = sdev;
+				blk_set_queue_flush_queueable(q, false);
 				scsi_device_put(sdev);
 			} else {
 				dev->sdev = NULL;


