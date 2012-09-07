Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760324Ab2IGJwE (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Sep 2012 05:52:04 -0400
Received: from zose-mta15.web4all.fr ([176.31.217.11]:44084 "EHLO
	zose-mta15.web4all.fr" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760286Ab2IGJwB convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Sep 2012 05:52:01 -0400
Date: Fri, 7 Sep 2012 11:57:18 +0200 (CEST)
From: =?utf-8?Q?Beno=C3=AEt_Th=C3=A9baudeau?= 
	<benoit.thebaudeau@advansee.com>
To: Sascha Hauer <s.hauer@pengutronix.de>
Cc: HACHIMI Samir <shachimi@adeneo-embedded.com>,
        shawn guo <shawn.guo@linaro.org>,
        thierry reding <thierry.reding@avionic-design.de>,
        linux-kernel@vger.kernel.org, kernel@pengutronix.de,
        Philipp Zabel <p.zabel@pengutronix.de>,
        linux-arm-kernel@lists.infradead.org
Message-ID: <1500638147.3845571.1347011838934.JavaMail.root@advansee.com>
In-Reply-To: <20120907074138.GN26594@pengutronix.de>
Subject: Re: [PATCH 7/9] pwm i.MX: fix clock lookup
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8BIT
X-Originating-IP: [88.188.188.98]
X-Mailer: Zimbra 7.2.0_GA_2669 (ZimbraWebClient - FF3.0 (Win)/7.2.0_GA_2669)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday, September 7, 2012 9:41:38 AM, Sascha Hauer wrote:
> On Thu, Sep 06, 2012 at 09:09:42PM +0200, Benoît Thébaudeau wrote:
> > On Thursday, September 6, 2012 8:42:56 PM, Sascha Hauer wrote:
> > > On Thu, Sep 06, 2012 at 08:31:58PM +0200, Benoît Thébaudeau
> > > wrote:
> > > > On Thursday, September 6, 2012 2:48:13 PM, Sascha Hauer wrote:
> > > > > 
> > > > > +	int ret;
> > > > > +
> > > > > +	ret = clk_prepare_enable(imx->clk_ipg);
> > > > > +	if (ret)
> > > > > +		return ret;
> > > > >  
> > > > > -	return imx->config(chip, pwm, duty_ns, period_ns);
> > > > > +	ret = imx->config(chip, pwm, duty_ns, period_ns);
> > > > > +
> > > > > +	clk_disable_unprepare(imx->clk_ipg);
> > > > > +
> > > > > +	return ret;
> > > > >  }
> > > > >  
> > > > >  static int imx_pwm_enable(struct pwm_chip *chip, struct
> > > > >  pwm_device
> > > > >  *pwm)
> > > > > @@ -169,7 +179,7 @@ static int imx_pwm_enable(struct pwm_chip
> > > > > *chip,
> > > > > struct pwm_device *pwm)
> > > > >  	struct imx_chip *imx = to_imx_chip(chip);
> > > > >  	int ret;
> > > > >  
> > > > > -	ret = clk_prepare_enable(imx->clk);
> > > > > +	ret = clk_prepare_enable(imx->clk_per);
> > > > >  	if (ret)
> > > > >  		return ret;
> > > > 
> > > > Have you tested that this actually works on i.MX53?
> > > > 
> > > > I have tested it successfully on i.MX35 (with a few additions
> > > > to
> > > > platform code).
> > > > But i.MX35 has a single bit controlling both PWM IPG and PER
> > > > clock
> > > > gates.
> > > > 
> > > > On i.MX53, there are 2 separate control bits for these. So, if
> > > > ipg
> > > > clk is
> > > > strictly required to access PWM registers, even if per clk is
> > > > enabled, this code
> > > > should not work without adding
> > > 
> > > I tested this on i.MX53, but you're right, this seems to be
> > > wrong.
> > > I'll
> > > recheck tomorrow.
> > 
> > I've performed a few more tests with bare register accesses in the
> > bootloader to
> > see how the PWM IP behaves.
> > 
> > On i.MX25, i.MX35 and i.MX51, read accesses always work, whatever
> > the state of
> > the IPG and PER clock gates.
> > 
> > On i.MX25 and i.MX51, write accesses always work, whatever the
> > state of the IPG
> > and PER clock gates.
> > 
> > On i.MX35, write accesses work if and only if the IPG and PER
> > clocks are not
> > gated off (single control bit for both).
> 
> Ok, I tested on i.MX53 and i.MX27.
> 
> On i.MX53 the registers are always accessible. I also measured with
> an
> oscilloscope that the ipg/per clock gates en/disable the PWM when
> it's
> configured for the corresponding clock.
> 
> On i.MX27 register accesses also work regardless of the clock gates.
> Here we have a single clock gate which only gates the ipg clock.
> 
> btw the i.MX6 has a single gate per pwm which are described as "PWMx
> clocks"
> 
> So it seems while not 100% correct the current code seems to be safe.

Agreed.

Best regards,
Benoît
