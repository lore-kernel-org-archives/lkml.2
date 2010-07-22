Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760027Ab0GVWYO (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Jul 2010 18:24:14 -0400
Received: from mail-px0-f174.google.com ([209.85.212.174]:64259 "EHLO
	mail-px0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759892Ab0GVWYL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Jul 2010 18:24:11 -0400
Subject: [PATCH] of/device: Protect against binding of_platform_drivers to
	non-OF devices
To: devicetree-discuss@lists.ozlabs.org, Greg Kroah-Hartman <gregkh@suse.de>,
        linux-kernel@vger.kernel.org
From: Grant Likely <grant.likely@secretlab.ca>
Date: Thu, 22 Jul 2010 16:24:07 -0600
Message-ID: <20100722222407.21517.46568.stgit@angua>
User-Agent: StGit/0.15
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

There is an unlikely chance of this situation is occurring, but it is
easy to protect against.  If a matching entry cannot be found in the
of_match_table, then don't bind the driver.

Signed-off-by: Grant Likely <grant.likely@secretlab.ca>
---
 drivers/of/platform.c |    7 ++++++-
 1 files changed, 6 insertions(+), 1 deletions(-)

diff --git a/drivers/of/platform.c b/drivers/of/platform.c
index 712dfd8..f3f1ec8 100644
--- a/drivers/of/platform.c
+++ b/drivers/of/platform.c
@@ -30,8 +30,13 @@ static int platform_driver_probe_shim(struct platform_device *pdev)
 
 	pdrv = container_of(pdev->dev.driver, struct platform_driver, driver);
 	ofpdrv = container_of(pdrv, struct of_platform_driver, platform_driver);
+
+	/* There is an unlikely chance that an of_platform driver might match
+	 * on a non-OF platform device.  If so, then of_match_device() will
+	 * come up empty.  Return -EINVAL in this case so other drivers get
+	 * the chance to bind. */
 	match = of_match_device(pdev->dev.driver->of_match_table, &pdev->dev);
-	return ofpdrv->probe(pdev, match);
+	return match ? ofpdrv->probe(pdev, match) : -EINVAL;
 }
 
 static void platform_driver_shutdown_shim(struct platform_device *pdev)

