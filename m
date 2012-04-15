Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755189Ab2DOOQS (ORCPT <rfc822;w@1wt.eu>);
	Sun, 15 Apr 2012 10:16:18 -0400
Received: from ftp.meprolight.com ([194.90.149.17]:43073 "EHLO meprolight.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1753934Ab2DOOQR convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 15 Apr 2012 10:16:17 -0400
From: Alex Gershgorin <alexg@meprolight.com>
To: Sascha Hauer <s.hauer@pengutronix.de>
CC: "g.liakhovetski@gmx.de" <g.liakhovetski@gmx.de>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Date: Sun, 15 Apr 2012 17:15:38 +0300
Subject: RE: [PATCH] ARM: i.mx35 increase dma consistent region size
Thread-Topic: [PATCH] ARM: i.mx35 increase dma consistent region size
Thread-Index: Ac0Zg06TSY8pHp7FR6yuqIN4BCdz6ABaewO+
Message-ID: <4875438356E7CA4A8F2145FCD3E61C0B2CC34CAD2F@MEP-EXCH.meprolight.com>
References: <1334167274-29524-1-git-send-email-alexg@meprolight.com>,<20120413144029.GP3852@pengutronix.de>
In-Reply-To: <20120413144029.GP3852@pengutronix.de>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
acceptlanguage: en-US
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Sascha,

Sorry was not possible to respond to you earlier. 

On Wed, Apr 11, 2012 at 09:01:14PM +0300, Alex Gershgorin wrote:
> The default size of the consistent DMA region is 2MB
> without this patch, attempt to allocate more than 2MB
> is causing allocation failure
>
> Signed-off-by: Alex Gershgorin <alexg@meprolight.com>
> ---
>  arch/arm/mach-imx/mm-imx3.c |    1 +
>  1 files changed, 1 insertions(+), 0 deletions(-)
>
> diff --git a/arch/arm/mach-imx/mm-imx3.c b/arch/arm/mach-imx/mm-imx3.c
> index 7412738..a2c0c7d 100644
> --- a/arch/arm/mach-imx/mm-imx3.c
> +++ b/arch/arm/mach-imx/mm-imx3.c
> @@ -201,6 +201,7 @@ static struct map_desc mx35_io_desc[] __initdata = {
>  void __init mx35_map_io(void)
>  {
>       iotable_init(mx35_io_desc, ARRAY_SIZE(mx35_io_desc));
> +     init_consistent_dma_size(SZ_8M);

> > I don't know what to think about this. You probably have a board with
> > camera support and thus need bigger buffers, right? Nevertheless this
> > patch affects all i.MX35 users, even the ones without camera support.

Camera support is not an issue, this patch belongs only to those I.MX35 drivers who are using 
the dma coherent/writecombine allocations.

For example,  mx3fb currently uses only once DMA allocation for the framebuffer,
In the case of adding overlay support, we need an additional allocation for the overlay 
buffer as a resulting in the total request more than 2 MB

I have already started work on the mx3fb overlay support, about this we spoke with Guennadi,
My current kernel mx3fb successfully registered with support overlay buffer allocation.

Please see my cat /proc/dma-mappings: 

btw as you can see below there is no allocation for the camera

0xffa00000-0xffb77000 1536000 __set_par+0xc8/0x7f8
0xffc00000-0xffd77000 1536000 __set_par+0xc8/0x7f8
0xffdfa000-0xffdfb000    4096 ehci_mxc_setup+0x194/0x574
0xffdfb000-0xffdfc000    4096 dma_pool_alloc+0x9c/0x1f0
0xffdfc000-0xffdfd000    4096 dma_pool_alloc+0x9c/0x1f0
0xffdfd000-0xffdfe000    4096 fec_probe+0x248/0x71c
0xffdfe000-0xffdff000    4096 sdma_request_channel+0x2c/0xd8
0xffdff000-0xffe00000    4096 sdma_probe+0x2cc/0x61c

> > Another possibility would be to make this board specific.

I think this needed adapted for all i.mx3x, maybe need to use. 
  
#ifdef CONFIG_FB_MX3
        init_consistent_dma_size(SZ_8M);
#endif

Regards,
Alex Gershgorin
