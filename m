Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753785Ab2FLQqP (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Jun 2012 12:46:15 -0400
Received: from mail-gg0-f174.google.com ([209.85.161.174]:57213 "EHLO
	mail-gg0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752838Ab2FLQqN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Jun 2012 12:46:13 -0400
MIME-Version: 1.0
In-Reply-To: <20120612135529.GA20467@suse.de>
References: <1339406250-10169-1-git-send-email-kosaki.motohiro@gmail.com>
 <1339406250-10169-3-git-send-email-kosaki.motohiro@gmail.com> <20120612135529.GA20467@suse.de>
From: KOSAKI Motohiro <kosaki.motohiro@gmail.com>
Date: Tue, 12 Jun 2012 12:45:52 -0400
Message-ID: <CAHGf_=oPRa8X7bfFx1eaFmR-B3=Bp4q66q8Sd-VoUe1iUFCMYQ@mail.gmail.com>
Subject: Re: [PATCH 2/6] mempolicy: remove all mempolicy sharing
To: Mel Gorman <mgorman@suse.de>
Cc: linux-kernel@vger.kernel.org, linux-mm@kvack.org,
        Andrew Morton <akpm@google.com>, Dave Jones <davej@redhat.com>,
        Christoph Lameter <cl@linux.com>, stable@vger.kernel.org,
        Andrew Morton <akpm@linux-foundation.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> Your example is missing some important detail. When I was looking at this
> I thought of the same scenario because initially I thought this might be
> the problem Dave's test case was hitting. Obviously I then proceeded to
> mess up anyway so take this with a grain of salt but why is this particular
> situation not prevented by vma_merge? is_mergeable_vma() should have spotted
> that the vm_files differed and mbind_range() should not have tried
> sharing them.

vma1 and vma2 are never merged. but policy_vma() used mpol_get() instaed
of mpol_dup(). then vma1 and vma2 became to use the same mempolicy.

vma merge/split are completely unrelated. Antually, vma1 and vma2 don't need
to be neighbor vma.  | vma1 | hole | vma2| pattern makes the same scenario.


>> Look at alloc_pages_vma(), it uses get_vma_policy() and mpol_cond_put() pair
>> for maintaining mempolicy refcount. The current rule is, get_vma_policy() does
>> NOT increase a refcount if the policy is not attached shmem vma and mpol_cond_put()
>> DOES decrease a refcount if mpol has MPOL_F_SHARED.
>
> The rules about refcounting are indeed annoying. It would be a lot easier
> to understand if the reference counting was unconditional but then every
> page allocation in a large VMA would also bounce the cacheline storing
> the count which would just generate a new bug later.

Yes. regular task/vma policy shouldn't take refcount in fast path. In the other
hands, shmem policy can't avoid refcount game because we have to avoid a
race that another thread free the policy in same time.


> I suspect these bugs were not noticed because the shmem policies are
> typically large and very long lived without much use of mbind() but
> that's not an excuse.

I agree your suspection. I haven't heared this issue.



>> -/* Apply policy to a single VMA */
>> -static int policy_vma(struct vm_area_struct *vma, struct mempolicy *new)
>> +/*
>> + * Apply policy to a single VMA
>> + * This must be called with the mmap_sem held for writing.
>> + */
>> +static int policy_vma(struct vm_area_struct *vma, struct mempolicy *pol)
>
> If we're going to change this, change the policy_vma() name as well to
> set_vma_policy. We currently have policy_vma() and vma_policy() which mean
> totally different things which is partially why I deleted it entirely the
> first time around. It's a small issue but it might make mempolicy.c 0.0001%
> easier to follow.

100% agree. I'll make simple renaming patch.
