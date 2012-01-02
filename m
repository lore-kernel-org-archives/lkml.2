Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752753Ab2ABOHS (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Jan 2012 09:07:18 -0500
Received: from mail-ww0-f44.google.com ([74.125.82.44]:55566 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751089Ab2ABOHQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Jan 2012 09:07:16 -0500
Date: Mon, 2 Jan 2012 13:51:45 +0000
From: Jamie Iles <jamie@jamieiles.com>
To: Mark Brown <broonie@opensource.wolfsonmicro.com>
Cc: Jamie Iles <jamie@jamieiles.com>, linux-kernel@vger.kernel.org,
        devicetree-discuss@lists.ozlabs.org, linus.walleij@stericsson.com
Subject: Re: [PATCHv3 1/3] gpio: add a driver for the Synopsys DesignWare APB
 GPIO block
Message-ID: <20120102135145.GA25420@page>
References: <1325508798-25439-1-git-send-email-jamie@jamieiles.com>
 <1325508798-25439-2-git-send-email-jamie@jamieiles.com>
 <20120102132500.GB18443@sirena.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120102132500.GB18443@sirena.org.uk>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Mark,

On Mon, Jan 02, 2012 at 01:25:00PM +0000, Mark Brown wrote:
> On Mon, Jan 02, 2012 at 12:53:16PM +0000, Jamie Iles wrote:
> > The Synopsys DesignWare block is used in some ARM devices (picoxcell)
> > and can be configured to provide multiple banks of GPIO pins.
> > 
> > v3:	- depend on rather than select IRQ_DOMAIN
> > 	- split IRQ support into a separate patch
> > v2:	- use Rob Herring's irqdomain in generic irq chip patches
> > 	- use reg property to indicate bank index
> > 	- support irqs on both edges based on LinusW's u300 driver
> 
> Put stuff like this after the ---, it shouldn't end up in git history.

Grant (and others I believe) have asked to have it above the separator 
in the past to ensure that it does end up in the history.  This helps 
make it clear what version got applied and it's a lot easier for patch 
authors to manage rather than keeping it out of band.

> > +- #interrupt-cells : Specifies the number of cells needed to encode an
> > +interrupt.  Shall be set to 2.  The first cell defines the interrupt number,
> > +the second encodes the triger flags encoded as:
> 
> > +	bits[3:0] trigger type and level flags.
> > +		1 = low-to-high edge triggered
> > +		2 = high-to-low edge triggered
> > +		4 = active high level-sensitive
> > +		8 = active low level-sensitive
> 
> This looks like a straight mapping of the Linux constants to device
> tree.  This seems sensible and reasonable and since we're forced to use
> magic numbers by the binding it'd be really good if we could standardise
> on using this for new drivers to reduce the pain for people writing and
> reading device tree bindings.  To help with that could you factor this
> out into a separate document that other drivers can reference?

Something like this?

diff --git a/Documentation/devicetree/bindings/arm/gic.txt b/Documentation/devicetree/bindings/arm/gic.txt
index 9b4b82a..d13f7ce 100644
--- a/Documentation/devicetree/bindings/arm/gic.txt
+++ b/Documentation/devicetree/bindings/arm/gic.txt
@@ -24,12 +24,8 @@ Main node required properties:
   SPI interrupts are in the range [0-987].  PPI interrupts are in the
   range [0-15].
 
-  The 3rd cell is the flags, encoded as follows:
-	bits[3:0] trigger type and level flags.
-		1 = low-to-high edge triggered
-		2 = high-to-low edge triggered
-		4 = active high level-sensitive
-		8 = active low level-sensitive
+  The 3rd cell is the flags, encoded as the trigger masks from
+  Documentation/devicetree/bindings/interrupts.txt and:
 	bits[15:8] PPI interrupt cpu mask.  Each bit corresponds to each of
 	the 8 possible cpus attached to the GIC.  A bit set to '1' indicated
 	the interrupt is wired to that CPU.  Only valid for PPI interrupts.
diff --git a/Documentation/devicetree/bindings/gpio/snps-dwapb-gpio.txt b/Documentation/devicetree/bindings/gpio/snps-dwapb-gpio.txt
index dccc113..73adf37 100644
--- a/Documentation/devicetree/bindings/gpio/snps-dwapb-gpio.txt
+++ b/Documentation/devicetree/bindings/gpio/snps-dwapb-gpio.txt
@@ -21,14 +21,8 @@ Optional properties:
 controller.
 - #interrupt-cells : Specifies the number of cells needed to encode an
 interrupt.  Shall be set to 2.  The first cell defines the interrupt number,
-the second encodes the triger flags encoded as:
-
-	bits[3:0] trigger type and level flags.
-		1 = low-to-high edge triggered
-		2 = high-to-low edge triggered
-		4 = active high level-sensitive
-		8 = active low level-sensitive
-
+the second encodes the triger flags encoded as described in
+Documentation/devicetree/bindings/interrupts.txt
 - interrupt-parent : The parent interrupt controller.
 - interrupts : The interrupts to the parent controller raised when GPIOs
 generate the interrupts.
diff --git a/Documentation/devicetree/bindings/interrupts.txt b/Documentation/devicetree/bindings/interrupts.txt
new file mode 100644
index 0000000..1545941
--- /dev/null
+++ b/Documentation/devicetree/bindings/interrupts.txt
@@ -0,0 +1,17 @@
+Common Interrupt Binding Details
+
+For controllers that need to encode trigger types and senses, where possible
+it is encouraged to use the following encoding (a direct mapping of the
+IRQF_TRIGGER_* constants in include/linux/interrupt.h):
+
+	bits[3:0] trigger type and level flags.
+		1 = low-to-high edge triggered
+		2 = high-to-low edge triggered
+		4 = active high level-sensitive
+		8 = active low level-sensitive
+
+For example, an interrupt may be encoded as (with #interrupt-cells = <2>):
+
+	interrupts = <4 0x3>;
+
+to have interrupt 4 raise an interrupt on both edges of the input.

Jamie
