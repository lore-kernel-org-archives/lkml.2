Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754879Ab3AHWXx (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Jan 2013 17:23:53 -0500
Received: from mail-ea0-f169.google.com ([209.85.215.169]:59346 "EHLO
	mail-ea0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754294Ab3AHWXu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Jan 2013 17:23:50 -0500
Message-ID: <50EC9C71.7010909@gmail.com>
Date: Tue, 08 Jan 2013 23:23:45 +0100
From: Sylwester Nawrocki <sylvester.nawrocki@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:11.0) Gecko/20120412 Thunderbird/11.0.1
MIME-Version: 1.0
To: KyongHo Cho <pullip.cho@samsung.com>
CC: Kukjin Kim <kgene.kim@samsung.com>, linux-arm-kernel@lists.infradead.org,
        Linux Kernel <linux-kernel@vger.kernel.org>,
        devicetree-discuss <devicetree-discuss@lists.ozlabs.org>,
        Linux IOMMU <iommu@lists.linux-foundation.org>,
        Hyunwoong Kim <khw0178.kim@samsung.com>,
        Rahul Sharma <rahul.sharma@samsung.com>,
        Subash Patel <subash.ramaswamy@linaro.org>,
        Linux Samsung SOC <linux-samsung-soc@vger.kernel.org>,
        Prathyush <prathyush.k@samsung.com>, Tomasz Figa <t.figa@samsung.com>
Subject: Re: [PATCH v6 00/12] iommu/exynos: Fixes and Enhancements of System
 MMU driver with DT
References: <003301cde30b$c584c2d0$508e4870$%cho@samsung.com> <50E611D5.5040909@gmail.com> <CAHQjnOMxYo1D6EgX6ZnGBm_Ufr+u4hgKQzAyQdXJGhiC3XpKdA@mail.gmail.com>
In-Reply-To: <CAHQjnOMxYo1D6EgX6ZnGBm_Ufr+u4hgKQzAyQdXJGhiC3XpKdA@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/07/2013 11:45 AM, KyongHo Cho wrote:
>> > The current exynos-iommu(System MMU) driver does not work autonomously
>> > since it is lack of support for power management of peripheral blocks.
>> > For example, MFC device driver must ensure that its System MMU is
> disabled
>> > before MFC block is power-down not to invalidate IOTLB in the System MMU
>> > when I/O memory mapping is changed. Because A System MMU is resides
> in the
>> > same H/W block, access to control registers of System MMU while the H/W
>> > block is turned off must be prohibited.
>> >
>> > This set of changes solves the above problem with setting each System
> MMUs
>> > as the parent of the device which owns the System MMU to recieve the
>> > information when the device is turned off or turned on.
>>
>>
>>  I intend to make Exynos4412 FIMC-LITEn (Exynos5 CAMIFn) devices child
>>  devices of the FIMC-IS (camera ISP) platform device. This patch reflects
>>  that: http://patchwork.linuxtv.org/patch/16046
>>
>>  This is required since AFAIK FIMC-LITE depends on clocks from FIMC-IS.
>>  By setting fimc-is device as the parent fimc-lite's dependency on it is
>>  resolved without any hacks between these drivers.
>>
>>  Then how this tree will look like after your sysmmu related re-parenting:
>>
>>           fimc-is
>>          /      \
>>   fimc-lite0    fimc-lite1
>>
>>
>>  ?
>
> First of all, I think that clock dependency shuold be resolved with
> setting the parent of clock descriptor of fimc-lite  to the clock
> descriptor of fimc-is.

I'll need to investigate it more, but AFAIU there is more than one clock
for the FIMC-IS device that needs to be enabled before FIMC-LITE can be
used. IOW FIMC-LITE must be activated after FIMC-IS, and deactivated before
FIMC-IS is (runtime) suspended.

So I'm afraid I can't simply alter the clock tree for the sake of the
subsystem dependencies - it's not a one-to-one relation and it doesn't
sound right.

> If you are concerning about power management, it is simply resolved with
> putting fimc-lite to the power domain of fimc-is.

Yes, these devices are already registered to same power domain (ISP).

> The above tree will be changed like below after probing System MMU:
> sysmmu-fimc-is
>              I
>       fimc-is
>
> sysmmu-fimc-lite0
>                I
>        fimc-lite0
>
> sysmmu-fimc-lite1
>               I
>         fimc-lite1

I'm just concerned that this iommu driver would drop previous parent
configurations and introduce its own. There might be other devices for
which this would be harmful. Didn't you consider just moving any existing
device's parent and setting it as iommu's parent, so the tree looks like

          sysmmu-fimc-is	
                |
             fimc-is
         /            \
   sysmmu-fimc-lite0  sysmmu-fimc-lite1
         |              |
   fimc-lite0         fimc-lite1

?

But it's not really much better...

>> > Another big change to the driver is the support for devicetree.
>> > The bindings for System MMU is described in
>> > Documentation/devicetree/bindings/arm/samsung/system-mmu.txt
>>
>>
>>  Yes, and there is no patch adding this file in this series. Let me paste
>>  it here:
>>
>>  From 88987ff5b77acc7211b9f537a6ef6ea38e3efdd0 Mon Sep 17 00:00:00 2001
>>  From: KyongHo Cho <pullip.cho@samsung.com <mailto:pullip.cho@samsung.com>>
>>  Date: Tue, 11 Dec 2012 14:06:25 +0900
>>  Subject: [PATCH] ARM: EXYNOS: add System MMU definition to DT
>>
>>  This commit adds System MMU nodes to DT of Exynos SoCs.
>>
>>  Signed-off-by: KyongHo Cho <pullip.cho@samsung.com
> <mailto:pullip.cho@samsung.com>>
>>  Signed-off-by: Kukjin Kim <kgene.kim@samsung.com
> <mailto:kgene.kim@samsung.com>>
>>  ---
>>   .../devicetree/bindings/arm/exynos/system-mmu.txt  |   86 ++++++++++++
>>   arch/arm/boot/dts/exynos4210.dtsi                  |   96 +++++++++++++
>>   arch/arm/boot/dts/exynos4x12.dtsi                  |  124
> +++++++++++++++++
>>   arch/arm/boot/dts/exynos5250.dtsi                  |  147
> +++++++++++++++++++-
>>   4 files changed, 451 insertions(+), 2 deletions(-)
>>   create mode 100644
> Documentation/devicetree/bindings/arm/exynos/system-mmu.txt
>>
>>  diff --git
> a/Documentation/devicetree/bindings/arm/exynos/system-mmu.txt
> b/Documentation/devicetree/bindings/arm/exynos/system-mmu.txt
>>  new file mode 100644
>>  index 0000000..b33d682
>>  --- /dev/null
>>  +++ b/Documentation/devicetree/bindings/arm/exynos/system-mmu.txt
>>  @@ -0,0 +1,86 @@
>>  +* Samsung Exynos System MMU
>>  +
>>  +Samsung's Exynos architecture includes System MMU that enables scattered
>>  +physical chunks to be visible as a contiguous region to DMA-capabile
> peripheral
>>  +devices like MFC, FIMC, FIMD, GScaler, FIMC-IS and so forth.
>>  +
>>  +System MMU is a sort of IOMMU and support identical translation table
> format to
>>  +ARMv7 translation tables with minimum set of page properties
> including access
>>  +permissions, shareability and security protection. In addition System
> MMU has
>>  +another capabilities like L2 TLB or block-fetch buffers to minimize
> translation
>>  +latency
>>  +
>>  +Each System MMU is included in the H/W block of a peripheral device.
> Thus, it is
>>  +important to specify that a System MMU is dedicated to which
> peripheral device
>>  +before using System MMU. System initialization must specify the
> relationships
>>  +between a System MMU and a peripheral device that owns the System MMU.
>>  +
>>  +Some device drivers may control several peripheral devices with a
> single device
>>  +descriptor like MFC. Since handling a System MMU with IOMMU API
> requires a
>>  +device descriptor that needs the System MMU, it is best to combine
> the System
>>  +MMUs of the peripheral devices and control them with a single System
> MMU device
>>  +descriptor. If it is unable to combine them into a single device
> descriptor,
>>  +they can be linked with each other by the means of device.parent
> relationship.
>>  +
>>  +Required properties:
>>  +- compatible: Should be "samsung,exynos-sysmmu".
>>  +- reg: Tuples of base address and size of System MMU registers. The
> number of
>>  +       tuples can be more than one if two or more System MMUs are
> controlled
>>  +       by a single device descriptor.
>>  +- interrupt-parent: The phandle of the interrupt controller of System MMU
>>  +- interrupts: Tuples of numbers that indicates the interrupt source. The
>>  +              number of elements in the tuple is dependent upon
>>  + 'interrupt-parent' property. The number of tuples in this property
>>  +             must be the same with 'reg' property.
>>  +
>>  +Optional properties:
>>  +- mmuname: Strings of the name of System MMU for debugging purpose.
> The number
>>  +          of strings must be the same with the number of tuples in 'reg'
>>  +          property.
>>
>>  As commented on previous patch, this isn't something that belongs here.
>>  But for debugging you could probably retrieve this from the node name ?
>
> Thank you for good idea. However mmuname is an array of strings,
> actually. Anyway I agree with your opinion that 'mmuname' is not proper
> property of a device node. I will remove it and substitute it with base
> register address of a System MMU.

Ok.

>>  +- mmu-master: phandle to the device node that owns System MMU. Only
> the device
>>  +          that is specified whith this property can control System
> MMU with
>>  +          IOMMU API.
>>  +
>>  +Examples:
>>  +
>>  +MFC has 2 System MMUs for each port that MFC is attached. Thus it
> seems natural
>>  +to define 2 System MMUs for each port of the MFC:

"The video codec (MFC) device has a System MMUs for each port (AXI master).
Thus it seems natural to define a System MMU device node for each port of
the MFC:"

>>  +
>>  +       sysmmu-mfc-l {
>>  +               mmuname = "mfc_l";
>>  +               reg = <0x11210000 0x1000>;
>>  +               compatible = "samsung,exynos-sysmmu";
>>  +               interrupt-parent = <&combiner>;
>>  +               interrupts = <8 5>;
>>  +               mmu-master = <&mfc>;
>>  +       };
>>  +
>>  +       sysmmu-mfc-r {
>>  +               mmuname = "mfc_r";
>>  +               reg = <0x11200000 0x1000>;
>>  +               compatible = "samsung,exynos-sysmmu";
>>  +               interrupt-parent = <&combiner>;
>>  +               interrupts = <6 2>;
>>  +               mmu-master = <&mfc>;
>>  +       };
>>  +
>>  +Actually, MFC device driver requires sub-devices that represents each
> port and
>>  +above 'mmu-master' properties of sysmmu-mfc-l and sysmmu-mfc-r have
> the phandles
>>  +to those sub-devices.
>>
>>  I find this sentence really difficult to parse. This documentation
> should talk
>>  about how the device is designed and represented, rather than about
> its driver.
>>
> OK. I will trying to find another expression easy to understand.  Do you
> have any suggestion?

I'm not a native English speaker, but maybe something like this makes sense:

"The sysmmu-mfc-l, sysmmy-mfc-r nodes represent parts of the MFC device 
which
indicate their 'mmu-master' phandles pointing to the mfc node."

?

>>  +However, it is also a good idea that treats the above System MMUs as

treats -> treat

> one System
>>  +MMU because those System MMUs are actually required by the MFC device:
>>  +
>>  +       sysmmu-mfc {
>>  +               mmuname = "mfc_l", "mfc_r";
>>  +               reg = <0x11210000 0x1000
>>  +                      0x11200000 0x1000>;
>>  +               compatible = "samsung,exynos-sysmmu";
>>  +               interrupt-parent = <&combiner>;
>>  +               interrupts = <8 5
>>  +                             6 2>;

interrupts = <8 5>, <6 2>; ?

>>  +               mmu-master = <&mfc>;
>>  +       };
>>  +
>>  +If System MMU of MFC is defined like the above, the number of
> elements and the
>>  +order of list in 'mmuname', 'reg' and 'interrupts' must be the same.
...
>>  diff --git a/arch/arm/boot/dts/exynos5250.dtsi
> b/arch/arm/boot/dts/exynos5250.dtsi
>>  index 2e3b6ef..2ff6d78 100644
>>  --- a/arch/arm/boot/dts/exynos5250.dtsi
>>  +++ b/arch/arm/boot/dts/exynos5250.dtsi
>>  @@ -75,7 +75,7 @@
>>                  interrupts = <0 42 0>;
>>          };
>>
...
>>  +       sysmmu-is0 {
>>  +               mmuname = "isp", "drc", "scalerc", "scalerp", "fd", "mcu";
>>  +               reg = < 0x13260000 0x1000
>>  +                       0x13270000 0x1000
>>  +                       0x13280000 0x1000
>>  +                       0x13290000 0x1000
>>  +                       0x132A0000 0x1000
>>  +                       0x132B0000 0x1000 >;
>>  +               compatible = "samsung,exynos-sysmmu";
>>  +               interrupt-parent = <&combiner>;
>>  +               interrupts = <  10 6
>>  +                               11 6
>>  +                                5 2
>>  +                                3 6
>>  +                                5 0
>>  +                                5 4 >;
>>
>>  I believe this should be
>>
>>                  interrupts = <10 6>, <11 6>, <5 2>,
>>  <3 6>, <5 0>, <5 4>;
>>
> I found the syntax of array of resources in the specifications of device
> tree. I found that it works correctly.

OK, it seems both conventions are valid. I just found it unusual, since
all interrupt specifiers I've seen for Samsung SoCs use the syntax, where
each interrupt is enclosed in triangular brackets. Maybe it's better to
keep it consistent across all files ?

--

Regards,
Sylwester
