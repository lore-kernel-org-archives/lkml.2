Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932677Ab0JAPcE (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Oct 2010 11:32:04 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:51286 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932400Ab0JAPcC convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Oct 2010 11:32:02 -0400
MIME-Version: 1.0
In-Reply-To: <1285909484-30958-3-git-send-email-walken@google.com>
References: <1285909484-30958-1-git-send-email-walken@google.com> <1285909484-30958-3-git-send-email-walken@google.com>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Fri, 1 Oct 2010 08:31:01 -0700
Message-ID: <AANLkTinGgZC7eHW_Q-aR5Vmur4yjv_kKSJ8z3MX60e-r@mail.gmail.com>
Subject: Re: [PATCH 2/2] Release mmap_sem when page fault blocks on disk transfer.
To: Michel Lespinasse <walken@google.com>
Cc: linux-mm@kvack.org, Ying Han <yinghan@google.com>,
        linux-kernel@vger.kernel.org,
        Andrew Morton <akpm@linux-foundation.org>,
        Rik van Riel <riel@redhat.com>, Nick Piggin <npiggin@suse.de>,
        Peter Zijlstra <peterz@infradead.org>, Hugh Dickins <hughd@google.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I have nothing against the 1/2 patch, it seems nice regardless.

This one is really messy, though. I think you're making the code much
less readable (and it's not wonderful to start with). That's
unacceptable.

On Thu, Sep 30, 2010 at 10:04 PM, Michel Lespinasse <walken@google.com> wrote:
>        int fault;
> +       unsigned int release_flag = FAULT_FLAG_RELEASE;

Try this with just "flag", and make it look something like

   unsigned int flag;

   flag = FAULT_FLAG_RELEASE | (write ? FAULT_FLAG_WRITE : 0);

and just keep the whole mm_handle_fault() flags value in there. That
avoids one ugly/complex line, and makes it much easier to add other
flags if we ever do.

Also, I think the "RELEASE" naming is too much about the
implementation, not about the context. I think it would be more
sensible to call it "ALLOW_RETRY" or "ATOMIC" or something like this,
and not make it about releasing the page lock so much as about what
you want to happen.

Because quite frankly, I could imagine other reasons to allow page fault retry.

(Similarly, I would rename VM_FAULT_RELEASED to VM_FAULT_RETRY. Again:
name things for the _concept_, not for some odd implementation issue)

> -       if (fault & VM_FAULT_MAJOR) {
> -               tsk->maj_flt++;
> -               perf_sw_event(PERF_COUNT_SW_PAGE_FAULTS_MAJ, 1, 0,
> -                                    regs, address);
> -       } else {
> -               tsk->min_flt++;
> -               perf_sw_event(PERF_COUNT_SW_PAGE_FAULTS_MIN, 1, 0,
> -                                    regs, address);
> +       if (release_flag) {     /* Did not go through a retry */
> +               if (fault & VM_FAULT_MAJOR) {

I really don't know if this is correct. What if you have two major
faults due to the retry? What if the first one is a minor fault, but
when we retry it's a major fault because the page got released? The
nesting of the conditionals doesn't seem to make conceptual sense.

I dunno. I can see what you're doing ("only do statistics for the
first return"), but at the same time it just feels a bit icky.

> -       lock_page(page);
> +       /* Lock the page. */
> +       if (!trylock_page(page)) {
> +               if (!(vmf->flags & FAULT_FLAG_RELEASE))
> +                       __lock_page(page);
> +               else {
> +                       /*
> +                        * Caller passed FAULT_FLAG_RELEASE flag.
> +                        * This indicates it has read-acquired mmap_sem,
> +                        * and requests that it be released if we have to
> +                        * wait for the page to be transferred from disk.
> +                        * Caller will then retry starting with the
> +                        * mmap_sem read-acquire.
> +                        */
> +                       up_read(&vma->vm_mm->mmap_sem);
> +                       wait_on_page_locked(page);
> +                       page_cache_release(page);
> +                       return ret | VM_FAULT_RELEASED;
> +               }
> +       }

I'd much rather see this abstracted out (preferably together with the
"did it get truncated" logic) into a small helper function of its own.
The main reason I say that is because I hate your propensity for
putting the comments deep inside the code. I think any code that needs
big comments at a deep indentation is fundamentally flawed.

You had the same thing in the x86 fault path. I really think it's
wrong. Needing a comment _inside_ a conditional is just nasty. You
shouldn't explain what just happened, you should explain what is
_going_ to happen, an why you do a test in the first place.

But on the whole I think that if the implementation didn't raise my
hackles so badly, I think the concept looks fine.

                                         Linus
