Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752670Ab2KTOVH (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Nov 2012 09:21:07 -0500
Received: from smtp1.goneo.de ([212.90.139.80]:46538 "EHLO smtp1.goneo.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751198Ab2KTOVE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Nov 2012 09:21:04 -0500
X-Spam-Flag: NO
X-Spam-Score: -2.661
From: Lars Poeschel <poeschel@lemonage.de>
To: Arnd Bergmann <arnd@arndb.de>
Subject: Re: [PATCH] video console: add a driver for lcd2s character display
Date: Tue, 20 Nov 2012 15:21:33 +0100
User-Agent: KMail/1.13.7 (Linux/3.2.0-4-amd64; KDE/4.8.4; x86_64; ; )
Cc: Lars Poeschel <larsi@wh2.tu-dresden.de>, FlorianSchandinat@gmx.de,
        mathieu.poirier@linaro.org, linux-fbdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
References: <1353416206-3243-1-git-send-email-larsi@wh2.tu-dresden.de> <201211201325.57883.arnd@arndb.de>
In-Reply-To: <201211201325.57883.arnd@arndb.de>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Message-Id: <201211201521.33726.poeschel@lemonage.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 20 November 2012 at 14:25:57, Arnd Bergmann wrote:
> On Tuesday 20 November 2012, Lars Poeschel wrote:
> > From: Lars Poeschel <poeschel@lemonage.de>
> > 
> > This driver allows to use a lcd2s 20x4 character display as
> > a linux console output device.
> > 
> > Signed-off-by: Lars Poeschel <poeschel@lemonage.de>
> 
> The driver looks nice overall, but I found two style issues:

Thank you for your feedback.

> > +static int __devinit lcd2s_i2c_probe(struct i2c_client *i2c,
> > +				const struct i2c_device_id *id)
> > +{
> > +	struct lcd2s_data *data;
> > +
> > +	if (!i2c_check_functionality(i2c->adapter,
> > +			I2C_FUNC_SMBUS_BYTE_DATA | I2C_FUNC_SMBUS_WORD_DATA))
> > +		return -EIO;
> > +	data = devm_kzalloc(&i2c->dev, sizeof(struct lcd2s_data), 
GFP_KERNEL);
> > +	if (!data)
> > +		return -ENOMEM;
> > +
> > +	data->i2c = i2c;
> > +	data->consw.owner		= THIS_MODULE;
> > +	data->consw.con_startup		= lcd2s_startup;
> > +	data->consw.con_init		= lcd2s_init;
> > +	data->consw.con_deinit		= lcd2s_deinit;
> > +	data->consw.con_clear		= lcd2s_clear;
> > +	data->consw.con_putc		= lcd2s_putc;
> > +	data->consw.con_putcs		= lcd2s_putcs;
> > +	data->consw.con_cursor		= lcd2s_cursor;
> > +	data->consw.con_scroll		= lcd2s_scroll;
> > +	data->consw.con_bmove		= lcd2s_bmove;
> > +	data->consw.con_switch		= lcd2s_switch;
> > +	data->consw.con_blank		= lcd2s_blank;
> > +	data->consw.con_set_palette	= lcd2s_set_palette;
> > +	data->consw.con_scrolldelta	= lcd2s_scrolldelta;
> > +
> > +	i2c_set_clientdata(i2c, data);
> > +
> > +	take_over_console(&data->consw, LCD2S_FIRST, LCD2S_LAST, 1);
> > +
> > +	return 0;
> > +}
> 
> It's better to define the struct consw as a preinitialized
> 'static const' object, rather than dynamically setting each
> member.

I could not find a place to store the drivers private data inside the struct 
vc_data. I wanted to have the struct consw inside the drivers private data 
(struct lcd2s_data) to be able to container_of to the drivers private data in 
the consw.con_* functions. This makes it possible to use more than one actual 
lcd2s display with the same driver. Otherwise I have to store the struct 
i2c_client somewhere statically and the driver can control only one display 
and has to forbid to be probed a second time. Or am I wrong somewhere ?

Lars
