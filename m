Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755192Ab2JNPEM (ORCPT <rfc822;w@1wt.eu>);
	Sun, 14 Oct 2012 11:04:12 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:46392 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754651Ab2JNOnC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 14 Oct 2012 10:43:02 -0400
Message-Id: <20121014143546.626013068@decadent.org.uk>
User-Agent: quilt/0.60-1
Date: Sun, 14 Oct 2012 15:37:08 +0100
From: Ben Hutchings <ben@decadent.org.uk>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Vaibhav Bedia <vaibhav.bedia@ti.com>,
        "Hebbar, Gururaja" <gururaja.hebbar@ti.com>,
        Venkatraman S <svenkatr@ti.com>, Chris Ball <cjb@laptop.org>
Subject: [ 095/147] mmc: omap_hsmmc: Pass on the suspend failure to the PM core
In-Reply-To: <20121014143533.742627615@decadent.org.uk>
X-SA-Exim-Connect-IP: 77.75.106.1
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Vaibhav Bedia <vaibhav.bedia@ti.com>

commit c4c8eeb4df00aabb641553d6fbcd46f458e56cd9 upstream.

In some cases mmc_suspend_host() is not able to claim the
host and proceed with the suspend process. The core returns
-EBUSY to the host controller driver. Unfortunately, the
host controller driver does not pass on this information
to the PM core and hence the system suspend process continues.

	ret = mmc_suspend_host(host->mmc);
	if (ret) {
		host->suspended = 0;
		if (host->pdata->resume) {
			ret = host->pdata->resume(dev, host->slot_id);

The return status from mmc_suspend_host() is overwritten by return
status from host->pdata->resume. So the original return status is lost.

In these cases the MMC core gets to an unexpected state
during resume and multiple issues related to MMC crop up.
1. Host controller driver starts accessing the device registers
before the clocks are enabled which leads to a prefetch abort.
2. A file copy thread which was launched before suspend gets
stuck due to the host not being reclaimed during resume.

To avoid such problems pass on the -EBUSY status to the PM core
from the host controller driver. With this change, MMC core
suspend might still fail but it does not end up making the
system unusable. Suspend gets aborted and the user can try
suspending the system again.

Signed-off-by: Vaibhav Bedia <vaibhav.bedia@ti.com>
Signed-off-by: Hebbar, Gururaja <gururaja.hebbar@ti.com>
Acked-by: Venkatraman S <svenkatr@ti.com>
Signed-off-by: Chris Ball <cjb@laptop.org>
[bwh: Backported to 3.2:
 - Adjust context, indentation
 - s/dev/\&pdev->dev/]
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 drivers/mmc/host/omap_hsmmc.c |    3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

--- a/drivers/mmc/host/omap_hsmmc.c
+++ b/drivers/mmc/host/omap_hsmmc.c
@@ -2188,9 +2188,7 @@ static int omap_hsmmc_suspend(struct dev
 		} else {
 			host->suspended = 0;
 			if (host->pdata->resume) {
-				ret = host->pdata->resume(&pdev->dev,
-							  host->slot_id);
-				if (ret)
+				if (host->pdata->resume(&pdev->dev, host->slot_id))
 					dev_dbg(mmc_dev(host->mmc),
 						"Unmask interrupt failed\n");
 			}


