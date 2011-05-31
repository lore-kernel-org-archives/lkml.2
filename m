Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757526Ab1EaHBY (ORCPT <rfc822;w@1wt.eu>);
	Tue, 31 May 2011 03:01:24 -0400
Received: from smtp1.it.da.ut.ee ([193.40.5.66]:52884 "EHLO smtp1.it.da.ut.ee"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751314Ab1EaHBX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 31 May 2011 03:01:23 -0400
Date: Tue, 31 May 2011 10:01:22 +0300 (EEST)
From: Meelis Roos <mroos@linux.ee>
To: Adaptec OEM Raid Solutions <aacraid@adaptec.com>
cc: linux-scsi@vger.kernel.org,
        Linux Kernel list <linux-kernel@vger.kernel.org>
Subject: [PATCH] dpt_i2o: fix module removal BUG
In-Reply-To: <alpine.SOC.1.00.1105251206580.19636@math.ut.ee>
Message-ID: <alpine.SOC.1.00.1105310956250.26883@math.ut.ee>
References: <alpine.SOC.1.00.1105251206580.19636@math.ut.ee>
User-Agent: Alpine 1.00 (SOC 882 2007-12-20)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

dpt_i2o rmmod fails with

BUG: unable to handle kernel NULL pointer dereference at 00000004

The reason is that legacy scsi_unregister() expects that legacy 
scsi_register() has been called before but this is not the case here. 
Driver has been mostly converted to newer style scsi registration, so 
scsi_host_put() is needed instead of scsi_unregister().

Also deletes obsolete comments around the fix.

Tested with DPT SmartRAID V with several module insertions and 
removals.

Signed-off-by: Meelis Roos <mroos@linux.ee>

diff --git a/drivers/scsi/dpt_i2o.c b/drivers/scsi/dpt_i2o.c
index b4f6c9a..1f3df55 100644
--- a/drivers/scsi/dpt_i2o.c
+++ b/drivers/scsi/dpt_i2o.c
@@ -299,15 +299,11 @@ rebuild_sys_tab:
 }
 
 
-/*
- * scsi_unregister will be called AFTER we return.
- */
 static int adpt_release(struct Scsi_Host *host)
 {
 	adpt_hba* pHba = (adpt_hba*) host->hostdata[0];
-//	adpt_i2o_quiesce_hba(pHba);
 	adpt_i2o_delete_hba(pHba);
-	scsi_unregister(host);
+	scsi_host_put(host);
 	return 0;
 }
 

-- 
Meelis Roos (mroos@linux.ee)
