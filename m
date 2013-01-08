Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756736Ab3AHQwg (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Jan 2013 11:52:36 -0500
Received: from mail-vb0-f45.google.com ([209.85.212.45]:54812 "EHLO
	mail-vb0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756543Ab3AHQwf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Jan 2013 11:52:35 -0500
MIME-Version: 1.0
In-Reply-To: <20130108163141.GA27555@shutemov.name>
References: <20130105152208.GA3386@redhat.com> <CAJd=RBCb0oheRnVCM4okVKFvKGzuLp9GpZJCkVY3RR-J=XEoBA@mail.gmail.com>
 <alpine.LNX.2.00.1301061037140.28950@eggly.anvils> <CAJd=RBAps4Qk9WLYbQhLkJd8d12NLV0CbjPYC6uqH_-L+Vu0VQ@mail.gmail.com>
 <CA+55aFyYAf6ztDLsxWFD+6jb++y0YNjso-9j+83Mm+3uQ=8PdA@mail.gmail.com>
 <CAJd=RBDTvCcYV8qAd-++_DOyDSypQD4Dvt216pG9nTQnWA2uCA@mail.gmail.com>
 <CA+55aFzfUABPycR82aNQhHNasQkL1kmxLN1rD0DJcByFtead3g@mail.gmail.com> <20130108163141.GA27555@shutemov.name>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Tue, 8 Jan 2013 08:52:14 -0800
X-Google-Sender-Auth: 2o9Xp2m5z4mf2DLkfAFg3lqGosE
Message-ID: <CA+55aFzaTvF7nYxWBT-G_b=xGz+_akRAeJ=U9iHy+Y=ZPo=pbA@mail.gmail.com>
Subject: Re: oops in copy_page_rep()
To: "Kirill A. Shutemov" <kirill@shutemov.name>
Cc: Hillf Danton <dhillf@gmail.com>, Hugh Dickins <hughd@google.com>,
        Dave Jones <davej@redhat.com>,
        Linux Kernel <linux-kernel@vger.kernel.org>,
        Andrea Arcangeli <aarcange@redhat.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Mel Gorman <mgorman@suse.de>, Linux-MM <linux-mm@kvack.org>,
        Rik van Riel <riel@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jan 8, 2013 at 8:31 AM, Kirill A. Shutemov <kirill@shutemov.name> wrote:
>>
>> Heh. I was more thinking about why do_huge_pmd_wp_page() needs it, but
>> do_huge_pmd_numa_page() does not.
>
> It does. The check should be moved up.
>
>> Also, do we actually need it for huge_pmd_set_accessed()? The
>> *placement* of that thing confuses me. And because it confuses me, I'd
>> like to understand it.
>
> We need it for huge_pmd_set_accessed() too.
>
> Looks like a mis-merge. The original patch for huge_pmd_set_accessed() was
> correct: http://lkml.org/lkml/2012/10/25/402

Not a merge error: the pmd_trans_splitting() check was removed by
commit d10e63f29488 ("mm: numa: Create basic numa page hinting
infrastructure").

Now, *why* it was removed, I can't tell. And it's not clear why the
original code just had it in a conditional, while the suggested patch
has that "goto repeat" thing. I suspect re-trying the fault (which I
assume the original code did) is actually better, because that way you
go through all the "should I reschedule as I return through the
exception" stuff. I dunno.

Mel, that original patch came from you , although it was based on
previous work by Peter/Ingo/Andrea. Can you walk us through the
history and thinking about the loss of pmd_trans_splitting(). Was it
purely a mistake? It looks intentional.

               Linus
