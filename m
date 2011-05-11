Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753887Ab1EKCxA (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 May 2011 22:53:00 -0400
Received: from imr4.ericy.com ([198.24.6.8]:33434 "EHLO imr4.ericy.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753122Ab1EKCw7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 May 2011 22:52:59 -0400
Date: Tue, 10 May 2011 19:52:07 -0700
From: Guenter Roeck <guenter.roeck@ericsson.com>
To: Nat Gurumoorthy <natg@google.com>
CC: Jean Delvare <khali@linux-fr.org>, Wim Van Sebroeck <wim@iguana.be>,
        "lm-sensors@lm-sensors.org" <lm-sensors@lm-sensors.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "mikew@google.com" <mikew@google.com>
Subject: Re: [PATCH v10 1/2] Use "request_muxed_region" in it87 watchdog
 drivers
Message-ID: <20110511025207.GA4051@ericsson.com>
References: <1304966644-19798-1-git-send-email-natg@google.com>
 <1304966707-19850-1-git-send-email-natg@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <1304966707-19850-1-git-send-email-natg@google.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, May 09, 2011 at 02:45:07PM -0400, Nat Gurumoorthy wrote:
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

One comment inline below; ok with me but others may have concerns.

Acked-by: Guenter Roeck <guenter.roeck@ericsson.com>

> ---
> 
> diff --git a/drivers/watchdog/it8712f_wdt.c b/drivers/watchdog/it8712f_wdt.c
> index 6143f52..c8677ac 100644
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
> @@ -173,10 +179,13 @@ static int it8712f_wdt_get_status(void)
>                 return 0;
>  }
> 
> -static void it8712f_wdt_enable(void)
> +static int it8712f_wdt_enable(void)
>  {
> +       int ret = superio_enter();
> +       if (ret)
> +               return ret;
> +
>         printk(KERN_DEBUG NAME ": enabling watchdog timer\n");
> -       superio_enter();
>         superio_select(LDN_GPIO);
> 
>         superio_outb(wdt_control_reg, WDT_CONTROL);
> @@ -186,13 +195,17 @@ static void it8712f_wdt_enable(void)
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
> -       printk(KERN_DEBUG NAME ": disabling watchdog timer\n");
> +       int ret = superio_enter();
> +       if (ret)
> +               return ret;
> 
> -       superio_enter();
> +       printk(KERN_DEBUG NAME ": disabling watchdog timer\n");
>         superio_select(LDN_GPIO);
> 
>         superio_outb(0, WDT_CONFIG);
> @@ -202,6 +215,7 @@ static void it8712f_wdt_disable(void)
>         superio_outb(0, WDT_TIMEOUT);
> 
>         superio_exit();
> +       return 0;
>  }
> 
>  static int it8712f_wdt_notify(struct notifier_block *this,
> @@ -252,6 +266,7 @@ static long it8712f_wdt_ioctl(struct file *file, unsigned int cmd,
>                                                 WDIOF_MAGICCLOSE,
>         };
>         int value;
> +       int ret;
> 
>         switch (cmd) {
>         case WDIOC_GETSUPPORT:
> @@ -259,7 +274,9 @@ static long it8712f_wdt_ioctl(struct file *file, unsigned int cmd,
>                         return -EFAULT;
>                 return 0;
>         case WDIOC_GETSTATUS:
> -               superio_enter();
> +               ret = superio_enter();
> +               if (ret)
> +                       return ret;
>                 superio_select(LDN_GPIO);
> 
>                 value = it8712f_wdt_get_status();
> @@ -280,7 +297,9 @@ static long it8712f_wdt_ioctl(struct file *file, unsigned int cmd,
>                 if (value > (max_units * 60))
>                         return -EINVAL;
>                 margin = value;
> -               superio_enter();
> +               ret = superio_enter();
> +               if (ret)
> +                       return ret;
>                 superio_select(LDN_GPIO);
> 
>                 it8712f_wdt_update_margin();
> @@ -299,10 +318,14 @@ static long it8712f_wdt_ioctl(struct file *file, unsigned int cmd,
> 
>  static int it8712f_wdt_open(struct inode *inode, struct file *file)
>  {
> +       int ret;
>         /* only allow one at a time */
>         if (test_and_set_bit(0, &wdt_open))
>                 return -EBUSY;
> -       it8712f_wdt_enable();
> +
> +       ret = it8712f_wdt_enable();
> +       if (ret)
> +               return ret;
>         return nonseekable_open(inode, file);
>  }
> 
> @@ -313,7 +336,8 @@ static int it8712f_wdt_release(struct inode *inode, struct file *file)
>                         ": watchdog device closed unexpectedly, will not"
>                         " disable the watchdog timer\n");
>         } else if (!nowayout) {
> -               it8712f_wdt_disable();
> +               if (it8712f_wdt_disable())
> +                       printk(KERN_WARNING NAME "Watchdog disable failed\n");
>         }
>         expect_close = 0;
>         clear_bit(0, &wdt_open);
> @@ -340,8 +364,10 @@ static int __init it8712f_wdt_find(unsigned short *address)
>  {
>         int err = -ENODEV;
>         int chip_type;
> +       int ret = superio_enter();
> +       if (ret)
> +               return ret;
> 
> -       superio_enter();
>         chip_type = superio_inw(DEVID);
>         if (chip_type != IT8712F_DEVID)
>                 goto exit;
> @@ -382,8 +408,6 @@ static int __init it8712f_wdt_init(void)
>  {
>         int err = 0;
> 
> -       spin_lock_init(&io_lock);
> -
>         if (it8712f_wdt_find(&address))
>                 return -ENODEV;
> 
> @@ -392,7 +416,11 @@ static int __init it8712f_wdt_init(void)
>                 return -EBUSY;
>         }
> 
> -       it8712f_wdt_disable();
> +       err = it8712f_wdt_disable();
> +       if (err) {
> +               printk(KERN_ERR NAME ": unable to disable watchdog timer.\n");
> +               goto out;
> +       }
> 
>         err = register_reboot_notifier(&it8712f_wdt_notifier);
>         if (err) {
> diff --git a/drivers/watchdog/it87_wdt.c b/drivers/watchdog/it87_wdt.c
> index b1bc72f..e3c03a9 100644
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
> @@ -255,12 +263,11 @@ static void wdt_keepalive(void)
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
> +       int ret = superio_enter();
> +       if (ret)
> +               return ret;
> 
>         superio_select(GPIO);
>         if (test_bit(WDTS_USE_GP, &wdt_status))
> @@ -270,15 +277,15 @@ static void wdt_start(void)
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
> +       int ret = superio_enter();
> +       if (ret)
> +               return ret;
> 
>         superio_select(GPIO);
>         superio_outb(0x00, WDTCTRL);
> @@ -288,7 +295,7 @@ static void wdt_stop(void)
>                 superio_outb(0x00, WDTVALMSB);
> 
>         superio_exit();
> -       spin_unlock_irqrestore(&spinlock, flags);
> +       return 0;
>  }
> 
>  /**
> @@ -303,8 +310,6 @@ static void wdt_stop(void)
> 
>  static int wdt_set_timeout(int t)
>  {
> -       unsigned long flags;
> -
>         if (t < 1 || t > max_units * 60)
>                 return -EINVAL;
> 
> @@ -313,14 +318,15 @@ static int wdt_set_timeout(int t)
>         else
>                 timeout = t;
> 
> -       spin_lock_irqsave(&spinlock, flags);
>         if (test_bit(WDTS_TIMER_RUN, &wdt_status)) {
> -               superio_enter();
> +               int ret = superio_enter();
> +               if (ret)
> +                       return ret;
> +
>                 superio_select(GPIO);
>                 wdt_update_timeout();
>                 superio_exit();
>         }
> -       spin_unlock_irqrestore(&spinlock, flags);
>         return 0;
>  }
> 
> @@ -339,12 +345,12 @@ static int wdt_set_timeout(int t)
> 
>  static int wdt_get_status(int *status)
>  {
> -       unsigned long flags;
> -
>         *status = 0;
>         if (testmode) {
> -               spin_lock_irqsave(&spinlock, flags);
> -               superio_enter();
> +               int ret = superio_enter();
> +               if (ret)
> +                       return ret;
> +
>                 superio_select(GPIO);
>                 if (superio_inb(WDTCTRL) & WDT_ZERO) {
>                         superio_outb(0x00, WDTCTRL);
> @@ -353,7 +359,6 @@ static int wdt_get_status(int *status)
>                 }
> 
>                 superio_exit();
> -               spin_unlock_irqrestore(&spinlock, flags);
>         }
>         if (test_and_clear_bit(WDTS_KEEPALIVE, &wdt_status))
>                 *status |= WDIOF_KEEPALIVEPING;
> @@ -379,9 +384,17 @@ static int wdt_open(struct inode *inode, struct file *file)
>         if (exclusive && test_and_set_bit(WDTS_DEV_OPEN, &wdt_status))
>                 return -EBUSY;
>         if (!test_and_set_bit(WDTS_TIMER_RUN, &wdt_status)) {
> +               int ret;
>                 if (nowayout && !test_and_set_bit(WDTS_LOCKED, &wdt_status))
>                         __module_get(THIS_MODULE);
> -               wdt_start();
> +
> +               ret = wdt_start();
> +               if (ret) {
> +                       clear_bit(WDTS_LOCKED, &wdt_status);
> +                       clear_bit(WDTS_TIMER_RUN, &wdt_status);
> +                       clear_bit(WDTS_DEV_OPEN, &wdt_status);
> +                       return ret;
> +               }
>         }
>         return nonseekable_open(inode, file);
>  }
> @@ -403,7 +416,16 @@ static int wdt_release(struct inode *inode, struct file *file)
>  {
>         if (test_bit(WDTS_TIMER_RUN, &wdt_status)) {
>                 if (test_and_clear_bit(WDTS_EXPECTED, &wdt_status)) {
> -                       wdt_stop();
> +                       int ret = wdt_stop();
> +                       if (ret) {
> +                               /*
> +                                * Stop failed. Just keep the watchdog alive
> +                                * and hope nothing bad happens.
> +                                */
> +                               set_bit(WDTS_EXPECTED, &wdt_status);
> +                               wdt_keepalive();
> +                               return ret;
> +                       }
>                         clear_bit(WDTS_TIMER_RUN, &wdt_status);
>                 } else {
>                         wdt_keepalive();
> @@ -484,7 +506,9 @@ static long wdt_ioctl(struct file *file, unsigned int cmd, unsigned long arg)
>                                     &ident, sizeof(ident)) ? -EFAULT : 0;
> 
>         case WDIOC_GETSTATUS:
> -               wdt_get_status(&status);
> +               rc = wdt_get_status(&status);
> +               if (rc)
> +                       return rc;
>                 return put_user(status, uarg.i);
> 
>         case WDIOC_GETBOOTSTATUS:
> @@ -500,14 +524,22 @@ static long wdt_ioctl(struct file *file, unsigned int cmd, unsigned long arg)
> 
>                 switch (new_options) {
>                 case WDIOS_DISABLECARD:
> -                       if (test_bit(WDTS_TIMER_RUN, &wdt_status))
> -                               wdt_stop();
> +                       if (test_bit(WDTS_TIMER_RUN, &wdt_status)) {
> +                               rc = wdt_stop();
> +                               if (rc)
> +                                       return rc;
> +                       }
>                         clear_bit(WDTS_TIMER_RUN, &wdt_status);
>                         return 0;
> 
>                 case WDIOS_ENABLECARD:
> -                       if (!test_and_set_bit(WDTS_TIMER_RUN, &wdt_status))
> -                               wdt_start();
> +                       if (!test_and_set_bit(WDTS_TIMER_RUN, &wdt_status)) {
> +                               rc = wdt_start();
> +                               if (rc) {
> +                                       clear_bit(WDTS_TIMER_RUN, &wdt_status);
> +                                       return rc;
> +                               }
> +                       }
>                         return 0;
> 
>                 default:
> @@ -560,16 +592,17 @@ static int __init it87_wdt_init(void)
>         int rc = 0;
>         int try_gameport = !nogameport;
>         u8  chip_rev;
> -       unsigned long flags;
> +       int gp_rreq_fail = 0;
> 
>         wdt_status = 0;
> 
> -       spin_lock_irqsave(&spinlock, flags);
> -       superio_enter();
> +       rc = superio_enter();
> +       if (rc)
> +               return rc;
> +
>         chip_type = superio_inw(CHIPID);
>         chip_rev  = superio_inb(CHIPREV) & 0x0f;
>         superio_exit();
> -       spin_unlock_irqrestore(&spinlock, flags);
> 
>         switch (chip_type) {
>         case IT8702_ID:
> @@ -603,8 +636,9 @@ static int __init it87_wdt_init(void)
>                 return -ENODEV;
>         }
> 
> -       spin_lock_irqsave(&spinlock, flags);
> -       superio_enter();
> +       rc = superio_enter();
> +       if (rc)
> +               return rc;
> 
>         superio_select(GPIO);
>         superio_outb(WDT_TOV1, WDTCFG);
> @@ -620,21 +654,16 @@ static int __init it87_wdt_init(void)
>                 }
>                 gpact = superio_inb(ACTREG);
>                 superio_outb(0x01, ACTREG);
> -               superio_exit();
> -               spin_unlock_irqrestore(&spinlock, flags);
>                 if (request_region(base, 1, WATCHDOG_NAME))
>                         set_bit(WDTS_USE_GP, &wdt_status);
>                 else
> -                       rc = -EIO;
> -       } else {
> -               superio_exit();
> -               spin_unlock_irqrestore(&spinlock, flags);
> +                       gp_rreq_fail = 1;
>         }
> 
>         /* If we haven't Gameport support, try to get CIR support */
>         if (!test_bit(WDTS_USE_GP, &wdt_status)) {
>                 if (!request_region(CIR_BASE, 8, WATCHDOG_NAME)) {
> -                       if (rc == -EIO)
> +                       if (gp_rreq_fail)
>                                 printk(KERN_ERR PFX
>                                         "I/O Address 0x%04x and 0x%04x"
>                                         " already in use\n", base, CIR_BASE);
> @@ -646,21 +675,16 @@ static int __init it87_wdt_init(void)
>                         goto err_out;
>                 }
>                 base = CIR_BASE;
> -               spin_lock_irqsave(&spinlock, flags);
> -               superio_enter();
> 
>                 superio_select(CIR);
>                 superio_outw(base, BASEREG);
>                 superio_outb(0x00, CIR_ILS);
>                 ciract = superio_inb(ACTREG);
>                 superio_outb(0x01, ACTREG);
> -               if (rc == -EIO) {
> +               if (gp_rreq_fail) {
>                         superio_select(GAMEPORT);
>                         superio_outb(gpact, ACTREG);
>                 }
> -
> -               superio_exit();

This is one possible solution; we'll have to see if the maintainer 
accepts it. There may be some concerns about blocking superio 
access during the calls to register_reboot_notifier() and misc_register().

> -               spin_unlock_irqrestore(&spinlock, flags);
>         }
> 
>         if (timeout < 1 || timeout > max_units * 60) {
> @@ -704,6 +728,7 @@ static int __init it87_wdt_init(void)
>                 "nogameport=%d)\n", chip_type, chip_rev, timeout,
>                 nowayout, testmode, exclusive, nogameport);
> 
> +       superio_exit();
>         return 0;
> 
>  err_out_reboot:
> @@ -711,49 +736,37 @@ err_out_reboot:
>  err_out_region:
>         release_region(base, test_bit(WDTS_USE_GP, &wdt_status) ? 1 : 8);
>         if (!test_bit(WDTS_USE_GP, &wdt_status)) {
> -               spin_lock_irqsave(&spinlock, flags);
> -               superio_enter();
>                 superio_select(CIR);
>                 superio_outb(ciract, ACTREG);
> -               superio_exit();
> -               spin_unlock_irqrestore(&spinlock, flags);
>         }
>  err_out:
>         if (try_gameport) {
> -               spin_lock_irqsave(&spinlock, flags);
> -               superio_enter();
>                 superio_select(GAMEPORT);
>                 superio_outb(gpact, ACTREG);
> -               superio_exit();
> -               spin_unlock_irqrestore(&spinlock, flags);
>         }
> 
> +       superio_exit();
>         return rc;
>  }
> 
>  static void __exit it87_wdt_exit(void)
>  {
> -       unsigned long flags;
> -       int nolock;
> -
> -       nolock = !spin_trylock_irqsave(&spinlock, flags);
> -       superio_enter();
> -       superio_select(GPIO);
> -       superio_outb(0x00, WDTCTRL);
> -       superio_outb(0x00, WDTCFG);
> -       superio_outb(0x00, WDTVALLSB);
> -       if (max_units > 255)
> -               superio_outb(0x00, WDTVALMSB);
> -       if (test_bit(WDTS_USE_GP, &wdt_status)) {
> -               superio_select(GAMEPORT);
> -               superio_outb(gpact, ACTREG);
> -       } else {
> -               superio_select(CIR);
> -               superio_outb(ciract, ACTREG);
> +       if (superio_enter() == 0) {
> +               superio_select(GPIO);
> +               superio_outb(0x00, WDTCTRL);
> +               superio_outb(0x00, WDTCFG);
> +               superio_outb(0x00, WDTVALLSB);
> +               if (max_units > 255)
> +                       superio_outb(0x00, WDTVALMSB);
> +               if (test_bit(WDTS_USE_GP, &wdt_status)) {
> +                       superio_select(GAMEPORT);
> +                       superio_outb(gpact, ACTREG);
> +               } else {
> +                       superio_select(CIR);
> +                       superio_outb(ciract, ACTREG);
> +               }
> +               superio_exit();
>         }
> -       superio_exit();
> -       if (!nolock)
> -               spin_unlock_irqrestore(&spinlock, flags);
> 
>         misc_deregister(&wdt_miscdev);
>         unregister_reboot_notifier(&wdt_notifier);
