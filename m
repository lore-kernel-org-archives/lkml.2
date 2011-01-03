Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755558Ab1ACRpG (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Jan 2011 12:45:06 -0500
Received: from mail-iy0-f174.google.com ([209.85.210.174]:51483 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750995Ab1ACRpE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Jan 2011 12:45:04 -0500
Date: Mon, 3 Jan 2011 10:45:00 -0700
From: Grant Likely <grant.likely@secretlab.ca>
To: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
Cc: linux-kernel@vger.kernel.org, sodaville@linutronix.de, x86@kernel.org,
        devicetree-discuss@lists.ozlabs.org
Subject: Re: [PATCH 03/15] x86/dtb: Add a device tree for CE4100
Message-ID: <20110103174500.GC2522@angua.secretlab.ca>
References: <1292600033-12271-1-git-send-email-bigeasy@linutronix.de>
 <1292600033-12271-4-git-send-email-bigeasy@linutronix.de>
 <20101230085122.GE11721@angua.secretlab.ca>
 <4D21B2D8.8040509@linutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4D21B2D8.8040509@linutronix.de>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jan 03, 2011 at 12:28:24PM +0100, Sebastian Andrzej Siewior wrote:
> Grant Likely wrote:
> 
> >>diff --git a/arch/x86/platform/ce4100/falconfalls.dts b/arch/x86/platform/ce4100/falconfalls.dts
> >>new file mode 100644
> >>index 0000000..24e67ca
> >>--- /dev/null
> >>+++ b/arch/x86/platform/ce4100/falconfalls.dts
> >>+
> >>+				i2c@15a00 {
> >>+					#address-cells = <1>;
> >>+					#size-cells = <0>;
> >>+					reg = <0x15a00 0x0 0x0 0x0>;
> >>+
> >>+
> >>+					i2c@0 {
> >>+						reg = <0>;
> >>+					};
> >>+
> >>+					i2c@1 {
> >>+						#address-cells = <1>;
> >>+						#size-cells = <0>;
> >>+						reg = <1>;
> >>+
> >>+						pcf8575@26 {
> >>+							compatible = "ti,pcf8575";
> >>+							reg = <0x26>;
> >>+						};
> >>+					};
> >>+
> >>+					i2c@2 {
> >>+						#address-cells = <1>;
> >>+						#size-cells = <0>;
> >>+						reg = <2>;
> >>+
> >>+						pcf8575@26 {
> >>+							compatible = "ti,pcf8575";
> >>+							reg = <0x26>;
> >>+						};
> >>+					};
> >
> >All these i2c bus controllers should have a compatible value so that
> >the OS knows what driver to bind to them.
> 
> The node i2c@15a00 is the PCI device. This PCI device has three bars, each
> bar is a complete i2c controller. All three controller share one IRQ. The
> device is probed via its pci-id and therefore I have no compatible value
> here. Do you want me to add compatible values based on "Vendor ID, Device
> ID, Subsystem Vendor ID, ..." as mention in the PCI-bindings?

If you have a node describing a device, then it *must* have a
compatible value.  Use the OF PCI binding to determine what the
compatible value should be something like:

compatible = "pciVVVV,DDDD,SSSS,ssss", "pciVVVV,DDDD"

See page 9 on this pdf: http://www.openbios.org/data/docs/bus.pci.pdf

The list of possible formats in the binding doc is long, but most of
them probably don't apply in your case (but include the other entries
if they do).

Also, since the i2c@15a00 is *not* an actual i2c bus, it should not be
named 'i2c@...'.  Name it something like i2c-controller@15a00,0,0.

You'll also note that I added ',0,0' to the end of the address.
That's because the node address reflects the parent bus address format
which uses 3 cells in this case.

> The child nodes here (i2c@0,...) represent the bars. I probably should
> replace i2c@0 with bar@0 and the reg property with a bar property. Would
> that be okay?

That depends.  Are the child nodes separately memory mapped devices?
Or are all three controlled by a shared register bank in the
controller?  If they are addressable (which they probably are) then
you need to use a ranges property to describe the translation from the
parent node to the child node.  Since you say that the registers
define describe the bars, it probably makes sense to use a 2 cell
addressing scheme: one cell for the bar# and one cell for the offset
off the bar base address (which will be 0 for each I expect).
Something like this:


	i2c-controller@15a00 {
		compatible = "intel,<blah>", "pciVVVV,DDDD,SSSS,ssss", "pciVVVV,DDDD";
		#address-cells = <2>;
		#size-cells = <1>;	// not 0!  0 is used for
					// devices that cannot be
					// memory mapped.
		reg = <0x15a00 0x0 0x0 0x0>;

		// Here's where the magic happens.  Each entry in
		// ranges describes how the parent pci address space
		// (middle group of 3) is translated to the local
		// address space (first group of 2) and the size of
		// each range (last cell).  In this particular case,
		// the first cell of the local address is chosen to be
		// 1:1 mapped to the BARs, and the second is the
		// offset from be base of the BAR (which would be
		// non-zero if you had 2 or more devices mapped off
		// the same BAR)
		//
		// ranges allows the address mapping to be described
		// in a way that the OS can interpret without
		// requiring custom device driver code.
		//
		// This example assumes that each child node has it's
		// own range of memory mapped registers.
		ranges = <0 0   0x02000000 0 0xa0000000   0x1000>
			 <1 0   0x02000000 0 0xa0002000   0x1000>
			 <2 0   0x02000000 0 0xa0004000   0x1000>


		i2c@0,0 {
			#address-cells = <1>
			#size-cells = <0>;
			compatible = <need something here>;
			reg = <1 0  0x1000>;
		};

		i2c@1,0 {
			#address-cells = <1>;
			#size-cells = <0>;
			compatible = <need something here>;
			reg = <1 0 0x1000>;

			pcf8575@26 {
				compatible = "ti,pcf8575";
				reg = <0x26>;
			};
		};

		i2c@2,0 {
			#address-cells = <1>;
			#size-cells = <0>;
			compatible = <need something here>;
			reg = <2 0 0x1000>;

			pcf8575@26 {
				compatible = "ti,pcf8575";
				reg = <0x26>;
			};
		};

> 
> >Also, the node names for the i2c devices should reflect what the
> >device does, not what the part number is (grep ePAPR for 'generic
> >names')
> Okay. This probably also means that I should replace pic@ with
> interrupt-controller and so on.

Correct.

g.

