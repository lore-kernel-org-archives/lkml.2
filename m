Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752688Ab2DEIb3 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Apr 2012 04:31:29 -0400
Received: from mail-bk0-f46.google.com ([209.85.214.46]:35667 "EHLO
	mail-bk0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751255Ab2DEIb0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Apr 2012 04:31:26 -0400
Message-ID: <4F7D5859.5050106@openvz.org>
Date: Thu, 05 Apr 2012 12:31:21 +0400
From: Konstantin Khlebnikov <khlebnikov@openvz.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:10.0.2) Gecko/20120217 Firefox/10.0.2 Iceape/2.7.2
MIME-Version: 1.0
To: Oleg Nesterov <oleg@redhat.com>
CC: "linux-mm@kvack.org" <linux-mm@kvack.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Hugh Dickins <hughd@google.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: [PATCH RFC] mm: account VMA before forced-COW via /proc/pid/mem
References: <20120402153631.5101.44091.stgit@zurg> <20120403143752.GA5150@redhat.com> <4F7C1B67.6030300@openvz.org> <20120404154148.GA7105@redhat.com>
In-Reply-To: <20120404154148.GA7105@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Oleg Nesterov wrote:
> On 04/04, Konstantin Khlebnikov wrote:
>>
>> Oleg Nesterov wrote:
>>> On 04/02, Konstantin Khlebnikov wrote:
>>>>
>>>> Currently kernel does not account read-only private mappings into memory commitment.
>>>> But these mappings can be force-COW-ed in get_user_pages().
>>>
>>> Heh. tail -n3 Documentation/vm/overcommit-accounting
>>> may be you should update it then.
>>
>> I just wonder how fragile this accounting...
>
> I meant, this patch could also remove this "TODO" from the docs.

Actually I dug into this code for killing VM_ACCOUNT vma flag.
Currently we cannot do this only because asymmetry in mprotect_fixup():
it account vma on read-only -> writable conversion, but keep on backward operation.
Probably we can kill this asymmetry, and after that we can recognize accountable vma
by its others flags state, so we don't need special VM_ACCOUNT for this.

>
>>> Can't really comment the patch, this is not my area. Still,
>>>
>>>> +	down_write(&mm->mmap_sem);
>>>> +	*pvma = vma = find_vma(mm, addr);
>>>> +	if (vma&&   vma->vm_start<= addr) {
>>>> +		ret = vma->vm_end - addr;
>>>> +		if ((vma->vm_flags&   (VM_ACCOUNT | VM_NORESERVE | VM_SHARED |
>>>> +				VM_HUGETLB | VM_MAYWRITE)) == VM_MAYWRITE) {
>>>> +			if (!security_vm_enough_memory_mm(mm, vma_pages(vma)))
>>>
>>> Oooooh, the whole vma. Say, gdb installs the single breakpoint into
>>> the huge .text mapping...
>>
>> We cannot split vma right there, this will be really weird. =)
>
> Sure, I understand why you did it this way.
>
>>> I am not sure, but probably you want to check at least VM_IO/PFNMAP
>>> as well. We do not want to charge this memory and retry with FOLL_FORCE
>>> before vm_ops->access(). Say, /dev/mem
>>
>> No, VM_IO/PFNMAP aren't affect accounting, there is VM_NORESERVE for this.
>
> You misunderstood. Again, I can be wrong, but.
>
> Suppose the task mmmaps /dev/mem (for example). This vma doesn't have
> VM_NORESERVE (but it has VM_IO).
>
> gup() fails correctly with or without FOLL_FORCE, we should fallback
> to vma_ops->access().

Yes, seems so. Maybe we should use ->access() before get_user_pages().

>
> However. With your patch __access_remote_vm() tries gup() without
> FOLL_FORCE first and wrongly assumes that it fails because it neeeds
> FOLL_FORCE and we are going to force-cow.
>
> So __account_vma() adds VM_ACCOUNT before (unnecessary) retry, and
> this is unnecessary too and wrong.
>
>>> Hmm. OTOH, if I am right then mprotect_fixup() should be fixed??
>>
>> mprotect_fixup() does not account area if it already accounted, so all ok.
>
> No, I meant another thing. But yes, I think I was wrong, mprotect_fixup()
> is fine.
>
>>> We drop ->mmap_sem... Say, the task does mremap() in between and
>>> len == 2 * PAGE_SIZE. Then, for example, copy_to_user_page() can
>>> write to the same page twice. Perhaps not a problem in practice,
>>> I dunno.
>>
>> I have an old unfinished patch which implements upgrade_read() for rw-semaphore =)
>
> Interesting ;)

Yeah, after upgrade_read() we cannot remove vmas, but we can add new and change existing.

>
