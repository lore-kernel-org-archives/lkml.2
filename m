Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934022Ab1JEDqp (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Oct 2011 23:46:45 -0400
Received: from mail-gy0-f174.google.com ([209.85.160.174]:41702 "EHLO
	mail-gy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933149Ab1JEDqn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Oct 2011 23:46:43 -0400
Date: Tue, 4 Oct 2011 22:46:39 -0500
From: Jon Mason <jdmason@kudzu.us>
To: Avi Kivity <avi@redhat.com>
Cc: Jon Mason <mason@myri.com>, Sven Schnelle <svens@stackframe.org>,
        Simon Kirby <sim@hostway.ca>, Eric Dumazet <eric.dumazet@gmail.com>,
        Niels Ole Salscheider <niels_ole@salscheider-online.de>,
        Jesse Barnes <jbarnes@virtuousgeek.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        "linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>,
        Ben Hutchings <bhutchings@solarflare.com>
Subject: Re: Workaround for Intel MPS errata
Message-ID: <20111005034636.GA8618@kudzu.us>
References: <4E82017C.3010304@redhat.com>
 <CAPoiz9w4LyTkmAACHQYR5GSJ+TmN7ePJSb-UuRQ7EjY=QYVn5Q@mail.gmail.com>
 <4E8215B6.1020108@redhat.com>
 <20110930001633.GA11436@myri.com>
 <4E882E34.8040409@redhat.com>
 <20111003045823.GA13222@myri.com>
 <4E898A69.8060306@redhat.com>
 <20111003151158.GA21955@myri.com>
 <4E8AD5F4.7000201@redhat.com>
 <4E8B04D8.5010107@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4E8B04D8.5010107@redhat.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hey Avi,
I believe this will fix the issue (assuming the errata is the issue in
the first place).  You'll need to apply the patch on top of Linus'
latest code and re-enable the MPS tuning (as it is now off by
default).  This can be done by adding "pci=pcie_bus_safe" to your boot
args.

After thinking about it some more, a PCI quark is the correct way of
doing things.  We must always disable read completion coalescing due
to the possibility of hotplugging a device with a MPS of 256B.  Also,
I believe everyone will think this is much cleaner.

Let me know how it goes and thanks again for testing this for me.

Thanks,
Jon

commit ada901c643c7d0978a762fbadc2a6526e4ddf860
Author: Jon Mason <mason@myri.com>
Date:   Thu Sep 29 16:56:37 2011 -0500

    PCI: Workaround for Intel MPS errata
    
    Intel 5000 and 5100 series memory controllers have a known issue if read
    completion coalescing is enabled and the PCI-E Maximum Payload Size is
    set to 256B.  To work around this issue, disable read completion
    coalescing in the memory controller and root complexes.  Unfortunately,
    it must always be disabled, even if no 256B MPS devices are precent, due
    to the possiblity of one being hotplugged.
    
    Links to erratas:
    http://www.intel.com/content/dam/doc/specification-update/5000-chipset-memory-controller-hub-specification-update.pdf
    http://www.intel.com/content/dam/doc/specification-update/5100-memory-controller-hub-chipset-specification-update.pdf
    
    Thanks to Jesse Brandeburg and Ben Hutchings for providing insight into
    the problem.
    
    Tested-and-Reported-by: Avi Kivity <avi@redhat.com>
    Signed-off-by: Jon Mason <mason@myri.com>

diff --git a/drivers/pci/probe.c b/drivers/pci/probe.c
index 6ab6bd3..c223d95 100644
--- a/drivers/pci/probe.c
+++ b/drivers/pci/probe.c
@@ -1452,7 +1452,7 @@ static int pcie_bus_configure_set(struct pci_dev *dev, void *data)
 	return 0;
 }
 
-/* pcie_bus_configure_mps requires that pci_walk_bus work in a top-down,
+/* pcie_bus_configure_settings requires that pci_walk_bus work in a top-down,
  * parents then children fashion.  If this changes, then this code will not
  * work as designed.
  */
diff --git a/drivers/pci/quirks.c b/drivers/pci/quirks.c
index 1196f61..70da3f5 100644
--- a/drivers/pci/quirks.c
+++ b/drivers/pci/quirks.c
@@ -2822,6 +2822,75 @@ static void __devinit fixup_ti816x_class(struct pci_dev* dev)
 }
 DECLARE_PCI_FIXUP_EARLY(PCI_VENDOR_ID_TI, 0xb800, fixup_ti816x_class);
 
