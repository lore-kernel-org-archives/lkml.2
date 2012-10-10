Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932532Ab2JJXCf (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Oct 2012 19:02:35 -0400
Received: from out1-smtp.messagingengine.com ([66.111.4.25]:59225 "EHLO
	out1-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932517Ab2JJXC3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Oct 2012 19:02:29 -0400
X-Sasl-enc: cLNPQftg3QXMwW7un/tzG5YkN9MESMj5z7k969xt/AzE 1349910146
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, alan@lxorguk.ukuu.org.uk,
        "Brian C. Huffman" <bhuffman@graze.net>, VL <vl.homutov@gmail.com>,
        Yinghai Lu <yinghai@kernel.org>, Bjorn Helgaas <bhelgaas@google.com>
Subject: [ 045/122] PCI: Check P2P bridge for invalid secondary/subordinate range
Date: Thu, 11 Oct 2012 07:53:31 +0900
Message-Id: <20121010225346.246631511@linuxfoundation.org>
X-Mailer: git-send-email 1.8.0.rc0.18.gf84667d
In-Reply-To: <20121010225337.989799482@linuxfoundation.org>
References: <20121010225337.989799482@linuxfoundation.org>
User-Agent: quilt/0.60-2.1.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.6-stable review patch.  If anyone has any objections, please let me know.

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

---
 drivers/pci/probe.c |    6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

--- a/drivers/pci/probe.c
+++ b/drivers/pci/probe.c
@@ -729,8 +729,10 @@ int __devinit pci_scan_bridge(struct pci
 
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
 


