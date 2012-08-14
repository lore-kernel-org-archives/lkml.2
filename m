Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756487Ab2HNPuR (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Aug 2012 11:50:17 -0400
Received: from mail4-relais-sop.national.inria.fr ([192.134.164.105]:52616
	"EHLO mail4-relais-sop.national.inria.fr" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755524Ab2HNPt4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Aug 2012 11:49:56 -0400
X-IronPort-AV: E=Sophos;i="4.77,766,1336341600"; 
   d="scan'208";a="153065917"
From: Julia Lawall <Julia.Lawall@lip6.fr>
To: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Cc: kernel-janitors@vger.kernel.org, Paul Mackerras <paulus@samba.org>,
        linuxppc-dev@lists.ozlabs.org, linux-kernel@vger.kernel.org
Subject: [PATCH 5/5] arch/powerpc/platforms/powernv/pci.c: Remove potential NULL dereferences
Date: Tue, 14 Aug 2012 17:49:48 +0200
Message-Id: <1344959388-19719-6-git-send-email-Julia.Lawall@lip6.fr>
X-Mailer: git-send-email 1.7.8.6
In-Reply-To: <1344959388-19719-1-git-send-email-Julia.Lawall@lip6.fr>
References: <1344959388-19719-1-git-send-email-Julia.Lawall@lip6.fr>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Julia Lawall <Julia.Lawall@lip6.fr>

If the NULL test is necessary, the initialization involving a dereference of
the tested value should be moved after the NULL test.

The sematic patch that fixes this problem is as follows:
(http://coccinelle.lip6.fr/)

// <smpl>
@@
type T;
expression E;
identifier i,fld;
statement S;
@@

- T i = E->fld;
+ T i;
  ... when != E
      when != i
  if (E == NULL) S
+ i = E->fld;
// </smpl>

Signed-off-by: Julia Lawall <Julia.Lawall@lip6.fr>

---
 arch/powerpc/platforms/powernv/pci.c |    6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/arch/powerpc/platforms/powernv/pci.c b/arch/powerpc/platforms/powernv/pci.c
index be3cfc5..928e97b 100644
--- a/arch/powerpc/platforms/powernv/pci.c
+++ b/arch/powerpc/platforms/powernv/pci.c
@@ -287,12 +287,13 @@ static int pnv_pci_read_config(struct pci_bus *bus,
 			       int where, int size, u32 *val)
 {
 	struct pci_controller *hose = pci_bus_to_host(bus);
-	struct pnv_phb *phb = hose->private_data;
+	struct pnv_phb *phb;
 	u32 bdfn = (((uint64_t)bus->number) << 8) | devfn;
 	s64 rc;
 
 	if (hose == NULL)
 		return PCIBIOS_DEVICE_NOT_FOUND;
+	phb = hose->private_data;
 
 	switch (size) {
 	case 1: {
@@ -331,11 +332,12 @@ static int pnv_pci_write_config(struct pci_bus *bus,
 				int where, int size, u32 val)
 {
 	struct pci_controller *hose = pci_bus_to_host(bus);
-	struct pnv_phb *phb = hose->private_data;
+	struct pnv_phb *phb;
 	u32 bdfn = (((uint64_t)bus->number) << 8) | devfn;
 
 	if (hose == NULL)
 		return PCIBIOS_DEVICE_NOT_FOUND;
+	phb = hose->private_data;
 
 	cfg_dbg("pnv_pci_write_config bus: %x devfn: %x +%x/%x -> %08x\n",
 		bus->number, devfn, where, size, val);

