Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753267Ab2KTN0I (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Nov 2012 08:26:08 -0500
Received: from moutng.kundenserver.de ([212.227.17.9]:49440 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752250Ab2KTN0G (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Nov 2012 08:26:06 -0500
From: Arnd Bergmann <arnd@arndb.de>
To: Lars Poeschel <larsi@wh2.tu-dresden.de>
Subject: Re: [PATCH] video console: add a driver for lcd2s character display
Date: Tue, 20 Nov 2012 13:25:57 +0000
User-Agent: KMail/1.12.2 (Linux/3.5.0; KDE/4.3.2; x86_64; ; )
Cc: FlorianSchandinat@gmx.de, poeschel@lemonage.de, mathieu.poirier@linaro.org,
        linux-fbdev@vger.kernel.org, linux-kernel@vger.kernel.org
References: <1353416206-3243-1-git-send-email-larsi@wh2.tu-dresden.de>
In-Reply-To: <1353416206-3243-1-git-send-email-larsi@wh2.tu-dresden.de>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Message-Id: <201211201325.57883.arnd@arndb.de>
X-Provags-ID: V02:K0:e5sKKj4Wbq+XjlrV35tvFqu49AsFRaa9CjxOx9zYQNj
 64DqaipyTVdjkOqphXlIdYEblbc2LEppOh4XgTpg5esyEM5qzU
 byyFlXpEBi9iAXSTf5OlQQ28FUgEjHkBbGx4ry9d7B45U5+wUo
 27K+WamDWOYCEbmR6bz3xS7WQ8fXKejZNqztxhfAUufRgjcMxW
 xolTomJPa4Ez/H4tGGKBwEAvSpQB47ckQsxdSCnwD9ki2AMcku
 WBC/mHXtM2WhvjHffG90/L95I2SLqszcOnWqGPux6AtabUfOnR
 LRRiZdhikraVBmmtdnaGiQbbtsqKkDINeeW2n7qUXDKsRsOcYn
 1pmDdqkl6LJ/XAA4Rttk=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 20 November 2012, Lars Poeschel wrote:
> From: Lars Poeschel <poeschel@lemonage.de>
> 
> This driver allows to use a lcd2s 20x4 character display as
> a linux console output device.
> 
> Signed-off-by: Lars Poeschel <poeschel@lemonage.de>

The driver looks nice overall, but I found two style issues:

> +static int __devinit lcd2s_i2c_probe(struct i2c_client *i2c,
> +				const struct i2c_device_id *id)
> +{
> +	struct lcd2s_data *data;
> +
> +	if (!i2c_check_functionality(i2c->adapter,
> +			I2C_FUNC_SMBUS_BYTE_DATA | I2C_FUNC_SMBUS_WORD_DATA))
> +		return -EIO;
> +	data = devm_kzalloc(&i2c->dev, sizeof(struct lcd2s_data), GFP_KERNEL);
> +	if (!data)
> +		return -ENOMEM;
> +
> +	data->i2c = i2c;
> +	data->consw.owner		= THIS_MODULE;
> +	data->consw.con_startup		= lcd2s_startup;
> +	data->consw.con_init		= lcd2s_init;
> +	data->consw.con_deinit		= lcd2s_deinit;
> +	data->consw.con_clear		= lcd2s_clear;
> +	data->consw.con_putc		= lcd2s_putc;
> +	data->consw.con_putcs		= lcd2s_putcs;
> +	data->consw.con_cursor		= lcd2s_cursor;
> +	data->consw.con_scroll		= lcd2s_scroll;
> +	data->consw.con_bmove		= lcd2s_bmove;
> +	data->consw.con_switch		= lcd2s_switch;
> +	data->consw.con_blank		= lcd2s_blank;
> +	data->consw.con_set_palette	= lcd2s_set_palette;
> +	data->consw.con_scrolldelta	= lcd2s_scrolldelta;
> +
> +	i2c_set_clientdata(i2c, data);
> +
> +	take_over_console(&data->consw, LCD2S_FIRST, LCD2S_LAST, 1);
> +
> +	return 0;
> +}

It's better to define the struct consw as a preinitialized
'static const' object, rather than dynamically setting each
member.

> +static struct i2c_driver lcd2s_i2c_driver = {
> +	.driver = {
> +		.name = "lcd2s",
> +		.owner = THIS_MODULE,
> +	},
> +	.probe = lcd2s_i2c_probe,
> +	.remove = __devexit_p(lcd2s_i2c_remove),
> +	.id_table = lcd2s_i2c_id,
> +};
> +
> +static int __init lcd2s_modinit(void)
> +{
> +	int ret = 0;
> +
> +	ret = i2c_add_driver(&lcd2s_i2c_driver);
> +	if (ret != 0)
> +		pr_err("Failed to register lcd2s driver\n");
> +
> +	return ret;
> +}
> +module_init(lcd2s_modinit)
> +
> +static void __exit lcd2s_exit(void)
> +{
> +	i2c_del_driver(&lcd2s_i2c_driver);
> +}
> +module_exit(lcd2s_exit)

Here, you can use module_i2c_driver.

	Arnd

