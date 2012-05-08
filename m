Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757402Ab2EHXTu (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 May 2012 19:19:50 -0400
Received: from mail209.messagelabs.com ([216.82.255.3]:18289 "EHLO
	mail209.messagelabs.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755712Ab2EHXTt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 May 2012 19:19:49 -0400
X-Env-Sender: hartleys@visionengravers.com
X-Msg-Ref: server-16.tower-209.messagelabs.com!1336519188!5134673!1
X-Originating-IP: [216.166.12.180]
X-StarScan-Version: 6.5.7; banners=-,-,-
X-VirusChecked: Checked
From: H Hartley Sweeten <hartleys@visionengravers.com>
To: Linux Kernel <linux-kernel@vger.kernel.org>
Subject: [PATCH] staging: comedi: mite: mite_io_addr and daq_io_addr are void __iomem *
Date: Tue, 8 May 2012 16:19:34 -0700
User-Agent: KMail/1.9.9
CC: <devel@driverdev.osuosl.org>, <abbotti@mev.co.uk>,
        <fmhess@users.sourceforge.net>, <gregkh@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-ID: <201205081619.34886.hartleys@visionengravers.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The mite_io_addr and daq_io_addr variables in struct mite_struct
are both ioremap'ed pci resources and should be void __iomem *
not void *.

This quiets a lot of sparse warings for the write[lwb],read[lwb]
calls in the comedi mite drives like:

warning: incorrect type in argument 1 (different address spaces)
   expected void const volatile [noderef] <asn:2>*addr
   got void *<noident>

warning: incorrect type in argument 2 (different address spaces)
   expected void volatile [noderef] <asn:2>*addr
   got void *

It also exposed some warnings in the mite ni_660x driver where
the daq_io_address was getting cast as a void *const.

Signed-off-by: H Hartley Sweeten <hsweeten@visionengravers.com>
Cc: Ian Abbott <abbotti@mev.co.uk>
Cc: Mori Hess <fmhess@users.sourceforge.net>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---

diff --git a/drivers/staging/comedi/drivers/mite.h b/drivers/staging/comedi/drivers/mite.h
index 999551f..83f1b27 100644
--- a/drivers/staging/comedi/drivers/mite.h
+++ b/drivers/staging/comedi/drivers/mite.h
@@ -66,9 +66,9 @@ struct mite_struct {
 
 	struct pci_dev *pcidev;
 	resource_size_t mite_phys_addr;
-	void *mite_io_addr;
+	void __iomem *mite_io_addr;
 	resource_size_t daq_phys_addr;
-	void *daq_io_addr;
+	void __iomem *daq_io_addr;
 
 	struct mite_channel channels[MAX_MITE_DMA_CHANNELS];
 	short channel_allocated[MAX_MITE_DMA_CHANNELS];
diff --git a/drivers/staging/comedi/drivers/ni_660x.c b/drivers/staging/comedi/drivers/ni_660x.c
index eea7047..21eb7fb 100644
--- a/drivers/staging/comedi/drivers/ni_660x.c
+++ b/drivers/staging/comedi/drivers/ni_660x.c
@@ -761,7 +761,7 @@ static inline void ni_660x_write_register(struct comedi_device *dev,
 					  unsigned chip_index, unsigned bits,
 					  enum NI_660x_Register reg)
 {
-	void *const write_address =
+	void __iomem *write_address =
 	    private(dev)->mite->daq_io_addr + GPCT_OFFSET[chip_index] +
 	    registerData[reg].offset;
 
@@ -784,7 +784,7 @@ static inline unsigned ni_660x_read_register(struct comedi_device *dev,
 					     unsigned chip_index,
 					     enum NI_660x_Register reg)
 {
-	void *const read_address =
+	void __iomem *read_address =
 	    private(dev)->mite->daq_io_addr + GPCT_OFFSET[chip_index] +
 	    registerData[reg].offset;
 
