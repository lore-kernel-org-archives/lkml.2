Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758264Ab2EVK6y (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 May 2012 06:58:54 -0400
Received: from comal.ext.ti.com ([198.47.26.152]:47265 "EHLO comal.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757978Ab2EVK6x convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 May 2012 06:58:53 -0400
From: "Jeong, Daniel" <Daniel.Jeong@ti.com>
To: Johan Hovold <jhovold@gmail.com>,
        Andrew Morton <akpm@linux-foundation.org>
CC: Richard Purdie <rpurdie@rpsys.net>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Wolfram Sang <w.sang@pengutronix.de>,
        Geon Si Jeong <gshark.jeong@gmail.com>
Subject: RE: [PATCH 1/1 v1] leds: Add LED driver for lm3556 chip
Thread-Topic: [PATCH 1/1 v1] leds: Add LED driver for lm3556 chip
Thread-Index: AQHNMsqjjif8xaDo/0SWR5gWZAVw15bVJQsAgACHX/A=
Date: Tue, 22 May 2012 10:58:33 +0000
Message-ID: <F0866C1C5ECEAF4CB380B619BD733BEAB2B0@DQHE02.ent.ti.com>
References: <1333936855-8807-1-git-send-email-gshark.jeong@gmail.com>
 <1333936855-8807-2-git-send-email-gshark.jeong@gmail.com>
 <20120515184330.GB5654@localhost> <20120522104806.GD7323@localhost>
In-Reply-To: <20120522104806.GD7323@localhost>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [172.16.34.32]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Andrew and Johan. 

Please drop it from current tree.
It will be replaced to "regmap"  and patched soon. 

Regards,
Daniel Jeong

-----Original Message-----
From: Johan Hovold [mailto:jhovold@gmail.com] 
Sent: Tuesday, May 22, 2012 7:48 PM
To: Andrew Morton
Cc: Richard Purdie; Jeong, Daniel; linux-kernel@vger.kernel.org; Wolfram Sang; Geon Si Jeong
Subject: Re: [PATCH 1/1 v1] leds: Add LED driver for lm3556 chip

On Tue, May 15, 2012 at 08:43:30PM +0200, Johan Hovold wrote:
> On Mon, Apr 09, 2012 at 11:00:55AM +0900, Geon Si Jeong wrote:
> > It is a simple driver for LM3556 Chip(Texas Instruments)
> > LM3556 :
> > The LM3556 is a 4 MHz fixed-frequency synchronous boost converter 
> > plus 1.5A constant current driver for a high-current white LED.
> > Datasheet: www.national.com/ds/LM/LM3556.pdf
> > 
> > Tested on OMAP4430
> > 
> > Signed-off-by: Geon Si Jeong <gshark.jeong@gmail.com>
> 
> [...]
> 
> > +/* i2c access*/
> > +static int lm3556_read_reg(struct i2c_client *client, u8 reg, u8 * 
> > +val) {
> > +	int ret;
> > +
> > +	ret = i2c_smbus_read_byte_data(client, reg);
> > +	if (ret < 0) {
> > +		dev_err(&client->dev, "i2c reading fail at 0x%02x error %d\n",
> > +			reg, ret);
> > +		return ret;
> > +	}
> > +	*val = ret & 0xff;
> > +	return ret;
> > +}
> > +
> > +static int lm3556_write_reg(struct i2c_client *client, u8 reg, u8 
> > +val) {
> > +	int ret = 0;
> > +
> > +	ret = i2c_smbus_write_byte_data(client, reg, val);
> > +
> > +	if (ret < 0)
> > +		dev_err(&client->dev, "i2c writting fail at 0x%02x\n", reg);
> > +	return ret;
> > +}
> > +
> > +static int lm3556_write_bits(struct i2c_client *client,
> > +			     u8 reg, u8 val, u8 mask, u8 shift) {
> > +	int ret;
> > +	u8 reg_val;
> > +	struct lm3556_chip_data *chip = i2c_get_clientdata(client);
> > +
> > +	mutex_lock(&chip->lock);
> > +	ret = lm3556_read_reg(client, reg, &reg_val);
> > +	if (ret < 0)
> > +		goto out;
> > +	reg_val &= (~(mask << shift));
> > +	reg_val |= ((val & mask) << shift);
> > +	ret = lm3556_write_reg(client, reg, reg_val);
> > +out:
> > +	mutex_unlock(&chip->lock);
> > +	return ret;
> > +}
> 
> The register io-locking above is broken. You need to protect both 
> write_reg and write_bits using the mutex (but you must restructure 
> your code because write_bits currently calls write_reg). This is 
> required to avoid register corruption due to concurrent write_reg and 
> write_bits.
> 
> As has been suggested elsewhere, you could consider using regmap.

Andrew, just wanted to remind you that this driver is still in your tree. Do you want to drop it or should someone else fix the locking?

Johan
