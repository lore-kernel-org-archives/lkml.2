Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752800Ab2E3TkJ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 May 2012 15:40:09 -0400
Received: from mail-vc0-f174.google.com ([209.85.220.174]:35297 "EHLO
	mail-vc0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752429Ab2E3TkG convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 May 2012 15:40:06 -0400
MIME-Version: 1.0
In-Reply-To: <alpine.DEB.2.00.1205301414020.31768@router.home>
References: <1338368529-21784-1-git-send-email-kosaki.motohiro@gmail.com>
 <1338368529-21784-2-git-send-email-kosaki.motohiro@gmail.com> <alpine.DEB.2.00.1205301414020.31768@router.home>
From: KOSAKI Motohiro <kosaki.motohiro@gmail.com>
Date: Wed, 30 May 2012 15:39:44 -0400
Message-ID: <CAHGf_=oLsK2bk_ym6EZfFD=uRpr33CL+1=nWmf4hrnCxUOFisQ@mail.gmail.com>
Subject: Re: [PATCH 1/6] Revert "mm: mempolicy: Let vma_merge and vma_split
 handle vma->vm_policy linkages"
To: Christoph Lameter <cl@linux.com>
Cc: linux-kernel@vger.kernel.org, linux-mm@kvack.org,
        Andrew Morton <akpm@google.com>, Dave Jones <davej@redhat.com>,
        Mel Gorman <mgorman@suse.de>,
        Linus Torvalds <torvalds@linux-foundation.org>, stable@vger.kernel.org,
        hughd@google.com, Andrew Morton <akpm@linux-foundation.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, May 30, 2012 at 3:17 PM, Christoph Lameter <cl@linux.com> wrote:
> On Wed, 30 May 2012, kosaki.motohiro@gmail.com wrote:
>
>> From: KOSAKI Motohiro <kosaki.motohiro@gmail.com>
>>
>> commit 05f144a0d5 removed vma->vm_policy updates code and it is a purpose of
>> mbind_range(). Now, mbind_range() is virtually no-op. no-op function don't
>> makes any bugs, I agree. but maybe it is not right fix.
>
> I dont really understand the changelog. But to restore the policy_vma() is
> the right thing to do since there are potential multiple use cases where
> we want to apply a policy to a vma.
>
> Proposed new changelog:
>
> Commit 05f144a0d5 folded policy_vma() into mbind_range(). There are
> other use cases of policy_vma(*) though and so revert a piece of
> that commit in order to have a policy_vma() function again.
>
>> @@ -655,23 +676,9 @@ static int mbind_range(struct mm_struct *mm, unsigned long start,
>>                       if (err)
>>                               goto out;
>>               }
>> -
>> -             /*
>> -              * Apply policy to a single VMA. The reference counting of
>> -              * policy for vma_policy linkages has already been handled by
>> -              * vma_merge and split_vma as necessary. If this is a shared
>> -              * policy then ->set_policy will increment the reference count
>> -              * for an sp node.
>> -              */
>
> You are dropping the nice comments by Mel that explain the refcounting.

Because this is not strictly correct. 1) vma_merge() and split_vma() don't
care mempolicy refcount. They only dup and drop it. 2) This mpol_get() is
for vma attaching. This function don't need to care sp_node internal.
