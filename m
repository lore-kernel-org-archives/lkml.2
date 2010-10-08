Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932903Ab0JHUGh (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Oct 2010 16:06:37 -0400
Received: from smtp-out.google.com ([216.239.44.51]:34745 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932453Ab0JHUGg convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Oct 2010 16:06:36 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=google.com; s=beta;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=gAzqr5LXz6qVLdCqCy4zqE0L2YHmMqbYZVcZtFvhdi+rg+INwllKvKbxqRsuW1z8gP
         ThSjo2JyblbdgAE/fabw==
MIME-Version: 1.0
In-Reply-To: <4CAF1B90.3080703@redhat.com>
References: <1286265215-9025-1-git-send-email-walken@google.com>
	<1286265215-9025-3-git-send-email-walken@google.com>
	<4CAB628D.3030205@redhat.com>
	<AANLkTimdACZ9Xm01DM2+E64+T5XfLffrkFBhf7CJ286p@mail.gmail.com>
	<20101008043956.GA25662@google.com>
	<4CAF1B90.3080703@redhat.com>
Date: Fri, 8 Oct 2010 13:06:18 -0700
Message-ID: <AANLkTinWxTT=+m_fAudc080OUMwacSefnMbSMBFZgPMH@mail.gmail.com>
Subject: Re: [PATCH 2/3] Retry page fault when blocking on disk transfer.
From: Michel Lespinasse <walken@google.com>
To: Rik van Riel <riel@redhat.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>, linux-mm@kvack.org,
        Ying Han <yinghan@google.com>, linux-kernel@vger.kernel.org,
        Andrew Morton <akpm@linux-foundation.org>,
        Nick Piggin <npiggin@kernel.dk>, Peter Zijlstra <peterz@infradead.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Oct 8, 2010 at 6:24 AM, Rik van Riel <riel@redhat.com> wrote:
>> +static inline int lock_page_or_retry(struct page *page, struct mm_struct
>> *mm,
>> +                                    unsigned int flags)
>> +{
>> +       if (trylock_page(page))
>> +               return 1;
>> +       if (!(flags&  FAULT_FLAG_ALLOW_RETRY)) {
>> +               __lock_page(page);
>> +               return 1;
>> +       }
>> +
>> +       up_read(&mm->mmap_sem);
>> +       wait_on_page_locked(page);
>> +       return 0;
>> +}
>
> Wait a moment.  Your other patch 2/3 also has a
> lock_page_or_retry function.  That one is in
> filemap.c and takes slightly different arguments,
> to do essentially the same thing...
>
> +/*
> + * Lock the page, unless this would block and the caller indicated that it
> + * can handle a retry.
> + */
> +static int lock_page_or_retry(struct page *page,
> +                             struct vm_area_struct *vma, struct vm_fault
> *vmf)
> +{
>
> Is there a way the two functions can be merged
> into one?

Yes, this would be easy to do.

The argument against it would be loss of inlining and, in the filemap
version, the need to reference vma and vmf fields to find out the mm
and flags values. We'd like to avoid doing that at least in the fast
path when trylock_page succeeds - though, now that I think about it,
both could be avoided with an inline function in a header returning
trylock_page(page) || _lock_page_or_retry(mm, flags)

Hmmm, this is actually quite similar to how other functions in
pagemap.h / filemap.c are done...
I'll send an updated series using this suggestion.

-- 
Michel "Walken" Lespinasse
A program is never fully debugged until the last user dies.
