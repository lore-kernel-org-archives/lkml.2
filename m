Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935793Ab0HFT16 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Aug 2010 15:27:58 -0400
Received: from kroah.org ([198.145.64.141]:43468 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1761865Ab0HFT1t (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Aug 2010 15:27:49 -0400
X-Mailbox-Line: From gregkh@clark.site Fri Aug  6 12:21:14 2010
Message-Id: <20100806192114.783973666@clark.site>
User-Agent: quilt/0.48-11.2
Date: Fri, 06 Aug 2010 12:19:45 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Ian Abbott <abbotti@mev.co.uk>
Subject: [04/36] comedi: Uncripple 8255-based DIO subdevices
In-Reply-To: <20100806192649.GA1614@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.34-stable review patch.  If anyone has any objections, please let us know.

------------------


(Note: upstream comedi configuration has been overhauled, so this patch
does not apply there.)

Several comedi drivers call subdev_8255_init() (declared in
"drivers/staging/comedi/drivers/8255.h") to set up one or more DIO
subdevices.  This should be provided by the 8255.ko module, but unless
the CONFIG_COMEDI_8255 or CONFIG_COMEDI_8255_MODULE macro is defined,
the 8255.h header uses a dummy inline version of the function instead.
This means the comedi devices end up with an "unused" subdevice with 0
channels instead of a "DIO" subdevice with 24 channels!

This patch provides a non-interactive COMEDI_8255 option and selects it
whenever the COMEDI_PCI_DRIVERS or COMEDI_PCMCIA_DRIVERS options are
selected.

Signed-off-by: Ian Abbott <abbotti@mev.co.uk>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/staging/comedi/Kconfig          |    5 +++++
 drivers/staging/comedi/drivers/Makefile |    4 +++-
 2 files changed, 8 insertions(+), 1 deletion(-)

--- a/drivers/staging/comedi/Kconfig
+++ b/drivers/staging/comedi/Kconfig
@@ -16,6 +16,7 @@ config COMEDI_DEBUG
 config COMEDI_PCI_DRIVERS
 	tristate "Comedi PCI drivers"
 	depends on COMEDI && PCI
+	select COMEDI_8255
 	default N
 	---help---
 	  Enable lots of comedi PCI drivers to be built
@@ -23,6 +24,7 @@ config COMEDI_PCI_DRIVERS
 config COMEDI_PCMCIA_DRIVERS
 	tristate "Comedi PCMCIA drivers"
 	depends on COMEDI && PCMCIA && PCCARD
+	select COMEDI_8255
 	default N
 	---help---
 	  Enable lots of comedi PCMCIA and PCCARD drivers to be built
@@ -33,3 +35,6 @@ config COMEDI_USB_DRIVERS
 	default N
 	---help---
 	  Enable lots of comedi USB drivers to be built
+
+config COMEDI_8255
+	tristate
--- a/drivers/staging/comedi/drivers/Makefile
+++ b/drivers/staging/comedi/drivers/Makefile
@@ -8,8 +8,10 @@ obj-$(CONFIG_COMEDI)			+= comedi_test.o
 obj-$(CONFIG_COMEDI)			+= comedi_parport.o
 obj-$(CONFIG_COMEDI)			+= pcm_common.o
 
+# Comedi 8255 module
+obj-$(CONFIG_COMEDI_8255)		+= 8255.o
+
 # Comedi PCI drivers
-obj-$(CONFIG_COMEDI_PCI_DRIVERS)	+= 8255.o
 obj-$(CONFIG_COMEDI_PCI_DRIVERS)	+= acl7225b.o
 obj-$(CONFIG_COMEDI_PCI_DRIVERS)	+= addi_apci_035.o
 obj-$(CONFIG_COMEDI_PCI_DRIVERS)	+= addi_apci_1032.o


