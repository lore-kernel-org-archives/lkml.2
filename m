Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932218Ab1DAQV0 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Apr 2011 12:21:26 -0400
Received: from mail-ey0-f174.google.com ([209.85.215.174]:35304 "EHLO
	mail-ey0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752839Ab1DAQVZ convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Apr 2011 12:21:25 -0400
MIME-Version: 1.0
In-Reply-To: <AANLkTimfArmB7judMW7Qd4ATtVaR=yTf_-0DBRAfCJ7w@mail.gmail.com>
References: <alpine.LSU.2.00.1102232136020.2239@sister.anvils>
	<AANLkTi==MQV=_qq1HaCxGLRu8DdT6FYddqzBkzp1TQs7@mail.gmail.com>
	<AANLkTimv66fV1+JDqSAxRwddvy_kggCuhoJLMTpMTtJM@mail.gmail.com>
	<alpine.LSU.2.00.1103182158200.18771@sister.anvils>
	<BANLkTinoNMudwkcOOgU5d+imPUfZhDbWWQ@mail.gmail.com>
	<AANLkTimfArmB7judMW7Qd4ATtVaR=yTf_-0DBRAfCJ7w@mail.gmail.com>
Date: Fri, 1 Apr 2011 18:21:23 +0200
Message-ID: <BANLkTim3x=1n+F7yD-euY0=RhmyXViUamg@mail.gmail.com>
Subject: Re: [PATCH] mm: fix possible cause of a page_mapped BUG
From: =?UTF-8?B?Um9iZXJ0IMWad2nEmWNraQ==?= <robert@swiecki.net>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Hugh Dickins <hughd@google.com>, Andrew Morton <akpm@linux-foundation.org>,
        Miklos Szeredi <miklos@szeredi.hu>,
        Michel Lespinasse <walken@google.com>,
        "Eric W. Biederman" <ebiederm@xmission.com>,
        linux-kernel@vger.kernel.org, linux-mm@kvack.org,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Rik van Riel <riel@redhat.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Apr 1, 2011 at 5:44 PM, Linus Torvalds
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

Is it possible to turn it off via config flags? Looking into
arch/x86/include/asm/bug.h it seems it's unconditional (as in "it
always manifests itself somehow") and I have
CONFIG_DEBUG_BUGVERBOSE=y.

This BUG/Oopps was triggered before I applied Hugh's patch on a vanilla kernel.

Anything that could help you debugging this? Uploading kernel image
(unfortunately I've overwritten this one), dumping more kgdb data? I
must admit I'm not up-to-date with current linux kernel debugging
techniques. The kernel config is here:
http://alt.swiecki.net/linux_kernel/ise-test-2.6.38-kernel-config.txt

For now I'll compile with -O0 -fno-inline (are you sure you'd like -Os?)

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
>
>                          Linus
>



-- 
Robert Święcki
