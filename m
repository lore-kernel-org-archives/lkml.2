Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752799Ab0IQJbV (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Sep 2010 05:31:21 -0400
Received: from www.tglx.de ([62.245.132.106]:49804 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751657Ab0IQJbT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Sep 2010 05:31:19 -0400
Date: Fri, 17 Sep 2010 11:29:40 +0200 (CEST)
From: Thomas Gleixner <tglx@linutronix.de>
To: Alexander Shishkin <virtuoso@slind.org>
cc: linux-kernel@vger.kernel.org, John Stultz <johnstul@us.ibm.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        "H. Peter Anvin" <hpa@zytor.com>, Kay Sievers <kay.sievers@vrfy.org>,
        Greg KH <gregkh@suse.de>, Chris Friesen <chris.friesen@genband.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        "Kirill A. Shutemov" <kirill@shutemov.name>,
        Martin Schwidefsky <schwidefsky@de.ibm.com>,
        Jon Hunter <jon-hunter@ti.com>, Ingo Molnar <mingo@elte.hu>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        David Howells <dhowells@redhat.com>, Avi Kivity <avi@redhat.com>,
        John Kacur <jkacur@redhat.com>
Subject: Re: [PATCH 1/7] notify userspace about time changes
In-Reply-To: <1284675049-23479-2-git-send-email-virtuoso@slind.org>
Message-ID: <alpine.LFD.2.00.1009171014420.2416@localhost6.localdomain6>
References: <1284675049-23479-1-git-send-email-virtuoso@slind.org> <1284675049-23479-2-git-send-email-virtuoso@slind.org>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 17 Sep 2010, Alexander Shishkin wrote:

> Certain userspace applications (like "clock" desktop applets or cron) might
> want to be notified when some other application changes the system time. It
> might also be important for an application to be able to distinguish between
> its own and somebody else's time changes.

That's overengineered. An application which fiddles with the time
should be able to deal with that inside of the application.

> diff --git a/include/linux/syscalls.h b/include/linux/syscalls.h
> index e6319d1..789f92e 100644
> --- a/include/linux/syscalls.h
> +++ b/include/linux/syscalls.h
> @@ -819,6 +819,7 @@ asmlinkage long sys_fanotify_init(unsigned int flags, unsigned int event_f_flags
>  asmlinkage long sys_fanotify_mark(int fanotify_fd, unsigned int flags,
>  				  u64 mask, int fd,
>  				  const char  __user *pathname);
> +asmlinkage long sys_time_change_notify(int fd, unsigned int flags);

Please do not create a new syscall with a weird flag field. As I said
above the selection of who changed the time is not necessary at all,
so what you want is the selection of which change event and that
should be an enum.
 
>  int kernel_execve(const char *filename, const char *const argv[], const char *const envp[]);
>  
> diff --git a/include/linux/time.h b/include/linux/time.h
> index 9f15ac7..d66045e 100644
> --- a/include/linux/time.h
> +++ b/include/linux/time.h
> @@ -252,6 +252,26 @@ static __always_inline void timespec_add_ns(struct timespec *a, u64 ns)
>  	a->tv_sec += __iter_div_u64_rem(a->tv_nsec + ns, NSEC_PER_SEC, &ns);
>  	a->tv_nsec = ns;
>  }
> +
> +/* time change events */
> +#define TIME_EVENT_SET 0
> +#define TIME_EVENT_ADJ 1

Enum please

> +#define TIME_CHANGE_NOTIFY_OTHERS	BIT(0)
> +#define TIME_CHANGE_NOTIFY_OWN		BIT(1)
> +#define TIME_CHANGE_NOTIFY_SET		BIT(2)
> +#define TIME_CHANGE_NOTIFY_ADJUST	BIT(3)
> +
> +#define TIME_CHANGE_NOTIFY_MAX_USERS	1024

What's this random limit for ?

> diff --git a/init/Kconfig b/init/Kconfig
> index 2de5b1c..504a51a 100644
> --- a/init/Kconfig
> +++ b/init/Kconfig
> @@ -980,6 +980,13 @@ config PERF_USE_VMALLOC
>  	help
>  	  See tools/perf/design.txt for details
>  
> +config TIME_NOTIFY
> +	bool "System time changes notification for userspace"
> +	depends on EVENTFD
> +	help
> +	  Enable time change notification events to userspace via
> +	  eventfd.
> +

How is that config switch related to PERF ?   

>  menu "Kernel Performance Events And Counters"
>  
>  config PERF_EVENTS
> diff --git a/kernel/Makefile b/kernel/Makefile
> index 0b72d1a..ac53c67 100644
> --- a/kernel/Makefile
> +++ b/kernel/Makefile
> @@ -104,6 +104,7 @@ obj-$(CONFIG_PERF_EVENTS) += perf_event.o
>  obj-$(CONFIG_HAVE_HW_BREAKPOINT) += hw_breakpoint.o
>  obj-$(CONFIG_USER_RETURN_NOTIFIER) += user-return-notifier.o
>  obj-$(CONFIG_PADATA) += padata.o
> +obj-$(CONFIG_TIME_NOTIFY) += time_notify.o

Please move this to kernel/time/

> diff --git a/kernel/sysctl.c b/kernel/sysctl.c
> index f88552c..9e7d7a9 100644
> --- a/kernel/sysctl.c
> +++ b/kernel/sysctl.c
> @@ -1441,6 +1441,17 @@ static struct ctl_table fs_table[] = {
>  		.proc_handler	= proc_doulongvec_minmax,
>  	},
>  #endif /* CONFIG_AIO */
> +#ifdef CONFIG_TIME_NOTIFY
> +	{
> +		.procname	= "time-change-notify-max-users",
> +		.data		= &time_change_notify_max_users,
> +		.maxlen		= sizeof(unsigned int),
> +		.mode		= 0644,
> +		.proc_handler	= proc_dointvec_minmax,
> +		.extra1		= &zero,
> +		.extra2		= &ten_thousand,
> +	},

Do we really need another sysctl which nobody ever will use ?  

> +#endif
>  #ifdef CONFIG_INOTIFY_USER
>  	{
>  		.procname	= "inotify",
> diff --git a/kernel/time.c b/kernel/time.c
> index ba9b338..b4155b8 100644
> --- a/kernel/time.c
> +++ b/kernel/time.c
> @@ -92,7 +92,9 @@ SYSCALL_DEFINE1(stime, time_t __user *, tptr)
>  	if (err)
>  		return err;
>  
> -	do_settimeofday(&tv);
> +	err = do_settimeofday(&tv);
> +	if (!err)
> +		time_notify_all(TIME_EVENT_SET);

Crap. We really do _NOT_ want to sprinkle this into all syscalls which
can be used to set the time. You already missed the case in
do_sys_settimeofday() when only a tz change happens. Can't we simply
put that into do_settimeofday() and cover all cases ?

>  }
> @@ -215,6 +220,8 @@ SYSCALL_DEFINE1(adjtimex, struct timex __user *, txc_p)
>  	if(copy_from_user(&txc, txc_p, sizeof(struct timex)))
>  		return -EFAULT;
>  	ret = do_adjtimex(&txc);
> +	if (!ret)
> +		time_notify_all(TIME_EVENT_ADJ);

That's nonsense. adjtimex is not necessarily setting the time. adjtimex
can just read the current values w/o doing any modification. Also if
adjtimex merily adjusts the clock drift parameters then we do NOT set
the clock. So this is rather pointless AFAICT.

> +/*
> + * A process can "subscribe" to receive a notification via eventfd that
> + * some other process has called stime/settimeofday/adjtimex.
> + */
> +struct time_event {
> +	struct eventfd_ctx	*eventfd;
> +	struct task_struct	*watcher;
> +	unsigned int		want_others:1;
> +	unsigned int		want_own:1;
> +	unsigned int		want_set:1;
> +	unsigned int		want_adj:1;
> +	struct work_struct	remove;
> +	wait_queue_t		wq;
> +	wait_queue_head_t	*wqh;
> +	poll_table		pt;
> +	struct list_head	list;
> +};
> +
> +static LIST_HEAD(event_list);
> +static int nevents;
> +static DEFINE_SPINLOCK(event_lock);
> +
> +/*
> + * Do the necessary cleanup when the eventfd is being closed
> + */
> +static void time_event_remove(struct work_struct *work)
> +{
> +	struct time_event *evt = container_of(work, struct time_event, remove);
> +
> +	BUG_ON(nevents <= 0);

  Errm. The accounting belongs to the place where we remove the event
  from the event list. This counter can go away anyway.

  You leak the refcount on the eventfd_ctx here.

> +
> +	kfree(evt);
> +	nevents--;
> +}
> +
> +static int time_event_wakeup(wait_queue_t *wq, unsigned int mode, int sync,
> +			     void *key)
> +{
> +	struct time_event *evt = container_of(wq, struct time_event, wq);
> +	unsigned long flags = (unsigned long)key;
> +
> +	if (flags & POLLHUP) {
> +		__remove_wait_queue(evt->wqh, &evt->wq);

  Please don't do that. Merily delete it from the list and schedule it
  for removal. Then in the remove function use
  eventfd_ctx_remove_wait_queue() to cleanup the eventfd.

> +		spin_lock(&event_lock);
> +		list_del(&evt->list);
> +		spin_unlock(&event_lock);
> +
> +		schedule_work(&evt->remove);
> +	}
> +
> +	return 0;
> +}
> +
> +static void time_event_ptable_queue_proc(struct file *file,
> +					 wait_queue_head_t *wqh, poll_table *pt)
> +{
> +	struct time_event *evt = container_of(pt, struct time_event, pt);
> +
> +	evt->wqh = wqh;
> +	add_wait_queue(wqh, &evt->wq);
> +}
> +
> +/*
> + * time_change_notify() registers a given eventfd to receive time change
> + * notifications
> + */
> +SYSCALL_DEFINE2(time_change_notify, int, fd, unsigned int, flags)
> +{
> +	int ret;
> +	struct file *file;
> +	struct time_event *evt;

  Reverting the order of these makes is 5 times easier to read.

> +
> +	evt = kmalloc(sizeof(*evt), GFP_KERNEL);
> +	if (!evt)
> +		return -ENOMEM;
> +
> +	evt->want_others = !!(flags & TIME_CHANGE_NOTIFY_OTHERS);
> +	evt->want_own = !!(flags & TIME_CHANGE_NOTIFY_OWN);
> +	evt->want_set = !!(flags & TIME_CHANGE_NOTIFY_SET);
> +	evt->want_adj = !!(flags & TIME_CHANGE_NOTIFY_ADJUST);

  Shudder. Please get rid of this.

> +	file = eventfd_fget(fd);
> +	if (IS_ERR(file)) {
> +		ret = -EINVAL;

  Grr. PTR_ERR(file) perhaps ?

> +		goto out_free;
> +	}
> +
> +	evt->eventfd = eventfd_ctx_fileget(file);
> +	if (IS_ERR(evt->eventfd)) {
> +		ret = PTR_ERR(evt->eventfd);
> +		goto out_fput;
> +	}
> +
> +	INIT_LIST_HEAD(&evt->list);
> +	INIT_WORK(&evt->remove, time_event_remove);
> +
> +	init_waitqueue_func_entry(&evt->wq, time_event_wakeup);
> +	init_poll_funcptr(&evt->pt, time_event_ptable_queue_proc);
> +
> +	evt->watcher = current;

  No need for this

> +	spin_lock(&event_lock);
> +	if (nevents == time_change_notify_max_users) {
> +		spin_unlock(&event_lock);
> +		ret = -EBUSY;


  Gah. You leak the refcount to eventfd.

> +		goto out_fput;
> +	}
> +
> +	nevents++;
> +	list_add(&evt->list, &event_list);
> +	spin_unlock(&event_lock);
> +
> +	if (file->f_op->poll(file, &evt->pt) & POLLHUP) {
> +		ret = 0;

  Ditto.

> +		goto out_fput;
> +	}
> +
> +	fput(file);
> +
> +	return 0;
> +
> +out_fput:
> +	fput(file);
> +
> +out_free:
> +	kfree(evt);
> +
> +	return ret;
> +}
> +
> +void time_notify_all(int type)
> +{
> +	struct list_head *tmp;
> +
> +	spin_lock(&event_lock);
> +	list_for_each(tmp, &event_list) {
> +		struct time_event *e = container_of(tmp, struct time_event,
> +						    list);
> +
> +		if (type == TIME_EVENT_SET && !e->want_set)
> +			continue;
> +		else if (type == TIME_EVENT_ADJ && !e->want_adj)
> +			continue;
> +
> +		if (e->watcher == current && !e->want_own)
> +			continue;
> +		else if (e->watcher != current && !e->want_others)
> +			continue;

  This needs a major cleanup.

> +		eventfd_signal(e->eventfd, 1);
> +	}
> +	spin_unlock(&event_lock);
> +}
> +
> +static int time_notify_init(void)
> +{
> +	return 0;
> +}
> +
> +core_initcall(time_notify_init);

What's the exact purpose of this initcall ?

Thanks,

	tglx
