Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756951Ab1JCQxT (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Oct 2011 12:53:19 -0400
Received: from e24smtp04.br.ibm.com ([32.104.18.25]:59260 "EHLO
	e24smtp04.br.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756906Ab1JCQxM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Oct 2011 12:53:12 -0400
From: Lucas Kannebley Tavares <lucaskt@linux.vnet.ibm.com>
To: linux-serial@vger.kernel.org
Cc: Breno Leitao <leitao@linux.vnet.ibm.com>, Alan Cox <alan@linux.intel.com>,
        linux-kernel@vger.kernel.org, cascardo@linux.vnet.ibm.com,
        Lucas Kannebley Tavares <lucaskt@linux.vnet.ibm.com>
Subject: [PATCH] jsm: Fixed EEH recovery error
Date: Mon,  3 Oct 2011 13:52:12 -0300
Message-Id: <1317660732-3647-1-git-send-email-lucaskt@linux.vnet.ibm.com>
X-Mailer: git-send-email 1.7.4.4
x-cbid: 11100316-8936-0000-0000-000004A2DE87
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

There was an error on the jsm driver that would cause it to be unable to
recover after a second error is detected.

At the first error, the device recovers properly:

[72521.485691] EEH: Detected PCI bus error on device 0003:02:00.0
[72521.485695] EEH: This PCI device has failed 1 times in the last hour:
...
[72532.035693] ttyn3 at MMIO 0x0 (irq = 49) is a jsm
[72532.105689] jsm: Port 3 added

However, at the second error, it cascades until EEH disables the device:

[72631.229549] Call Trace:
...
[72641.725687] jsm: Port 3 added
[72641.725695] EEH: Detected PCI bus error on device 0003:02:00.0
[72641.725698] EEH: This PCI device has failed 3 times in the last hour:

It was caused because the PCI state was not being saved after the first
restore. Therefore, at the second recovery the PCI state would not be
restored.

Signed-off-by: Lucas Kannebley Tavares <lucaskt@linux.vnet.ibm.com>
---
 drivers/tty/serial/jsm/jsm_driver.c |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/drivers/tty/serial/jsm/jsm_driver.c b/drivers/tty/serial/jsm/jsm_driver.c
index 96da178..8941b15 100644
--- a/drivers/tty/serial/jsm/jsm_driver.c
+++ b/drivers/tty/serial/jsm/jsm_driver.c
@@ -270,6 +270,7 @@ static void jsm_io_resume(struct pci_dev *pdev)
 	struct jsm_board *brd = pci_get_drvdata(pdev);
 
 	pci_restore_state(pdev);
+	pci_save_state(pdev);
 
 	jsm_uart_port_init(brd);
 }
-- 
1.7.4.4

