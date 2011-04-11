Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753779Ab1DKLb3 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Apr 2011 07:31:29 -0400
Received: from ch1outboundpool.messaging.microsoft.com ([216.32.181.183]:54372
	"EHLO ch1outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752225Ab1DKLb1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Apr 2011 07:31:27 -0400
X-SpamScore: -20
X-BigFish: VPS-20(zz9371O542M1432N98dKzz1202hzz8275bhz32i2a8h668h839h61h)
X-Spam-TCS-SCL: 0:0
X-Forefront-Antispam-Report: KIP:(null);UIP:(null);IPVD:NLI;H:kcinpunhjhc02.kpit.com;RD:none;EFVD:NLI
From: Ashish Jangam <Ashish.Jangam@kpitcummins.com>
To: Mark Brown <broonie@opensource.wolfsonmicro.com>
CC: "sameo@openedhand.com" <sameo@openedhand.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Dajun Chen <Dajun.Chen@diasemi.com>
Date: Mon, 11 Apr 2011 17:01:12 +0530
Subject: RE: [PATCHv1 1/11] MFD: MFD module of DA9052 PMIC driver
Thread-Topic: [PATCHv1 1/11] MFD: MFD module of DA9052 PMIC driver
Thread-Index: Acv0Yu85jsWHylNuTvGMmoary0BirgD1qkNg
Message-ID: <E2CAE7F7B064EA49B5CE7EE9A4BB167D151B55613A@KCINPUNHJCMS01.kpit.com>
References: <E2CAE7F7B064EA49B5CE7EE9A4BB167D151B4AC245@KCINPUNHJCMS01.kpit.com>
 <20110406135954.GA2810@opensource.wolfsonmicro.com>
In-Reply-To: <20110406135954.GA2810@opensource.wolfsonmicro.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
acceptlanguage: en-US
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
X-OriginatorOrg: kpitcummins.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by mail.home.local id p3BBVcRM025928

Hi Mark,

Please see the comment below.

> -----Original Message-----
> From: Mark Brown [mailto:broonie@opensource.wolfsonmicro.com]
> Sent: Wednesday, April 06, 2011 7:30 PM
> To: Ashish Jangam
> Cc: sameo@openedhand.com; linux-kernel@vger.kernel.org; Dajun Chen
> Subject: Re: [PATCHv1 1/11] MFD: MFD module of DA9052 PMIC driver
> 
> On Wed, Apr 06, 2011 at 07:01:34PM +0530, Ashish Jangam wrote:
> 
> > +int da9052_adc_manual_read(struct da9052 *da9052,
> > +                       unsigned char channel)
> > +{
> > +       unsigned char timeout_cnt = 8;
> > +       unsigned short calc_data;
> > +       int ret;
> > +       u16 data = 0;
> > +       u8 mux_sel = 0;
> 
> There's no concurrency protection in this code so if two users try to do
> ADC reads simultaneously they'll interfere with each other.
> 
> > +int da9052_reg_read(struct da9052 *da9052, unsigned char reg)
> > +{
> > +       unsigned char val;
> > +
> > +       if( reg > DA9052_MAX_REG_CNT ) {
> 
> This isn't the standard kernel coding style - checkpatch.pl can help
> spot issues like this (there's many other examples throughout the code).
> 
> > +       if ( da9052->read_dev(da9052, reg, 1, &val) ) {
> > +               mutex_unlock(&da9052->io_lock);
> > +               return -EIO;
> > +       }
> 
> It'd seem helpful to return any error code that read_dev() returns to
> the caller.
> 
> > +int da9052_read_events(struct da9052 *da9052, unsigned char reg ,
> > +                             unsigned int *events)
> > +{
> > +       uint8_t v[4] = {0, 0, 0, 0};
> > +       int ret;
> > +
> > +       ret = da9052_group_read(da9052, reg, 4, v);
> > +       if (ret < 0)
> > +               return ret;
> > +
> > +       *events = (v[3] << 24) | (v[2] << 16) | (v[1] << 8) | v[0];
> > +
> > +       return 0;
> > +}
> > +EXPORT_SYMBOL_GPL(da9052_read_events);
> 
> This looks like part of the old non-standard IRQ code previous versions
> of these patches had?  Looks like this should be merged into the IRQ
> code if it's needed at all.
> 
> > +MODULE_AUTHOR("Dialog Semiconductor Ltd <dchen@diasemi.com>");
> > +MODULE_DESCRIPTION("DA9052 MFD Core");
> > +MODULE_LICENSE("GPL v2");
> > +MODULE_ALIAS("platform:" DA9052_SSC_DEVICE_NAME);
> 
> Is this really a platform device?
> 
> > +static struct i2c_device_id da9052_i2c_id[] = {
> > +       { "da9052_i2c", 0},
> > +       {}
> > +};
> 
> The usual style would just be "da9052_i2c" - the fact that this is an
> I2C device ID makes it obvious that the device is an I2C one.
> 
> > +/*
> > + * da9052-irq.c  --  Interrupt controller support for Dilaog DA9052 PMICs
> > + *
> > +#include <linux/i2c.h>
> > +#include <linux/spi/spi.h>
> 
> The IRQ controller code probably shouldn't know anything about I2C or
> SPI given that you've got a separate layer doing register I/O.
> 
> > +static void da9052_irq_sync_unlock(unsigned int irq)
> > +{
> > +       struct da9052 *da9052 = get_irq_chip_data(irq);
> > +
> > +       mutex_unlock(&da9052->irq_lock);
> > +}
> 
> You should be applying the changes made while locked here - the locked
> region should be atomic.
> 
> > +struct irq_chip da9052_irq_chip = {
> > +       .name = "da9052",
> > +       .bus_lock = da9052_irq_lock,
> > +       .bus_sync_unlock = da9052_irq_sync_unlock,
> > +       .mask = da9052_irq_mask,
> > +       .unmask = da9052_irq_unmask,
> > +};
> 
> This is out of date with current mainline, you should be using the irq_
> variants of the operations which take an irq_desc rather than IRQ
> number.
> 
> > +       for (cur_irq = da9052->irq_base;
> > +            cur_irq < ARRAY_SIZE(da9052_irqs) + da9052->irq_base;
> > +            cur_irq++) {
> > +               set_irq_chip_data(cur_irq, da9052);
> > +               set_irq_chip_and_handler(cur_irq, &da9052_irq_chip,
> > +                                        handle_simple_irq);
> > +               set_irq_nested_thread(cur_irq, 1);
> > +
> > +               /* ARM needs us to explicitly flag the IRQ as valid
> > +                * and will set them noprobe when we do so. */
> > +#ifdef CONFIG_ARM
> > +               set_irq_flags(cur_irq, IRQF_VALID);
> > +#else
> > +               set_irq_noprobe(cur_irq);
> > +#endif
> > +       }
> 
> It'd be nice to credit the code you're drawing inspiration from :)
> 
> > +config PMIC_DA9052
> > +       tristate "Dialog DA9052 with SPI/I2C"
> > +       depends on SPI_MASTER=y
> > +       depends on I2C=y
> 
> These dependencies look wrong - they'll force both I2C and SPI to be
> built in even though only one of them will be required by the driver in
> a given system.
> 
> > + /* Helper to save on boilerplate */
> > +static inline int da9052_request_irq(struct da9052 *da9052, int irq,
> > +                                      irq_handler_t handler, const char
> *name,
> > +                                      void *data)
> > + {
> > +       int ret;
> > +
> > +       if (!da9052->irq_base)
> > +               return -EINVAL;
> > +
> > +       ret = request_threaded_irq(da9052->irq_base + irq, NULL, handler,
> > +                                     IRQF_TRIGGER_LOW | IRQF_ONESHOT, name,
> > +                                     data);
> 
> Since you're implementing directly with genirq you don't need this
> stuff, some drivers have it as they were written before genirq could
> support devices on sleepy buses.

DA9052 PMIC is event based so mfd device like touch, onkey, rtc etc gets register to their associated event by this function. In absence of the request_threaded_irq() call there will no mechanism for the said devices to receive their event. Hence we intend to keep this API call.

In case our explanation is not inline with your review then kindly elaborate.

Regards,
Ashish


ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
