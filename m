Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752758Ab0JAXGj (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Oct 2010 19:06:39 -0400
Received: from smtp-out.google.com ([74.125.121.35]:44914 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751836Ab0JAXGi convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Oct 2010 19:06:38 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=google.com; s=beta;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=KWgWIFRRx83xkt0on5dcY2+WTVT0M4L8PTdI8jVceFrYAolXZEeftA3BV/SwC9Q9J8
         gFDQgZ/ACVdeBvNeYoaQ==
MIME-Version: 1.0
In-Reply-To: <AANLkTinGgZC7eHW_Q-aR5Vmur4yjv_kKSJ8z3MX60e-r@mail.gmail.com>
References: <1285909484-30958-1-git-send-email-walken@google.com>
	<1285909484-30958-3-git-send-email-walken@google.com>
	<AANLkTinGgZC7eHW_Q-aR5Vmur4yjv_kKSJ8z3MX60e-r@mail.gmail.com>
Date: Fri, 1 Oct 2010 16:06:35 -0700
Message-ID: <AANLkTi=3hscMOo6Ho_RbCT82eUZ_Scz_e_9KGQAdKwAs@mail.gmail.com>
Subject: Re: [PATCH 2/2] Release mmap_sem when page fault blocks on disk transfer.
From: Michel Lespinasse <walken@google.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-mm@kvack.org, Ying Han <yinghan@google.com>,
        linux-kernel@vger.kernel.org,
        Andrew Morton <akpm@linux-foundation.org>,
        Rik van Riel <riel@redhat.com>, Nick Piggin <npiggin@suse.de>,
        Peter Zijlstra <peterz@infradead.org>, Hugh Dickins <hughd@google.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Oct 1, 2010 at 8:31 AM, Linus Torvalds
<torvalds@linux-foundation.org> wrote:
> Also, I think the "RELEASE" naming is too much about the
> implementation, not about the context. I think it would be more
> sensible to call it "ALLOW_RETRY" or "ATOMIC" or something like this,
> and not make it about releasing the page lock so much as about what
> you want to happen.
>
> Because quite frankly, I could imagine other reasons to allow page fault retry.
>
> (Similarly, I would rename VM_FAULT_RELEASED to VM_FAULT_RETRY. Again:
> name things for the _concept_, not for some odd implementation issue)

All right, I changed for your names and I think they do help. There is
still one annoyance though (and this is why I had not made this purely
about retry in the first iteration): the up_read(mmap_sem) and the
wait_on_page_locked(page) still happen within filemap_fault(). I think
ideally we would prefer to move this into do_page_fault so that the
interface could *really* be about retry; however we can't easily do
that because the struct page is not exposed at that level.

>
>> -       if (fault & VM_FAULT_MAJOR) {
>> -               tsk->maj_flt++;
>> -               perf_sw_event(PERF_COUNT_SW_PAGE_FAULTS_MAJ, 1, 0,
>> -                                    regs, address);
>> -       } else {
>> -               tsk->min_flt++;
>> -               perf_sw_event(PERF_COUNT_SW_PAGE_FAULTS_MIN, 1, 0,
>> -                                    regs, address);
>> +       if (release_flag) {     /* Did not go through a retry */
>> +               if (fault & VM_FAULT_MAJOR) {
>
> I really don't know if this is correct. What if you have two major
> faults due to the retry? What if the first one is a minor fault, but
> when we retry it's a major fault because the page got released? The
> nesting of the conditionals doesn't seem to make conceptual sense.
>
> I dunno. I can see what you're doing ("only do statistics for the
> first return"), but at the same time it just feels a bit icky.

In a way filemap_fault() already has that problem - during a minor
fault, the page could go away before we have a chance to lock it, and
the fault would still be counted as minor. So I just took that
property (first find_get_page() determines if we call the fault minor
or major) and extended it into the retry case.

One reasonable alternative, I think, would be to always count the
fault as major if we had to go through the retry path. The main
difference this would make, I think, is if two threads hit the exact
same page before we get a chance to load it from disk - in which case
they would both get counted as major faults, vs the current accounting
that would charge one as major and the other one as minor.

>> -       lock_page(page);
>> +       /* Lock the page. */
>> +       if (!trylock_page(page)) {
>> +               if (!(vmf->flags & FAULT_FLAG_RELEASE))
>> +                       __lock_page(page);
>> +               else {
>> +                       /*
>> +                        * Caller passed FAULT_FLAG_RELEASE flag.
>> +                        * This indicates it has read-acquired mmap_sem,
>> +                        * and requests that it be released if we have to
>> +                        * wait for the page to be transferred from disk.
>> +                        * Caller will then retry starting with the
>> +                        * mmap_sem read-acquire.
>> +                        */
>> +                       up_read(&vma->vm_mm->mmap_sem);
>> +                       wait_on_page_locked(page);
>> +                       page_cache_release(page);
>> +                       return ret | VM_FAULT_RELEASED;
>> +               }
>> +       }
>
> I'd much rather see this abstracted out (preferably together with the
> "did it get truncated" logic) into a small helper function of its own.
> The main reason I say that is because I hate your propensity for
> putting the comments deep inside the code. I think any code that needs
> big comments at a deep indentation is fundamentally flawed.

To be clear, is it about the helper function or about the comment
location ? I think the code block is actually short and simple, so
maybe if I just moved the comment up to the /* Lock the page */
location it'd also look that way ?

> You had the same thing in the x86 fault path. I really think it's
> wrong. Needing a comment _inside_ a conditional is just nasty. You
> shouldn't explain what just happened, you should explain what is
> _going_ to happen, an why you do a test in the first place.

That's probably an habit I picked up on another project. Thanks for
pointing it out, I'll try to avoid doing this in linux code.

-- 
Michel "Walken" Lespinasse
A program is never fully debugged until the last user dies.
