Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752809Ab2GRHzi (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Jul 2012 03:55:38 -0400
Received: from slimlogic.co.uk ([89.16.172.20]:34254 "EHLO slimlogic.co.uk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750999Ab2GRHzc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Jul 2012 03:55:32 -0400
Message-ID: <50066BF2.7050507@slimlogic.co.uk>
Date: Wed, 18 Jul 2012 08:55:30 +0100
From: Graeme Gregory <gg@slimlogic.co.uk>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:14.0) Gecko/20120714 Thunderbird/14.0
MIME-Version: 1.0
To: Axel Lin <axel.lin@gmail.com>
CC: Mark Brown <broonie@opensource.wolfsonmicro.com>,
        linux-kernel@vger.kernel.org, Liam Girdwood <lrg@ti.com>
Subject: Re: [PATCH] regulator: palmas: Fix calculating selector in palmas_map_voltage_ldo
References: <1342582211.12515.2.camel@phoenix>
In-Reply-To: <1342582211.12515.2.camel@phoenix>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 18/07/12 04:30, Axel Lin wrote:
> This patch fixes below issues when choosing selector:
>
> 1. Current code returns negative selector if min_uV < 900000 which is wrong.
>    For example, it is possible to satisfy the request with selector = 1 if
>    the requested min_uV is 850000.
Isnt this defending against bugs in the regulator core? I am normally
against repeating the same checks at multiple levels in a stack.
> 2. Current code may select a voltage lower than requested min_uV.
>    For example, if the requested min_uV is 945000, current code chooses
>    selector = 1 which is lower than requested min_uV.
>    DIV_ROUND_UP to avoid this case.
>
> Signed-off-by: Axel Lin <axel.lin@gmail.com>
> ---
>  drivers/regulator/palmas-regulator.c |    9 ++++++---
>  1 file changed, 6 insertions(+), 3 deletions(-)
>
> diff --git a/drivers/regulator/palmas-regulator.c b/drivers/regulator/palmas-regulator.c
> index 17d19fb..0fcf355 100644
> --- a/drivers/regulator/palmas-regulator.c
> +++ b/drivers/regulator/palmas-regulator.c
> @@ -486,9 +486,12 @@ static int palmas_map_voltage_ldo(struct regulator_dev *rdev,
>  {
>  	int ret, voltage;
>  
> -	ret = ((min_uV - 900000) / 50000) + 1;
> -	if (ret < 0)
> -		return ret;
> +	if (min_uV == 0)
> +		return 0;
> +
> +	if (min_uV < 900000)
> +		min_uV = 900000;
> +	ret = DIV_ROUND_UP(min_uV - 900000, 50000) + 1;
>  
>  	/* Map back into a voltage to verify we're still in bounds */
>  	voltage = palmas_list_voltage_ldo(rdev, ret);

