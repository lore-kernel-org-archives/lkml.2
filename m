Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757159Ab2CBGyx (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Mar 2012 01:54:53 -0500
Received: from acsinet15.oracle.com ([141.146.126.227]:17030 "EHLO
	acsinet15.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755591Ab2CBGyw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Mar 2012 01:54:52 -0500
Date: Fri, 2 Mar 2012 09:54:41 +0300
From: Dan Carpenter <dan.carpenter@oracle.com>
To: Eric Wollesen <ericw@xmtp.net>
Cc: Doug Thompson <dougthompson@xmission.com>, list-edac@vger.kernel.org,
        linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org
Subject: [patch] edac i5000: fix pointer math in i5000_get_mc_regs()
Message-ID: <20120302065441.GB24508@elgon.mountain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Source-IP: ucsinet22.oracle.com [156.151.31.94]
X-CT-RefId: str=0001.0A090209.4F506EBB.00AD,ss=1,re=0.000,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

"pvt->ambase" is a u64 datatype.  The intent here is to fill the first
half in the first call to pci_read_config_dword() and the other half in
the second.  Unfortunately the pointer math is wrong so we set the wrong
data.

Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>
---
I don't have the hardware to test this.  Please review carefully.

diff --git a/drivers/edac/i5000_edac.c b/drivers/edac/i5000_edac.c
index 4dc3ac2..fcdc4ab 100644
--- a/drivers/edac/i5000_edac.c
+++ b/drivers/edac/i5000_edac.c
@@ -1130,7 +1130,7 @@ static void i5000_get_mc_regs(struct mem_ctl_info *mci)
 	pci_read_config_dword(pvt->system_address, AMBASE,
 			(u32 *) & pvt->ambase);
 	pci_read_config_dword(pvt->system_address, AMBASE + sizeof(u32),
-			((u32 *) & pvt->ambase) + sizeof(u32));
+			(u32 *)((char *) &pvt->ambase + sizeof(u32)));
 
 	maxdimmperch = pvt->maxdimmperch;
 	maxch = pvt->maxch;
