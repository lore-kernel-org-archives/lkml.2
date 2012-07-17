Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753961Ab2GQIqD (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Jul 2012 04:46:03 -0400
Received: from slimlogic.co.uk ([89.16.172.20]:38295 "EHLO slimlogic.co.uk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751330Ab2GQIqA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Jul 2012 04:46:00 -0400
Message-ID: <50052645.4090301@slimlogic.co.uk>
Date: Tue, 17 Jul 2012 09:45:57 +0100
From: Graeme Gregory <gg@slimlogic.co.uk>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:13.0) Gecko/20120615 Thunderbird/13.0.1
MIME-Version: 1.0
To: Axel Lin <axel.lin@gmail.com>
CC: Mark Brown <broonie@opensource.wolfsonmicro.com>,
        linux-kernel@vger.kernel.org, Liam Girdwood <lrg@ti.com>
Subject: Re: [PATCH RFT] regulator: palmas: Fix calcuating selector in palmas_map_voltage_smps
References: <1342495743.16433.1.camel@phoenix>
In-Reply-To: <1342495743.16433.1.camel@phoenix>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Good catch, thanks I totally forgot about the range bit in that function.

Acked-by: Graeme Gregory <gg@slimlogic.co.uk>

On 17/07/12 04:29, Axel Lin wrote:
> The logic of calculating selector in palmas_map_voltage_smps() does not match
> the logic to list voltage in palmas_list_voltage_smps().
>
> We use below equation to calculate voltage when selector > 0:
>         voltage = (0.49V + (selector * 0.01V)) * RANGE
> RANGE is either x1 or x2
>
> So we need to take into account with the multiplier set in VSEL register when
> calculating selector in palmas_map_voltage_smps()
>
> Signed-off-by: Axel Lin <axel.lin@gmail.com>
> ---
>  drivers/regulator/palmas-regulator.c |   17 ++++++++++++++---
>  1 file changed, 14 insertions(+), 3 deletions(-)
>
> diff --git a/drivers/regulator/palmas-regulator.c b/drivers/regulator/palmas-regulator.c
> index 7540c95..17d19fb 100644
> --- a/drivers/regulator/palmas-regulator.c
> +++ b/drivers/regulator/palmas-regulator.c
> @@ -373,11 +373,22 @@ static int palmas_set_voltage_smps_sel(struct regulator_dev *dev,
>  static int palmas_map_voltage_smps(struct regulator_dev *rdev,
>  		int min_uV, int max_uV)
>  {
> +	struct palmas_pmic *pmic = rdev_get_drvdata(rdev);
> +	int id = rdev_get_id(rdev);
>  	int ret, voltage;
>  
> -	ret = ((min_uV - 500000) / 10000) + 1;
> -	if (ret < 0)
> -		return ret;
> +	if (min_uV == 0)
> +		return 0;
> +
> +	if (pmic->range[id]) { /* RANGE is x2 */
> +		if (min_uV < 1000000)
> +			min_uV = 1000000;
> +		ret = DIV_ROUND_UP(min_uV - 1000000, 20000) + 1;
> +	} else {		/* RANGE is x1 */
> +		if (min_uV < 500000)
> +			min_uV = 500000;
> +		ret = DIV_ROUND_UP(min_uV - 500000, 10000) + 1;
> +	}
>  
>  	/* Map back into a voltage to verify we're still in bounds */
>  	voltage = palmas_list_voltage_smps(rdev, ret);


