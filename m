Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752938Ab2DRSWA (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Apr 2012 14:22:00 -0400
Received: from na3sys009aog114.obsmtp.com ([74.125.149.211]:59544 "EHLO
	na3sys009aog114.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751386Ab2DRSV6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Apr 2012 14:21:58 -0400
From: Kevin Hilman <khilman@ti.com>
To: jean.pihet@newoldbits.com
Cc: linux-omap@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        "Rafael J. Wysocki" <rjw@sisk.pl>, LKML <linux-kernel@vger.kernel.org>,
        Jean Pihet <j-pihet@ti.com>, Paul Walmsley <paul@pwsan.com>,
        Thara Gopinath <thara@ti.com>, Nishanth Menon <nm@ti.com>
Subject: Re: [PATCH 7/9] ARM: OMAP2+: SmartReflex: Use per-OPP data structure
Organization: Texas Instruments, Inc.
References: <1332173578-27422-1-git-send-email-j-pihet@ti.com>
	<1332173578-27422-8-git-send-email-j-pihet@ti.com>
Date: Wed, 18 Apr 2012 11:21:47 -0700
In-Reply-To: <1332173578-27422-8-git-send-email-j-pihet@ti.com> (jean pihet's
	message of "Mon, 19 Mar 2012 17:12:56 +0100")
Message-ID: <87y5pskiis.fsf@ti.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.3 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

jean.pihet@newoldbits.com writes:

> From: Jean Pihet <j-pihet@ti.com>
>
> The SmartReflex driver incorrectly treats some per-OPP data as data
> common to all OPPs (e.g., ERRMINLIMIT).  Move this data into a per-OPP
> data structure.

OK

> The SmartReflex driver should not be dependent on whether the host SoC
> uses eFuses to store SmartReflex parameters or not.  (Even SoCs that
> do store SR data in eFuses often need to override that data with
> software-defined values.)  So, convert sr_retrieve_nvalue() to look up
> per-OPP data by the OPP's nominal voltage, rather than by the eFuse
> offset.

Right.

> While at it:
>  . tidy up the code wrt default values in the data tables,
>  . remove the global errminlimit debugfs entry and create per-voltage
>    entries from the data tables.

OK

> Furthermore, in order to make the SmartReflex implementation ready for
> the move to drivers/, remove the dependency from the SR driver code
> to the voltage layer by querying the data tables only from the SR device
> init code.

So that's 4 relatively independent things going on in this patch which
makes it somewhat difficult to review and understand.

I'd suggest breaking it up into smaller parts if possible.  If not, fix
up the changelog to describe why all of these need to go together, and
why it's necessary to do them before the move.

Thanks,

Kevin

> Based on Paul's original code for the SmartReflex driver conversion.
>
> Signed-off-by: Jean Pihet <j-pihet@ti.com>
> Cc: Paul Walmsley <paul@pwsan.com>
> Cc: Thara Gopinath <thara@ti.com>
> Cc: Nishanth Menon <nm@ti.com>
> Cc: Kevin Hilman <khilman@ti.com>
> ---
>  arch/arm/mach-omap2/smartreflex.c |   57 +++++++++++++++---------------------
>  arch/arm/mach-omap2/sr_device.c   |   35 +++++++++++++++++++----
>  include/linux/power/smartreflex.h |    8 ++++-
>  3 files changed, 59 insertions(+), 41 deletions(-)
>
> diff --git a/arch/arm/mach-omap2/smartreflex.c b/arch/arm/mach-omap2/smartreflex.c
> index 5f3faf3..71f70ca 100644
> --- a/arch/arm/mach-omap2/smartreflex.c
> +++ b/arch/arm/mach-omap2/smartreflex.c
> @@ -348,22 +348,24 @@ static void sr_v2_disable(struct omap_sr *sr)
>  	sr_write_reg(sr, IRQSTATUS, IRQSTATUS_MCUDISABLEACKINT);
>  }
>  
> -static u32 sr_retrieve_nvalue(struct omap_sr *sr, u32 efuse_offs)
> +static struct omap_sr_nvalue_table *sr_retrieve_nvalue_row(
> +				struct omap_sr *sr,
> +				unsigned long volt_nominal)
>  {
>  	int i;
>  
>  	if (!sr->nvalue_table) {
>  		dev_warn(&sr->pdev->dev, "%s: Missing ntarget value table\n",
>  			__func__);
> -		return 0;
> +		return NULL;
>  	}
>  
>  	for (i = 0; i < sr->nvalue_count; i++) {
> -		if (sr->nvalue_table[i].efuse_offs == efuse_offs)
> -			return sr->nvalue_table[i].nvalue;
> +		if (sr->nvalue_table[i].volt_nominal == volt_nominal)
> +			return &sr->nvalue_table[i];
>  	}
>  
> -	return 0;
> +	return NULL;
>  }
>  
>  /* Public Functions */
> @@ -585,9 +587,8 @@ int sr_configure_minmax(struct voltagedomain *voltdm)
>   */
>  int sr_enable(struct voltagedomain *voltdm, unsigned long volt)
>  {
> -	struct omap_volt_data *volt_data;
>  	struct omap_sr *sr = _sr_lookup(voltdm);
> -	u32 nvalue_reciprocal;
> +	struct omap_sr_nvalue_table *nvalue_row;
>  	int ret;
>  
>  	if (IS_ERR(sr)) {
> @@ -595,24 +596,16 @@ int sr_enable(struct voltagedomain *voltdm, unsigned long volt)
>  		return PTR_ERR(sr);
>  	}
>  
> -	volt_data = omap_voltage_get_voltdata(sr->voltdm, volt);
> -
> -	if (IS_ERR(volt_data)) {
> -		dev_warn(&sr->pdev->dev, "%s: Unable to get voltage table"
> -			"for nominal voltage %ld\n", __func__, volt);
> -		return PTR_ERR(volt_data);
> -	}
> -
> -	nvalue_reciprocal = sr_retrieve_nvalue(sr, volt_data->sr_efuse_offs);
> -
> -	if (!nvalue_reciprocal) {
> -		dev_warn(&sr->pdev->dev, "%s: NVALUE = 0 at voltage %ld\n",
> -			__func__, volt);
> +	nvalue_row = sr_retrieve_nvalue_row(sr, volt);
> +	if (!nvalue_row) {
> +		dev_warn(&sr->pdev->dev, "%s: failure getting SR data for this voltage %ld\n",
> +			 __func__, volt);
>  		return -ENODATA;
>  	}
>  
> +
>  	/* errminlimit is opp dependent and hence linked to voltage */
> -	sr->err_minlimit = volt_data->sr_errminlimit;
> +	sr->err_minlimit = nvalue_row->errminlimit;
>  
>  	pm_runtime_get_sync(&sr->pdev->dev);
>  
> @@ -625,7 +618,7 @@ int sr_enable(struct voltagedomain *voltdm, unsigned long volt)
>  	if (ret)
>  		return ret;
>  
> -	sr_write_reg(sr, NVALUERECIPROCAL, nvalue_reciprocal);
> +	sr_write_reg(sr, NVALUERECIPROCAL, nvalue_row->nvalue);
>  
>  	/* SRCONFIG - enable SR */
>  	sr_modify_reg(sr, SRCONFIG, SRCONFIG_SRENABLE, SRCONFIG_SRENABLE);
> @@ -873,7 +866,6 @@ static int __init omap_sr_probe(struct platform_device *pdev)
>  	struct omap_sr_data *pdata = pdev->dev.platform_data;
>  	struct resource *mem, *irq;
>  	struct dentry *nvalue_dir;
> -	struct omap_volt_data *volt_data;
>  	int i, ret = 0;
>  
>  	sr_info = kzalloc(sizeof(struct omap_sr), GFP_KERNEL);
> @@ -980,8 +972,6 @@ static int __init omap_sr_probe(struct platform_device *pdev)
>  			&sr_info->err_weight);
>  	(void) debugfs_create_x32("errmaxlimit", S_IRUGO, sr_info->dbg_dir,
>  			&sr_info->err_maxlimit);
> -	(void) debugfs_create_x32("errminlimit", S_IRUGO, sr_info->dbg_dir,
> -			&sr_info->err_minlimit);
>  
>  	nvalue_dir = debugfs_create_dir("nvalue", sr_info->dbg_dir);
>  	if (IS_ERR_OR_NULL(nvalue_dir)) {
> @@ -991,12 +981,9 @@ static int __init omap_sr_probe(struct platform_device *pdev)
>  		goto err_debugfs;
>  	}
>  
> -	omap_voltage_get_volttable(sr_info->voltdm, &volt_data);
> -	if (!volt_data) {
> -		dev_warn(&pdev->dev, "%s: %s: No Voltage table for the"
> -			" corresponding vdd. Cannot create debugfs"
> -			"entries for n-values\n",
> -			__func__, sr_info->name);
> +	if (sr_info->nvalue_count == 0 || !sr_info->nvalue_table) {
> +		dev_warn(&pdev->dev, "%s: %s: No Voltage table for the corresponding vdd. Cannot create debugfs entries for n-values\n",
> +			 __func__, sr_info->name);
>  		ret = -ENODATA;
>  		goto err_debugfs;
>  	}
> @@ -1004,10 +991,14 @@ static int __init omap_sr_probe(struct platform_device *pdev)
>  	for (i = 0; i < sr_info->nvalue_count; i++) {
>  		char name[NVALUE_NAME_LEN + 1];
>  
> -		snprintf(name, sizeof(name), "volt_%d",
> -			 volt_data[i].volt_nominal);
> +		snprintf(name, sizeof(name), "volt_%lu",
> +			 sr_info->nvalue_table[i].volt_nominal);
>  		(void) debugfs_create_x32(name, S_IRUGO | S_IWUSR, nvalue_dir,
>  				&(sr_info->nvalue_table[i].nvalue));
> +		snprintf(name, sizeof(name), "errminlimit_%lu",
> +			 sr_info->nvalue_table[i].volt_nominal);
> +		(void) debugfs_create_x32(name, S_IRUGO | S_IWUSR, nvalue_dir,
> +				&(sr_info->nvalue_table[i].errminlimit));
>  	}
>  
>  	return ret;
> diff --git a/arch/arm/mach-omap2/sr_device.c b/arch/arm/mach-omap2/sr_device.c
> index e081174..67d967e 100644
> --- a/arch/arm/mach-omap2/sr_device.c
> +++ b/arch/arm/mach-omap2/sr_device.c
> @@ -36,7 +36,10 @@ static void __init sr_set_nvalues(struct omap_volt_data *volt_data,
>  				struct omap_sr_data *sr_data)
>  {
>  	struct omap_sr_nvalue_table *nvalue_table;
> -	int i, count = 0;
> +	int i, j, count = 0;
> +
> +	sr_data->nvalue_count = 0;
> +	sr_data->nvalue_table = NULL;
>  
>  	while (volt_data[count].volt_nominal)
>  		count++;
> @@ -44,8 +47,14 @@ static void __init sr_set_nvalues(struct omap_volt_data *volt_data,
>  	nvalue_table = kzalloc(sizeof(struct omap_sr_nvalue_table)*count,
>  			GFP_KERNEL);
>  
> -	for (i = 0; i < count; i++) {
> +	if (!nvalue_table) {
> +		pr_err("OMAP: SmartReflex: cannot allocate memory for n-value table\n");
> +		return;
> +	}
> +
> +	for (i = 0, j = 0; i < count; i++) {
>  		u32 v;
> +
>  		/*
>  		 * In OMAP4 the efuse registers are 24 bit aligned.
>  		 * A __raw_readl will fail for non-32 bit aligned address
> @@ -58,15 +67,29 @@ static void __init sr_set_nvalues(struct omap_volt_data *volt_data,
>  				omap_ctrl_readb(offset + 1) << 8 |
>  				omap_ctrl_readb(offset + 2) << 16;
>  		} else {
> -			 v = omap_ctrl_readl(volt_data[i].sr_efuse_offs);
> +			v = omap_ctrl_readl(volt_data[i].sr_efuse_offs);
>  		}
>  
> -		nvalue_table[i].efuse_offs = volt_data[i].sr_efuse_offs;
> -		nvalue_table[i].nvalue = v;
> +		/*
> +		 * Many OMAP SoCs don't have the eFuse values set.
> +		 * For example, pretty much all OMAP3xxx before
> +		 * ES3.something.
> +		 *
> +		 * XXX There needs to be some way for board files or
> +		 * userspace to add these in.
> +		 */
> +		if (v == 0)
> +			continue;
> +
> +		nvalue_table[j].nvalue = v;
> +		nvalue_table[j].errminlimit = volt_data[i].sr_errminlimit;
> +		nvalue_table[j].volt_nominal = volt_data[i].volt_nominal;
> +
> +		j++;
>  	}
>  
>  	sr_data->nvalue_table = nvalue_table;
> -	sr_data->nvalue_count = count;
> +	sr_data->nvalue_count = j;
>  }
>  
>  static int __init sr_dev_init(struct omap_hwmod *oh, void *user)
> diff --git a/include/linux/power/smartreflex.h b/include/linux/power/smartreflex.h
> index e7dff08..0f7c81b 100644
> --- a/include/linux/power/smartreflex.h
> +++ b/include/linux/power/smartreflex.h
> @@ -48,12 +48,16 @@ struct omap_sr {
>  /**
>   * struct omap_sr_nvalue_table	- Smartreflex n-target value info
>   *
> - * @efuse_offs:	The offset of the efuse where n-target values are stored.
> - * @nvalue:	The n-target value.
> + * @efuse_offs:	  The offset of the efuse where n-target values are stored.
> + * @nvalue:	  The n-target value.
> + * @errminlimit:  The value of the ERRMINLIMIT bitfield for this n-target
> + * @volt_nominal: microvolts DC that the VDD is initially programmed to
>   */
>  struct omap_sr_nvalue_table {
>  	u32 efuse_offs;
>  	u32 nvalue;
> +	u32 errminlimit;
> +	unsigned long volt_nominal;
>  };
>  
>  /**
