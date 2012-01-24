Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932771Ab2AXCzl (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Jan 2012 21:55:41 -0500
Received: from cantor2.suse.de ([195.135.220.15]:50563 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932745Ab2AXCr4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Jan 2012 21:47:56 -0500
X-Mailbox-Line: From gregkh@clark.kroah.org Mon Jan 23 18:39:33 2012
Message-Id: <20120124023933.553323508@clark.kroah.org>
User-Agent: quilt/0.50-11.1
Date: Mon, 23 Jan 2012 18:35:28 -0800
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org,
        alan@lxorguk.ukuu.org.uk,
        =?UTF-8?q?Rafa=C5=82=20Mi=C5=82ecki?= <zajec5@gmail.com>,
        "John W. Linville" <linville@tuxdriver.com>
Subject: [108/129] bcma: invalidate the mapped core over suspend/resume
In-Reply-To: <20120124024041.GA18422@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2-stable review patch.  If anyone has any objections, please let me know.

------------------
Content-Length: 1013
Lines: 35

From: Rafał Miłecki <zajec5@gmail.com>

commit 28e7d218da975f6ae1751e293aed938952c55c98 upstream.

This clears the currently mapped core when suspending, to force
re-mapping after resume. Without that we were touching default core
registers believing some other core is mapped. Such a behaviour
resulted in lockups on some machines.

Signed-off-by: Rafał Miłecki <zajec5@gmail.com>
Signed-off-by: John W. Linville <linville@tuxdriver.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/bcma/host_pci.c |    3 +++
 1 file changed, 3 insertions(+)

--- a/drivers/bcma/host_pci.c
+++ b/drivers/bcma/host_pci.c
@@ -227,11 +227,14 @@ static void bcma_host_pci_remove(struct
 #ifdef CONFIG_PM
 static int bcma_host_pci_suspend(struct pci_dev *dev, pm_message_t state)
 {
+	struct bcma_bus *bus = pci_get_drvdata(dev);
+
 	/* Host specific */
 	pci_save_state(dev);
 	pci_disable_device(dev);
 	pci_set_power_state(dev, pci_choose_state(dev, state));
 
+	bus->mapped_core = NULL;
 	return 0;
 }
 


