Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757579Ab0DWOJt (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Apr 2010 10:09:49 -0400
Received: from s15228384.onlinehome-server.info ([87.106.30.177]:36537 "EHLO
	mail.x86-64.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753203Ab0DWOJr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Apr 2010 10:09:47 -0400
Date: Fri, 23 Apr 2010 16:09:27 +0200
From: Borislav Petkov <bp@amd64.org>
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: mingo@elte.hu, tglx@linutronix.de, x86@kernel.org,
       linux-kernel@vger.kernel.org, Frank Arnold <frank.arnold@amd.com>
Subject: Re: [PATCH -v2 0/5] AMD L3 cache index disable fixes for .35
Message-ID: <20100423140927.GA13750@aftab>
References: <1271945222-5283-1-git-send-email-bp@amd64.org>
 <4BD0E869.10402@zytor.com>
 <20100423065016.GA11748@aftab>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100423065016.GA11748@aftab>
Organization: Advanced Micro Devices =?iso-8859-1?Q?GmbH?=
	=?iso-8859-1?Q?=2C_Karl-Hammerschmidt-Str=2E_34=2C_85609_Dornach_bei_M=FC?=
	=?iso-8859-1?Q?nchen=2C_Gesch=E4ftsf=FChrer=3A_Thomas_M=2E_McCoy=2C_Giuli?=
	=?iso-8859-1?Q?ano_Meroni=2C_Andrew_Bowd=2C_Sitz=3A_Dornach=2C_Gemeinde_A?=
	=?iso-8859-1?Q?schheim=2C_Landkreis_M=FCnchen=2C_Registergericht_M=FCnche?=
	=?iso-8859-1?Q?n=2C?= HRB Nr. 43632
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Borislav Petkov <bp@amd64.org>
Date: Fri, Apr 23, 2010 at 08:50:16AM +0200

> > I get compilation failures on tip:x86/cpu with this patchset:
> > 
> > arch/x86/built-in.o: In function `amd_check_l3_disable':
> > intel_cacheinfo.c:(.cpuinit.text+0x412): undefined reference to
> > `num_k8_northbridges'
> > 
> > Both i386 and x86-64 "make allnoconfig".
> 
> Yeah, this has bitten us already several times in the past. allnoconfig
> deselects CONFIG_PCI and num_k8_northbridges is under CONFIG_K8_NB which
> depends on CONFIG_PCI so there you go.
> 
> I'm thinking the k8.c facility is needed more and more for all the
> processor functionality control over the PCI config space so how about
> compile it in unconditionally on AMD? All the k8's and F10h's need
> it and the older ones will have it there but it won't hurt since the
> pci_get_device() won't match any on those.
> 
> allnoconfig build failure is fixed this way, albeit non-functional since
> CONFIG_PCI is off and pci_get_device() returns NULL but in that case
> almost all of the functionality (I guess raw PCI access would still
> work) depending on AMD northbridge PCI devices won't work anyway.
> 
> I'll prep something in a while.

Ok, looking at the k8.o object it is 507 bytes so I don't think
compiling it in would hurt embedded people too much:

   text    data     bss     dec     hex filename
    379     104      24     507     1fb arch/x86/kernel/k8.o

So how about the following? It should apply cleanly on top and it
survived a bunch of randconfigs here so far.

---
From: Borislav Petkov <borislav.petkov@amd.com>
Date: Fri, 23 Apr 2010 14:05:50 +0200
Subject: [PATCH] x86, AMD: Build in Northbridge PCI config devices support

A bunch of facilities in the kernel depend on accessing the processor's
PCI config space in the northbridge for configuration and control. All
K8 and F10h processors have that config space so build in the facility
in k8.c which takes care of enumerating those PCI devices by default on
AMD.

Signed-off-by: Borislav Petkov <borislav.petkov@amd.com>
---
 arch/x86/Kconfig             |    6 +-----
 arch/x86/kernel/Makefile     |    1 -
 arch/x86/kernel/cpu/Makefile |    2 +-
 drivers/char/agp/Kconfig     |    2 +-
 drivers/edac/Kconfig         |    2 +-
 include/linux/pci.h          |    4 ++++
 6 files changed, 8 insertions(+), 9 deletions(-)

diff --git a/arch/x86/Kconfig b/arch/x86/Kconfig
index 9458685..9f80658 100644
--- a/arch/x86/Kconfig
+++ b/arch/x86/Kconfig
@@ -662,7 +662,7 @@ config GART_IOMMU
 	bool "GART IOMMU support" if EMBEDDED
 	default y
 	select SWIOTLB
-	depends on X86_64 && PCI && K8_NB
+	depends on X86_64 && PCI
 	---help---
 	  Support for full DMA access of devices with 32bit memory access only
 	  on systems with more than 3GB. This is usually needed for USB,
@@ -2059,10 +2059,6 @@ config OLPC
 
 endif # X86_32
 
-config K8_NB
-	def_bool y
-	depends on CPU_SUP_AMD && PCI
-
 source "drivers/pcmcia/Kconfig"
 
 source "drivers/pci/hotplug/Kconfig"
diff --git a/arch/x86/kernel/Makefile b/arch/x86/kernel/Makefile
index 4c58352..1afad06 100644
--- a/arch/x86/kernel/Makefile
+++ b/arch/x86/kernel/Makefile
@@ -89,7 +89,6 @@ obj-$(CONFIG_EARLY_PRINTK)	+= early_printk.o
 obj-$(CONFIG_HPET_TIMER) 	+= hpet.o
 obj-$(CONFIG_APB_TIMER)		+= apb_timer.o
 
-obj-$(CONFIG_K8_NB)		+= k8.o
 obj-$(CONFIG_DEBUG_RODATA_TEST)	+= test_rodata.o
 obj-$(CONFIG_DEBUG_NX_TEST)	+= test_nx.o
 
diff --git a/arch/x86/kernel/cpu/Makefile b/arch/x86/kernel/cpu/Makefile
index c202b62..78ef6c0 100644
--- a/arch/x86/kernel/cpu/Makefile
+++ b/arch/x86/kernel/cpu/Makefile
@@ -20,7 +20,7 @@ obj-$(CONFIG_X86_32)	+= bugs.o cmpxchg.o
 obj-$(CONFIG_X86_64)	+= bugs_64.o
 
 obj-$(CONFIG_CPU_SUP_INTEL)		+= intel.o
-obj-$(CONFIG_CPU_SUP_AMD)		+= amd.o
+obj-$(CONFIG_CPU_SUP_AMD)		+= amd.o ../k8.o
 obj-$(CONFIG_CPU_SUP_CYRIX_32)		+= cyrix.o
 obj-$(CONFIG_CPU_SUP_CENTAUR)		+= centaur.o
 obj-$(CONFIG_CPU_SUP_TRANSMETA_32)	+= transmeta.o
diff --git a/drivers/char/agp/Kconfig b/drivers/char/agp/Kconfig
index 4b66c69..2fb3a48 100644
--- a/drivers/char/agp/Kconfig
+++ b/drivers/char/agp/Kconfig
@@ -57,7 +57,7 @@ config AGP_AMD
 
 config AGP_AMD64
 	tristate "AMD Opteron/Athlon64 on-CPU GART support"
-	depends on AGP && X86 && K8_NB
+	depends on AGP && X86
 	help
 	  This option gives you AGP support for the GLX component of
 	  X using the on-CPU northbridge of the AMD Athlon64/Opteron CPUs.
diff --git a/drivers/edac/Kconfig b/drivers/edac/Kconfig
index 55c9c59..0812bbf 100644
--- a/drivers/edac/Kconfig
+++ b/drivers/edac/Kconfig
@@ -71,7 +71,7 @@ config EDAC_MM_EDAC
 
 config EDAC_AMD64
 	tristate "AMD64 (Opteron, Athlon64) K8, F10h, F11h"
-	depends on EDAC_MM_EDAC && K8_NB && X86_64 && PCI && EDAC_DECODE_MCE
+	depends on EDAC_MM_EDAC && X86_64 && PCI && EDAC_DECODE_MCE
 	help
 	  Support for error detection and correction on the AMD 64
 	  Families of Memory Controllers (K8, F10h and F11h)
diff --git a/include/linux/pci.h b/include/linux/pci.h
index a788fa1..150dd65 100644
--- a/include/linux/pci.h
+++ b/include/linux/pci.h
@@ -1199,6 +1199,10 @@ static inline struct pci_dev *pci_get_bus_and_slot(unsigned int bus,
 						unsigned int devfn)
 { return NULL; }
 
+static inline const struct pci_device_id *pci_match_id(const struct pci_device_id *ids,
+						       struct pci_dev *dev)
+{ return NULL; }
+
 #define dev_is_pci(d) (false)
 #define dev_is_pf(d) (false)
 #define dev_num_vf(d) (0)
-- 
1.6.4.4


-- 
Regards/Gruss,
Boris.

--
Advanced Micro Devices, Inc.
Operating Systems Research Center
