Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757141Ab1LGQRb (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Dec 2011 11:17:31 -0500
Received: from cantor2.suse.de ([195.135.220.15]:33085 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757120Ab1LGQR1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Dec 2011 11:17:27 -0500
X-Mailbox-Line: From gregkh@clark.kroah.org Wed Dec  7 08:08:24 2011
Message-Id: <20111207160824.268488820@clark.kroah.org>
User-Agent: quilt/0.50-23.1
Date: Wed, 07 Dec 2011 08:06:40 -0800
From: Greg KH <gregkh@suse.de>
To: <linux-kernel@vger.kernel.org>, <stable@vger.kernel.org>
Cc: <torvalds@linux-foundation.org>, <akpm@linux-foundation.org>,
        <alan@lxorguk.ukuu.org.uk>, Tim Blechmann <tim@klingt.org>,
        Takashi Iwai <tiwai@suse.de>
Subject: [20/80] ALSA: lx6464es - fix device communication via command bus
In-Reply-To: <20111207161256.GA7736@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.0-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Tim Blechmann <tim@klingt.org>

commit a29878553a9a7b4c06f93c7e383527cf014d4ceb upstream.

commit 6175ddf06b6172046a329e3abfd9c901a43efd2e optimized the mem*io
functions that have been used to send commands to the device. these
optimizations somehow corrupted the communication with the lx6464es,
that resulted the device to be unusable with kernels after 2.6.33.

this patch emulates the memcpy_*_io functions via a loop to avoid these
problems.

Signed-off-by: Tim Blechmann <tim@klingt.org>
LKML-Reference: <4ECB5257.4040600@ladisch.de>
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 sound/pci/lx6464es/lx_core.c |   16 ++++++++++++----
 1 file changed, 12 insertions(+), 4 deletions(-)

--- a/sound/pci/lx6464es/lx_core.c
+++ b/sound/pci/lx6464es/lx_core.c
@@ -80,8 +80,12 @@ unsigned long lx_dsp_reg_read(struct lx6
 
 void lx_dsp_reg_readbuf(struct lx6464es *chip, int port, u32 *data, u32 len)
 {
-	void __iomem *address = lx_dsp_register(chip, port);
-	memcpy_fromio(data, address, len*sizeof(u32));
+	u32 __iomem *address = lx_dsp_register(chip, port);
+	int i;
+
+	/* we cannot use memcpy_fromio */
+	for (i = 0; i != len; ++i)
+		data[i] = ioread32(address + i);
 }
 
 
@@ -94,8 +98,12 @@ void lx_dsp_reg_write(struct lx6464es *c
 void lx_dsp_reg_writebuf(struct lx6464es *chip, int port, const u32 *data,
 			 u32 len)
 {
-	void __iomem *address = lx_dsp_register(chip, port);
-	memcpy_toio(address, data, len*sizeof(u32));
+	u32 __iomem *address = lx_dsp_register(chip, port);
+	int i;
+
+	/* we cannot use memcpy_to */
+	for (i = 0; i != len; ++i)
+		iowrite32(data[i], address + i);
 }
 
 


