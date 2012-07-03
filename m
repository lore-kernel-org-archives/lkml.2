Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755515Ab2GCJIi (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Jul 2012 05:08:38 -0400
Received: from na3sys010aog108.obsmtp.com ([74.125.245.84]:39216 "HELO
	na3sys010aog108.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1755297Ab2GCJIg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Jul 2012 05:08:36 -0400
From: Roland Dreier <roland@kernel.org>
To: Tomas Winkler <tomas.winkler@intel.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Lekensteyn <lekensteyn@gmail.com>
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH] misc: mei: set IRQF_ONESHOT for MSI request_threaded_irq() in mei_pci_resume()
Date: Tue,  3 Jul 2012 02:08:30 -0700
Message-Id: <1341306510-28808-1-git-send-email-roland@kernel.org>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <15236906.ttExm1X813@al>
References: <15236906.ttExm1X813@al>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Roland Dreier <roland@purestorage.com>

When the default quick IRQ handler is used then IRQF_ONESHOT must be set,
or else the request fails and following error is logged on resume:

    genirq: Threaded irq requested with handler=NULL and !ONESHOT for irq ...

This is the same fix that commit aa189ecdc0c7 ("misc: mei: set
IRQF_ONESHOT for msi request_threaded_irq") did in the probe function.

Reported-by: Lekensteyn <lekensteyn@gmail.com>
Signed-off-by: Roland Dreier <roland@purestorage.com>
---
Can you try this?  It looks to be needed.

Thomas/Greg, I think this should get into 3.5 if possible.

 drivers/misc/mei/main.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/misc/mei/main.c b/drivers/misc/mei/main.c
index 7de1389..783fcd7 100644
--- a/drivers/misc/mei/main.c
+++ b/drivers/misc/mei/main.c
@@ -1147,7 +1147,7 @@ static int mei_pci_resume(struct device *device)
 		err = request_threaded_irq(pdev->irq,
 			NULL,
 			mei_interrupt_thread_handler,
-			0, mei_driver_name, dev);
+			IRQF_ONESHOT, mei_driver_name, dev);
 	else
 		err = request_threaded_irq(pdev->irq,
 			mei_interrupt_quick_handler,
-- 
1.7.10.4

