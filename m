Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752464Ab2LUQKC (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Dec 2012 11:10:02 -0500
Received: from bear.ext.ti.com ([192.94.94.41]:56170 "EHLO bear.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751885Ab2LUQJ4 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Dec 2012 11:09:56 -0500
From: "Kim, Milo" <Milo.Kim@ti.com>
To: "devendra.aaru" <devendra.aaru@gmail.com>
CC: "a.zummo@towertech.it" <a.zummo@towertech.it>,
        Andrew Morton <akpm@linux-foundation.org>,
        "rtc-linux@googlegroups.com" <rtc-linux@googlegroups.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Samuel Ortiz <sameo@linux.intel.com>
Subject: RE: [PATCH v3 1/2] rtc: add new lp8788 rtc driver
Thread-Topic: [PATCH v3 1/2] rtc: add new lp8788 rtc driver
Thread-Index: Ac3fUIXDqZYgoeWsSjiBLm1bKZpEpv//xn0A//9RFnA=
Date: Fri, 21 Dec 2012 16:09:30 +0000
Message-ID: <A874F61F95741C4A9BA573A70FE3998F69E10977@DQHE02.ent.ti.com>
References: <A874F61F95741C4A9BA573A70FE3998F69E108CA@DQHE02.ent.ti.com>
 <CAHdPZaOrVQ-oU_+N621izgFedjvWBCJGh2vDub4HjzVemusG7w@mail.gmail.com>
In-Reply-To: <CAHdPZaOrVQ-oU_+N621izgFedjvWBCJGh2vDub4HjzVemusG7w@mail.gmail.com>
Accept-Language: ko-KR, en-US
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

Hi Devendra,

> > +static int lp8788_alarm_irq_enable(struct device *dev, unsigned int
> enable)
> > +{
> > +       struct lp8788_rtc *rtc = dev_get_drvdata(dev);
> > +       struct lp8788 *lp = rtc->lp;
> > +       u8 mask, shift;
> > +
> > +       mask = mask_alarm_en[rtc->alarm];
> > +       shift = shift_alarm_en[rtc->alarm];
> > +
> > +       return lp8788_update_bits(lp, LP8788_INTEN_3, mask, enable <<
> shift);
> 
> i have no idea about this function but just asking,
> 
> this will be called from ioctl right? so what if user calls RTC_AIE_ON
> and you return the IRQ status ? enable or disable like that?
> 
> i guess a failure in setting for no irq and a success otherwise.

Please go to my answer below - at the end of mail.

> 
> > +}
> > +
> > +static const struct rtc_class_ops lp8788_rtc_ops = {
> > +       .read_time = lp8788_rtc_read_time,
> > +       .set_time = lp8788_rtc_set_time,
> > +       .read_alarm = lp8788_read_alarm,
> > +       .set_alarm = lp8788_set_alarm,
> > +       .alarm_irq_enable = lp8788_alarm_irq_enable,
> > +};
> > +
> > +static irqreturn_t lp8788_alarm_irq_handler(int irq, void *ptr)
> > +{
> > +       struct lp8788_rtc *rtc = ptr;
> > +
> > +       rtc_update_irq(rtc->rdev, 1, ALARM_IRQ_FLAG);
> > +       return IRQ_HANDLED;
> > +}
> > +
> > +static int lp8788_alarm_irq_register(struct platform_device *pdev,
> > +                               struct lp8788_rtc *rtc)
> > +{
> > +       struct resource *r;
> > +       struct lp8788 *lp = rtc->lp;
> > +       struct irq_domain *irqdm = lp->irqdm;
> > +       int irq;
> > +
> > +       rtc->irq = 0;
> > +
> > +       if (!lp->pdata) {
> > +               dev_warn(lp->dev, "no platform data for rtc irq\n");
> 
> but we didn't registered irqs right? if we return 0 here means that we
> have a vaild irq no?

Oh, it's my mistake.
Alarm IRQ number is configured in the mfd-lp8788 driver and map it by irq-domain.
Therefore no platform data is required here.

> > +static int lp8788_rtc_probe(struct platform_device *pdev)
> > +{
> > +       struct lp8788 *lp = dev_get_drvdata(pdev->dev.parent);
> > +       struct lp8788_rtc *rtc;
> > +       struct device *dev = &pdev->dev;
> > +
> > +       rtc = devm_kzalloc(lp->dev, sizeof(struct lp8788_rtc),
> GFP_KERNEL);
> 
> lp->dev may be parent device, is &pdev->dev, or dev may be correct?

Great catch! You're correct. Thanks!

> 
> > +       if (!rtc)
> > +               return -ENOMEM;
> > +
> > +       rtc->lp = lp;
> > +       rtc->alarm = lp->pdata ? lp->pdata->alarm_sel :
> DEFAULT_ALARM_SEL;
> > +       platform_set_drvdata(pdev, rtc);
> > +
> > +       device_init_wakeup(dev, 1);
> > +
> > +       rtc->rdev = rtc_device_register("lp8788_rtc", dev,
> > +                                       &lp8788_rtc_ops, THIS_MODULE);
> > +       if (IS_ERR(rtc->rdev)) {
> > +               dev_err(dev, "can not register rtc device\n");
> 
>                     return PTR_ERR(rtc->rdev);  may be better?

Agree, thanks!

> 
> > +               return -ENODEV;
> > +       }
> > +
> > +       if (lp8788_alarm_irq_register(pdev, rtc))
> > +               dev_warn(lp->dev, "no rtc irq handler\n");
> > +
> 
> even if there is no alarm irq, we can still use the rtc to get the
> time, but there wont be RTC_AIE_ON ioctl enabled ?

If ALARM IRQ can't be registered, there are two handling conditions.

(a) Should it return as error in _probe() and no RTC is used anymore?
: Very simple handling but we can't set/get the RTC time even no problem.

(b) Just returns OK in _probe() and error handling when RTC_AIE_ON/OFF IOCTL is 
called?
: It guarantees RTC time functions but alarm IRQ doesn't work.
Please see the code below.

static int lp8788_alarm_irq_enable(struct device *dev, unsigned int enable)
{
	struct lp8788_rtc *rtc = dev_get_drvdata(dev);
	struct lp8788 *lp = rtc->lp;
	u8 mask, shift;

+	if (!rtc->irq)
+		return -EIO;

	mask = mask_alarm_en[rtc->alarm];
	shift = shift_alarm_en[rtc->alarm];

	return lp8788_update_bits(lp, LP8788_INTEN_3, mask, enable << shift);
}

'rtc->irq' is updated only when lp8788_alarm_irq_register() returns true.
If no alarm IRQ is specified, RTC_AIE_ON/OFF returns as EIO.
Then, RTC set/get time works well and alarm IRQ doesn't work.

I believe case (b) is better solution, but I'd like to have your opinion.
Thanks!

Best Regards,
Milo


