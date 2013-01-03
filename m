Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754550Ab3ACXSx (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Jan 2013 18:18:53 -0500
Received: from mail-ea0-f175.google.com ([209.85.215.175]:51939 "EHLO
	mail-ea0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753852Ab3ACXSv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Jan 2013 18:18:51 -0500
Message-ID: <50E611D5.5040909@gmail.com>
Date: Fri, 04 Jan 2013 00:18:45 +0100
From: Sylwester Nawrocki <sylvester.nawrocki@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:11.0) Gecko/20120412 Thunderbird/11.0.1
MIME-Version: 1.0
To: Cho KyongHo <pullip.cho@samsung.com>
CC: "'Linux ARM Kernel'" <linux-arm-kernel@lists.infradead.org>,
        "'Linux IOMMU'" <iommu@lists.linux-foundation.org>,
        "'Linux Kernel'" <linux-kernel@vger.kernel.org>,
        "'Linux Samsung SOC'" <linux-samsung-soc@vger.kernel.org>,
        "'Hyunwoong Kim'" <khw0178.kim@samsung.com>,
        "'Joerg Roedel'" <joro@8bytes.org>,
        "'Kukjin Kim'" <kgene.kim@samsung.com>,
        "'Prathyush'" <prathyush.k@samsung.com>,
        "'Rahul Sharma'" <rahul.sharma@samsung.com>,
        "'Subash Patel'" <subash.ramaswamy@linaro.org>,
        Marek Szyprowski <m.szyprowski@samsung.com>,
        Tomasz Figa <t.figa@samsung.com>,
        devicetree-discuss <devicetree-discuss@lists.ozlabs.org>
Subject: Re: [PATCH v6 00/12] iommu/exynos: Fixes and Enhancements of System
 MMU driver with DT
References: <003301cde30b$c584c2d0$508e4870$%cho@samsung.com>
In-Reply-To: <003301cde30b$c584c2d0$508e4870$%cho@samsung.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

Cc: devicetree-discuss <devicetree-discuss@lists.ozlabs.org>

On 12/26/2012 02:53 AM, Cho KyongHo wrote:
> notice: v6 patch-set is rebased on next/iommu-exynos branch of
> linux-samsung.git.  This patch-set does not include 2 patches (05 and 06
> patches in v5 patch-se) because they alread exist already in the branch.
>
> The current exynos-iommu(System MMU) driver does not work autonomously
> since it is lack of support for power management of peripheral blocks.
> For example, MFC device driver must ensure that its System MMU is disabled
> before MFC block is power-down not to invalidate IOTLB in the System MMU
> when I/O memory mapping is changed. Because A System MMU is resides in the
> same H/W block, access to control registers of System MMU while the H/W
> block is turned off must be prohibited.
>
> This set of changes solves the above problem with setting each System MMUs
> as the parent of the device which owns the System MMU to recieve the
> information when the device is turned off or turned on.

I intend to make Exynos4412 FIMC-LITEn (Exynos5 CAMIFn) devices child
devices of the FIMC-IS (camera ISP) platform device. This patch reflects
that: http://patchwork.linuxtv.org/patch/16046

This is required since AFAIK FIMC-LITE depends on clocks from FIMC-IS.
By setting fimc-is device as the parent fimc-lite's dependency on it is
resolved without any hacks between these drivers.

Then how this tree will look like after your sysmmu related re-parenting:

          fimc-is
         /      \
  fimc-lite0    fimc-lite1

?

> Another big change to the driver is the support for devicetree.
> The bindings for System MMU is described in
> Documentation/devicetree/bindings/arm/samsung/system-mmu.txt

Yes, and there is no patch adding this file in this series. Let me paste
it here:

 From 88987ff5b77acc7211b9f537a6ef6ea38e3efdd0 Mon Sep 17 00:00:00 2001
From: KyongHo Cho <pullip.cho@samsung.com>
Date: Tue, 11 Dec 2012 14:06:25 +0900
Subject: [PATCH] ARM: EXYNOS: add System MMU definition to DT

This commit adds System MMU nodes to DT of Exynos SoCs.

Signed-off-by: KyongHo Cho <pullip.cho@samsung.com>
Signed-off-by: Kukjin Kim <kgene.kim@samsung.com>
---
  .../devicetree/bindings/arm/exynos/system-mmu.txt  |   86 ++++++++++++
  arch/arm/boot/dts/exynos4210.dtsi                  |   96 +++++++++++++
  arch/arm/boot/dts/exynos4x12.dtsi                  |  124 
+++++++++++++++++
  arch/arm/boot/dts/exynos5250.dtsi                  |  147 
+++++++++++++++++++-
  4 files changed, 451 insertions(+), 2 deletions(-)
  create mode 100644 
Documentation/devicetree/bindings/arm/exynos/system-mmu.txt

diff --git a/Documentation/devicetree/bindings/arm/exynos/system-mmu.txt 
b/Documentation/devicetree/bindings/arm/exynos/system-mmu.txt
new file mode 100644
index 0000000..b33d682
--- /dev/null
+++ b/Documentation/devicetree/bindings/arm/exynos/system-mmu.txt
@@ -0,0 +1,86 @@
+* Samsung Exynos System MMU
+
+Samsung's Exynos architecture includes System MMU that enables scattered
+physical chunks to be visible as a contiguous region to DMA-capabile 
peripheral
+devices like MFC, FIMC, FIMD, GScaler, FIMC-IS and so forth.
+
+System MMU is a sort of IOMMU and support identical translation table 
format to
+ARMv7 translation tables with minimum set of page properties including 
access
+permissions, shareability and security protection. In addition System 
MMU has
+another capabilities like L2 TLB or block-fetch buffers to minimize 
translation
+latency
+
+Each System MMU is included in the H/W block of a peripheral device. 
Thus, it is
+important to specify that a System MMU is dedicated to which peripheral 
device
+before using System MMU. System initialization must specify the 
relationships
+between a System MMU and a peripheral device that owns the System MMU.
+
+Some device drivers may control several peripheral devices with a 
single device
+descriptor like MFC. Since handling a System MMU with IOMMU API requires a
+device descriptor that needs the System MMU, it is best to combine the 
System
+MMUs of the peripheral devices and control them with a single System 
MMU device
+descriptor. If it is unable to combine them into a single device 
descriptor,
+they can be linked with each other by the means of device.parent 
relationship.
+
+Required properties:
+- compatible: Should be "samsung,exynos-sysmmu".
+- reg: Tuples of base address and size of System MMU registers. The 
number of
+       tuples can be more than one if two or more System MMUs are 
controlled
+       by a single device descriptor.
+- interrupt-parent: The phandle of the interrupt controller of System MMU
+- interrupts: Tuples of numbers that indicates the interrupt source. The
+              number of elements in the tuple is dependent upon
+             'interrupt-parent' property. The number of tuples in this 
property
+             must be the same with 'reg' property.
+
+Optional properties:
+- mmuname: Strings of the name of System MMU for debugging purpose. The 
number
+          of strings must be the same with the number of tuples in 'reg'
+          property.

As commented on previous patch, this isn't something that belongs here.
But for debugging you could probably retrieve this from the node name ?

+- mmu-master: phandle to the device node that owns System MMU. Only the 
device
+          that is specified whith this property can control System MMU with
+          IOMMU API.
+
+Examples:
+
+MFC has 2 System MMUs for each port that MFC is attached. Thus it seems 
natural
+to define 2 System MMUs for each port of the MFC:
+
+	sysmmu-mfc-l {
+		mmuname = "mfc_l";
+		reg = <0x11210000 0x1000>;
+		compatible = "samsung,exynos-sysmmu";
+		interrupt-parent = <&combiner>;
+		interrupts = <8 5>;
+		mmu-master = <&mfc>;
+	};
+
+	sysmmu-mfc-r {
+		mmuname = "mfc_r";
+		reg = <0x11200000 0x1000>;
+		compatible = "samsung,exynos-sysmmu";
+		interrupt-parent = <&combiner>;
+		interrupts = <6 2>;
+		mmu-master = <&mfc>;
+	};
+
+Actually, MFC device driver requires sub-devices that represents each 
port and
+above 'mmu-master' properties of sysmmu-mfc-l and sysmmu-mfc-r have the 
phandles
+to those sub-devices.

I find this sentence really difficult to parse. This documentation 
should talk
about how the device is designed and represented, rather than about its 
driver.

+However, it is also a good idea that treats the above System MMUs as 
one System
+MMU because those System MMUs are actually required by the MFC device:
+
+	sysmmu-mfc {
+		mmuname = "mfc_l", "mfc_r";
+		reg = <0x11210000 0x1000
+		       0x11200000 0x1000>;
+		compatible = "samsung,exynos-sysmmu";
+		interrupt-parent = <&combiner>;
+		interrupts = <8 5
+			      6 2>;
+		mmu-master = <&mfc>;
+	};
+
+If System MMU of MFC is defined like the above, the number of elements 
and the
+order of list in 'mmuname', 'reg' and 'interrupts' must be the same.
diff --git a/arch/arm/boot/dts/exynos4210.dtsi 
b/arch/arm/boot/dts/exynos4210.dtsi
index e31bfc4..1c134b2 100644
--- a/arch/arm/boot/dts/exynos4210.dtsi
+++ b/arch/arm/boot/dts/exynos4210.dtsi
@@ -76,4 +76,100 @@
  		reg = <0x100C0000 0x100>;
  		interrupts = <2 4>;
  	};
