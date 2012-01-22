Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752175Ab2AVRG7 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 22 Jan 2012 12:06:59 -0500
Received: from marvin.crapouillou.net ([109.190.12.102]:55754 "EHLO
	marvin.crapouillou.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751961Ab2AVRG5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 22 Jan 2012 12:06:57 -0500
X-Greylist: delayed 1331 seconds by postgrey-1.27 at vger.kernel.org; Sun, 22 Jan 2012 12:06:57 EST
Message-ID: <4F1C3CF4.1000408@crapouillou.net>
Date: Sun, 22 Jan 2012 17:44:36 +0100
From: Paul Cercueil <paul@crapouillou.net>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:9.0) Gecko/20111222 Thunderbird/9.0.1
MIME-Version: 1.0
To: Axel Lin <axel.lin@gmail.com>
CC: linux-kernel@vger.kernel.org, Lars-Peter Clausen <lars@metafoo.de>,
        Wim Van Sebroeck <wim@iguana.be>, linux-watchdog@vger.kernel.org
Subject: Re: [RFC][PATCH] watchdog: Convert jz4740_wdt driver to watchdog
 core
References: <1327067054.15205.6.camel@phoenix>
In-Reply-To: <1327067054.15205.6.camel@phoenix>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Le 20/01/2012 14:44, Axel Lin a écrit :
> This patch converts jz4740_wdt driver to use watchdog core APIs.
> Also use devm_* APIs to save a few error handling code.
>
> Signed-off-by: Axel Lin<axel.lin@gmail.com>
> ---
> Hi Paul and Lars,
> I don't have this hardware handy.
> I'd appreciate if you can review and test this patch.
>
> Thanks,
> Axel

Acked-by: Paul Cercueil <paul@crapouillou.net>

I just tested on hardware, it works fine.
Thanks for the patch.


