Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933481Ab1C3WHQ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Mar 2011 18:07:16 -0400
Received: from mga02.intel.com ([134.134.136.20]:4384 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933207Ab1C3VGR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Mar 2011 17:06:17 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.63,270,1299484800"; 
   d="scan'208";a="727132832"
From: Andi Kleen <andi@firstfloor.org>
References: <20110330203.501921634@firstfloor.org>
In-Reply-To: <20110330203.501921634@firstfloor.org>
To: kashyap.desai@lsi.com, James.Bottomley@suse.de, gregkh@suse.de,
        ak@linux.intel.com, linux-kernel@vger.kernel.org, stable@kernel.org,
        tim.bird@am.sony.com
Subject: [PATCH] [39/275] mpt2sas: Fix device removal handshake for zoned devices
Message-Id: <20110330210434.BC89F3E1A05@tassilo.jf.intel.com>
Date: Wed, 30 Mar 2011 14:04:34 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.35-longterm review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Andi Kleen <ak@linux.intel.com>

---
 drivers/scsi/mpt2sas/mpt2sas_scsih.c |    3 ---
 1 file changed, 3 deletions(-)

Index: linux-2.6.35.y/drivers/scsi/mpt2sas/mpt2sas_scsih.c
===================================================================
--- linux-2.6.35.y.orig/drivers/scsi/mpt2sas/mpt2sas_scsih.c	2011-03-29 22:51:53.469355022 -0700
+++ linux-2.6.35.y/drivers/scsi/mpt2sas/mpt2sas_scsih.c	2011-03-29 23:02:59.011325469 -0700
@@ -2759,9 +2759,6 @@
 	u16 handle;
 
 	for (i = 0 ; i < event_data->NumEntries; i++) {
-		if (event_data->PHY[i].PhyStatus &
-		    MPI2_EVENT_SAS_TOPO_PHYSTATUS_VACANT)
-			continue;
 		handle = le16_to_cpu(event_data->PHY[i].AttachedDevHandle);
 		if (!handle)
 			continue;
