Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758830Ab0JVSYp (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Oct 2010 14:24:45 -0400
Received: from kroah.org ([198.145.64.141]:37718 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758721Ab0JVSYn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Oct 2010 14:24:43 -0400
From: Greg Kroah-Hartman <gregkh@suse.de>
To: linux-kernel@vger.kernel.org
Cc: Breno Leitao <leitao@linux.vnet.ibm.com>,
        Greg Kroah-Hartman <gregkh@suse.de>
Subject: [PATCH 44/49] jsm: Remove the uart port on errors
Date: Fri, 22 Oct 2010 11:21:23 -0700
Message-Id: <1287771688-14805-44-git-send-email-gregkh@suse.de>
X-Mailer: git-send-email 1.7.1
In-Reply-To: <20101022175112.GC13489@kroah.com>
References: <20101022175112.GC13489@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Breno Leitao <leitao@linux.vnet.ibm.com>

If kzmalloc fails, the uart port is not removed causing a leak.
This patch just add another label that removes the uart when the
kzmalloc fails.

Signed-off-by: Breno Leitao <leitao@linux.vnet.ibm.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
---
 drivers/serial/jsm/jsm_driver.c |    4 +++-
 1 files changed, 3 insertions(+), 1 deletions(-)

diff --git a/drivers/serial/jsm/jsm_driver.c b/drivers/serial/jsm/jsm_driver.c
index eaf5450..18f5484 100644
--- a/drivers/serial/jsm/jsm_driver.c
+++ b/drivers/serial/jsm/jsm_driver.c
@@ -172,13 +172,15 @@ static int __devinit jsm_probe_one(struct pci_dev *pdev, const struct pci_device
 		 	jsm_uart_port_init here! */
 		dev_err(&pdev->dev, "memory allocation for flipbuf failed\n");
 		rc = -ENOMEM;
-		goto out_free_irq;
+		goto out_free_uart;
 	}
 
 	pci_set_drvdata(pdev, brd);
 	pci_save_state(pdev);
 
 	return 0;
+ out_free_uart:
+	jsm_remove_uart_port(brd);
  out_free_irq:
 	jsm_remove_uart_port(brd);
 	free_irq(brd->irq, brd);
-- 
1.7.2

