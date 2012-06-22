Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761622Ab2FVIOM (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Jun 2012 04:14:12 -0400
Received: from mail-gh0-f174.google.com ([209.85.160.174]:64367 "EHLO
	mail-gh0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1761609Ab2FVIOI convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Jun 2012 04:14:08 -0400
MIME-Version: 1.0
In-Reply-To: <CAEtiSasQco=GPCwENUY5ND7uvsMrH0a-uTZ6o9GNwmC5dgsPkA@mail.gmail.com>
References: <4FE169B1.7020600@kernel.org> <4FE16E80.9000306@gmail.com>
 <4FE18187.3050103@kernel.org> <4FE23069.5030702@gmail.com>
 <4FE26470.90401@kernel.org> <CAHGf_=pjoiHQ9vxXXe-GtbkYRzhxdDhu3pf6pwDsCe5pBQE8Nw@mail.gmail.com>
 <4FE27F15.8050102@kernel.org> <CAHGf_=pDw4axwG2tQ+B5hPks-sz2S5+G1Kk-=HSDmo=DSXOkEw@mail.gmail.com>
 <4FE2A937.6040701@kernel.org> <4FE2FCFB.4040808@jp.fujitsu.com>
 <4FE3C4E4.2050107@kernel.org> <CAHGf_=oo5GrsbjTRPF2vC-g8R1XVOhjLAMQg6ik49-fr8D=Q+g@mail.gmail.com>
 <CAEtiSasQco=GPCwENUY5ND7uvsMrH0a-uTZ6o9GNwmC5dgsPkA@mail.gmail.com>
From: KOSAKI Motohiro <kosaki.motohiro@gmail.com>
Date: Fri, 22 Jun 2012 04:13:47 -0400
Message-ID: <CAHGf_=rJK_RV2UmaFCTjtd6taKVXZCKYz66TwPfSRCqcUo=PqQ@mail.gmail.com>
Subject: Re: Accounting problem of MIGRATE_ISOLATED freed page
To: Aaditya Kumar <aaditya.kumar.30@gmail.com>
Cc: Minchan Kim <minchan@kernel.org>,
        Kamezawa Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        Mel Gorman <mel@csn.ul.ie>, "linux-mm@kvack.org" <linux-mm@kvack.org>,
        LKML <linux-kernel@vger.kernel.org>, tim.bird@am.sony.com,
        frank.rowand@am.sony.com, takuzo.ohara@ap.sony.com,
        kan.iibuchi@jp.sony.com, aaditya.kumar@ap.sony.com
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jun 22, 2012 at 3:56 AM, Aaditya Kumar
<aaditya.kumar.30@gmail.com> wrote:
> On Fri, Jun 22, 2012 at 12:52 PM, KOSAKI Motohiro
> <kosaki.motohiro@gmail.com> wrote:
>>> Let me summary again.
>>>
>>> The problem:
>>>
>>> when hotplug offlining happens on zone A, it starts to freed page as MIGRATE_ISOLATE type in buddy.
>>> (MIGRATE_ISOLATE is very irony type because it's apparently on buddy but we can't allocate them)
>>> When the memory shortage happens during hotplug offlining, current task starts to reclaim, then wake up kswapd.
>>> Kswapd checks watermark, then go sleep BECAUSE current zone_watermark_ok_safe doesn't consider
>>> MIGRATE_ISOLATE freed page count. Current task continue to reclaim in direct reclaim path without kswapd's help.
>>> The problem is that zone->all_unreclaimable is set by only kswapd so that current task would be looping forever
>>> like below.
>>>
>>> __alloc_pages_slowpath
>>> restart:
>>>        wake_all_kswapd
>>> rebalance:
>>>        __alloc_pages_direct_reclaim
>>>                do_try_to_free_pages
>>>                        if global_reclaim && !all_unreclaimable
>>>                                return 1; /* It means we did did_some_progress */
>>>        skip __alloc_pages_may_oom
>>>        should_alloc_retry
>>>                goto rebalance;
>>>
>>> If we apply KOSAKI's patch[1] which doesn't depends on kswapd about setting zone->all_unreclaimable,
>>> we can solve this problem by killing some task. But it doesn't wake up kswapd, still.
>>> It could be a problem still if other subsystem needs GFP_ATOMIC request.
>>> So kswapd should consider MIGRATE_ISOLATE when it calculate free pages before going sleep.
>>
>> I agree. And I believe we should remove rebalance label and alloc
>> retrying should always wake up kswapd.
>> because wake_all_kswapd is unreliable, it have no guarantee to success
>> to wake up kswapd. then this
>> micro optimization is NOT optimization. Just trouble source. Our
>> memory reclaim logic has a lot of race
>> by design. then any reclaim code shouldn't believe some one else works fine.
>>
>
> I think this is a better approach, since MIGRATE_ISLOATE is really a
> temporary phenomenon, it makes sense to just retry allocation.
> One issue however, with this approach is that it does not exactly work
> for PAGE_ALLOC_COSTLY_ORDER, But well, given the
> frequency of such allocation, I think may be it is an acceptable
> compromise to handle such request by OOM in case of many
> MIGRATE_ISOLATE
> pages present.
>
> what do you think ?

I think we need both change.