+/* Intel 5000 and 5100 Memory controllers have an errata with read completion
+ * coalescing (which is enabled by default on some BIOSes) and MPS of 256B.
+ * Since there is no way of knowing what the PCIE MPS on each fabric will be
+ * until all of the devices are discovered and buses walked, read completion
+ * coalescing must be disabled.  Unfortunately, it cannot be re-enabled because
+ * it is possible to hotplug a device with MPS of 256B.
+ */
+static void __devinit quirk_intel_mc_errata(struct pci_dev *dev)
+{
+	int err;
+	u16 rcc;
+
+	if (pcie_bus_config == PCIE_BUS_TUNE_OFF)
+		return;
+
+	/* Intel errata specifies bits to change but does not say what they are.
+	 * Keeping them magical until such time as the registers and values can
+	 * be explained.
+	 */
+	err = pci_read_config_word(dev, 0x48, &rcc);
+	if (err) {
+		dev_err(&dev->dev, "Error attempting to read the read "
+			"completion coalescing register.\n");
+		return;
+	}
+
+	if (!(rcc & (1 << 10)))
+		return;
+
+	rcc &= ~(1 << 10);
+
+	err = pci_write_config_word(dev, 0x48, rcc);
+	if (err) {
+		dev_err(&dev->dev, "Error attempting to write the read "
+			"completion coalescing register.\n");
+		return;
+	}
+
+	pr_info_once("Read completion coalescing disabled due to hardware "
+		     "errata relating to 256B MPS.\n");
+}
+/* Intel 5000 series memory controllers and ports 2-7 */
+DECLARE_PCI_FIXUP_HEADER(PCI_VENDOR_ID_INTEL, 0x25c0, quirk_intel_mc_errata);
+DECLARE_PCI_FIXUP_HEADER(PCI_VENDOR_ID_INTEL, 0x25d0, quirk_intel_mc_errata);
+DECLARE_PCI_FIXUP_HEADER(PCI_VENDOR_ID_INTEL, 0x25d4, quirk_intel_mc_errata);
+DECLARE_PCI_FIXUP_HEADER(PCI_VENDOR_ID_INTEL, 0x25d8, quirk_intel_mc_errata);
+DECLARE_PCI_FIXUP_HEADER(PCI_VENDOR_ID_INTEL, 0x25e2, quirk_intel_mc_errata);
+DECLARE_PCI_FIXUP_HEADER(PCI_VENDOR_ID_INTEL, 0x25e3, quirk_intel_mc_errata);
+DECLARE_PCI_FIXUP_HEADER(PCI_VENDOR_ID_INTEL, 0x25e4, quirk_intel_mc_errata);
+DECLARE_PCI_FIXUP_HEADER(PCI_VENDOR_ID_INTEL, 0x25e5, quirk_intel_mc_errata);
+DECLARE_PCI_FIXUP_HEADER(PCI_VENDOR_ID_INTEL, 0x25e6, quirk_intel_mc_errata);
+DECLARE_PCI_FIXUP_HEADER(PCI_VENDOR_ID_INTEL, 0x25e7, quirk_intel_mc_errata);
+DECLARE_PCI_FIXUP_HEADER(PCI_VENDOR_ID_INTEL, 0x25f7, quirk_intel_mc_errata);
+DECLARE_PCI_FIXUP_HEADER(PCI_VENDOR_ID_INTEL, 0x25f8, quirk_intel_mc_errata);
+DECLARE_PCI_FIXUP_HEADER(PCI_VENDOR_ID_INTEL, 0x25f9, quirk_intel_mc_errata);
+DECLARE_PCI_FIXUP_HEADER(PCI_VENDOR_ID_INTEL, 0x25fa, quirk_intel_mc_errata);
+/* Intel 5100 series memory controllers and ports 2-7 */
+DECLARE_PCI_FIXUP_HEADER(PCI_VENDOR_ID_INTEL, 0x65c0, quirk_intel_mc_errata);
+DECLARE_PCI_FIXUP_HEADER(PCI_VENDOR_ID_INTEL, 0x65e2, quirk_intel_mc_errata);
+DECLARE_PCI_FIXUP_HEADER(PCI_VENDOR_ID_INTEL, 0x65e3, quirk_intel_mc_errata);
+DECLARE_PCI_FIXUP_HEADER(PCI_VENDOR_ID_INTEL, 0x65e4, quirk_intel_mc_errata);
+DECLARE_PCI_FIXUP_HEADER(PCI_VENDOR_ID_INTEL, 0x65e5, quirk_intel_mc_errata);
+DECLARE_PCI_FIXUP_HEADER(PCI_VENDOR_ID_INTEL, 0x65e6, quirk_intel_mc_errata);
+DECLARE_PCI_FIXUP_HEADER(PCI_VENDOR_ID_INTEL, 0x65e7, quirk_intel_mc_errata);
+DECLARE_PCI_FIXUP_HEADER(PCI_VENDOR_ID_INTEL, 0x65f7, quirk_intel_mc_errata);
+DECLARE_PCI_FIXUP_HEADER(PCI_VENDOR_ID_INTEL, 0x65f8, quirk_intel_mc_errata);
+DECLARE_PCI_FIXUP_HEADER(PCI_VENDOR_ID_INTEL, 0x65f9, quirk_intel_mc_errata);
+DECLARE_PCI_FIXUP_HEADER(PCI_VENDOR_ID_INTEL, 0x65fa, quirk_intel_mc_errata);
+
 static void pci_do_fixups(struct pci_dev *dev, struct pci_fixup *f,
 			  struct pci_fixup *end)
 {
