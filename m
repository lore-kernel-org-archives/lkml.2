Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753552Ab1GRNe4 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Jul 2011 09:34:56 -0400
Received: from casper.infradead.org ([85.118.1.10]:35828 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751029Ab1GRNez convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Jul 2011 09:34:55 -0400
Subject: Re: [PATCH v2 1/6] perf: Add interface to add general events to
 sysfs
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: Lin Ming <ming.m.lin@intel.com>
Cc: Ingo Molnar <mingo@elte.hu>, Andi Kleen <andi@firstfloor.org>,
        Stephane Eranian <eranian@google.com>,
        Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        linux-kernel <linux-kernel@vger.kernel.org>
In-Reply-To: <1310740503-15608-2-git-send-email-ming.m.lin@intel.com>
References: <1310740503-15608-1-git-send-email-ming.m.lin@intel.com>
	 <1310740503-15608-2-git-send-email-ming.m.lin@intel.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
Date: Mon, 18 Jul 2011 15:34:28 +0200
Message-ID: <1310996068.13765.67.camel@twins>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2011-07-15 at 14:34 +0000, Lin Ming wrote:
> PMU can implement ::add_events() to add its general events to sysfs.
> 
> For example,
> 
> /sys/bus/event_source/devices/uncore/events
> └── cycle
> 
> Signed-off-by: Lin Ming <ming.m.lin@intel.com>
> ---
>  include/linux/perf_event.h |    9 +++++++
>  kernel/events/core.c       |   52 ++++++++++++++++++++++++++++++++++++++++++++
>  2 files changed, 61 insertions(+), 0 deletions(-)
> 
> diff --git a/include/linux/perf_event.h b/include/linux/perf_event.h
> index 3f2711c..14337a3 100644
> --- a/include/linux/perf_event.h
> +++ b/include/linux/perf_event.h
> @@ -676,6 +676,14 @@ struct pmu {
>  	 * for each successful ->add() during the transaction.
>  	 */
>  	void (*cancel_txn)		(struct pmu *pmu); /* optional */
> +
> +	void (*add_events)		(void);
> +};

I'd rather not have a function pointer here, and all the kobj thingies
can be hooking into the existing struct device, right?

> +struct pmu_event {
> +	char name[64];
> +	u64 config;
> +	struct kobj_attribute attr;
>  };

Can't this live in kerne/event/internal.h?

>  /**
> @@ -941,6 +949,7 @@ struct perf_output_handle {
>  
>  extern int perf_pmu_register(struct pmu *pmu, char *name, int type);
>  extern void perf_pmu_unregister(struct pmu *pmu);
> +extern void perf_pmu_add_events(struct pmu *pmu, struct pmu_event events[], int count);
>  
>  extern int perf_num_counters(void);
>  extern const char *perf_pmu_name(void);
> diff --git a/kernel/events/core.c b/kernel/events/core.c
> index 0567e32..9f4f463 100644
> --- a/kernel/events/core.c
> +++ b/kernel/events/core.c
> @@ -5571,6 +5571,8 @@ static int pmu_dev_alloc(struct pmu *pmu)
>  	if (ret)
>  		goto free_dev;
>  
> +	if (pmu->add_events)
> +		pmu->add_events();
>  out:
>  	return ret;
>  
> @@ -7035,4 +7037,54 @@ struct cgroup_subsys perf_subsys = {
>  	.exit		= perf_cgroup_exit,
>  	.attach_task	= perf_cgroup_attach_task,
>  };
> +
> +static ssize_t pmu_event_show(struct kobject *kobj,
> +		struct kobj_attribute *attr, char *buf)
> +{
> +	struct pmu_event *event = container_of(attr, struct pmu_event, attr);
> +	int size;
> +
> +	size = sprintf(buf, "%lld\n", event->config);
> +
> +	return size;
> +}
> +
> +void perf_pmu_add_events(struct pmu *pmu, struct pmu_event events[], int count)
> +{
> +	struct attribute_group *attr_group = NULL;
> +	struct attribute **all_attrs = NULL;
> +	struct kobj_attribute *event_attr;
> +	struct pmu_event *event;
> +	int i;
> +
> +	attr_group = kzalloc(sizeof(*attr_group), GFP_KERNEL);
> +	if (!attr_group)
> +		return;
> +	attr_group->name = "events";
> +
> +	all_attrs = kzalloc(sizeof(*all_attrs) * (count + 1), GFP_KERNEL);
> +	if (!all_attrs)
> +		goto fail;
> +
> +	for (i = 0; i < count; i++) {
> +		event = &events[i];
> +		event_attr = &event->attr;
> +
> +		sysfs_attr_init(&event_attr->attr);
> +		event_attr->attr.name = event->name;
> +		event_attr->attr.mode = 0444;
> +		event_attr->show = pmu_event_show;
> +
> +		all_attrs[i] = &event_attr->attr;
> +	}
> +
> +	attr_group->attrs = all_attrs;
> +	if (!sysfs_create_group(&pmu->dev->kobj, attr_group))
> +		return;
> +
> +fail:
> +	kfree(attr_group);
> +	kfree(all_attrs);
> +}
> +
>  #endif /* CONFIG_CGROUP_PERF */

Uhm, why does this live under CONFIG_CGROUP_PERF?

Also, I would prefer an interface like:

int perf_pmu_add_event(struct pmu *pmu, const char *name, u64 config)
{
}

which would create the events directory if not already present and
allocate and add a pmu_sysfs_event thingy.


