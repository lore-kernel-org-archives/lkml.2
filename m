Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752301Ab2HPLfE (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Aug 2012 07:35:04 -0400
Received: from mailrelay1.diasemi.com ([82.210.246.133]:8742 "EHLO
	mailrelay1.diasemi.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751822Ab2HPLfA convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Aug 2012 07:35:00 -0400
From: "Opensource [Anthony Olech]" <anthony.olech.opensource@diasemi.com>
To: Mark Brown <broonie@opensource.wolfsonmicro.com>,
        "Opensource [Anthony Olech]" <anthony.olech.opensource@diasemi.com>
CC: Samuel Ortiz <sameo@linux.intel.com>, Arnd Bergmann <arnd@arndb.de>,
        "Mauro Carvalho Chehab" <mchehab@redhat.com>,
        Steven Toth <stoth@kernellabs.com>,
        Michael Krufky <mkrufky@kernellabs.com>,
        LKML <linux-kernel@vger.kernel.org>,
        David Dajun Chen <david.chen@diasemi.com>
Subject: RE: [NEW DRIVER V3 1/8] DA9058 MFD core driver
Thread-Topic: [NEW DRIVER V3 1/8] DA9058 MFD core driver
Thread-Index: AQHNevk5l/k5+isK8EGF7ihfS7RRkpdbJ8CAgAEXAGA=
Date: Thu, 16 Aug 2012 11:34:56 +0000
Message-ID: <24DF37198A1E704D9811D8F72B87EB51032C6702@NB-EX-MBX02.diasemi.com>
References: <201208151518.q7FFIN9v011639@latitude.olech.com>
 <20120815185316.GG15365@opensource.wolfsonmicro.com>
In-Reply-To: <20120815185316.GG15365@opensource.wolfsonmicro.com>
Accept-Language: en-GB, de-DE, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.20.27.23]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> -----Original Message-----
> From: Mark Brown [mailto:broonie@opensource.wolfsonmicro.com]
> Sent: 15 August 2012 19:53
> To: Opensource [Anthony Olech]
> Cc: Samuel Ortiz; Arnd Bergmann; Mauro Carvalho Chehab; Steven Toth;
> Michael Krufky; LKML; David Dajun Chen
> Subject: Re: [NEW DRIVER V3 1/8] DA9058 MFD core driver
> On Wed, Aug 15, 2012 at 04:05:21PM +0100, Anthony Olech wrote:
> >
> >  if HAS_IOMEM
> > +
> >  menu "Multifunction device drivers"
> This random change is still present from the first version....
> > +	/*
> > +	 * the init_board_irq() call-back function should be defined in
> > +	 * the machine driver initialization code and is used to set up
> > +	 * the actual (probably GPIO) line as an interrupt line.
> > +	 */
> > +	if (pdata->init_board_irq) {
> > +		ret = pdata->init_board_irq();
> > +		if (ret)
> > +			goto failed_to_setup_the_actual_i2c_hw_irq;
> > +	}
> You appear to have ignored my previous review comments about this...  it still
> shouldn't be needed with modern kernels.


The comment you made was "Why is this conditional?  With irqdomains there's no real reason
to not allocate the IRQs even if you can't usefully use them and it helps make the code simpler."

I obviously did not understand, because you also wrote that the driver must not rely of platform
data. That therefore means that the call-back function pdata->init_board_irq might be NULL,
which in turn means that a check must be done.
 
The only other interpretation of your comment is that the h/w IRQ line setup code must be done
in the machine driver, in my case for testing is arch/arm/mach-s3c64xx/mach-smdk6410.c
But that view is contricted by the init call-backs from the wm8350 and wm1192 drivers.

I am confused, but it does make sense to do the GPIO --> IRQ initialization in the machine driver,
so I will try to do that. But who would be responsible for changing the wm8350 and wm1192 drivers
to also follow that philosophy?


> > +static bool da9058_register_volatile(struct device *dev, unsigned int
> > +reg) {
> > +	switch (reg) {
> > +	case DA9058_ADCMAN_REG:
> > +	case DA9058_ADCRESH_REG:
> > +	case DA9058_ADCRESL_REG:
> > +	case DA9058_ALARMD_REG:
> > +	case DA9058_ALARMH_REG:
> > +	case DA9058_ALARMMI_REG:
> > +	case DA9058_ALARMMO_REG:
> > +	case DA9058_ALARMS_REG:
> > +	case DA9058_ALARMY_REG:
> Are all the alarm registers really volatile?


register DA9058_ADCMAN_REG has one bit that is set by the PMIC
register DA9058_ADCRESH_REG has all bits set by the PMIC
register DA9058_ADCRESL_REG has some bits set by the PMIC

so those are volatile

the registers DA9058_ALARMD... are, on detailed inspection of the chip
documentation, not volatile. I misread the docs previous. I will make the
change. Well done for spotting my mistake - thanks!


> > +	case DA9058_LDO9_REG:
> > +	case DA9058_TOFFSET_REG:
> > +	default:
> > +		return false;
> Just use the default.


The compiler will (I hope) produce the same code even if some of the
default values are enumerated. I produced those call-backs by starting
with all the registers and moving the cases around. I seemed a good
idea at the time. Your objection, I presume, is based on source file size
or aesthetics, but I will eliminate the functionally redundant cases.


> > +static struct regulator_consumer_supply platform_vddarm_consumers[] = {
> > +	{.supply = "vcc",}
> > +};
> No, this and all your other regulator configuration is board specific.


I will remove that.


Thank you Mark for the review.

Tony Olech
