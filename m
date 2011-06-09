Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757424Ab1FILh7 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Jun 2011 07:37:59 -0400
Received: from mail-pw0-f46.google.com ([209.85.160.46]:60896 "EHLO
	mail-pw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753970Ab1FILh5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Jun 2011 07:37:57 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:mime-version:content-type
         :content-disposition:user-agent;
        b=b0H31+ywzJPtlBWPbN/bJzpVQ9iio5i0CahXVQXHyU4rD4Arzc8UBGosKJx4nPoQzm
         O/ZgxqYvKG4sSLfeefK4/iJMqjHMuqn034DVtiK8/Qwo4Ab3qR3v5JPDdkBFVt/FOcqb
         Nk04bPC4BRr666eW7KYE/biqbtQDSabODl8c0=
Date: Thu, 9 Jun 2011 17:22:15 +0530
From: "Prashant P. Shah" <pshah.mumbai@gmail.com>
To: devel@linuxdriverproject.org
Cc: Greg Kroah-Hartman <gregkh@suse.de>,
        Frank Mori Hess <fmhess@users.sourceforge.net>,
        Ian Abbott <abbotti@mev.co.uk>, linux-kernel@vger.kernel.org
Subject: [PATCH] Staging: comedi: dyna_pci10xx: replace semaphore with mutex
Message-ID: <20110609115215.GA14569@mail.fossee.in>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

- Replace all semaphores with mutex
- Check NULL value for devpriv during detach callback

Signed-off-by: Prashant P. Shah <pshah.mumbai@gmail.com>
---
 drivers/staging/comedi/drivers/dyna_pci10xx.c |   24 +++++++++++-------------
 1 files changed, 11 insertions(+), 13 deletions(-)

diff --git a/drivers/staging/comedi/drivers/dyna_pci10xx.c b/drivers/staging/comedi/drivers/dyna_pci10xx.c
index 7acb2ed..50abb6e 100644
--- a/drivers/staging/comedi/drivers/dyna_pci10xx.c
+++ b/drivers/staging/comedi/drivers/dyna_pci10xx.c
@@ -39,7 +39,7 @@
 
 #include "../comedidev.h"
 #include "comedi_pci.h"
-#include <linux/semaphore.h>
+#include <linux/mutex.h>
 
 #define PCI_VENDOR_ID_DYNALOG		0x10b5
 #define DRV_NAME			"dyna_pci10xx"
@@ -126,7 +126,7 @@ static struct comedi_driver driver_dyna_pci10xx = {
 struct dyna_pci10xx_private {
 	struct pci_dev *pci_dev;	/*  ptr to PCI device */
 	char valid;			/*  card is usable */
-	struct semaphore sem;
+	struct mutex mutex;
 
 	/* device base address registers */
 	unsigned long BADR0, BADR1, BADR2, BADR3, BADR4, BADR5;
@@ -152,7 +152,7 @@ static int dyna_pci10xx_insn_read_ai(struct comedi_device *dev,
 	chan = CR_CHAN(insn->chanspec);
 	range = thisboard->range_codes_ai[CR_RANGE((insn->chanspec))];
 
-	down(&devpriv->sem);
+	mutex_lock(&devpriv->mutex);
 	/* convert n samples */
 	for (n = 0; n < insn->n; n++) {
 		/* trigger conversion */
@@ -176,7 +176,7 @@ conv_finish:
 		d &= 0x0FFF;
 		data[n] = d;
 	}
-	up(&devpriv->sem);
+	mutex_unlock(&devpriv->mutex);
 
 	/* return the number of samples read/written */
 	return n;
@@ -193,13 +193,13 @@ static int dyna_pci10xx_insn_write_ao(struct comedi_device *dev,
 	chan = CR_CHAN(insn->chanspec);
 	range = thisboard->range_codes_ai[CR_RANGE((insn->chanspec))];
 
-	down(&devpriv->sem);
+	mutex_lock(&devpriv->mutex);
 	for (n = 0; n < insn->n; n++) {
 		/* trigger conversion and write data */
 		outw_p(data[n], devpriv->BADR2);
 		smp_mb(); udelay(10);
 	}
-	up(&devpriv->sem);
+	mutex_unlock(&devpriv->mutex);
 	return n;
 }
 
@@ -213,11 +213,11 @@ static int dyna_pci10xx_di_insn_bits(struct comedi_device *dev,
 	if (insn->n != 2)
 		return -EINVAL;
 
-	down(&devpriv->sem);
+	mutex_lock(&devpriv->mutex);
 	smp_mb();
 	d = inw_p(devpriv->BADR3);
 	udelay(10);
-	up(&devpriv->sem);
+	mutex_unlock(&devpriv->mutex);
 
 	/* on return the data[0] contains output and data[1] contains input */
 	data[1] = d;
@@ -238,15 +238,13 @@ static int dyna_pci10xx_do_insn_bits(struct comedi_device *dev,
 	 * in data[1], each channel cooresponding to a bit.
 	 * s->state contains the previous write data
 	 */
-
+	mutex_lock(&devpriv->mutex);
 	if (data[0]) {
-		down(&devpriv->sem);
 		s->state &= ~data[0];
 		s->state |= (data[0] & data[1]);
 		smp_mb();
 		outw_p(s->state, devpriv->BADR3);
 		udelay(10);
-		up(&devpriv->sem);
 	}
 
 	/*
@@ -255,7 +253,7 @@ static int dyna_pci10xx_do_insn_bits(struct comedi_device *dev,
 	 * output values if it was a purely digital output subdevice.
 	 */
 	data[1] = s->state;
-
+	mutex_unlock(&devpriv->mutex);
 	return 2;
 }
 
@@ -339,7 +337,7 @@ found:
 		return -EIO;
 	}
 
-	sema_init(&devpriv->sem, 1);
+	mutex_init(&devpriv->mutex);
 	dev->board_ptr = &boardtypes[board_index];
 	devpriv->pci_dev = pcidev;
 
-- 
1.7.1

