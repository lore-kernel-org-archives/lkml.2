Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965140Ab1DNSAH (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Apr 2011 14:00:07 -0400
Received: from imr4.ericy.com ([198.24.6.8]:60571 "EHLO imr4.ericy.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S964921Ab1DNR76 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Apr 2011 13:59:58 -0400
Subject: Re: [lm-sensors] [PATCH v5 1/2] Use "request_muxed_region" in it87
 watchdog drivers
From: Guenter Roeck <guenter.roeck@ericsson.com>
Reply-To: guenter.roeck@ericsson.com
To: Hans de Goede <hdegoede@redhat.com>
CC: Nat Gurumoorthy <natg@google.com>, Jean Delvare <khali@linux-fr.org>,
        Wim Van Sebroeck <wim@iguana.be>,
        "linux-watchdog@vger.kernel.org" <linux-watchdog@vger.kernel.org>,
        "lm-sensors@lm-sensors.org" <lm-sensors@lm-sensors.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Mike Waychison <mikew@google.com>
In-Reply-To: <4DA547CD.60406@redhat.com>
References: <1302641290-30212-1-git-send-email-natg@google.com>
	 <1302641387-30264-1-git-send-email-natg@google.com>
	 <4DA547CD.60406@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Organization: Ericsson
Date: Thu, 14 Apr 2011 10:58:33 -0700
Message-ID: <1302803913.26780.373.camel@groeck-laptop>
MIME-Version: 1.0
X-Mailer: Evolution 2.28.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2011-04-13 at 02:50 -0400, Hans de Goede wrote:
> Hi,
> 
> On 04/12/2011 10:49 PM, Nat Gurumoorthy wrote:
> > 01 - Changes to it87 watchdog driver to use "request_muxed_region"
> > Serialize access to the hardware by using "request_muxed_region" macro defined
> > by Alan Cox. Call to this macro will hold off the requestor if the resource is
> > currently busy.
> >
> > The use of the above macro makes it possible to get rid of
> > spinlocks in it8712f_wdt.c and it87_wdt.c watchdog drivers.
> > This also greatly simplifies the implementation of it87_wdt.c driver.
> >
> > Signed-off-by: Nat Gurumoorthy<natg@google.com>
> > ---
> >
> > diff --git a/drivers/watchdog/it8712f_wdt.c b/drivers/watchdog/it8712f_wdt.c
> > index 6143f52..51bfbc0 100644
> > --- a/drivers/watchdog/it8712f_wdt.c
> > +++ b/drivers/watchdog/it8712f_wdt.c
> > @@ -51,7 +51,6 @@ MODULE_PARM_DESC(nowayout, "Disable watchdog shutdown on close");
> >
> >   static unsigned long wdt_open;
> >   static unsigned expect_close;
> > -static spinlock_t io_lock;
> >   static unsigned char revision;
> >
> >   /* Dog Food address - We use the game port address */
> > @@ -123,7 +122,11 @@ static inline void superio_select(int ldn)
> >
> >   static inline void superio_enter(void)
> >   {
> > -	spin_lock(&io_lock);
> > +	/*
> > +	 * Reserve REG and REG + 1 for exclusive access.
> > +	 */
> > +	(void) request_muxed_region(REG, 2, NAME);
> > +
> 
> You shouldn't (void) this, there is a reason you get a warning
> otherwise! request_muxed_region can still fail if some other driver
> has done a none muxed request_region on the same region, and in that
> case you should not continue with accessing the io-ports.
> 
Absolutely agree - even if that means adding a return code to
superio_enter() and checking it from the calling code.

Guenter


