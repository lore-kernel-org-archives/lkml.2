Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755597Ab2E1Dy6 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 27 May 2012 23:54:58 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:51856 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753371Ab2E1D3E (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 27 May 2012 23:29:04 -0400
Message-Id: <20120528031205.661391895@decadent.org.uk>
User-Agent: quilt/0.60-1
Date: Mon, 28 May 2012 04:12:22 +0100
From: Ben Hutchings <ben@decadent.org.uk>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org,
        alan@lxorguk.ukuu.org.uk,
        "nagalakshmi.nandigama@lsi.com" <nagalakshmi.nandigama@lsi.com>,
        James Bottomley <JBottomley@Parallels.com>
Subject: [ 020/117] [SCSI] mpt2sas: Fix for panic happening because of improper memory
 allocation
In-Reply-To: <20120528031202.829379252@decadent.org.uk>
X-SA-Exim-Connect-IP: 192.168.4.185
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: "nagalakshmi.nandigama@lsi.com" <nagalakshmi.nandigama@lsi.com>

commit e42fafc25fa86c61824e8d4c5e7582316415d24f upstream.

The ioc->pfacts member in the IOC structure is getting set to zero
following a call to _base_get_ioc_facts due to the memset in that routine.
So if the ioc->pfacts was read after a host reset, there would be a NULL
pointer dereference. The routine _base_get_ioc_facts is called from context
of host reset.  The problem in _base_get_ioc_facts  is the size of
Mpi2IOCFactsReply is 64, whereas the sizeof "struct mpt2sas_facts" is 60,
so there is a four byte overflow resulting from the memset.

Also, there is memset in _base_get_port_facts using the incorrect structure,
it should be "struct mpt2sas_port_facts" instead of Mpi2PortFactsReply.

Signed-off-by: Nagalakshmi Nandigama <nagalakshmi.nandigama@lsi.com>
Signed-off-by: James Bottomley <JBottomley@Parallels.com>
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 drivers/scsi/mpt2sas/mpt2sas_base.c |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/scsi/mpt2sas/mpt2sas_base.c b/drivers/scsi/mpt2sas/mpt2sas_base.c
index 702faf6..6102ef2 100644
--- a/drivers/scsi/mpt2sas/mpt2sas_base.c
+++ b/drivers/scsi/mpt2sas/mpt2sas_base.c
@@ -3350,7 +3350,7 @@ _base_get_port_facts(struct MPT2SAS_ADAPTER *ioc, int port, int sleep_flag)
 	}
 
 	pfacts = &ioc->pfacts[port];
-	memset(pfacts, 0, sizeof(Mpi2PortFactsReply_t));
+	memset(pfacts, 0, sizeof(struct mpt2sas_port_facts));
 	pfacts->PortNumber = mpi_reply.PortNumber;
 	pfacts->VP_ID = mpi_reply.VP_ID;
 	pfacts->VF_ID = mpi_reply.VF_ID;
@@ -3392,7 +3392,7 @@ _base_get_ioc_facts(struct MPT2SAS_ADAPTER *ioc, int sleep_flag)
 	}
 
 	facts = &ioc->facts;
-	memset(facts, 0, sizeof(Mpi2IOCFactsReply_t));
+	memset(facts, 0, sizeof(struct mpt2sas_facts));
 	facts->MsgVersion = le16_to_cpu(mpi_reply.MsgVersion);
 	facts->HeaderVersion = le16_to_cpu(mpi_reply.HeaderVersion);
 	facts->VP_ID = mpi_reply.VP_ID;
@@ -4270,7 +4270,7 @@ mpt2sas_base_attach(struct MPT2SAS_ADAPTER *ioc)
 		goto out_free_resources;
 
 	ioc->pfacts = kcalloc(ioc->facts.NumberOfPorts,
-	    sizeof(Mpi2PortFactsReply_t), GFP_KERNEL);
+	    sizeof(struct mpt2sas_port_facts), GFP_KERNEL);
 	if (!ioc->pfacts) {
 		r = -ENOMEM;
 		goto out_free_resources;


