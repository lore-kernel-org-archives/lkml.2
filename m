Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757951Ab1BPBlW (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Feb 2011 20:41:22 -0500
Received: from kroah.org ([198.145.64.141]:38967 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756988Ab1BPATz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Feb 2011 19:19:55 -0500
X-Mailbox-Line: From gregkh@clark.kroah.org Tue Feb 15 16:14:32 2011
Message-Id: <20110216001432.245944069@clark.kroah.org>
User-Agent: quilt/0.48-11.2
Date: Tue, 15 Feb 2011 16:12:08 -0800
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Kashyap Desai <kashyap.desai@lsi.com>,
        James Bottomley <James.Bottomley@suse.de>
Subject: [071/272] [SCSI] mpt2sas: fix Integrated Raid unsynced on shutdown problem
In-Reply-To: <20110216001559.GA31413@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.37-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Kashyap, Desai <kashyap.desai@lsi.com>

commit 3a9c913a3e57b170887d39456e04c18f2305ec67 upstream.

Issue:
IR shutdown(sending) and IR shutdown(complete) messages not
listed in /var/log/messages when driver is removed.

The driver needs to issue a MPI2_RAID_ACTION_SYSTEM_SHUTDOWN_INITIATED
request when the driver is unloaded so the IR metadata journal is updated.
If this request is not sent, then the volume would need a "check
consistency" issued on the next bootup if the volume was roamed from one
initiator to another. The current driver supports this feature only when the
system is rebooted, however this also need to be supported if the driver is
unloaded

Fix:
To fix this issue, the driver is going
to need to call the _scsih_ir_shutdown prior to reporting
the volumes missing from the OS, hence the device handles
are still present.

Signed-off-by: Kashyap Desai <kashyap.desai@lsi.com>
Signed-off-by: James Bottomley <James.Bottomley@suse.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/scsi/mpt2sas/mpt2sas_scsih.c |    1 +
 1 file changed, 1 insertion(+)

--- a/drivers/scsi/mpt2sas/mpt2sas_scsih.c
+++ b/drivers/scsi/mpt2sas/mpt2sas_scsih.c
@@ -6687,6 +6687,7 @@ _scsih_remove(struct pci_dev *pdev)
 		destroy_workqueue(wq);
 
 	/* release all the volumes */
+	_scsih_ir_shutdown(ioc);
 	list_for_each_entry_safe(raid_device, next, &ioc->raid_device_list,
 	    list) {
 		if (raid_device->starget) {


