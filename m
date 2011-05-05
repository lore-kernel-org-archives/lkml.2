Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752063Ab1EEBSP (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 May 2011 21:18:15 -0400
Received: from smtp-out.google.com ([74.125.121.67]:61976 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751252Ab1EEBSO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 May 2011 21:18:14 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=google.com; s=beta;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type;
        b=Wz0GcTFH0cs+Pbrd5A/ZDBsPEVjITAtauLQcj236FKPQzKxv7OE0GlCtov0id5bv4F
         vnkFNK+5ze2HSdZQkRuA==
MIME-Version: 1.0
In-Reply-To: <BANLkTim_QtaQLa9GV5hMZyCmW_WAz_Ucvg@mail.gmail.com>
References: <alpine.LSU.2.00.1102232136020.2239@sister.anvils>
	<AANLkTi==MQV=_qq1HaCxGLRu8DdT6FYddqzBkzp1TQs7@mail.gmail.com>
	<AANLkTimv66fV1+JDqSAxRwddvy_kggCuhoJLMTpMTtJM@mail.gmail.com>
	<alpine.LSU.2.00.1103182158200.18771@sister.anvils>
	<BANLkTinoNMudwkcOOgU5d+imPUfZhDbWWQ@mail.gmail.com>
	<AANLkTimfArmB7judMW7Qd4ATtVaR=yTf_-0DBRAfCJ7w@mail.gmail.com>
	<BANLkTi=Limr3NUaG7RLoQLv5TuEDmm7Rqg@mail.gmail.com>
	<BANLkTi=UZcocVk_16MbbV432g9a3nDFauA@mail.gmail.com>
	<BANLkTi=KTdLRC_hRvxfpFoMSbz=vOjpObw@mail.gmail.com>
	<BANLkTindeX9-ECPjgd_V62ZbXCd7iEG9_w@mail.gmail.com>
	<BANLkTikcZK+AQvwe2ED=b0dLZ0hqg0B95w@mail.gmail.com>
	<BANLkTimV1f1YDTWZUU9uvAtCO_fp6EKH9Q@mail.gmail.com>
	<BANLkTi=tavhpytcSV+nKaXJzw19Bo3W9XQ@mail.gmail.com>
	<alpine.LSU.2.00.1104060837590.4909@sister.anvils>
	<BANLkTi=-Zb+vrQuY6J+dAMsmz+cQDD-KUw@mail.gmail.com>
	<BANLkTim0MZfa8vFgHB3W6NsoPHp2jfirrA@mail.gmail.com>
	<BANLkTim-hyXpLj537asC__8exMo3o-WCLA@mail.gmail.com>
	<alpine.LSU.2.00.1104070718120.28555@sister.anvils>
	<BANLkTik_9YW5+64FHrzNy7kPz1FUWrw-rw@mail.gmail.com>
	<BANLkTiniyAN40p0q+2wxWsRZ5PJFn9zE0Q@mail.gmail.com>
	<BANLkTik6U21r91DYiUsz9A0P--=5QcsBrA@mail.gmail.com>
	<BANLkTim6ATGxTiMcfK5-03azgcWuT4wtJA@mail.gmail.com>
	<BANLkTiktvcBWsLKEk5iBYVEbPJS3i+U+hA@mail.gmail.com>
	<BANLkTikdM2kF=qOy4d4bZ_wfb5ykEdkZPQ@mail.gmail.com>
	<BANLkTikZ1szdH5HZdjKEEzG2+1VPusWEeg@mail.gmail.com>
	<BANLkTingV3eiHEco+36YyM4YTDHFHc9_jA@mail.gmail.com>
	<BANLkTi=D+oe_zyxA1Oj5S36F6Tk0J+26iQ@mail.gmail.com>
	<BANLkTim_QtaQLa9GV5hMZyCmW_WAz_Ucvg@mail.gmail.com>
Date: Wed, 4 May 2011 18:18:09 -0700
Message-ID: <BANLkTik-s3Gr6GDMN4L24wX2BK9n3okzQA@mail.gmail.com>
Subject: Re: [PATCH] mm: fix possible cause of a page_mapped BUG
From: Michel Lespinasse <walken@google.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: =?UTF-8?B?Um9iZXJ0IMWad2nEmWNraQ==?= <robert@swiecki.net>,
        Hugh Dickins <hughd@google.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Miklos Szeredi <miklos@szeredi.hu>,
        "Eric W. Biederman" <ebiederm@xmission.com>,
        linux-kernel@vger.kernel.org, linux-mm@kvack.org,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Rik van Riel <riel@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, May 4, 2011 at 5:38 PM, Linus Torvalds
<torvalds@linux-foundation.org> wrote:
>> A more conservative alternative could
>> be to enable the guard page special case under an new GUP flag, but
>> this loses much of the elegance of your original proposal...
>
> How about only doing that only for FOLL_MLOCK?

Sounds reasonable.

> Also, looking at mm/mlock.c, why _do_ we call get_user_pages() even if
> the vma isn't mlocked? That looks bogus. Since we have dropped the
> mm_semaphore, an unlock may have happened, and afaik we should *not*
> try to bring those pages back in at all. There's this whole comment
> about that in the caller ("__mlock_vma_pages_range() double checks the
> vma flags, so that it won't mlock pages if the vma was already
> munlocked."), but despite that it would actually call
> __get_user_pages() even if the VM_LOCKED bit had been cleared (it just
> wouldn't call it with the FOLL_MLOCK flag).

There are two reasons VM_LOCKED might be cleared in
__mlock_vma_pages_range(). It could be that one of the VM_SPECIAL
flags were set on the VMA, in which case mlock() won't set VM_LOCKED
but it still must make the pages present. Or, there is an munlock()
executing concurrently with mlock() - in that case, the conservative
thing to do is to give the same results as if the mlock() had
completed before the munlock(). That is, the mlock() would have broken
COW / made the pages present and the munlock() would have cleared the
VM_LOCKED and PageMlocked flags.

> UNTESTED! And maybe there was some really subtle reason to still call
> __get_user_pages() without that FOLL_MLOCK thing that I'm missing.

I think we want the mm/memory.c part of this proposal without the
mm/mlock.c part.

-- 
Michel "Walken" Lespinasse
A program is never fully debugged until the last user dies.
