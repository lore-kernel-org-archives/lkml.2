Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753591Ab0HWRfW (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Aug 2010 13:35:22 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:41484 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751107Ab0HWRfU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Aug 2010 13:35:20 -0400
MIME-Version: 1.0
In-Reply-To: <19570.44367.719276.128881@chiark.greenend.org.uk>
References: <AANLkTimuP9cFvd4pfqy6=vixSMdagrSEv1-VLNAEuWgr@mail.gmail.com>
 <1282391770.29609.1223.camel@localhost.localdomain> <AANLkTimYnfewBCDNYXZHxbcX=TRE__Cu07_FFK_kAK2h@mail.gmail.com>
 <1282460275.11348.865.camel@localhost.localdomain> <1282462386.11348.871.camel@localhost.localdomain>
 <1282470917.11348.891.camel@localhost.localdomain> <20100822172548.GB8957@suse.de>
 <AANLkTi=wWcAg8MdWy4O-0au3m6mH+9xWDOKVCJ_x5G_v@mail.gmail.com>
 <19570.38608.79434.179797@chiark.greenend.org.uk> <1282580751.2605.1997.camel@laptop>
 <19570.44367.719276.128881@chiark.greenend.org.uk>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Mon, 23 Aug 2010 10:34:12 -0700
Message-ID: <AANLkTi=+O8wKZV6XT5wGJbfZdgC9kxTxvtEZMD+M+pZn@mail.gmail.com>
Subject: Re: [RFC] mlock/stack guard interaction fixup
To: Ian Jackson <ijackson@chiark.greenend.org.uk>
Cc: Peter Zijlstra <peterz@infradead.org>, Greg KH <gregkh@suse.de>,
        Ian Campbell <ijc@hellion.org.uk>, linux-kernel@vger.kernel.org,
        stable@kernel.org, stable-review@kernel.org, akpm@linux-foundation.org,
        alan@lxorguk.ukuu.org.uk, Jeremy Fitzhardinge <jeremy@goop.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Aug 23, 2010 at 10:18 AM, Ian Jackson
<ijackson@chiark.greenend.org.uk> wrote:
>
> But you seem, like me, to be disagreeing with Linus's assertion that
> calling mlock() on the stack is something no sane programs does ?

Note: I don't think it's generally sane to mlock() a _part_ of the stack.

I think it's entirely sane to lock the whole stack (and that includes
expanding it to some expected maximum value). That makes sense as a
"we cannot afford to run out of memory" or "we must not allow the
pages to hit disk" kind of protection.

However, using mlock on part of the stack is dubious. It's also
dubious as a way to pin particular pages in the page tables, because
it's not necessarily something that the semantics guarantee
(historically mlock just guarantees that they won't be swapped out,
not that they will necessarily maintain some particular mapping).

There's also a difference between "resident in RAM" and "that physical
page is guaranteed to be mapped at that virtual address".

Quite frankly, I personally believe that people who play games with
mlock are misguided. The _one_ special case is for protecting keys or
private data that you do not want to hit the disk in some unencrypted
mode, and quite frankly, you should strive to handle those way more
specially than just putting them in some random place ("on the stack"
or "in some malloc()'ed area"). The sane model for doing that is
generally to explicitly mmap() and mlock the area, so that you get a
very controlled access pattern, and never have to worry about things
like COW etc.

Because trust me, COW and mlock() is _interesting_. As in "I suspect
lots of systems have bugs", and "the semantics don't really guarantee
that you won't have to wait for somethign to be paged out in order for
the allocation for the COW to be satisfied".

I suspect that if you use mlock for _any_ other reason than protecting
a particular very sensitive piece of information, you should use
mlockall(MCL_FUTURE). IOW, if you use mlock because you have realtime
issues, there is no excuse to ever use anything else, imho. And even
then, I guarantee that things like copy-on-write is going to be
"interesting".

I realize that people hate mlockall() (and particularly MCL_FUTURE),
and yes, it's a bloated thing that you can't reasonably use on a large
process. But dammit, if you have RT issues, you shouldn't _have_ some
big bloated process. You should have a small statically linked server
that is RT, and nothing else.

People who use mlock any other way tend to be the people who can't be
bothered to do it right, so they do some hacky half-way crap.

                      Linus
