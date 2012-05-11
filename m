Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761144Ab2EKXs7 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 May 2012 19:48:59 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:64389 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755445Ab2EKXs6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 May 2012 19:48:58 -0400
From: Grant Likely <grant.likely@secretlab.ca>
Subject: Re: [PATCH] gpiolib: Use seq_file's iterator interface
To: Thierry Reding <thierry.reding@avionic-design.de>,
        linux-kernel@vger.kernel.org
Cc: Linus Walleij <linus.walleij@stericsson.com>,
        Arnd Bergmann <arnd@arndb.de>
In-Reply-To: <1334229961-1844-1-git-send-email-thierry.reding@avionic-design.de>
References: <1334229961-1844-1-git-send-email-thierry.reding@avionic-design.de>
Date: Fri, 11 May 2012 17:48:56 -0600
Message-Id: <20120511234856.7AC023E0791@localhost>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 12 Apr 2012 13:26:01 +0200, Thierry Reding <thierry.reding@avionic-design.de> wrote:
> When dumping a collection of items via seq_file, it is recommended to
> use the iterator interface. For the gpiolib debugfs interface this can
> be done to dump each GPIO chip in turn.
> 
> Note that for gpiolib this is a little cumbersome because it does not
> provide a list of registered GPIO chips and the only way to iterate is
> over each GPIO individually. Once a chip is found, the number of GPIOs
> it provides can be skipped as a small optimization.
> 
> This patch was requested by Arnd Bergmann here:
> 
> 	http://article.gmane.org/gmane.linux.ports.tegra/3535
> 
> Signed-off-by: Thierry Reding <thierry.reding@avionic-design.de>

Arnd, you requested this.  Can you review it?

Thanks,
g.

> Cc: Linus Walleij <linus.walleij@stericsson.com>
> Cc: Grant Likely <grant.likely@secretlab.ca>
> Cc: Arnd Bergmann <arnd@arndb.de>
> Cc: linux-kernel@vger.kernel.org
> ---
>  drivers/gpio/gpiolib.c |  102 +++++++++++++++++++++++++++++++++++-------------
>  1 file changed, 74 insertions(+), 28 deletions(-)
> 
> diff --git a/drivers/gpio/gpiolib.c b/drivers/gpio/gpiolib.c
> index 566d012..3c5296f 100644
> --- a/drivers/gpio/gpiolib.c
> +++ b/drivers/gpio/gpiolib.c
> @@ -1773,56 +1773,102 @@ static void gpiolib_dbg_show(struct seq_file *s, struct gpio_chip *chip)
>  	}
>  }
>  
> -static int gpiolib_show(struct seq_file *s, void *unused)
> +static void *gpiolib_seq_start(struct seq_file *s, loff_t *pos)
>  {
> -	struct gpio_chip	*chip = NULL;
> -	unsigned		gpio;
> -	int			started = 0;
> +	struct gpio_chip *chip = NULL;
> +	unsigned int gpio;
> +	void *ret = NULL;
> +	loff_t index = 0;
>  
>  	/* REVISIT this isn't locked against gpio_chip removal ... */
>  
>  	for (gpio = 0; gpio_is_valid(gpio); gpio++) {
> -		struct device *dev;
> -
> -		if (chip == gpio_desc[gpio].chip)
> +		if (gpio_desc[gpio].chip == chip)
>  			continue;
> +
>  		chip = gpio_desc[gpio].chip;
>  		if (!chip)
>  			continue;
>  
> -		seq_printf(s, "%sGPIOs %d-%d",
> -				started ? "\n" : "",
> -				chip->base, chip->base + chip->ngpio - 1);
> -		dev = chip->dev;
> -		if (dev)
> -			seq_printf(s, ", %s/%s",
> -				dev->bus ? dev->bus->name : "no-bus",
> -				dev_name(dev));
> -		if (chip->label)
> -			seq_printf(s, ", %s", chip->label);
> -		if (chip->can_sleep)
> -			seq_printf(s, ", can sleep");
> -		seq_printf(s, ":\n");
> -
> -		started = 1;
> -		if (chip->dbg_show)
> -			chip->dbg_show(s, chip);
> -		else
> -			gpiolib_dbg_show(s, chip);
> +		if (index++ >= *pos) {
> +			ret = chip;
> +			break;
> +		}
>  	}
> +
> +	s->private = "";
> +
> +	return ret;
> +}
> +
> +static void *gpiolib_seq_next(struct seq_file *s, void *v, loff_t *pos)
> +{
> +	struct gpio_chip *chip = v;
> +	unsigned int gpio;
> +	void *ret = NULL;
> +
> +	/* skip GPIOs provided by the current chip */
> +	for (gpio = chip->base + chip->ngpio; gpio_is_valid(gpio); gpio++) {
> +		chip = gpio_desc[gpio].chip;
> +		if (chip) {
> +			ret = chip;
> +			break;
> +		}
> +	}
> +
> +	s->private = "\n";
> +	++*pos;
> +
> +	return ret;
> +}
> +
> +static void gpiolib_seq_stop(struct seq_file *s, void *v)
> +{
> +}
> +
> +static int gpiolib_seq_show(struct seq_file *s, void *v)
> +{
> +	struct gpio_chip *chip = v;
> +	struct device *dev;
> +
> +	seq_printf(s, "%sGPIOs %d-%d", (char *)s->private,
> +			chip->base, chip->base + chip->ngpio - 1);
> +	dev = chip->dev;
> +	if (dev)
> +		seq_printf(s, ", %s/%s", dev->bus ? dev->bus->name : "no-bus",
> +			dev_name(dev));
> +	if (chip->label)
> +		seq_printf(s, ", %s", chip->label);
> +	if (chip->can_sleep)
> +		seq_printf(s, ", can sleep");
> +	seq_printf(s, ":\n");
> +
> +	if (chip->dbg_show)
> +		chip->dbg_show(s, chip);
> +	else
> +		gpiolib_dbg_show(s, chip);
> +
>  	return 0;
>  }
>  
> +static const struct seq_operations gpiolib_seq_ops = {
> +	.start = gpiolib_seq_start,
> +	.next = gpiolib_seq_next,
> +	.stop = gpiolib_seq_stop,
> +	.show = gpiolib_seq_show,
> +};
> +
>  static int gpiolib_open(struct inode *inode, struct file *file)
>  {
> -	return single_open(file, gpiolib_show, NULL);
> +	return seq_open(file, &gpiolib_seq_ops);
>  }
>  
>  static const struct file_operations gpiolib_operations = {
> +	.owner		= THIS_MODULE,
>  	.open		= gpiolib_open,
>  	.read		= seq_read,
>  	.llseek		= seq_lseek,
> -	.release	= single_release,
> +	.release	= seq_release,
>  };
>  
>  static int __init gpiolib_debugfs_init(void)
> -- 
> 1.7.10
> 

-- 
Grant Likely, B.Sc, P.Eng.
Secret Lab Technologies, Ltd.
