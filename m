Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933953Ab2FEK7J (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Jun 2012 06:59:09 -0400
Received: from am1ehsobe005.messaging.microsoft.com ([213.199.154.208]:6357
	"EHLO am1outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S933334Ab2FEK7H (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Jun 2012 06:59:07 -0400
X-Forefront-Antispam-Report: CIP:70.37.183.190;KIP:(null);UIP:(null);IPV:NLI;H:mail.freescale.net;RD:none;EFVD:NLI
X-SpamScore: -11
X-BigFish: VS-11(zzbb2dI9371I1432N98dKzz1202hzz8275bhz2dh2a8h668h839h944hd25hf0ah)
Date: Tue, 5 Jun 2012 18:59:29 +0800
From: Zhao Chenhui <chenhui.zhao@freescale.com>
To: Scott Wood <scottwood@freescale.com>
CC: <linuxppc-dev@lists.ozlabs.org>, <linux-kernel@vger.kernel.org>,
        <galak@kernel.crashing.org>, <leoli@freescale.com>
Subject: Re: [PATCH v5 5/5] powerpc/85xx: add support to JOG feature using
 cpufreq interface
Message-ID: <20120605105929.GA22427@localhost.localdomain>
References: <1336737235-15370-1-git-send-email-chenhui.zhao@freescale.com>
 <1336737235-15370-5-git-send-email-chenhui.zhao@freescale.com>
 <4FC950AF.90007@freescale.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <4FC950AF.90007@freescale.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-OriginatorOrg: freescale.net
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jun 01, 2012 at 06:30:55PM -0500, Scott Wood wrote:
> On 05/11/2012 06:53 AM, Zhao Chenhui wrote:
> > Some 85xx silicons like MPC8536 and P1022 have a JOG feature, which provides
> > a dynamic mechanism to lower or raise the CPU core clock at runtime.
> 
> Is there a reason P1023 isn't supported?

P1023 support is deferred.

> 
> > This patch adds the support to change CPU frequency using the standard
> > cpufreq interface. The ratio CORE to CCB can be 1:1(except MPC8536), 3:2,
> > 2:1, 5:2, 3:1, 7:2 and 4:1.
> > 
> > Two CPU cores on P1022 must not in the low power state during the frequency
> > transition. The driver uses a atomic counter to meet the requirement.
> > 
> > The jog mode frequency transition process on the MPC8536 is similar to
> > the deep sleep process. The driver need save the CPU state and restore
> > it after CPU warm reset.
> > 
> > Note:
> >  * The I/O peripherals such as PCIe and eTSEC may lose packets during
> >    the jog mode frequency transition.
> 
> That might be acceptable for eTSEC, but it is not acceptable to lose
> anything on PCIe.  Especially not if you're going to make this "default y".

It is a hardware limitation. Peripherals in the platform will not be operating
during the jog mode frequency transition process.

I can make it "default n".

> 
> 
> > +static int mpc85xx_job_probe(struct platform_device *ofdev)
> 
> Job?

Sorry, It should be "jog".

> 
> > +{
> > +	struct device_node *np = ofdev->dev.of_node;
> > +	unsigned int svr;
> > +
> > +	if (of_device_is_compatible(np, "fsl,mpc8536-guts")) {
> > +		svr = mfspr(SPRN_SVR);
> > +		if ((svr & 0x7fff) == 0x10) {
> > +			pr_err("MPC8536 Rev 1.0 do not support JOG.\n");
> > +			return -ENODEV;
> > +		}
> 
> s/do not support JOG/does not support cpufreq/
> 
> > +		mpc85xx_freqs = mpc8536_freqs_table;
> > +		set_pll = mpc8536_set_pll;
> > +	} else if (of_device_is_compatible(np, "fsl,p1022-guts")) {
> > +		mpc85xx_freqs = p1022_freqs_table;
> > +		set_pll = p1022_set_pll;
> > +	} else {
> > +		return -ENODEV;
> > +	}
> > +
> > +	sysfreq = fsl_get_sys_freq();
> > +
> > +	guts = of_iomap(np, 0);
> > +	if (!guts)
> > +		return -ENODEV;
> > +
> > +	max_pll[0] = get_pll(0);
> > +	if (mpc85xx_freqs == p1022_freqs_table)
> > +		max_pll[1] = get_pll(1);
> > +
> > +	pr_info("Freescale MPC85xx CPU frequency switching(JOG) driver\n");
> > +
> > +	return cpufreq_register_driver(&mpc85xx_cpufreq_driver);
> > +}
> > +
> > +static int mpc85xx_jog_remove(struct platform_device *ofdev)
> > +{
> > +	iounmap(guts);
> > +	cpufreq_unregister_driver(&mpc85xx_cpufreq_driver);
> > +
> > +	return 0;
> > +}
> > +
> > +static struct of_device_id mpc85xx_jog_ids[] = {
> > +	{ .compatible = "fsl,mpc8536-guts", },
> > +	{ .compatible = "fsl,p1022-guts", },
> > +	{}
> > +};
> > +
> > +static struct platform_driver mpc85xx_jog_driver = {
> > +	.driver = {
> > +		.name = "mpc85xx_cpufreq_jog",
> > +		.owner = THIS_MODULE,
> > +		.of_match_table = mpc85xx_jog_ids,
> > +	},
> > +	.probe = mpc85xx_job_probe,
> > +	.remove = mpc85xx_jog_remove,
> > +};
> 
> Why is this a separate driver from fsl_pmc.c?
> 
> Only one driver can bind to a node through normal mechanisms -- you
> don't get to take the entire guts node for this.

You are right. I will not bind this to the guts node.

> 
> > +static int __init mpc85xx_jog_init(void)
> > +{
> > +	return platform_driver_register(&mpc85xx_jog_driver);
> > +}
> > +
> > +static void __exit mpc85xx_jog_exit(void)
> > +{
> > +	platform_driver_unregister(&mpc85xx_jog_driver);
> > +}
> > +
> > +module_init(mpc85xx_jog_init);
> > +module_exit(mpc85xx_jog_exit);
> > +
> > +MODULE_LICENSE("GPL");
> > +MODULE_AUTHOR("Dave Liu <daveliu@freescale.com>");
> > diff --git a/arch/powerpc/platforms/Kconfig b/arch/powerpc/platforms/Kconfig
> > index a35ca44..445bedd 100644
> > --- a/arch/powerpc/platforms/Kconfig
> > +++ b/arch/powerpc/platforms/Kconfig
> > @@ -204,6 +204,17 @@ config CPU_FREQ_PMAC64
> >  	  This adds support for frequency switching on Apple iMac G5,
> >  	  and some of the more recent desktop G5 machines as well.
> >  
> > +config MPC85xx_CPUFREQ
> > +	bool "Support for Freescale MPC85xx CPU freq"
> > +	depends on PPC_85xx && PPC32 && !PPC_E500MC
> 
> PPC32 is redundant given the !PPC_E500MC.

Yes.

> 
> > index 8976534..401cac0 100644
> > --- a/arch/powerpc/sysdev/fsl_soc.h
> > +++ b/arch/powerpc/sysdev/fsl_soc.h
> > @@ -62,5 +62,10 @@ void fsl_hv_halt(void);
> >   * code can be compatible with both 32-bit & 36-bit.
> >   */
> >  extern void mpc85xx_enter_deep_sleep(u64 ccsrbar, u32 powmgtreq);
> > +
> > +static inline void mpc85xx_enter_jog(u64 ccsrbar, u32 powmgtreq)
> > +{
> > +	mpc85xx_enter_deep_sleep(ccsrbar, powmgtreq);
> > +}
> 
> What value is this function adding over mpc85xx_enter_deep_sleep()?

Just an alias name. If this is improper, I could use mpc85xx_enter_deep_sleep() directly.

-Chenhui

