Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755858Ab1LVUUi (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Dec 2011 15:20:38 -0500
Received: from border.exmeritus.com ([70.167.241.26]:32973 "EHLO
	border.exmeritus.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755573Ab1LVUUe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Dec 2011 15:20:34 -0500
From: Kyle Moffett <Kyle.D.Moffett@boeing.com>
To: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Cc: linuxppc-dev@lists.ozlabs.org, devicetree-discuss@lists.ozlabs.org,
        Kyle Moffett <Kyle.D.Moffett@boeing.com>,
        Grant Likely <grant.likely@secretlab.ca>,
        Rob Herring <rob.herring@calxeda.com>,
        Randy Dunlap <rdunlap@xenotime.net>, Paul Mackerras <paulus@samba.org>,
        Kumar Gala <galak@kernel.crashing.org>,
        Lucas De Marchi <lucas.demarchi@profusion.mobi>,
        Stuart Yoder <stuart.yoder@freescale.com>,
        Josh Boyer <jwboyer@linux.vnet.ibm.com>,
        Milton Miller <miltonm@bga.com>, Scott Wood <scottwood@freescale.com>,
        linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH 3/6] fsl/mpic: Create and document the "single-cpu-affinity" device-tree flag
Date: Thu, 22 Dec 2011 15:19:11 -0500
Message-Id: <1324585155-13453-4-git-send-email-Kyle.D.Moffett@boeing.com>
X-Mailer: git-send-email 1.7.7.3
In-Reply-To: <1324585155-13453-1-git-send-email-Kyle.D.Moffett@boeing.com>
References: <1324585155-13453-1-git-send-email-Kyle.D.Moffett@boeing.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The Freescale MPIC (and perhaps others in the future) is incapable of
routing non-IPI interrupts to more than once CPU at a time.  Currently
all of the Freescale boards msut pass the MPIC_SINGLE_DEST_CPU flag to
mpic_alloc(), but that information should really be present in the
device-tree.

Older board code can't rely on the device-tree having the property set,
but newer platforms won't need it manually specified in the code.

Signed-off-by: Kyle Moffett <Kyle.D.Moffett@boeing.com>
---
 .../devicetree/bindings/powerpc/fsl/mpic.txt       |    6 ++++++
 arch/powerpc/boot/dts/fsl/pq3-mpic.dtsi            |    1 +
 arch/powerpc/sysdev/mpic.c                         |    8 +++++---
 3 files changed, 12 insertions(+), 3 deletions(-)

diff --git a/Documentation/devicetree/bindings/powerpc/fsl/mpic.txt b/Documentation/devicetree/bindings/powerpc/fsl/mpic.txt
index ebafba2..b393ccf 100644
--- a/Documentation/devicetree/bindings/powerpc/fsl/mpic.txt
+++ b/Documentation/devicetree/bindings/powerpc/fsl/mpic.txt
@@ -64,6 +64,12 @@ PROPERTIES
           device-trees omit this property on MPIC nodes even when the MPIC is
           in fact big-endian, so certain boards override this property.
 
+  - single-cpu-affinity
+      Usage: optional
+      Value type: <empty>
+          If present the MPIC will be assumed to only be able to route
+          non-IPI interrupts to a single CPU at a time (EG: Freescale MPIC).
+
 INTERRUPT SPECIFIER DEFINITION
 
   Interrupt specifiers consists of 4 cells encoded as
diff --git a/arch/powerpc/boot/dts/fsl/pq3-mpic.dtsi b/arch/powerpc/boot/dts/fsl/pq3-mpic.dtsi
index 47f2b67..658bd81 100644
--- a/arch/powerpc/boot/dts/fsl/pq3-mpic.dtsi
+++ b/arch/powerpc/boot/dts/fsl/pq3-mpic.dtsi
@@ -40,6 +40,7 @@ mpic: pic@40000 {
 	compatible = "fsl,mpic";
 	device_type = "open-pic";
 	big-endian;
+	single-cpu-affinity;
 };
 
 timer@41100 {
diff --git a/arch/powerpc/sysdev/mpic.c b/arch/powerpc/sysdev/mpic.c
index 9dd7f76..c297a52 100644
--- a/arch/powerpc/sysdev/mpic.c
+++ b/arch/powerpc/sysdev/mpic.c
@@ -1183,11 +1183,13 @@ struct mpic * __init mpic_alloc(struct device_node *node,
 	}
 
 	/* Read extra device-tree properties into the flags variable */
-	if (of_get_property(mpic->node, "big-endian", NULL))
+	if (of_get_property(node, "big-endian", NULL))
 		flags |= MPIC_BIG_ENDIAN;
-	if (of_get_property(mpic->node, "pic-no-reset", NULL))
+	if (of_get_property(node, "pic-no-reset", NULL))
 		flags |= MPIC_NO_RESET;
-	if (of_device_is_compatible(mpic->node, "fsl,mpic"))
+	if (of_get_property(node, "single-cpu-affinity", NULL))
+		flags |= MPIC_SINGLE_DEST_CPU;
+	if (of_device_is_compatible(node, "fsl,mpic"))
 		flags |= MPIC_FSL;
 
 	mpic = kzalloc(sizeof(struct mpic), GFP_KERNEL);
-- 
1.7.7.3

