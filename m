Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758260Ab1BPCIb (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Feb 2011 21:08:31 -0500
Received: from kroah.org ([198.145.64.141]:48840 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758104Ab1BPBts (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Feb 2011 20:49:48 -0500
X-Mailbox-Line: From gregkh@clark.kroah.org Tue Feb 15 17:46:57 2011
Message-Id: <20110216014657.813327083@clark.kroah.org>
User-Agent: quilt/0.48-11.2
Date: Tue, 15 Feb 2011 17:45:01 -0800
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Kashyap Desai <kashyap.desai@lsi.com>,
        James Bottomley <James.Bottomley@suse.de>
Subject: [035/115] [SCSI] mpt2sas: Fix device removal handshake for zoned devices
In-Reply-To: <20110216014741.GA24678@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.32-longterm review patch.  If anyone has any objections, please let us know.

------------------

From: Kashyap, Desai <kashyap.desai@lsi.com>

commit 4dc2757a2e9a9d1f2faee4fc6119276fc0061c16 upstream.

When zoning end devices, the driver is not sending device
removal handshake alogrithm to firmware. This results in controller
firmware not sending sas topology add events the next time the device is
added. The fix is the driver should be doing the device removal handshake
even though the PHYSTATUS_VACANT bit is set in the PhyStatus of the
event data. The current design is avoiding the handshake when the
VACANT bit is set in the phy status.

Signed-off-by: Kashyap Desai <kashyap.desai@lsi.com>
Signed-off-by: James Bottomley <James.Bottomley@suse.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/scsi/mpt2sas/mpt2sas_scsih.c |    3 ---
 1 file changed, 3 deletions(-)

--- a/drivers/scsi/mpt2sas/mpt2sas_scsih.c
+++ b/drivers/scsi/mpt2sas/mpt2sas_scsih.c
@@ -2585,9 +2585,6 @@ _scsih_check_topo_delete_events(struct M
 	u16 handle;
 
 	for (i = 0 ; i < event_data->NumEntries; i++) {
-		if (event_data->PHY[i].PhyStatus &
-		    MPI2_EVENT_SAS_TOPO_PHYSTATUS_VACANT)
-			continue;
 		handle = le16_to_cpu(event_data->PHY[i].AttachedDevHandle);
 		if (!handle)
 			continue;


