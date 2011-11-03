Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754922Ab1KCJVf (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Nov 2011 05:21:35 -0400
Received: from hqemgate03.nvidia.com ([216.228.121.140]:3042 "EHLO
	hqemgate03.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752447Ab1KCJVc convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Nov 2011 05:21:32 -0400
X-PGP-Universal: processed;
	by hqnvupgp06.nvidia.com on Thu, 03 Nov 2011 02:21:20 -0700
Date: Thu, 3 Nov 2011 11:21:16 +0200
From: Peter De Schrijver <pdeschrijver@nvidia.com>
To: Colin Cross <ccross@android.com>
CC: Russell King <linux@arm.linux.org.uk>, Olof Johansson <olof@lixom.net>,
        Stephen Warren <swarren@nvidia.com>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-tegra@vger.kernel.org" <linux-tegra@vger.kernel.org>
Subject: Re: [PATCH v2 2/8] arm/tegra: prepare early init for multiple
 tegra variants
Message-ID: <20111103092116.GO13358@tbergstrom-lnx.Nvidia.com>
References: <1320242948-21061-1-git-send-email-pdeschrijver@nvidia.com>
 <1320242948-21061-3-git-send-email-pdeschrijver@nvidia.com>
 <CAMbhsRSTcR8qgYESmM6OxkXeVeg6vS49woCe_OX6CY4pAj2g_A@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="iso-8859-1"
Content-Disposition: inline
Content-Transfer-Encoding: 8BIT
In-Reply-To: <CAMbhsRSTcR8qgYESmM6OxkXeVeg6vS49woCe_OX6CY4pAj2g_A@mail.gmail.com>
X-NVConfidentiality: public
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Nov 02, 2011 at 07:30:43PM +0100, Colin Cross wrote:
> On Wed, Nov 2, 2011 at 7:09 AM, Peter De Schrijver
> <pdeschrijver@nvidia.com> wrote:
> > This patch splits the early init code in a common and a tegra20 specific part.
> > L2 cache initialization is generalized and discovers the cache associativity
> > at runtime.
> >
> > Signed-off-by: Peter De Schrijver <pdeschrijver@nvidia.com>
> > ---
> <snip>
> 
> > -static __initdata struct tegra_clk_init_table common_clk_init_table[] = {
> > +void (*arch_reset)(char mode, const char *cmd) = tegra_assert_system_reset;
> > +
> This is unrelated to the patch description?
> 

This is a left over from the past. Will be removed from the next version.

> > +static __initdata struct tegra_clk_init_table tegra20_clk_init_table[] = {
> >        /* name         parent          rate            enabled */
> >        { "clk_m",      NULL,           0,              true },
> >        { "pll_p",      "clk_m",        216000000,      true },
> > @@ -59,25 +61,34 @@ static __initdata struct tegra_clk_init_table common_clk_init_table[] = {
> >        { NULL,         NULL,           0,              0},
> >  };
> >
> > -static void __init tegra_init_cache(void)
> > +static void __init tegra_init_cache(u32 tag_latency, u32 data_latency)
> >  {
> >  #ifdef CONFIG_CACHE_L2X0
> >        void __iomem *p = IO_ADDRESS(TEGRA_ARM_PERIF_BASE) + 0x3000;
> > +       u32 aux_ctrl;
> > +
> > +       writel_relaxed(tag_latency, p + L2X0_TAG_LATENCY_CTRL);
> > +       writel_relaxed(data_latency, p + L2X0_DATA_LATENCY_CTRL);
> >
> > -       writel_relaxed(0x331, p + L2X0_TAG_LATENCY_CTRL);
> > -       writel_relaxed(0x441, p + L2X0_DATA_LATENCY_CTRL);
> > +       aux_ctrl = readl(p + L2X0_CACHE_TYPE);
> > +       aux_ctrl = (aux_ctrl & 0x700) << (17-8);
> 
> If I'm interpreting the PL310 TRM correctly, the cache associativity
> value in the L2X0_CACHE_TYPE register is read from the aux control
> register, so this is just leaving the existing value in place.  If the
> value is not being modified, just take it out of the aux_ctrl mask
> passed to l2x0_init.
> 

This seems to work fine on our android kernels though. Need to dig deeper
what's going on here.

> > +       aux_ctrl |= 0x7C000001;
> 
> This adds the BRESP bit to the aux control register.  Considering the
> problems I've seen with random bits in the L2 cache causing all sorts
> of instabilities, this should be split out into a separate change so
> that it's obvious in a bisect.
> 

Ok. Will remove that for now.

> >
> > -       l2x0_init(p, 0x6C080001, 0x8200c3fe);
> > +       l2x0_init(p, aux_ctrl, 0x8200c3fe);
> >  #endif
> >
> >  }
> >
> > -void __init tegra_init_early(void)
> > +static void __init tegra_setup_system_reset(void)
> > +{
> > +       arm_arch_reset = tegra_assert_system_reset;
> > +}
> > +
> > +void __init tegra20_init_early(void)
> >  {
> >        tegra_init_fuse();
> >        tegra_init_clock();
> > -       tegra_clk_init_from_table(common_clk_init_table);
> > -       tegra_init_cache();
> > -
> > -       arm_arch_reset = tegra_assert_system_reset;
> > +       tegra_clk_init_from_table(tegra20_clk_init_table);
> > +       tegra_init_cache(0x331, 0x441);
> > +       tegra_setup_system_reset();
> 
> It seems likely that there will be multiple init functions that need
> to be called from init_early on both tegra20 and tegra30.  Maybe add a
> common function that only calls tegra_setup_system_reset() for now?
> 

Ok. Will do that.

Cheers,

Peter.
