Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755304Ab2DCR0L (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Apr 2012 13:26:11 -0400
Received: from oproxy4-pub.bluehost.com ([69.89.21.11]:50843 "HELO
	oproxy4-pub.bluehost.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1754281Ab2DCR0J (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Apr 2012 13:26:09 -0400
Message-ID: <4F7B32AE.7050900@tao.ma>
Date: Wed, 04 Apr 2012 01:26:06 +0800
From: Tao Ma <tm@tao.ma>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.28) Gecko/20120313 Thunderbird/3.1.20
MIME-Version: 1.0
To: Vivek Goyal <vgoyal@redhat.com>
CC: Tejun Heo <tj@kernel.org>, axboe@kernel.dk, ctalbott@google.com,
        rni@google.com, linux-kernel@vger.kernel.org, cgroups@vger.kernel.org,
        containers@lists.linux-foundation.org, Shaohua Li <shli@kernel.org>
Subject: Re: IOPS based scheduler (Was: Re: [PATCH 18/21] blkcg: move blkio_group_conf->weight
 to cfq)
References: <1332975091-10950-19-git-send-email-tj@kernel.org> <4F7A1C8B.3010402@tao.ma> <20120402214938.GA19634@dhcp-172-17-108-109.mtv.corp.google.com> <4F7A2217.2030201@tao.ma> <20120402221702.GA21017@dhcp-172-17-108-109.mtv.corp.google.com> <4F7A261A.9000200@tao.ma> <20120402222504.GA2672@redhat.com> <4F7A2B21.5000907@tao.ma> <20120403153736.GI5913@redhat.com> <4F7B2708.6080504@tao.ma> <20120403164959.GJ5913@redhat.com>
In-Reply-To: <20120403164959.GJ5913@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Identified-User: {1390:box585.bluehost.com:colyli:tao.ma} {sentby:smtp auth 50.1.53.2 authed with tm@tao.ma}
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/04/2012 12:50 AM, Vivek Goyal wrote:
> On Wed, Apr 04, 2012 at 12:36:24AM +0800, Tao Ma wrote:
> 
> [..]
>>> - Can't we just set the slice_idle=0 and "quantum" to some high value
>>>   say "64" or "128" and achieve similar results to iops based scheduler?
>> yes, I should say cfq with slice_idle = 0 works well in most cases. But
>> if it comes to blkcg with ssd, it is really a disaster. You know, cfq
>> has to choose between different cgroups, so even if you choose 1ms as
>> the service time for each cgroup(actually in my test, only >2ms can work
>> reliably). the latency for some requests(which have been sent by the
>> user while not submitting to the driver) is really too much for the
>> application. I don't think there is a way to resolve it in cfq.
> 
> Ok, so now you are saying that CFQ as such is not a problem but blkcg
> logic in CFQ is an issue.
> 
> What's the issue there? I think the issue there also is group idling.
> If you set group_idle=0, that idling will be cut down and switching
> between groups will be fast. That's a different thing that in the
> process you will most likely lose service differentiation also for
> most of the workloads.
No, group_idle=0 doesn't help. We don't have problem with idling, the
disk is busy for all the tasks, we just want it to be proportional and
time endurable.
> 
>>
>>>
>>> In theory, above will cut down on idling and try to provide fairness in
>>> terms of time. I thought fairness in terms of time is most fair. The
>>> most common problem is measurement of time is not attributable to
>>> individual queue in an NCQ hardware. I guess that throws time measurement
>>> of out the window until and unless we have a better algorithm to measure
>>> time in NCQ environment.
>>>
>>> I guess then we can just replace time with number of requests dispatched
>>> from a process queue. Allow it to dispatch requests for some time and
>>> then schedule it out and put it back on service tree and charge it 
>>> according to its weight.
>> As I have said, in this case, the minimal time(1ms) multiple the group
>> number is too much for a ssd.
>>
>> If we can use iops based scheduler, we can use iops_weight for different
>> cgroups and switch cgroup according to this number. So all the
>> applications can have a moderate response time which can be estimated.
> 
> How iops_weight and switching different than CFQ group scheduling logic?
> I think shaohua was talking of using similar logic. What would you do
> fundamentally different so that without idling you will get service 
> differentiation?
I am thinking of differentiate different groups with iops, so if there
are 3 groups(the weight are 100, 200, 300) we can let them submit 1 io,
2 io and 3 io in a round-robin way. With a intel ssd, every io can be
finished within 100us. So the maximum latency for one io is about 600us,
still less than 1ms. But with cfq, if all the cgroups are busy, we have
to switch between these group in ms which means the maximum latency will
be 6ms. It is terrible for some applications since they use ssds now.

> 
> If you explain your logic in detail, it will help.
> 
> BTW, in last mail you mentioned that in iops_mode() we make use of time.
> That's not the case. in iops_mode() we charge group based on number of
> requests dispatched. (slice_dispatch records number of requests dispatched
> from the queue in that slice). So to me counting number of requests
> instead of time will effectively switch CFQ to iops based scheduler, isn't
> it?
yes, iops_mode in cfq is calculated iops, but it is switched according
to the time slice, right? So it can't resolve the problem I mentioned above.

Thanks
Tao
> Thanks
> Vivek
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/

