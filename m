Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752511Ab2DPIsH (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Apr 2012 04:48:07 -0400
Received: from mga01.intel.com ([192.55.52.88]:41642 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751951Ab2DPIr2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Apr 2012 04:47:28 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.71,315,1320652800"; 
   d="scan'208";a="142187301"
From: Mika Westerberg <mika.westerberg@linux.intel.com>
To: linux-kernel@vger.kernel.org
Cc: anton.vorontsov@linaro.org, alan@linux.intel.com,
        bruce.e.robertson@intel.com,
        Mika Westerberg <mika.westerberg@linux.intel.com>
Subject: [PATCH 3/4] power-supply: smb347-charger: move IRQ enabling to the end of probe
Date: Mon, 16 Apr 2012 11:48:40 +0300
Message-Id: <1334566121-8243-3-git-send-email-mika.westerberg@linux.intel.com>
X-Mailer: git-send-email 1.7.9.1
In-Reply-To: <1334566121-8243-1-git-send-email-mika.westerberg@linux.intel.com>
References: <1334566121-8243-1-git-send-email-mika.westerberg@linux.intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

There is a potential problem if we call smb347_irq_enable() from
smb347_irq_init() because smb347_irq_enable() makes the device registers
read-only once it returns and smb347_irq_init() expects them to still be
read-write. Currently no harm happens because it is the last call we make in
smb347_irq_init().

Anyway a better place for enabling IRQs is at the end of probe function and
this is also symmetric to call smb347_irq_disable() which is done at the
beginning of remove function.

Signed-off-by: Mika Westerberg <mika.westerberg@linux.intel.com>
---
 drivers/power/smb347-charger.c |    6 ++----
 1 files changed, 2 insertions(+), 4 deletions(-)

diff --git a/drivers/power/smb347-charger.c b/drivers/power/smb347-charger.c
index d774fd3..781c058 100644
--- a/drivers/power/smb347-charger.c
+++ b/drivers/power/smb347-charger.c
@@ -923,10 +923,6 @@ static int smb347_irq_init(struct smb347_charger *smb)
 	if (ret < 0)
 		goto fail_readonly;
 
-	ret = smb347_irq_enable(smb);
-	if (ret < 0)
-		goto fail_readonly;
-
 	smb347_set_writable(smb, false);
 	smb->client->irq = irq;
 	return 0;
@@ -1233,6 +1229,8 @@ static int smb347_probe(struct i2c_client *client,
 		if (ret < 0) {
 			dev_warn(dev, "failed to initialize IRQ: %d\n", ret);
 			dev_warn(dev, "disabling IRQ support\n");
+		} else {
+			smb347_irq_enable(smb);
 		}
 	}
 
-- 
1.7.9.1

