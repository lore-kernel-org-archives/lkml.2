Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754988Ab2E0Bzl (ORCPT <rfc822;w@1wt.eu>);
	Sat, 26 May 2012 21:55:41 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:42162 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754583Ab2E0A5x (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 26 May 2012 20:57:53 -0400
Message-Id: <20120527002615.642284130@linuxfoundation.org>
User-Agent: quilt/0.60-19.1
Date: Sun, 27 May 2012 09:26:25 +0900
From: Greg KH <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org,
        alan@lxorguk.ukuu.org.uk,
        Nagalakshmi Nandigama <nagalakshmi.nandigama@lsi.com>,
        James Bottomley <JBottomley@Parallels.com>
Subject: [ 12/55] SCSI: mpt2sas: Fix for panic happening because of improper memory allocation
In-Reply-To: <20120527005203.GA2146@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.0-stable review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/scsi/mpt2sas/mpt2sas_base.c |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

--- a/drivers/scsi/mpt2sas/mpt2sas_base.c
+++ b/drivers/scsi/mpt2sas/mpt2sas_base.c
@@ -3056,7 +3056,7 @@ _base_get_port_facts(struct MPT2SAS_ADAP
 	}
 
 	pfacts = &ioc->pfacts[port];
-	memset(pfacts, 0, sizeof(Mpi2PortFactsReply_t));
+	memset(pfacts, 0, sizeof(struct mpt2sas_port_facts));
 	pfacts->PortNumber = mpi_reply.PortNumber;
 	pfacts->VP_ID = mpi_reply.VP_ID;
 	pfacts->VF_ID = mpi_reply.VF_ID;
@@ -3098,7 +3098,7 @@ _base_get_ioc_facts(struct MPT2SAS_ADAPT
 	}
 
 	facts = &ioc->facts;
-	memset(facts, 0, sizeof(Mpi2IOCFactsReply_t));
+	memset(facts, 0, sizeof(struct mpt2sas_facts));
 	facts->MsgVersion = le16_to_cpu(mpi_reply.MsgVersion);
 	facts->HeaderVersion = le16_to_cpu(mpi_reply.HeaderVersion);
 	facts->VP_ID = mpi_reply.VP_ID;
@@ -3779,7 +3779,7 @@ mpt2sas_base_attach(struct MPT2SAS_ADAPT
 		goto out_free_resources;
 
 	ioc->pfacts = kcalloc(ioc->facts.NumberOfPorts,
-	    sizeof(Mpi2PortFactsReply_t), GFP_KERNEL);
+	    sizeof(struct mpt2sas_port_facts), GFP_KERNEL);
 	if (!ioc->pfacts) {
 		r = -ENOMEM;
 		goto out_free_resources;


