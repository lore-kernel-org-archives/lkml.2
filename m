Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752755Ab0HJTmg (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Aug 2010 15:42:36 -0400
Received: from be1ssnxpe2.nxp.com ([57.67.164.70]:49808 "EHLO
	be1ssnxpe2.nxp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751662Ab0HJTmf convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Aug 2010 15:42:35 -0400
From: Kevin Wells <kevin.wells@nxp.com>
To: Wolfram Sang <w.sang@pengutronix.de>,
        "rtc-linux@googlegroups.com" <rtc-linux@googlegroups.com>
CC: Durgesh Pattamatta <durgesh.pattamatta@nxp.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        Kevin Wells <wellsk40@gmail.com>
Date: Tue, 10 Aug 2010 21:08:10 +0200
Subject: RE: [rtc-linux] [PATCH 1/2] rtc: rtc-lpc32xx: Introduce RTC driver
	for the LPC32XX SoC
Thread-Topic: [rtc-linux] [PATCH 1/2] rtc: rtc-lpc32xx: Introduce RTC driver
	for the LPC32XX SoC
Thread-Index: Acs4d12cZO+TZWXTS3q0Uyr1phRSoQAPsMBg
Message-ID: <083DF309106F364B939360100EC290F80AC6E5F76C@eu1rdcrdc1wx030.exi.nxp.com>
References: <1281370650-29520-1-git-send-email-wellsk40@gmail.com>
	<1281370650-29520-2-git-send-email-wellsk40@gmail.com>
 <20100810102507.GB4268@pengutronix.de>
In-Reply-To: <20100810102507.GB4268@pengutronix.de>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
acceptlanguage: en-US
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10432:5.0.10011,1.0.148,0.0.0000 definitions=2010-08-10_07:2010-08-10,2010-08-10,1970-01-01 signatures=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Wolfram,

Thanks for helping review this.
I'll get your suggestions installed and an update posted in a few days.

> > +
> > +	device_init_wakeup(&pdev->dev, 1);
> > +	rtc->rtc = rtc_device_register(RTC_NAME, &pdev->dev, &lpc32xx_rtc_ops,
> > +		THIS_MODULE);
> > +	if (IS_ERR(rtc->rtc)) {
> > +		dev_err(&pdev->dev, "Can't get RTC\n");
> > +		retval = PTR_ERR(rtc->rtc);
> > +		goto err_noreg;
> > +	}
> > +
> > +	retval = request_irq(rtc->irq, lpc32xx_rtc_alarm_interrupt,
> > +		IRQF_DISABLED, "rtcalarm", rtc);
> > +	if (retval < 0) {
> > +		dev_err(&pdev->dev, "Can't request interrupt\n");
> > +		goto err_free_irq;
> > +	}
> 
> I saw that a number of rtc-drivers register their irq after they register the
> device. I wonder if this is OK here? Couldn't it happen that after
> rtc_device_register() there is a preemption and another process could set the
> alarm? Then there is a race between interrupts already enabled and no handler
> available, no?
> 

The 32xx RTC registers can save states across power or reset
cycles and are only initialized if they have never been previously
initialized. When waking up from suspend, power on, or reset - the
alarm IRQ may have fired and may be enabled from a previous
initialization, so the RTC device needs to be registered first.

You bring up a good point though, I wonder if going through probe
requires that the alarm be disabled (ie, suspend won't go via probe,
but a hard system reset will). I'll review this a bit more.

