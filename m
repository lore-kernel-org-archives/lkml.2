Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935414Ab0KQUpJ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Nov 2010 15:45:09 -0500
Received: from x35.xmailserver.org ([64.71.152.41]:47998 "EHLO
	x35.xmailserver.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757797Ab0KQUpH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Nov 2010 15:45:07 -0500
X-AuthUser: davidel@xmailserver.org
Date: Wed, 17 Nov 2010 12:42:52 -0800 (PST)
From: Davide Libenzi <davidel@xmailserver.org>
X-X-Sender: davide@davide-lnx1
To: Alexander Shishkin <virtuoso@slind.org>
cc: Thomas Gleixner <tglx@linutronix.de>, Kyle Moffett <kyle@moffetthome.net>,
        Valdis.Kletnieks@vt.edu, LKML <linux-kernel@vger.kernel.org>,
        John Stultz <johnstul@us.ibm.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        "H. Peter Anvin" <hpa@zytor.com>, Kay Sievers <kay.sievers@vrfy.org>,
        Greg KH <gregkh@suse.de>, Chris Friesen <chris.friesen@genband.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        "Kirill A. Shutemov" <kirill@shutemov.name>
Subject: Re: [PATCHv6 0/7] system time changes notification
In-Reply-To: <20101117190659.GB26184@shisha.kicks-ass.net>
Message-ID: <alpine.DEB.2.00.1011171130210.1595@davide-lnx1>
References: <1289503802-22444-1-git-send-email-virtuoso@slind.org> <22542.1289507293@localhost> <20101111205123.GC10585@shisha.kicks-ass.net> <alpine.LFD.2.00.1011112212460.2900@localhost6.localdomain6> <AANLkTik8FS5p_P_2ygh9qC2qg7wTDP+23LKbhJCKcMez@mail.gmail.com>
 <alpine.LFD.2.00.1011112322280.2900@localhost6.localdomain6> <20101117190659.GB26184@shisha.kicks-ass.net>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
X-GPG-FINGRPRINT: CFAE 5BEE FD36 F65E E640  56FE 0974 BF23 270F 474E
X-GPG-PUBLIC_KEY: http://www.xmailserver.org/davidel.asc
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 17 Nov 2010, Alexander Shishkin wrote:

> > But what you folks really want for this stuff is an extension to
> > timerfd as you want to be able to poll, right?
> > 
> > So what about the following:
> > 
> > Add a new flag TDF_NOTIFY_CLOCK_WAS_SET to the timerfd flags. Now this
> > flag adds the timer to a separate list, which gets woken up when the
> > clock is set.
> > 
> > No new syscall, just a few lines of code in fs/timerfd.c and
> > clock_was_set().
> > 
> > Thoughts ?
> 
> Something like this (sans ugliness)?

Oh, gosh, please.  This is interface-multiplexing-a-palooza.
It should be decided if the feature makes sense, and then have proper 
interface, instead of multiplexing unrelated insterfaces.
This is a sort of system-event-report pattern.  What is wrong with using a 
netlink-based transport for those kind of things?





> Signed-off-by: Alexander Shishkin <virtuoso@slind.org>
> ---
>  fs/timerfd.c            |   52 +++++++++++++++++++++++++++++++++++++++++++++-
>  include/linux/timerfd.h |    3 +-
>  kernel/hrtimer.c        |    2 +
>  3 files changed, 54 insertions(+), 3 deletions(-)
> 
> diff --git a/fs/timerfd.c b/fs/timerfd.c
> index 8c4fc14..51a033e 100644
> --- a/fs/timerfd.c
> +++ b/fs/timerfd.c
> @@ -30,8 +30,14 @@ struct timerfd_ctx {
>  	u64 ticks;
>  	int expired;
>  	int clockid;
> +	int clock_notifier; /* list_empty()? */
> +	struct list_head notifiers_list;
>  };
>  
> +/* TFD_NOTIFY_CLOCK_SET timers go here */
> +static DEFINE_SPINLOCK(notifiers_lock);
> +static LIST_HEAD(notifiers_list);
> +
>  /*
>   * This gets called when the timer event triggers. We set the "expired"
>   * flag, but we do not re-arm the timer (in case it's necessary,
> @@ -51,6 +57,21 @@ static enum hrtimer_restart timerfd_tmrproc(struct hrtimer *htmr)
>  	return HRTIMER_NORESTART;
>  }
>  
> +void timerfd_clock_was_set(void)
> +{
> +	struct timerfd_ctx *ctx;
> +	unsigned long flags;
> +
> +	spin_lock(&notifiers_lock);
> +	list_for_each_entry(ctx, &notifiers_list, notifiers_list) {
> +		spin_lock_irqsave(&ctx->wqh.lock, flags);
> +		ctx->ticks++;
> +		wake_up_locked(&ctx->wqh);
> +		spin_unlock_irqrestore(&ctx->wqh.lock, flags);
> +	}
> +	spin_unlock(&notifiers_lock);
> +}
> +
>  static ktime_t timerfd_get_remaining(struct timerfd_ctx *ctx)
>  {
>  	ktime_t remaining;
> @@ -65,6 +86,14 @@ static void timerfd_setup(struct timerfd_ctx *ctx, int flags,
>  	enum hrtimer_mode htmode;
>  	ktime_t texp;
>  
> +	if (flags & TFD_NOTIFY_CLOCK_SET) {
> +		ctx->clock_notifier = 1;
> +		ctx->ticks = 0;
> +		INIT_LIST_HEAD(&ctx->notifiers_list);
> +		list_add(&ctx->notifiers_list, &notifiers_list);
> +		return;
> +	}
> +
>  	htmode = (flags & TFD_TIMER_ABSTIME) ?
>  		HRTIMER_MODE_ABS: HRTIMER_MODE_REL;
>  
> @@ -83,7 +112,12 @@ static int timerfd_release(struct inode *inode, struct file *file)
>  {
>  	struct timerfd_ctx *ctx = file->private_data;
>  
> -	hrtimer_cancel(&ctx->tmr);
> +	if (ctx->clock_notifier) {
> +		spin_lock(&notifiers_lock);
> +		list_del(&ctx->notifiers_list);
> +		spin_unlock(&notifiers_lock);
> +	} else
> +		hrtimer_cancel(&ctx->tmr);
>  	kfree(ctx);
>  	return 0;
>  }
> @@ -113,6 +147,7 @@ static ssize_t timerfd_read(struct file *file, char __user *buf, size_t count,
>  
>  	if (count < sizeof(ticks))
>  		return -EINVAL;
> +
>  	spin_lock_irq(&ctx->wqh.lock);
>  	if (file->f_flags & O_NONBLOCK)
>  		res = -EAGAIN;
> @@ -120,7 +155,7 @@ static ssize_t timerfd_read(struct file *file, char __user *buf, size_t count,
>  		res = wait_event_interruptible_locked_irq(ctx->wqh, ctx->ticks);
>  	if (ctx->ticks) {
>  		ticks = ctx->ticks;
> -		if (ctx->expired && ctx->tintv.tv64) {
> +		if (ctx->expired && ctx->tintv.tv64 && !ctx->clock_notifier) {
>  			/*
>  			 * If tintv.tv64 != 0, this is a periodic timer that
>  			 * needs to be re-armed. We avoid doing it in the timer
> @@ -218,13 +253,20 @@ SYSCALL_DEFINE4(timerfd_settime, int, ufd, int, flags,
>  	 * it to the new values.
>  	 */
>  	for (;;) {
> +		spin_lock(&notifiers_lock);
>  		spin_lock_irq(&ctx->wqh.lock);
>  		if (hrtimer_try_to_cancel(&ctx->tmr) >= 0)
>  			break;
>  		spin_unlock_irq(&ctx->wqh.lock);
> +		spin_unlock(&notifiers_lock);
>  		cpu_relax();
>  	}
>  
> +	if (ctx->clock_notifier) {
> +		ctx->clock_notifier = 0;
> +		list_del(&ctx->notifiers_list);
> +	}
> +
>  	/*
>  	 * If the timer is expired and it's periodic, we need to advance it
>  	 * because the caller may want to know the previous expiration time.
> @@ -243,6 +285,7 @@ SYSCALL_DEFINE4(timerfd_settime, int, ufd, int, flags,
>  	timerfd_setup(ctx, flags, &ktmr);
>  
>  	spin_unlock_irq(&ctx->wqh.lock);
> +	spin_unlock(&notifiers_lock);
>  	fput(file);
>  	if (otmr && copy_to_user(otmr, &kotmr, sizeof(kotmr)))
>  		return -EFAULT;
> @@ -262,6 +305,11 @@ SYSCALL_DEFINE2(timerfd_gettime, int, ufd, struct itimerspec __user *, otmr)
>  	ctx = file->private_data;
>  
>  	spin_lock_irq(&ctx->wqh.lock);
> +	if (ctx->clock_notifier) {
> +		spin_unlock_irq(&ctx->wqh.lock);
> +		return -EINVAL;
> +	}
> +
>  	if (ctx->expired && ctx->tintv.tv64) {
>  		ctx->expired = 0;
>  		ctx->ticks +=
> diff --git a/include/linux/timerfd.h b/include/linux/timerfd.h
> index 2d07929..c3ddad9 100644
> --- a/include/linux/timerfd.h
> +++ b/include/linux/timerfd.h
> @@ -19,6 +19,7 @@
>   * shared O_* flags.
>   */
>  #define TFD_TIMER_ABSTIME (1 << 0)
> +#define TFD_NOTIFY_CLOCK_SET (1 << 1)
>  #define TFD_CLOEXEC O_CLOEXEC
>  #define TFD_NONBLOCK O_NONBLOCK
>  
> @@ -26,6 +27,6 @@
>  /* Flags for timerfd_create.  */
>  #define TFD_CREATE_FLAGS TFD_SHARED_FCNTL_FLAGS
>  /* Flags for timerfd_settime.  */
> -#define TFD_SETTIME_FLAGS TFD_TIMER_ABSTIME
> +#define TFD_SETTIME_FLAGS (TFD_TIMER_ABSTIME | TFD_NOTIFY_CLOCK_SET)
>  
>  #endif /* _LINUX_TIMERFD_H */
> diff --git a/kernel/hrtimer.c b/kernel/hrtimer.c
> index 72206cf..a779e0f 100644
> --- a/kernel/hrtimer.c
> +++ b/kernel/hrtimer.c
> @@ -642,8 +642,10 @@ static void retrigger_next_event(void *arg)
>   * resolution timer interrupts. On UP we just disable interrupts and
>   * call the high resolution interrupt code.
>   */
> +void timerfd_clock_was_set(clockid_t clockid);
>  void clock_was_set(void)
>  {
> +	timerfd_clock_was_set(CLOCK_REALTIME);
>  	/* Retrigger the CPU local events everywhere */
>  	on_each_cpu(retrigger_next_event, NULL, 1);
>  }
> -- 
> 1.7.2.1.45.gb66c2
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
> 


- Davide


