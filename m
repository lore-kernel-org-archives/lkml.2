Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757989Ab2IKCut (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Sep 2012 22:50:49 -0400
Received: from e28smtp02.in.ibm.com ([122.248.162.2]:37063 "EHLO
	e28smtp02.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754850Ab2IKCur (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Sep 2012 22:50:47 -0400
Message-ID: <504EA6FE.7070405@linux.vnet.ibm.com>
Date: Tue, 11 Sep 2012 10:50:38 +0800
From: Michael Wang <wangyun@linux.vnet.ibm.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:15.0) Gecko/20120827 Thunderbird/15.0
MIME-Version: 1.0
To: Pekka Enberg <penberg@kernel.org>
CC: paulmck@linux.vnet.ibm.com, Christoph Lameter <cl@linux.com>,
        LKML <linux-kernel@vger.kernel.org>, linux-mm@kvack.org,
        Matt Mackall <mpm@selenic.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>
Subject: Re: [PATCH] slab: fix the DEADLOCK issue on l3 alien lock
References: <5044692D.7080608@linux.vnet.ibm.com> <5046B9EE.7000804@linux.vnet.ibm.com> <0000013996b6f21d-d45be653-3111-4aef-b079-31dc673e6fd8-000000@email.amazonses.com>	<504812E7.3000700@linux.vnet.ibm.com>	<20120906222933.GR2448@linux.vnet.ibm.com> <CAOJsxLFA1sk4KZkRuPL_giktSkFK_g7w-mGi_OEQ9fVXF2UVzw@mail.gmail.com>
In-Reply-To: <CAOJsxLFA1sk4KZkRuPL_giktSkFK_g7w-mGi_OEQ9fVXF2UVzw@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
x-cbid: 12091102-5816-0000-0000-000004661885
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/08/2012 04:39 PM, Pekka Enberg wrote:
> On Fri, Sep 7, 2012 at 1:29 AM, Paul E. McKenney
> <paulmck@linux.vnet.ibm.com> wrote:
>> On Thu, Sep 06, 2012 at 11:05:11AM +0800, Michael Wang wrote:
>>> On 09/05/2012 09:55 PM, Christoph Lameter wrote:
>>>> On Wed, 5 Sep 2012, Michael Wang wrote:
>>>>
>>>>> Since the cachep and cachep->slabp_cache's l3 alien are in the same lock class,
>>>>> fake report generated.
>>>>
>>>> Ahh... That is a key insight into why this occurs.
>>>>
>>>>> This should not happen since we already have init_lock_keys() which will
>>>>> reassign the lock class for both l3 list and l3 alien.
>>>>
>>>> Right. I was wondering why we still get intermitted reports on this.
>>>>
>>>>> This patch will invoke init_lock_keys() after we done enable_cpucache()
>>>>> instead of before to avoid the fake DEADLOCK report.
>>>>
>>>> Acked-by: Christoph Lameter <cl@linux.com>
>>>
>>> Thanks for your review.
>>>
>>> And add Paul to the cc list(my skills on mailing is really poor...).
>>
>> Tested-by: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
> 
> I'd also like to tag this for the stable tree to avoid bogus lockdep
> reports. How far back in release history should we queue this?
Hi, Pekka

Sorry for the delayed reply, I try to find out the reason for commit
30765b92 but not get it yet, so I add Peter to the cc list.

The below patch for release 3.0.0 is the one to cause the bogus report.

commit 30765b92ada267c5395fc788623cb15233276f5c
Author: Peter Zijlstra <peterz@infradead.org>
Date:   Thu Jul 28 23:22:56 2011 +0200

    slab, lockdep: Annotate the locks before using them

    Fernando found we hit the regular OFF_SLAB 'recursion' before we
    annotate the locks, cure this.

    The relevant portion of the stack-trace:

    > [    0.000000]  [<c085e24f>] rt_spin_lock+0x50/0x56
    > [    0.000000]  [<c04fb406>] __cache_free+0x43/0xc3
    > [    0.000000]  [<c04fb23f>] kmem_cache_free+0x6c/0xdc
    > [    0.000000]  [<c04fb2fe>] slab_destroy+0x4f/0x53
    > [    0.000000]  [<c04fb396>] free_block+0x94/0xc1
    > [    0.000000]  [<c04fc551>] do_tune_cpucache+0x10b/0x2bb
    > [    0.000000]  [<c04fc8dc>] enable_cpucache+0x7b/0xa7
    > [    0.000000]  [<c0bd9d3c>] kmem_cache_init_late+0x1f/0x61
    > [    0.000000]  [<c0bba687>] start_kernel+0x24c/0x363
    > [    0.000000]  [<c0bba0ba>] i386_start_kernel+0xa9/0xaf

    Reported-by: Fernando Lopez-Lezcano <nando@ccrma.Stanford.EDU>
    Acked-by: Pekka Enberg <penberg@kernel.org>
    Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
    Link: http://lkml.kernel.org/r/1311888176.2617.379.camel@laptop
    Signed-off-by: Ingo Molnar <mingo@elte.hu>

It moved init_lock_keys() before we build up the alien, so we failed to
reclass it.

Regards,
Michael Wang

> 

