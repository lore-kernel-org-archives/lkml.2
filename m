Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759372Ab0GPWWs (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Jul 2010 18:22:48 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:55758 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751400Ab0GPWWr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Jul 2010 18:22:47 -0400
MIME-Version: 1.0
In-Reply-To: <AANLkTineI34tKDMPYN4SPY0W432cv8ZPc55IEW5hwmed@mail.gmail.com>
References: <AANLkTineI34tKDMPYN4SPY0W432cv8ZPc55IEW5hwmed@mail.gmail.com>
Date: Fri, 16 Jul 2010 15:22:13 -0700
Message-ID: <AANLkTikwWezvqiW-ts__stLfofKbaqG8CSzOYvDQuxhu@mail.gmail.com>
Subject: Re: [patch 2/2] x86 NMI-safe INT3 and Page Fault
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Jeffrey Merkey <jeffmerkey@gmail.com>
Cc: linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jul 16, 2010 at 3:02 PM, Jeffrey Merkey <jeffmerkey@gmail.com> wrote:
>
> So Linus, my understanding of Intel's processor design is that the
> processor will NEVER singal a nested NMI until it sees an iret from
> the first NMI exception.

Wrong.

I like x86, but it has warts. The NMI blocking is one of them.

The NMI's will be nested until the _next_ "iret", but it has no
nesting. So if you take a fault during the NMI (debug, page table
fixup, whatever), the iret in the faulthandler will re-enable NMI's
even though we're still busy with the original NMI. There is no
nesting, or any way to say that "this is a NMI-releasing iret". They
could even do it still - make a new "iret that doesn't clear NMI" by
adding a segment override prefix to iret or whatever. But it's not
going to happen, and it's just one of those ugly special cases that
has various historical reasons (recursive faults during NMI sure as
hell didn't make sense back in the real-mode 8086 days).

So we have to handle it in software. Or not ever trap at all inside
the NMI handler.

The original patch - and the patch I detest - is to make the normal
fault paths use a "popf + ret" to emulate iret, but without the NMI
release.

Now, I could live with that if it's the only solution, but it _is_
pretty damn ugly.

If somebody shows that it's actually faster to do "popf + ret" when
retuning to kernel space (a poor mans special-case iret), maybe it
would be worth it, but the really critical code sequence is actually
not "return to kernel space", but the "return to user space" case that
really wants the iret. And I just think it's disgusting to add extra
tests to that path.

The other alternative would be to just make the rule be "NMI can never
take traps". It's possible to do that, but quite frankly, it's a pain.
It's a pain for page faults due to the whole vmalloc thing, and it's a
pain if you ever want to debug an NMI in any way (or put a breakpoint
on anything that is accessed from an NMI, which could potentially be
quite a lot of things).

If it was just the debug issue, I'd say "neener neener, debuggers are
for wimps", but it's clearly not just about debug. It's a whole lot of
other thigs. Random percpu datastructures used for tracing, kernel
pointer verification code, yadda yadda.

                  Linus
