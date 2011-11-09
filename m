Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935404Ab1KJEwv (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Nov 2011 23:52:51 -0500
Received: from cantor2.suse.de ([195.135.220.15]:42927 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S935361Ab1KJDbt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Nov 2011 22:31:49 -0500
X-Mailbox-Line: From gregkh@clark.kroah.org Wed Nov  9 13:27:22 2011
Message-Id: <20111109212722.201449394@clark.kroah.org>
User-Agent: quilt/0.48-16.4
Date: Wed, 09 Nov 2011 13:28:57 -0800
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org,
        alan@lxorguk.ukuu.org.uk, Babu Moger <babu.moger@netapp.com>,
        James Bottomley <JBottomley@Parallels.com>
Subject: [215/262] [SCSI] scsi_dh: check queuedata pointer before proceeding further
In-Reply-To: <20111109212847.GA20838@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.0-stable review patch.  If anyone has any objections, please let me know.

------------------

From: "Moger, Babu" <Babu.Moger@netapp.com>

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
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/scsi/device_handler/scsi_dh.c |   10 +++++++++-
 1 file changed, 9 insertions(+), 1 deletion(-)

--- a/drivers/scsi/device_handler/scsi_dh.c
+++ b/drivers/scsi/device_handler/scsi_dh.c
@@ -398,7 +398,15 @@ int scsi_dh_activate(struct request_queu
 
 	spin_lock_irqsave(q->queue_lock, flags);
 	sdev = q->queuedata;
-	if (sdev && sdev->scsi_dh_data)
+	if (!sdev) {
+		spin_unlock_irqrestore(q->queue_lock, flags);
+		err = SCSI_DH_NOSYS;
+		if (fn)
+			fn(data, err);
+		return err;
+	}
+
+	if (sdev->scsi_dh_data)
 		scsi_dh = sdev->scsi_dh_data->scsi_dh;
 	dev = get_device(&sdev->sdev_gendev);
 	if (!scsi_dh || !dev ||


