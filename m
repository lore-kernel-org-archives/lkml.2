Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752092Ab1CJIP7 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Mar 2011 03:15:59 -0500
Received: from filtteri1.pp.htv.fi ([213.243.153.184]:33151 "EHLO
	filtteri1.pp.htv.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751922Ab1CJIP6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Mar 2011 03:15:58 -0500
Date: Thu, 10 Mar 2011 10:15:55 +0200
From: Alexander Shishkin <virtuoso@slind.org>
To: "Kirill A. Shutemov" <kirill@shutemov.name>
Cc: linux-kernel@vger.kernel.org, Ken MacLeod <ken@bitsko.slc.ut.us>,
        Shaun Reich <predator106@gmail.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Alexander Viro <viro@zeniv.linux.org.uk>,
        Greg Kroah-Hartman <gregkh@suse.de>, Feng Tang <feng.tang@intel.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Michael Tokarev <mjt@tls.msk.ru>,
        Marcelo Tosatti <mtosatti@redhat.com>,
        John Stultz <johnstul@us.ibm.com>,
        Chris Friesen <chris.friesen@genband.com>,
        Kay Sievers <kay.sievers@vrfy.org>,
        Artem Bityutskiy <dedekind1@gmail.com>,
        Davide Libenzi <davidel@xmailserver.org>,
        linux-fsdevel@vger.kernel.org, Alexander Shishkin <virtuoso@slind.org>
Subject: Re: [RFCv4] timerfd: add TFD_NOTIFY_CLOCK_SET to watch for clock
 changes
Message-ID: <20110310081555.GB11410@shisha.kicks-ass.net>
References: <1299681411-9227-1-git-send-email-virtuoso@slind.org>
 <20110310080251.GA1830@shutemov.name>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110310080251.GA1830@shutemov.name>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Mar 10, 2011 at 10:02:51AM +0200, Kirill A. Shutemov wrote:
> On Wed, Mar 09, 2011 at 04:36:51PM +0200, Alexander Shishkin wrote:
> > Changes since v3:
> >  - changed timerfd_settime() semantics (see below)
> > Changes since v2:
> >  - replaced sysfs interface with a syscall
> >  - added sysctl/procfs handle to set a limit to the number of users
> >  - fixed issues pointed out by Greg.
> > Changes since v1:
> >  - updated against 2.6.36-rc1,
> >  - added notification/filtering options,
> >  - added Documentation/ABI/sysfs-kernel-time-notify interface description.
> > 
> > Certain userspace applications (like "clock" desktop applets or cron or
> > systemd) might want to be notified when some other application changes
> > the system time. There are several known to me reasons for this:
> >  - avoiding periodic wakeups to poll time changes;
> >  - rearming CLOCK_REALTIME timers when said changes happen;
> >  - changing system timekeeping policy for system-wide time management
> >    programs;
> >  - keeping guest applications/operating systems running in emulators
> >    up to date;
> >  - recalculation of traffic signal cycles in Advanced Traffic Controllers
> >    (ATC), which is part of ATC API requirements [1] as developed by ATC
> >    working group of the U.S. Institute of Transportation Engineers (ITE).
> > 
> > The major change since the previous version is the new semantics of
> > timerfd_settime() when it's called on a time change notification
> > descriptor: it will set the system time to utmr.it_value if the time
> > change counter is zero, otherwise it will return EBUSY, this is required
> > to prevent a race between setting the time and reading the counter, when
> > the time controlling procees changes the time immediately after another
> > process in the system did the same (the counter is greater than one),
> > that process' time change will be lost. Thus, the time controlling
> > process should use timerfd_settime() instead of clock_settime() or
> > settimeofday() to ensure that other processes' time changes don't get
> > lost.
> > 
> > This is another attempt to approach notifying userspace about system
> > clock changes. The other one is using an eventfd and a syscall [1]. In
> > the course of discussing the necessity of a syscall for this kind of
> > notifications, it was suggested that this functionality can be achieved
> > via timers [2] (and timerfd in particular [3]). This idea got quite
> > some support [4], [5], [6] and some vague criticism [7], so I decided
> > to try and go a bit further with it.
> > 
> > [1] http://www.ite.org/standards/atcapi/version2.asp
> > [2] http://marc.info/?l=linux-kernel&m=128950389423614&w=2
> > [3] http://marc.info/?l=linux-kernel&m=128951020831573&w=2
> > [4] http://marc.info/?l=linux-kernel&m=128951588006157&w=2
> > [5] http://marc.info/?l=linux-kernel&m=128951503205111&w=2
> > [6] http://marc.info/?l=linux-kernel&m=128955890118477&w=2
> > [7] http://marc.info/?l=linux-kernel&m=129002967031104&w=2
> > [8] http://marc.info/?l=linux-kernel&m=129002672227263&w=2
> > 
> > Signed-off-by: Alexander Shishkin <virtuoso@slind.org>
> > CC: Thomas Gleixner <tglx@linutronix.de>
> > CC: Alexander Viro <viro@zeniv.linux.org.uk>
> > CC: Greg Kroah-Hartman <gregkh@suse.de>
> > CC: Feng Tang <feng.tang@intel.com>
> > CC: Andrew Morton <akpm@linux-foundation.org>
> > CC: Michael Tokarev <mjt@tls.msk.ru>
> > CC: Marcelo Tosatti <mtosatti@redhat.com>
> > CC: John Stultz <johnstul@us.ibm.com>
> > CC: Chris Friesen <chris.friesen@genband.com>
> > CC: Kay Sievers <kay.sievers@vrfy.org>
> > CC: Kirill A. Shutemov <kirill@shutemov.name>
> > CC: Artem Bityutskiy <dedekind1@gmail.com>
> > CC: Davide Libenzi <davidel@xmailserver.org>
> > CC: linux-fsdevel@vger.kernel.org
> > CC: linux-kernel@vger.kernel.org
> > ---
> >  fs/timerfd.c            |   94 ++++++++++++++++++++++++++++++++++++++++++-----
> >  include/linux/hrtimer.h |    6 +++
> >  include/linux/timerfd.h |    3 +-
> >  kernel/compat.c         |    5 ++-
> >  kernel/hrtimer.c        |    4 ++
> >  kernel/time.c           |   11 ++++-
> >  6 files changed, 109 insertions(+), 14 deletions(-)
> > 
> > diff --git a/fs/timerfd.c b/fs/timerfd.c
> > index 8c4fc14..6170f61 100644
> > --- a/fs/timerfd.c
> > +++ b/fs/timerfd.c
> > @@ -22,6 +22,7 @@
> >  #include <linux/anon_inodes.h>
> >  #include <linux/timerfd.h>
> >  #include <linux/syscalls.h>
> > +#include <linux/security.h>
> >  
> >  struct timerfd_ctx {
> >  	struct hrtimer tmr;
> > @@ -30,8 +31,13 @@ struct timerfd_ctx {
> >  	u64 ticks;
> >  	int expired;
> >  	int clockid;
> > +	struct list_head notifiers_list;
> >  };
> >  
> > +/* TFD_NOTIFY_CLOCK_SET timers go here */
> > +static DEFINE_SPINLOCK(notifiers_lock);
> > +static LIST_HEAD(notifiers_list);
> > +
> >  /*
> >   * This gets called when the timer event triggers. We set the "expired"
> >   * flag, but we do not re-arm the timer (in case it's necessary,
> > @@ -51,10 +57,31 @@ static enum hrtimer_restart timerfd_tmrproc(struct hrtimer *htmr)
> >  	return HRTIMER_NORESTART;
> >  }
> >  
> > +void timerfd_clock_was_set(clockid_t clockid)
> > +{
> > +	struct timerfd_ctx *ctx;
> > +	unsigned long flags;
> > +
> > +	spin_lock(&notifiers_lock);
> > +	list_for_each_entry(ctx, &notifiers_list, notifiers_list) {
> > +		spin_lock_irqsave(&ctx->wqh.lock, flags);
> > +		if (ctx->tmr.base->index == clockid) {
> > +			ctx->ticks++;
> > +			wake_up_locked(&ctx->wqh);
> > +		}
> > +		spin_unlock_irqrestore(&ctx->wqh.lock, flags);
> > +	}
> > +	spin_unlock(&notifiers_lock);
> > +}
> > +
> >  static ktime_t timerfd_get_remaining(struct timerfd_ctx *ctx)
> >  {
> >  	ktime_t remaining;
> >  
> > +	/* for notification timers, return current time */
> > +	if (!list_empty(&ctx->notifiers_list))
> > +		return timespec_to_ktime(current_kernel_time());
> > +
> >  	remaining = hrtimer_expires_remaining(&ctx->tmr);
> >  	return remaining.tv64 < 0 ? ktime_set(0, 0): remaining;
> >  }
> > @@ -72,6 +99,12 @@ static void timerfd_setup(struct timerfd_ctx *ctx, int flags,
> >  	ctx->expired = 0;
> >  	ctx->ticks = 0;
> >  	ctx->tintv = timespec_to_ktime(ktmr->it_interval);
> > +
> > +	if (flags & TFD_NOTIFY_CLOCK_SET) {
> > +		list_add(&ctx->notifiers_list, &notifiers_list);
> > +		return;
> > +	}
> > +
> >  	hrtimer_init(&ctx->tmr, ctx->clockid, htmode);
> >  	hrtimer_set_expires(&ctx->tmr, texp);
> >  	ctx->tmr.function = timerfd_tmrproc;
> > @@ -83,7 +116,12 @@ static int timerfd_release(struct inode *inode, struct file *file)
> >  {
> >  	struct timerfd_ctx *ctx = file->private_data;
> >  
> > -	hrtimer_cancel(&ctx->tmr);
> > +	if (!list_empty(&ctx->notifiers_list)) {
> > +		spin_lock(&notifiers_lock);
> > +		list_del(&ctx->notifiers_list);
> > +		spin_unlock(&notifiers_lock);
> > +	} else
> > +		hrtimer_cancel(&ctx->tmr);
> >  	kfree(ctx);
> >  	return 0;
> >  }
> > @@ -113,6 +151,7 @@ static ssize_t timerfd_read(struct file *file, char __user *buf, size_t count,
> >  
> >  	if (count < sizeof(ticks))
> >  		return -EINVAL;
> > +
> >  	spin_lock_irq(&ctx->wqh.lock);
> >  	if (file->f_flags & O_NONBLOCK)
> >  		res = -EAGAIN;
> 
> Whitespace changes?
> 
> > @@ -120,7 +159,8 @@ static ssize_t timerfd_read(struct file *file, char __user *buf, size_t count,
> >  		res = wait_event_interruptible_locked_irq(ctx->wqh, ctx->ticks);
> >  	if (ctx->ticks) {
> >  		ticks = ctx->ticks;
> > -		if (ctx->expired && ctx->tintv.tv64) {
> > +		if (ctx->expired && ctx->tintv.tv64 &&
> > +		    list_empty(&ctx->notifiers_list)) {
> >  			/*
> >  			 * If tintv.tv64 != 0, this is a periodic timer that
> >  			 * needs to be re-armed. We avoid doing it in the timer
> > @@ -184,6 +224,8 @@ SYSCALL_DEFINE2(timerfd_create, int, clockid, int, flags)
> >  	ctx->clockid = clockid;
> >  	hrtimer_init(&ctx->tmr, clockid, HRTIMER_MODE_ABS);
> >  
> > +	INIT_LIST_HEAD(&ctx->notifiers_list);
> > +
> >  	ufd = anon_inode_getfd("[timerfd]", &timerfd_fops, ctx,
> >  			       O_RDWR | (flags & TFD_SHARED_FCNTL_FLAGS));
> >  	if (ufd < 0)
> > @@ -196,18 +238,24 @@ SYSCALL_DEFINE4(timerfd_settime, int, ufd, int, flags,
> >  		const struct itimerspec __user *, utmr,
> >  		struct itimerspec __user *, otmr)
> >  {
> > +	int ret = 0;
> >  	struct file *file;
> >  	struct timerfd_ctx *ctx;
> >  	struct itimerspec ktmr, kotmr;
> >  
> > -	if (copy_from_user(&ktmr, utmr, sizeof(ktmr)))
> > -		return -EFAULT;
> > -
> > -	if ((flags & ~TFD_SETTIME_FLAGS) ||
> > -	    !timespec_valid(&ktmr.it_value) ||
> > -	    !timespec_valid(&ktmr.it_interval))
> > +	if (flags & ~TFD_SETTIME_FLAGS)
> >  		return -EINVAL;
> >  
> > +	/* utmr may be NULL for notification timerfd */
> > +	if (!(flags & TFD_NOTIFY_CLOCK_SET) || utmr) {
> > +		if (copy_from_user(&ktmr, utmr, sizeof(ktmr)))
> > +			return -EFAULT;
> > +
> > +		if (!timespec_valid(&ktmr.it_value) ||
> > +		    !timespec_valid(&ktmr.it_interval))
> > +			return -EINVAL;
> > +	}
> > +
> >  	file = timerfd_fget(ufd);
> >  	if (IS_ERR(file))
> >  		return PTR_ERR(file);
> > @@ -218,10 +266,12 @@ SYSCALL_DEFINE4(timerfd_settime, int, ufd, int, flags,
> >  	 * it to the new values.
> >  	 */
> >  	for (;;) {
> > +		spin_lock(&notifiers_lock);
> >  		spin_lock_irq(&ctx->wqh.lock);
> > -		if (hrtimer_try_to_cancel(&ctx->tmr) >= 0)
> > +		if (!list_empty(&notifiers_list) || hrtimer_try_to_cancel(&ctx->tmr) >= 0)
> >  			break;
> >  		spin_unlock_irq(&ctx->wqh.lock);
> > +		spin_unlock(&notifiers_lock);
> >  		cpu_relax();
> >  	}
> >  
> > @@ -238,16 +288,39 @@ SYSCALL_DEFINE4(timerfd_settime, int, ufd, int, flags,
> >  	kotmr.it_interval = ktime_to_timespec(ctx->tintv);
> >  
> >  	/*
> > +	 * for the notification timerfd, set current time to it_value
> > +	 * if the timer hasn't expired; otherwise someone has changed
> > +	 * the system time to the value that we don't know
> > +	 */
> > +	if (!list_empty(&ctx->notifiers_list) && utmr) {
> > +		if (ctx->ticks) {
> > +			ret = -EBUSY;
> > +			goto out;
> > +		}
> > +
> > +		ret = security_settime(&ktmr.it_value, NULL);
> > +		if (ret)
> > +			goto out;
> > +
> > +		spin_unlock_irq(&ctx->wqh.lock);
> > +		ret = do_settimeofday(&ktmr.it_value);
> > +		goto out1;
> > +	}
> > +
> > +	/*
> >  	 * Re-program the timer to the new value ...
> >  	 */
> >  	timerfd_setup(ctx, flags, &ktmr);
> >  
> > +out:
> >  	spin_unlock_irq(&ctx->wqh.lock);
> > +out1:
> > +	spin_unlock(&notifiers_lock);
> >  	fput(file);
> >  	if (otmr && copy_to_user(otmr, &kotmr, sizeof(kotmr)))
> >  		return -EFAULT;
> 
> What's reason to do copy_to_user() in case of error?

That's a separate issue. security_settime() checks for the capability for
_setting_ the time. This bit is returning the previously effective time
back to user if he/she asked for it.

> Is it safe for error from security_settime()?

The user can still obtain system time by other means.

> 
> > -	return 0;
> > +	return ret;
> >  }
> >  
> >  SYSCALL_DEFINE2(timerfd_gettime, int, ufd, struct itimerspec __user *, otmr)
> > @@ -273,6 +346,7 @@ SYSCALL_DEFINE2(timerfd_gettime, int, ufd, struct itimerspec __user *, otmr)
> >  	spin_unlock_irq(&ctx->wqh.lock);
> >  	fput(file);
> >  
> > +out:
> >  	return copy_to_user(otmr, &kotmr, sizeof(kotmr)) ? -EFAULT: 0;
> >  }
> 
> This lable is not needed.
> 
> > diff --git a/include/linux/hrtimer.h b/include/linux/hrtimer.h
> > index 6bc1804..991e8d9 100644
> > --- a/include/linux/hrtimer.h
> > +++ b/include/linux/hrtimer.h
> > @@ -248,6 +248,12 @@ static inline ktime_t hrtimer_expires_remaining(const struct hrtimer *timer)
> >  	return ktime_sub(timer->node.expires, timer->base->get_time());
> >  }
> >  
> > +#ifdef CONFIG_TIMERFD
> > +extern void timerfd_clock_was_set(clockid_t clockid);
> > +#else
> > +static inline void timerfd_clock_was_set(clockid_t clockid) {}
> > +#endif
> > +
> >  #ifdef CONFIG_HIGH_RES_TIMERS
> >  struct clock_event_device;
> >  
> > diff --git a/include/linux/timerfd.h b/include/linux/timerfd.h
> > index 2d07929..c3ddad9 100644
> > --- a/include/linux/timerfd.h
> > +++ b/include/linux/timerfd.h
> > @@ -19,6 +19,7 @@
> >   * shared O_* flags.
> >   */
> >  #define TFD_TIMER_ABSTIME (1 << 0)
> > +#define TFD_NOTIFY_CLOCK_SET (1 << 1)
> >  #define TFD_CLOEXEC O_CLOEXEC
> >  #define TFD_NONBLOCK O_NONBLOCK
> >  
> > @@ -26,6 +27,6 @@
> >  /* Flags for timerfd_create.  */
> >  #define TFD_CREATE_FLAGS TFD_SHARED_FCNTL_FLAGS
> >  /* Flags for timerfd_settime.  */
> > -#define TFD_SETTIME_FLAGS TFD_TIMER_ABSTIME
> > +#define TFD_SETTIME_FLAGS (TFD_TIMER_ABSTIME | TFD_NOTIFY_CLOCK_SET)
> >  
> >  #endif /* _LINUX_TIMERFD_H */
> > diff --git a/kernel/compat.c b/kernel/compat.c
> > index 38b1d2c..b1cf3e1 100644
> > --- a/kernel/compat.c
> > +++ b/kernel/compat.c
> > @@ -995,7 +995,10 @@ asmlinkage long compat_sys_stime(compat_time_t __user *tptr)
> >  	if (err)
> >  		return err;
> >  
> > -	do_settimeofday(&tv);
> > +	err = do_settimeofday(&tv);
> > +	if (!err)
> > +		timerfd_clock_was_set(CLOCK_REALTIME);
> > +
> >  	return 0;
> >  }
> >  
> > diff --git a/kernel/hrtimer.c b/kernel/hrtimer.c
> > index 2c3d6e5..469eef6 100644
> > --- a/kernel/hrtimer.c
> > +++ b/kernel/hrtimer.c
> > @@ -663,6 +663,7 @@ void clock_was_set(void)
> >  {
> >  	/* Retrigger the CPU local events everywhere */
> >  	on_each_cpu(retrigger_next_event, NULL, 1);
> > +
> >  }
> >  
> >  /*
> 
> Whitespace changes?
> 
> > @@ -675,6 +676,9 @@ void hres_timers_resume(void)
> >  		  KERN_INFO "hres_timers_resume() called with IRQs enabled!");
> >  
> >  	retrigger_next_event(NULL);
> > +
> > +	/* Trigger timerfd notifiers */
> > +	timerfd_clock_was_set(CLOCK_MONOTONIC);
> >  }
> >  
> >  /*
> > diff --git a/kernel/time.c b/kernel/time.c
> > index 6430a75..b06f759 100644
> > --- a/kernel/time.c
> > +++ b/kernel/time.c
> > @@ -92,7 +92,10 @@ SYSCALL_DEFINE1(stime, time_t __user *, tptr)
> >  	if (err)
> >  		return err;
> >  
> > -	do_settimeofday(&tv);
> > +	err = do_settimeofday(&tv);
> > +	if (!err)
> > +		timerfd_clock_was_set(CLOCK_REALTIME);
> > +
> >  	return 0;
> >  }
> >  
> > @@ -177,7 +180,11 @@ int do_sys_settimeofday(const struct timespec *tv, const struct timezone *tz)
> >  		/* SMP safe, again the code in arch/foo/time.c should
> >  		 * globally block out interrupts when it runs.
> >  		 */
> > -		return do_settimeofday(tv);
> > +		error = do_settimeofday(tv);
> > +		if (!error)
> > +			timerfd_clock_was_set(CLOCK_REALTIME);
> > +
> > +		return error;
> >  	}
> >  	return 0;
> >  }
> > -- 
> > 1.7.2.1.45.gb66c2
> > 
> 
> -- 
>  Kirill A. Shutemov
