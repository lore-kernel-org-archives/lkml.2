Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756552Ab2F0JIL (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Jun 2012 05:08:11 -0400
Received: from acsinet15.oracle.com ([141.146.126.227]:33851 "EHLO
	acsinet15.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756470Ab2F0JIH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Jun 2012 05:08:07 -0400
Date: Wed, 27 Jun 2012 12:07:58 +0300
From: Dan Carpenter <dan.carpenter@oracle.com>
To: Mauro Carvalho Chehab <mchehab@redhat.com>
Cc: Doug Thompson <dougthompson@xmission.com>, linux-edac@vger.kernel.org,
        linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org
Subject: [patch v3 -resend] edac i5000, i5400: fix pointer math in
 i5000_get_mc_regs()
Message-ID: <20120627090758.GQ31212@elgon.mountain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120627085800.GA3007@mwanda>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Source-IP: ucsinet21.oracle.com [156.151.31.93]
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

I don't have this hardware, so please review carefully.  But the
original code obviously corrupts memory so my patch could hardly be
worse...

This was originally sent on Mon, Mar 5, 2012.  Btw, there are some
Sparse errors in these files.  The code looks buggy but I don't know
what the intent was.

drivers/edac/i5000_edac.c:485:15: warning: right shift by bigger than source value
drivers/edac/i5000_edac.c:580:23: warning: right shift by bigger than source value
drivers/edac/i5400_edac.c:391:36: warning: right shift by bigger than source value
drivers/edac/i5400_edac.c:401:37: warning: right shift by bigger than source value

diff --git a/drivers/edac/i5000_edac.c b/drivers/edac/i5000_edac.c
index a5c33df..39c6375 100644
--- a/drivers/edac/i5000_edac.c
+++ b/drivers/edac/i5000_edac.c
@@ -328,7 +328,13 @@ struct i5000_pvt {
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
 
@@ -1131,9 +1137,9 @@ static void i5000_get_mc_regs(struct mem_ctl_info *mci)
 	pvt = mci->pvt_info;
 
 	pci_read_config_dword(pvt->system_address, AMBASE,
-			(u32 *) & pvt->ambase);
+			&pvt->u.ambase_bottom);
 	pci_read_config_dword(pvt->system_address, AMBASE + sizeof(u32),
-			((u32 *) & pvt->ambase) + sizeof(u32));
+			&pvt->u.ambase_top);
 
 	maxdimmperch = pvt->maxdimmperch;
 	maxch = pvt->maxch;
diff --git a/drivers/edac/i5400_edac.c b/drivers/edac/i5400_edac.c
index 50069c6..2772469 100644
--- a/drivers/edac/i5400_edac.c
+++ b/drivers/edac/i5400_edac.c
@@ -327,7 +327,13 @@ struct i5400_pvt {
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
 
@@ -1055,9 +1061,9 @@ static void i5400_get_mc_regs(struct mem_ctl_info *mci)
 	pvt = mci->pvt_info;
 
 	pci_read_config_dword(pvt->system_address, AMBASE,
-			(u32 *) &pvt->ambase);
+			&pvt->u.ambase_bottom);
 	pci_read_config_dword(pvt->system_address, AMBASE + sizeof(u32),
-			((u32 *) &pvt->ambase) + sizeof(u32));
+			&pvt->u.ambase_top);
 
 	maxdimmperch = pvt->maxdimmperch;
 	maxch = pvt->maxch;
