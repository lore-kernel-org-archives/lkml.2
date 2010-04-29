Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932828Ab0D3RWQ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Apr 2010 13:22:16 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:59886 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933104Ab0D3RVc convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Apr 2010 13:21:32 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Arve =?iso-8859-1?q?Hj=F8nnev=E5g?= <arve@android.com>
Subject: Re: [PATCH 1/8] PM: Add suspend block api.
Date: Thu, 29 Apr 2010 23:16:14 +0200
User-Agent: KMail/1.12.4 (Linux/2.6.34-rc4-rjw; KDE/4.3.5; x86_64; ; )
Cc: linux-pm@lists.linux-foundation.org, linux-kernel@vger.kernel.org,
       Alan Stern <stern@rowland.harvard.edu>, Tejun Heo <tj@kernel.org>,
       Oleg Nesterov <oleg@redhat.com>, Len Brown <len.brown@intel.com>,
       Pavel Machek <pavel@ucw.cz>, Randy Dunlap <rdunlap@xenotime.net>,
       Jesse Barnes <jbarnes@virtuousgeek.org>, Magnus Damm <damm@igel.co.jp>,
       Nigel Cunningham <nigel@tuxonice.net>,
       Cornelia Huck <cornelia.huck@de.ibm.com>,
       Ming Lei <tom.leiming@gmail.com>, Wu Fengguang <fengguang.wu@intel.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       Maxim Levitsky <maximlevitsky@gmail.com>, linux-doc@vger.kernel.org
