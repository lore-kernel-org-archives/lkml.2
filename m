Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933353Ab1I1WtA (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Sep 2011 18:49:00 -0400
Received: from cantor2.suse.de ([195.135.220.15]:54855 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933336Ab1I1Wsy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Sep 2011 18:48:54 -0400
X-Mailbox-Line: From gregkh@clark.kroah.org Wed Sep 28 15:01:47 2011
Message-Id: <20110928220147.715204100@clark.kroah.org>
User-Agent: quilt/0.48-16.4
Date: Wed, 28 Sep 2011 15:02:56 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Jon Mason <mason@myri.com>
Subject: [212/244] pci: Dont crash when reading mpss from root complex
In-Reply-To: <20110928220225.GA27128@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.0-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Benjamin Herrenschmidt <benh@kernel.crashing.org>

commit 1a4b1a41b8a3d5256019854e851beed063b34344 upstream.

In pcie_find_smpss(), we have the following statement:

 	if (dev->is_hotplug_bridge && (!list_is_singular(&dev->bus->devices) ||
	    dev->bus->self->pcie_type != PCI_EXP_TYPE_ROOT_PORT))

The problem is that at least on my machine, this gets called for the
root complex (virtual P2P bridge), and dev->bus->self is NULL since
the parent bus for this is not itself anchor to a PCI device.

This adds the necessary NULL check.

Signed-off-by: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Acked-by: Jon Mason <mason@myri.com>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/pci/probe.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

--- a/drivers/pci/probe.c
+++ b/drivers/pci/probe.c
@@ -1352,7 +1352,8 @@ static int pcie_find_smpss(struct pci_de
 	 * will occur as normal.
 	 */
 	if (dev->is_hotplug_bridge && (!list_is_singular(&dev->bus->devices) ||
-	    dev->bus->self->pcie_type != PCI_EXP_TYPE_ROOT_PORT))
+	     (dev->bus->self &&
+	      dev->bus->self->pcie_type != PCI_EXP_TYPE_ROOT_PORT)))
 		*smpss = 0;
 
 	if (*smpss > dev->pcie_mpss)