+
+	sysmmu-mfcL {

This capitalization looks weird. How about just making it sysmmu-mfc-l ?

+		mmuname = "mfc_l";
+		reg = <0x13620000 0x1000>;
+		compatible = "samsung,exynos-sysmmu";
+		interrupt-parent = <&combiner>;
+		interrupts = <5 5>;
+	};
+
+	sysmmu-mfcR {

and sysmmu-mfc-r ?

Hmm, you actually have it defined this way for exynos5250...

+		mmuname = "mfc_r";
+		reg = <0x13630000 0x1000>;
+		compatible = "samsung,exynos-sysmmu";
+		interrupt-parent = <&combiner>;
+		interrupts = <5 6>;
+	};
+
+	sysmmu-tv {
+		mmuname = "tv";
+		reg = <0x13E20000 0x1000>;
+		compatible = "samsung,exynos-sysmmu";
+		interrupt-parent = <&combiner>;
+		interrupts = <5 4>;
+	};
+
+	sysmmu-fimc0 {
+		mmuname = "fimc0";
+		reg = <0x11A20000 0x1000>;
+		compatible = "samsung,exynos-sysmmu";
+		interrupt-parent = <&combiner>;
+		interrupts = <4 2>;
+	};
+
+	sysmmu-fimc1 {
+		mmuname = "fimc1";
+		reg = <0x11A30000 0x1000>;
+		compatible = "samsung,exynos-sysmmu";
+		interrupt-parent = <&combiner>;
+		interrupts = <4 3>;
+	};
+
+	sysmmu-fimc2 {
+		mmuname = "fimc2";
+		reg = <0x11A40000 0x1000>;
+		compatible = "samsung,exynos-sysmmu";
+		interrupt-parent = <&combiner>;
+		interrupts = <4 4>;
+	};
+
+	sysmmu-fimc3 {
+		mmuname = "fimc3";
+		reg = <0x11A50000 0x1000>;
+		compatible = "samsung,exynos-sysmmu";
+		interrupt-parent = <&combiner>;
+		interrupts = <4 5>;
+	};
+
+	sysmmu-jpeg {
+		mmuname = "jpeg";
+		reg = <0x11A60000 0x1000>;
+		compatible = "samsung,exynos-sysmmu";
+		interrupt-parent = <&combiner>;
+		interrupts = <4 6>;
+	};
+
+	sysmmu-g2d {
+		mmuname = "g2d";
+		reg = <0x12A20000 0x1000>;
+		compatible = "samsung,exynos-sysmmu";
+		interrupt-parent = <&combiner>;
+		interrupts = <4 7>;
+	};
+
+	sysmmu-rotator {
+		mmuname = "rotator";
+		reg = <0x12A30000 0x1000>;
+		compatible = "samsung,exynos-sysmmu";
+		interrupt-parent = <&combiner>;
+		interrupts = <5 0>;
+	};
+
+	sysmmu-fimd0 {
+		mmuname = "fimd0";
+		reg = <0x11E20000 0x1000>;
+		compatible = "samsung,exynos-sysmmu";
+		interrupt-parent = <&combiner>;
+		interrupts = <5 2>;
+	};
+
+	sysmmu-fimd1 {
+		mmuname = "fimd1";
+		reg = <0x12220000 0x1000>;
+		compatible = "samsung,exynos-sysmmu";
+		interrupt-parent = <&combiner>;
+		interrupts = <5 3>;
+	};
  };
