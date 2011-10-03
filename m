Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756463Ab1JCPMQ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Oct 2011 11:12:16 -0400
Received: from mail-pz0-f42.google.com ([209.85.210.42]:64578 "EHLO
	mail-pz0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756096Ab1JCPMI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Oct 2011 11:12:08 -0400
Date: Mon, 3 Oct 2011 10:12:01 -0500
From: Jon Mason <mason@myri.com>
To: Avi Kivity <avi@redhat.com>
Cc: Sven Schnelle <svens@stackframe.org>, Simon Kirby <sim@hostway.ca>,
        Eric Dumazet <eric.dumazet@gmail.com>,
        Niels Ole Salscheider <niels_ole@salscheider-online.de>,
        Jesse Barnes <jbarnes@virtuousgeek.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        "linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>,
        Ben Hutchings <bhutchings@solarflare.com>
Subject: Re: Workaround for Intel MPS errata
Message-ID: <20111003151158.GA21955@myri.com>
References: <4E82017C.3010304@redhat.com>
 <CAPoiz9w4LyTkmAACHQYR5GSJ+TmN7ePJSb-UuRQ7EjY=QYVn5Q@mail.gmail.com>
 <4E8215B6.1020108@redhat.com>
 <20110930001633.GA11436@myri.com>
 <4E882E34.8040409@redhat.com>
 <20111003045823.GA13222@myri.com>
 <4E898A69.8060306@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4E898A69.8060306@redhat.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Oct 03, 2011 at 12:11:53PM +0200, Avi Kivity wrote:
> On 10/03/2011 06:58 AM, Jon Mason wrote:
> >On Sun, Oct 02, 2011 at 11:26:12AM +0200, Avi Kivity wrote:
> >>  On 09/30/2011 03:16 AM, Jon Mason wrote:
> >>  >Hey Avi,
> >>  >Can you try this patch?  It should resolve the issue you are seeing.
> >>
> >>  It doesn't; the fixup: label is not reached (though I do have an
> >>  0x25d4 device).
> >>
> >>  -- >  error compiling committee.c: too many arguments to
> >function
> >>
> >
> >I found a system with a 5000X Memory controller (which should have the
> >same errata).  It doesn't have the faulty bit (perhaps better BIOS).  I
> >was able to findout why the code in the previous patch wasn't working,
> >but wasn't able to cause the crash by setting the bit from the errata.
> >The reworked version of the previous patch found below should resolve
> >the issue.  Please test it if you can.
> 
> Will be happy to test, but patch appears to be against a different tree?
> 
> $ git apply -C2 .git/rebase-apply/patch
> .git/rebase-apply/patch:75: trailing whitespace, shock horror.
>      *
> Context reduced to (2/2) to apply fragment at 1362
> Context reduced to (2/2) to apply fragment at 1475
> error: patch failed: drivers/pci/probe.c:1433
> error: drivers/pci/probe.c: patch does not apply

Sorry, I had the patch on top of the 3 patches I just sent to Linus.
I've rebased it and inserted it below.

Thanks,
Jon


    PCI: Workaround for Intel MPS errata
    
    Intel 5000 and 5100 series memory controllers have a known issue if read
    completion coalescing is enabled (the default setting) and the PCI-E
    Maximum Payload Size is set to 256B.  To work around this issue, disable
    read completion coalescing if the MPS is 256B.
    
    It is worth noting that there is no function to undo the disable of read
    completion coalescing, and the performance benefit of read completion
    coalescing will be lost if the MPS is set from 256B to 128B.  It is only
    possible to have this issue via hotplug removing the only 256B MPS
    device in the system (thus making all of the other devices in the system
    have a performance degradation without the benefit of any 256B
    transfers).  Therefore, this trade off is acceptable.
    
    http://www.intel.com/content/dam/doc/specification-update/5000-chipset-memory-controller-hub-specification-update.pdf
    http://www.intel.com/content/dam/doc/specification-update/5100-memory-controller-hub-chipset-specification-update.pdf
    
    Thanks to Jesse Brandeburg and Ben Hutchings for providing insight into
    the problem.
    
    Reported-by: Avi Kivity <avi@redhat.com>
    Signed-off-by: Jon Mason <mason@myri.com>

