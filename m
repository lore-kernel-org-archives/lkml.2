Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756183Ab1AaUUi (ORCPT <rfc822;w@1wt.eu>);
	Mon, 31 Jan 2011 15:20:38 -0500
Received: from mail-yw0-f46.google.com ([209.85.213.46]:47486 "EHLO
	mail-yw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753898Ab1AaUUg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 31 Jan 2011 15:20:36 -0500
Subject: [PATCH v3 3/3 RFC] dt: add documentation of ARM dt boot interface
To: devicetree-discuss@lists.ozlabs.org, linuxppc-dev@lists.ozlabs.org,
        linux-kernel@vger.kernel.org
From: Grant Likely <grant.likely@secretlab.ca>
Cc: benh@kernel.crashing.org, jwboyer@linux.vnet.ibm.com, sam@ravnborg.org
Date: Mon, 31 Jan 2011 13:20:30 -0700
Message-ID: <20110131201954.12434.22910.stgit@localhost6.localdomain6>
In-Reply-To: <20110131201941.12434.11171.stgit@localhost6.localdomain6>
References: <20110131201941.12434.11171.stgit@localhost6.localdomain6>
User-Agent: StGit/0.15
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

v3: added details to Documentation/arm/Booting

This is RFC only.  I'm not asking for this to be merged until arm-dt
support is accepted in mainline.

Signed-off-by: Grant Likely <grant.likely@secretlab.ca>
---
 Documentation/arm/Booting                       |   33 +++++++++++++++++--
 Documentation/devicetree/booting-without-of.txt |   40 +++++++++++++++++++++++
 2 files changed, 69 insertions(+), 4 deletions(-)

diff --git a/Documentation/arm/Booting b/Documentation/arm/Booting
index 7685029..4e686a2 100644
--- a/Documentation/arm/Booting
+++ b/Documentation/arm/Booting
@@ -65,13 +65,19 @@ looks at the connected hardware is beyond the scope of this document.
 The boot loader must ultimately be able to provide a MACH_TYPE_xxx
 value to the kernel. (see linux/arch/arm/tools/mach-types).
 
-
-4. Setup the kernel tagged list
--------------------------------
+4. Setup boot data
+------------------
 
 Existing boot loaders:		OPTIONAL, HIGHLY RECOMMENDED
 New boot loaders:		MANDATORY
 
+The boot loader must provide either a tagged list or a dtb image for
+passing configuration data to the kernel.  The physical address of the
+boot data is passed to the kernel in register r2.
+
+4a. Setup the kernel tagged list
+--------------------------------
+
 The boot loader must create and initialise the kernel tagged list.
 A valid tagged list starts with ATAG_CORE and ends with ATAG_NONE.
 The ATAG_CORE tag may or may not be empty.  An empty ATAG_CORE tag
@@ -101,6 +107,24 @@ The tagged list must be placed in a region of memory where neither
 the kernel decompressor nor initrd 'bootp' program will overwrite
 it.  The recommended placement is in the first 16KiB of RAM.
 
+4b. Setup the device tree
+-------------------------
+
+The boot loader must load a device tree image (dtb) into system ram
+at a 64bit aligned address and initialize it with the boot data.  The
+dtb format is documented in Documentation/devicetree/booting-without-of.txt.
+The kernel will look for the dtb magic value of 0xd00dfeed at the dtb
+physical address to determine if a dtb has been passed instead of a
+tagged list.
+
+The boot loader must pass at a minimum the size and location of the
+system memory, and the root filesystem location.  The dtb must be
+placed in a region of memory where the kernel decompressor will not
+overwrite it.  The recommended placement is in the first 16KiB of RAM
+with the caveat that it may not be located at physical address 0 since
+the kernel interprets a value of 0 in r2 to mean neither a tagged list
+nor a dtb were passed.
+
 5. Calling the kernel image
 ---------------------------
 
@@ -125,7 +149,8 @@ In either case, the following conditions must be met:
 - CPU register settings
   r0 = 0,
   r1 = machine type number discovered in (3) above.
-  r2 = physical address of tagged list in system RAM.
+  r2 = physical address of tagged list in system RAM, or
+       physical address of device tree block (dtb) in system RAM
 
 - CPU mode
   All forms of interrupts must be disabled (IRQs and FIQs)
diff --git a/Documentation/devicetree/booting-without-of.txt b/Documentation/devicetree/booting-without-of.txt
index 28b1c9d..9381a14 100644
--- a/Documentation/devicetree/booting-without-of.txt
+++ b/Documentation/devicetree/booting-without-of.txt
@@ -13,6 +13,7 @@ Table of Contents
 
   I - Introduction
     1) Entry point for arch/powerpc
+    2) Entry point for arch/arm
 
   II - The DT block format
     1) Header
@@ -225,6 +226,45 @@ it with special cases.
   cannot support both configurations with Book E and configurations
   with classic Powerpc architectures.
 
+2) Entry point for arch/arm
+---------------------------
+
+   There is one single entry point to the kernel, at the start
+   of the kernel image. That entry point supports two calling
+   conventions.  A summary of the interface is described here.  A full
+   description of the boot requirements is documented in
+   Documentation/arm/Booting
+
+        a) ATAGS interface.  Minimal information is passed from firmware
+        to the kernel with a tagged list of predefined parameters.
+
+                r0 : 0
+
+                r1 : Machine type number
+
+                r2 : Physical address of tagged list in system RAM
+
+        b) Entry with a flattened device-tree block.  Firmware loads the
+        physical address of the flattened device tree block (dtb) into r2,
+        r1 is not used, but it is considered good practise to use a valid
+        machine number as described in Documentation/arm/Booting.
+
+                r0 : 0
+
+                r1 : Valid machine type number.  When using a device tree,
+                a single machine type number will often be assigned to
+                represent a class or family of SoCs.
+
+                r2 : physical pointer to the device-tree block
+                (defined in chapter II) in RAM.  Device tree can be located
+                anywhere in system RAM, but it should be aligned on a 32 bit
+                boundary.
+
+   The kernel will differentiate between ATAGS and device tree booting by
+   reading the memory pointed to by r1 and looking for either the flattened
+   device tree block magic value (0xd00dfeed) or the ATAG_CORE value at
+   offset 0x4 from r2 (0x54410001).
+
 
 II - The DT block format
 ========================

