Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757502Ab2HNUqM (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Aug 2012 16:46:12 -0400
Received: from mail132.messagelabs.com ([216.82.242.115]:13228 "EHLO
	mail132.messagelabs.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756336Ab2HNUqK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Aug 2012 16:46:10 -0400
X-Env-Sender: hartleys@visionengravers.com
X-Msg-Ref: server-12.tower-132.messagelabs.com!1344977131!13216176!37
X-Originating-IP: [216.166.12.178]
X-StarScan-Received: 
X-StarScan-Version: 6.6.1.2; banners=-,-,-
X-VirusChecked: Checked
From: H Hartley Sweeten <hartleys@visionengravers.com>
To: Linux Kernel <linux-kernel@vger.kernel.org>
Subject: [PATCH] staging: comedi: adl_pci7x3x: fix pointer-to-int-cast warning
Date: Tue, 14 Aug 2012 13:45:53 -0700
User-Agent: KMail/1.9.9
CC: <devel@driverdev.osuosl.org>, <gregkh@linuxfoundation.org>,
        <abbotti@mev.co.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-ID: <201208141345.54496.hartleys@visionengravers.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This driver uses the void *private variable in the comedi_subdevice
to pass the offset needed to read/write the appropriate register to
get/set the channels for the subdevice.

The adl_pci7x3x_do_insn_bits() and adl_pci7x3x_di_insn_bits() functions
were retrieving this offset by casting the s->private value as an
unsigned int. On 64-bit builds this results in a warning:

warning: cast from pointer to integer of different size [-Wpointer-to-int-cast]

Fix these warnings by casting the void * to an unsigned long.

Signed-off-by: H Hartley Sweeten <hsweeten@visionengravers.com>
Reported-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Ian Abbott <abbotti@mev.co.uk>
---
 drivers/staging/comedi/drivers/adl_pci7x3x.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/staging/comedi/drivers/adl_pci7x3x.c b/drivers/staging/comedi/drivers/adl_pci7x3x.c
index 990670a..41963fb 100644
--- a/drivers/staging/comedi/drivers/adl_pci7x3x.c
+++ b/drivers/staging/comedi/drivers/adl_pci7x3x.c
@@ -121,7 +121,7 @@ static int adl_pci7x3x_do_insn_bits(struct comedi_device *dev,
 				    struct comedi_insn *insn,
 				    unsigned int *data)
 {
-	unsigned int reg = (unsigned int)s->private;
+	unsigned long reg = (unsigned long)s->private;
 	unsigned int mask = data[0];
 	unsigned int bits = data[1];
 
@@ -147,7 +147,7 @@ static int adl_pci7x3x_di_insn_bits(struct comedi_device *dev,
 				    struct comedi_insn *insn,
 				    unsigned int *data)
 {
-	unsigned int reg = (unsigned int)s->private;
+	unsigned long reg = (unsigned long)s->private;
 
 	data[1] = inl(dev->iobase + reg);
 
-- 
1.7.11