diff --git a/arch/arm/boot/dts/exynos4x12.dtsi 
b/arch/arm/boot/dts/exynos4x12.dtsi
index 179a62e..0c6d001 100644
--- a/arch/arm/boot/dts/exynos4x12.dtsi
+++ b/arch/arm/boot/dts/exynos4x12.dtsi
@@ -66,4 +66,128 @@
  		reg = <0x106E0000 0x1000>;
  		interrupts = <0 72 0>;
  	};
+
+	sysmmu-mfcL {
+		mmuname = "mfc_l";
+		reg = <0x13620000 0x1000>;
+		compatible = "samsung,exynos-sysmmu";
+		interrupt-parent = <&combiner>;
+		interrupts = <5 5>;
+	};
+
+	sysmmu-mfcR {
+		mmuname = "mfc_r";
+		reg = <0x13630000 0x1000>;
+		compatible = "samsung,exynos-sysmmu";
+		interrupt-parent = <&combiner>;
+		interrupts = <5 6>;
+	};
+
+	sysmmu-tv {
+		mmuname = "tv";
+		reg = <0x13E20000 0x1000>;
+		compatible = "samsung,exynos-sysmmu";
+		interrupt-parent = <&combiner>;
+		interrupts = <5 4>;
+	};
+
+	sysmmu-fimc0 {
+		mmuname = "fimc0";
+		reg = <0x11A20000 0x1000>;
+		compatible = "samsung,exynos-sysmmu";
+		interrupt-parent = <&combiner>;
+		interrupts = <4 2>;
+	};
+
+	sysmmu-fimc1 {
+		mmuname = "fimc1";
+		reg = <0x11A30000 0x1000>;
+		compatible = "samsung,exynos-sysmmu";
+		interrupt-parent = <&combiner>;
+		interrupts = <4 3>;
+	};
+
+	sysmmu-fimc2 {
+		mmuname = "fimc2";
+		reg = <0x11A40000 0x1000>;
+		compatible = "samsung,exynos-sysmmu";
+		interrupt-parent = <&combiner>;
+		interrupts = <4 4>;
+	};
+
+	sysmmu-fimc3 {
+		mmuname = "fimc3";
+		reg = <0x11A50000 0x1000>;
+		compatible = "samsung,exynos-sysmmu";
+		interrupt-parent = <&combiner>;
+		interrupts = <4 5>;
+	};
+
+	sysmmu-jpeg {
+		mmuname = "jpeg";
+		reg = <0x11A60000 0x1000>;
+		compatible = "samsung,exynos-sysmmu";
+		interrupt-parent = <&combiner>;
+		interrupts = <4 6>;
+	};
+
+	sysmmu-g2d {
+		mmuname = "g2d";
+		reg = <0x10A40000 0x1000>;
+		compatible = "samsung,exynos-sysmmu";
+		interrupt-parent = <&combiner>;
+		interrupts = <4 7>;
+	};
+
+	sysmmu-rotator {
+		mmuname = "rotator";
+		reg = <0x12A30000 0x1000>;
+		compatible = "samsung,exynos-sysmmu";
+		interrupt-parent = <&combiner>;
+		interrupts = <5 0>;
+	};
+
+	sysmmu-fimd0 {
+		mmuname = "fimd0";
+		reg = <0x11E20000 0x1000>;
+		compatible = "samsung,exynos-sysmmu";
+		interrupt-parent = <&combiner>;
+		interrupts = <5 2>;
+	};
+
+	sysmmu-is0 {
+		mmuname = "isp", "drc", "fd";
+		reg = < 0x12260000 0x1000
+			0x12270000 0x1000
+			0x122A0000 0x1000 >;
+		compatible = "samsung,exynos-sysmmu";
+		interrupt-parent = <&combiner>;
+		interrupts = <  16 2
+				16 3
+				16 4 >;
+	};
+
+	sysmmu-is1 {
+		mmuname = "ispcpu";
+		reg = <0x122B0000 0x1000>;
+		compatible = "samsung,exynos-sysmmu";
+		interrupt-parent = <&combiner>;
+		interrupts = <16 5>;
+	};
+
+	sysmmu-flite0 {
+		mmuname = "fimc-lite0";
+		reg = <0x123B0000 0x1000>;
+		compatible = "samsung,exynos-sysmmu";
+		interrupt-parent = <&combiner>;
+		interrupts = <16 0>;
+	};
+
+	sysmmu-flite1 {
+		mmuname = "fimc-lite1";
+		reg = <0x123C0000 0x1000>;
+		compatible = "samsung,exynos-sysmmu";
+		interrupt-parent = <&combiner>;
+		interrupts = <16 1>;
+	};
  };
