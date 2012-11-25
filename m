Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752887Ab2KYCkt (ORCPT <rfc822;w@1wt.eu>);
	Sat, 24 Nov 2012 21:40:49 -0500
Received: from mail-vc0-f174.google.com ([209.85.220.174]:51910 "EHLO
	mail-vc0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752791Ab2KYCks (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 24 Nov 2012 21:40:48 -0500
MIME-Version: 1.0
Date: Sat, 24 Nov 2012 18:40:46 -0800
Message-ID: <CANN689EzEDuYFdcM3=ir=UZgOhiNeKNpc_ydP8vH00f0nM6PXw@mail.gmail.com>
Subject: [PATCH 0/3] remove kvm's use of augmented rbtree
From: Michel Lespinasse <walken@google.com>
To: Sasha Levin <sasha.levin@oracle.com>
Cc: Pekka Enberg <penberg@kernel.org>, Asias He <asias.hejun@gmail.com>,
        Ingo Molnar <mingo@elte.hu>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Nov 22, 2012 at 9:49 PM, Michel Lespinasse <walken@google.com> wrote:
> On Thu, Nov 22, 2012 at 9:14 AM, Sasha Levin <sasha.levin@oracle.com> wrote:
>> The following patch fixed the problem for me:
>>
>> diff --git a/include/linux/rbtree_augmented.h b/include/linux/rbtree_augmented.h
>> index 214caa3..5cfdca6 100644
>> --- a/include/linux/rbtree_augmented.h
>> +++ b/include/linux/rbtree_augmented.h
>> @@ -47,6 +47,7 @@ rb_insert_augmented(struct rb_node *node, struct rb_root *root,
>>                     const struct rb_augment_callbacks *augment)
>>  {
>>         __rb_insert_augmented(node, root, augment->rotate);
>> +       augment->propagate(node, NULL);
>>  }
>
> This would work, but would slow down all sites which already take care
> of updating the augmented information before calling
> rb_insert_augmented, so please don't do that.
>
> The simplest fix would be to add the propagate call where your
> rb_insert_augmented() call site is; the better fix would be to do the
> update incrementally as you search down the tree for the insertion
> point; and the best fix may be to just avoid duplicating that code and
> use interval_tree.h (if your keys are longs) or
> interval_tree_generic.h to generate the proper insert / remove
> functions.

So I had a quick look at linux-next, and my understanding is that the
rbtree-interval API in kvm always stores non-overlapping intervals.
Based on this, the use of augmented rbtrees isn't really justified; it
is just as easy to use a simple rbtree of intervals sorted by the
addresses they cover.

This patchset was generated against the current linux-next. I only
verified that kvm still compiled; obviously this would need more
testing. On the other hand, there are currently some correctness
issues in kvm's implementatin of rbtree intervals, so I think this
simplification should be beneficial.

Michel Lespinasse (3):
  kvm: ensure non-overlapping intervals in rb_int_insert()
  kvm: rb_int_search_single simplification
  kvm: remove max_high field in rb_int_node structure

 tools/kvm/include/kvm/rbtree-interval.h |   13 +++--
 tools/kvm/util/rbtree-interval.c        |   86 ++++---------------------------
 2 files changed, 18 insertions(+), 81 deletions(-)

Sasha, could you please check my logic and apply this to the kvm tree ?

Thanks,

-- 
Michel "Walken" Lespinasse
A program is never fully debugged until the last user dies.
