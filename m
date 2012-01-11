Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753670Ab2AKHO4 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Jan 2012 02:14:56 -0500
Received: from mail-yx0-f174.google.com ([209.85.213.174]:61915 "EHLO
	mail-yx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751552Ab2AKHOz convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Jan 2012 02:14:55 -0500
MIME-Version: 1.0
In-Reply-To: <4F0BABE0.8080107@redhat.com>
References: <20120109181023.7c81d0be@annuminas.surriel.com>
 <4F0B7D1F.7040802@gmail.com> <4F0BABE0.8080107@redhat.com>
From: KOSAKI Motohiro <kosaki.motohiro@gmail.com>
Date: Wed, 11 Jan 2012 02:14:32 -0500
Message-ID: <CAHGf_=qtpA5VTw5W0zaAhB2WCX1+-k59szTnDLnqDJeg+q9Jsw@mail.gmail.com>
Subject: Re: [PATCH -mm] make swapin readahead skip over holes
To: Rik van Riel <riel@redhat.com>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org,
        akpm@linux-foundation.org, Mel Gorman <mel@csn.ul.ie>,
        Johannes Weiner <hannes@cmpxchg.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2012/1/9 Rik van Riel <riel@redhat.com>:
> On 01/09/2012 06:49 PM, KOSAKI Motohiro wrote:
>>
>> (1/9/12 6:10 PM), Rik van Riel wrote:
>>>
>>> Ever since abandoning the virtual scan of processes, for scalability
>>> reasons, swap space has been a little more fragmented than before.
>>> This can lead to the situation where a large memory user is killed,
>>> swap space ends up full of "holes" and swapin readahead is totally
>>> ineffective.
>>>
>>> On my home system, after killing a leaky firefox it took over an
>>> hour to page just under 2GB of memory back in, slowing the virtual
>>> machines down to a crawl.
>>>
>>> This patch makes swapin readahead simply skip over holes, instead
>>> of stopping at them. This allows the system to swap things back in
>>> at rates of several MB/second, instead of a few hundred kB/second.
>>
>>
>> If I understand correctly, this patch have
>>
>> Pros
>> - increase IO throughput
>
>
> By about a factor 3-10 in my tests here.
>
>
>> Cons
>> - increase a risk to pick up unrelated swap entries by swap readahead
>
>
> I do not believe there is a very large risk of this, because
> since we introduced rmap, we have been placing unrelated
> pages right next to each other in swap.
>
> This is also why, since 2.6.28, the kernel places newly swapped
> in pages on the INACTIVE_ANON list, where they should not
> displace the working set.
>
> Another factor is that swapping on modern systems is often a
> temporary thing. During a load spike, things get swapped out
> and run slowly. After the load spike is over, or some memory
> hog process got killed, we want the system to recover to normal
> performance as soon as possible.  This often involves swapping
> everything back into memory.

Hmmm.... OK, I have to agree this.
But if so, to skip hole is not best way. I think we should always makes
one big IO, even if the swap cluster have some holes. one big IO is
usually faster than multiple small IOs. Isn't it?

Also, I doubt current swap_cluster default is best value on nowadays.
