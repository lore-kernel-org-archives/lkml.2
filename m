Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932641Ab2BAVcb (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Feb 2012 16:32:31 -0500
Received: from out4-smtp.messagingengine.com ([66.111.4.28]:54418 "EHLO
	out4-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932531Ab2BAVTJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Feb 2012 16:19:09 -0500
X-Sasl-enc: NAddLE7M1aSEH+n+HBNdoFv76wnS6UTUkdODzG+XoRPo 1328131148
X-Mailbox-Line: From gregkh@clark.kroah.org Wed Feb  1 12:57:40 2012
Message-Id: <20120201205740.710568597@clark.kroah.org>
User-Agent: quilt/0.51-15.1
Date: Wed, 01 Feb 2012 12:56:17 -0800
From: Greg KH <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org,
        alan@lxorguk.ukuu.org.uk,
        Lucas Kannebley Tavares <lucaskt@linux.vnet.ibm.com>,
        Breno Leitao <brenohl@br.ibm.com>,
        Thadeu Lima de Souza Cascardo <cascardo@linux.vnet.ibm.com>
Subject: [37/65] jsm: Fixed EEH recovery error
In-Reply-To: <20120201210236.GA25966@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.0-stable review patch.  If anyone has any objections, please let me know.

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
@@ -269,6 +269,7 @@ static void jsm_io_resume(struct pci_dev
 	struct jsm_board *brd = pci_get_drvdata(pdev);
 
 	pci_restore_state(pdev);
+	pci_save_state(pdev);
 
 	jsm_uart_port_init(brd);
 }


