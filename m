Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758205Ab0KOTwG (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Nov 2010 14:52:06 -0500
Received: from mx1.redhat.com ([209.132.183.28]:64419 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757936Ab0KOTwE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Nov 2010 14:52:04 -0500
Date: Mon, 15 Nov 2010 20:51:15 +0100
From: Jakub Jelinek <jakub@redhat.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Jim Bos <jim876@xs4all.nl>, Andi Kleen <andi@firstfloor.org>,
        James Cloos <cloos@jhcloos.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Andreas Schwab <schwab@redhat.com>, Michael Matz <matz@suse.de>,
        Dave Korn <dave.korn.cygwin@gmail.com>,
        Richard Guenther <richard.guenther@gmail.com>, gcc@gcc.gnu.org
Subject: Re: gcc 4.5.1 / as 2.20.51.0.11 miscompiling drivers/char/i8k.c ?
Message-ID: <20101115195115.GZ29412@tyan-ft48-01.lab.bos.redhat.com>
Reply-To: Jakub Jelinek <jakub@redhat.com>
References: <20101115100331.GG2583@sunsite.ms.mff.cuni.cz>
 <20101115105446.GD7269@basil.fritz.box>
 <20101115111642.GU29412@tyan-ft48-01.lab.bos.redhat.com>
 <AANLkTi=jwrt2VE5tnL9NR2WhGDnQtv+k6rapnHfsy_aL@mail.gmail.com>
 <4CE17098.8090000@xs4all.nl>
 <AANLkTimEw0U5TqMcmoeShXQ67kqp32hp5fwd2oRQhWo2@mail.gmail.com>
 <4CE17C4B.1070305@xs4all.nl>
 <20101115185848.GI2583@sunsite.ms.mff.cuni.cz>
 <20101115191248.GY29412@tyan-ft48-01.lab.bos.redhat.com>
 <AANLkTikeYLrqXhvTP_uuKnKhy=k7pAQCbONJdKBc838O@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <AANLkTikeYLrqXhvTP_uuKnKhy=k7pAQCbONJdKBc838O@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Nov 15, 2010 at 11:21:30AM -0800, Linus Torvalds wrote:
> On Mon, Nov 15, 2010 at 11:12 AM, Jakub Jelinek <jakub@redhat.com> wrote:
> >
> > Ah, the problem is that memory_identifier_string is only initialized in
> > ipa-reference.c's initialization, so it can be (and is in this case) NULL in
> > ipa-pure-const.c.
> 
> Ok. And I guess you can verify that all versions of gcc do this
> correctly for "asm volatile"?

Yes, reading 4.1/4.2/4.3/4.4/4.5/4.6 code ipa-pure-const.c handles
asm volatile correctly, in each case the function is no longer assumed to be
pure or const in the discovery (of course, user can still say the
function is const or pure). 4.0 and earlier didn't have ipa-pure-const.c.

Using the simplified

extern void abort (void);

__attribute__((noinline)) int
foo (int *p)
{
  int r;
  asm ("movl $6, (%1)\n\txorl %0, %0" : "=r" (r) : "r" (p) : "memory");
  return r;
}

int
main (void)
{
  int p = 8;
  if ((foo (&p) ? : p) != 6)
    abort ();
  return 0;
}

testcase shows that in 4.1/4.2/4.3/4.4 this is miscompiled only when using
-fno-ipa-reference, in 4.5 it is miscompiled always when optimizing
unless -fno-ipa-pure-const (as 4.5 added local-pure-const pass which is run
before ipa-reference) and in 4.6 this has been fixed by Honza when
doing ipa cleanups.

> Because since we'll have to work around this problem in the kernel, I
> suspect the simplest solution is to remove the "+m" that causes
> register pressure problems, and then use "asm volatile" to work around
> the const-function bug.

Yes.

	Jakub
