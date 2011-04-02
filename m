Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754909Ab1DBBqS (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Apr 2011 21:46:18 -0400
Received: from smtp-out.google.com ([216.239.44.51]:6696 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751216Ab1DBBqQ convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Apr 2011 21:46:16 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=google.com; s=beta;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=sHHmWJA4qqTls/5UTlMfFRp2dsloGT1UXh+X2tVSHxciS4pEaj6EK6A5uW9MDKPRYB
         hTB/c5QMmvitKCdZaLmw==
MIME-Version: 1.0
In-Reply-To: <AANLkTimfArmB7judMW7Qd4ATtVaR=yTf_-0DBRAfCJ7w@mail.gmail.com>
References: <alpine.LSU.2.00.1102232136020.2239@sister.anvils>
	<AANLkTi==MQV=_qq1HaCxGLRu8DdT6FYddqzBkzp1TQs7@mail.gmail.com>
	<AANLkTimv66fV1+JDqSAxRwddvy_kggCuhoJLMTpMTtJM@mail.gmail.com>
	<alpine.LSU.2.00.1103182158200.18771@sister.anvils>
	<BANLkTinoNMudwkcOOgU5d+imPUfZhDbWWQ@mail.gmail.com>
	<AANLkTimfArmB7judMW7Qd4ATtVaR=yTf_-0DBRAfCJ7w@mail.gmail.com>
Date: Fri, 1 Apr 2011 18:46:12 -0700
Message-ID: <BANLkTi=Limr3NUaG7RLoQLv5TuEDmm7Rqg@mail.gmail.com>
Subject: Re: [PATCH] mm: fix possible cause of a page_mapped BUG
From: Hugh Dickins <hughd@google.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: =?UTF-8?B?Um9iZXJ0IMWad2nEmWNraQ==?= <robert@swiecki.net>,
        Andrew Morton <akpm@linux-foundation.org>,
        Miklos Szeredi <miklos@szeredi.hu>,
        Michel Lespinasse <walken@google.com>,
        "Eric W. Biederman" <ebiederm@xmission.com>,
        linux-kernel@vger.kernel.org, linux-mm@kvack.org,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Rik van Riel <riel@redhat.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Apr 1, 2011 at 8:44 AM, Linus Torvalds
<torvalds@linux-foundation.org> wrote:
> On Fri, Apr 1, 2011 at 7:34 AM, Robert Święcki <robert@swiecki.net> wrote:
>>
>> Hey, I'll apply your patch and check it out. In the meantime I
>> triggered another Oops (NULL-ptr deref via sys_mprotect).
>>
>> The oops is here:
>>
>> http://alt.swiecki.net/linux_kernel/sys_mprotect-2.6.38.txt
>
> That's not a NULL pointer dereference. That's a BUG_ON().
>
> And for some reason you've turned off the BUG_ON() messages, saving
> some tiny amount of memory.
>
> Anyway, it looks like the first BUG_ON() in vma_prio_tree_add(), so it
> would be this one:
>
>        BUG_ON(RADIX_INDEX(vma) != RADIX_INDEX(old));
>
> but it is possible that gcc has shuffled things around (so it _might_
> be the HEAP_INDEX() one). If you had CONFIG_DEBUG_BUGVERBOSE=y, you'd
> get a filename and line number. One reason I hate -O2 in cases like
> this is that the basic block movement makes it way harder to actually
> debug things. I would suggest using -Os too (CONFIG_OPTIMIZE_FOR_SIZE
> or whatever it's called).
>
> Anyway, I do find it worrying. The vma code shouldn't be this fragile.  Hugh?
>
> I do wonder what triggers this. Is it a huge-page vma? We seem to be
> lacking the check to see that mprotect() is on a hugepage boundary -
> and that seems bogus. Or am I missing some check? The new transparent
> hugepage support splits the page, but what if it's a _static_ hugepage
> thing?
>
> But why would that affect the radix_index thing? I have no idea. I'd
> like to blame the anon_vma rewrites last year, but I can't see why
> that should matter either. Again, hugepages had some special rules, I
> think (and that would explain why nobody normal sees this).
>
> Guys, please give this one a look.

I do intend to look, but I think it makes more sense to wait until
Robert has reproduced it (or something like it) with my debugging
patch in.

He's fuzzing, so no reason to get anxious about recent changes, it may
have been lurking there for years.  He did already report a
vma_prio_tree_add() crash, which led me to send him the patch: so the
issue seems to be reproducible, and the patch dumps out the
vma_area_structs involved, which has some hope of telling us more.

Down the years we've had about three earlier reports of crashes there:
so rare we've tended to put them down to bad memory or slab
corruption, but never had anything like a reproducible case to study
until now.

Hugh
