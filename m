Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932251Ab2JCODR (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Oct 2012 10:03:17 -0400
Received: from mail.savoirfairelinux.com ([209.172.62.77]:35112 "EHLO
	mail.savoirfairelinux.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755630Ab2JCODQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Oct 2012 10:03:16 -0400
Message-ID: <1349272988.9436.20.camel@trivette>
Subject: Re: [PATCH v4 2/2] hwmon: (ads7828) add support for ADS7830
From: Vivien Didelot <vivien.didelot@savoirfairelinux.com>
To: Guenter Roeck <linux@roeck-us.net>
Cc: lm-sensors@lm-sensors.org,
        Guillaume Roguez <guillaume.roguez@savoirfairelinux.com>,
        Jean Delvare <khali@linux-fr.org>, linux-kernel@vger.kernel.org,
        Steve Hardy <shardy@redhat.com>
Date: Wed, 03 Oct 2012 10:03:08 -0400
In-Reply-To: <20121003050739.GB7491@roeck-us.net>
References: <1349235207-7517-1-git-send-email-vivien.didelot@savoirfairelinux.com>
	 <1349235207-7517-2-git-send-email-vivien.didelot@savoirfairelinux.com>
	 <20121003050739.GB7491@roeck-us.net>
Organization: Savoir-faire Linux Inc.
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.4.4 (3.4.4-2.fc17) 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Guenter,

On Tue, 2012-10-02 at 22:07 -0700, Guenter Roeck wrote:
> On Tue, Oct 02, 2012 at 11:33:27PM -0400, Vivien Didelot wrote:
> > From: Guillaume Roguez <guillaume.roguez@savoirfairelinux.com>
> > 
> > The ADS7830 device is almost the same as the ADS7828,
> > except that it does 8-bit sampling, instead of 12-bit.
> > This patch extends the ads7828 driver to support this chip.
> > 
> > Signed-off-by: Guillaume Roguez <guillaume.roguez@savoirfairelinux.com>
> > Signed-off-by: Vivien Didelot <vivien.didelot@savoirfairelinux.com>
> 
> Guillaume,
> Vivien,
> 
> [ ... ]
> 
> > @@ -147,6 +152,7 @@ static int ads7828_detect(struct i2c_client *client,
> >  {
> >  	struct i2c_adapter *adapter = client->adapter;
> >  	u8 default_cmd_byte = ADS7828_CMD_SD_SE | ADS7828_CMD_PD3;
> > +	bool is_8bit = false;
> >  	int ch;
> >  
> >  	/* Check we have a valid client */
> > @@ -158,7 +164,9 @@ static int ads7828_detect(struct i2c_client *client,
> >  	 * dedicated register so attempt to sanity check using knowledge of
> >  	 * the chip
> >  	 * - Read from the 8 channel addresses
> > -	 * - Check the top 4 bits of each result are not set (12 data bits)
> > +	 * - Check the top 4 bits of each result:
> > +	 *   - They should not be set in case of 12-bit samples
> > +	 *   - The two bytes should be equal in case of 8-bit samples
> >  	 */
> >  	for (ch = 0; ch < ADS7828_NCH; ch++) {
> >  		u8 cmd = ads7828_cmd_byte(default_cmd_byte, ch);
> > @@ -168,13 +176,20 @@ static int ads7828_detect(struct i2c_client *client,
> >  			return -ENODEV;
> >  
> >  		if (in_data & 0xF000) {
> > -			pr_debug("%s : Doesn't look like an ads7828 device\n",
> > -				 __func__);
> > -			return -ENODEV;
> > +			if ((in_data >> 8) == (in_data & 0xFF)) {
> > +				/* Seems to be an ADS7830 (8-bit sample) */
> > +				is_8bit = true;
> > +			} else {
> > +				dev_dbg(&client->dev, "doesn't look like an ADS7828 compatible device\n");
> > +				return -ENODEV;
> > +			}
> >  		}
> >  	}
> 
> I have been thinking about this. The detection function is already quite weak,
> and this makes it even weaker. Reason is that you conly check for ADS7830 if the
> check for ADS7828 failed, and you repeat the pattern for each channel.
> Unfortunately, that means that you don't check for the ADS7830 condition if the
> value returned for a channel happens to be a valid ADS7828 value, even if it is
> not valid for ADS7830 (and even if you already know that the chip is not a
> ADS7828).
> 
> Example:
> 	ch=0: 0x1818	--> You know it is not ADS7828
> 	ch=1: 0x0818	--> You know it is not ADS7830, but you don't check for it
> 
> I don't know an optimal solution right now, but maybe something like
> 
>  	maybe_7828 = true;
> 	maybe_7830 = true;
> 	for (ch = 0; ch < ADS7828_NCH && (maybe_7828 || maybe_7830); ch++) {
> 		...
> 		if (in_data & 0xF000)
> 			maybe_7828 = false;
> 		if ((in_data >> 8) != (in_data & 0xFF))
> 			maybe_7830 = false;
> 	}
> 	if (!maybe_7828 && !maybe_7830)
> 		return -ENODEV;
> 
> 	if (maybe_7828)
> 		strlcpy(info->type, "ads7828", I2C_NAME_SIZE);
> 	else
> 		strlcpy(info->type, "ads7830", I2C_NAME_SIZE);
> 
> Frankly I would prefer to get rid of the _detect function entirely, I just don't
> know if that would negatively affect some users. To give you an example for a
> bad result: The function will wrongly detect an ADS7830 as ADS7828 if all ADC
> channels report a value between 0x00 and 0x0f.

We totally agree with you here. There is no clean way to detect (i.e. to
be sure) that this *is* an ADS7828 compatible device.

> How do you use the chip ? Do you need the detect function in your application ?

In our application, this device is statically declared in the platform
support code, so we don't need to "detect" it.

I propose to re-send a v5 with the "s/u16 in_data/int in_data/" fix and
the ads7828_detect() removal in the first cleanup patch, then the
ADS7830 support. Does it sound good for you?

Thanks,
Vivien

