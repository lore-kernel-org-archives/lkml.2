Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752875Ab0CYG2t (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Mar 2010 02:28:49 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:60376 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1751840Ab0CYG2r (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Mar 2010 02:28:47 -0400
Message-ID: <4BAB027D.7000405@cn.fujitsu.com>
Date: Thu, 25 Mar 2010 14:28:13 +0800
From: Gui Jianfeng <guijianfeng@cn.fujitsu.com>
User-Agent: Thunderbird 2.0.0.23 (Windows/20090812)
MIME-Version: 1.0
To: jens.axboe@oracle.com
CC: Vivek Goyal <vgoyal@redhat.com>, Chad Talbott <ctalbott@google.com>,
       linux-kernel@vger.kernel.org, Nauman Rafique <nauman@google.com>,
       Li Zefan <lizf@cn.fujitsu.com>
Subject: Re: [PATCH 1/2 V3] io-controller: Add a new interface	"weight_device"
 for IO-Controller
References: <4B8DFFD7.2000908@cn.fujitsu.com> <20100303143311.GA2866@redhat.com> <20100303154748.GC2866@redhat.com> <e98e18941003031519v14d4f79cg33da5c3cf1f5ac03@mail.gmail.com> <1786ab031003031825m5467c86jf5c355df10001dd2@mail.gmail.com> <4B8F27BD.2020704@cn.fujitsu.com> <4B8F62B7.3080401@cn.fujitsu.com> <20100304152400.GB18786@redhat.com> <4B906BB6.3080104@cn.fujitsu.com> <20100305141300.GA3296@redhat.com>
In-Reply-To: <20100305141300.GA3296@redhat.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Vivek Goyal wrote:
> On Fri, Mar 05, 2010 at 10:25:58AM +0800, Gui Jianfeng wrote:
>> Currently, IO Controller makes use of blkio.weight to assign weight for
>> all devices. Here a new user interface "blkio.weight_device" is introduced to
>> assign different weights for different devices. blkio.weight becomes the
>> default value for devices which are not configured by "blkio.weight_device"
>>
>> You can use the following format to assigned specific weight for a given
>> device:
>>
>> major:minor represents device number.
>>
>> And you can remove a specific weight as following:
>>
>> V1->V2 changes:
>> - use user interface "weight_device" instead of "policy" suggested by Vivek
>> - rename some struct suggested by Vivek
>> - rebase to 2.6-block "for-linus" branch
>> - remove an useless list_empty check pointed out by Li Zefan
>> - some trivial typo fix
>>
>> V2->V3 changes:
>> - Move policy_*_node() functions up to get rid of forward declarations
>> - rename related functions by adding prefix "blkio_"
>>
> 
> Thanks for the changes Gui. Looks good to me.
> 
> Acked-by: Vivek Goyal <vgoyal@redhat.com>

Hi Jens,

This patchset seems to get lost. Just for reminding. Any comments?

Thanks,
Gui

> 
> Vivek
> 
>> Signed-off-by: Gui Jianfeng <guijianfeng@cn.fujitsu.com>
>> ---
>>  block/blk-cgroup.c  |  236 ++++++++++++++++++++++++++++++++++++++++++++++++++-
>>  block/blk-cgroup.h  |   10 ++
>>  block/cfq-iosched.c |    2 +-
>>  3 files changed, 246 insertions(+), 2 deletions(-)
>>
>> diff --git a/block/blk-cgroup.c b/block/blk-cgroup.c
>> index c85d74c..8825e49 100644
>> --- a/block/blk-cgroup.c
>> +++ b/block/blk-cgroup.c
>> @@ -16,6 +16,7 @@
>>  #include <linux/module.h>
>>  #include <linux/err.h>
>>  #include "blk-cgroup.h"
>> +#include <linux/genhd.h>
>>  
>>  static DEFINE_SPINLOCK(blkio_list_lock);
>>  static LIST_HEAD(blkio_list);
>> @@ -23,6 +24,32 @@ static LIST_HEAD(blkio_list);
>>  struct blkio_cgroup blkio_root_cgroup = { .weight = 2*BLKIO_WEIGHT_DEFAULT };
>>  EXPORT_SYMBOL_GPL(blkio_root_cgroup);
>>  
>> +static inline void blkio_policy_insert_node(struct blkio_cgroup *blkcg,
>> +					    struct blkio_policy_node *pn)
>> +{
>> +	list_add(&pn->node, &blkcg->policy_list);
>> +}
>> +
>> +/* Must be called with blkcg->lock held */
>> +static inline void blkio_policy_delete_node(struct blkio_policy_node *pn)
>> +{
>> +	list_del(&pn->node);
>> +}
>> +
>> +/* Must be called with blkcg->lock held */
>> +static struct blkio_policy_node *
>> +blkio_policy_search_node(const struct blkio_cgroup *blkcg, dev_t dev)
>> +{
>> +	struct blkio_policy_node *pn;
>> +
>> +	list_for_each_entry(pn, &blkcg->policy_list, node) {
>> +		if (pn->dev == dev)
>> +			return pn;
>> +	}
>> +
>> +	return NULL;
>> +}
>> +
>>  struct blkio_cgroup *cgroup_to_blkio_cgroup(struct cgroup *cgroup)
>>  {
>>  	return container_of(cgroup_subsys_state(cgroup, blkio_subsys_id),
>> @@ -128,6 +155,7 @@ blkiocg_weight_write(struct cgroup *cgroup, struct cftype *cftype, u64 val)
>>  	struct blkio_group *blkg;
>>  	struct hlist_node *n;
>>  	struct blkio_policy_type *blkiop;
>> +	struct blkio_policy_node *pn;
>>  
>>  	if (val < BLKIO_WEIGHT_MIN || val > BLKIO_WEIGHT_MAX)
>>  		return -EINVAL;
>> @@ -136,7 +164,13 @@ blkiocg_weight_write(struct cgroup *cgroup, struct cftype *cftype, u64 val)
>>  	spin_lock(&blkio_list_lock);
>>  	spin_lock_irq(&blkcg->lock);
>>  	blkcg->weight = (unsigned int)val;
>> +
>>  	hlist_for_each_entry(blkg, n, &blkcg->blkg_list, blkcg_node) {
>> +		pn = blkio_policy_search_node(blkcg, blkg->dev);
>> +
>> +		if (pn)
>> +			continue;
>> +
>>  		list_for_each_entry(blkiop, &blkio_list, list)
>>  			blkiop->ops.blkio_update_group_weight_fn(blkg,
>>  					blkcg->weight);
>> @@ -178,15 +212,208 @@ SHOW_FUNCTION_PER_GROUP(dequeue);
>>  
>>  #ifdef CONFIG_DEBUG_BLK_CGROUP
>>  void blkiocg_update_blkio_group_dequeue_stats(struct blkio_group *blkg,
>> -			unsigned long dequeue)
>> +					      unsigned long dequeue)
>>  {
>>  	blkg->dequeue += dequeue;
>>  }
>>  EXPORT_SYMBOL_GPL(blkiocg_update_blkio_group_dequeue_stats);
>>  #endif
>>  
>> +static int blkio_check_dev_num(dev_t dev)
>> +{
>> +	int part = 0;
>> +	struct gendisk *disk;
>> +
>> +	disk = get_gendisk(dev, &part);
>> +	if (!disk || part)
>> +		return -ENODEV;
>> +
>> +	return 0;
>> +}
>> +
>> +static int blkio_policy_parse_and_set(char *buf,
>> +				      struct blkio_policy_node *newpn)
>> +{
>> +	char *s[4], *p, *major_s = NULL, *minor_s = NULL;
>> +	int ret;
>> +	unsigned long major, minor, temp;
>> +	int i = 0;
>> +	dev_t dev;
>> +
>> +	memset(s, 0, sizeof(s));
>> +
>> +	while ((p = strsep(&buf, " ")) != NULL) {
>> +		if (!*p)
>> +			continue;
>> +
>> +		s[i++] = p;
>> +
>> +		/* Prevent from inputing too many things */
>> +		if (i == 3)
>> +			break;
>> +	}
>> +
>> +	if (i != 2)
>> +		return -EINVAL;
>> +
>> +	p = strsep(&s[0], ":");
>> +	if (p != NULL)
>> +		major_s = p;
>> +	else
>> +		return -EINVAL;
>> +
>> +	minor_s = s[0];
>> +	if (!minor_s)
>> +		return -EINVAL;
>> +
>> +	ret = strict_strtoul(major_s, 10, &major);
>> +	if (ret)
>> +		return -EINVAL;
>> +
>> +	ret = strict_strtoul(minor_s, 10, &minor);
>> +	if (ret)
>> +		return -EINVAL;
>> +
>> +	dev = MKDEV(major, minor);
>> +
>> +	ret = blkio_check_dev_num(dev);
>> +	if (ret)
>> +		return ret;
>> +
>> +	newpn->dev = dev;
>> +
>> +	if (s[1] == NULL)
>> +		return -EINVAL;
>> +
>> +	ret = strict_strtoul(s[1], 10, &temp);
>> +	if (ret || (temp < BLKIO_WEIGHT_MIN && temp > 0) ||
>> +	    temp > BLKIO_WEIGHT_MAX)
>> +		return -EINVAL;
>> +
>> +	newpn->weight =  temp;
>> +
>> +	return 0;
>> +}
>> +
>> +unsigned int blkcg_get_weight(struct blkio_cgroup *blkcg,
>> +			      dev_t dev)
>> +{
>> +	struct blkio_policy_node *pn;
>> +
>> +	pn = blkio_policy_search_node(blkcg, dev);
>> +	if (pn)
>> +		return pn->weight;
>> +	else
>> +		return blkcg->weight;
>> +}
>> +EXPORT_SYMBOL_GPL(blkcg_get_weight);
>> +
>> +static int blkiocg_weight_device_write(struct cgroup *cgrp, struct cftype *cft,
>> +				       const char *buffer)
>> +{
>> +	int ret = 0;
>> +	char *buf;
>> +	struct blkio_policy_node *newpn, *pn;
>> +	struct blkio_cgroup *blkcg;
>> +	struct blkio_group *blkg;
>> +	int keep_newpn = 0;
>> +	struct hlist_node *n;
>> +	struct blkio_policy_type *blkiop;
>> +
>> +	buf = kstrdup(buffer, GFP_KERNEL);
>> +	if (!buf)
>> +		return -ENOMEM;
>> +
>> +	newpn = kzalloc(sizeof(*newpn), GFP_KERNEL);
>> +	if (!newpn) {
>> +		ret = -ENOMEM;
>> +		goto free_buf;
>> +	}
>> +
>> +	ret = blkio_policy_parse_and_set(buf, newpn);
>> +	if (ret)
>> +		goto free_newpn;
>> +
>> +	blkcg = cgroup_to_blkio_cgroup(cgrp);
>> +
>> +	spin_lock_irq(&blkcg->lock);
>> +
>> +	pn = blkio_policy_search_node(blkcg, newpn->dev);
>> +	if (!pn) {
>> +		if (newpn->weight != 0) {
>> +			blkio_policy_insert_node(blkcg, newpn);
>> +			keep_newpn = 1;
>> +		}
>> +		spin_unlock_irq(&blkcg->lock);
>> +		goto update_io_group;
>> +	}
>> +
>> +	if (newpn->weight == 0) {
>> +		/* weight == 0 means deleteing a specific weight */
>> +		blkio_policy_delete_node(pn);
>> +		spin_unlock_irq(&blkcg->lock);
>> +		goto update_io_group;
>> +	}
>> +	spin_unlock_irq(&blkcg->lock);
>> +
>> +	pn->weight = newpn->weight;
>> +
>> +update_io_group:
>> +	/* update weight for each cfqg */
>> +	spin_lock(&blkio_list_lock);
>> +	spin_lock_irq(&blkcg->lock);
>> +
>> +	hlist_for_each_entry(blkg, n, &blkcg->blkg_list, blkcg_node) {
>> +		if (newpn->dev == blkg->dev) {
>> +			list_for_each_entry(blkiop, &blkio_list, list)
>> +				blkiop->ops.blkio_update_group_weight_fn(blkg,
>> +						newpn->weight ?
>> +						newpn->weight :
>> +						blkcg->weight);
>> +		}
>> +	}
>> +
>> +	spin_unlock_irq(&blkcg->lock);
>> +	spin_unlock(&blkio_list_lock);
>> +
>> +free_newpn:
>> +	if (!keep_newpn)
>> +		kfree(newpn);
>> +free_buf:
>> +	kfree(buf);
>> +	return ret;
>> +}
>> +
>> +static int blkiocg_weight_device_read(struct cgroup *cgrp, struct cftype *cft,
>> +				      struct seq_file *m)
>> +{
>> +	struct blkio_cgroup *blkcg;
>> +	struct blkio_policy_node *pn;
>> +
>> +	seq_printf(m, "dev\tweight\n");
>> +
>> +	blkcg = cgroup_to_blkio_cgroup(cgrp);
>> +	if (list_empty(&blkcg->policy_list))
>> +		goto out;
>> +
>> +	spin_lock_irq(&blkcg->lock);
>> +	list_for_each_entry(pn, &blkcg->policy_list, node) {
>> +		seq_printf(m, "%u:%u\t%u\n", MAJOR(pn->dev),
>> +			   MINOR(pn->dev), pn->weight);
>> +	}
>> +	spin_unlock_irq(&blkcg->lock);
>> +out:
>> +	return 0;
>> +}
>> +
>>  struct cftype blkio_files[] = {
>>  	{
>> +		.name = "weight_device",
>> +		.read_seq_string = blkiocg_weight_device_read,
>> +		.write_string = blkiocg_weight_device_write,
>> +		.max_write_len = 256,
>> +	},
>> +	{
>>  		.name = "weight",
>>  		.read_u64 = blkiocg_weight_read,
>>  		.write_u64 = blkiocg_weight_write,
>> @@ -220,6 +447,7 @@ static void blkiocg_destroy(struct cgroup_subsys *subsys, struct cgroup *cgroup)
>>  	struct blkio_group *blkg;
>>  	void *key;
>>  	struct blkio_policy_type *blkiop;
>> +	struct blkio_policy_node *pn, *pntmp;
>>  
>>  	rcu_read_lock();
>>  remove_entry:
>> @@ -250,7 +478,12 @@ remove_entry:
>>  		blkiop->ops.blkio_unlink_group_fn(key, blkg);
>>  	spin_unlock(&blkio_list_lock);
>>  	goto remove_entry;
>> +
>>  done:
>> +	list_for_each_entry_safe(pn, pntmp, &blkcg->policy_list, node) {
>> +		blkio_policy_delete_node(pn);
>> +		kfree(pn);
>> +	}
>>  	free_css_id(&blkio_subsys, &blkcg->css);
>>  	rcu_read_unlock();
>>  	kfree(blkcg);
>> @@ -280,6 +513,7 @@ done:
>>  	spin_lock_init(&blkcg->lock);
>>  	INIT_HLIST_HEAD(&blkcg->blkg_list);
>>  
>> +	INIT_LIST_HEAD(&blkcg->policy_list);
>>  	return &blkcg->css;
>>  }
>>  
>> diff --git a/block/blk-cgroup.h b/block/blk-cgroup.h
>> index 84bf745..c8144a2 100644
>> --- a/block/blk-cgroup.h
>> +++ b/block/blk-cgroup.h
>> @@ -22,6 +22,7 @@ struct blkio_cgroup {
>>  	unsigned int weight;
>>  	spinlock_t lock;
>>  	struct hlist_head blkg_list;
>> +	struct list_head policy_list; /* list of blkio_policy_node */
>>  };
>>  
>>  struct blkio_group {
>> @@ -43,6 +44,15 @@ struct blkio_group {
>>  	unsigned long sectors;
>>  };
>>  
>> +struct blkio_policy_node {
>> +	struct list_head node;
>> +	dev_t dev;
>> +	unsigned int weight;
>> +};
>> +
>> +extern unsigned int blkcg_get_weight(struct blkio_cgroup *blkcg,
>> +				     dev_t dev);
>> +
>>  typedef void (blkio_unlink_group_fn) (void *key, struct blkio_group *blkg);
>>  typedef void (blkio_update_group_weight_fn) (struct blkio_group *blkg,
>>  						unsigned int weight);
>> diff --git a/block/cfq-iosched.c b/block/cfq-iosched.c
>> index dee9d93..6945e9b 100644
>> --- a/block/cfq-iosched.c
>> +++ b/block/cfq-iosched.c
>> @@ -954,7 +954,6 @@ cfq_find_alloc_cfqg(struct cfq_data *cfqd, struct cgroup *cgroup, int create)
>>  	if (!cfqg)
>>  		goto done;
>>  
>> -	cfqg->weight = blkcg->weight;
>>  	for_each_cfqg_st(cfqg, i, j, st)
>>  		*st = CFQ_RB_ROOT;
>>  	RB_CLEAR_NODE(&cfqg->rb_node);
>> @@ -971,6 +970,7 @@ cfq_find_alloc_cfqg(struct cfq_data *cfqd, struct cgroup *cgroup, int create)
>>  	sscanf(dev_name(bdi->dev), "%u:%u", &major, &minor);
>>  	blkiocg_add_blkio_group(blkcg, &cfqg->blkg, (void *)cfqd,
>>  					MKDEV(major, minor));
>> +	cfqg->weight = blkcg_get_weight(blkcg, cfqg->blkg.dev);
>>  
>>  	/* Add group on cfqd list */
>>  	hlist_add_head(&cfqg->cfqd_node, &cfqd->cfqg_list);
>> -- 
>> 1.5.4.rc3
>>
>>
>>
>>
> 
> 
> 

