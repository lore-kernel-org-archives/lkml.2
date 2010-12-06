Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753344Ab0LFOyv (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Dec 2010 09:54:51 -0500
Received: from mx1.redhat.com ([209.132.183.28]:45322 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752968Ab0LFOyu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Dec 2010 09:54:50 -0500
Date: Mon, 6 Dec 2010 09:54:47 -0500
From: Vivek Goyal <vgoyal@redhat.com>
To: Hillf Danton <dhillf@gmail.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [PATCH] maximize dispatching in block throttle
Message-ID: <20101206145447.GB3117@redhat.com>
References: <AANLkTi=aqMR0uNCgz40pdUG1288CMxLRnZdVxzZuBzGw@mail.gmail.com>
 <20101130145712.GD26758@redhat.com>
 <AANLkTik_x-SSU1aazJ3ZqJdsbq11vh3+=ikwbpxNcRYh@mail.gmail.com>
 <20101201144128.GC4672@redhat.com>
 <AANLkTinGChRaNUeH+AzS+6Y3Au+0BR1Mz97W8aDSoyQf@mail.gmail.com>
 <20101203143256.GA30407@redhat.com>
 <AANLkTikJj+ByPuLK7NEqQd37E=njAiTnOeiLQJcSJBXg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <AANLkTikJj+ByPuLK7NEqQd37E=njAiTnOeiLQJcSJBXg@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Dec 04, 2010 at 09:36:40PM +0800, Hillf Danton wrote:
> On Fri, Dec 3, 2010 at 10:32 PM, Vivek Goyal <vgoyal@redhat.com> wrote:
> > It should not be too hard. IO schedulers already create
> > /sys/block/<dev>/queue/iosched/ dir and we can create <dev>/queue/throttle/
> > dir and export throttle related tunables there.
> 
> Evening, Vivek.
> 
> I worked the framework for the tunable out.
> 
> If in right direction, I will complete it soon.

Hillf, 

You still have not answered my questions in previous mail. 

- What's the problem are you facing and how filling the quantum to the
  capacity is helping you.

- Tunable and filling the quantum are two different things. If filling
  the quantum solved your problem, then how tunable is going to solve
  same problem.

I don't want to introduce tunables if they are really not put to use 
by somebody. So before we move in this direction, lets first answer
above questions.

Thanks
Vivek
 
> 
> Thanks
> Hillf
> 
> 
> 
> --- a/block/blk-throttle.c	2010-11-01 19:54:12.000000000 +0800
> +++ b/block/blk-throttle.c	2010-12-04 21:24:58.000000000 +0800
> @@ -98,6 +98,27 @@ struct throtl_data
>  	struct delayed_work throtl_work;
> 
>  	atomic_t limits_changed;
> +
> +	/*
> +	 * following is sysfs stuff about queue throttle
> +	 */
> +	struct kobject	kobj;
> +
> +	struct mutex	sysfs_lock;
> +
> +	/* Max dispatch from a group in 1 round */
> +	int grp_quantum;
> +
> +	/* Total max dispatch from all groups in one round */
> +	int q_quantum;
> +
> +	/* Throttling is performed over 100ms slice and after that
> +	 * slice is renewed
> +	 */
> +	unsigned long time_slice;
> +
> +	/* read percentage of dispatch from a group in 1 round */
> +	int read_percentage;
>  };
> 
>  enum tg_state_flags {
> @@ -644,11 +665,19 @@ static int throtl_dispatch_tg(struct thr
>  				struct bio_list *bl)
>  {
>  	unsigned int nr_reads = 0, nr_writes = 0;
> -	unsigned int max_nr_reads = throtl_grp_quantum*3/4;
> -	unsigned int max_nr_writes = throtl_grp_quantum - nr_reads;
> +	unsigned int max_nr_reads, max_nr_writes;
>  	struct bio *bio;
> 
> -	/* Try to dispatch 75% READS and 25% WRITES */
> +	max_nr_reads = td->read_percentage * td->grp_quantum /100;
> +	if (! max_nr_reads)
> +		max_nr_reads = 1;
> +	/*
> +	 * both are not computed stricktly here to throttle I/O
> +	 */
> +	if (max_nr_reads < td->grp_quantum)
> +		max_nr_writes = td->grp_quantum - max_nr_reads;
> +	else
> +		max_nr_writes = 1;
> 
>  	while ((bio = bio_list_peek(&tg->bio_lists[READ]))
>  		&& tg_may_dispatch(td, tg, bio, NULL)) {
> @@ -1025,10 +1054,169 @@ out:
>  	return 0;
>  }
> 
> +/*
> + * sysfs stuff
> + */
> +
> +struct throttle_sysfs_entry {
> +	struct attribute attr;
> +	ssize_t (*show)(struct throtl_data *, char *);
> +	ssize_t (*store)(struct throtl_data *, const char *, size_t);
> +};
> +
> +static ssize_t
> +throttle_show_time_slice(struct throtl_data *td, char *page)
> +{
> +	unsigned int msecs = jiffies_to_msecs(td->time_slice);
> +	return sprintf(page, "%lu\n", msecs);
> +}
> +static ssize_t
> +throttle_store_time_slice(struct throtl_data *td,
> +				const char *page, size_t len)
> +{
> +	char *p = (char *) page;
> +	unsigned long msecs = simple_strtoul(p, &p, 10);
> +
> +	td->time_slice = msecs_to_jiffies(msecs);
> +	return len;
> +}
> +static struct throttle_sysfs_entry  throttle_time_slice_entry = {
> +	.attr = { .name = "time_slice", .mode = S_IRUGO | S_IWUSR },
> +	.show = throttle_show_time_slice,
> +	.store = throttle_store_time_slice,
> +};
> +
> +static ssize_t
> +throttle_show_grp_quantum(struct throtl_data *td, char *page)
> +{
> +	return sprintf(page, "%d\n", td->grp_quantum);
> +}
> +static ssize_t
> +throttle_store_grp_quantum(struct throtl_data *td,
> +				const char *page, size_t len)
> +{
> +	char *p = (char *) page;
> +	unsigned long v = simple_strtoul(p, &p, 10);
> +
> +	td->grp_quantum = (int) v;
> +	return len;
> +}
> +static struct throttle_sysfs_entry  throttle_grp_quantum_entry = {
> +	.attr = { .name = "grp_quantum", .mode = S_IRUGO | S_IWUSR },
> +	.show = throttle_show_grp_quantum,
> +	.store = throttle_store_grp_quantum,
> +};
> +
> +static ssize_t
> +throttle_show_q_quantum(struct throtl_data *td, char *page)
> +{
> +	return sprintf(page, "%d\n", td->q_quantum);
> +}
> +static ssize_t
> +throttle_store_q_quantum(struct throtl_data *td,
> +				const char *page, size_t len)
> +{
> +	char *p = (char *) page;
> +	unsigned long v = simple_strtoul(p, &p, 10);
> +
> +	td->q_quantum = (int) v;
> +	return len;
> +}
> +static struct throttle_sysfs_entry  throttle_q_quantum_entry = {
> +	.attr = { .name = "q_quantum", .mode = S_IRUGO | S_IWUSR },
> +	.show = throttle_show_q_quantum,
> +	.store = throttle_store_q_quantum,
> +};
> +
> +static ssize_t
> +throttle_show_read_percentage(struct throtl_data *td, char *page)
> +{
> +	return sprintf(page, "%d\n", td->read_percentage);
> +}
> +static ssize_t
> +throttle_store_read_percentage(struct throtl_data *td,
> +				const char *page, size_t len)
> +{
> +	char *p = (char *) page;
> +	unsigned long v = simple_strtoul(p, &p, 10);
> +
> +	if (v > 99)
> +		v = 99;
> +	else if (v < 1)
> +		v = 1;
> +	td->read_percentage = (int) v;
> +	return len;
> +}
> +static struct throttle_sysfs_entry  throttle_read_percentage_entry = {
> +	.attr = { .name = "read_percentage", .mode = S_IRUGO | S_IWUSR },
> +	.show = throttle_show_read_percentage,
> +	.store = throttle_store_read_percentage,
> +};
> +
> +static struct attribute *throttle_attrs[] = {
> +	&throttle_grp_quantum_entry.attr,
> +	&throttle_q_quantum_entry.attr,
> +	&throttle_time_slice_entry.attr,
> +	&throttle_read_percentage_entry.attr,
> +	NULL,
> +};
> +
> +static ssize_t
> +throttle_attr_store(struct kobject *kobj, struct attribute *attr,
> +		    const char *page, size_t length)
> +{
> +	struct throttle_sysfs_entry *entry =
> +		container_of(attr, struct throttle_sysfs_entry, attr);
> +	struct throtl_data *td =
> +		container_of(kobj, struct throtl_data, kobj);
> +	ssize_t rtn;
> +
> +	if (! entry->store)
> +		return -EIO;
> +	mutex_lock(&td->sysfs_lock);
> +	rtn = entry->store(td, page, length);
> +	mutex_unlock(&td->sysfs_lock);
> +	return rtn;
> +}
> +
> +static ssize_t
> +throttle_attr_show(struct kobject *kobj, struct attribute *attr, char *page)
> +{
> +	struct throttle_sysfs_entry *entry =
> +		container_of(attr, struct throttle_sysfs_entry, attr);
> +	struct throtl_data *td =
> +		container_of(kobj, struct throtl_data, kobj);
> +	ssize_t rtn;
> +
> +	if (! entry->show)
> +		return -EIO;
> +	mutex_lock(&td->sysfs_lock);
> +	rtn = entry->show(td, page);
> +	mutex_unlock(&td->sysfs_lock);
> +	return rtn;
> +}
> +
> +static const struct sysfs_ops  throttle_sysfs_ops = {
> +	.show	= throttle_attr_show,
> +	.store	= throttle_attr_store,
> +};
> +
> +static void throttle_release(struct kobject *kobj)
> +{
> +}
> +
> +static struct kobj_type blk_throttle_ktype = {
> +	.sysfs_ops	= &throttle_sysfs_ops,
> +	.default_attrs	= throttle_attrs,
> +	.release	= throttle_release,
> +};
> +
> +
>  int blk_throtl_init(struct request_queue *q)
>  {
>  	struct throtl_data *td;
>  	struct throtl_grp *tg;
> +	int rtn;
> 
>  	td = kzalloc_node(sizeof(*td), GFP_KERNEL, q->node);
>  	if (!td)
> @@ -1049,6 +1237,20 @@ int blk_throtl_init(struct request_queue
>  	tg->bps[0] = tg->bps[1] = -1;
>  	tg->iops[0] = tg->iops[1] = -1;
> 
> +	mutex_init(&td->sysfs_lock);
> +	td->grp_quantum = throtl_grp_quantum;
> +	td->q_quantum = throtl_quantum;
> +	td->time_slice = throtl_slice;
> +	/* Try to dispatch 75% READS and 25% WRITES by default */
> +	td->read_percentage = 75;
> +	kobject_init(&td->kobj, &blk_throttle_ktype);
> +	rtn = kobject_add(&td->kobj, kobject_get(&q->kobj), "%s", "throttle");
> +	if (rtn < 0) {
> +		kfree(td);
> +		return rtn;
> +	}
> +	kobject_uevent(&td->kobj, KOBJ_ADD);
> +
>  	/*
>  	 * Set root group reference to 2. One reference will be dropped when
>  	 * all groups on tg_list are being deleted during queue exit. Other
> @@ -1111,6 +1313,9 @@ void blk_throtl_exit(struct request_queu
>  	 * it.
>  	 */
>  	throtl_shutdown_timer_wq(q);
> +	kobject_uevent(&td->kobj, KOBJ_REMOVE);
> +	kobject_del(&td->kobj);
> +	kobject_put(&q->kobj);
>  	throtl_td_free(td);
>  }
