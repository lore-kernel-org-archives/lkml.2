Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757107Ab2IDN0k (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Sep 2012 09:26:40 -0400
Received: from comal.ext.ti.com ([198.47.26.152]:57284 "EHLO comal.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757088Ab2IDN0j (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Sep 2012 09:26:39 -0400
From: "Hebbar, Gururaja" <gururaja.hebbar@ti.com>
To: <linux-omap@vger.kernel.org>, <linux-mmc@vger.kernel.org>,
        <svenkatr@ti.com>
CC: <rob.herring@calxeda.com>, <linux-kernel@vger.kernel.org>,
        <grant.likely@secretlab.ca>, <cjb@laptop.org>, <nsekhar@ti.com>,
        <sudhakar.raj@ti.com>, <gururaja.hebbar@ti.com>,
        Vaibhav Bedia <vaibhav.bedia@ti.com>
Subject: [PATCH] mmc: omap_hsmmc: Pass on the suspend failure to the PM core
Date: Tue, 4 Sep 2012 18:38:29 +0530
Message-ID: <1346764109-21174-1-git-send-email-gururaja.hebbar@ti.com>
X-Mailer: git-send-email 1.7.1
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Vaibhav Bedia <vaibhav.bedia@ti.com>

In some cases mmc_suspend_host() is not able to claim the
host and proceed with the suspend process. The core returns
-EBUSY to the host controller driver. Unfortunately, the
host controller driver does not pass on this information
to the PM core and hence the system suspend process continues.

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
---
:100644 100644 9afdd20... c3e96a2... M	drivers/mmc/host/omap_hsmmc.c
 drivers/mmc/host/omap_hsmmc.c |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/drivers/mmc/host/omap_hsmmc.c b/drivers/mmc/host/omap_hsmmc.c
index 9afdd20..c3e96a2 100644
--- a/drivers/mmc/host/omap_hsmmc.c
+++ b/drivers/mmc/host/omap_hsmmc.c
@@ -2054,6 +2054,7 @@ static int omap_hsmmc_suspend(struct device *dev)
 			if (ret)
 				dev_dbg(dev, "Unmask interrupt failed\n");
 		}
+		ret = -EBUSY;
 		goto err;
 	}
 
-- 
1.7.1

