Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754918Ab2BEW1k (ORCPT <rfc822;w@1wt.eu>);
	Sun, 5 Feb 2012 17:27:40 -0500
Received: from 1wt.eu ([62.212.114.60]:62158 "EHLO 1wt.eu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754997Ab2BEW1b (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 5 Feb 2012 17:27:31 -0500
Message-Id: <20120205220952.399096942@pcw.home.local>
User-Agent: quilt/0.48-1
Date: Sun, 05 Feb 2012 23:10:58 +0100
From: Willy Tarreau <w@1wt.eu>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Babu Moger <babu.moger@netapp.com>,
        James Bottomley <JBottomley@Parallels.com>,
        Dan Carpenter <dan.carpenter@oracle.com>,
        Greg KH <gregkh@linuxfoundation.org>
Subject: [PATCH 69/91] SCSI: scsi_dh: check queuedata pointer before proceeding further
In-Reply-To: <0635750f5f06ed2ca212b91fcb5c4483@local>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.27-longterm review patch.  If anyone has any objections, please let us know.

------------------

commit a18a920c70d48a8e4a2b750d8a183b3c1a4be514 upstream.

This patch validates sdev pointer in scsi_dh_activate before proceeding further.

Without this check we might see the panic as below. I have seen this
panic multiple times..

Call trace:

 #0 [ffff88007d647b50] machine_kexec at ffffffff81020902
 #1 [ffff88007d647ba0] crash_kexec at ffffffff810875b0
 #2 [ffff88007d647c70] oops_end at ffffffff8139c650
 #3 [ffff88007d647c90] __bad_area_nosemaphore at ffffffff8102dd15
 #4 [ffff88007d647d50] page_fault at ffffffff8139b8cf
    [exception RIP: scsi_dh_activate+0x82]
    RIP: ffffffffa0041922  RSP: ffff88007d647e00  RFLAGS: 00010046
    RAX: 0000000000000000  RBX: 0000000000000000  RCX: 00000000000093c5
    RDX: 00000000000093c5  RSI: ffffffffa02e6640  RDI: ffff88007cc88988
    RBP: 000000000000000f   R8: ffff88007d646000   R9: 0000000000000000
    R10: ffff880082293790  R11: 00000000ffffffff  R12: ffff88007cc88988
    R13: 0000000000000000  R14: 0000000000000286  R15: ffff880037b845e0
    ORIG_RAX: ffffffffffffffff  CS: 0010  SS: 0000
 #5 [ffff88007d647e38] run_workqueue at ffffffff81060268
 #6 [ffff88007d647e78] worker_thread at ffffffff81060386
 #7 [ffff88007d647ee8] kthread at ffffffff81064436
 #8 [ffff88007d647f48] kernel_thread at ffffffff81003fba

Signed-off-by: Babu Moger <babu.moger@netapp.com>
Signed-off-by: James Bottomley <JBottomley@Parallels.com>
Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
---
 drivers/scsi/device_handler/scsi_dh.c |    7 ++++++-
 1 files changed, 6 insertions(+), 1 deletions(-)

Index: longterm-2.6.27/drivers/scsi/device_handler/scsi_dh.c
===================================================================
--- longterm-2.6.27.orig/drivers/scsi/device_handler/scsi_dh.c	2012-02-05 22:34:32.891915048 +0100
+++ longterm-2.6.27/drivers/scsi/device_handler/scsi_dh.c	2012-02-05 22:34:44.687914590 +0100
@@ -423,7 +423,12 @@
 
 	spin_lock_irqsave(q->queue_lock, flags);
 	sdev = q->queuedata;
-	if (sdev && sdev->scsi_dh_data)
+	if (!sdev) {
+		spin_unlock_irqrestore(q->queue_lock, flags);
+		return SCSI_DH_NOSYS;
+	}
+
+	if (sdev->scsi_dh_data)
 		scsi_dh = sdev->scsi_dh_data->scsi_dh;
 	if (!scsi_dh || !get_device(&sdev->sdev_gendev))
 		err = SCSI_DH_NOSYS;


