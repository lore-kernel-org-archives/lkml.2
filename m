Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754923Ab2CFGjN (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Mar 2012 01:39:13 -0500
Received: from rcsinet15.oracle.com ([148.87.113.117]:45250 "EHLO
	rcsinet15.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752523Ab2CFGjM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Mar 2012 01:39:12 -0500
Date: Tue, 6 Mar 2012 09:38:59 +0300
From: Dan Carpenter <dan.carpenter@oracle.com>
To: walter harms <wharms@bfs.de>
Cc: Eric Wollesen <ericw@xmtp.net>, Doug Thompson <dougthompson@xmission.com>,
        list-edac@vger.kernel.org, linux-kernel@vger.kernel.org,
        kernel-janitors@vger.kernel.org
Subject: [patch v3] edac i5000, i5400: fix pointer math in i5000_get_mc_regs()
Message-ID: <20120306063859.GA3324@elgon.mountain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120305095244.GG1003@mwanda>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Source-IP: ucsinet21.oracle.com [156.151.31.93]
X-CT-RefId: str=0001.0A090202.4F55B10C.008A,ss=1,re=0.000,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

"pvt->ambase" is a u64 datatype.  The intent here is to fill the first
half in the first call to pci_read_config_dword() and the other half in
the second.  Unfortunately the pointer math is wrong so we set the wrong
data.

Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>
---
v2: Redid it as with a union as Walter Harms suggested.
    Fixed the same bug in i5400_edac.c as well.
v3: Make the struct __packed just in case.

I don't have this hardware, so please review carefully.

diff --git a/drivers/edac/i5400_edac.c b/drivers/edac/i5400_edac.c
index 74d6ec34..083e80a 100644
--- a/drivers/edac/i5400_edac.c
+++ b/drivers/edac/i5400_edac.c
@@ -343,7 +343,13 @@ struct i5400_pvt {
 	struct pci_dev *branch_1;		/* 22.0 */
 
 	u16 tolm;				/* top of low memory */
-	u64 ambase;				/* AMB BAR */
+	union {
+		u64 ambase;				/* AMB BAR */
+		struct {
+			u32 ambase_bottom;
+			u32 ambase_top;
+		} u __packed;
+	};
 
 	u16 mir0, mir1;
 
@@ -1024,9 +1030,9 @@ static void i5400_get_mc_regs(struct mem_ctl_info *mci)
 	pvt = mci->pvt_info;
 
 	pci_read_config_dword(pvt->system_address, AMBASE,
-			(u32 *) &pvt->ambase);
+			&pvt->u.ambase_bottom);
 	pci_read_config_dword(pvt->system_address, AMBASE + sizeof(u32),
-			((u32 *) &pvt->ambase) + sizeof(u32));
+			&pvt->u.ambase_top);
 
 	maxdimmperch = pvt->maxdimmperch;
 	maxch = pvt->maxch;
diff --git a/drivers/edac/i5000_edac.c b/drivers/edac/i5000_edac.c
index 4dc3ac2..ecc2401 100644
--- a/drivers/edac/i5000_edac.c
+++ b/drivers/edac/i5000_edac.c
@@ -343,7 +343,13 @@ struct i5000_pvt {
 	struct pci_dev *branch_1;	/* 22.0 */
 
 	u16 tolm;		/* top of low memory */
-	u64 ambase;		/* AMB BAR */
+	union {
+		u64 ambase;		/* AMB BAR */
+		struct {
+			u32 ambase_bottom;
+			u32 ambase_top;
+		} u __packed;
+	};
 
 	u16 mir0, mir1, mir2;
 
@@ -1128,9 +1134,9 @@ static void i5000_get_mc_regs(struct mem_ctl_info *mci)
 	pvt = mci->pvt_info;
 
 	pci_read_config_dword(pvt->system_address, AMBASE,
-			(u32 *) & pvt->ambase);
+			&pvt->u.ambase_bottom);
 	pci_read_config_dword(pvt->system_address, AMBASE + sizeof(u32),
-			((u32 *) & pvt->ambase) + sizeof(u32));
+			&pvt->u.ambase_top);
 
 	maxdimmperch = pvt->maxdimmperch;
 	maxch = pvt->maxch;



