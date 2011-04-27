Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759924Ab1D0Tuy (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Apr 2011 15:50:54 -0400
Received: from imr4.ericy.com ([198.24.6.8]:55521 "EHLO imr4.ericy.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758142Ab1D0Tux (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Apr 2011 15:50:53 -0400
Date: Wed, 27 Apr 2011 12:49:56 -0700
From: Guenter Roeck <guenter.roeck@ericsson.com>
To: Natarajan Gurumoorthy <natg@google.com>
CC: Jean Delvare <khali@linux-fr.org>, Wim Van Sebroeck <wim@iguana.be>,
        Mike Waychison <mikew@google.com>,
        "lm-sensors@lm-sensors.org" <lm-sensors@lm-sensors.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-watchdog@vger.kernel.org" <linux-watchdog@vger.kernel.org>
Subject: Re: [PATCH v7 1/2] Use "request_muxed_region" in it87 watchdog
 drivers
Message-ID: <20110427194956.GA24382@ericsson.com>
References: <1303153127-11717-1-git-send-email-natg@google.com>
 <1303153204-11784-1-git-send-email-natg@google.com>
 <20110422044451.GB524@ericsson.com>
 <BANLkTikGGO76ToGaRJ0foSc-Yp6Fe4C97g@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <BANLkTikGGO76ToGaRJ0foSc-Yp6Fe4C97g@mail.gmail.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Apr 27, 2011 at 01:49:01PM -0400, Natarajan Gurumoorthy wrote:
> Guenter,
> 
> On Thu, Apr 21, 2011 at 9:44 PM, Guenter Roeck
> <guenter.roeck@ericsson.com> wrote:
> > >  /**
> > > @@ -303,8 +308,6 @@ static void wdt_stop(void)
> > >
> > >  static int wdt_set_timeout(int t)
> > >  {
> > > -       unsigned long flags;
> > > -
> > >         if (t < 1 || t > max_units * 60)
> > >                 return -EINVAL;
> > >
> > > @@ -313,14 +316,14 @@ static int wdt_set_timeout(int t)
> > >         else
> > >                 timeout = t;
> > >
> > > -       spin_lock_irqsave(&spinlock, flags);
> > >         if (test_bit(WDTS_TIMER_RUN, &wdt_status)) {
> > > -               superio_enter();
> > > +               if (superio_enter())
> > > +                       return -EBUSY;
> > > +
> > I don't think you can do that here. You are moving the lock,
> > meaning test_bit is no longer protected by the lock.
> >
> I am not sure I am in agreement with your here. If you look at other
> places in the original driver I see sections of code in "wdt_ioctl"
> that look as follows:
>         case WDIOC_SETOPTIONS:
>                 if (get_user(new_options, uarg.i))
>                         return -EFAULT;
> 
>                 switch (new_options) {
>                 case WDIOS_DISABLECARD:
>                         if (test_bit(WDTS_TIMER_RUN, &wdt_status))
>                                 wdt_stop();
>                         clear_bit(WDTS_TIMER_RUN, &wdt_status);
>                         return 0;
> 
>                 case WDIOS_ENABLECARD:
>                         if (!test_and_set_bit(WDTS_TIMER_RUN, &wdt_status))
>                                 wdt_start();
>                         return 0;
> 
>                 default:
>                         return -EFAULT;
>                 }
> 
> They have run through manipulating the "WDTS_TIMER_RUN" bit in
> wdt_status without touching the spinlock. "wdt_stop" does acquire the
> spinlock before touching the hardware through superio_enter. It seems
> to me that the original writers of this driver were using the spinlock
> to isolate access to the hardware and we will be achieving the same by
> the use of "request_muxed_region" call from superio_enter.
> 
Agreed. Thanks for the clarification.

Guenter
