Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756507Ab1ISVl1 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Sep 2011 17:41:27 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:42686 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932335Ab1ISVlZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Sep 2011 17:41:25 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Sarah Sharp <sarah.a.sharp@linux.intel.com>
Subject: Re: PME via interrupt or SCI mechanism?
Date: Mon, 19 Sep 2011 23:43:33 +0200
User-Agent: KMail/1.13.6 (Linux/3.1.0-rc4+; KDE/4.6.0; x86_64; ; )
Cc: linux-acpi@vger.kernel.org, linux-pci@vger.kernel.org,
        LKML <linux-kernel@vger.kernel.org>
References: <20110912171003.GA7939@xanatos>
In-Reply-To: <20110912171003.GA7939@xanatos>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201109192343.33407.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

Sorry for the delayed response, I was traveling during the last week too.

On Monday, September 12, 2011, Sarah Sharp wrote:
> Hi Rafael,
> 
> As I mentioned at LPC, I have a USB host controller that is failing to
> wakeup from D3 when a new USB device is connected to an external hub.
> The system is in S0 at this point.
> 
> You mentioned that there were two ways for hardware to generate PMEs:
> either through the standard PCI interrupt process, or via an ACPI SCI
> call.
> 
> I think the hardware engineers want Linux to set up the PCI device to
> generate PMEs via an SCI call, but I'm not sure if Linux is.  I've tried
> turning on ACPI debugging (with level and layers both set to 0xffffffff
> so I can see all debugging), and I don't see any output at all from ACPI
> functions like acpi_ev_sci_xrupt_handler when the host controller comes
> out of D3.  (It does come out of D3 if I plug in the device within 10
> seconds of PCI suspend, for whatever reason.)
> 
> Is there a way to tell if SCI is being used by a PCI device to generate
> PMEs?

Yes, there is.  First, if the native PCIe PME is used (which means SCI isn't),
there will be entries like these in /proc/interrupts:

 40:          0          0   PCI-MSI-edge      PCIe PME
 41:          0          0   PCI-MSI-edge      PCIe PME
 42:          0          0   PCI-MSI-edge      PCIe PME

If they are not present, it means that the kernel is _trying_ to use SCI
for PME signaling.  In that case, you can check if the number of ACPI
interrupts in /proc/interrupts is increasing when you try to trigger the
events.

In that case you can use the files under /sys/firmware/acpi/interrupts/
to see what GPEs are activated by the wakeup events.


> You also mentioned that Linux has to choose whether to use standard
> interrupts or an SCI to generate PMEs.  You said Linux asks the BIOS if
> the hardware can use interrupts to generate PMEs, and it always uses
> interrupt-based PME generation if the BIOS says yes.

That's correct.

> Do you know where that code is?

drivers/acpi/pci_root.c:acpi_pci_root_add()

> I'd like to see how the BIOS responds to that call, and perhaps get the
> BIOS guys to fix their response if the hardware is supposed to only use
> SCIs to generate PMEs.

The BIOS should respond by clearing bit 2 (PCIe PME) of the control field
returned from _OSC() invoked for the PCIe Root Complex (meaning that the
kernel is not granted control of the native PCIe feature).

Thanks,
Rafael
