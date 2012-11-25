Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753566Ab2KYWOo (ORCPT <rfc822;w@1wt.eu>);
	Sun, 25 Nov 2012 17:14:44 -0500
Received: from mail-ie0-f174.google.com ([209.85.223.174]:53091 "EHLO
	mail-ie0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753490Ab2KYWOm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 25 Nov 2012 17:14:42 -0500
MIME-Version: 1.0
In-Reply-To: <CANN689EzEDuYFdcM3=ir=UZgOhiNeKNpc_ydP8vH00f0nM6PXw@mail.gmail.com>
References: <CANN689EzEDuYFdcM3=ir=UZgOhiNeKNpc_ydP8vH00f0nM6PXw@mail.gmail.com>
From: Sasha Levin <levinsasha928@gmail.com>
Date: Sun, 25 Nov 2012 17:14:22 -0500
Message-ID: <CA+1xoqfu=hw--46Ae+VrP8Xt7Rdozv5TtPvGvhcJr94VVmJQ_A@mail.gmail.com>
Subject: Re: [PATCH 0/3] remove kvm's use of augmented rbtree
To: Michel Lespinasse <walken@google.com>
Cc: Sasha Levin <sasha.levin@oracle.com>, Pekka Enberg <penberg@kernel.org>,
        Asias He <asias.hejun@gmail.com>, Ingo Molnar <mingo@elte.hu>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Nov 24, 2012 at 9:40 PM, Michel Lespinasse <walken@google.com> wrote:
> On Thu, Nov 22, 2012 at 9:49 PM, Michel Lespinasse <walken@google.com> wrote:
>> On Thu, Nov 22, 2012 at 9:14 AM, Sasha Levin <sasha.levin@oracle.com> wrote:
>>> The following patch fixed the problem for me:
>>>
>>> diff --git a/include/linux/rbtree_augmented.h b/include/linux/rbtree_augmented.h
>>> index 214caa3..5cfdca6 100644
>>> --- a/include/linux/rbtree_augmented.h
>>> +++ b/include/linux/rbtree_augmented.h
>>> @@ -47,6 +47,7 @@ rb_insert_augmented(struct rb_node *node, struct rb_root *root,
>>>                     const struct rb_augment_callbacks *augment)
>>>  {
>>>         __rb_insert_augmented(node, root, augment->rotate);
>>> +       augment->propagate(node, NULL);
>>>  }
>>
>> This would work, but would slow down all sites which already take care
>> of updating the augmented information before calling
>> rb_insert_augmented, so please don't do that.
>>
>> The simplest fix would be to add the propagate call where your
>> rb_insert_augmented() call site is; the better fix would be to do the
>> update incrementally as you search down the tree for the insertion
>> point; and the best fix may be to just avoid duplicating that code and
>> use interval_tree.h (if your keys are longs) or
>> interval_tree_generic.h to generate the proper insert / remove
>> functions.
>
> So I had a quick look at linux-next, and my understanding is that the
> rbtree-interval API in kvm always stores non-overlapping intervals.
> Based on this, the use of augmented rbtrees isn't really justified; it
> is just as easy to use a simple rbtree of intervals sorted by the
> addresses they cover.
>
> This patchset was generated against the current linux-next. I only
> verified that kvm still compiled; obviously this would need more
> testing. On the other hand, there are currently some correctness
> issues in kvm's implementatin of rbtree intervals, so I think this
> simplification should be beneficial.
>
> Michel Lespinasse (3):
>   kvm: ensure non-overlapping intervals in rb_int_insert()
>   kvm: rb_int_search_single simplification
>   kvm: remove max_high field in rb_int_node structure
>
>  tools/kvm/include/kvm/rbtree-interval.h |   13 +++--
>  tools/kvm/util/rbtree-interval.c        |   86 ++++---------------------------
>  2 files changed, 18 insertions(+), 81 deletions(-)
>
> Sasha, could you please check my logic and apply this to the kvm tree ?

When I've initially added the interval tree I figured we might need to
allow overlapping for future arches which might need it. Since we now
have extra 2 arches I guess we don't really need it. So I guess we're
fine with removing it.

Pekka?


Thanks,
Sasha
