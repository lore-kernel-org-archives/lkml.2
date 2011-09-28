Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933033Ab1I1XGh (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Sep 2011 19:06:37 -0400
Received: from cantor2.suse.de ([195.135.220.15]:54544 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932990Ab1I1Wqd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Sep 2011 18:46:33 -0400
X-Mailbox-Line: From gregkh@clark.kroah.org Wed Sep 28 15:01:43 2011
Message-Id: <20110928220143.457007376@clark.kroah.org>
User-Agent: quilt/0.48-16.4
Date: Wed, 28 Sep 2011 15:02:16 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Kashyap Desai <kashyap.desai@lsi.com>,
        James Bottomley <JBottomley@Parallels.com>
Subject: [172/244] [SCSI] mpt2sas: Added DID_NO_CONNECT return when driver remove and avoid shutdown call
In-Reply-To: <20110928220225.GA27128@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.0-stable review patch.  If anyone has any objections, please let us know.

------------------

From: "Kashyap, Desai" <kashyap.desai@lsi.com>

commit 7821578caa8cb831868989041112ab808029ca65 upstream.

Driver should not call shutdown call from _scsih_remove otherwise,
The scsi midlayer can be deadlocked when devices are removed from the driver
pci_driver->shutdown handler.

Signed-off-by: Kashyap Desai <kashyap.desai@lsi.com>
Signed-off-by: James Bottomley <JBottomley@Parallels.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/scsi/mpt2sas/mpt2sas_scsih.c |    3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

--- a/drivers/scsi/mpt2sas/mpt2sas_scsih.c
+++ b/drivers/scsi/mpt2sas/mpt2sas_scsih.c
@@ -3698,7 +3698,7 @@ _scsih_qcmd_lck(struct scsi_cmnd *scmd,
 		return 0;
 	}
 
-	if (ioc->pci_error_recovery) {
+	if (ioc->pci_error_recovery || ioc->remove_host) {
 		scmd->result = DID_NO_CONNECT << 16;
 		scmd->scsi_done(scmd);
 		return 0;
@@ -7211,7 +7211,6 @@ _scsih_remove(struct pci_dev *pdev)
 	}
 
 	sas_remove_host(shost);
-	_scsih_shutdown(pdev);
 	list_del(&ioc->list);
 	scsi_remove_host(shost);
 	scsi_host_put(shost);


