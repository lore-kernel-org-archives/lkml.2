Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758625Ab2JXMbh (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Oct 2012 08:31:37 -0400
Received: from mail2.gnudd.com ([213.203.150.91]:36317 "EHLO mail.gnudd.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758017Ab2JXMbe (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Oct 2012 08:31:34 -0400
Date: Wed, 24 Oct 2012 14:31:18 +0200
From: Davide Ciminaghi <ciminaghi@gnudd.com>
To: Mark Brown <broonie@opensource.wolfsonmicro.com>
Cc: sameo@linux.intel.com, rubini@gnudd.com, giancarlo.asnaghi@st.com,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 02/10] drivers/mfd/sta2x11-mfd: add regmap support
Message-ID: <20121024123118.GD26622@mail.gnudd.com>
References: <1350917441-4478-1-git-send-email-ciminaghi@gnudd.com> <1350917441-4478-3-git-send-email-ciminaghi@gnudd.com> <20121023171837.GE4477@opensource.wolfsonmicro.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
In-Reply-To: <20121023171837.GE4477@opensource.wolfsonmicro.com>
X-Face: #Q;A)@_4.#>0+_%y]7aBr:c"ndLp&#+2?]J;lkse\^)FP^Lr5@O0{)J;'nny4%74.fM'n)M >ISCj.KmsL/HTxz!:Ju'pnj'Gz&.
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Oct 23, 2012 at 06:18:38PM +0100, Mark Brown wrote:
> On Mon, Oct 22, 2012 at 04:50:33PM +0200, ciminaghi@gnudd.com wrote:
> 
> > +static bool sta2x11_sctl_writeable_reg(struct device *dev, unsigned int reg)
> > +{
> > +	return !__reg_within_range(reg, SCTL_SCPCIECSBRST, SCTL_SCRSTSTA);
> > +}
> 
> This and most of your other readable/writable things look like a
> framework feature waiting to be written - something data driven which
> takes a table of register ranges and goes and does the
> __reg_within_range() check on them.  Seems like it'd be really useful
> for devices like this.
>
I was looking at other drivers with regmap support, and it actually looks
like this __reg_within_range (or similar) thing is fairly common.
For instance sound/soc/tegra/tegra30_ahub.c:

#define REG_IN_ARRAY(reg, name) \
        ((reg >= TEGRA30_AHUB_##name) && \
         (reg <= LAST_REG(name) && \
         (!((reg - TEGRA30_AHUB_##name) % TEGRA30_AHUB_##name##_STRIDE))))

also used for precious and volatile registers.

sound/soc/tegra/tegra20_das.c:

static bool tegra20_das_wr_rd_reg(struct device *dev, unsigned int reg)
{
        if ((reg >= TEGRA20_DAS_DAP_CTRL_SEL) &&
            (reg <= LAST_REG(DAP_CTRL_SEL)))
                return true;
        if ((reg >= TEGRA20_DAS_DAC_INPUT_DATA_CLK_SEL) &&
            (reg <= LAST_REG(DAC_INPUT_DATA_CLK_SEL)))
                return true;

        return false;
}

My opinion is that passing function pointers for
readable/writeable/precious/volatile methods could still be useful when
registers' features or access properties can change at runtime (for instance a
given register is readable/writeable in working mode X and becomes read-only
when the device switches to mode Y). Other than that, four tables could just be
passed via struct regmap_config. regmap_writeable/readable/precious/volatile
would then invoke a (regmap private) _regmap_reg_in_ranges() function which
would do the check based on the correct range table. Things would work just
like now in case of NULL table pointers.

I am planning to submit a regmap patch in the next days (actually I've already
written something, but it is completely untested). Since sta2x11-mfd is
blocking the rest of our work on the Connext chip, though, I think the best
thing would be for me to keep things as they are now, and then doing this
improvement later on, if you agree.

> > +static bool sta2x11_apb_soc_regs_writeable_reg(struct device *dev,
> > +					       unsigned int reg)
> > +{
> > +	if (!sta2x11_apb_soc_regs_readable_reg(dev, reg))
> > +		return false;
> > +	return (!__reg_within_range(reg, PCIE_PM_STATUS_0_PORT_0_4,
> > +				    PCIE_PM_STATUS_7_0_EP4) &&
> > +		reg != PCIE_COMMON_CLOCK_CONFIG_0_4_0 &&
> > +		!__reg_within_range(reg, PCIE_SoC_INT_ROUTER_STATUS0_REG,
> > +				    PCIE_SoC_INT_ROUTER_STATUS3_REG) &&
> > +		reg != SYSTEM_CONFIG_STATUS_REG &&
> > +		reg != COMPENSATION_REG1);
> 
> For this I'd write a switch statement with the range checks in the
> default: case.  Actually you could just use the GCC switch range
> feature:
> 
> 	case PCIE_PM_STATUS_0_PORT_0_4..PCIE_PM_STATUS_7_0_EP4:
> 
> Either of these would increase readability.
> 
ok, will do that immediately.

> but generally
> 
> Reviewed-by: Mark Brown <broonie@opensource.wolfsonmicro.com>

Thanks a lot for your time.

Regards
Davide


