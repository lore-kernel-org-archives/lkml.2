Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934976Ab0KQQTa (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Nov 2010 11:19:30 -0500
Received: from lxorguk.ukuu.org.uk ([81.2.110.251]:48258 "EHLO
	lxorguk.ukuu.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934864Ab0KQQT2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Nov 2010 11:19:28 -0500
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
Subject: [PATCH 6/7] sst: log error returned by scu ipc read/write
To: greg@kroah.com, linux-kernel@vger.kernel.org
Date: Wed, 17 Nov 2010 15:59:30 +0000
Message-ID: <20101117155922.21681.98517.stgit@localhost.localdomain>
In-Reply-To: <20101117155748.21681.71501.stgit@localhost.localdomain>
References: <20101117155748.21681.71501.stgit@localhost.localdomain>
User-Agent: StGIT/0.14.3
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Vinod Koul <vinod.koul@intel.com>

scu ipc driver fails sometimes to read/write. This add logs with register
addr and ret code when these errors occur.

Signed-off-by: Vinod Koul <vinod.koul@intel.com>
Signed-off-by: Alan Cox <alan@linux.intel.com>
---

 drivers/staging/intel_sst/intelmid_pvt.c |   25 ++++++++++++-------------
 1 files changed, 12 insertions(+), 13 deletions(-)


diff --git a/drivers/staging/intel_sst/intelmid_pvt.c b/drivers/staging/intel_sst/intelmid_pvt.c
index e8938d9..ecf3b60 100644
--- a/drivers/staging/intel_sst/intelmid_pvt.c
+++ b/drivers/staging/intel_sst/intelmid_pvt.c
@@ -143,30 +143,29 @@ int sst_sc_reg_access(struct sc_reg_access *sc_access,
 		for (i = 0; i < num_val; i++) {
 			retval = intel_scu_ipc_iowrite8(sc_access[i].reg_addr,
 							sc_access[i].value);
-			if (retval) {
-				pr_err("sst: IPC write failed!!! %d\n", retval);
-				return retval;
-			}
+			if (retval)
+				goto err;
 		}
 	} else if (type == PMIC_READ) {
 		for (i = 0; i < num_val; i++) {
 			retval = intel_scu_ipc_ioread8(sc_access[i].reg_addr,
 							&(sc_access[i].value));
-			if (retval) {
-				pr_err("sst: IPC read failed!!!!!%d\n", retval);
-				return retval;
-			}
+			if (retval)
+				goto err;
 		}
 	} else {
 		for (i = 0; i < num_val; i++) {
 			retval = intel_scu_ipc_update_register(
 				sc_access[i].reg_addr, sc_access[i].value,
 				sc_access[i].mask);
-			if (retval) {
-				pr_err("sst: IPC Modify failed!!!%d\n", retval);
-				return retval;
-			}
+			if (retval)
+				goto err;
 		}
-	}
+		}
+	return 0;
+err:
+	pr_err("sst: IPC failed for cmd!!!%d, %d\n", retval, type);
+	pr_err("reg:0x%2x addr:0x%2x\n",
+		sc_access[i].reg_addr, sc_access[i].value);
 	return retval;
 }