>
>   drivers/watchdog/Kconfig      |    1 +
>   drivers/watchdog/jz4740_wdt.c |  250 ++++++++++++++---------------------------
>   2 files changed, 86 insertions(+), 165 deletions(-)
>
> diff --git a/drivers/watchdog/Kconfig b/drivers/watchdog/Kconfig
> index 877b107..32d48b8 100644
> --- a/drivers/watchdog/Kconfig
> +++ b/drivers/watchdog/Kconfig
> @@ -955,6 +955,7 @@ config INDYDOG
>   config JZ4740_WDT
>   	tristate "Ingenic jz4740 SoC hardware watchdog"
>   	depends on MACH_JZ4740
> +	select WATCHDOG_CORE
>   	help
>   	  Hardware driver for the built-in watchdog timer on Ingenic jz4740 SoCs.
>
> diff --git a/drivers/watchdog/jz4740_wdt.c b/drivers/watchdog/jz4740_wdt.c
> index 17ef300..2cdb67f 100644
> --- a/drivers/watchdog/jz4740_wdt.c
> +++ b/drivers/watchdog/jz4740_wdt.c
> @@ -17,11 +17,9 @@
>   #include<linux/moduleparam.h>
>   #include<linux/types.h>
>   #include<linux/kernel.h>
> -#include<linux/fs.h>
>   #include<linux/miscdevice.h>
>   #include<linux/watchdog.h>
>   #include<linux/init.h>
> -#include<linux/bitops.h>
>   #include<linux/platform_device.h>
>   #include<linux/spinlock.h>
>   #include<linux/uaccess.h>
> @@ -29,6 +27,7 @@
>   #include<linux/device.h>
>   #include<linux/clk.h>
>   #include<linux/slab.h>
> +#include<linux/err.h>
>
>   #include<asm/mach-jz4740/timer.h>
>
> @@ -56,30 +55,45 @@
>   #define DEFAULT_HEARTBEAT 5
>   #define MAX_HEARTBEAT     2048
>
> -static struct {
> -	void __iomem *base;
> -	struct resource	*mem;
> -	struct clk *rtc_clk;
> -	unsigned long status;
> -} jz4740_wdt;
> +static int nowayout = WATCHDOG_NOWAYOUT;
> +module_param(nowayout, int, 0);
> +MODULE_PARM_DESC(nowayout,
> +		 "Watchdog cannot be stopped once started (default="
> +		 __MODULE_STRING(WATCHDOG_NOWAYOUT) ")");
>
>   static int heartbeat = DEFAULT_HEARTBEAT;
> +module_param(heartbeat, int, 0);
> +MODULE_PARM_DESC(heartbeat,
> +		"Watchdog heartbeat period in seconds from 1 to "
> +		__MODULE_STRING(MAX_HEARTBEAT) ", default "
> +		__MODULE_STRING(DEFAULT_HEARTBEAT));
>
> +struct jz4740_wdt_drvdata {
> +	struct watchdog_device wdt;
> +	void __iomem *base;
> +	struct resource	*mem;
> +	struct clk *rtc_clk;
> +};
>
> -static void jz4740_wdt_service(void)
> +static int jz4740_wdt_ping(struct watchdog_device *wdt_dev)
>   {
> -	writew(0x0, jz4740_wdt.base + JZ_REG_WDT_TIMER_COUNTER);
> +	struct jz4740_wdt_drvdata *drvdata = watchdog_get_drvdata(wdt_dev);
> +
> +	writew(0x0, drvdata->base + JZ_REG_WDT_TIMER_COUNTER);
> +	return 0;
>   }
>
> -static void jz4740_wdt_set_heartbeat(int new_heartbeat)
> +static int jz4740_wdt_set_heartbeat(struct watchdog_device *wdt_dev,
> +				    unsigned int new_heartbeat)
>   {
> +	struct jz4740_wdt_drvdata *drvdata = watchdog_get_drvdata(wdt_dev);
>   	unsigned int rtc_clk_rate;
>   	unsigned int timeout_value;
>   	unsigned short clock_div = JZ_WDT_CLOCK_DIV_1;
>
>   	heartbeat = new_heartbeat;
>
> -	rtc_clk_rate = clk_get_rate(jz4740_wdt.rtc_clk);
> +	rtc_clk_rate = clk_get_rate(drvdata->rtc_clk);
>
>   	timeout_value = rtc_clk_rate * heartbeat;
>   	while (timeout_value>  0xffff) {
> @@ -93,199 +107,112 @@ static void jz4740_wdt_set_heartbeat(int new_heartbeat)
>   		clock_div += (1<<  JZ_WDT_CLOCK_DIV_SHIFT);
>   	}
>
> -	writeb(0x0, jz4740_wdt.base + JZ_REG_WDT_COUNTER_ENABLE);
> -	writew(clock_div, jz4740_wdt.base + JZ_REG_WDT_TIMER_CONTROL);
> +	writeb(0x0, drvdata->base + JZ_REG_WDT_COUNTER_ENABLE);
> +	writew(clock_div, drvdata->base + JZ_REG_WDT_TIMER_CONTROL);
>
> -	writew((u16)timeout_value, jz4740_wdt.base + JZ_REG_WDT_TIMER_DATA);
> -	writew(0x0, jz4740_wdt.base + JZ_REG_WDT_TIMER_COUNTER);
> +	writew((u16)timeout_value, drvdata->base + JZ_REG_WDT_TIMER_DATA);
> +	writew(0x0, drvdata->base + JZ_REG_WDT_TIMER_COUNTER);
>   	writew(clock_div | JZ_WDT_CLOCK_RTC,
> -		jz4740_wdt.base + JZ_REG_WDT_TIMER_CONTROL);
> -
> -	writeb(0x1, jz4740_wdt.base + JZ_REG_WDT_COUNTER_ENABLE);
> -}
> +		drvdata->base + JZ_REG_WDT_TIMER_CONTROL);
>
> -static void jz4740_wdt_enable(void)
> -{
> -	jz4740_timer_enable_watchdog();
> -	jz4740_wdt_set_heartbeat(heartbeat);
> -}
> +	writeb(0x1, drvdata->base + JZ_REG_WDT_COUNTER_ENABLE);
>
> -static void jz4740_wdt_disable(void)
> -{
> -	jz4740_timer_disable_watchdog();
> -	writeb(0x0, jz4740_wdt.base + JZ_REG_WDT_COUNTER_ENABLE);
> +	return 0;
>   }
>
> -static int jz4740_wdt_open(struct inode *inode, struct file *file)
> +static int jz4740_wdt_start(struct watchdog_device *wdt_dev)
>   {
> -	if (test_and_set_bit(WDT_IN_USE,&jz4740_wdt.status))
> -		return -EBUSY;
> -
> -	jz4740_wdt_enable();
> +	jz4740_timer_enable_watchdog();
> +	jz4740_wdt_set_heartbeat(wdt_dev, heartbeat);
>
> -	return nonseekable_open(inode, file);
> +	return 0;
>   }
>
> -static ssize_t jz4740_wdt_write(struct file *file, const char *data,
> -		size_t len, loff_t *ppos)
> +static int jz4740_wdt_stop(struct watchdog_device *wdt_dev)
>   {
> -	if (len) {
> -		size_t i;
> -
> -		clear_bit(WDT_OK_TO_CLOSE,&jz4740_wdt.status);
> -		for (i = 0; i != len; i++) {
> -			char c;
> +	struct jz4740_wdt_drvdata *drvdata = watchdog_get_drvdata(wdt_dev);
>
> -			if (get_user(c, data + i))
> -				return -EFAULT;
> -
> -			if (c == 'V')
> -				set_bit(WDT_OK_TO_CLOSE,&jz4740_wdt.status);
> -		}
> -		jz4740_wdt_service();
> -	}
> +	jz4740_timer_disable_watchdog();
> +	writeb(0x0, drvdata->base + JZ_REG_WDT_COUNTER_ENABLE);
>
> -	return len;
> +	return 0;
>   }
>
> -static const struct watchdog_info ident = {
> -	.options = WDIOF_KEEPALIVEPING,
> +static const struct watchdog_info jz4740_wdt_info = {
> +	.options = WDIOF_SETTIMEOUT | WDIOF_KEEPALIVEPING | WDIOF_MAGICCLOSE,
>   	.identity = "jz4740 Watchdog",
>   };
>
> -static long jz4740_wdt_ioctl(struct file *file,
> -					unsigned int cmd, unsigned long arg)
> -{
> -	int ret = -ENOTTY;
> -	int heartbeat_seconds;
> -
> -	switch (cmd) {
> -	case WDIOC_GETSUPPORT:
> -		ret = copy_to_user((struct watchdog_info *)arg,&ident,
> -				sizeof(ident)) ? -EFAULT : 0;
> -		break;
> -
> -	case WDIOC_GETSTATUS:
> -	case WDIOC_GETBOOTSTATUS:
> -		ret = put_user(0, (int *)arg);
> -		break;
> -
> -	case WDIOC_KEEPALIVE:
> -		jz4740_wdt_service();
> -		return 0;
> -
> -	case WDIOC_SETTIMEOUT:
> -		if (get_user(heartbeat_seconds, (int __user *)arg))
> -			return -EFAULT;
> -
> -		jz4740_wdt_set_heartbeat(heartbeat_seconds);
> -		return 0;
> -
> -	case WDIOC_GETTIMEOUT:
> -		return put_user(heartbeat, (int *)arg);
> -
> -	default:
> -		break;
> -	}
> -
> -	return ret;
> -}
> -
> -static int jz4740_wdt_release(struct inode *inode, struct file *file)
> -{
> -	jz4740_wdt_service();
> -
> -	if (test_and_clear_bit(WDT_OK_TO_CLOSE,&jz4740_wdt.status))
> -		jz4740_wdt_disable();
> -
> -	clear_bit(WDT_IN_USE,&jz4740_wdt.status);
> -	return 0;
> -}
> -
> -static const struct file_operations jz4740_wdt_fops = {
> +static const struct watchdog_ops jz4740_wdt_ops = {
>   	.owner = THIS_MODULE,
> -	.llseek = no_llseek,
> -	.write = jz4740_wdt_write,
> -	.unlocked_ioctl = jz4740_wdt_ioctl,
> -	.open = jz4740_wdt_open,
> -	.release = jz4740_wdt_release,
> -};
> -
> -static struct miscdevice jz4740_wdt_miscdev = {
> -	.minor = WATCHDOG_MINOR,
> -	.name = "watchdog",
> -	.fops =&jz4740_wdt_fops,
> +	.start = jz4740_wdt_start,
> +	.stop = jz4740_wdt_stop,
> +	.ping = jz4740_wdt_ping,
> +	.set_timeout = jz4740_wdt_set_heartbeat,
>   };
>
>   static int __devinit jz4740_wdt_probe(struct platform_device *pdev)
>   {
> -	int ret = 0, size;
> -	struct resource *res;
> -	struct device *dev =&pdev->dev;
> -
> -	res = platform_get_resource(pdev, IORESOURCE_MEM, 0);
> -	if (res == NULL) {
> -		dev_err(dev, "failed to get memory region resource\n");
> -		return -ENXIO;
> +	struct jz4740_wdt_drvdata *drvdata;
> +	struct watchdog_device *jz4740_wdt;
> +	int ret;
> +
> +	drvdata = devm_kzalloc(&pdev->dev, sizeof(struct jz4740_wdt_drvdata),
> +			       GFP_KERNEL);
> +	if (!drvdata) {
> +		dev_err(&pdev->dev, "Unable to alloacate watchdog device\n");
> +		return -ENOMEM;
>   	}
>
> -	size = resource_size(res);
> -	jz4740_wdt.mem = request_mem_region(res->start, size, pdev->name);
> -	if (jz4740_wdt.mem == NULL) {
> -		dev_err(dev, "failed to get memory region\n");
> -		return -EBUSY;
> +	jz4740_wdt =&drvdata->wdt;
> +	jz4740_wdt->info =&jz4740_wdt_info;
> +	jz4740_wdt->ops =&jz4740_wdt_ops;
> +	watchdog_set_nowayout(jz4740_wdt, nowayout);
> +	watchdog_set_drvdata(jz4740_wdt, drvdata);
> +
> +	drvdata->mem = platform_get_resource(pdev, IORESOURCE_MEM, 0);
> +	if (drvdata->mem == NULL) {
> +		dev_err(&pdev->dev, "failed to get memory region resource\n");
> +		return -ENXIO;
>   	}
>
> -	jz4740_wdt.base = ioremap_nocache(res->start, size);
> -	if (jz4740_wdt.base == NULL) {
> -		dev_err(dev, "failed to map memory region\n");
> +	drvdata->base = devm_request_and_ioremap(&pdev->dev, drvdata->mem);
> +	if (drvdata->base == NULL) {
>   		ret = -EBUSY;
> -		goto err_release_region;
> +		goto err_out;
>   	}
>
> -	jz4740_wdt.rtc_clk = clk_get(NULL, "rtc");
> -	if (IS_ERR(jz4740_wdt.rtc_clk)) {
> -		dev_err(dev, "cannot find RTC clock\n");
> -		ret = PTR_ERR(jz4740_wdt.rtc_clk);
> -		goto err_iounmap;
> +	drvdata->rtc_clk = clk_get(NULL, "rtc");
> +	if (IS_ERR(drvdata->rtc_clk)) {
> +		dev_err(&pdev->dev, "cannot find RTC clock\n");
> +		ret = PTR_ERR(drvdata->rtc_clk);
> +		goto err_out;
>   	}
>
> -	ret = misc_register(&jz4740_wdt_miscdev);
> -	if (ret<  0) {
> -		dev_err(dev, "cannot register misc device\n");
> +	ret = watchdog_register_device(&drvdata->wdt);
> +	if (ret<  0)
>   		goto err_disable_clk;
> -	}
>
> +	platform_set_drvdata(pdev, drvdata);
>   	return 0;
>
>   err_disable_clk:
> -	clk_put(jz4740_wdt.rtc_clk);
> -err_iounmap:
> -	iounmap(jz4740_wdt.base);
> -err_release_region:
> -	release_mem_region(jz4740_wdt.mem->start,
> -			resource_size(jz4740_wdt.mem));
> +	clk_put(drvdata->rtc_clk);
> +err_out:
>   	return ret;
>   }
>
> -
>   static int __devexit jz4740_wdt_remove(struct platform_device *pdev)
>   {
> -	jz4740_wdt_disable();
> -	misc_deregister(&jz4740_wdt_miscdev);
> -	clk_put(jz4740_wdt.rtc_clk);
> -
> -	iounmap(jz4740_wdt.base);
> -	jz4740_wdt.base = NULL;
> +	struct jz4740_wdt_drvdata *drvdata = platform_get_drvdata(pdev);
>
> -	release_mem_region(jz4740_wdt.mem->start,
> -				resource_size(jz4740_wdt.mem));
> -	jz4740_wdt.mem = NULL;
> +	jz4740_wdt_stop(&drvdata->wdt);
> +	watchdog_unregister_device(&drvdata->wdt);
> +	clk_put(drvdata->rtc_clk);
>
>   	return 0;
>   }
>
> -
>   static struct platform_driver jz4740_wdt_driver = {
>   	.probe = jz4740_wdt_probe,
>   	.remove = __devexit_p(jz4740_wdt_remove),
> @@ -299,13 +226,6 @@ module_platform_driver(jz4740_wdt_driver);
>
>   MODULE_AUTHOR("Paul Cercueil<paul@crapouillou.net>");
>   MODULE_DESCRIPTION("jz4740 Watchdog Driver");
> -
> -module_param(heartbeat, int, 0);
> -MODULE_PARM_DESC(heartbeat,
> -		"Watchdog heartbeat period in seconds from 1 to "
> -		__MODULE_STRING(MAX_HEARTBEAT) ", default "
> -		__MODULE_STRING(DEFAULT_HEARTBEAT));
> -
>   MODULE_LICENSE("GPL");
>   MODULE_ALIAS_MISCDEV(WATCHDOG_MINOR);
>   MODULE_ALIAS("platform:jz4740-wdt");

