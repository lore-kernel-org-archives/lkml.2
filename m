Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754062Ab1BOCim (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Feb 2011 21:38:42 -0500
Received: from cn.fujitsu.com ([222.73.24.84]:53234 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1751196Ab1BOCik (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Feb 2011 21:38:40 -0500
Message-ID: <4D59E728.3030209@cn.fujitsu.com>
Date: Tue, 15 Feb 2011 10:38:32 +0800
From: Gui Jianfeng <guijianfeng@cn.fujitsu.com>
User-Agent: Thunderbird 2.0.0.24 (Windows/20100228)
MIME-Version: 1.0
To: Vivek Goyal <vgoyal@redhat.com>
CC: Jens Axboe <axboe@kernel.dk>, Shaohua Li <shaohua.li@intel.com>,
        lkml <linux-kernel@vger.kernel.org>,
        Chad Talbott <ctalbott@google.com>, Divyesh Shah <dpshah@google.com>
Subject: Re: [PATCH 5/6 v4] cfq-iosched: CFQ group hierarchical scheduling
 and use_hierarchy interface
References: <4D51ED26.8050809@cn.fujitsu.com> <4D539821.1090703@cn.fujitsu.com> <20110210205722.GB2600@redhat.com> <4D55EEBB.8060304@cn.fujitsu.com> <20110214180428.GF13097@redhat.com>
In-Reply-To: <20110214180428.GF13097@redhat.com>
X-MIMETrack: Itemize by SMTP Server on mailserver/fnst(Release 8.5.1FP4|July 25, 2010) at
 2011-02-15 10:37:43,
	Serialize by Router on mailserver/fnst(Release 8.5.1FP4|July 25, 2010) at
 2011-02-15 10:37:43,
	Serialize complete at 2011-02-15 10:37:43
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Vivek Goyal wrote:
> On Sat, Feb 12, 2011 at 10:21:47AM +0800, Gui Jianfeng wrote:
> [..]
>>>> +static struct cfq_group *
>>>> +cfq_find_alloc_cfqg(struct cfq_data *cfqd, struct cgroup *cgroup, int create)
>>>> +{
>>>> +	struct blkio_cgroup *blkcg = cgroup_to_blkio_cgroup(cgroup);
>>>> +	struct cfq_group *cfqg = NULL;
>>>> +	void *key = cfqd;
>>>> +	struct backing_dev_info *bdi = &cfqd->queue->backing_dev_info;
>>>> +	unsigned int major, minor;
>>>> +
>>>> +	cfqg = cfqg_of_blkg(blkiocg_lookup_group(blkcg, key));
>>>> +	if (cfqg && !cfqg->blkg.dev && bdi->dev && dev_name(bdi->dev)) {
>>>> +		sscanf(dev_name(bdi->dev), "%u:%u", &major, &minor);
>>>> +		cfqg->blkg.dev = MKDEV(major, minor);
>>>> +		goto done;
>>>> +	}
>>> Should we make this updation of this info hierarhical?
>> IMHO, it's fine to defer the updation when we really get the cfqg.
> 
> But if cfqg is alrady present, we will never hit the allocation path 
> again. So if somebody creates 2-3 level deep hierarchy and does IO
> only in the children cgroup, parent cgroups will potentially not get
> device info updated hence no visible stats?

Ahh, I see your concern. But do we really need to show the stats even if
a cgroup doesn't issue any IO on a given device? 
For example, on valinna kernel, when we create a new cgroup, we check the
stats, say blkio.io_service_bytes, we will get "Total 0", and no disk
specific stats.
Currently, As soon as a cgroup issue one IO request, cfqg->blkg.dev will
be updated.

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
