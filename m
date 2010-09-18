Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754423Ab0IRBiB (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Sep 2010 21:38:01 -0400
Received: from trinity.fluff.org ([89.16.178.74]:59434 "EHLO trinity.fluff.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752179Ab0IRBh7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Sep 2010 21:37:59 -0400
Date: Sat, 18 Sep 2010 02:37:54 +0100
From: Ben Dooks <ben-i2c@fluff.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Minkyu Kang <mk7.kang@samsung.com>, linux-kernel@vger.kernel.org,
        linux-i2c@vger.kernel.org, kyungmin.park@samsung.com,
        Greg KH <greg@kroah.com>
Subject: Re: [PATCH] misc: adds support the FSA9480 USB Switch
Message-ID: <20100918013753.GE7494@trinity.fluff.org>
References: <4C7CD95A.5040309@samsung.com> <20100917150731.f1f44f3c.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100917150731.f1f44f3c.akpm@linux-foundation.org>
X-Disclaimer: These are my views alone.
X-URL: http://www.fluff.org/
User-Agent: Mutt/1.5.18 (2008-05-17)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: ben@trinity.fluff.org
X-SA-Exim-Scanned: No (on trinity.fluff.org); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Sep 17, 2010 at 03:07:31PM -0700, Andrew Morton wrote:
> (catching up!)
> 
> On Tue, 31 Aug 2010 19:28:42 +0900
> Minkyu Kang <mk7.kang@samsung.com> wrote:
> 
> > The FSA9480 is a USB port accessory detector and switch.
> > This patch adds support the FSA9480 USB Switch.
> > 
> 
> What a strange device.
> 
> Is there a data sheet available?
> 
> > +config USB_SWITCH_FSA9480
> > +	tristate "FSA9480 USB Switch"
> > +	depends on I2C
> > +	help
> > +	  The FSA9480 is a USB port accessory detector and switch.
> > +	  The FSA9480 is fully controlled using I2C and enables USB data,
> > +	  stereo and mono audio, video, microphone and UART data to use
> > +	  a common connector port.
> 
> So if I'm understanding it correctly, it's an i2c-controlled device
> which turns USB devices on and off, multiplexing them into a single USB
> port?  So if I switch from "USB data" over to "microphone", the USB
> subsystem will see the "USB data" device get unplugged and will see a
> "microphone" get plugged in?

It is generally for 'smart phones' where one connector has to do many
jobs. Basically it's a electrical switch which allows one set of lines
on a connector to be electrically connected to either the USB, or one
of a number of analogue functions.

Often this is helped by the connector having some form of detect line
which tells you what is plugged in, such as a headset, usb cable, etc.
 
> Or something else.  Am I even vaguely understanding this thing?
> 
> It would help if the changelog were to contain a paragraph
> describing the overall behaviour of this device.
> 
> >
> > ...
> >
> > +void fsa9480_set_switch(const char *buf)
> > +{
> > +	struct fsa9480_usbsw *usbsw = chip;
> > +	struct i2c_client *client = usbsw->client;
> > +	unsigned int value;
> > +	unsigned int path = 0;
> > +
> > +	value = fsa9480_read_reg(client, FSA9480_REG_CTRL);
> > +
> > +	if (!strncmp(buf, "VAUDIO", 6)) {
> > +		path = SW_VAUDIO;
> > +		value &= ~CON_MANUAL_SW;
> > +	} else if (!strncmp(buf, "UART", 4)) {
> > +		path = SW_UART;
> > +		value &= ~CON_MANUAL_SW;
> > +	} else if (!strncmp(buf, "AUDIO", 5)) {
> > +		path = SW_AUDIO;
> > +		value &= ~CON_MANUAL_SW;
> > +	} else if (!strncmp(buf, "DHOST", 5)) {
> > +		path = SW_DHOST;
> > +		value &= ~CON_MANUAL_SW;
> > +	} else if (!strncmp(buf, "AUTO", 4)) {
> > +		path = SW_AUTO;
> > +		value |= CON_MANUAL_SW;
> > +	} else {
> > +		printk(KERN_ERR "Wrong command\n");
> > +		return;
> > +	}
> > +
> > +	usbsw->mansw = path;
> > +	fsa9480_write_reg(client, FSA9480_REG_MANSW1, path);
> > +	fsa9480_write_reg(client, FSA9480_REG_CTRL, value);
> > +}
> > +EXPORT_SYMBOL_GPL(fsa9480_set_switch);
> 
> Why was this exported?
> 
> > +ssize_t fsa9480_get_switch(char *buf)
> > +{
> > +	struct fsa9480_usbsw *usbsw = chip;
> > +	struct i2c_client *client = usbsw->client;
> > +	unsigned int value;
> > +
> > +	value = fsa9480_read_reg(client, FSA9480_REG_MANSW1);
> > +
> > +	if (value == SW_VAUDIO)
> > +		return sprintf(buf, "VAUDIO\n");
> > +	else if (value == SW_UART)
> > +		return sprintf(buf, "UART\n");
> > +	else if (value == SW_AUDIO)
> > +		return sprintf(buf, "AUDIO\n");
> > +	else if (value == SW_DHOST)
> > +		return sprintf(buf, "DHOST\n");
> > +	else if (value == SW_AUTO)
> > +		return sprintf(buf, "AUTO\n");
> > +	else
> > +		return sprintf(buf, "%x", value);
> > +}
> > +EXPORT_SYMBOL_GPL(fsa9480_get_switch);
> 
> This export also has no callers?
> 
> These functions implement a userspace API.  Userspace APIs are
> important.  But the patch provided no documentation for that API. 
> Please always fully, exhaustively document userspace APIs!  For they
> are the one part of the driver which we can never change.
> 
> Documenting them in a documentation file is OK.  Also there's
> Documentation/ABI/.  And they can be nicely described in the changelog
> too.
> 
> But providing us with no description at all makes review harder and
> less effective than we'd like it to be, and results in a driver which
> is harder for our users to use.
> 
> OK?
> 
> > +static ssize_t fsa9480_show_status(struct device *dev,
> > +				   struct device_attribute *attr,
> > +				   char *buf)
> > +{
> > +	struct fsa9480_usbsw *usbsw = dev_get_drvdata(dev);
> > +	struct i2c_client *client = usbsw->client;
> > +	int devid, ctrl, adc, dev1, dev2, intr,
> > +	    intmask1, intmask2, time1, time2, mansw1;
> > +
> > +	devid = fsa9480_read_reg(client, FSA9480_REG_DEVID);
> > +	ctrl = fsa9480_read_reg(client, FSA9480_REG_CTRL);
> > +	adc = fsa9480_read_reg(client, FSA9480_REG_ADC);
> > +	intmask1 = fsa9480_read_reg(client, FSA9480_REG_INT1_MASK);
> > +	intmask2 = fsa9480_read_reg(client, FSA9480_REG_INT2_MASK);
> > +	dev1 = fsa9480_read_reg(client, FSA9480_REG_DEV_T1);
> > +	dev2 = fsa9480_read_reg(client, FSA9480_REG_DEV_T2);
> > +	time1 = fsa9480_read_reg(client, FSA9480_REG_TIMING1);
> > +	time2 = fsa9480_read_reg(client, FSA9480_REG_TIMING2);
> > +	mansw1 = fsa9480_read_reg(client, FSA9480_REG_MANSW1);
> > +
> > +	fsa9480_read_irq(client, &intr);
> > +
> > +	return sprintf(buf, "Device ID(%02x), CTRL(%02x)\n"
> > +			"ADC(%02x), DEV_T1(%02x), DEV_T2(%02x)\n"
> > +			"INT(%04x), INTMASK(%02x, %02x)\n"
> > +			"TIMING(%02x, %02x), MANSW1(%02x)\n",
> > +			devid, ctrl, adc, dev1, dev2, intr,
> > +			intmask1, intmask2, time1, time2, mansw1);
> > +}
> 
> That's will produce odd-looking output I suspect.  More conventional
> would be
> 
> 	Device ID:%02x CTRL:%02x
> 
> or something like that.
> 
> But that result is basically unparseable by software and a better output
> would be
> 
> Device_ID: %02x
> CTRL: %02x
> ADC: %02x
> 
> etc.
> 
> But even that violates the sysfs one-value-per-file guideline.
> 
> So this interface is problematic.  It should have been discussed
> up-front in the changelog so we can all take a look at the proposal and
> have a think about it.
> 
> >
> > ...
> >
> > +static irqreturn_t fsa9480_irq_handler(int irq, void *data)
> > +{
> > +	struct fsa9480_usbsw *usbsw = data;
> > +
> > +	if (!work_pending(&usbsw->work)) {
> > +		disable_irq_nosync(irq);
> > +		schedule_work(&usbsw->work);
> > +	}
> > +
> > +	return IRQ_HANDLED;
> > +}
> 
> I expect that this driver can be converted to the new threaded IRQ code
> (request_threaded_irq) and it will all become simpler.
> 
> >
> > ...
> >
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-i2c" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

-- 
-- 
Ben

Q:      What's a light-year?
A:      One-third less calories than a regular year.

