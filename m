Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754866Ab2AaTJP (ORCPT <rfc822;w@1wt.eu>);
	Tue, 31 Jan 2012 14:09:15 -0500
Received: from mail-pz0-f46.google.com ([209.85.210.46]:38420 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753996Ab2AaTJN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 31 Jan 2012 14:09:13 -0500
Date: Tue, 31 Jan 2012 11:09:05 -0800
From: Dmitry Torokhov <dmitry.torokhov@gmail.com>
To: Stephen Warren <swarren@nvidia.com>
Cc: Shridhar Rasal <srasal@nvidia.com>,
        "rydberg@euromail.se" <rydberg@euromail.se>,
        Rakesh Iyer <riyer@nvidia.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-input@vger.kernel.org" <linux-input@vger.kernel.org>,
        "linux-tegra@vger.kernel.org" <linux-tegra@vger.kernel.org>
Subject: Re: [PATCH 1/1] input: keyboard: Set configuration registers
Message-ID: <20120131190904.GA20672@core.coreip.homeip.net>
References: <1323415758-16822-1-git-send-email-srasal@nvidia.com>
 <74CDBE0F657A3D45AFBB94109FB122FF1751860550@HQMAIL01.nvidia.com>
 <3849551.l2KNPKMSmh@dtor-d630.eng.vmware.com>
 <74CDBE0F657A3D45AFBB94109FB122FF17518605E5@HQMAIL01.nvidia.com>
 <20111230032559.GB17850@core.coreip.homeip.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20111230032559.GB17850@core.coreip.homeip.net>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Dec 29, 2011 at 07:25:59PM -0800, Dmitry Torokhov wrote:
> On Fri, Dec 09, 2011 at 03:17:54PM -0800, Stephen Warren wrote:
> > Dmitry Torokhov wrote at Friday, December 09, 2011 2:25 PM:
> > > On Friday, December 09, 2011 12:10:43 PM Stephen Warren wrote:
> > > > Shridhar Rasal wrote at Friday, December 09, 2011 12:29 AM:
> > > > > To: dmitry.torokhov@gmail.com
> > > > > Cc: rydberg@euromail.se; Stephen Warren; Rakesh Iyer;
> > > > > linux-kernel@vger.kernel.org; linux- input@vger.kernel.org;
> > > > > linux-tegra@vger.kernel.org; Shridhar Rasal Subject: [PATCH 1/1] input:
> > > > > keyboard: Set configuration registers
> > > > >
> > > > > -Set only REQUIRED row and column configuration register to
> > > > > PROPER values to avoid continuously generating KBC input events.
> > > > > -Use *en* field in pin_cfg, to check GPIO_x_ROW_EN register
> > > > > should be set or clear.
> > > > >
> > > > > Signed-off-by: Shridhar Rasal <srasal@nvidia.com>
> > > >
> > > > I wondered if num==0 could be used instead of a new en field, but 0 is a
> > > > valid row/column number, so no. As such,
> > > >
> > > > Acked-by: Stephen Warren <swarren@nvidia.com>
> > > 
> > > Can we pass in number of pin_cfg instances in pdata and simply do not
> > > mention unneeded pins instead?
> > 
> > IIUC, the array is currently a fixed size (based on the set of pins
> > Supported by the KBC), hence that won't work; there's an entry for each
> > pin saying which row/column it is.
> > 
> > However, I suppose if we were to change the structure of the pdata to be:
> > 
> > struct tegra_kbc_pin_cfg {
> >     bool is_row;
> >     u8 row_col_id;
> >     u8 pin_id;
> > };
> > 
> > Then struct tegra_kbc_platform_data could indeed have a pointer to a
> > variable-sized array of these, which would avoid the "en" member.
> > 
> 
> How about we change bool to enum instead, like in the patch below?
> 

*ping*

> -- 
> Dmitry
> 
> 
> Input: tegra-kbc - allow skipping setting up some of GPIO pins
> 
> From: Shridhar Rasal <srasal@nvidia.com>
> 
> Allow marking some of GPIO pins as ignored to to avoid continuously
> generating KBC input events.
> 
> Signed-off-by: Shridhar Rasal <srasal@nvidia.com>
> Signed-off-by: Dmitry Torokhov <dtor@mail.ru>
> ---
> 
>  arch/arm/mach-tegra/include/mach/kbc.h |    8 +++++++-
>  drivers/input/keyboard/tegra-kbc.c     |   34 +++++++++++++++++++++++++-------
>  2 files changed, 34 insertions(+), 8 deletions(-)
> 
> 
> diff --git a/arch/arm/mach-tegra/include/mach/kbc.h b/arch/arm/mach-tegra/include/mach/kbc.h
> index 20bb054..72e28bd 100644
> --- a/arch/arm/mach-tegra/include/mach/kbc.h
> +++ b/arch/arm/mach-tegra/include/mach/kbc.h
> @@ -36,8 +36,14 @@
>  #define KBC_MAX_COL	8
>  #define KBC_MAX_KEY	(KBC_MAX_ROW * KBC_MAX_COL)
>  
> +enum tegra_pin_type {
> +	PIN_CFG_COL,
> +	PIN_CFG_ROW,
> +	PIN_CFG_IGNORE,
> +};
> +
>  struct tegra_kbc_pin_cfg {
> -	bool is_row;
> +	enum tegra_pin_type type;
>  	unsigned char num;
>  };
>  
> diff --git a/drivers/input/keyboard/tegra-kbc.c b/drivers/input/keyboard/tegra-kbc.c
> index a136e2e..09f383a 100644
> --- a/drivers/input/keyboard/tegra-kbc.c
> +++ b/drivers/input/keyboard/tegra-kbc.c
> @@ -455,10 +455,18 @@ static void tegra_kbc_config_pins(struct tegra_kbc *kbc)
>  		row_cfg &= ~r_mask;
>  		col_cfg &= ~c_mask;
>  
> -		if (pdata->pin_cfg[i].is_row)
> +		switch (pdata->pin_cfg[i].type) {
> +		case PIN_CFG_ROW:
>  			row_cfg |= ((pdata->pin_cfg[i].num << 1) | 1) << r_shft;
> -		else
> +			break;
> +
> +		case PIN_CFG_COL:
>  			col_cfg |= ((pdata->pin_cfg[i].num << 1) | 1) << c_shft;
> +			break;
> +
> +		case PIN_CFG_IGNORE:
> +			break;
> +		}
>  
>  		writel(row_cfg, kbc->mmio + r_offs);
>  		writel(col_cfg, kbc->mmio + c_offs);
> @@ -563,7 +571,8 @@ tegra_kbc_check_pin_cfg(const struct tegra_kbc_platform_data *pdata,
>  	for (i = 0; i < KBC_MAX_GPIO; i++) {
>  		const struct tegra_kbc_pin_cfg *pin_cfg = &pdata->pin_cfg[i];
>  
> -		if (pin_cfg->is_row) {
> +		switch (pin_cfg->type) {
> +		case PIN_CFG_ROW:
>  			if (pin_cfg->num >= KBC_MAX_ROW) {
>  				dev_err(dev,
>  					"pin_cfg[%d]: invalid row number %d\n",
> @@ -571,13 +580,25 @@ tegra_kbc_check_pin_cfg(const struct tegra_kbc_platform_data *pdata,
>  				return false;
>  			}
>  			(*num_rows)++;
> -		} else {
> +			break;
> +
> +		case PIN_CFG_COL:
>  			if (pin_cfg->num >= KBC_MAX_COL) {
>  				dev_err(dev,
>  					"pin_cfg[%d]: invalid column number %d\n",
>  					i, pin_cfg->num);
>  				return false;
>  			}
> +			break;
> +
> +		case PIN_CFG_IGNORE:
> +			break;
> +
> +		default:
> +			dev_err(dev,
> +				"pin_cfg[%d]: invalid entry type %d\n",
> +				pin_cfg->type, pin_cfg->num);
> +			return false;
>  		}
>  	}
>  
> @@ -594,7 +615,6 @@ tegra_kbc_dt_parse_pdata(struct platform_device *pdev)
>  	if (!np)
>  		return NULL;
>  
> -	pdata = kzalloc(sizeof(*pdata), GFP_KERNEL);
>  	if (!pdata)
>  		return NULL;
>  
> @@ -616,12 +636,12 @@ tegra_kbc_dt_parse_pdata(struct platform_device *pdev)
>  	 */
>  	for (i = 0; i < KBC_MAX_ROW; i++) {
>  		pdata->pin_cfg[i].num = i;
> -		pdata->pin_cfg[i].is_row = true;
> +		pdata->pin_cfg[i].type = PIN_CFG_ROW;
>  	}
>  
>  	for (i = 0; i < KBC_MAX_COL; i++) {
>  		pdata->pin_cfg[KBC_MAX_ROW + i].num = i;
> -		pdata->pin_cfg[KBC_MAX_ROW + i].is_row = false;
> +		pdata->pin_cfg[KBC_MAX_ROW + i].type = PIN_CFG_COL;
>  	}
>  
>  	return pdata;

-- 
Dmitry
