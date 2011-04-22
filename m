Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751053Ab1DVEpr (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Apr 2011 00:45:47 -0400
Received: from imr3.ericy.com ([198.24.6.13]:37663 "EHLO imr3.ericy.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750793Ab1DVEpp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Apr 2011 00:45:45 -0400
Date: Thu, 21 Apr 2011 21:44:51 -0700
From: Guenter Roeck <guenter.roeck@ericsson.com>
To: Nat Gurumoorthy <natg@google.com>
CC: Jean Delvare <khali@linux-fr.org>, Wim Van Sebroeck <wim@iguana.be>,
        Mike Waychison <mikew@google.com>,
        "lm-sensors@lm-sensors.org" <lm-sensors@lm-sensors.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-watchdog@vger.kernel.org" <linux-watchdog@vger.kernel.org>
Subject: Re: [PATCH v7 1/2] Use "request_muxed_region" in it87 watchdog
 drivers
Message-ID: <20110422044451.GB524@ericsson.com>
References: <1303153127-11717-1-git-send-email-natg@google.com>
 <1303153204-11784-1-git-send-email-natg@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <1303153204-11784-1-git-send-email-natg@google.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Apr 18, 2011 at 03:00:04PM -0400, Nat Gurumoorthy wrote:
> 01 - Changes to it87 watchdog driver to use "request_muxed_region"
> Serialize access to the hardware by using "request_muxed_region" macro defined
> by Alan Cox. Call to this macro will hold off the requestor if the resource is
> currently busy.
> 
> The use of the above macro makes it possible to get rid of
> spinlocks in it8712f_wdt.c and it87_wdt.c watchdog drivers.
> This also greatly simplifies the implementation of it87_wdt.c driver.
> 
>  "superio_enter" will return an error if call to "request_muxed_region" fails.
> Rest of the code change is to ripple an error return from superio_enter to
> the top level.
> 
> Signed-off-by: Nat Gurumoorthy <natg@google.com>
> ---
> 
> diff --git a/drivers/watchdog/it8712f_wdt.c b/drivers/watchdog/it8712f_wdt.c
> index 6143f52..0442889 100644
> --- a/drivers/watchdog/it8712f_wdt.c
> +++ b/drivers/watchdog/it8712f_wdt.c
> @@ -51,7 +51,6 @@ MODULE_PARM_DESC(nowayout, "Disable watchdog shutdown on close");
> 
>  static unsigned long wdt_open;
>  static unsigned expect_close;
> -static spinlock_t io_lock;
>  static unsigned char revision;
> 
>  /* Dog Food address - We use the game port address */
> @@ -121,20 +120,27 @@ static inline void superio_select(int ldn)
>         outb(ldn, VAL);
>  }
> 
> -static inline void superio_enter(void)
> +static inline int
> +superio_enter(void)
>  {
> -       spin_lock(&io_lock);
> +       /*
> +        * Try to reserve REG and REG + 1 for exclusive access.
> +        */
> +       if (!request_muxed_region(REG, 2, NAME))
> +               return -EBUSY;
> +
>         outb(0x87, REG);
>         outb(0x01, REG);
>         outb(0x55, REG);
>         outb(0x55, REG);
> +       return 0;
>  }
> 
>  static inline void superio_exit(void)
>  {
>         outb(0x02, REG);
>         outb(0x02, VAL);
> -       spin_unlock(&io_lock);
> +       release_region(REG, 2);
>  }
> 
>  static inline void it8712f_wdt_ping(void)
> @@ -173,10 +179,12 @@ static int it8712f_wdt_get_status(void)
>                 return 0;
>  }
> 
> -static void it8712f_wdt_enable(void)
> +static int it8712f_wdt_enable(void)
>  {
>         printk(KERN_DEBUG NAME ": enabling watchdog timer\n");
> -       superio_enter();
> +       if (superio_enter())
> +               return -EBUSY;
> +
>         superio_select(LDN_GPIO);
> 
>         superio_outb(wdt_control_reg, WDT_CONTROL);
> @@ -186,13 +194,17 @@ static void it8712f_wdt_enable(void)
>         superio_exit();
> 
>         it8712f_wdt_ping();
> +
> +       return 0;
>  }
> 
> -static void it8712f_wdt_disable(void)
> +static int it8712f_wdt_disable(void)
>  {
>         printk(KERN_DEBUG NAME ": disabling watchdog timer\n");
> 
> -       superio_enter();
> +       if (superio_enter())
> +               return -EBUSY;

If you lookk at other drivers implementing the same, you'll notice
that the idea is to return the error code you get from superio_enter(),
instead of replacing it with another one. Sure, it is in practice the same,
but that is not the point.

> +
>         superio_select(LDN_GPIO);
> 
>         superio_outb(0, WDT_CONFIG);
> @@ -202,6 +214,7 @@ static void it8712f_wdt_disable(void)
>         superio_outb(0, WDT_TIMEOUT);
> 
>         superio_exit();
> +       return 0;
>  }
> 
>  static int it8712f_wdt_notify(struct notifier_block *this,
> @@ -209,7 +222,8 @@ static int it8712f_wdt_notify(struct notifier_block *this,
>  {
>         if (code == SYS_HALT || code == SYS_POWER_OFF)
>                 if (!nowayout)
> -                       it8712f_wdt_disable();
> +                       if (it8712f_wdt_disable())
> +                               return -EBUSY;

That is not a valid return code for notifier calls. Sometimes one has
to ignore an error code. Again, compare with other drivers what they do
in this situation.

> 
>         return NOTIFY_DONE;
>  }
> @@ -259,7 +273,8 @@ static long it8712f_wdt_ioctl(struct file *file, unsigned int cmd,
>                         return -EFAULT;
>                 return 0;
>         case WDIOC_GETSTATUS:
> -               superio_enter();
> +               if (superio_enter())
> +                       return -EBUSY;
>                 superio_select(LDN_GPIO);
> 
>                 value = it8712f_wdt_get_status();
> @@ -280,7 +295,8 @@ static long it8712f_wdt_ioctl(struct file *file, unsigned int cmd,
>                 if (value > (max_units * 60))
>                         return -EINVAL;
>                 margin = value;
> -               superio_enter();
> +               if (superio_enter())
> +                       return -EBUSY;
>                 superio_select(LDN_GPIO);
> 
>                 it8712f_wdt_update_margin();
> @@ -302,7 +318,8 @@ static int it8712f_wdt_open(struct inode *inode, struct file *file)
>         /* only allow one at a time */
>         if (test_and_set_bit(0, &wdt_open))
>                 return -EBUSY;
> -       it8712f_wdt_enable();
> +       if (it8712f_wdt_enable())
> +               return -EBUSY;
>         return nonseekable_open(inode, file);
>  }
> 
> @@ -313,7 +330,8 @@ static int it8712f_wdt_release(struct inode *inode, struct file *file)
>                         ": watchdog device closed unexpectedly, will not"
>                         " disable the watchdog timer\n");
>         } else if (!nowayout) {
> -               it8712f_wdt_disable();
> +               if (it8712f_wdt_disable())
> +                       return -EBUSY;
>         }
>         expect_close = 0;
>         clear_bit(0, &wdt_open);
> @@ -341,7 +359,9 @@ static int __init it8712f_wdt_find(unsigned short *address)
>         int err = -ENODEV;
>         int chip_type;
> 
> -       superio_enter();
> +       if (superio_enter())
> +               return -EBUSY;
> +
>         chip_type = superio_inw(DEVID);
>         if (chip_type != IT8712F_DEVID)
>                 goto exit;
> @@ -382,8 +402,6 @@ static int __init it8712f_wdt_init(void)
>  {
>         int err = 0;
> 
> -       spin_lock_init(&io_lock);
> -
>         if (it8712f_wdt_find(&address))
>                 return -ENODEV;
> 
> @@ -392,7 +410,8 @@ static int __init it8712f_wdt_init(void)
>                 return -EBUSY;
>         }
> 
> -       it8712f_wdt_disable();
> +       if (it8712f_wdt_disable())
> +               return -EBUSY;
> 
>         err = register_reboot_notifier(&it8712f_wdt_notifier);
>         if (err) {
> diff --git a/drivers/watchdog/it87_wdt.c b/drivers/watchdog/it87_wdt.c
> index b1bc72f..39c98cb 100644
> --- a/drivers/watchdog/it87_wdt.c
> +++ b/drivers/watchdog/it87_wdt.c
> @@ -137,7 +137,6 @@
> 
>  static unsigned int base, gpact, ciract, max_units, chip_type;
>  static unsigned long wdt_status;
> -static DEFINE_SPINLOCK(spinlock);
> 
>  static int nogameport = DEFAULT_NOGAMEPORT;
>  static int exclusive  = DEFAULT_EXCLUSIVE;
> @@ -163,18 +162,27 @@ MODULE_PARM_DESC(nowayout, "Watchdog cannot be stopped once started, default="
> 
>  /* Superio Chip */
> 
> -static inline void superio_enter(void)
> +static inline int
> +superio_enter(void)
>  {
> +       /*
> +        * Try to reserve REG and REG + 1 for exclusive access.
> +        */
> +       if (!request_muxed_region(REG, 2, WATCHDOG_NAME))
> +               return -EBUSY;
> +
>         outb(0x87, REG);
>         outb(0x01, REG);
>         outb(0x55, REG);
>         outb(0x55, REG);
> +       return 0;
>  }
> 
>  static inline void superio_exit(void)
>  {
>         outb(0x02, REG);
>         outb(0x02, VAL);
> +       release_region(REG, 2);
>  }
> 
>  static inline void superio_select(int ldn)
> @@ -255,12 +263,10 @@ static void wdt_keepalive(void)
>         set_bit(WDTS_KEEPALIVE, &wdt_status);
>  }
> 
> -static void wdt_start(void)
> +static int wdt_start(void)
>  {
> -       unsigned long flags;
> -
> -       spin_lock_irqsave(&spinlock, flags);
> -       superio_enter();
> +       if (superio_enter())
> +               return -EBUSY;
> 
>         superio_select(GPIO);
>         if (test_bit(WDTS_USE_GP, &wdt_status))
> @@ -270,15 +276,14 @@ static void wdt_start(void)
>         wdt_update_timeout();
> 
>         superio_exit();
> -       spin_unlock_irqrestore(&spinlock, flags);
> +
> +       return 0;
>  }
> 
> -static void wdt_stop(void)
> +static int wdt_stop(void)
>  {
> -       unsigned long flags;
> -
> -       spin_lock_irqsave(&spinlock, flags);
> -       superio_enter();
> +       if (superio_enter())
> +               return -EBUSY;
> 
>         superio_select(GPIO);
>         superio_outb(0x00, WDTCTRL);
> @@ -288,7 +293,7 @@ static void wdt_stop(void)
>                 superio_outb(0x00, WDTVALMSB);
> 
>         superio_exit();
> -       spin_unlock_irqrestore(&spinlock, flags);
> +       return 0;
>  }
> 
>  /**
> @@ -303,8 +308,6 @@ static void wdt_stop(void)
> 
>  static int wdt_set_timeout(int t)
>  {
> -       unsigned long flags;
> -
>         if (t < 1 || t > max_units * 60)
>                 return -EINVAL;
> 
> @@ -313,14 +316,14 @@ static int wdt_set_timeout(int t)
>         else
>                 timeout = t;
> 
> -       spin_lock_irqsave(&spinlock, flags);
>         if (test_bit(WDTS_TIMER_RUN, &wdt_status)) {
> -               superio_enter();
> +               if (superio_enter())
> +                       return -EBUSY;
> +
I don't think you can do that here. You are moving the lock,
meaning test_bit is no longer protected by the lock.

>                 superio_select(GPIO);
>                 wdt_update_timeout();
>                 superio_exit();
>         }
> -       spin_unlock_irqrestore(&spinlock, flags);
>         return 0;
>  }
> 
> @@ -339,12 +342,10 @@ static int wdt_set_timeout(int t)
> 
>  static int wdt_get_status(int *status)
>  {
> -       unsigned long flags;
> -
>         *status = 0;
>         if (testmode) {
> -               spin_lock_irqsave(&spinlock, flags);
> -               superio_enter();
> +               if (superio_enter())
> +                       return -EBUSY;
>                 superio_select(GPIO);
>                 if (superio_inb(WDTCTRL) & WDT_ZERO) {
>                         superio_outb(0x00, WDTCTRL);
> @@ -353,7 +354,6 @@ static int wdt_get_status(int *status)
>                 }
> 
>                 superio_exit();
> -               spin_unlock_irqrestore(&spinlock, flags);
>         }
>         if (test_and_clear_bit(WDTS_KEEPALIVE, &wdt_status))
>                 *status |= WDIOF_KEEPALIVEPING;
> @@ -381,7 +381,12 @@ static int wdt_open(struct inode *inode, struct file *file)
>         if (!test_and_set_bit(WDTS_TIMER_RUN, &wdt_status)) {
>                 if (nowayout && !test_and_set_bit(WDTS_LOCKED, &wdt_status))
>                         __module_get(THIS_MODULE);
> -               wdt_start();
> +               if (wdt_start()) {
> +                       clear_bit(WDTS_LOCKED, &wdt_status);
> +                       clear_bit(WDTS_TIMER_RUN, &wdt_status);
> +                       clear_bit(WDTS_DEV_OPEN, &wdt_status);
> +                       return -EBUSY;
> +               }
>         }
>         return nonseekable_open(inode, file);
>  }
> @@ -403,7 +408,15 @@ static int wdt_release(struct inode *inode, struct file *file)
>  {
>         if (test_bit(WDTS_TIMER_RUN, &wdt_status)) {
>                 if (test_and_clear_bit(WDTS_EXPECTED, &wdt_status)) {
> -                       wdt_stop();
> +                       if (wdt_stop()) {
> +                               /*
> +                                * Stop failed. Just keep the watchdog alive
> +                                * and hope nothing bad happens.
> +                                */
> +                               set_bit(WDTS_EXPECTED, &wdt_status);
> +                               wdt_keepalive();
> +                               return -EBUSY;
> +                       }
>                         clear_bit(WDTS_TIMER_RUN, &wdt_status);
>                 } else {
>                         wdt_keepalive();
> @@ -484,7 +497,8 @@ static long wdt_ioctl(struct file *file, unsigned int cmd, unsigned long arg)
>                                     &ident, sizeof(ident)) ? -EFAULT : 0;
> 
>         case WDIOC_GETSTATUS:
> -               wdt_get_status(&status);
> +               if (wdt_get_status(&status))
> +                       return -EBUSY;
>                 return put_user(status, uarg.i);
> 
>         case WDIOC_GETBOOTSTATUS:
> @@ -501,13 +515,19 @@ static long wdt_ioctl(struct file *file, unsigned int cmd, unsigned long arg)
>                 switch (new_options) {
>                 case WDIOS_DISABLECARD:
>                         if (test_bit(WDTS_TIMER_RUN, &wdt_status))
> -                               wdt_stop();
> +                               if (wdt_stop())
> +                                       return -EBUSY;
> +
>                         clear_bit(WDTS_TIMER_RUN, &wdt_status);
>                         return 0;
> 
>                 case WDIOS_ENABLECARD:
> -                       if (!test_and_set_bit(WDTS_TIMER_RUN, &wdt_status))
> -                               wdt_start();
> +                       if (!test_and_set_bit(WDTS_TIMER_RUN, &wdt_status)) {
> +                               if (wdt_start()) {
> +                                       clear_bit(WDTS_TIMER_RUN, &wdt_status);
> +                                       return -EBUSY;
> +                               }
> +                       }
>                         return 0;
> 
>                 default:
> @@ -532,7 +552,8 @@ static int wdt_notify_sys(struct notifier_block *this, unsigned long code,
>         void *unused)
>  {
>         if (code == SYS_DOWN || code == SYS_HALT)
> -               wdt_stop();
> +               if (wdt_stop())
> +                       return -EBUSY;

-EBUSY is not a valid return code here.

>         return NOTIFY_DONE;
>  }
> 
> @@ -560,16 +581,15 @@ static int __init it87_wdt_init(void)
>         int rc = 0;
>         int try_gameport = !nogameport;
>         u8  chip_rev;
> -       unsigned long flags;
> 
>         wdt_status = 0;
> 
> -       spin_lock_irqsave(&spinlock, flags);
> -       superio_enter();
> +       if (superio_enter())
> +               return -EBUSY;
> +
>         chip_type = superio_inw(CHIPID);
>         chip_rev  = superio_inb(CHIPREV) & 0x0f;
>         superio_exit();
> -       spin_unlock_irqrestore(&spinlock, flags);
> 
>         switch (chip_type) {
>         case IT8702_ID:
> @@ -603,8 +623,8 @@ static int __init it87_wdt_init(void)
>                 return -ENODEV;
>         }
> 
> -       spin_lock_irqsave(&spinlock, flags);
> -       superio_enter();
> +       if (superio_enter())
> +               return -EBUSY;
> 
>         superio_select(GPIO);
>         superio_outb(WDT_TOV1, WDTCFG);
> @@ -621,14 +641,12 @@ static int __init it87_wdt_init(void)
>                 gpact = superio_inb(ACTREG);
>                 superio_outb(0x01, ACTREG);
>                 superio_exit();
> -               spin_unlock_irqrestore(&spinlock, flags);
>                 if (request_region(base, 1, WATCHDOG_NAME))
>                         set_bit(WDTS_USE_GP, &wdt_status);
>                 else
>                         rc = -EIO;
>         } else {
>                 superio_exit();
> -               spin_unlock_irqrestore(&spinlock, flags);
>         }
> 
>         /* If we haven't Gameport support, try to get CIR support */
> @@ -646,8 +664,8 @@ static int __init it87_wdt_init(void)
>                         goto err_out;
>                 }
>                 base = CIR_BASE;
> -               spin_lock_irqsave(&spinlock, flags);
> -               superio_enter();
> +               if (superio_enter())
> +                       return -EBUSY;
> 
>                 superio_select(CIR);
>                 superio_outw(base, BASEREG);
> @@ -660,7 +678,6 @@ static int __init it87_wdt_init(void)
>                 }
> 
>                 superio_exit();
> -               spin_unlock_irqrestore(&spinlock, flags);
>         }
> 
>         if (timeout < 1 || timeout > max_units * 60) {
> @@ -711,21 +728,19 @@ err_out_reboot:
>  err_out_region:
>         release_region(base, test_bit(WDTS_USE_GP, &wdt_status) ? 1 : 8);
>         if (!test_bit(WDTS_USE_GP, &wdt_status)) {
> -               spin_lock_irqsave(&spinlock, flags);
> -               superio_enter();
> +               if (superio_enter())
> +                       return -EBUSY;
>                 superio_select(CIR);
>                 superio_outb(ciract, ACTREG);
>                 superio_exit();
> -               spin_unlock_irqrestore(&spinlock, flags);
>         }
>  err_out:
>         if (try_gameport) {
> -               spin_lock_irqsave(&spinlock, flags);
> -               superio_enter();
> +               if (superio_enter())
> +                       return -EBUSY;
>                 superio_select(GAMEPORT);
>                 superio_outb(gpact, ACTREG);
>                 superio_exit();
> -               spin_unlock_irqrestore(&spinlock, flags);
>         }
> 
>         return rc;
> @@ -733,11 +748,9 @@ err_out:
> 
>  static void __exit it87_wdt_exit(void)
>  {
> -       unsigned long flags;
> -       int nolock;
> +       if (superio_enter())
> +               return;

Assumption is that you unregister the device. So even if superio_select fails,
you still have to execute the rest of the code.

> 
> -       nolock = !spin_trylock_irqsave(&spinlock, flags);
> -       superio_enter();
>         superio_select(GPIO);
>         superio_outb(0x00, WDTCTRL);
>         superio_outb(0x00, WDTCFG);
> @@ -752,8 +765,6 @@ static void __exit it87_wdt_exit(void)
>                 superio_outb(ciract, ACTREG);
>         }
>         superio_exit();
> -       if (!nolock)
> -               spin_unlock_irqrestore(&spinlock, flags);
> 
>         misc_deregister(&wdt_miscdev);
>         unregister_reboot_notifier(&wdt_notifier);
> --
> 1.7.3.1
> 

-- 
Guenter Roeck
Distinguished Engineer
PDU IP Systems
