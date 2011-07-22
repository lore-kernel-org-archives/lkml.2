Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932316Ab1GVVj1 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Jul 2011 17:39:27 -0400
Received: from e8.ny.us.ibm.com ([32.97.182.138]:37391 "EHLO e8.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932269Ab1GVVj0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Jul 2011 17:39:26 -0400
Subject: [PATCH] tpm_nsc: Fix bugzilla 34572
From: Stefan Berger <stefanb@linux.vnet.ibm.com>
To: Rajiv Andrade <srajiv@linux.vnet.ibm.com>
Cc: James Morris <jmorris@namei.org>, baryluk@smp.if.uj.edu.pl,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Date: Fri, 22 Jul 2011 17:39:20 -0400
Message-ID: <1311370760.565.4.camel@d941e-10>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.2 (2.32.2-1.fc14) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch fixes kernel bugzilla 34572. It applies to the tip of Linus's tree.

https://bugzilla.kernel.org/show_bug.cgi?id=34572

Signed-off-by: Stefan Berger <stefanb@linux.vnet.ibm.com>
Tested-by: Witold Baryluk <baryluk@smp.if.uj.edu.pl>

---
 drivers/char/tpm/tpm_nsc.c |   14 +++++++-------
 1 file changed, 7 insertions(+), 7 deletions(-)

Index: linux-2.6/drivers/char/tpm/tpm_nsc.c
===================================================================
--- linux-2.6.orig/drivers/char/tpm/tpm_nsc.c
+++ linux-2.6/drivers/char/tpm/tpm_nsc.c
@@ -330,12 +330,12 @@ static int __init init_nsc(void)
 	pdev->dev.driver = &nsc_drv.driver;
 	pdev->dev.release = tpm_nsc_remove;
 
-	if ((rc = platform_device_register(pdev)) < 0)
-		goto err_free_dev;
+	if ((rc = platform_device_add(pdev)) < 0)
+		goto err_put_dev;
 
 	if (request_region(base, 2, "tpm_nsc0") == NULL ) {
 		rc = -EBUSY;
-		goto err_unreg_dev;
+		goto err_del_dev;
 	}
 
 	if (!(chip = tpm_register_hardware(&pdev->dev, &tpm_nsc))) {
@@ -382,10 +382,10 @@ static int __init init_nsc(void)
 
 err_rel_reg:
 	release_region(base, 2);
-err_unreg_dev:
-	platform_device_unregister(pdev);
-err_free_dev:
-	kfree(pdev);
+err_del_dev:
+	platform_device_del(pdev);
+err_put_dev:
+	platform_device_put(pdev);
 err_unreg_drv:
 	platform_driver_unregister(&nsc_drv);
 	return rc;


