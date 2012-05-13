Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752942Ab2EMM3u (ORCPT <rfc822;w@1wt.eu>);
	Sun, 13 May 2012 08:29:50 -0400
Received: from cassiel.sirena.org.uk ([80.68.93.111]:50325 "EHLO
	cassiel.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751421Ab2EMM3s (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 13 May 2012 08:29:48 -0400
Date: Sun, 13 May 2012 13:29:46 +0100
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Sebastian Hesselbarh <sebastian.hesselbarth@googlemail.com>
Cc: linux-kernel@vger.kernel.org, mturquette@ti.com
Subject: Re: [RFC] Common clock framework for external clock generators
Message-ID: <20120513122946.GD706@sirena.org.uk>
References: <4FAB15DB.5050702@googlemail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4FAB15DB.5050702@googlemail.com>
X-Cookie: I'm not proud.
User-Agent: Mutt/1.5.20 (2009-06-14)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: broonie@sirena.org.uk
X-SA-Exim-Scanned: No (on cassiel.sirena.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, May 10, 2012 at 03:11:55AM +0200, Sebastian Hesselbarh wrote:

Always CC maintainers on mails, things get lost on high volume lists.

> I recently read about the newly introduced common clock framework (ccf)
> and wondered if this could be also used for external, e.g. i2c attached,
> clock generators.

Yes, it should be able to be used for this.  I've been posting a driver
for the wm831x PMICs for quite some considerable time.

> static inline u8 si5351_reg_read(struct si5351_driver_data *data, u8 addr)
> {
> 	return (u8)i2c_smbus_read_byte_data(data->client, addr);
> }

I'd suggest using regmap for the cache support (which helps with
read/modify/write cycles) and because...

> static int si5351_xtal_enable(struct clk_hw *hw)
> {
> 	struct si5351_driver_data *sidata = 
> 		container_of(hw, struct si5351_driver_data, hw_xtal);
> 	u8 reg;
> 
> 	reg = si5351_reg_read(sidata, SI5351_FANOUT_ENABLE);
> 	reg |= SI5351_XTAL_ENABLE;
> 	si5351_reg_write(sidata, SI5351_FANOUT_ENABLE, reg);
> 	return 0;
> }

...we should be able to factor things like this out of the drivers using
regmap (we've been getting some great results doing that for regulator
over this release).

> static const struct clk_ops si5351_xtal_ops = {
> 	.enable = si5351_xtal_enable,
> 	.disable = si5351_xtal_disable,

These should be prepare() and unprepare() - enable() and disable() are
called from atomic context so you can't do I2C I/O.

> static u8 si5351_clkout_get_parent(struct clk_hw *hw)
> {
> 	struct si5351_driver_data *sidata = si5351_clkout_get_data(hw);
> 	return 0;
> }

If we need empty functions like this we should fix the framework.

> 	sidata = kzalloc(sizeof(struct si5351_driver_data), GFP_KERNEL);
> 	if (sidata == NULL) {
> 		dev_err(&client->dev, "unable to allocate driver data\n");
> 		return -ENOMEM;
> 	}

devm_kzalloc().
