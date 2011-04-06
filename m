Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756365Ab1DFQAT (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Apr 2011 12:00:19 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:53111 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755952Ab1DFQAR convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Apr 2011 12:00:17 -0400
MIME-Version: 1.0
In-Reply-To: <alpine.LSU.2.00.1104060837590.4909@sister.anvils>
References: <alpine.LSU.2.00.1102232136020.2239@sister.anvils>
 <AANLkTi==MQV=_qq1HaCxGLRu8DdT6FYddqzBkzp1TQs7@mail.gmail.com>
 <AANLkTimv66fV1+JDqSAxRwddvy_kggCuhoJLMTpMTtJM@mail.gmail.com>
 <alpine.LSU.2.00.1103182158200.18771@sister.anvils> <BANLkTinoNMudwkcOOgU5d+imPUfZhDbWWQ@mail.gmail.com>
 <AANLkTimfArmB7judMW7Qd4ATtVaR=yTf_-0DBRAfCJ7w@mail.gmail.com>
 <BANLkTi=Limr3NUaG7RLoQLv5TuEDmm7Rqg@mail.gmail.com> <BANLkTi=UZcocVk_16MbbV432g9a3nDFauA@mail.gmail.com>
 <BANLkTi=KTdLRC_hRvxfpFoMSbz=vOjpObw@mail.gmail.com> <BANLkTindeX9-ECPjgd_V62ZbXCd7iEG9_w@mail.gmail.com>
 <BANLkTikcZK+AQvwe2ED=b0dLZ0hqg0B95w@mail.gmail.com> <BANLkTimV1f1YDTWZUU9uvAtCO_fp6EKH9Q@mail.gmail.com>
 <BANLkTi=tavhpytcSV+nKaXJzw19Bo3W9XQ@mail.gmail.com> <alpine.LSU.2.00.1104060837590.4909@sister.anvils>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Wed, 6 Apr 2011 08:59:19 -0700
Message-ID: <BANLkTi=-Zb+vrQuY6J+dAMsmz+cQDD-KUw@mail.gmail.com>
Subject: Re: [PATCH] mm: fix possible cause of a page_mapped BUG
To: Hugh Dickins <hughd@google.com>
Cc: =?UTF-8?B?Um9iZXJ0IMWad2nEmWNraQ==?= <robert@swiecki.net>,
        Andrew Morton <akpm@linux-foundation.org>,
        Miklos Szeredi <miklos@szeredi.hu>,
        Michel Lespinasse <walken@google.com>,
        "Eric W. Biederman" <ebiederm@xmission.com>,
        linux-kernel@vger.kernel.org, linux-mm@kvack.org,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Rik van Riel <riel@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Apr 6, 2011 at 8:43 AM, Hugh Dickins <hughd@google.com> wrote:
>
> I was about to send you my own UNTESTED patch: let me append it anyway,
> I think it is more correct than yours (it's the offset of vm_end we need
> to worry about, and there's the funny old_len,new_len stuff).

Umm. That's what my patch did too. The

   pgoff = (addr - vma->vm_start) >> PAGE_SHIFT;

is the "offset of the pgoff" from the original mapping, then we do

   pgoff += vma->vm_pgoff;

to get the pgoff of the new mapping, and then we do

   if (pgoff + (new_len >> PAGE_SHIFT) < pgoff)

to check that the new mapping is ok.

I think yours is equivalent, just a different (and odd - that
linear_page_index() thing will do lots of unnecessary shifts and
hugepage crap) way of writing it.

> See what you think - sorry, I'm going out now.

I think _yours_ is conceptually buggy, because I think that test for
"vma->vm_file" is wrong.

Yes, new anonymous mappings set vm_pgoff to the virtual address, but
that's not true for mremap() moving them around, afaik.

Admittedly it's really hard to get to the overflow case, because the
address is shifted down, so even if you start out with an anonymous
mmap at a high address (to get a big vm_off), and then move it down
and expand it (to get a big size), I doubt you can possibly overflow.
But I still don't think that the test for vm_file is semantically
sensible, even if it might not _matter_.

But whatever. I suspect both our patches are practically doing the
same thing, and it would be interesting to hear if it actually fixes
the issue. Maybe there is some other way to mess up vm_pgoff that I
can't think of right now.

                                  Linus
