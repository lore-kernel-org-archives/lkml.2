Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752395Ab1L3Jbr (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Dec 2011 04:31:47 -0500
Received: from mail-gx0-f174.google.com ([209.85.161.174]:52933 "EHLO
	mail-gx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751857Ab1L3Jbp convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Dec 2011 04:31:45 -0500
MIME-Version: 1.0
In-Reply-To: <4EFD7AE3.8020403@tao.ma>
References: <1325226961-4271-1-git-send-email-tm@tao.ma> <CAHGf_=qOGy3MQgiFyfeG82+gbDXTBT5KQjgR7JqMfQ7e7RSGpA@mail.gmail.com>
 <4EFD7AE3.8020403@tao.ma>
From: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Date: Fri, 30 Dec 2011 04:31:23 -0500
X-Google-Sender-Auth: xquj-OY5zhzIniqFSvFH3sI4cDo
Message-ID: <CAHGf_=pODc6fLGJAEZWzQtUd6fj6v=fV9n6UTwysqRR1SwY++A@mail.gmail.com>
Subject: Re: [PATCH] mm: do not drain pagevecs for mlock
To: Tao Ma <tm@tao.ma>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org,
        David Rientjes <rientjes@google.com>,
        Minchan Kim <minchan.kim@gmail.com>, Mel Gorman <mel@csn.ul.ie>,
        Johannes Weiner <jweiner@redhat.com>,
        Andrew Morton <akpm@linux-foundation.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2011/12/30 Tao Ma <tm@tao.ma>:
> On 12/30/2011 04:11 PM, KOSAKI Motohiro wrote:
>> 2011/12/30 Tao Ma <tm@tao.ma>:
>>> In our test of mlock, we have found some severe performance regression
>>> in it. Some more investigations show that mlocked is blocked heavily
>>> by lur_add_drain_all which calls schedule_on_each_cpu and flush the work
>>> queue which is very slower if we have several cpus.
>>>
>>> So we have tried 2 ways to solve it:
>>> 1. Add a per cpu counter for all the pagevecs so that we don't schedule
>>>   and flush the lru_drain work if the cpu doesn't have any pagevecs(I
>>>   have finished the codes already).
>>> 2. Remove the lru_add_drain_all.
>>>
>>> The first one has some problems since in our product system, all the cpus
>>> are busy, so I guess there is very little chance for a cpu to have 0 pagevecs
>>> except that you run several consecutive mlocks.
>>>
>>> From the commit log which added this function(8891d6da), it seems that we
>>> don't have to call it. So the 2nd one seems to be both easy and workable and
>>> comes this patch.
>>
>> Could you please show us your system environment and benchmark programs?
>> Usually lru_drain_** is very fast than mlock() body because it makes
>> plenty memset(page).
> The system environment is: 16 core Xeon E5620. 24G memory.
>
> I have attached the program. It is very simple and just uses mlock/munlock.

Because your test program is too artificial. 20sec/100000times =
200usec. And your
program repeat mlock and munlock the exact same address. so, yes, if
lru_add_drain_all() is removed, it become near no-op. but it's
worthless comparision.
none of any practical program does such strange mlock usage.

But, 200usec is much than I measured before. I'll dig it a bit more.
