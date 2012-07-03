Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752876Ab2GCErO (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Jul 2012 00:47:14 -0400
Received: from arroyo.ext.ti.com ([192.94.94.40]:55763 "EHLO arroyo.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751980Ab2GCErM convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Jul 2012 00:47:12 -0400
From: "AnilKumar, Chimata" <anilkumar@ti.com>
To: Axel Lin <axel.lin@gmail.com>, "Girdwood, Liam" <lrg@ti.com>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "Nori, Sekhar" <nsekhar@ti.com>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>
Subject: RE: [PATCH 2/2] regulator: tps65217: Fix voltage boundary checking
 in tps65217_pmic_map_voltage
Thread-Topic: [PATCH 2/2] regulator: tps65217: Fix voltage boundary checking
 in tps65217_pmic_map_voltage
Thread-Index: AQHNWMjPmY5gFg9gAUCbVVRddR0fhJcW+hKg
Date: Tue, 3 Jul 2012 04:46:16 +0000
Message-ID: <331ABD5ECB02734CA317220B2BBEABC13E9E8CAB@DBDE01.ent.ti.com>
References: <1341284473.18757.2.camel@phoenix>
 <1341284755.18757.5.camel@phoenix>
In-Reply-To: <1341284755.18757.5.camel@phoenix>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [172.24.133.24]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Axel,

On Tue, Jul 03, 2012 at 08:35:55, Axel Lin wrote:
> It is ok to request voltage with min_uV < tps->info[rid]->min_uV and
> max_uV > tps->info[rid]->max_uV
> 
> Signed-off-by: Axel Lin <axel.lin@gmail.com>
> ---
>  drivers/regulator/tps65217-regulator.c |    5 +----
>  1 file changed, 1 insertion(+), 4 deletions(-)
> 
> diff --git a/drivers/regulator/tps65217-regulator.c b/drivers/regulator/tps65217-regulator.c
> index 0a3df5b..0947a09 100644
> --- a/drivers/regulator/tps65217-regulator.c
> +++ b/drivers/regulator/tps65217-regulator.c
> @@ -206,10 +206,7 @@ static int tps65217_pmic_map_voltage(struct regulator_dev *dev,
>  	if (rid < TPS65217_DCDC_1 || rid > TPS65217_LDO_4)
>  		return -EINVAL;
>  
> -	if (min_uV < tps->info[rid]->min_uV || min_uV > tps->info[rid]->max_uV)
> -		return -EINVAL;
> -
> -	if (max_uV < tps->info[rid]->min_uV || max_uV > tps->info[rid]->max_uV)
> +	if (max_uV < tps->info[rid]->min_uV || min_uV > tps->info[rid]->max_uV)
>  		return -EINVAL;

Case 1:-
------

tps->info[rid]->min_uV = 600000;
tps->info[rid]->max_uV = 1100000;

If we do regulator_set_voltage(reg, 550000, 1100000);

This results into error condition and how can we handle with this?

Case 2:-
------

I think the current code handles this case as well.

There might be a case where board/DT data is false like

tps->info[rid]->min_uV = 1100000;
tps->info[rid]->max_uV = 600000;

regulator_set_voltage(reg, 650000, 1100000);

Regards
AnilKumar