Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754763Ab2FZJLf (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Jun 2012 05:11:35 -0400
Received: from mx2.parallels.com ([64.131.90.16]:48320 "EHLO mx2.parallels.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752928Ab2FZJLe (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Jun 2012 05:11:34 -0400
Message-ID: <4FE97C20.8010500@parallels.com>
Date: Tue, 26 Jun 2012 13:08:48 +0400
From: Glauber Costa <glommer@parallels.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:13.0) Gecko/20120605 Thunderbird/13.0
MIME-Version: 1.0
To: David Rientjes <rientjes@google.com>
CC: <cgroups@vger.kernel.org>, <linux-mm@kvack.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        <linux-kernel@vger.kernel.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Pekka Enberg <penberg@kernel.org>, Michal Hocko <mhocko@suse.cz>,
        Johannes Weiner <hannes@cmpxchg.org>, Christoph Lameter <cl@linux.com>,
        <devel@openvz.org>, <kamezawa.hiroyu@jp.fujitsu.com>,
        Tejun Heo <tj@kernel.org>, Suleiman Souhlal <suleiman@google.com>
Subject: Re: [PATCH 02/11] memcg: Reclaim when more than one page needed.
References: <1340633728-12785-1-git-send-email-glommer@parallels.com> <1340633728-12785-3-git-send-email-glommer@parallels.com> <alpine.DEB.2.00.1206252106430.26640@chino.kir.corp.google.com> <4FE960D6.4040409@parallels.com> <alpine.DEB.2.00.1206260146010.16020@chino.kir.corp.google.com>
In-Reply-To: <alpine.DEB.2.00.1206260146010.16020@chino.kir.corp.google.com>
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/26/2012 12:54 PM, David Rientjes wrote:
> On Tue, 26 Jun 2012, Glauber Costa wrote:
>
>>>> + * retries
>>>> + */
>>>> +#define NR_PAGES_TO_RETRY 2
>>>> +
>>>
>>> Should be 1 << PAGE_ALLOC_COSTLY_ORDER?  Where does this number come from?
>>> The changelog doesn't specify.
>>
>> Hocko complained about that, and I changed. Where the number comes from, is
>> stated in the comments: it is a number small enough to have high changes of
>> had been freed by the previous reclaim, and yet around the number of pages of
>> a kernel allocation.
>>
>
> PAGE_ALLOC_COSTLY_ORDER _is_ the threshold used to determine where reclaim
> and compaction is deemed to be too costly to continuously retry, I'm not
> sure why this is any different?
>
> And this is certainly not "around the number of pages of a kernel
> allocation", that depends very heavily on the slab allocator being used;
> slub very often uses order-2 and order-3 page allocations as the default
> settings (it is capped at, you guessed it, PAGE_ALLOC_COSTLY_ORDER
> internally by default) and can be significantly increased on the command
> line.

I am obviously okay with either.

Maybe Michal can comment on this?

>> Of course there are allocations for nr_pages > 2. But 2 will already service
>> the stack most of the time, and most of the slab caches.
>>
>
> Nope, have you checked the output of /sys/kernel/slab/.../order when
> running slub?  On my workstation 127 out of 316 caches have order-2 or
> higher by default.
>

Well, this is still on the side of my argument, since this is still a 
majority of them being low ordered. The code here does not necessarily 
have to retry - if I understand it correctly - we just retry for very 
small allocations because that is where our likelihood of succeeding is.

