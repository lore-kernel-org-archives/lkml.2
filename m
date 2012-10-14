Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754663Ab2JNOrd (ORCPT <rfc822;w@1wt.eu>);
	Sun, 14 Oct 2012 10:47:33 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:46774 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932446Ab2JNOoR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 14 Oct 2012 10:44:17 -0400
Message-Id: <20121014143538.285496439@decadent.org.uk>
User-Agent: quilt/0.60-1
Date: Sun, 14 Oct 2012 15:36:06 +0100
From: Ben Hutchings <ben@decadent.org.uk>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Yinghai Lu <yinghai@kernel.org>,
        "Brian C. Huffman" <bhuffman@graze.net>, VL <vl.homutov@gmail.com>,
        Bjorn Helgaas <bhelgaas@google.com>
Subject: [ 033/147] PCI: Check P2P bridge for invalid secondary/subordinate range
In-Reply-To: <20121014143533.742627615@decadent.org.uk>
X-SA-Exim-Connect-IP: 77.75.106.1
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Yinghai Lu <yinghai@kernel.org>

commit 1965f66e7db08d1ebccd24a59043eba826cc1ce8 upstream.

For bridges with "secondary > subordinate", i.e., invalid bus number
apertures, we don't enumerate anything behind the bridge unless the
user specified "pci=assign-busses".

This patch makes us automatically try to reassign the downstream bus
numbers in this case (just for that bridge, not for all bridges as
"pci=assign-busses" does).

We don't discover all the devices on the Intel DP43BF motherboard
without this change (or "pci=assign-busses") because its BIOS configures
a bridge as:

    pci 0000:00:1e.0: PCI bridge to [bus 20-08] (subtractive decode)

[bhelgaas: changelog, change message to dev_info]
Bugzilla: https://bugzilla.kernel.org/show_bug.cgi?id=18412
Bugzilla: https://bugzilla.redhat.com/show_bug.cgi?id=625754
Reported-by: Brian C. Huffman <bhuffman@graze.net>
Reported-by: VL <vl.homutov@gmail.com>
Tested-by: VL <vl.homutov@gmail.com>
Signed-off-by: Yinghai Lu <yinghai@kernel.org>
Signed-off-by: Bjorn Helgaas <bhelgaas@google.com>
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 drivers/pci/probe.c |    6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/drivers/pci/probe.c b/drivers/pci/probe.c
index 9f8a6b7..61859d0 100644
--- a/drivers/pci/probe.c
+++ b/drivers/pci/probe.c
@@ -729,8 +729,10 @@ int __devinit pci_scan_bridge(struct pci_bus *bus, struct pci_dev *dev, int max,
 
 	/* Check if setup is sensible at all */
 	if (!pass &&
-	    (primary != bus->number || secondary <= bus->number)) {
-		dev_dbg(&dev->dev, "bus configuration invalid, reconfiguring\n");
+	    (primary != bus->number || secondary <= bus->number ||
+	     secondary > subordinate)) {
+		dev_info(&dev->dev, "bridge configuration invalid ([bus %02x-%02x]), reconfiguring\n",
+			 secondary, subordinate);
 		broken = 1;
 	}
 


