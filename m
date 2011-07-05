Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751859Ab1GEWy6 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Jul 2011 18:54:58 -0400
Received: from slimlogic.co.uk ([89.16.172.20]:56965 "EHLO slimlogic.co.uk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751378Ab1GEWy5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Jul 2011 18:54:57 -0400
Message-ID: <4E13963F.1050905@slimlogic.co.uk>
Date: Tue, 05 Jul 2011 23:54:55 +0100
From: Graeme Gregory <gg@slimlogic.co.uk>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.17) Gecko/20110428 Fedora/3.1.10-1.fc15 Lightning/1.0b3pre Thunderbird/3.1.10
MIME-Version: 1.0
To: Jesper Juhl <jj@chaosbits.net>
CC: Samuel Ortiz <sameo@linux.intel.com>, linux-kernel@vger.kernel.org,
        Jorge Eduardo Candelaria <jedu@slimlogic.co.uk>
Subject: Re: [PATCH] mfd: Don't leak init_data in tps65910_i2c_probe
References: <alpine.LNX.2.00.1107022120171.16316@swampdragon.chaosbits.net> <20110704173320.GR3021@sortiz-mobl> <alpine.LNX.2.00.1107050945330.27127@swampdragon.chaosbits.net> <alpine.LNX.2.00.1107060027280.9158@swampdragon.chaosbits.net>
In-Reply-To: <alpine.LNX.2.00.1107060027280.9158@swampdragon.chaosbits.net>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/05/2011 11:29 PM, Jesper Juhl wrote:
> On Tue, 5 Jul 2011, Jesper Juhl wrote:
>
>> On Mon, 4 Jul 2011, Samuel Ortiz wrote:
>>
> [...]
>>> This is not a memory leak fix. And I actually prefer the == NULL check.
>>> Please remove the == NULL check replacement with !* and keep only the memory
>>> leak fixing part.
>>>
> Here's an updated patch.
>
>
> From: Jesper Juhl <jj@chaosbits.net>
> Subject: [PATCH] mfd: Don't leak init_data in tps65910_i2c_probe
>
> There are a couple of situations where we leak init_data in
> drivers/mfd/tps65910.c:tps65910_i2c_probe() - this patch should take
> care of them.
>
> Signed-off-by: Jesper Juhl <jj@chaosbits.net>
> ---
>  drivers/mfd/tps65910.c |    6 +++++-
>  1 files changed, 5 insertions(+), 1 deletions(-)
>
> diff --git a/drivers/mfd/tps65910.c b/drivers/mfd/tps65910.c
> index 2229e66..7a3eb2d 100644
> --- a/drivers/mfd/tps65910.c
> +++ b/drivers/mfd/tps65910.c
> @@ -151,8 +151,10 @@ static int tps65910_i2c_probe(struct i2c_client *i2c,
>  	init_data->irq_base = pmic_plat_data->irq;
>  
>  	tps65910 = kzalloc(sizeof(struct tps65910), GFP_KERNEL);
> -	if (tps65910 == NULL)
> +	if (tps65910 == NULL) {
> +		kfree(init_data);
>  		return -ENOMEM;
> +	}
>  
>  	i2c_set_clientdata(i2c, tps65910);
>  	tps65910->dev = &i2c->dev;
> @@ -174,11 +176,13 @@ static int tps65910_i2c_probe(struct i2c_client *i2c,
>  	if (ret < 0)
>  		goto err;
>  
> +	kfree(init_data);
>  	return ret;
>  
>  err:
>  	mfd_remove_devices(tps65910->dev);
>  	kfree(tps65910);
> +	kfree(init_data);
>  	return ret;
>  }
>  
Sorry didnt reply to this first time round.

Acked-by: Graeme Gregory <gg@slimlogic.co.uk>

