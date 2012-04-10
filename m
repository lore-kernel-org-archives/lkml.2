Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753477Ab2DJF5M (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Apr 2012 01:57:12 -0400
Received: from na3sys009aog105.obsmtp.com ([74.125.149.75]:43385 "EHLO
	na3sys009aog105.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752258Ab2DJF5L convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Apr 2012 01:57:11 -0400
From: "Nandigama, Nagalakshmi" <Nagalakshmi.Nandigama@lsi.com>
To: Alex Shi <alex.shi@intel.com>,
        "JBottomley@parallels.com" <JBottomley@parallels.com>
CC: "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Date: Tue, 10 Apr 2012 11:27:04 +0530
Subject: RE: [PATCH] scsi/mpt2sas: fix unsafe preempt setting for ioc
Thread-Topic: [PATCH] scsi/mpt2sas: fix unsafe preempt setting for ioc
Thread-Index: Ac0LGKy5bZJA7f4AR2ewrr1a+St82wLxg9Lg
Message-ID: <A6888A6805518E4EA4AF7072A28264A6067E7E4087@inbmail02.lsi.com>
References: <1332742810-5116-1-git-send-email-alex.shi@intel.com>
In-Reply-To: <1332742810-5116-1-git-send-email-alex.shi@intel.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
acceptlanguage: en-US
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch seem to be fine. Please consider this patch as Acked-by: "Nandigama, Nagalakshmi" <Nagalakshmi.Nandigama@lsi.com>

Regards,
Nagalakshmi


-----Original Message-----
From: Alex Shi [mailto:alex.shi@intel.com] 
Sent: Monday, March 26, 2012 11:50 AM
To: JBottomley@parallels.com
Cc: Nandigama, Nagalakshmi; linux-scsi@vger.kernel.org; linux-kernel@vger.kernel.org
Subject: [PATCH] scsi/mpt2sas: fix unsafe preempt setting for ioc

commit 911ae943 add a new function:
+_base_get_msix_index(struct MPT2SAS_ADAPTER *ioc)
+{
+       return ioc->cpu_msix_table[smp_processor_id()];
+}
Here smp_processor_id() need be used in preempt safe condition. but
caller did not give this assurance. So fix this in caller.

Signed-off-by: Alex Shi <alex.shi@intel.com>
---
 drivers/scsi/mpt2sas/mpt2sas_base.c |    6 ++++++
 1 files changed, 6 insertions(+), 0 deletions(-)

diff --git a/drivers/scsi/mpt2sas/mpt2sas_base.c b/drivers/scsi/mpt2sas/mpt2sas_base.c
index a78036f..55a368e 100644
--- a/drivers/scsi/mpt2sas/mpt2sas_base.c
+++ b/drivers/scsi/mpt2sas/mpt2sas_base.c
@@ -1803,6 +1803,7 @@ mpt2sas_base_put_smid_scsi_io(struct MPT2SAS_ADAPTER *ioc, u16 smid, u16 handle)
 	u64 *request = (u64 *)&descriptor;
 
 
+	preempt_disable();
 	descriptor.SCSIIO.RequestFlags = MPI2_REQ_DESCRIPT_FLAGS_SCSI_IO;
 	descriptor.SCSIIO.MSIxIndex =  _base_get_msix_index(ioc);
 	descriptor.SCSIIO.SMID = cpu_to_le16(smid);
@@ -1810,6 +1811,7 @@ mpt2sas_base_put_smid_scsi_io(struct MPT2SAS_ADAPTER *ioc, u16 smid, u16 handle)
 	descriptor.SCSIIO.LMID = 0;
 	_base_writeq(*request, &ioc->chip->RequestDescriptorPostLow,
 	    &ioc->scsi_lookup_lock);
+	preempt_enable();
 }
 
 
@@ -1849,6 +1851,7 @@ mpt2sas_base_put_smid_default(struct MPT2SAS_ADAPTER *ioc, u16 smid)
 	Mpi2RequestDescriptorUnion_t descriptor;
 	u64 *request = (u64 *)&descriptor;
 
+	preempt_disable();
 	descriptor.Default.RequestFlags = MPI2_REQ_DESCRIPT_FLAGS_DEFAULT_TYPE;
 	descriptor.Default.MSIxIndex =  _base_get_msix_index(ioc);
 	descriptor.Default.SMID = cpu_to_le16(smid);
@@ -1856,6 +1859,7 @@ mpt2sas_base_put_smid_default(struct MPT2SAS_ADAPTER *ioc, u16 smid)
 	descriptor.Default.DescriptorTypeDependent = 0;
 	_base_writeq(*request, &ioc->chip->RequestDescriptorPostLow,
 	    &ioc->scsi_lookup_lock);
+	preempt_enable();
 }
 
 /**
@@ -1873,6 +1877,7 @@ mpt2sas_base_put_smid_target_assist(struct MPT2SAS_ADAPTER *ioc, u16 smid,
 	Mpi2RequestDescriptorUnion_t descriptor;
 	u64 *request = (u64 *)&descriptor;
 
+	preempt_disable();
 	descriptor.SCSITarget.RequestFlags =
 	    MPI2_REQ_DESCRIPT_FLAGS_SCSI_TARGET;
 	descriptor.SCSITarget.MSIxIndex =  _base_get_msix_index(ioc);
@@ -1881,6 +1886,7 @@ mpt2sas_base_put_smid_target_assist(struct MPT2SAS_ADAPTER *ioc, u16 smid,
 	descriptor.SCSITarget.IoIndex = cpu_to_le16(io_index);
 	_base_writeq(*request, &ioc->chip->RequestDescriptorPostLow,
 	    &ioc->scsi_lookup_lock);
+	preempt_enable();
 }
 
 /**
-- 
1.7.5.4

