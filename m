Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753035Ab2BURZj (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Feb 2012 12:25:39 -0500
Received: from xes-mad.com ([216.165.139.218]:14697 "EHLO xes-mad.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752113Ab2BURZi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Feb 2012 12:25:38 -0500
Date: Tue, 21 Feb 2012 11:25:13 -0600 (CST)
From: Aaron Sierra <asierra@xes-inc.com>
To: Guenter Roeck <guenter@roeck-us.net>
Cc: Peter Tyser <ptyser@xes-inc.com>, Grant Likely <grant.likely@secretlab.ca>,
        LKML <linux-kernel@vger.kernel.org>, Jean Delvare <khali@linux-fr.org>
Subject: Re: [PATCH V5 2/3] gpio: Add support for Intel  ICHx/3100/Series[56] GPIO
Message-ID: <a6f20f7d-8af4-4020-ba8d-c1f90512138b@zimbra>
In-Reply-To: <6.2.5.6.2.20120220221635.0273c0d0@roeck-us.net>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
MIME-Version: 1.0
X-Originating-IP: [10.52.0.65]
X-Mailer: Zimbra 7.1.3_GA_3346 (ZimbraWebClient - GC15 (Linux)/7.1.3_GA_3346)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> >+static int ich6_gpio_get(struct gpio_chip *chip, unsigned nr)
> >+{
> >+       unsigned long flags;
> >+       u32 data;
> >+
> >+       /*
> >+       * GPI 0 - 15 need to be read from the power management
> >registers on
> >+       * a ICH6/3100 bridge.
> >+       */
> >+       if (nr < 16 && ichx_priv.pm_base) {
> >+               spin_lock_irqsave(&ichx_priv.lock, flags);
> >+
> >+               /* GPI 0 - 15 are latched, write 1 to clear*/
> >+               ICHX_WRITE(1 << (16 + nr), 0, ichx_priv.pm_base);
> >+               data = ICHX_READ(0, ichx_priv.pm_base);
> >+
> >+               spin_unlock_irqrestore(&ichx_priv.lock, flags);
> >+
> >+               return (data >> 16) & (1 << nr) ? 1 : 0;
> >+       } else {
> 
> 
> unless I am missing something, this still does not address the error
> case where pm_base is not set because of an ACPI conflict (.uses_gpe0
> is true, but .pm_base is NULL).
> 
> Not sure what to do in that case, but simply calling ichx_gpio_get
> doesn't seem to be the correct solution.

Guenter,
You're right. That doesn't do what I'd intended, but this should do the
trick:

	...

	* a ICH6/3100 bridge.
	*/
	if (nr < 16) {
		if (!ichx_priv.pm_base)
			return -ENXIO;

	...

Any other concerns?

> >+               return ichx_gpio_get(chip, nr);
> >+       }
