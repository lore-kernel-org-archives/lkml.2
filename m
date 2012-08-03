Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753684Ab2HCOve (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Aug 2012 10:51:34 -0400
Received: from smtp2.infineon.com ([217.10.60.23]:4951 "EHLO
	smtp2.infineon.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753056Ab2HCOvc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Aug 2012 10:51:32 -0400
X-SBRS: None
From: Peter Huewe <peter.huewe@infineon.com>
To: Kent Yoder <key@linux.vnet.ibm.com>, James Morris <jmorris@namei.org>
CC: <linux-kernel@vger.kernel.org>, <linux-security-module@vger.kernel.org>,
        <tpmdd-devel@lists.sourceforge.net>, Bryan Freed <bfreed@chromium.org>,
        David Safford <safford@linux.vnet.ibm.com>, <hpa@linux.intel.com>,
        Peter Huewe <peter.huewe@infineon.com>
Subject: [PATCH] char/tpm: Fix compile error if CONFIG_PM is not set in tpm_i2c_infineon
Date: Fri, 3 Aug 2012 16:51:16 +0200
Message-ID: <1344005476-8004-1-git-send-email-peter.huewe@infineon.com>
X-Mailer: git-send-email 1.7.6.msysgit.0
In-Reply-To: <alpine.LRH.2.02.1208031444100.25196@tundra.namei.org>
References: <alpine.LRH.2.02.1208031444100.25196@tundra.namei.org>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [172.29.170.161]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

If CONFIG_PM was not set the compiler aborted with the following message:
tpm_i2c_infineon.c:740:12: error: lvalue required as unary '&' operand

This patch fixes this error by not defining tpm_tis_i2c_ops as NULL if
CONFIG_PM is not set, but only setting the suspend and resume function
pointer as NULL

Signed-off-by: Peter Huewe <peter.huewe@infineon.com>
---
Sorry for the inconvenience - now tested with and without CONFIG_PM. Sorry.

 drivers/char/tpm/tpm_i2c_infineon.c |    9 ++++-----
 1 files changed, 4 insertions(+), 5 deletions(-)

diff --git a/drivers/char/tpm/tpm_i2c_infineon.c b/drivers/char/tpm/tpm_i2c_infineon.c
index 1794a09..114e1a1 100644
--- a/drivers/char/tpm/tpm_i2c_infineon.c
+++ b/drivers/char/tpm/tpm_i2c_infineon.c
@@ -674,16 +674,15 @@ static int tpm_tis_i2c_resume(struct device *dev)
 {
 	return tpm_pm_resume(dev);
 }
+#else
+#define tpm_tis_i2c_suspend NULL
+#define tpm_tis_i2c_resume NULL
+#endif
 
 static const struct dev_pm_ops tpm_tis_i2c_ops = {
 	.suspend = tpm_tis_i2c_suspend,
 	.resume = tpm_tis_i2c_resume,
 };
-#else
-#define tpm_tis_i2c_suspend NULL
-#define tpm_tis_i2c_resume NULL
-#define tpm_tis_i2c_ops NULL
-#endif
 
 static int __devinit tpm_tis_i2c_probe(struct i2c_client *client,
 			     const struct i2c_device_id *id)
-- 
1.7.6.msysgit.0

