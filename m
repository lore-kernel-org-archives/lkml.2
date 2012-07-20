Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753531Ab2GTRc4 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Jul 2012 13:32:56 -0400
Received: from mail132.messagelabs.com ([216.82.242.115]:59341 "EHLO
	mail132.messagelabs.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753101Ab2GTRcy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Jul 2012 13:32:54 -0400
X-Env-Sender: hartleys@visionengravers.com
X-Msg-Ref: server-4.tower-132.messagelabs.com!1342805572!14948021!2
X-Originating-IP: [216.166.12.31]
X-StarScan-Version: 6.5.10; banners=-,-,-
X-VirusChecked: Checked
From: H Hartley Sweeten <hartleys@visionengravers.com>
To: Linux Kernel <linux-kernel@vger.kernel.org>
Subject: [PATCH 4/5] staging: comedi: dt3000: ioremap'ed addresses are resource_size_t
Date: Fri, 20 Jul 2012 10:32:47 -0700
User-Agent: KMail/1.9.9
CC: <devel@driverdev.osuosl.org>, <abbotti@mev.co.uk>,
        <gregkh@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-ID: <201207201032.47867.hartleys@visionengravers.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

As mentioned by Ian Abbott, the pci address passed to ioremap
should be a resource_size_t not an unsigned long. Use a local
variable of that type to hold the pci_resource_start() that is
passed to ioremp().

Set the dev->iobase to a dummy non-zero value so that the "detach"
can use it as a flag to know that comedi_pci_disable() needs to
be called.

Signed-off-by: H Hartley Sweeten <hsweeten@visionengravers.com>
Reported-by: Ian Abbott <abbotti@mev.co.uk>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/staging/comedi/drivers/dt3000.c | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/drivers/staging/comedi/drivers/dt3000.c b/drivers/staging/comedi/drivers/dt3000.c
index a6fe6c9..3476cda 100644
--- a/drivers/staging/comedi/drivers/dt3000.c
+++ b/drivers/staging/comedi/drivers/dt3000.c
@@ -804,6 +804,7 @@ static int dt3000_attach(struct comedi_device *dev, struct comedi_devconfig *it)
 {
 	struct pci_dev *pcidev;
 	struct comedi_subdevice *s;
+	resource_size_t pci_base;
 	int ret = 0;
 
 	dev_dbg(dev->class_dev, "dt3000:\n");
@@ -820,9 +821,10 @@ static int dt3000_attach(struct comedi_device *dev, struct comedi_devconfig *it)
 	ret = comedi_pci_enable(pcidev, "dt3000");
 	if (ret < 0)
 		return ret;
+	dev->iobase = 1;	/* the "detach" needs this */
 
-	dev->iobase = pci_resource_start(pcidev, 0);
-	devpriv->io_addr = ioremap(dev->iobase, DT3000_SIZE);
+	pci_base  = pci_resource_start(pcidev, 0);
+	devpriv->io_addr = ioremap(pci_base, DT3000_SIZE);
 	if (!devpriv->io_addr)
 		return -ENOMEM;
 
-- 
1.7.11

