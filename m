Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755825Ab1EIW4f (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 May 2011 18:56:35 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:44769 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755782Ab1EIW4e (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 May 2011 18:56:34 -0400
MIME-Version: 1.0
In-Reply-To: <20110509224511.GC15227@parisc-linux.org>
References: <alpine.DEB.2.00.1105082045250.15552@artax.karlin.mff.cuni.cz>
 <BANLkTikEpaRZK3X4YReeQAwgcv3HAGUwSw@mail.gmail.com> <alpine.DEB.2.00.1105091246550.32299@artax.karlin.mff.cuni.cz>
 <4DC7D37F.9040308@redhat.com> <20110509224511.GC15227@parisc-linux.org>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Mon, 9 May 2011 15:56:11 -0700
Message-ID: <BANLkTikz-sGiy2NdzQMPzCWF64cVF-DZ7w@mail.gmail.com>
Subject: Re: [PATCH] Don't mlock guardpage if the stack is growing up
To: Matthew Wilcox <matthew@wil.cx>
Cc: Zdenek Kabelac <zkabelac@redhat.com>,
        Mikulas Patocka <mikulas@artax.karlin.mff.cuni.cz>,
        linux-kernel@vger.kernel.org, linux-parisc@vger.kernel.org,
        Hugh Dickins <hughd@google.com>, Oleg Nesterov <oleg@redhat.com>,
        agk@redhat.com
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, May 9, 2011 at 3:45 PM, Matthew Wilcox <matthew@wil.cx> wrote:
>
> Sounds to me like glibc should introduce an mlockmost() call that does all
> the work for you ...

That sounds like the worst of all worlds. Nobody will use it, now
there's two places to break, and how do you describe what you don't
want mlocked?

I dunno. There are so few applications that use mlock at *all* that I
wonder if it's even worth worrying about. And this one case we've
hopefully now fixed anyway.

But if people really want to fix mlockall(), I'd suggest some way of
just marking certain mappings as "sparse mappings", and then we can
just teach mlockall to not lock them. And then glibc could just mark
its locale archive that way - and maybe others would mark other
mappings.

We could still make such a "sparse mapping" act as locked for the
actual pages that are mapped into it - so it would have some kind of
real semantics. You could do a "mlockall(..)" on the process, and then
touch the sparse pages you know you want, and they'd be guaranteed to
be mapped after that.

We might even have a "mlockall(MCL_SPARSE)" flag that does that for
everything - basically guarantee that "whatever is mapped in now will
remain mapped in, but I won't bother paging it in just because you ask
me to do a mlockall".

So there are sane semantics for the concept, and it would be easy to
do in the kernel. Whether it's worth doing, I dunno.

                    Linus
