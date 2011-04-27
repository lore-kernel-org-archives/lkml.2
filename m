Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932803Ab1D0RtH (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Apr 2011 13:49:07 -0400
Received: from smtp-out.google.com ([216.239.44.51]:35194 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756311Ab1D0RtE convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Apr 2011 13:49:04 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=google.com; s=beta;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=oyL+ENqFy6V9Y9BxFbXbSm3in66jIta/yIazQnEAsydfd2VB6uxHNm3D7l58gQMSL0
         w7FzBItSodpxBo/iYlBg==
MIME-Version: 1.0
In-Reply-To: <20110422044451.GB524@ericsson.com>
References: <1303153127-11717-1-git-send-email-natg@google.com>
	<1303153204-11784-1-git-send-email-natg@google.com>
	<20110422044451.GB524@ericsson.com>
Date: Wed, 27 Apr 2011 10:49:01 -0700
Message-ID: <BANLkTikGGO76ToGaRJ0foSc-Yp6Fe4C97g@mail.gmail.com>
Subject: Re: [PATCH v7 1/2] Use "request_muxed_region" in it87 watchdog drivers
From: Natarajan Gurumoorthy <natg@google.com>
To: Guenter Roeck <guenter.roeck@ericsson.com>
Cc: Jean Delvare <khali@linux-fr.org>, Wim Van Sebroeck <wim@iguana.be>,
        Mike Waychison <mikew@google.com>,
        "lm-sensors@lm-sensors.org" <lm-sensors@lm-sensors.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-watchdog@vger.kernel.org" <linux-watchdog@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Guenter,

On Thu, Apr 21, 2011 at 9:44 PM, Guenter Roeck
<guenter.roeck@ericsson.com> wrote:
> >  /**
> > @@ -303,8 +308,6 @@ static void wdt_stop(void)
> >
> >  static int wdt_set_timeout(int t)
> >  {
> > -       unsigned long flags;
> > -
> >         if (t < 1 || t > max_units * 60)
> >                 return -EINVAL;
> >
> > @@ -313,14 +316,14 @@ static int wdt_set_timeout(int t)
> >         else
> >                 timeout = t;
> >
> > -       spin_lock_irqsave(&spinlock, flags);
> >         if (test_bit(WDTS_TIMER_RUN, &wdt_status)) {
> > -               superio_enter();
> > +               if (superio_enter())
> > +                       return -EBUSY;
> > +
> I don't think you can do that here. You are moving the lock,
> meaning test_bit is no longer protected by the lock.
>
I am not sure I am in agreement with your here. If you look at other
places in the original driver I see sections of code in "wdt_ioctl"
that look as follows:
	case WDIOC_SETOPTIONS:
		if (get_user(new_options, uarg.i))
			return -EFAULT;

		switch (new_options) {
		case WDIOS_DISABLECARD:
			if (test_bit(WDTS_TIMER_RUN, &wdt_status))
				wdt_stop();
			clear_bit(WDTS_TIMER_RUN, &wdt_status);
			return 0;

		case WDIOS_ENABLECARD:
			if (!test_and_set_bit(WDTS_TIMER_RUN, &wdt_status))
				wdt_start();
			return 0;

		default:
			return -EFAULT;
		}

They have run through manipulating the "WDTS_TIMER_RUN" bit in
wdt_status without touching the spinlock. "wdt_stop" does acquire the
spinlock before touching the hardware through superio_enter. It seems
to me that the original writers of this driver were using the spinlock
to isolate access to the hardware and we will be achieving the same by
the use of "request_muxed_region" call from superio_enter.

I am fixing the rest of the issues pointed out by you and am hoping to
ship out a patch by the end of the week.

Regards
Nat

> >                 superio_select(GPIO);
> >                 wdt_update_timeout();
> >                 superio_exit();
> >         }
> > -       spin_unlock_irqrestore(&spinlock, flags);
> >         return 0;
> >  }
> >
> > @@ -339,12 +342,10 @@ static int wdt_set_timeout(int t)
> >
> >  static int wdt_get_status(int *status)
> >  {
> > -       unsigned long flags;
> > -
> >         *status = 0;
> >         if (testmode) {
> > -               spin_lock_irqsave(&spinlock, flags);
> > -               superio_enter();
> > +               if (superio_enter())
> > +                       return -EBUSY;
> >                 superio_select(GPIO);
> >                 if (superio_inb(WDTCTRL) & WDT_ZERO) {
> >                         superio_outb(0x00, WDTCTRL);
> > @@ -353,7 +354,6 @@ static int wdt_get_status(int *status)
> >                 }
> >
> >                 superio_exit();
> > -               spin_unlock_irqrestore(&spinlock, flags);
> >         }
> >         if (test_and_clear_bit(WDTS_KEEPALIVE, &wdt_status))
> >                 *status |= WDIOF_KEEPALIVEPING;
> > @@ -381,7 +381,12 @@ static int wdt_open(struct inode *inode, struct file *file)
> >         if (!test_and_set_bit(WDTS_TIMER_RUN, &wdt_status)) {
> >                 if (nowayout && !test_and_set_bit(WDTS_LOCKED, &wdt_status))
> >                         __module_get(THIS_MODULE);
> > -               wdt_start();
> > +               if (wdt_start()) {
> > +                       clear_bit(WDTS_LOCKED, &wdt_status);
> > +                       clear_bit(WDTS_TIMER_RUN, &wdt_status);
> > +                       clear_bit(WDTS_DEV_OPEN, &wdt_status);
> > +                       return -EBUSY;
> > +               }
> >         }
> >         return nonseekable_open(inode, file);
> >  }
> > @@ -403,7 +408,15 @@ static int wdt_release(struct inode *inode, struct file *file)
> >  {
> >         if (test_bit(WDTS_TIMER_RUN, &wdt_status)) {
> >                 if (test_and_clear_bit(WDTS_EXPECTED, &wdt_status)) {
> > -                       wdt_stop();
> > +                       if (wdt_stop()) {
> > +                               /*
> > +                                * Stop failed. Just keep the watchdog alive
> > +                                * and hope nothing bad happens.
> > +                                */
> > +                               set_bit(WDTS_EXPECTED, &wdt_status);
> > +                               wdt_keepalive();
> > +                               return -EBUSY;
> > +                       }
> >                         clear_bit(WDTS_TIMER_RUN, &wdt_status);
> >                 } else {
> >                         wdt_keepalive();
> > @@ -484,7 +497,8 @@ static long wdt_ioctl(struct file *file, unsigned int cmd, unsigned long arg)
> >                                     &ident, sizeof(ident)) ? -EFAULT : 0;
> >
> >         case WDIOC_GETSTATUS:
> > -               wdt_get_status(&status);
> > +               if (wdt_get_status(&status))
> > +                       return -EBUSY;
> >                 return put_user(status, uarg.i);
> >
> >         case WDIOC_GETBOOTSTATUS:
> > @@ -501,13 +515,19 @@ static long wdt_ioctl(struct file *file, unsigned int cmd, unsigned long arg)
> >                 switch (new_options) {
> >                 case WDIOS_DISABLECARD:
> >                         if (test_bit(WDTS_TIMER_RUN, &wdt_status))
> > -                               wdt_stop();
> > +                               if (wdt_stop())
> > +                                       return -EBUSY;
> > +
> >                         clear_bit(WDTS_TIMER_RUN, &wdt_status);
> >                         return 0;
> >
> >                 case WDIOS_ENABLECARD:
> > -                       if (!test_and_set_bit(WDTS_TIMER_RUN, &wdt_status))
> > -                               wdt_start();
> > +                       if (!test_and_set_bit(WDTS_TIMER_RUN, &wdt_status)) {
> > +                               if (wdt_start()) {
> > +                                       clear_bit(WDTS_TIMER_RUN, &wdt_status);
> > +                                       return -EBUSY;
> > +                               }
> > +                       }
> >                         return 0;
> >
> >                 default:
> > @@ -532,7 +552,8 @@ static int wdt_notify_sys(struct notifier_block *this, unsigned long code,
> >         void *unused)
> >  {
> >         if (code == SYS_DOWN || code == SYS_HALT)
> > -               wdt_stop();
> > +               if (wdt_stop())
> > +                       return -EBUSY;
>
> -EBUSY is not a valid return code here.
>
> >         return NOTIFY_DONE;
> >  }
> >
> > @@ -560,16 +581,15 @@ static int __init it87_wdt_init(void)
> >         int rc = 0;
> >         int try_gameport = !nogameport;
> >         u8  chip_rev;
> > -       unsigned long flags;
> >
> >         wdt_status = 0;
> >
> > -       spin_lock_irqsave(&spinlock, flags);
> > -       superio_enter();
> > +       if (superio_enter())
> > +               return -EBUSY;
> > +
> >         chip_type = superio_inw(CHIPID);
> >         chip_rev  = superio_inb(CHIPREV) & 0x0f;
> >         superio_exit();
> > -       spin_unlock_irqrestore(&spinlock, flags);
> >
> >         switch (chip_type) {
> >         case IT8702_ID:
> > @@ -603,8 +623,8 @@ static int __init it87_wdt_init(void)
> >                 return -ENODEV;
> >         }
> >
> > -       spin_lock_irqsave(&spinlock, flags);
> > -       superio_enter();
> > +       if (superio_enter())
> > +               return -EBUSY;
> >
> >         superio_select(GPIO);
> >         superio_outb(WDT_TOV1, WDTCFG);
> > @@ -621,14 +641,12 @@ static int __init it87_wdt_init(void)
> >                 gpact = superio_inb(ACTREG);
> >                 superio_outb(0x01, ACTREG);
> >                 superio_exit();
> > -               spin_unlock_irqrestore(&spinlock, flags);
> >                 if (request_region(base, 1, WATCHDOG_NAME))
> >                         set_bit(WDTS_USE_GP, &wdt_status);
> >                 else
> >                         rc = -EIO;
> >         } else {
> >                 superio_exit();
> > -               spin_unlock_irqrestore(&spinlock, flags);
> >         }
> >
> >         /* If we haven't Gameport support, try to get CIR support */
> > @@ -646,8 +664,8 @@ static int __init it87_wdt_init(void)
> >                         goto err_out;
> >                 }
> >                 base = CIR_BASE;
> > -               spin_lock_irqsave(&spinlock, flags);
> > -               superio_enter();
> > +               if (superio_enter())
> > +                       return -EBUSY;
> >
> >                 superio_select(CIR);
> >                 superio_outw(base, BASEREG);
> > @@ -660,7 +678,6 @@ static int __init it87_wdt_init(void)
> >                 }
> >
> >                 superio_exit();
> > -               spin_unlock_irqrestore(&spinlock, flags);
> >         }
> >
> >         if (timeout < 1 || timeout > max_units * 60) {
> > @@ -711,21 +728,19 @@ err_out_reboot:
> >  err_out_region:
> >         release_region(base, test_bit(WDTS_USE_GP, &wdt_status) ? 1 : 8);
> >         if (!test_bit(WDTS_USE_GP, &wdt_status)) {
> > -               spin_lock_irqsave(&spinlock, flags);
> > -               superio_enter();
> > +               if (superio_enter())
> > +                       return -EBUSY;
> >                 superio_select(CIR);
> >                 superio_outb(ciract, ACTREG);
> >                 superio_exit();
> > -               spin_unlock_irqrestore(&spinlock, flags);
> >         }
> >  err_out:
> >         if (try_gameport) {
> > -               spin_lock_irqsave(&spinlock, flags);
> > -               superio_enter();
> > +               if (superio_enter())
> > +                       return -EBUSY;
> >                 superio_select(GAMEPORT);
> >                 superio_outb(gpact, ACTREG);
> >                 superio_exit();
> > -               spin_unlock_irqrestore(&spinlock, flags);
> >         }
> >
> >         return rc;
> > @@ -733,11 +748,9 @@ err_out:
> >
> >  static void __exit it87_wdt_exit(void)
> >  {
> > -       unsigned long flags;
> > -       int nolock;
> > +       if (superio_enter())
> > +               return;
>
> Assumption is that you unregister the device. So even if superio_select fails,
> you still have to execute the rest of the code.
>
> >
> > -       nolock = !spin_trylock_irqsave(&spinlock, flags);
> > -       superio_enter();
> >         superio_select(GPIO);
> >         superio_outb(0x00, WDTCTRL);
> >         superio_outb(0x00, WDTCFG);
> > @@ -752,8 +765,6 @@ static void __exit it87_wdt_exit(void)
> >                 superio_outb(ciract, ACTREG);
> >         }
> >         superio_exit();
> > -       if (!nolock)
> > -               spin_unlock_irqrestore(&spinlock, flags);
> >
> >         misc_deregister(&wdt_miscdev);
> >         unregister_reboot_notifier(&wdt_notifier);
> > --
> > 1.7.3.1
> >
>
> --
> Guenter Roeck
> Distinguished Engineer
> PDU IP Systems



--
Regards
Nat Gurumoorthy AB6SJ
