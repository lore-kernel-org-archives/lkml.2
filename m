Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757339Ab2BAVNs (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Feb 2012 16:13:48 -0500
Received: from out1-smtp.messagingengine.com ([66.111.4.25]:48149 "EHLO
	out1-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932650Ab2BAVKi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Feb 2012 16:10:38 -0500
X-Sasl-enc: HcvNggl4mpDKOie3aHqhK+jcy5c3SsSxwwYdRE1+Vt/7 1328130637
X-Mailbox-Line: From gregkh@clark.kroah.org Wed Feb  1 13:00:47 2012
Message-Id: <20120201210047.250560181@clark.kroah.org>
User-Agent: quilt/0.51-15.1
Date: Wed, 01 Feb 2012 13:00:02 -0800
From: Greg KH <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org,
        alan@lxorguk.ukuu.org.uk,
        Nagalakshmi Nandigama <nagalakshmi.nandigama@lsi.com>,
        James Bottomley <JBottomley@Parallels.com>
Subject: [38/89] [SCSI] mpt2sas: Removed redundant calling of _scsih_probe_devices() from _scsih_probe
In-Reply-To: <20120201210505.GA26028@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: "nagalakshmi.nandigama@lsi.com" <nagalakshmi.nandigama@lsi.com>

commit 2cb6fc8c014b9b00c4487a79b8f6ed0da4121f45 upstream.

Removed redundant calling of _scsih_probe_devices() from _scsih_probe as
it is getting called from _scsih_scan_finished.

Also moved the function scsi_scan_host(shost) to get called after the
volumes on warp drive are reported to the OS. Otherwise by the time
the (ioc->hide_drives) flags is set, the volumes on warp drive
are reported to the OS already.

Also modified the initialization of reply queues only in case of driver load
time in the function _base_make_ioc_operational().

Signed-off-by: Nagalakshmi Nandigama <nagalakshmi.nandigama@lsi.com>
Signed-off-by: James Bottomley <JBottomley@Parallels.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/scsi/mpt2sas/mpt2sas_base.c  |   20 +++++++-------------
 drivers/scsi/mpt2sas/mpt2sas_scsih.c |    3 +--
 2 files changed, 8 insertions(+), 15 deletions(-)

--- a/drivers/scsi/mpt2sas/mpt2sas_base.c
+++ b/drivers/scsi/mpt2sas/mpt2sas_base.c
@@ -4033,7 +4033,8 @@ _base_make_ioc_operational(struct MPT2SA
 		ioc->reply_free[i] = cpu_to_le32(reply_address);
 
 	/* initialize reply queues */
-	_base_assign_reply_queues(ioc);
+	if (ioc->is_driver_loading)
+		_base_assign_reply_queues(ioc);
 
 	/* initialize Reply Post Free Queue */
 	reply_post_free = (long)ioc->reply_post_free;
@@ -4081,24 +4082,17 @@ _base_make_ioc_operational(struct MPT2SA
 
 
 	if (ioc->is_driver_loading) {
-
-
-
-		ioc->wait_for_discovery_to_complete =
-		    _base_determine_wait_on_discovery(ioc);
-		return r; /* scan_start and scan_finished support */
-	}
-
-
-	if (ioc->wait_for_discovery_to_complete && ioc->is_warpdrive) {
-		if (ioc->manu_pg10.OEMIdentifier  == 0x80) {
+		if (ioc->is_warpdrive && ioc->manu_pg10.OEMIdentifier
+		    == 0x80) {
 			hide_flag = (u8) (ioc->manu_pg10.OEMSpecificFlags0 &
 			    MFG_PAGE10_HIDE_SSDS_MASK);
 			if (hide_flag != MFG_PAGE10_HIDE_SSDS_MASK)
 				ioc->mfg_pg10_hide_flag = hide_flag;
 		}
+		ioc->wait_for_discovery_to_complete =
+		    _base_determine_wait_on_discovery(ioc);
+		return r; /* scan_start and scan_finished support */
 	}
-
 	r = _base_send_port_enable(ioc, sleep_flag);
 	if (r)
 		return r;
--- a/drivers/scsi/mpt2sas/mpt2sas_scsih.c
+++ b/drivers/scsi/mpt2sas/mpt2sas_scsih.c
@@ -8001,7 +8001,6 @@ _scsih_probe(struct pci_dev *pdev, const
 		goto out_attach_fail;
 	}
 
-	scsi_scan_host(shost);
 	if (ioc->is_warpdrive) {
 		if (ioc->mfg_pg10_hide_flag ==  MFG_PAGE10_EXPOSE_ALL_DISKS)
 			ioc->hide_drives = 0;
@@ -8015,8 +8014,8 @@ _scsih_probe(struct pci_dev *pdev, const
 		}
 	} else
 		ioc->hide_drives = 0;
+	scsi_scan_host(shost);
 
-	_scsih_probe_devices(ioc);
 	return 0;
 
  out_attach_fail:


