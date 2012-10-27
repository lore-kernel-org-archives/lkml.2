Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758592Ab2J0Nkm (ORCPT <rfc822;w@1wt.eu>);
	Sat, 27 Oct 2012 09:40:42 -0400
Received: from co1ehsobe004.messaging.microsoft.com ([216.32.180.187]:37914
	"EHLO co1outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758245Ab2J0Nkl convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 27 Oct 2012 09:40:41 -0400
X-Forefront-Antispam-Report: CIP:62.221.5.235;KIP:(null);UIP:(null);IPV:NLI;H:xir-gw1;RD:unknown-62-221-5-235.ipspace.xilinx.com;EFVD:NLI
X-SpamScore: 9
X-BigFish: VPS9(zz9371I542M1432I4015Izz1202h1d1ah1d2ahzz8275bhz30ih95h668h839h944hd24hf0ah119dh1220h1288h12a5h12a9h12bdh137ah13b6h1441h1504h1537h153bh1307i1155h)
From: Michal Simek <michal.simek@xilinx.com>
To: Josh Cartwright <josh.cartwright@ni.com>,
        "arm@kernel.org" <arm@kernel.org>, Arnd Bergmann <arnd@arndb.de>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        John Linn <linnj@xilinx.com>, Nick Bowler <nbowler@elliptictech.com>
Subject: RE: [PATCH v4 2/5] zynq: use pl310 device tree bindings
Thread-Topic: [PATCH v4 2/5] zynq: use pl310 device tree bindings
Thread-Index: AQHNsiKyEf7x3HF56EGbAJ454ouRf5fNLKbw
Date: Sat, 27 Oct 2012 13:40:33 +0000
References: <20121024200222.GA6713@beefymiracle.amer.corp.natinst.com>
 <20121024200337.GC6713@beefymiracle.amer.corp.natinst.com>
In-Reply-To: <20121024200337.GC6713@beefymiracle.amer.corp.natinst.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [172.21.26.65]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
X-RCIS-Action: ALLOW
Message-ID: <cd33234d-7122-4c64-a750-d4a6c2fc83bd@CO1EHSMHS004.ehs.local>
X-OriginatorOrg: xilinx.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



> -----Original Message-----
> From: Josh Cartwright [mailto:josh.cartwright@ni.com]
> Sent: Wednesday, October 24, 2012 10:04 PM
> To: arm@kernel.org; Arnd Bergmann
> Cc: linux-kernel@vger.kernel.org; linux-arm-kernel@lists.infradead.org; John
> Linn; Nick Bowler; Michal Simek
> Subject: [PATCH v4 2/5] zynq: use pl310 device tree bindings
>
> The Zynq has a PL310 L2 cache controller.  Convert in-tree uses to using the
> device tree.
>
> Signed-off-by: Josh Cartwright <josh.cartwright@ni.com>
> Cc: John Linn <john.linn@xilinx.com>
> Acked-by: Arnd Bergmann <arnd@arndb.de>
> ---
>  arch/arm/boot/dts/zynq-ep107.dts           | 9 +++++++++
>  arch/arm/mach-zynq/common.c                | 9 +--------
>  arch/arm/mach-zynq/include/mach/zynq_soc.h | 4 ----
>  3 files changed, 10 insertions(+), 12 deletions(-)
>
> diff --git a/arch/arm/boot/dts/zynq-ep107.dts b/arch/arm/boot/dts/zynq-
> ep107.dts
> index 7bfff4a..87204d7 100644
> --- a/arch/arm/boot/dts/zynq-ep107.dts
> +++ b/arch/arm/boot/dts/zynq-ep107.dts
> @@ -44,6 +44,15 @@
>                             <0xF8F00100 0x100>;
>               };
>
> +             L2: cache-controller {
> +                     compatible = "arm,pl310-cache";
> +                     reg = <0xF8F02000 0x1000>;
> +                     arm,data-latency = <2 3 2>;
> +                     arm,tag-latency = <2 3 2>;
> +                     cache-unified;
> +                     cache-level = <2>;
> +             };
> +
>               uart0: uart@e0000000 {
>                       compatible = "xlnx,xuartps";
>                       reg = <0xE0000000 0x1000>;
> diff --git a/arch/arm/mach-zynq/common.c b/arch/arm/mach-zynq/common.c
> index d73963b..056091a 100644
> --- a/arch/arm/mach-zynq/common.c
> +++ b/arch/arm/mach-zynq/common.c
> @@ -45,12 +45,10 @@ static struct of_device_id zynq_of_bus_ids[] __initdata = {
>   */
>  static void __init xilinx_init_machine(void)  { -#ifdef CONFIG_CACHE_L2X0
>       /*
>        * 64KB way size, 8-way associativity, parity disabled
>        */
> -     l2x0_init(PL310_L2CC_BASE, 0x02060000, 0xF0F0FFFF);
> -#endif
> +     l2x0_of_init(0x02060000, 0xF0F0FFFF);
>
>       of_platform_bus_probe(NULL, zynq_of_bus_ids, NULL);  } @@ -83,11
> +81,6 @@ static struct map_desc io_desc[] __initdata = {
>               .pfn            = __phys_to_pfn(SCU_PERIPH_PHYS),
>               .length         = SZ_8K,
>               .type           = MT_DEVICE,
> -     }, {
> -             .virtual        = PL310_L2CC_VIRT,
> -             .pfn            = __phys_to_pfn(PL310_L2CC_PHYS),
> -             .length         = SZ_4K,
> -             .type           = MT_DEVICE,
>       },
>
>  #ifdef CONFIG_DEBUG_LL
> diff --git a/arch/arm/mach-zynq/include/mach/zynq_soc.h b/arch/arm/mach-
> zynq/include/mach/zynq_soc.h
> index 3d1c6a6..218283a 100644
> --- a/arch/arm/mach-zynq/include/mach/zynq_soc.h
> +++ b/arch/arm/mach-zynq/include/mach/zynq_soc.h
> @@ -25,9 +25,6 @@
>  #define TTC0_PHYS                    0xF8001000
>  #define TTC0_VIRT                    TTC0_PHYS
>
> -#define PL310_L2CC_PHYS                      0xF8F02000
> -#define PL310_L2CC_VIRT                      PL310_L2CC_PHYS
> -
>  #define SCU_PERIPH_PHYS                      0xF8F00000
>  #define SCU_PERIPH_VIRT                      SCU_PERIPH_PHYS
>
> @@ -35,7 +32,6 @@
>
>  #define TTC0_BASE                    IOMEM(TTC0_VIRT)
>  #define SCU_PERIPH_BASE                      IOMEM(SCU_PERIPH_VIRT)
> -#define PL310_L2CC_BASE                      IOMEM(PL310_L2CC_VIRT)
>
>  /*
>   * Mandatory for CONFIG_LL_DEBUG, UART is mapped virtual = physical
> --
> 1.8.0
>

This is ok. No changes are necessary.
Acked-by: Michal Simek <michal.simek@xilinx.com>

Please add my acked-by line to this patch to the v5 series.
When all patches are ready I will apply it to zynq next branch at git.xilnx.com.

Thanks,
Michal



This email and any attachments are intended for the sole use of the named recipient(s) and contain(s) confidential information that may be proprietary, privileged or copyrighted under applicable law. If you are not the intended recipient, do not read, copy, or forward this email message or any attachments. Delete this email message and any attachments immediately.


