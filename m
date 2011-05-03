Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753099Ab1ECGoU (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 May 2011 02:44:20 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:40751 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751485Ab1ECGoS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 May 2011 02:44:18 -0400
Date: Tue, 3 May 2011 08:44:01 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Borislav Petkov <bp@amd64.org>
Cc: Peter Zijlstra <peterz@infradead.org>,
        Arnaldo Carvalho de Melo <acme@infradead.org>,
        Steven Rostedt <rostedt@goodmis.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Tony Luck <tony.luck@intel.com>,
        Mauro Carvalho Chehab <mchehab@redhat.com>,
        EDAC devel <linux-edac@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Borislav Petkov <borislav.petkov@amd.com>
Subject: Re: [PATCH 3/4] x86, mce: Add persistent MCE event
Message-ID: <20110503064401.GE7751@elte.hu>
References: <1304357691-14354-1-git-send-email-bp@amd64.org>
 <1304357691-14354-4-git-send-email-bp@amd64.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1304357691-14354-4-git-send-email-bp@amd64.org>
User-Agent: Mutt/1.5.20 (2009-08-17)
X-ELTE-SpamScore: -2.0
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-2.0 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.3.1
	-2.0 BAYES_00               BODY: Bayes spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Borislav Petkov <bp@amd64.org> wrote:

> +static struct perf_event_attr pattr = {
> +	.type		= PERF_TYPE_TRACEPOINT,
> +	.size		= sizeof(pattr),
> +	.sample_type	= PERF_SAMPLE_RAW,
> +	.persistent	= 1,
> +};
> +
> +static struct dentry *mce_add_event_debugfs(struct perf_event *event, int cpu)
> +{
> +	char buf[14];
> +
> +	sprintf(buf, "mce_record%d", cpu);
> +
> +	return debugfs_create_file(buf, S_IRUGO | S_IWUSR,
> +				   mce_get_debugfs_dir(),
> +				   event, &perf_pers_fops);
> +}
> +
> +#define MCE_BUF_PAGES	4
> +
> +static int mce_enable_perf_event_on_cpu(int cpu)
> +{
> +	struct mce_tp_desc *d = &per_cpu(mce_event, cpu);
> +	int err = -EINVAL;
> +
> +	d->event = perf_enable_persistent_event(&pattr, cpu, MCE_BUF_PAGES);
> +	if (IS_ERR(d->event)) {
> +		printk(KERN_ERR "MCE: Error enabling event on cpu %d\n", cpu);
> +		goto ret;
> +	}
> +
> +	d->debugfs_entry = mce_add_event_debugfs(d->event, cpu);
> +	if (!d->debugfs_entry) {
> +		printk(KERN_ERR "MCE: Error adding event debugfs entry on cpu %d\n", cpu);
> +		goto disable;
> +	}
> +
> +	return 0;
> +
> +disable:
> +	perf_disable_persistent_event(d->event, cpu);
> +
> +ret:
> +	return err;
> +}
> +
> +static void mce_disable_perf_event_on_cpu(int cpu)
> +{
> +	struct mce_tp_desc *d = &per_cpu(mce_event, cpu);
> +	debugfs_remove(d->debugfs_entry);
> +	perf_disable_persistent_event(d->event, cpu);
> +}
> +
> +static __init int mcheck_init_persistent_event(void)
> +{
> +	int cpu, err = 0;
> +
> +	get_online_cpus();
> +
> +	pattr.config = event_mce_record.event.type;
> +	pattr.sample_period = 1;
> +	pattr.wakeup_events = 1;
> +
> +	for_each_online_cpu(cpu)
> +		if (mce_enable_perf_event_on_cpu(cpu))
> +			goto err_unwind;
> +
> +	goto unlock;
> +
> +err_unwind:
> +	err = -EINVAL;
> +	for (--cpu; cpu >= 0; cpu--)
> +		mce_disable_perf_event_on_cpu(cpu);
> +
> +unlock:
> +	put_online_cpus();
> +
> +	return err;
> +}
> +
> +/*
> + * This has to run after event_trace_init()
> + */
> +device_initcall(mcheck_init_persistent_event);

Looks quite generic - shouldnt this bit be generalized a bit more into 
kernel/events/? When other places (and other platforms) want to add a
persistent event they would thus have your new facility available as well.

Except this bit:

>  /* Get notified when a cpu comes on/off. Be hotplug friendly. */
>  static int __cpuinit
>  mce_cpu_callback(struct notifier_block *nfb, unsigned long action, void *hcpu)
> @@ -2068,6 +2154,7 @@ mce_cpu_callback(struct notifier_block *nfb, unsigned long action, void *hcpu)
>  		mce_create_device(cpu);
>  		if (threshold_cpu_callback)
>  			threshold_cpu_callback(action, cpu);
> +		mce_enable_perf_event_on_cpu(cpu);
>  		break;
>  	case CPU_DEAD:
>  	case CPU_DEAD_FROZEN:
> @@ -2077,6 +2164,7 @@ mce_cpu_callback(struct notifier_block *nfb, unsigned long action, void *hcpu)
>  		break;
>  	case CPU_DOWN_PREPARE:
>  	case CPU_DOWN_PREPARE_FROZEN:
> +		mce_disable_perf_event_on_cpu(cpu);
>  		del_timer_sync(t);
>  		smp_call_function_single(cpu, mce_disable_cpu, &action, 1);
>  		break;
> @@ -2088,6 +2176,7 @@ mce_cpu_callback(struct notifier_block *nfb, unsigned long action, void *hcpu)
>  			add_timer_on(t, cpu);
>  		}
>  		smp_call_function_single(cpu, mce_reenable_cpu, &action, 1);
> +		mce_enable_perf_event_on_cpu(cpu);
>  		break;
>  	case CPU_POST_DEAD:
>  		/* intentionally ignoring frozen here */

which looks a bit x86 specific.

Thanks,

	Ingo
