Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757012Ab2DDQpL (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Apr 2012 12:45:11 -0400
Received: from oproxy8-pub.bluehost.com ([69.89.22.20]:43390 "HELO
	oproxy8-pub.bluehost.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1756876Ab2DDQpJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Apr 2012 12:45:09 -0400
Message-ID: <4F7C7A91.8040707@tao.ma>
Date: Thu, 05 Apr 2012 00:45:05 +0800
From: Tao Ma <tm@tao.ma>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.28) Gecko/20120313 Thunderbird/3.1.20
MIME-Version: 1.0
To: Vivek Goyal <vgoyal@redhat.com>
CC: Shaohua Li <shli@kernel.org>, Tejun Heo <tj@kernel.org>, axboe@kernel.dk,
        ctalbott@google.com, rni@google.com, linux-kernel@vger.kernel.org,
        cgroups@vger.kernel.org, containers@lists.linux-foundation.org
Subject: Re: IOPS based scheduler (Was: Re: [PATCH 18/21] blkcg: move blkio_group_conf->weight
 to cfq)
References: <4F7A2217.2030201@tao.ma> <20120402221702.GA21017@dhcp-172-17-108-109.mtv.corp.google.com> <4F7A261A.9000200@tao.ma> <20120402222504.GA2672@redhat.com> <4F7A2B21.5000907@tao.ma> <20120403153736.GI5913@redhat.com> <4F7B2708.6080504@tao.ma> <20120403164959.GJ5913@redhat.com> <4F7B32AE.7050900@tao.ma> <CANejiEU1qAsvogozY3MjZnpcrbYZO4CkRE8s73WGPc_R5LKV9g@mail.gmail.com> <20120404133705.GB12676@redhat.com>
In-Reply-To: <20120404133705.GB12676@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Identified-User: {1390:box585.bluehost.com:colyli:tao.ma} {sentby:smtp auth 50.1.53.18 authed with tm@tao.ma}
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/04/2012 09:37 PM, Vivek Goyal wrote:
> On Wed, Apr 04, 2012 at 05:35:49AM -0700, Shaohua Li wrote:
> 
> [..]
>>>> How iops_weight and switching different than CFQ group scheduling logic?
>>>> I think shaohua was talking of using similar logic. What would you do
>>>> fundamentally different so that without idling you will get service
>>>> differentiation?
>>> I am thinking of differentiate different groups with iops, so if there
>>> are 3 groups(the weight are 100, 200, 300) we can let them submit 1 io,
>>> 2 io and 3 io in a round-robin way. With a intel ssd, every io can be
>>> finished within 100us. So the maximum latency for one io is about 600us,
>>> still less than 1ms. But with cfq, if all the cgroups are busy, we have
>>> to switch between these group in ms which means the maximum latency will
>>> be 6ms. It is terrible for some applications since they use ssds now.
>> Yes, with iops based scheduling, we do queue switching for every request.
>> Doing the same thing between groups is quite straightforward. The only issue
>> I found is this will introduce more process context switch, this isn't
>> a big issue
>> for io bound application, but depends. It cuts latency a lot, which I
>> guess is more
>> important for web 2.0 application.
> 
> In iops_mode(), expire each cfqq after dispatch of 1 or bunch of requests
> and you should get the same behavior (with slice_idle=0 and group_idle=0).
> So why write a new scheduler.
really? How could we config cfq to work like this? Or you mean we can
change the code for it?
> 
> Only thing is that with above, current code will provide iops fairness only
> for groups. We should be able to tweak queue scheduling to support iops
> fairness also.
OK, as I have said in another e-mail another my concern is the
complexity. It will make cfq too much complicated. I just checked the
source code of shaohua's original patch, fiops scheduler is only ~700
lines, so with cgroup support added it would be ~1000 lines I guess.
Currently cfq-iosched.c is around ~4000 lines even after Tejun's cleanup
of io context...

Thanks
Tao
> 
> Anyway, we will end up doing that at some point of time. Supporting two
> scheduling algorihtms for queue and groups is not sustainable. There are
> already calls to make CFQ hierarchical and in that case both queue and
> groups need to be on a single service tree and that means need to follow
> same algorithm for scheduling.
> 
> Thanks
> Vivek
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/

