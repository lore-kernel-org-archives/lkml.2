Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753333Ab2DUGrR (ORCPT <rfc822;w@1wt.eu>);
	Sat, 21 Apr 2012 02:47:17 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:53086 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751022Ab2DUGrP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 21 Apr 2012 02:47:15 -0400
Date: Fri, 20 Apr 2012 23:47:10 -0700
From: Dmitry Torokhov <dmitry.torokhov@gmail.com>
To: =?iso-8859-1?Q?Jean-Fran=E7ois?= Dagenais 
	<jeff.dagenais@gmail.com>
Cc: grant.likely@secretlab.ca, linus.walleij@stericsson.com,
        linux-kernel@vger.kernel.org, linux-input@vger.kernel.org,
        michael.hennerich@analog.com
Subject: Re: [PATCH 1/2] input: adp5588-keys - get value from data out when
 dir out
Message-ID: <20120421064710.GC2360@core.coreip.homeip.net>
References: <1334935921-13016-1-git-send-email-jeff.dagenais@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1334935921-13016-1-git-send-email-jeff.dagenais@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Jean-François,

On Fri, Apr 20, 2012 at 11:32:00AM -0400, Jean-François Dagenais wrote:
> As discussed here: http://ez.analog.com/message/35852,
> the 5587 revC and 5588 revB spec sheets contain a mistake
> in the GPIO_DAT_STATx register description.
> 
> According to R.Shnell at ADI, as well as my own
> observations, it should read:
> "GPIO data status (shows GPIO state when read for inputs)".
> 
> This commit changes the get value function accordingly.
> 
> A similar patch for gpio-adp5588 follows.
> 
> Signed-off-by: Jean-François Dagenais <jeff.dagenais@gmail.com>
> Acked-by: Michael Hennerich <michael.hennerich@analog.com>
> ---
>  drivers/input/keyboard/adp5588-keys.c |    7 +++++++
>  1 files changed, 7 insertions(+), 0 deletions(-)
> 
> diff --git a/drivers/input/keyboard/adp5588-keys.c b/drivers/input/keyboard/adp5588-keys.c
> index 6412ced..b7a0f1a 100644
> --- a/drivers/input/keyboard/adp5588-keys.c
> +++ b/drivers/input/keyboard/adp5588-keys.c
> @@ -78,6 +78,13 @@ static int adp5588_gpio_get_value(struct gpio_chip *chip, unsigned off)
>  	unsigned int bank = ADP5588_BANK(kpad->gpiomap[off]);
>  	unsigned int bit = ADP5588_BIT(kpad->gpiomap[off]);
>  
> +	mutex_lock(&kpad->gpio_lock);
> +	if (kpad->dir[bank] & bit) {
> +		int result = !!(kpad->dat_out[bank] & bit);
> +		mutex_unlock(&kpad->gpio_lock);
> +		return result;
> +	}
> +	mutex_unlock(&kpad->gpio_lock);
>  	return !!(adp5588_read(kpad->client, GPIO_DAT_STAT1 + bank) & bit);

This locking looks wrong as it is possible for adp5588_gpio_get_value()
to get scheduled out after checking kpad->dir[bank] and releasing
kpad->gpio_lock while another thread executes
adp5588_gpio_direction_output() and modifies kpad->dir[bank].

You should keep mutex for the entire duration; something like this:

	mutex_lock(&kpad->gpio_lock);
	if (kpad->dir[bank] & bit)
		val = kpad->dat_out[bank];
	else
		val = adp5588_read(kpad->client, GPIO_DAT_STAT1 + bank);
	mutex_unlock(&kpad->gpio_lock);

	return !!(val & bit);

Thanks.

-- 
Dmitry
