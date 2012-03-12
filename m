Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757954Ab2CLWvP (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Mar 2012 18:51:15 -0400
Received: from csmtp3.one.com ([91.198.169.23]:9029 "EHLO csmtp3.one.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752534Ab2CLWvN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Mar 2012 18:51:13 -0400
Date: Mon, 12 Mar 2012 23:53:02 +0100
From: Eric Andersson <eric.andersson@unixphere.com>
To: Arnd Bergmann <arnd@arndb.de>
Cc: linux-kernel@vger.kernel.org, gregkh@linuxfoundation.org,
        alan@lxorguk.ukuu.org.uk, zhengguang.guo@bosch-sensortec.com,
        peter.moeller@cn.bosch.com,
        Stefan Nilsson <stefan.nilsson@unixphere.com>
Subject: Re: [PATCHv2 1/3] misc: clean up bmp085 driver
Message-ID: <20120312225301.GA16648@skinner.xfiles.lan>
References: <1331068084-17911-1-git-send-email-eric.andersson@unixphere.com>
 <1331068084-17911-2-git-send-email-eric.andersson@unixphere.com>
 <201203062120.47953.arnd@arndb.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <201203062120.47953.arnd@arndb.de>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 21:20 Tue 06 Mar     , Arnd Bergmann wrote:
> On Tuesday 06 March 2012, Eric Andersson wrote:
> > This patch includes various cleaning of the bmp085 driver including:
> > - Addition of platform_data and header file
> > - Implement pm functions
> > - Whitespaces and alignment fixes
> > - Minor typos
> > - Consistency fixes
> > 
> > Reviewed-by: Stefan Nilsson <stefan.nilsson@unixphere.com>
> > Signed-off-by: Eric Andersson <eric.andersson@unixphere.com>
> 
> Most of the cleanups look good, just a few things that stick out:
> 
> >  static int __devinit bmp085_probe(struct i2c_client *client,
> > -			 const struct i2c_device_id *id)
> > +			const struct i2c_device_id *id)
> >  {
> >  	struct bmp085_data *data;
> > +	struct bmp085_platform_data *pdata = client->dev.platform_data;
> > +	u8 chip_id = (pdata && pdata->chip_id) ? pdata->chip_id :
> > +						 BMP085_CHIP_ID;
> >  	int err = 0;
> >  
> > +	if (pdata && pdata->init_hw) {
> > +		err = pdata->init_hw(&client->dev);
> > +		if (err) {
> > +			dev_err(&client->dev, "%s: init_hw failed!\n",
> > +				BMP085_NAME);
> > +			return err;
> > +		}
> > +	}
> > +
> 
> The addition of platform_data does not look like a cleanup to me,
> it's a significant change in the interface to the platform, so I
> would put it into a separate patch.

Yes, I agree.

> > +	if (i2c_smbus_read_byte_data(client, BMP085_CHIP_ID_REG) != chip_id) {
> > +		dev_err(&client->dev, "%s: chip_id failed!\n", BMP085_NAME);
> > +		err = -ENODEV;
> > +		goto exit_free;
> > +	}
> > +
> 
> This part looks like it belongs into the second patch where you add support
> for more than one chip id.
> 
> > diff --git a/include/linux/i2c/bmp085.h b/include/linux/i2c/bmp085.h
> > new file mode 100644
> > index 0000000..e6fc752
> > --- /dev/null
> > +++ b/include/linux/i2c/bmp085.h
> 
> Since this file only adds platform_data, I think it should go into
> include/linux/platform_data/, not include/linux/i2c, and it should
> be in the same patch as the change to use the platform data when you
> split that out.
> 
> Also, which platforms are actually using this driver? I could
> not find any platform that defines a bmp085 platform_device. If this
> is for new ARM platforms, I would rather not add platform_data at
> all because those platforms will have to use device tree properties
> rather than platform_data to pass initialization data.

Platform device? This is a pressure sensor connected as a peripheral
device to the i2c bus. I don't think you will find any platform that
uses this "by default" in the tree.

Of course I can add of_get_property() calls, but what is actually the
long-term plan here for peripheral devices? Should they all abandon their
platform data in favor of devicetree? How should the callbacks in platform
data be handled, in my case pdata->init_hw()?

-- 
Best regards,
 Eric

http://www.unixphere.com
