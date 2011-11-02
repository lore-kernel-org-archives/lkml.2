Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934036Ab1KCBir (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Nov 2011 21:38:47 -0400
Received: from cantor2.suse.de ([195.135.220.15]:50968 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933994Ab1KCBig (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Nov 2011 21:38:36 -0400
X-Mailbox-Line: From gregkh@clark.kroah.org Wed Nov  2 15:27:40 2011
Message-Id: <20111102222740.863724593@clark.kroah.org>
User-Agent: quilt/0.48-16.4
Date: Wed, 02 Nov 2011 15:25:57 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org,
        alan@lxorguk.ukuu.org.uk,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>
Subject: [013/101] powerpc/pci: Check devices status property when scanning OF tree
In-Reply-To: <20111102222755.GA10893@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.33-longterm review patch.  If anyone has any objections, please let us know.

------------------

From: Sonny Rao <sonnyrao@us.ibm.com>

commit 5b339bdf164d8aee394609768f7e2e4415b0252a upstream.

We ran into an issue where it looks like we're not properly ignoring a
pci device with a non-good status property when we walk the device tree
and instanciate the Linux side PCI devices.

However, the EEH init code does look for the property and disables EEH
on these devices. This leaves us in an inconsistent where we are poking
at a supposedly bad piece of hardware and RTAS will block our config
cycles because EEH isn't enabled anyway.

Signed-of-by: Sonny Rao <sonnyrao@linux.vnet.ibm.com>
Signed-off-by: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 arch/powerpc/kernel/pci_of_scan.c |    2 ++
 1 file changed, 2 insertions(+)

--- a/arch/powerpc/kernel/pci_of_scan.c
+++ b/arch/powerpc/kernel/pci_of_scan.c
@@ -310,6 +310,8 @@ static void __devinit __of_scan_bus(stru
 	/* Scan direct children */
 	for_each_child_of_node(node, child) {
 		pr_debug("  * %s\n", child->full_name);
+		if (!of_device_is_available(child))
+			continue;
 		reg = of_get_property(child, "reg", &reglen);
 		if (reg == NULL || reglen < 20)
 			continue;


