Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758855Ab0JZCxg (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Oct 2010 22:53:36 -0400
Received: from mx1.redhat.com ([209.132.183.28]:19053 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757241Ab0JZCxe (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Oct 2010 22:53:34 -0400
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
	Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
	Kingdom.
	Registered in England and Wales under Company Registration No. 3798903
Subject: [PATCH 04/43] mn10300: Use pci_claim_resource
To: linux-am33-list@redhat.com
From: David Howells <dhowells@redhat.com>
Cc: Matthew Wilcox <willy@linux.intel.com>, linux-kernel@vger.kernel.org
Date: Tue, 26 Oct 2010 03:53:23 +0100
Message-ID: <20101026025323.23512.69162.stgit@warthog.procyon.org.uk>
In-Reply-To: <20101026025301.23512.24525.stgit@warthog.procyon.org.uk>
References: <20101026025301.23512.24525.stgit@warthog.procyon.org.uk>
User-Agent: StGit/0.15-97-g9680-dirty
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: by way of Jesse Barnes jbarnes@virtuousgeek.org <Matthew Wilcox willy@linux.intel.com>

Instead of open-coding pci_find_parent_resource and request_resource,
just call pci_claim_resource.

Signed-off-by: Matthew Wilcox <willy@linux.intel.com>
Signed-off-by: David Howells <dhowells@redhat.com>
---

 arch/mn10300/unit-asb2305/pci-asb2305.c |   16 ++++++----------
 1 files changed, 6 insertions(+), 10 deletions(-)


diff --git a/arch/mn10300/unit-asb2305/pci-asb2305.c b/arch/mn10300/unit-asb2305/pci-asb2305.c
index 45b40ac..8e6763e 100644
--- a/arch/mn10300/unit-asb2305/pci-asb2305.c
+++ b/arch/mn10300/unit-asb2305/pci-asb2305.c
@@ -93,7 +93,7 @@ static void __init pcibios_allocate_bus_resources(struct list_head *bus_list)
 	struct pci_bus *bus;
 	struct pci_dev *dev;
 	int idx;
-	struct resource *r, *pr;
+	struct resource *r;
 
 	/* Depth-First Search on bus tree */
 	list_for_each_entry(bus, bus_list, node) {
@@ -105,10 +105,8 @@ static void __init pcibios_allocate_bus_resources(struct list_head *bus_list)
 				r = &dev->resource[idx];
 				if (!r->flags)
 					continue;
-				pr = pci_find_parent_resource(dev, r);
 				if (!r->start ||
-				    !pr ||
-				    request_resource(pr, r) < 0) {
+				    pci_claim_resource(dev, idx) < 0) {
 					printk(KERN_ERR "PCI:"
 					       " Cannot allocate resource"
 					       " region %d of bridge %s\n",
@@ -131,7 +129,7 @@ static void __init pcibios_allocate_resources(int pass)
 	struct pci_dev *dev = NULL;
 	int idx, disabled;
 	u16 command;
-	struct resource *r, *pr;
+	struct resource *r;
 
 	for_each_pci_dev(dev) {
 		pci_read_config_word(dev, PCI_COMMAND, &command);
@@ -150,8 +148,7 @@ static void __init pcibios_allocate_resources(int pass)
 				    " (f=%lx, d=%d, p=%d)\n",
 				    pci_name(dev), r->start, r->end, r->flags,
 				    disabled, pass);
-				pr = pci_find_parent_resource(dev, r);
-				if (!pr || request_resource(pr, r) < 0) {
+				if (pci_claim_resource(dev, idx) < 0) {
 					printk(KERN_ERR "PCI:"
 					       " Cannot allocate resource"
 					       " region %d of device %s\n",
@@ -184,7 +181,7 @@ static void __init pcibios_allocate_resources(int pass)
 static int __init pcibios_assign_resources(void)
 {
 	struct pci_dev *dev = NULL;
-	struct resource *r, *pr;
+	struct resource *r;
 
 	if (!(pci_probe & PCI_ASSIGN_ROMS)) {
 		/* Try to use BIOS settings for ROMs, otherwise let
@@ -194,8 +191,7 @@ static int __init pcibios_assign_resources(void)
 			r = &dev->resource[PCI_ROM_RESOURCE];
 			if (!r->flags || !r->start)
 				continue;
-			pr = pci_find_parent_resource(dev, r);
-			if (!pr || request_resource(pr, r) < 0) {
+			if (pci_claim_resource(dev, PCI_ROM_RESOURCE) < 0) {
 				r->end -= r->start;
 				r->start = 0;
 			}

