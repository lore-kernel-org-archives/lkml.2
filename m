Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1422695Ab2GMPWQ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Jul 2012 11:22:16 -0400
Received: from metis.ext.pengutronix.de ([92.198.50.35]:58503 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755669Ab2GMPWO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Jul 2012 11:22:14 -0400
Date: Fri, 13 Jul 2012 17:22:00 +0200
From: Uwe =?iso-8859-1?Q?Kleine-K=F6nig?= 
	<u.kleine-koenig@pengutronix.de>
To: Samuel Ortiz <samuel.ortiz@intel.com>
Cc: kernel@pengutronix.de, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org,
        "Ying-Chun Liu (PaulLiu)" <paulliu@debian.org>,
        Philippe =?iso-8859-1?Q?R=E9tornaz?= <philippe.retornaz@epfl.ch>,
        Marc Reilly <marc@cpdesign.com.au>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>
Subject: Re: [PATCH 6/7] mfd/mc13xxx: change probing details for mc13xxx
 devices
Message-ID: <20120713152200.GL592@pengutronix.de>
References: <1342087073-3892-1-git-send-email-u.kleine-koenig@pengutronix.de>
 <1342087073-3892-7-git-send-email-u.kleine-koenig@pengutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1342087073-3892-7-git-send-email-u.kleine-koenig@pengutronix.de>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SA-Exim-Connect-IP: 2001:6f8:1178:2:21e:67ff:fe11:9c5c
X-SA-Exim-Mail-From: ukl@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jul 12, 2012 at 11:57:52AM +0200, Uwe Kleine-König wrote:
> This removes auto-detection of which variant of mc13xxx is used because
> mc34708 uses a different layout in the revision register that doesn't
> allow differentiation any more.
> 
> Signed-off-by: Uwe Kleine-König <u.kleine-koenig@pengutronix.de>
> ---
>  drivers/mfd/mc13xxx-core.c |   77 ++++++++++++++++----------------------------
>  drivers/mfd/mc13xxx-i2c.c  |   16 +++++----
>  drivers/mfd/mc13xxx-spi.c  |   25 +++++++-------
>  drivers/mfd/mc13xxx.h      |   17 ++++++----
>  4 files changed, 60 insertions(+), 75 deletions(-)
> 
> diff --git a/drivers/mfd/mc13xxx-core.c b/drivers/mfd/mc13xxx-core.c
> index f0ea3b8..7874711 100644
> --- a/drivers/mfd/mc13xxx-core.c
> +++ b/drivers/mfd/mc13xxx-core.c
> @@ -410,62 +410,36 @@ static irqreturn_t mc13xxx_irq_thread(int irq, void *data)
>  	return IRQ_RETVAL(handled);
>  }
>  
> -static const char *mc13xxx_chipname[] = {
> -	[MC13XXX_ID_MC13783] = "mc13783",
> -	[MC13XXX_ID_MC13892] = "mc13892",
> -};
> -
>  #define maskval(reg, mask)	(((reg) & (mask)) >> __ffs(mask))
> -static int mc13xxx_identify(struct mc13xxx *mc13xxx)
> +static void mc13xxx_print_revision(struct mc13xxx *mc13xxx, u32 revision)
>  {
> -	u32 icid;
> -	u32 revision;
> -	int ret;
> -
> -	/*
> -	 * Get the generation ID from register 46, as apparently some older
> -	 * IC revisions only have this info at this location. Newer ICs seem to
> -	 * have both.
> -	 */
> -	ret = mc13xxx_reg_read(mc13xxx, 46, &icid);
> -	if (ret)
> -		return ret;
> -
> -	icid = (icid >> 6) & 0x7;
> -
> -	switch (icid) {
> -	case 2:
> -		mc13xxx->ictype = MC13XXX_ID_MC13783;
> -		break;
> -	case 7:
> -		mc13xxx->ictype = MC13XXX_ID_MC13892;
> -		break;
> -	default:
> -		mc13xxx->ictype = MC13XXX_ID_INVALID;
> -		break;
> -	}
> +	dev_info(mc13xxx->dev, "%s: rev: %d.%d, "
> +			"fin: %d, fab: %d, icid: %d/%d\n",
> +			mc13xxx->variant->name,
> +			maskval(revision, MC13XXX_REVISION_REVFULL),
> +			maskval(revision, MC13XXX_REVISION_REVMETAL),
> +			maskval(revision, MC13XXX_REVISION_FIN),
> +			maskval(revision, MC13XXX_REVISION_FAB),
> +			maskval(revision, MC13XXX_REVISION_ICID),
> +			maskval(revision, MC13XXX_REVISION_ICIDCODE));
> +}
>  
> -	if (mc13xxx->ictype == MC13XXX_ID_MC13783 ||
> -			mc13xxx->ictype == MC13XXX_ID_MC13892) {
> -		ret = mc13xxx_reg_read(mc13xxx, MC13XXX_REVISION, &revision);
> -
> -		dev_info(mc13xxx->dev, "%s: rev: %d.%d, "
> -				"fin: %d, fab: %d, icid: %d/%d\n",
> -				mc13xxx_chipname[mc13xxx->ictype],
> -				maskval(revision, MC13XXX_REVISION_REVFULL),
> -				maskval(revision, MC13XXX_REVISION_REVMETAL),
> -				maskval(revision, MC13XXX_REVISION_FIN),
> -				maskval(revision, MC13XXX_REVISION_FAB),
> -				maskval(revision, MC13XXX_REVISION_ICID),
> -				maskval(revision, MC13XXX_REVISION_ICIDCODE));
> -	}
> +/* These are only exported for mc13xxx-i2c and mc13xxx-spi */
> +struct mc13xxx_variant mc13xxx_variant_mc13783 = {
> +	.name = "mc13783",
> +	.print_revision = mc13xxx_print_revision,
> +};
> +EXPORT_SYMBOL_GPL(mc13xxx_variant_mc13783);
>  
> -	return (mc13xxx->ictype == MC13XXX_ID_INVALID) ? -ENODEV : 0;
> -}
> +struct mc13xxx_variant mc13xxx_variant_mc13892 = {
> +	.name = "mc13892",
> +	.print_revision = mc13xxx_print_revision,
> +};
> +EXPORT_SYMBOL_GPL(mc13xxx_variant_mc13892);
>  
>  static const char *mc13xxx_get_chipname(struct mc13xxx *mc13xxx)
>  {
> -	return mc13xxx_chipname[mc13xxx->ictype];
> +	return mc13xxx->variant->name;
>  }
>  
>  int mc13xxx_get_flags(struct mc13xxx *mc13xxx)
> @@ -653,13 +627,16 @@ int mc13xxx_common_init(struct mc13xxx *mc13xxx,
>  		struct mc13xxx_platform_data *pdata, int irq)
>  {
>  	int ret;
> +	u32 revision;
>  
>  	mc13xxx_lock(mc13xxx);
>  
> -	ret = mc13xxx_identify(mc13xxx);
> +	ret = mc13xxx_reg_read(mc13xxx, MC13XXX_REVISION, &revision);
>  	if (ret)
>  		goto err_revision;
>  
> +	mc13xxx_print_revision(mc13xxx, revision);
This must read:

	mc13xxx->variant->print_revision(mc13xxx, revision);

I fixed that in my tree, Samuel, please tell me if I should resend or if
you can fix that up.

Best regards
Uwe

-- 
Pengutronix e.K.                           | Uwe Kleine-König            |
Industrial Linux Solutions                 | http://www.pengutronix.de/  |
