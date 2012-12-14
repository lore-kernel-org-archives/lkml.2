Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756155Ab2LNLCx (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Dec 2012 06:02:53 -0500
Received: from mail-lb0-f174.google.com ([209.85.217.174]:34810 "EHLO
	mail-lb0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756075Ab2LNLCu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Dec 2012 06:02:50 -0500
Subject: [PATCH 05/12] staging: vme_pio2: fix oops on module unloading
To: linux-kernel@vger.kernel.org
From: Konstantin Khlebnikov <khlebnikov@openvz.org>
Cc: Martyn Welch <martyn.welch@ge.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        devel@driverdev.osuosl.org, Manohar Vanga <manohar.vanga@gmail.com>
Date: Fri, 14 Dec 2012 15:02:44 +0400
Message-ID: <20121214110244.11019.14075.stgit@zurg>
In-Reply-To: <20121214110229.11019.63713.stgit@zurg>
References: <20121214110229.11019.63713.stgit@zurg>
User-Agent: StGit/0.15
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch forbids loading vme_pio2 module without specifing "num_bus" parameter.
Otherwise on module unloading pio2_exit() calls vme_unregister_driver() for not
registered pio2_driver.

Signed-off-by: Konstantin Khlebnikov <khlebnikov@openvz.org>
Cc: Martyn Welch <martyn.welch@ge.com>
Cc: Manohar Vanga <manohar.vanga@gmail.com>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: devel@driverdev.osuosl.org
---
 drivers/staging/vme/devices/vme_pio2_core.c |   14 ++------------
 1 file changed, 2 insertions(+), 12 deletions(-)

diff --git a/drivers/staging/vme/devices/vme_pio2_core.c b/drivers/staging/vme/devices/vme_pio2_core.c
index 0331178..bf73ba2 100644
--- a/drivers/staging/vme/devices/vme_pio2_core.c
+++ b/drivers/staging/vme/devices/vme_pio2_core.c
@@ -162,11 +162,9 @@ static struct vme_driver pio2_driver = {
 
 static int __init pio2_init(void)
 {
-	int retval = 0;
-
 	if (bus_num == 0) {
 		pr_err("No cards, skipping registration\n");
-		goto err_nocard;
+		return -ENODEV;
 	}
 
 	if (bus_num > PIO2_CARDS_MAX) {
@@ -176,15 +174,7 @@ static int __init pio2_init(void)
 	}
 
 	/* Register the PIO2 driver */
-	retval = vme_register_driver(&pio2_driver, bus_num);
-	if (retval != 0)
-		goto err_reg;
-
-	return retval;
-
-err_reg:
-err_nocard:
-	return retval;
+	return  vme_register_driver(&pio2_driver, bus_num);
 }
 
 static int pio2_match(struct vme_dev *vdev)