References: <1272429119-12103-1-git-send-email-arve@android.com> <201004282250.44200.rjw@sisk.pl> <l2yd6200be21004282037rc063266by91db7f732ceaa529@mail.gmail.com>
In-Reply-To: <l2yd6200be21004282037rc063266by91db7f732ceaa529@mail.gmail.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 8BIT
Message-Id: <201004292316.14524.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 29 April 2010, Arve Hjønnevåg wrote:
> 2010/4/28 Rafael J. Wysocki <rjw@sisk.pl>:
> ...
> >>
> >> +/**
> >> + *   policy - set policy for state
> >> + */
> >> +
> >> +static ssize_t policy_show(struct kobject *kobj,
> >> +                        struct kobj_attribute *attr, char *buf)
> >> +{
> >> +     char *s = buf;
> >> +     int i;
> >> +
> >> +     for (i = 0; i < ARRAY_SIZE(policies); i++) {
> >> +             if (i == policy)
> >> +                     s += sprintf(s, "[%s] ", policies[i].name);
> >> +             else
> >> +                     s += sprintf(s, "%s ", policies[i].name);
> >> +     }
> >> +     if (s != buf)
> >> +             /* convert the last space to a newline */
> >> +             *(s-1) = '\n';
> >> +     return (s - buf);
> >> +}
> >> +
> >> +static ssize_t policy_store(struct kobject *kobj,
> >> +                         struct kobj_attribute *attr,
> >> +                         const char *buf, size_t n)
> >> +{
> >> +     const char *s;
> >> +     char *p;
> >> +     int len;
> >> +     int i;
> >> +
> >> +     p = memchr(buf, '\n', n);
> >> +     len = p ? p - buf : n;
> >> +
> >> +     for (i = 0; i < ARRAY_SIZE(policies); i++) {
> >> +             s = policies[i].name;
> >> +             if (s && len == strlen(s) && !strncmp(buf, s, len)) {
> >> +                     mutex_lock(&pm_mutex);
> >> +                     policies[policy].set_state(PM_SUSPEND_ON);
> >> +                     policy = i;
> >> +                     mutex_unlock(&pm_mutex);
> >> +                     return n;
> >> +             }
> >> +     }
> >> +     return -EINVAL;
> >> +}
> >> +
> >> +power_attr(policy);
> >> +
> >>  #ifdef CONFIG_PM_TRACE
> >>  int pm_trace_enabled;
> >>
> >
> > Would you mind if I changed the above so that "policy" doesn't even show up
> > if CONFIG_OPPORTUNISTIC_SUSPEND is unset?
> >
> I don't mind, but It did not seem worth the trouble to hide it. It
> will only list the supported policies, and it is easy to add or remove
> policies this way.
> 
> > ...
> >> +static void suspend_worker(struct work_struct *work)
> >> +{
> >> +     int ret;
> >> +     int entry_event_num;
> >> +
> >> +     enable_suspend_blockers = true;
> >> +     while (!suspend_is_blocked()) {
> >> +             entry_event_num = current_event_num;
> >> +
> >> +             if (debug_mask & DEBUG_SUSPEND)
> >> +                     pr_info("suspend: enter suspend\n");
> >> +
> >> +             ret = pm_suspend(requested_suspend_state);
> >> +
> >> +             if (debug_mask & DEBUG_EXIT_SUSPEND)
> >> +                     pr_info_time("suspend: exit suspend, ret = %d ", ret);
> >> +
> >> +             if (current_event_num == entry_event_num)
> >> +                     pr_info("suspend: pm_suspend returned with no event\n");
> >
> > Hmm, what exactly is this for?  It looks like a debug thing to me.  I'd use
> > pr_debug() here and in both debug printk()s above.  Would you agree?
> >
> 
> If the driver that caused the wakeup does not use suspend blockers, we
> the only choice is to try to suspend again. I want to know if this
> happened. The stats patch disable this printk by default since it will
> show up in the stats, and the timeout patch (not included here) delays
> the retry.
> 
> ...
> >> +EXPORT_SYMBOL(suspend_blocker_init);
> >
> > Is there a strong objection to changing that (and the other instances below) to
> > EXPORT_SYMBOL_GPL?
> >
> 
> I don't know if it is a strong objection, but I prefer that this api
> is available to all drivers. I don't want to prevent a user from using
> opportunistic suspend because a non-gpl driver could not use suspend
> blockers. I changed the suspend blocking work functions to be gpl only
> though, since they are not required, and the workqueue api is
> available to gpl code anyway.
> 
> ...
> >> +bool request_suspend_valid_state(suspend_state_t state)
> >> +{
> >> +     return (state == PM_SUSPEND_ON) || valid_state(state);
> >> +}
> >> +
> >> +int request_suspend_state(suspend_state_t state)
> >> +{
> >> +     unsigned long irqflags;
> >> +
> >> +     if (!request_suspend_valid_state(state))
> >> +             return -ENODEV;
> >> +
> >> +     spin_lock_irqsave(&state_lock, irqflags);
> >> +
> >> +     if (debug_mask & DEBUG_USER_STATE)
> >> +             pr_info_time("request_suspend_state: %s (%d->%d) at %lld ",
> >> +                          state != PM_SUSPEND_ON ? "sleep" : "wakeup",
> >> +                          requested_suspend_state, state,
> >> +                          ktime_to_ns(ktime_get()));
> >> +
> >> +     requested_suspend_state = state;
> >> +     if (state == PM_SUSPEND_ON)
> >> +             suspend_block(&main_suspend_blocker);
> >> +     else
> >> +             suspend_unblock(&main_suspend_blocker);
> >> +     spin_unlock_irqrestore(&state_lock, irqflags);
> >> +     return 0;
> >> +}
> >
> > I think the two functions above should be static, shouldn't they?
> 
> No, they are used from main.c.
> 
> >
> >> +static int __init suspend_block_init(void)
> >> +{
> >> +     suspend_work_queue = create_singlethread_workqueue("suspend");
> >> +     if (!suspend_work_queue)
> >> +             return -ENOMEM;
> >> +
> >> +     suspend_blocker_init(&main_suspend_blocker, "main");
> >> +     suspend_block(&main_suspend_blocker);
> >> +     return 0;
> >> +}
> >> +
> >> +core_initcall(suspend_block_init);
> >
> > Hmm.  Why don't you want to put that initialization into pm_init() (in
> > kernel/power/main.c)?
> 
> It was not needed before, but I changed pm_init to call
> suspend_block_init after creating pm_wq.
> 
> >
> > Also, we already have one PM workqueue.  It is used for runtime PM, but I guess
> > it may be used just as well for the opportunistic suspend.  It is freezable,
> > but would it hurt?
> 
> No, it works, the freezable flag is just ignored when I call
> pm_suspend and I don't run anything else on the workqueue while
> threads are frozen. It does need to be a single threaded workqueue
> though, so make sure you don't just change that.

Freezable workqueues have to be singlethread or else there will be unfixable
races, so you can safely assume things will stay as they are in this respect.

Rafael


> 
> 

