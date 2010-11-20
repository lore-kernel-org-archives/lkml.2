Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753696Ab0KTPoY (ORCPT <rfc822;w@1wt.eu>);
	Sat, 20 Nov 2010 10:44:24 -0500
Received: from 81-174-11-161.staticnet.ngi.it ([81.174.11.161]:47547 "EHLO
	mail.enneenne.com" rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org
	with ESMTP id S1753032Ab0KTPoX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 20 Nov 2010 10:44:23 -0500
X-Greylist: delayed 1417 seconds by postgrey-1.27 at vger.kernel.org; Sat, 20 Nov 2010 10:44:22 EST
Date: Sat, 20 Nov 2010 16:44:17 +0100
From: Rodolfo Giometti <giometti@enneenne.com>
To: Alexander Gordeev <lasaine@lvk.cs.msu.su>
Cc: linux-kernel@vger.kernel.org, "Nikita V. Youshchenko" <yoush@cs.msu.su>,
        linuxpps@ml.enneenne.com, Greg Kroah-Hartman <gregkh@suse.de>,
        Andrew Morton <akpm@linux-foundation.org>, Tejun Heo <tj@kernel.org>
Message-ID: <20101120154416.GX13356@enneenne.com>
Mail-Followup-To: Alexander Gordeev <lasaine@lvk.cs.msu.su>,
	linux-kernel@vger.kernel.org,
	"Nikita V. Youshchenko" <yoush@cs.msu.su>, linuxpps@ml.enneenne.com,
	Greg Kroah-Hartman <gregkh@suse.de>,
	Andrew Morton <akpm@linux-foundation.org>,
	Tejun Heo <tj@kernel.org>
References: <cover.1290087473.git.lasaine@lvk.cs.msu.su>
 <57dad12253191b67a6a08bb9c464bd54e70e52a3.1290087479.git.lasaine@lvk.cs.msu.su>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-15
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <57dad12253191b67a6a08bb9c464bd54e70e52a3.1290087479.git.lasaine@lvk.cs.msu.su>
Organization: GNU/Linux Device Drivers, Embedded Systems and Courses
X-PGP-Key: gpg --keyserver keyserver.linux.it --recv-keys D25A5633
User-Agent: Mutt/1.5.20 (2009-06-14)
X-SA-Exim-Connect-IP: 192.168.32.37
X-SA-Exim-Mail-From: giometti@enneenne.com
Subject: Re: [PATCHv4 05/17] pps: access pps device by direct pointer
X-SA-Exim-Version: 4.2.1 (built Wed, 25 Jun 2008 17:14:11 +0000)
X-SA-Exim-Scanned: Yes (on mail.enneenne.com)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Nov 18, 2010 at 07:00:58PM +0300, Alexander Gordeev wrote:
> Using device index as a pointer needs some unnecessary work to be done
> every time the pointer is needed (in irq handler for example).
> Using a direct pointer is much more easy (and safe as well).
> 
> Signed-off-by: Alexander Gordeev <lasaine@lvk.cs.msu.su>
> ---
>  drivers/pps/clients/pps-ktimer.c |   30 ++++-----
>  drivers/pps/clients/pps-ldisc.c  |   52 ++++++++++------
>  drivers/pps/kapi.c               |  124 +++++++++-----------------------------
>  drivers/pps/pps.c                |   22 ++-----
>  include/linux/pps_kernel.h       |   23 +++----
>  5 files changed, 90 insertions(+), 161 deletions(-)
> 
> diff --git a/drivers/pps/clients/pps-ktimer.c b/drivers/pps/clients/pps-ktimer.c
> index e1bdd8b..966ead1 100644
> --- a/drivers/pps/clients/pps-ktimer.c
> +++ b/drivers/pps/clients/pps-ktimer.c
> @@ -31,7 +31,7 @@
>   * Global variables
>   */
>  
> -static int source;
> +static struct pps_device *pps;
>  static struct timer_list ktimer;
>  
>  /*
> @@ -47,7 +47,7 @@ static void pps_ktimer_event(unsigned long ptr)
>  
>  	pr_info("PPS event at %lu\n", jiffies);
>  
> -	pps_event(source, &ts, PPS_CAPTUREASSERT, NULL);
> +	pps_event(pps, &ts, PPS_CAPTUREASSERT, NULL);
>  
>  	mod_timer(&ktimer, jiffies + HZ);
>  }
> @@ -56,12 +56,11 @@ static void pps_ktimer_event(unsigned long ptr)
>   * The echo function
>   */
>  
> -static void pps_ktimer_echo(int source, int event, void *data)
> +static void pps_ktimer_echo(struct pps_device *pps, int event, void *data)
>  {
> -	pr_info("echo %s %s for source %d\n",
> +	dev_info(pps->dev, "echo %s %s\n",
>  		event & PPS_CAPTUREASSERT ? "assert" : "",
> -		event & PPS_CAPTURECLEAR ? "clear" : "",
> -		source);
> +		event & PPS_CAPTURECLEAR ? "clear" : "");
>  }
>  
>  /*
> @@ -84,30 +83,27 @@ static struct pps_source_info pps_ktimer_info = {
>  
>  static void __exit pps_ktimer_exit(void)
>  {
> -	del_timer_sync(&ktimer);
> -	pps_unregister_source(source);
> +	dev_info(pps->dev, "ktimer PPS source unregistered\n");
>  
> -	pr_info("ktimer PPS source unregistered\n");
> +	del_timer_sync(&ktimer);
> +	pps_unregister_source(pps);
>  }
>  
>  static int __init pps_ktimer_init(void)
>  {
> -	int ret;
> -
> -	ret = pps_register_source(&pps_ktimer_info,
> +	pps = pps_register_source(&pps_ktimer_info,
>  				PPS_CAPTUREASSERT | PPS_OFFSETASSERT);
> -	if (ret < 0) {
> +	if (pps == NULL) {
>  		printk(KERN_ERR "cannot register ktimer source\n");
> -		return ret;
> +		return -ENOMEM;
>  	}
> -	source = ret;
>  
>  	setup_timer(&ktimer, pps_ktimer_event, 0);
>  	mod_timer(&ktimer, jiffies + HZ);
>  
> -	pr_info("ktimer PPS source registered at %d\n", source);
> +	dev_info(pps->dev, "ktimer PPS source registered\n");
>  
> -	return  0;
> +	return 0;
>  }
>  
>  module_init(pps_ktimer_init);
> diff --git a/drivers/pps/clients/pps-ldisc.c b/drivers/pps/clients/pps-ldisc.c
> index 20fc9f7..1950b15 100644
> --- a/drivers/pps/clients/pps-ldisc.c
> +++ b/drivers/pps/clients/pps-ldisc.c
> @@ -23,14 +23,18 @@
>  #include <linux/serial_core.h>
>  #include <linux/tty.h>
>  #include <linux/pps_kernel.h>
> +#include <linux/spinlock.h>
>  
>  #define PPS_TTY_MAGIC		0x0001
>  
> +static DEFINE_SPINLOCK(pps_ldisc_lock);
> +
>  static void pps_tty_dcd_change(struct tty_struct *tty, unsigned int status,
>  				struct pps_event_time *ts)
>  {
> -	int id = (long)tty->disc_data;
> +	struct pps_device *pps;
>  	struct pps_event_time __ts;
> +	unsigned long flags;
>  
>  	/* First of all we get the time stamp... */
>  	pps_get_ts(&__ts);
> @@ -39,12 +43,18 @@ static void pps_tty_dcd_change(struct tty_struct *tty, unsigned int status,
>  	if (!ts)	/* No. Do it ourself! */
>  		ts = &__ts;
>  
> -	/* Now do the PPS event report */
> -	pps_event(id, ts, status ? PPS_CAPTUREASSERT : PPS_CAPTURECLEAR,
> -			NULL);
> +	spin_lock_irqsave(&pps_ldisc_lock, flags);
>  
> -	pr_debug("PPS %s at %lu on source #%d\n",
> -			status ? "assert" : "clear", jiffies, id);
> +	/* Now do the PPS event report */
> +	pps = (struct pps_device *)tty->disc_data;
> +	if (pps != NULL) {
> +		pps_event(pps, ts, status ? PPS_CAPTUREASSERT :
> +				PPS_CAPTURECLEAR, NULL);
> +		spin_unlock_irqrestore(&pps_ldisc_lock, flags);
> +		dev_dbg(pps->dev, "PPS %s at %lu\n",
> +				status ? "assert" : "clear", jiffies);

I think you should swap these two lines because after you release the
lock the pps pointer may be not valid...

> +	} else
> +		spin_unlock_irqrestore(&pps_ldisc_lock, flags);
>  }
>  
>  static int (*alias_n_tty_open)(struct tty_struct *tty);
> @@ -54,7 +64,7 @@ static int pps_tty_open(struct tty_struct *tty)
>  	struct pps_source_info info;
>  	struct tty_driver *drv = tty->driver;
>  	int index = tty->index + drv->name_base;
> -	int ret;
> +	struct pps_device *pps;
>  
>  	info.owner = THIS_MODULE;
>  	info.dev = NULL;
> @@ -64,20 +74,22 @@ static int pps_tty_open(struct tty_struct *tty)
>  			PPS_OFFSETASSERT | PPS_OFFSETCLEAR | \
>  			PPS_CANWAIT | PPS_TSFMT_TSPEC;
>  
> -	ret = pps_register_source(&info, PPS_CAPTUREBOTH | \
> +	pps = pps_register_source(&info, PPS_CAPTUREBOTH | \
>  				PPS_OFFSETASSERT | PPS_OFFSETCLEAR);
> -	if (ret < 0) {
> +	if (pps == NULL) {
>  		pr_err("cannot register PPS source \"%s\"\n", info.path);
> -		return ret;
> +		return -ENOMEM;
>  	}
> -	tty->disc_data = (void *)(long)ret;
> +
> +	spin_lock_irq(&pps_ldisc_lock);
> +	tty->disc_data = pps;
> +	spin_unlock_irq(&pps_ldisc_lock);

Maybe this lock is useless... however, are we sure that before setting
tty->disc_data to pps its value is null? Otherwise the dcd_change may
be called with an oops! We cannot control serial port IRQ
generation... :-/

>  	/* Should open N_TTY ldisc too */
> -	ret = alias_n_tty_open(tty);
> -	if (ret < 0)
> -		pps_unregister_source((long)tty->disc_data);
> +	if (alias_n_tty_open(tty) < 0)

Are you sure this code style is «canonical»? What does checkpatch say?
;)

> +		pps_unregister_source(pps);

If the above function fails I suppose you should invalidate
tty->disc_data, then unregister the pps source and, in the end, return
error (I know old code returns 0 anywhere, but I think it can be fixed
right now! ;).

> -	pr_info("PPS source #%d \"%s\" added\n", ret, info.path);
> +	dev_info(pps->dev, "source \"%s\" added\n", info.path);
>  
>  	return 0;
>  }
> @@ -86,12 +98,16 @@ static void (*alias_n_tty_close)(struct tty_struct *tty);
>  
>  static void pps_tty_close(struct tty_struct *tty)
>  {
> -	int id = (long)tty->disc_data;
> +	struct pps_device *pps = (struct pps_device *)tty->disc_data;
>  
> -	pps_unregister_source(id);
>  	alias_n_tty_close(tty);
>  
> -	pr_info("PPS source #%d removed\n", id);
> +	spin_lock_irq(&pps_ldisc_lock);
> +	tty->disc_data = NULL;
> +	spin_unlock_irq(&pps_ldisc_lock);
> +
> +	dev_info(pps->dev, "removed\n");
> +	pps_unregister_source(pps);
>  }
>  
>  static struct tty_ldisc_ops pps_ldisc_ops;

I suppose you can solve all your problems if you do the lock into
pps_tty_init...

Ciao,

Rodolfo

-- 

GNU/Linux Solutions                  e-mail: giometti@enneenne.com
Linux Device Driver                          giometti@linux.it
Embedded Systems                     phone:  +39 349 2432127
UNIX programming                     skype:  rodolfo.giometti
Freelance ICT Italia - Consulente ICT Italia - www.consulenti-ict.it
