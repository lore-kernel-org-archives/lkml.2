Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755949Ab1HCX6V (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Aug 2011 19:58:21 -0400
Received: from mail-yx0-f174.google.com ([209.85.213.174]:52630 "EHLO
	mail-yx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755872Ab1HCX6R (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Aug 2011 19:58:17 -0400
Subject: [PATCH] tpm: tpm_nsc: Fix a double free of pdev in cleanup_nsc
From: Axel Lin <axel.lin@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: Leendert van Doorn <leendert@watson.ibm.com>,
        Debora Velarde <debora@linux.vnet.ibm.com>,
        Rajiv Andrade <srajiv@linux.vnet.ibm.com>,
        Marcel Selhorst <m.selhorst@sirrix.com>,
        tpmdd-devel@lists.sourceforge.net
Content-Type: text/plain; charset="UTF-8"
Date: Thu, 04 Aug 2011 07:58:07 +0800
Message-ID: <1312415887.2604.1.camel@phoenix>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

platform_device_unregister() will release all resources
and remove it from the subsystem, then drop reference count by
calling platform_device_put().

We should not call kfree(pdev) after platform_device_unregister(pdev).

Signed-off-by: Axel Lin <axel.lin@gmail.com>
---
 drivers/char/tpm/tpm_nsc.c |    2 --
 1 files changed, 0 insertions(+), 2 deletions(-)

diff --git a/drivers/char/tpm/tpm_nsc.c b/drivers/char/tpm/tpm_nsc.c
index 82facc9..4d24648 100644
--- a/drivers/char/tpm/tpm_nsc.c
+++ b/drivers/char/tpm/tpm_nsc.c
@@ -396,8 +396,6 @@ static void __exit cleanup_nsc(void)
 	if (pdev) {
 		tpm_nsc_remove(&pdev->dev);
 		platform_device_unregister(pdev);
-		kfree(pdev);
-		pdev = NULL;
 	}
 
 	platform_driver_unregister(&nsc_drv);
-- 
1.7.4.1



