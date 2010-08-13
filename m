Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761912Ab0HMR1v (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Aug 2010 13:27:51 -0400
Received: from be1ssnxpe1.nxp.com ([57.67.164.69]:55919 "EHLO
	be1ssnxpe1.nxp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1761896Ab0HMR1u convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Aug 2010 13:27:50 -0400
From: Kevin Wells <kevin.wells@nxp.com>
To: Wolfram Sang <w.sang@pengutronix.de>,
        "rtc-linux@googlegroups.com" <rtc-linux@googlegroups.com>
CC: Durgesh Pattamatta <durgesh.pattamatta@nxp.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        Kevin Wells <wellsk40@gmail.com>
Date: Fri, 13 Aug 2010 19:27:12 +0200
Subject: RE: [rtc-linux] [PATCH] rtc: rtc-lpc32xx: Introduce RTC driver for
	the LPC32XX SoC (v3)
Thread-Topic: [rtc-linux] [PATCH] rtc: rtc-lpc32xx: Introduce RTC driver for
	the LPC32XX SoC (v3)
Thread-Index: Acs626SvJ0w7ebhXR9GUC2h7F5liCAAJ4eGw
Message-ID: <083DF309106F364B939360100EC290F80AC719CAEF@eu1rdcrdc1wx030.exi.nxp.com>
References: <1281650244-9889-1-git-send-email-wellsk40@gmail.com>
	<1281650244-9889-2-git-send-email-wellsk40@gmail.com>
 <20100813112933.GA23852@pengutronix.de>
In-Reply-To: <20100813112933.GA23852@pengutronix.de>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
acceptlanguage: en-US
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10432:5.0.10011,1.0.148,0.0.0000 definitions=2010-08-13_05:2010-08-13,2010-08-13,1970-01-01 signatures=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Wolfram,

Thanks for continued testing and review of the driver.

> > +
> > +#define LPC32XX_RTC_MATCH0_EN		(1 << 0)
> > +#define LPC32XX_RTC_MATCH1_EN		(1 << 1)
> > +#define LPC32XX_RTC_ONSW_MATCH0_EN	(1 << 2)
> > +#define LPC32XX_RTC_ONSW_MATCH1_EN	(1 << 3)
> > +#define LPC32XX_RTC_SW_RESET		(1 << 4)
> > +#define LPC32XX_RTC_CNTR_DIS		(1 << 6)
> > +#define LPC32XX_RTC_ONSW_FORCE_HIGH	(1 << 7)
> 
> I would have liked LPC32XX_RTC_CTRL_* as a prefix better as mentioned last
> time. It will do here for the RTC as it doesn't have much registers, though.
> 
> > +
> > +#define LPC32XX_RTC_MATCH0_INT_STS	(1 << 0)
> > +#define LPC32XX_RTC_MATCH1_INT_STS	(1 << 1)
> > +#define LPC32XX_RTC_ONSW_INT_STS	(1 << 2)
> 
> ditto for including the register name.
> 

No problem here..I'll change these.

> > +static int lpc32xx_rtc_alarm_irq_enable(struct device *dev,
> > +	unsigned int enabled)
> > +{
> > +	struct lpc32xx_rtc *rtc = dev_get_drvdata(dev);
> > +	u32 tmp;
> > +
> > +	spin_lock_irq(&rtc->lock);
> > +	tmp = rtc_readl(rtc, LPC32XX_RTC_CTRL);
> > +
> > +	if (enabled) {
> > +		rtc->alarm_enabled = 1;
> > +		tmp |= LPC32XX_RTC_MATCH0_EN;
> > +	} else {
> > +		rtc->alarm_enabled = 0;
> > +		tmp &= ~LPC32XX_RTC_MATCH0_EN;
> > +	}
> 
> Maybe 'rtc->alarm_enabled = enabled;' or similar could be used. Didn't check
> thouroughly.
> 

I picked this specific approach because the type in the local rtc structure
is unsigned char (matching the struct rtc_wkalrm type) while the passed
parameter 'enabled' is unsigned long. I considered these..
	rtc->alarm_enabled = (unsigned char) enabled;
and
	rtc->alarm_enabled = !!enabled;

The direct assignment seemed the best approach to avoid some type of cast or
extra logic.

> > +	/*
> > +	 * The RTC is on a seperate power domain and can keep it's state
> > +	 * across a chip power cycle. If the RTC has never been previously
> > +	 * setup, then set it up now for the first time.
> > +	 */
> > +	tmp = rtc_readl(rtc, LPC32XX_RTC_CTRL);
> > +	if (rtc_readl(rtc, LPC32XX_RTC_KEY) == LPC32XX_RTC_KEY_ONSW_LOADVAL)
> > +{
> 
> This cannot work; it really should be '!=' otherwise the time will be reset at
> every reboot!
> 

Hmm, this was a good find. If the key value isn't setup correctly, the
boot ROM will clear the RTC counter on power-on reset. The time isn't being
cleared on my board, so something is setting up the key elsewhere. Your
suggested fix is probably the right fix, but I'll review. Sorry - I won't
get updates for this available until next week.

