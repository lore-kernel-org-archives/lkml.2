Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754522Ab1HESbY (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Aug 2011 14:31:24 -0400
Received: from smtp18.mail.ru ([94.100.176.155]:45205 "EHLO smtp18.mail.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752061Ab1HESbX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Aug 2011 14:31:23 -0400
Date: Fri, 5 Aug 2011 22:31:19 +0400
From: Dmitry Artamonow <mad_soft@inbox.ru>
To: Guenter Roeck <guenter.roeck@ericsson.com>
Cc: "lm-sensors@lm-sensors.org" <lm-sensors@lm-sensors.org>,
        Ian Dobson <i.dobson@planet-ian.com>,
        Jean Delvare <khali@linux-fr.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] hwmon: add caseopen detection to w83627ehf driver
Message-ID: <20110805183119.GB18823@rainbow>
References: <1312549243-7503-1-git-send-email-mad_soft@inbox.ru>
 <20110805143447.GA2538@ericsson.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110805143447.GA2538@ericsson.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Spam: Not detected
X-Mras: Ok
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi, Guenter!

On 07:34 Fri 05 Aug     , Guenter Roeck wrote:
> On Fri, Aug 05, 2011 at 09:00:43AM -0400, Dmitry Artamonow wrote:
> > Export caseopen alarm status into userspace for
> > Winbond w83627* chips and also implement alarm clear knob.
> > 
> > Signed-off-by: Dmitry Artamonow <mad_soft@inbox.ru>
> > ---
> >  drivers/hwmon/w83627ehf.c |   66 +++++++++++++++++++++++++++++++++++++++++++++
> >  1 files changed, 66 insertions(+), 0 deletions(-)
> > 
> > Tested on board with W83627DHG-P chip and also checked against datasheets
> > for other W83627 chips. NCT6775F / NCT6776F are currently excluded as I
> > haven't found datasheets for them online and can't check if they have the
> > same registers for caseopen detection. If anyone having access to these
> > datasheets can check that caseopen detection is read from 4th bit of
> > register 42h (Bank 0), and cleared by writing 1 and then 0 into bit 7 of
> > register 46h (Bank 0), then I'll throw away those 'if'-s and resend updated
> > patch.
> > 
> Hi Dmitry,
> 
> NCT6775F / NCT6776F support the same bits. NCT6776F has a second set of bits.
> 42/4 and 46/7 is CASEOPEN0, 42/6 and 46/6 is CASEOPEN1. Register 46/7 (and 46/6
> for NCT6776F) is self-clearing, meaning it is not necessary to write 0,
> but that should not matter.

Oh, that's nice to hear that NCTs are compatible! I'll see that can I do
about additional caseopen on NCT6776F.

[...]

> >  
> > +		data->caseopen = !!(w83627ehf_read_value(data,
> > +					W83627EHF_REG_CASEOPEN_DET) & 0x10);
> > +
> If you use !!, you should define caseopen as bool for consistency.
> And then you don't need !!  since the conversion to 0/1 will be done automatically.
> 
> Even better would be to just save the register value and enable support 
> for the second set of caseopen bits for NCT6776F (ie do the !!() in
> the show function).

Considering second caseopen on NCT6776F that sounds sensible.

> > +static ssize_t
> > +store_caseopen_clear(struct device *dev, struct device_attribute *attr,
> > +			const char *buf, size_t count)
> > +{
> > +	struct w83627ehf_data *data = dev_get_drvdata(dev);
> > +	unsigned long val;
> > +	unsigned int reg;
> > +
> > +	if (strict_strtoul(buf, 10, &val) || val != 0)
> > +		return -EINVAL;
> > +
> > +	mutex_lock(&data->update_lock);
> > +	reg = w83627ehf_read_value(data, W83627EHF_REG_CASEOPEN_CLR);
> > +	w83627ehf_write_value(data, W83627EHF_REG_CASEOPEN_CLR, reg | 0x80);
> > +	reg = w83627ehf_read_value(data, W83627EHF_REG_CASEOPEN_CLR);
> > +	w83627ehf_write_value(data, W83627EHF_REG_CASEOPEN_CLR, reg & ~0x80);
> > +	reg = w83627ehf_read_value(data, W83627EHF_REG_CASEOPEN_CLR);
> 
> I am a bit lost here. What are those additional two reads for ?
> Seems to be unnecessary.
> 
Ugh. These are remnants from my debugging printouts - I removed
printouts, but forgot to drop register readings as well. They are surely
not needed.

> > +static struct sensor_device_attribute sda_caseopen =
> > +	SENSOR_ATTR(intrusion0_alarm, S_IWUSR | S_IRUGO, show_caseopen,
> > +			store_caseopen_clear , 12);
> > +
> Formatting: s/ , /, /
> 
Yes. And this "12" shouldn't be here as well (though it doesn't really
matter, as it's not used by show_caseopen/store_caseopen_clear) - it was
the number of caseopen bit in alarm registers, when I was trying to use
show_alarm() for reading caseopen status. Sadly that never worked for
me, as in spite that datasheets told, this bit contained realtime state
of caseopen pin without any latch! - i.e. it was 0 when caseopen was
triggered and 1, when it wasn't. And once "case was closed" it again
became 1.

Thanks for review! I'll try to send updated patch shortly.

-- 
Best regards,
Dmitry "MAD" Artamonow

