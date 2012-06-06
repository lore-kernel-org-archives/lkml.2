Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756211Ab2FFOnw (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Jun 2012 10:43:52 -0400
Received: from slimlogic.co.uk ([89.16.172.20]:47447 "EHLO slimlogic.co.uk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752879Ab2FFOnv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Jun 2012 10:43:51 -0400
Message-ID: <4FCF6CA4.90400@slimlogic.co.uk>
Date: Wed, 06 Jun 2012 15:43:48 +0100
From: Graeme Gregory <gg@slimlogic.co.uk>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:12.0) Gecko/20120430 Thunderbird/12.0.1
MIME-Version: 1.0
To: Axel Lin <axel.lin@gmail.com>
CC: linux-kernel@vger.kernel.org,
        Mark Brown <broonie@opensource.wolfsonmicro.com>,
        Liam Girdwood <lrg@ti.com>
Subject: Re: [PATCH v2] regulator: palmas: Slightly code change for better
 readability
References: <1338984098.5195.1.camel@phoenix>
In-Reply-To: <1338984098.5195.1.camel@phoenix>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Acked-by: Graeme Gregory <gg@slimlogic.co.uk>

On 06/06/12 13:01, Axel Lin wrote:
> It's a little bit hard to read that the "else" case means id == PALMAS_REG_SMPS10.
>
> if (id != PALMAS_REG_SMPS10){
>         do something for the cases id != PALMAS_REG_SMPS10;
> } else {
>         do something for the case id == PALMAS_REG_SMPS10;
> }
>
> This patch changes above syntax to switch statement.
>
> Signed-off-by: Axel Lin <axel.lin@gmail.com>
> ---
>  drivers/regulator/palmas-regulator.c |   28 ++++++++++++++++------------
>  1 file changed, 16 insertions(+), 12 deletions(-)
>
> diff --git a/drivers/regulator/palmas-regulator.c b/drivers/regulator/palmas-regulator.c
> index b4e10b0..112436b 100644
> --- a/drivers/regulator/palmas-regulator.c
> +++ b/drivers/regulator/palmas-regulator.c
> @@ -517,7 +517,15 @@ static int palmas_smps_init(struct palmas *palmas, int id,
>  	if (ret)
>  		return ret;
>  
> -	if (id != PALMAS_REG_SMPS10) {
> +	switch (id) {
> +	case PALMAS_REG_SMPS10:
> +		if (reg_init->mode_sleep) {
> +			reg &= ~PALMAS_SMPS10_CTRL_MODE_SLEEP_MASK;
> +			reg |= reg_init->mode_sleep <<
> +					PALMAS_SMPS10_CTRL_MODE_SLEEP_SHIFT;
> +		}
> +		break;
> +	default:
>  		if (reg_init->warm_reset)
>  			reg |= PALMAS_SMPS12_CTRL_WR_S;
>  
> @@ -529,14 +537,8 @@ static int palmas_smps_init(struct palmas *palmas, int id,
>  			reg |= reg_init->mode_sleep <<
>  					PALMAS_SMPS12_CTRL_MODE_SLEEP_SHIFT;
>  		}
> -	} else {
> -		if (reg_init->mode_sleep) {
> -			reg &= ~PALMAS_SMPS10_CTRL_MODE_SLEEP_MASK;
> -			reg |= reg_init->mode_sleep <<
> -					PALMAS_SMPS10_CTRL_MODE_SLEEP_SHIFT;
> -		}
> -
>  	}
> +
>  	ret = palmas_smps_write(palmas, addr, reg);
>  	if (ret)
>  		return ret;
> @@ -660,10 +662,8 @@ static __devinit int palmas_probe(struct platform_device *pdev)
>  		pmic->desc[id].name = palmas_regs_info[id].name;
>  		pmic->desc[id].id = id;
>  
> -		if (id != PALMAS_REG_SMPS10) {
> -			pmic->desc[id].ops = &palmas_ops_smps;
> -			pmic->desc[id].n_voltages = PALMAS_SMPS_NUM_VOLTAGES;
> -		} else {
> +		switch (id) {
> +		case PALMAS_REG_SMPS10:
>  			pmic->desc[id].n_voltages = PALMAS_SMPS10_NUM_VOLTAGES;
>  			pmic->desc[id].ops = &palmas_ops_smps10;
>  			pmic->desc[id].vsel_reg = PALMAS_SMPS10_CTRL;
> @@ -672,6 +672,10 @@ static __devinit int palmas_probe(struct platform_device *pdev)
>  			pmic->desc[id].enable_mask = SMPS10_BOOST_EN;
>  			pmic->desc[id].min_uV = 3750000;
>  			pmic->desc[id].uV_step = 1250000;
> +			break;
> +		default:
> +			pmic->desc[id].ops = &palmas_ops_smps;
> +			pmic->desc[id].n_voltages = PALMAS_SMPS_NUM_VOLTAGES;
>  		}
>  
>  		pmic->desc[id].type = REGULATOR_VOLTAGE;

