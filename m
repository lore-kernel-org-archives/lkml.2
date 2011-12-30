Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752564Ab1L3Jph (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Dec 2011 04:45:37 -0500
Received: from oproxy9.bluehost.com ([69.89.24.6]:60735 "HELO
	oproxy9.bluehost.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1751431Ab1L3Jpe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Dec 2011 04:45:34 -0500
Message-ID: <4EFD8832.6010905@tao.ma>
Date: Fri, 30 Dec 2011 17:45:22 +0800
From: Tao Ma <tm@tao.ma>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.24) Gecko/20111109 Thunderbird/3.1.16
MIME-Version: 1.0
To: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
CC: linux-mm@kvack.org, linux-kernel@vger.kernel.org,
        David Rientjes <rientjes@google.com>,
        Minchan Kim <minchan.kim@gmail.com>, Mel Gorman <mel@csn.ul.ie>,
        Johannes Weiner <jweiner@redhat.com>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH] mm: do not drain pagevecs for mlock
References: <1325226961-4271-1-git-send-email-tm@tao.ma> <CAHGf_=qOGy3MQgiFyfeG82+gbDXTBT5KQjgR7JqMfQ7e7RSGpA@mail.gmail.com> <4EFD7AE3.8020403@tao.ma> <CAHGf_=pODc6fLGJAEZWzQtUd6fj6v=fV9n6UTwysqRR1SwY++A@mail.gmail.com>
In-Reply-To: <CAHGf_=pODc6fLGJAEZWzQtUd6fj6v=fV9n6UTwysqRR1SwY++A@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Identified-User: {1390:box585.bluehost.com:colyli:tao.ma} {sentby:smtp auth 182.92.247.2 authed with tm@tao.ma}
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/30/2011 05:31 PM, KOSAKI Motohiro wrote:
> 2011/12/30 Tao Ma <tm@tao.ma>:
>> On 12/30/2011 04:11 PM, KOSAKI Motohiro wrote:
>>> 2011/12/30 Tao Ma <tm@tao.ma>:
>>>> In our test of mlock, we have found some severe performance regression
>>>> in it. Some more investigations show that mlocked is blocked heavily
>>>> by lur_add_drain_all which calls schedule_on_each_cpu and flush the work
>>>> queue which is very slower if we have several cpus.
>>>>
>>>> So we have tried 2 ways to solve it:
>>>> 1. Add a per cpu counter for all the pagevecs so that we don't schedule
>>>>   and flush the lru_drain work if the cpu doesn't have any pagevecs(I
>>>>   have finished the codes already).
>>>> 2. Remove the lru_add_drain_all.
>>>>
>>>> The first one has some problems since in our product system, all the cpus
>>>> are busy, so I guess there is very little chance for a cpu to have 0 pagevecs
>>>> except that you run several consecutive mlocks.
>>>>
>>>> From the commit log which added this function(8891d6da), it seems that we
>>>> don't have to call it. So the 2nd one seems to be both easy and workable and
>>>> comes this patch.
>>>
>>> Could you please show us your system environment and benchmark programs?
>>> Usually lru_drain_** is very fast than mlock() body because it makes
>>> plenty memset(page).
>> The system environment is: 16 core Xeon E5620. 24G memory.
>>
>> I have attached the program. It is very simple and just uses mlock/munlock.
> 
> Because your test program is too artificial. 20sec/100000times =
> 200usec. And your
> program repeat mlock and munlock the exact same address. so, yes, if
> lru_add_drain_all() is removed, it become near no-op. but it's
> worthless comparision.
> none of any practical program does such strange mlock usage.
yes, I should say it is artificial. But mlock did cause the problem in
our product system and perf shows that the mlock uses the system time
much more than others. That's the reason we created this program to test
whether mlock really sucks. And we compared the result with
rhel5(2.6.18) which runs much much faster.

And from the commit log you described, we can remove lru_add_drain_all
safely here, so why add it? At least removing it makes mlock much faster
compared to the vanilla kernel.

> 
> But, 200usec is much than I measured before. I'll dig it a bit more.
Thanks for the help.

Tao