diff --git a/arch/arm/boot/dts/exynos5250.dtsi 
b/arch/arm/boot/dts/exynos5250.dtsi
index 2e3b6ef..2ff6d78 100644
--- a/arch/arm/boot/dts/exynos5250.dtsi
+++ b/arch/arm/boot/dts/exynos5250.dtsi
@@ -75,7 +75,7 @@
  		interrupts = <0 42 0>;
  	};

-	codec@11000000 {
+	mfc: codec@11000000 {
  		compatible = "samsung,mfc-v6";
  		reg = <0x11000000 0x10000>;
  		interrupts = <0 96 0>;
@@ -578,9 +578,152 @@
  		interrupts = <0 95 0>;
  	};

-	mixer {
+	mixer: mixer {
  		compatible = "samsung,exynos5-mixer";
  		reg = <0x14450000 0x10000>;
  		interrupts = <0 94 0>;
  	};
+
+	sysmmu-mfc-l {
+		mmuname = "mfc_l";
+		reg = <0x11210000 0x1000>;
+		compatible = "samsung,exynos-sysmmu";
+		interrupt-parent = <&combiner>;
+		interrupts = <8 5>;
+		mmu-master = <&mfc>;
+	};
+
+	sysmmu-mfc-r {
+		mmuname = "mfc_r";
+		reg = <0x11200000 0x1000>;
+		compatible = "samsung,exynos-sysmmu";
+		interrupt-parent = <&combiner>;
+		interrupts = <6 2>;
+		mmu-master = <&mfc>;
+	};
+
+	sysmmu-tv {
+		mmuname = "tv";
+		reg = <0x14650000 0x1000>;
+		compatible = "samsung,exynos-sysmmu";
+		interrupt-parent = <&combiner>;
+		interrupts = <7 4>;
+		mmu-master = <&mixer>;
+	};
+
+	sysmmu-gsc0 {
+		mmuname = "gsc0";
+		reg = <0x13E80000 0x1000>;
+		compatible = "samsung,exynos-sysmmu";
+		interrupt-parent = <&combiner>;
+		interrupts = <2 0>;
+		mmu-master = <&gsc_0>;
+	};
+
+	sysmmu-gsc1 {
+		mmuname = "gsc1";
+		reg = <0x13E90000 0x1000>;
+		compatible = "samsung,exynos-sysmmu";
+		interrupt-parent = <&combiner>;
+		interrupts = <2 2>;
+		mmu-master = <&gsc_1>;
+	};
+
+	sysmmu-gsc2 {
+		mmuname = "gsc2";
+		reg = <0x13EA0000 0x1000>;
+		compatible = "samsung,exynos-sysmmu";
+		interrupt-parent = <&combiner>;
+		interrupts = <2 4>;
+		mmu-master = <&gsc_2>;
+	};
+
+	sysmmu-gsc3 {
+		mmuname = "gsc3";
+		reg = <0x13EB0000 0x1000>;
+		compatible = "samsung,exynos-sysmmu";
+		interrupt-parent = <&combiner>;
+		interrupts = <2 6>;
+		mmu-master = <&gsc_3>;
+	};
+
+	sysmmu-fimd1 {
+		mmuname = "fimd1";
+		reg = <0x14640000 0x1000>;
+		compatible = "samsung,exynos-sysmmu";
+		interrupt-parent = <&combiner>;
+		interrupts = <3 2>;
+	};
+
+	sysmmu-rotator {
+		mmuname = "rotator";
+		reg = <0x11D40000 0x1000>;
+		compatible = "samsung,exynos-sysmmu";
+		interrupt-parent = <&combiner>;
+		interrupts = <4 0>;
+	};
+
+	sysmmu-is0 {
+		mmuname = "isp", "drc", "scalerc", "scalerp", "fd", "mcu";
+		reg = < 0x13260000 0x1000
+			0x13270000 0x1000
+			0x13280000 0x1000
+			0x13290000 0x1000
+			0x132A0000 0x1000
+			0x132B0000 0x1000 >;
+		compatible = "samsung,exynos-sysmmu";
+		interrupt-parent = <&combiner>;
+		interrupts = <  10 6
+				11 6
+				 5 2
+				 3 6
+				 5 0
+				 5 4 >;

I believe this should be

		interrupts = <10 6>, <11 6>, <5 2>,
			     <3 6>, <5 0>, <5 4>;

+	};
+
+	sysmmu-is1 {
+		mmuname = "odc", "dis0", "dis1", "3dnr";
+		reg = < 0x132C0000 0x1000
+			0x132D0000 0x1000
+			0x132E0000 0x1000
+			0x132F0000 0x1000 >;
+		compatible = "samsung,exynos-sysmmu";
+		interrupt-parent = <&combiner>;
+		interrupts = <  11 0
+				10 4
+				 9 4
+				 5 6 >;

Ditto.

+	};
+
+	sysmmu-2d {
+		mmuname = "2d";
+		reg = <0x10A60000 0x1000>;
+		compatible = "samsung,exynos-sysmmu";
+		interrupt-parent = <&combiner>;
+		interrupts = <24 5>;
+	};
+
+	sysmmu-jpeg {
+		mmuname = "jpeg";
+		reg = <0x11F20000 0x1000>;
+		compatible = "samsung,exynos-sysmmu";
+		interrupt-parent = <&combiner>;
+		interrupts = <4 2>;
+	};
+
+	sysmmu-flite0 {
+		mmuname = "flite0";
+		reg = <0x13C40000 0x1000>;
+		compatible = "samsung,exynos-sysmmu";
+		interrupt-parent = <&combiner>;
+		interrupts = <3 4>;
+	};
+
+	sysmmu-flite1 {
+		mmuname = "flite1";
+		reg = <0x13C50000 0x1000>;
+		compatible = "samsung,exynos-sysmmu";
+		interrupt-parent = <&combiner>;
+		interrupts = <24 1>;
+	};
  };

--

Thanks,
Sylwester
