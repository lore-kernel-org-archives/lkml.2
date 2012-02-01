Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932638Ab2BAVKe (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Feb 2012 16:10:34 -0500
Received: from out1-smtp.messagingengine.com ([66.111.4.25]:34146 "EHLO
	out1-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932601Ab2BAVK1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Feb 2012 16:10:27 -0500
X-Sasl-enc: CiF3ztSp0TM7HKV9NLQYfcVjI82AVn7a8lfR5BgekORz 1328130625
X-Mailbox-Line: From gregkh@clark.kroah.org Wed Feb  1 13:00:48 2012
Message-Id: <20120201210048.469113293@clark.kroah.org>
User-Agent: quilt/0.51-15.1
Date: Wed, 01 Feb 2012 13:00:16 -0800
From: Greg KH <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org,
        alan@lxorguk.ukuu.org.uk,
        Lucas Kannebley Tavares <lucaskt@linux.vnet.ibm.com>,
        Breno Leitao <brenohl@br.ibm.com>,
        Thadeu Lima de Souza Cascardo <cascardo@linux.vnet.ibm.com>
Subject: [52/89] jsm: Fixed EEH recovery error
In-Reply-To: <20120201210505.GA26028@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Lucas Kannebley Tavares <lucaskt@linux.vnet.ibm.com>

commit 26aa38cafae0dbef3b2fe75ea487c83313c36d45 upstream.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/tty/serial/jsm/jsm_driver.c |    1 +
 1 file changed, 1 insertion(+)

--- a/drivers/tty/serial/jsm/jsm_driver.c
+++ b/drivers/tty/serial/jsm/jsm_driver.c
@@ -251,6 +251,7 @@ static void jsm_io_resume(struct pci_dev
 	struct jsm_board *brd = pci_get_drvdata(pdev);
 
 	pci_restore_state(pdev);
+	pci_save_state(pdev);
 
 	jsm_uart_port_init(brd);
 }