diff --git a/drivers/pci/probe.c b/drivers/pci/probe.c
index f3f94a5..1dd11a5 100644
--- a/drivers/pci/probe.c
+++ b/drivers/pci/probe.c
@@ -1361,6 +1361,90 @@ static int pcie_find_smpss(struct pci_dev *dev, void *data)
 	return 0;
 }
 
+static void pcie_errata_check(int mps)
+{
+	static bool done = false;
+	struct pci_bus *bus;
+	u16 val;
+
+	if (done)
+		return;
+
+	/* pci_get_device cannot be used for these, as there are no pci_dev's
+	 * created for the memory controllers.  We'll have to get nasty here and
+	 * check PCI config space ourselves.
+	 */
+	bus = pci_find_bus(0, 0);
+	if (!bus)
+		return;
+
+	/* Intel 5000 and 5100 Memory controllers have an errata with read
+	 * completion coalescing (which is enabled by default) and MPS of 256B.
+	 */
+	pci_bus_read_config_word(bus, 0, PCI_VENDOR_ID, &val);
+	if (val != PCI_VENDOR_ID_INTEL) {
+		done = true;
+		return;
+	}
+
+	pci_bus_read_config_word(bus, 0, PCI_DEVICE_ID, &val);
+	switch (val) {
+	case 0x25C0:	/* 5000X Chipset Memory Controller Hub */
+	case 0x25D0:	/* 5000Z Chipset Memory Controller Hub */
+	case 0x25D4:	/* 5000V Chipset Memory Controller Hub */
+	case 0x25D8:	/* 5000P Chipset Memory Controller Hub */
+	case 0x65C0:	/* 5100 Chipset Memory Controller Hub */
+		break;
+	default:
+		done = true;
+		return;
+	}
+
+	/* Disable read completion coalescing to allow an MPS of 256.
+	 * 
+	 * It is worth noting that there is no function to undo the disable of
+	 * read completion coalescing, and the performance benefit of read
+	 * completion coalescing will be lost if the MPS is set from 256B to
+	 * 128B.  It is only possible to have this issue via hotplug removing
+	 * the only 256B MPS device in the system (thus making all of the other
+	 * devices in the system have a performance degradation without the
+	 * benefit of any 256B transfers).  Therefore, this trade off is
+	 * acceptable.
+	 */
+	if (mps == 256) {
+		int err;
+
+		/* Intel errata specifies bits to change but does not say what
+		 * they are.  Keeping them magical until such time as the
+		 * registers and values can be explained.
+		 */
+		err = pci_bus_read_config_word(bus, 0, 0x48, &val);
+		if (err) {
+			dev_err(&bus->dev, "Error attempting to read the read "
+				"completion coalescing register.\n");
+			return;
+		}
+
+		if (!(val & (1 << 10))) {
+			done = true;
+			return;
+		}
+
+		val |= (1 << 10);
+		err = pci_bus_write_config_word(bus, 0, 0x48, val);
+		if (err) {
+			dev_err(&bus->dev, "Error attempting to write the read "
+				"completion coalescing register.\n");
+			return;
+		}
+
+		dev_info(&bus->dev, "Read completion coalescing disabled due "
+			 "to hardware errata relating to 256B MPS.\n");
+
+		done = true;
+	}
+}
+
 static void pcie_write_mps(struct pci_dev *dev, int mps)
 {
 	int rc, dev_mpss;
@@ -1390,6 +1474,8 @@ static void pcie_write_mps(struct pci_dev *dev, int mps)
 		dev->pcie_mpss = ffs(mps) - 8;
 	}
 
+	pcie_errata_check(mps);
+
 	rc = pcie_set_mps(dev, mps);
 	if (rc)
 		dev_err(&dev->dev, "Failed attempting to set the MPS\n");
@@ -1452,7 +1538,7 @@ static int pcie_bus_configure_set(struct pci_dev *dev, void *data)
 	return 0;
 }
 
-/* pcie_bus_configure_mps requires that pci_walk_bus work in a top-down,
+/* pcie_bus_configure_settings requires that pci_walk_bus work in a top-down,
  * parents then children fashion.  If this changes, then this code will not
  * work as designed.
  */
