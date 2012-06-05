Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753121Ab2FEEIb (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Jun 2012 00:08:31 -0400
Received: from ch1ehsobe006.messaging.microsoft.com ([216.32.181.186]:8634
	"EHLO ch1outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751725Ab2FEEI3 convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Jun 2012 00:08:29 -0400
X-Forefront-Antispam-Report: CIP:70.37.183.190;KIP:(null);UIP:(null);IPV:NLI;H:mail.freescale.net;RD:none;EFVD:NLI
X-SpamScore: -15
X-BigFish: VS-15(zzbb2dI9371I542M1432N98dKzz1202hzz8275bhz2dh2a8h668h839h8e2h8e3h944hd25hf0ahbe9i)
From: Li Yang-R58472 <r58472@freescale.com>
To: Wood Scott-B07421 <B07421@freescale.com>,
        Zhao Chenhui-B35336 <B35336@freescale.com>
CC: "linuxppc-dev@lists.ozlabs.org" <linuxppc-dev@lists.ozlabs.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "galak@kernel.crashing.org" <galak@kernel.crashing.org>
Subject: RE: [PATCH v5 4/5] fsl_pmc: Add API to enable device as wakeup
 event source
Thread-Topic: [PATCH v5 4/5] fsl_pmc: Add API to enable device as wakeup
 event source
Thread-Index: AQHNL2y7r6BvQOIl+0qohWyrm5d/spbmezkAgAQGN4CAAL/KgP//5sXg
Date: Tue, 5 Jun 2012 04:08:25 +0000
Message-ID: <94F013E7935FF44C83EBE7784D62AD3F09335D27@039-SN2MPN1-022.039d.mgd.msft.net>
References: <1336737235-15370-1-git-send-email-chenhui.zhao@freescale.com>
 <1336737235-15370-4-git-send-email-chenhui.zhao@freescale.com>
 <4FC93D74.3090200@freescale.com>
 <20120604113609.GC20676@localhost.localdomain> <4FCD3E8B.30805@freescale.com>
In-Reply-To: <4FCD3E8B.30805@freescale.com>
Accept-Language: zh-CN, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.192.208.83]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
X-OriginatorOrg: freescale.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



> -----Original Message-----
> From: Wood Scott-B07421
> Sent: Tuesday, June 05, 2012 7:03 AM
> To: Zhao Chenhui-B35336
> Cc: linuxppc-dev@lists.ozlabs.org; linux-kernel@vger.kernel.org;
> galak@kernel.crashing.org; Li Yang-R58472
> Subject: Re: [PATCH v5 4/5] fsl_pmc: Add API to enable device as wakeup
> event source
> 
> On 06/04/2012 06:36 AM, Zhao Chenhui wrote:
> > On Fri, Jun 01, 2012 at 05:08:52PM -0500, Scott Wood wrote:
> >> On 05/11/2012 06:53 AM, Zhao Chenhui wrote:
> >>> Add APIs for setting wakeup source and lossless Ethernet in low power
> modes.
> >>> These APIs can be used by wake-on-packet feature.
> >>>
> >>> Signed-off-by: Dave Liu <daveliu@freescale.com>
> >>> Signed-off-by: Li Yang <leoli@freescale.com>
> >>> Signed-off-by: Jin Qing <b24347@freescale.com>
> >>> Signed-off-by: Zhao Chenhui <chenhui.zhao@freescale.com>
> >>> ---
> >>>  arch/powerpc/sysdev/fsl_pmc.c |   71
> ++++++++++++++++++++++++++++++++++++++++-
> >>>  arch/powerpc/sysdev/fsl_soc.h |    9 +++++
> >>>  2 files changed, 79 insertions(+), 1 deletions(-)
> >>>
> >>> diff --git a/arch/powerpc/sysdev/fsl_pmc.c
> b/arch/powerpc/sysdev/fsl_pmc.c
> >>> index 1dc6e9e..c1170f7 100644
> >>> --- a/arch/powerpc/sysdev/fsl_pmc.c
> >>> +++ b/arch/powerpc/sysdev/fsl_pmc.c
> >>> @@ -34,6 +34,7 @@ struct pmc_regs {
> >>>  	__be32 powmgtcsr;
> >>>  #define POWMGTCSR_SLP		0x00020000
> >>>  #define POWMGTCSR_DPSLP		0x00100000
> >>> +#define POWMGTCSR_LOSSLESS	0x00400000
> >>>  	__be32 res3[2];
> >>>  	__be32 pmcdr;
> >>>  };
> >>> @@ -43,6 +44,74 @@ static unsigned int pmc_flag;
> >>>
> >>>  #define PMC_SLEEP	0x1
> >>>  #define PMC_DEEP_SLEEP	0x2
> >>> +#define PMC_LOSSLESS	0x4
> >>> +
> >>> +/**
> >>> + * mpc85xx_pmc_set_wake - enable devices as wakeup event source
> >>> + * @pdev: platform device affected
> >>> + * @enable: True to enable event generation; false to disable
> >>> + *
> >>> + * This enables the device as a wakeup event source, or disables it.
> >>> + *
> >>> + * RETURN VALUE:
> >>> + * 0 is returned on success
> >>> + * -EINVAL is returned if device is not supposed to wake up the
> system
> >>> + * Error code depending on the platform is returned if both the
> platform and
> >>> + * the native mechanism fail to enable the generation of wake-up
> events
> >>> + */
> >>> +int mpc85xx_pmc_set_wake(struct platform_device *pdev, bool enable)
> >>
> >> Why does it have to be a platform_device?  Would a bare device_node
> work
> >> here?  If it's for stuff like device_may_wakeup() that could be in a
> >> platform_device wrapper function.
> >
> > It does not have to be a platform_device. I think it can be a struct
> device.
> 
> Why does it even need that?  The low level mechanism for influencing
> PMCDR should only need a device node, not a Linux device struct.

It does no harm to pass the device structure and makes more sense for object oriented interface design. 

> 
> >> Where does this get called from?  I don't see an example user in this
> >> patchset.
> >
> > It will be used by a gianfar related patch. I plan to submit that patch
> > after these patches accepted.
> 
> It would be nice to see how this is used when reviewing this.
> 
> >>> +{
> >>> +	int ret = 0;
> >>> +	struct device_node *clk_np;
> >>> +	u32 *prop;
> >>> +	u32 pmcdr_mask;
> >>> +
> >>> +	if (!pmc_regs) {
> >>> +		pr_err("%s: PMC is unavailable\n", __func__);
> >>> +		return -ENODEV;
> >>> +	}
> >>> +
> >>> +	if (enable && !device_may_wakeup(&pdev->dev))
> >>> +		return -EINVAL;
> >>
> >> Who is setting can_wakeup for these devices?
> >
> > The device driver is responsible to set can_wakeup.
> 
> How would the device driver know how to set it?  Wouldn't this depend on
> the particular SoC and low power mode?

It is based on the "fsl,magic-packet" and "fsl,wake-on-filer" device tree properties.

Leo

