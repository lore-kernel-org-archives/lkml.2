Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755855Ab1BQBWx (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Feb 2011 20:22:53 -0500
Received: from cn.fujitsu.com ([222.73.24.84]:62986 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1754033Ab1BQBWu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Feb 2011 20:22:50 -0500
Message-ID: <4D5C7861.5090900@cn.fujitsu.com>
Date: Thu, 17 Feb 2011 09:22:41 +0800
From: Gui Jianfeng <guijianfeng@cn.fujitsu.com>
User-Agent: Thunderbird 2.0.0.24 (Windows/20100228)
MIME-Version: 1.0
To: Vivek Goyal <vgoyal@redhat.com>
CC: Jens Axboe <axboe@kernel.dk>, Shaohua Li <shaohua.li@intel.com>,
        lkml <linux-kernel@vger.kernel.org>,
        Chad Talbott <ctalbott@google.com>, Divyesh Shah <dpshah@google.com>
Subject: Re: [PATCH 5/6 v4] cfq-iosched: CFQ group hierarchical scheduling
 and use_hierarchy interface
References: <4D51ED26.8050809@cn.fujitsu.com> <4D539821.1090703@cn.fujitsu.com> <20110210205722.GB2600@redhat.com> <4D55EEBB.8060304@cn.fujitsu.com> <20110214180428.GF13097@redhat.com> <4D59E728.3030209@cn.fujitsu.com> <20110215142752.GC27296@redhat.com> <4D5B2C07.9050909@cn.fujitsu.com> <20110216141746.GA14653@redhat.com>
In-Reply-To: <20110216141746.GA14653@redhat.com>
X-MIMETrack: Itemize by SMTP Server on mailserver/fnst(Release 8.5.1FP4|July 25, 2010) at
 2011-02-17 09:21:51,
	Serialize by Router on mailserver/fnst(Release 8.5.1FP4|July 25, 2010) at
 2011-02-17 09:21:52,
	Serialize complete at 2011-02-17 09:21:52
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Vivek Goyal wrote:
> On Wed, Feb 16, 2011 at 09:44:39AM +0800, Gui Jianfeng wrote:
>> Vivek Goyal wrote:
>>> On Tue, Feb 15, 2011 at 10:38:32AM +0800, Gui Jianfeng wrote:
>>>> Vivek Goyal wrote:
>>>>> On Sat, Feb 12, 2011 at 10:21:47AM +0800, Gui Jianfeng wrote:
>>>>> [..]
>>>>>>>> +static struct cfq_group *
>>>>>>>> +cfq_find_alloc_cfqg(struct cfq_data *cfqd, struct cgroup *cgroup, int create)
>>>>>>>> +{
>>>>>>>> +	struct blkio_cgroup *blkcg = cgroup_to_blkio_cgroup(cgroup);
>>>>>>>> +	struct cfq_group *cfqg = NULL;
>>>>>>>> +	void *key = cfqd;
>>>>>>>> +	struct backing_dev_info *bdi = &cfqd->queue->backing_dev_info;
>>>>>>>> +	unsigned int major, minor;
>>>>>>>> +
>>>>>>>> +	cfqg = cfqg_of_blkg(blkiocg_lookup_group(blkcg, key));
>>>>>>>> +	if (cfqg && !cfqg->blkg.dev && bdi->dev && dev_name(bdi->dev)) {
>>>>>>>> +		sscanf(dev_name(bdi->dev), "%u:%u", &major, &minor);
>>>>>>>> +		cfqg->blkg.dev = MKDEV(major, minor);
>>>>>>>> +		goto done;
>>>>>>>> +	}
>>>>>>> Should we make this updation of this info hierarhical?
>>>>>> IMHO, it's fine to defer the updation when we really get the cfqg.
>>>>> But if cfqg is alrady present, we will never hit the allocation path 
>>>>> again. So if somebody creates 2-3 level deep hierarchy and does IO
>>>>> only in the children cgroup, parent cgroups will potentially not get
>>>>> device info updated hence no visible stats?
>>>> Ahh, I see your concern. But do we really need to show the stats even if
>>>> a cgroup doesn't issue any IO on a given device? 
>>> I am assuming that once use_hierarchy=1, you are aggregating the stats
>>> in parent cgroups? So if a child services 5 IOs, these are accounted
>>> to parent group also when user_hier=1?
>>>
>>> What happens in case of  memoy cgroup controller?
>> Hmm, it seems memcg aggregating stats in parent group.
>> But do we really need to do that in kernel? I think it's easier to do it in
>> userland, and it makes kernel much simpler.
> 
> I think at some point of time hierarchical aggregated stats will also be
> required. I am also looking at "memory.stat" file of meomory controller
> and they seem to be reporting both aggregated as well as individual group
> stats.
> 
> So we can probably skip implementing hierarhical stats in this patchset
> and implement it on a need basis in future.

Ok, I agree.

Thanks,
Gui

> 
> Thanks
> Vivek
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
> 
