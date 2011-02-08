Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755633Ab1BHWyl (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Feb 2011 17:54:41 -0500
Received: from smtpq1.gn.mail.iss.as9143.net ([212.54.34.164]:54425 "EHLO
	smtpq1.gn.mail.iss.as9143.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753834Ab1BHWyk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Feb 2011 17:54:40 -0500
Message-ID: <4D51C9A9.4060306@home.nl>
Date: Tue, 08 Feb 2011 23:54:33 +0100
From: Walter Goossens <waltergoossens@home.nl>
User-Agent: Mozilla/5.0 (Macintosh; U; Intel Mac OS X 10.6; en-US; rv:1.9.2.13) Gecko/20101207 Lightning/1.0b2 Thunderbird/3.1.7
MIME-Version: 1.0
To: nios2-dev@sopc.et.ntust.edu.tw
CC: Tobias Klauser <tklauser@distanz.ch>, Wim Van Sebroeck <wim@iguana.be>,
        linux-watchdog@vger.kernel.org,
        Grant Likely <grant.likely@secretlab.ca>,
        devicetree-discuss@lists.ozlabs.org, linux-kernel@vger.kernel.org
Subject: Re: [Nios2-dev] [PATCH v2] watchdog: Add driver for Altera Watchdog
 Timer
References: <1294829027-15029-1-git-send-email-tklauser@distanz.ch> <1297171322-32401-1-git-send-email-tklauser@distanz.ch>
In-Reply-To: <1297171322-32401-1-git-send-email-tklauser@distanz.ch>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-ZiggoSMTP-MailScanner-Information: Please contact the ISP for more information
X-ZiggoSMTP-MailScanner-ID: 1PmwSC-00056f-Qf
X-ZiggoSMTP-MailScanner: Found to be clean
X-ZiggoSMTP-MailScanner-SpamCheck: geen spam, SpamAssassin (niet cached,
	score=0.318, vereist 5, ALL_TRUSTED -1.00, BAYES_00 -1.90,
	CM_META_TB_NOARR 0.50, HELO_LH_HOME 1.74, RDNS_DYNAMIC 0.98)
X-ZiggoSMTP-MailScanner-From: waltergoossens@home.nl
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Tobias,

One small remark below, looks ok otherwise.
Thanks for the work you put into this!

On 2/8/11 2:22 PM, Tobias Klauser wrote:
[...]
> +static struct miscdevice altera_wdt_miscdev = {
> +	.minor	= WATCHDOG_MINOR,
> +	.name	= "watchdog",
> +	.fops	=&altera_wdt_fops,
> +};
> +
> +static int __devinit altera_wdt_probe(struct platform_device *pdev)
> +{
> +	struct resource *res, *mem;
> +	const u32 *freq_prop, *timeout_prop;
Type should be const __be32 * here.
> +	unsigned long timeout;
> +	int ret;
> +
> +	res = platform_get_resource(pdev, IORESOURCE_MEM, 0);
> +	if (!res)
> +		return -ENOENT;
> +
> +	mem = devm_request_mem_region(&pdev->dev, res->start,
> +				      resource_size(res), pdev->name);
> +	if (!mem)
> +		return -EBUSY;
> +
> +	altera_wdt_priv.base = devm_ioremap_nocache(&pdev->dev, mem->start,
> +						    resource_size(mem));
> +	if (!altera_wdt_priv.base)
> +		return -ENOMEM;
> +
> +	freq_prop = of_get_property(pdev->dev.of_node, "clock-frequency", NULL);
> +	if (!freq_prop)
> +		return -ENODEV;
> +
> +	timeout_prop = of_get_property(pdev->dev.of_node, "timeout", NULL);
> +	if (!timeout_prop)
> +		return -ENODEV;
> +
> +	/* Add 1 as the timeout property actually holds the load value */
> +	timeout = be32_to_cpup(timeout_prop) + 1;
> +	/* Convert timeout to msecs */
> +	timeout = timeout / (be32_to_cpup(freq_prop) / MSEC_PER_SEC);
> +	/* Tickle the watchdog twice per timeout period */
> +	altera_wdt_priv.wdt_timeout = msecs_to_jiffies(timeout / 2);
> +
> +	ret = misc_register(&altera_wdt_miscdev);
> +	if (ret)
> +		return ret;
> +
> +	altera_wdt_setup();
> +	altera_wdt_priv.next_heartbeat = jiffies + heartbeat * HZ;
> +	setup_timer(&altera_wdt_priv.timer, altera_wdt_ping, 0);
> +	mod_timer(&altera_wdt_priv.timer, jiffies + altera_wdt_priv.wdt_timeout);
> +
> +	pr_info(WATCHDOG_NAME " enabled (heartbeat=%d sec, nowayout=%d)\n",
> +		heartbeat, nowayout);
> +
> +	return 0;
> +}
> +
> +static int __devexit altera_wdt_remove(struct platform_device *pdev)
> +{
> +	misc_deregister(&altera_wdt_miscdev);
> +	return 0;
> +}
> +
> +static struct of_device_id altera_wdt_match[] = {
> +	{ .compatible = "ALTR,wdt-1.0", },
> +	{},
> +};
> +MODULE_DEVICE_TABLE(of, altera_wdt_match);
> +
> +static struct platform_driver altera_wdt_driver = {
> +	.probe		= altera_wdt_probe,
> +	.remove		= __devexit_p(altera_wdt_remove),
> +	.driver		= {
> +		.owner		= THIS_MODULE,
> +		.name		= WATCHDOG_NAME,
> +		.of_match_table	= altera_wdt_match,
> +	},
> +};
> +
> +static int __init altera_wdt_init(void)
> +{
> +	return platform_driver_register(&altera_wdt_driver);
> +}
> +
> +static void __exit altera_wdt_exit(void)
> +{
> +	platform_driver_unregister(&altera_wdt_driver);
> +}
> +
> +module_init(altera_wdt_init);
> +module_exit(altera_wdt_exit);
> +
> +MODULE_AUTHOR("Walter Goossens, Tobias Klauser<tklauser@distanz.ch>");
> +MODULE_DESCRIPTION("Driver for Altera Watchdog Timer");
> +MODULE_LICENSE("GPL");
> +MODULE_ALIAS_MISCDEV(WATCHDOG_MINOR);
> +MODULE_ALIAS("platform:" WATCHDOG_NAME);

