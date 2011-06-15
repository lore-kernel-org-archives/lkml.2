Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753635Ab1FOSub (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Jun 2011 14:50:31 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:38896 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753573Ab1FOSu0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Jun 2011 14:50:26 -0400
MIME-Version: 1.0
In-Reply-To: <20110615072553.GA26003@elte.hu>
References: <BANLkTikbnsu05+Nae8isATuZ8Fucj14+LQ@mail.gmail.com>
 <BANLkTi=nsCK2bFf2v+PkKj=Opsxseqe9pQ@mail.gmail.com> <BANLkTi=ZETGToRcOHXg5gxAQO3EKN+YyLg@mail.gmail.com>
 <BANLkTi=-xJizWP5H9vNvaJhRN-Vm-ubraA@mail.gmail.com> <4DF7A264.3030901@mit.edu>
 <20110614211613.GB12249@elte.hu> <BANLkTi=W1xFdoSFxnNBGX9gt_pYOH4oF=A@mail.gmail.com>
 <20110614213109.GA9725@elte.hu> <BANLkTimXYaf_14VbB6ex0kG6sPnTUfzu6g@mail.gmail.com>
 <BANLkTi=mwowbSy0M=rjdQW_cKDVf1tBBpA@mail.gmail.com> <20110615072553.GA26003@elte.hu>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Wed, 15 Jun 2011 11:49:30 -0700
Message-ID: <BANLkTinSac=XHNk7jnsYGDo06B=ChXsnAQ@mail.gmail.com>
Subject: Re: [PATCH] x86, vsyscall: Fix build warning in vsyscall_64.c
To: Ingo Molnar <mingo@elte.hu>
Cc: Rakib Mullick <rakib.mullick@gmail.com>, Andrew Lutomirski <luto@mit.edu>,
        hpa@zytor.com, tglx@linutronix.de, x86@kernel.org,
        linux-kernel@vger.kernel.org,
        Andrew Morton <akpm@linux-foundation.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jun 15, 2011 at 12:25 AM, Ingo Molnar <mingo@elte.hu> wrote:
>
> No, that BUG() is a "cannot happen on a correct kernel" so it has no
> ABI impact - but it might trigger if the execution environment is
> violated:

Well, in genreal, I would seriously suggest that people not use
BUG_ON() as liberally as they tend to be used.

There are *very* few reasons to have a BUG_ON(), and they are all "I
cannot possibly continue from this state".

Anything else should have a WARN_ON() or just return an error, or (if
it's a security issue) just kill the process.

Some kernel developers seem to use BUG_ON() as a "I can't see how this
could ever trigger, so let's kill the machine if it does", and that
really is very wrong.

If you are aware that something should never trigger, I'd suggest you
either say "ok, I'm _sure_ that this cannot trigger" and just remove
the BUG_ON(), or you should ask yourself "are we better off killing
the machine than just returning an error".

In this case, for example, if

>  - leave the warning as-is. Whoever builds with CONFIG_BUG=n will
>   have to live with the consequences of the 'impossible' happening
>   and will have to accept the more unpredictable kernel behavior
>   that *will* trigger in various parts of the kernel if BUG() is
>   turned into a NOP. If any of the above 'impossible' failure modes
>   triggers then having more undefined behavior in form of an
>   uninitialized variable will be the least of their worry.

If it's that impossible, I don't see why you have the BUG_ON() in the
first place.

I also don't see why the code isn't just written to be so strict that
the lack of BUG_ON just wouldn't matter. I think that code that
"depends" on a BUG_ON() for correctness (ie assuming that the whole
thing never returns) is buggy by definition. Please just don't write
code like that.

So what's the reason for just not initializing that 'ret' variable to
-EFAULT, and leaving it at that? And/or just removing all the BUG_ON's
entirely? Do they actually _help_ anything?

                               Linus
