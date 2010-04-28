Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754937Ab0D1Uu0 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Apr 2010 16:50:26 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:53400 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752088Ab0D1UuY convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Apr 2010 16:50:24 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Arve =?utf-8?q?Hj=C3=B8nnev=C3=A5g?= <arve@android.com>
Subject: Re: [PATCH 1/8] PM: Add suspend block api.
Date: Wed, 28 Apr 2010 22:50:44 +0200
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
References: <1272429119-12103-1-git-send-email-arve@android.com> <1272429119-12103-2-git-send-email-arve@android.com>
In-Reply-To: <1272429119-12103-2-git-send-email-arve@android.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 8BIT
Message-Id: <201004282250.44200.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 28 April 2010, Arve Hjønnevåg wrote:
> Adds /sys/power/policy that selects the behaviour of /sys/power/state.
> After setting the policy to opportunistic, writes to /sys/power/state
> become non-blocking requests that specify which suspend state to enter
> when no suspend blockers are active. A special state, "on", stops the
> process by activating the "main" suspend blocker.
> 
> Signed-off-by: Arve Hjønnevåg <arve@android.com>
> ---
...
> @@ -20,6 +21,27 @@ DEFINE_MUTEX(pm_mutex);
>  unsigned int pm_flags;
>  EXPORT_SYMBOL(pm_flags);
>  
> +struct policy {
> +	const char *name;
> +	bool (*valid_state)(suspend_state_t state);
> +	int (*set_state)(suspend_state_t state);
> +};
> +static struct policy policies[] = {
> +	{
> +		.name		= "forced",
> +		.valid_state	= valid_state,
> +		.set_state	= enter_state,
> +	},
> +#ifdef CONFIG_OPPORTUNISTIC_SUSPEND
> +	{
> +		.name		= "opportunistic",
> +		.valid_state	= request_suspend_valid_state,
> +		.set_state	= request_suspend_state,
> +	},
> +#endif
> +};
> +static int policy;
> +
>  #ifdef CONFIG_PM_SLEEP
>  
>  /* Routines for PM-transition notifications */
> @@ -146,6 +168,12 @@ struct kobject *power_kobj;
>   *
>   *	store() accepts one of those strings, translates it into the 
>   *	proper enumerated value, and initiates a suspend transition.
> + *
> + *	If policy is set to opportunistic, store() does not block until the
> + *	system resumes, and it will try to re-enter the state until another
> + *	state is requested. Suspend blockers are respected and the requested
> + *	state will only be entered when no suspend blockers are active.
> + *	Write "on" to cancel.
>   */
>  static ssize_t state_show(struct kobject *kobj, struct kobj_attribute *attr,
>  			  char *buf)
> @@ -155,12 +183,13 @@ static ssize_t state_show(struct kobject *kobj, struct kobj_attribute *attr,
>  	int i;
>  
>  	for (i = 0; i < PM_SUSPEND_MAX; i++) {
> -		if (pm_states[i] && valid_state(i))
> +		if (pm_states[i] && policies[policy].valid_state(i))
>  			s += sprintf(s,"%s ", pm_states[i]);
>  	}
>  #endif
>  #ifdef CONFIG_HIBERNATION
> -	s += sprintf(s, "%s\n", "disk");
> +	if (!policy)
> +		s += sprintf(s, "%s\n", "disk");
>  #else
>  	if (s != buf)
>  		/* convert the last space to a newline */
> @@ -173,7 +202,7 @@ static ssize_t state_store(struct kobject *kobj, struct kobj_attribute *attr,
>  			   const char *buf, size_t n)
>  {
>  #ifdef CONFIG_SUSPEND
> -	suspend_state_t state = PM_SUSPEND_STANDBY;
> +	suspend_state_t state = PM_SUSPEND_ON;
>  	const char * const *s;
>  #endif
>  	char *p;
> @@ -184,7 +213,7 @@ static ssize_t state_store(struct kobject *kobj, struct kobj_attribute *attr,
>  	len = p ? p - buf : n;
>  
>  	/* First, check if we are requested to hibernate */
> -	if (len == 4 && !strncmp(buf, "disk", len)) {
> +	if (len == 4 && !strncmp(buf, "disk", len) && !policy) {
>  		error = hibernate();
>    goto Exit;
>  	}
> @@ -195,7 +224,7 @@ static ssize_t state_store(struct kobject *kobj, struct kobj_attribute *attr,
>  			break;
>  	}
>  	if (state < PM_SUSPEND_MAX && *s)
> -		error = enter_state(state);
> +		error = policies[policy].set_state(state);
>  #endif
>  
>   Exit:
> @@ -204,6 +233,55 @@ static ssize_t state_store(struct kobject *kobj, struct kobj_attribute *attr,
>  
>  power_attr(state);
>  
> +/**
> + *	policy - set policy for state
> + */
> +
> +static ssize_t policy_show(struct kobject *kobj,
> +			   struct kobj_attribute *attr, char *buf)
> +{
> +	char *s = buf;
> +	int i;
> +
> +	for (i = 0; i < ARRAY_SIZE(policies); i++) {
> +		if (i == policy)
> +			s += sprintf(s, "[%s] ", policies[i].name);
> +		else
> +			s += sprintf(s, "%s ", policies[i].name);
> +	}
> +	if (s != buf)
> +		/* convert the last space to a newline */
> +		*(s-1) = '\n';
> +	return (s - buf);
> +}
> +
> +static ssize_t policy_store(struct kobject *kobj,
> +			    struct kobj_attribute *attr,
> +			    const char *buf, size_t n)
> +{
> +	const char *s;
> +	char *p;
> +	int len;
> +	int i;
> +
> +	p = memchr(buf, '\n', n);
> +	len = p ? p - buf : n;
> +
> +	for (i = 0; i < ARRAY_SIZE(policies); i++) {
> +		s = policies[i].name;
> +		if (s && len == strlen(s) && !strncmp(buf, s, len)) {
> +			mutex_lock(&pm_mutex);
> +			policies[policy].set_state(PM_SUSPEND_ON);
> +			policy = i;
> +			mutex_unlock(&pm_mutex);
> +			return n;
> +		}
> +	}
> +	return -EINVAL;
> +}
> +
> +power_attr(policy);
> +
>  #ifdef CONFIG_PM_TRACE
>  int pm_trace_enabled;
>  

Would you mind if I changed the above so that "policy" doesn't even show up
if CONFIG_OPPORTUNISTIC_SUSPEND is unset?

...
> +static void suspend_worker(struct work_struct *work)
> +{
> +	int ret;
> +	int entry_event_num;
> +
> +	enable_suspend_blockers = true;
> +	while (!suspend_is_blocked()) {
> +		entry_event_num = current_event_num;
> +
> +		if (debug_mask & DEBUG_SUSPEND)
> +			pr_info("suspend: enter suspend\n");
> +
> +		ret = pm_suspend(requested_suspend_state);
> +
> +		if (debug_mask & DEBUG_EXIT_SUSPEND)
> +			pr_info_time("suspend: exit suspend, ret = %d ", ret);
> +
> +		if (current_event_num == entry_event_num)
> +			pr_info("suspend: pm_suspend returned with no event\n");

Hmm, what exactly is this for?  It looks like a debug thing to me.  I'd use
pr_debug() here and in both debug printk()s above.  Would you agree?

> +	}
> +	enable_suspend_blockers = false;
> +}
> +static DECLARE_WORK(suspend_work, suspend_worker);
> +
> +/**
> + * suspend_blocker_init() - Initialize a suspend blocker
> + * @blocker:	The suspend blocker to initialize.
> + * @name:	The name of the suspend blocker to show in debug messages.
> + *
> + * The suspend blocker struct and name must not be freed before calling
> + * suspend_blocker_destroy.
> + */
> +void suspend_blocker_init(struct suspend_blocker *blocker, const char *name)
> +{
> +	unsigned long irqflags = 0;
> +
> +	WARN_ON(!name);
> +
> +	if (debug_mask & DEBUG_SUSPEND_BLOCKER)
> +		pr_info("suspend_blocker_init name=%s\n", name);
> +
> +	blocker->name = name;
> +	blocker->flags = SB_INITIALIZED;
> +	INIT_LIST_HEAD(&blocker->link);
> +
> +	spin_lock_irqsave(&list_lock, irqflags);
> +	list_add(&blocker->link, &inactive_blockers);
> +	spin_unlock_irqrestore(&list_lock, irqflags);
> +}
> +EXPORT_SYMBOL(suspend_blocker_init);

Is there a strong objection to changing that (and the other instances below) to
EXPORT_SYMBOL_GPL?

> +
> +/**
> + * suspend_blocker_destroy() - Destroy a suspend blocker
> + * @blocker:	The suspend blocker to destroy.
> + */
> +void suspend_blocker_destroy(struct suspend_blocker *blocker)
> +{
> +	unsigned long irqflags;
> +	if (WARN_ON(!(blocker->flags & SB_INITIALIZED)))
> +		return;
> +
> +	if (debug_mask & DEBUG_SUSPEND_BLOCKER)
> +		pr_info("suspend_blocker_destroy name=%s\n", blocker->name);
> +
> +	spin_lock_irqsave(&list_lock, irqflags);
> +	blocker->flags &= ~SB_INITIALIZED;
> +	list_del(&blocker->link);
> +	if ((blocker->flags & SB_ACTIVE) && list_empty(&active_blockers))
> +		queue_work(suspend_work_queue, &suspend_work);
> +	spin_unlock_irqrestore(&list_lock, irqflags);
> +}
> +EXPORT_SYMBOL(suspend_blocker_destroy);
> +
> +/**
> + * suspend_block() - Block suspend
> + * @blocker:	The suspend blocker to use
> + *
> + * It is safe to call this function from interrupt context.
> + */
> +void suspend_block(struct suspend_blocker *blocker)
> +{
> +	unsigned long irqflags;
> +
> +	if (WARN_ON(!(blocker->flags & SB_INITIALIZED)))
> +		return;
> +
> +	spin_lock_irqsave(&list_lock, irqflags);
> +	blocker->flags |= SB_ACTIVE;
> +	list_del(&blocker->link);
> +
> +	if (debug_mask & DEBUG_SUSPEND_BLOCKER)
> +		pr_info("suspend_block: %s\n", blocker->name);
> +
> +	list_add(&blocker->link, &active_blockers);
> +
> +	current_event_num++;
> +	spin_unlock_irqrestore(&list_lock, irqflags);
> +}
> +EXPORT_SYMBOL(suspend_block);
> +
> +/**
> + * suspend_unblock() - Unblock suspend
> + * @blocker:	The suspend blocker to unblock.
> + *
> + * If no other suspend blockers block suspend, the system will suspend.
> + *
> + * It is safe to call this function from interrupt context.
> + */
> +void suspend_unblock(struct suspend_blocker *blocker)
> +{
> +	unsigned long irqflags;
> +
> +	if (WARN_ON(!(blocker->flags & SB_INITIALIZED)))
> +		return;
> +
> +	spin_lock_irqsave(&list_lock, irqflags);
> +
> +	if (debug_mask & DEBUG_SUSPEND_BLOCKER)
> +		pr_info("suspend_unblock: %s\n", blocker->name);
> +
> +	list_del(&blocker->link);
> +	list_add(&blocker->link, &inactive_blockers);
> +
> +	if ((blocker->flags & SB_ACTIVE) && list_empty(&active_blockers))
> +		queue_work(suspend_work_queue, &suspend_work);
> +	blocker->flags &= ~(SB_ACTIVE);
> +	if (blocker == &main_suspend_blocker) {
> +		if (debug_mask & DEBUG_SUSPEND)
> +			print_active_blockers_locked();
> +	}
> +	spin_unlock_irqrestore(&list_lock, irqflags);
> +}
> +EXPORT_SYMBOL(suspend_unblock);
> +
> +/**
> + * suspend_blocker_is_active() - Test if a suspend blocker is blocking suspend
> + * @blocker:	The suspend blocker to check.
> + *
> + * Returns true if the suspend_blocker is currently active.
> + */
> +bool suspend_blocker_is_active(struct suspend_blocker *blocker)
> +{
> +	WARN_ON(!(blocker->flags & SB_INITIALIZED));
> +
> +	return !!(blocker->flags & SB_ACTIVE);
> +}
> +EXPORT_SYMBOL(suspend_blocker_is_active);
> +
> +bool request_suspend_valid_state(suspend_state_t state)
> +{
> +	return (state == PM_SUSPEND_ON) || valid_state(state);
> +}
> +
> +int request_suspend_state(suspend_state_t state)
> +{
> +	unsigned long irqflags;
> +
> +	if (!request_suspend_valid_state(state))
> +		return -ENODEV;
> +
> +	spin_lock_irqsave(&state_lock, irqflags);
> +
> +	if (debug_mask & DEBUG_USER_STATE)
> +		pr_info_time("request_suspend_state: %s (%d->%d) at %lld ",
> +			     state != PM_SUSPEND_ON ? "sleep" : "wakeup",
> +			     requested_suspend_state, state,
> +			     ktime_to_ns(ktime_get()));
> +
> +	requested_suspend_state = state;
> +	if (state == PM_SUSPEND_ON)
> +		suspend_block(&main_suspend_blocker);
> +	else
> +		suspend_unblock(&main_suspend_blocker);
> +	spin_unlock_irqrestore(&state_lock, irqflags);
> +	return 0;
> +}

I think the two functions above should be static, shouldn't they?

> +static int __init suspend_block_init(void)
> +{
> +	suspend_work_queue = create_singlethread_workqueue("suspend");
> +	if (!suspend_work_queue)
> +		return -ENOMEM;
> +
> +	suspend_blocker_init(&main_suspend_blocker, "main");
> +	suspend_block(&main_suspend_blocker);
> +	return 0;
> +}
> +
> +core_initcall(suspend_block_init);

Hmm.  Why don't you want to put that initialization into pm_init() (in
kernel/power/main.c)?

Also, we already have one PM workqueue.  It is used for runtime PM, but I guess
it may be used just as well for the opportunistic suspend.  It is freezable,
but would it hurt?

Rafael
