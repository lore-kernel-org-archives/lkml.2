Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1032005Ab2CORUm (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Mar 2012 13:20:42 -0400
Received: from mail-yx0-f174.google.com ([209.85.213.174]:61978 "EHLO
	mail-yx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932243Ab2CORUg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Mar 2012 13:20:36 -0400
Message-ID: <4F6224E2.5060006@gmail.com>
Date: Thu, 15 Mar 2012 10:20:34 -0700
From: Dirk Brandewie <dirk.brandewie@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:10.0.1) Gecko/20120216 Thunderbird/10.0.1
MIME-Version: 1.0
To: Dan Carpenter <dan.carpenter@oracle.com>
CC: Grant Likely <grant.likely@secretlab.ca>,
        Dirk Brandewie <dirk.brandewie@gmail.com>,
        Rob Herring <rob.herring@calxeda.com>,
        Anton Vorontsov <anton.vorontsov@linaro.org>,
        MyungJoo Ham <myungjoo.ham@samsung.com>,
        Kyungmin Park <kyungmin.park@samsung.com>,
        Philip Rakity <prakity@marvell.com>, linux-kernel@vger.kernel.org,
        devicetree-discuss@lists.ozlabs.org, kernel-janitors@vger.kernel.org
Subject: Re: [patch] max17042_battery: fix a couple buffer overflows
References: <20120315113732.GA364@elgon.mountain>
In-Reply-To: <20120315113732.GA364@elgon.mountain>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/15/2012 04:37 AM, Dan Carpenter wrote:
> There are a couple issues here caused by confusion between sizeof()
> and ARRAY_SIZE().  "table_size" should be the number of elements, but we
> should allocate it with kcalloc() so that we allocate the correct number
> of bytes.
>
> In max17042_init_model() we don't allocate enough space so we go past
> the end of the array in max17042_read_model_data() and
> max17042_model_data_compare().
>
> In max17042_verify_model_lock() we allocate the right amount of space
> but we call max17042_read_model_data() with the wrong number of elements
> and also in the for loop we go past the end of the array.
>
> Signed-off-by: Dan Carpenter<dan.carpenter@oracle.com>
Acked-by: Dirk Brandewie <dirk.brandewie@gmail.com>

Typo in first ack :-(
> ---
> I don't have this hardware.  The original code is clearly buggy, but I
> can't test that my fix is correct.  Please review carefully.
>
> diff --git a/drivers/power/max17042_battery.c b/drivers/power/max17042_battery.c
> index e36763a..f8cd48c 100644
> --- a/drivers/power/max17042_battery.c
> +++ b/drivers/power/max17042_battery.c
> @@ -328,11 +328,10 @@ static inline int max17042_model_data_compare(struct max17042_chip *chip,
>   static int max17042_init_model(struct max17042_chip *chip)
>   {
>   	int ret;
> -	int table_size =
> -		sizeof(chip->pdata->config_data->cell_char_tbl)/sizeof(u16);
> +	int table_size = ARRAY_SIZE(chip->pdata->config_data->cell_char_tbl);
>   	u16 *temp_data;
>
> -	temp_data = kzalloc(table_size, GFP_KERNEL);
> +	temp_data = kcalloc(table_size, sizeof(*temp_data), GFP_KERNEL);
>   	if (!temp_data)
>   		return -ENOMEM;
>
> @@ -357,12 +356,11 @@ static int max17042_init_model(struct max17042_chip *chip)
>   static int max17042_verify_model_lock(struct max17042_chip *chip)
>   {
>   	int i;
> -	int table_size =
> -		sizeof(chip->pdata->config_data->cell_char_tbl);
> +	int table_size = ARRAY_SIZE(chip->pdata->config_data->cell_char_tbl);
>   	u16 *temp_data;
>   	int ret = 0;
>
> -	temp_data = kzalloc(table_size, GFP_KERNEL);
> +	temp_data = kcalloc(table_size, sizeof(*temp_data), GFP_KERNEL);
>   	if (!temp_data)
>   		return -ENOMEM;
>

