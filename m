Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754469Ab2AIM60 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Jan 2012 07:58:26 -0500
Received: from e24smtp03.br.ibm.com ([32.104.18.24]:34162 "EHLO
	e24smtp03.br.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753876Ab2AIM6Z (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Jan 2012 07:58:25 -0500
From: Lucas Kannebley Tavares <lucaskt@linux.vnet.ibm.com>
To: Greg KH <greg@kroah.com>
Cc: Thadeu Lima de Souza Cascardo <cascardo@linux.vnet.ibm.com>,
        Breno Leitao <leitao@linux.vnet.ibm.com>,
        Alan Cox <alan@linux.intel.com>, linux-serial@vger.kernel.org,
        linux-kernel@vger.kernel.org, Breno Leitao <brenohl@br.ibm.com>
Subject: [PATCH] jsm: Fixed EEH recovery error
Date: Mon,  9 Jan 2012 10:58:06 -0200
Message-Id: <1326113886-10830-1-git-send-email-lucaskt@linux.vnet.ibm.com>
X-Mailer: git-send-email 1.7.4.4
x-cbid: 12010912-9254-0000-0000-000007C42151
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
Signed-off-by: Breno Leitao <brenohl@br.ibm.com>
Acked-by: Thadeu Lima de Souza Cascardo <cascardo@linux.vnet.ibm.com> 
---
 drivers/tty/serial/jsm/jsm_driver.c |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/drivers/tty/serial/jsm/jsm_driver.c b/drivers/tty/serial/jsm/jsm_driver.c
index 7c867a0..7545fe1 100644
--- a/drivers/tty/serial/jsm/jsm_driver.c
+++ b/drivers/tty/serial/jsm/jsm_driver.c
@@ -251,6 +251,7 @@ static void jsm_io_resume(struct pci_dev *pdev)
 	struct jsm_board *brd = pci_get_drvdata(pdev);
 
 	pci_restore_state(pdev);
+	pci_save_state(pdev);
 
 	jsm_uart_port_init(brd);
 }
-- 
1.7.4.4

