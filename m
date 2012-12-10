Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752491Ab2LJVuo (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Dec 2012 16:50:44 -0500
Received: from mail-vc0-f174.google.com ([209.85.220.174]:62367 "EHLO
	mail-vc0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752425Ab2LJVuk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Dec 2012 16:50:40 -0500
MIME-Version: 1.0
In-Reply-To: <CA+1xoqdtvq7WQf_1EoGjBo9Rjd1YHS4eSqQX2o-nnYNoMuCzzg@mail.gmail.com>
References: <CANN689EzEDuYFdcM3=ir=UZgOhiNeKNpc_ydP8vH00f0nM6PXw@mail.gmail.com>
	<CA+1xoqfu=hw--46Ae+VrP8Xt7Rdozv5TtPvGvhcJr94VVmJQ_A@mail.gmail.com>
	<CA+1xoqdtvq7WQf_1EoGjBo9Rjd1YHS4eSqQX2o-nnYNoMuCzzg@mail.gmail.com>
Date: Mon, 10 Dec 2012 13:50:39 -0800
Message-ID: <CANN689Gy3nLBasBea-nqkK7zTC4XuhUKH=FmOTcq_pKWPi_xmw@mail.gmail.com>
Subject: Re: [PATCH 0/3] remove kvm's use of augmented rbtree
From: Michel Lespinasse <walken@google.com>
To: Sasha Levin <levinsasha928@gmail.com>,
        Andrew Morton <akpm@linux-foundation.org>
Cc: Sasha Levin <sasha.levin@oracle.com>, Pekka Enberg <penberg@kernel.org>,
        Asias He <asias.hejun@gmail.com>, Ingo Molnar <mingo@elte.hu>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Dec 10, 2012 at 8:22 AM, Sasha Levin <levinsasha928@gmail.com> wrote:
> Ping?

Hey Sasha,

There seems to have been some confusion here. After your last message,
I expected *you* to take the patches and push them towards kvm tree.
But, I guess you were waiting for Pekka's reply first ? Or did you
expect me to go push the patches ?

If it helps, I could push this through Andrew's -mm tree; however I
think it would make the most sense if these could reach linus's tree
through a kvm merge rather than through Andrew's -mm...

> On Sun, Nov 25, 2012 at 5:14 PM, Sasha Levin <levinsasha928@gmail.com> wrote:
>> On Sat, Nov 24, 2012 at 9:40 PM, Michel Lespinasse <walken@google.com> wrote:
>>> On Thu, Nov 22, 2012 at 9:49 PM, Michel Lespinasse <walken@google.com> wrote:
>>>> On Thu, Nov 22, 2012 at 9:14 AM, Sasha Levin <sasha.levin@oracle.com> wrote:
>>>>> The following patch fixed the problem for me:
>>>>>
>>>>> diff --git a/include/linux/rbtree_augmented.h b/include/linux/rbtree_augmented.h
>>>>> index 214caa3..5cfdca6 100644
>>>>> --- a/include/linux/rbtree_augmented.h
>>>>> +++ b/include/linux/rbtree_augmented.h
>>>>> @@ -47,6 +47,7 @@ rb_insert_augmented(struct rb_node *node, struct rb_root *root,
>>>>>                     const struct rb_augment_callbacks *augment)
>>>>>  {
>>>>>         __rb_insert_augmented(node, root, augment->rotate);
>>>>> +       augment->propagate(node, NULL);
>>>>>  }
>>>>
>>>> This would work, but would slow down all sites which already take care
>>>> of updating the augmented information before calling
>>>> rb_insert_augmented, so please don't do that.
>>>>
>>>> The simplest fix would be to add the propagate call where your
>>>> rb_insert_augmented() call site is; the better fix would be to do the
>>>> update incrementally as you search down the tree for the insertion
>>>> point; and the best fix may be to just avoid duplicating that code and
>>>> use interval_tree.h (if your keys are longs) or
>>>> interval_tree_generic.h to generate the proper insert / remove
>>>> functions.
>>>
>>> So I had a quick look at linux-next, and my understanding is that the
>>> rbtree-interval API in kvm always stores non-overlapping intervals.
>>> Based on this, the use of augmented rbtrees isn't really justified; it
>>> is just as easy to use a simple rbtree of intervals sorted by the
>>> addresses they cover.
>>>
>>> This patchset was generated against the current linux-next. I only
>>> verified that kvm still compiled; obviously this would need more
>>> testing. On the other hand, there are currently some correctness
>>> issues in kvm's implementatin of rbtree intervals, so I think this
>>> simplification should be beneficial.
>>>
>>> Michel Lespinasse (3):
>>>   kvm: ensure non-overlapping intervals in rb_int_insert()
>>>   kvm: rb_int_search_single simplification
>>>   kvm: remove max_high field in rb_int_node structure
>>>
>>>  tools/kvm/include/kvm/rbtree-interval.h |   13 +++--
>>>  tools/kvm/util/rbtree-interval.c        |   86 ++++---------------------------
>>>  2 files changed, 18 insertions(+), 81 deletions(-)
>>>
>>> Sasha, could you please check my logic and apply this to the kvm tree ?
>>
>> When I've initially added the interval tree I figured we might need to
>> allow overlapping for future arches which might need it. Since we now
>> have extra 2 arches I guess we don't really need it. So I guess we're
>> fine with removing it.
>>
>> Pekka?
>>
>>
>> Thanks,
>> Sasha



-- 
Michel "Walken" Lespinasse
A program is never fully debugged until the last user dies.
