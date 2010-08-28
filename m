Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752951Ab0H1VYq (ORCPT <rfc822;w@1wt.eu>);
	Sat, 28 Aug 2010 17:24:46 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:43312 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752776Ab0H1VYo convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 28 Aug 2010 17:24:44 -0400
MIME-Version: 1.0
In-Reply-To: <20100827011436.GB3521@parisc-linux.org>
References: <20100826200318.GA13636@shell> <20100827011436.GB3521@parisc-linux.org>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Sat, 28 Aug 2010 14:23:51 -0700
Message-ID: <AANLkTi=400UGaZZNnNaDM-=gF5VrZ=myROZDgS=UnFV0@mail.gmail.com>
Subject: Re: [PATCH] VFS: Sanity check mount flags passed to change_mnt_propagation()
To: Matthew Wilcox <matthew@wil.cx>
Cc: Valerie Aurora <vaurora@redhat.com>,
        Alexander Viro <viro@zeniv.linux.org.uk>, Karel Zak <kzak@redhat.com>,
        linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Aug 26, 2010 at 6:14 PM, Matthew Wilcox <matthew@wil.cx> wrote:
>
> Hrm.  I think we can do this a bit more pithily.

Well, perhaps, but please NOT the way you suggest.

>
>        /* Only one propagation flag should be set, and no others */
>        if (hweight32(type) != 1

Guys, stop with "teh crazy".

What the f*ck kind of expression is that? We don't do this kind of
crap. Even if it's possible that the compiler might be able to
optimize it, it's just crazy to call "hweight32()" for something like
this.

Please think about what you're really after for a second, and realize
that "one bit set" is just another way of saying "power of two". And
then sit back, relax, and realize that there are way better ways to
say "is this is a power of two" than counting bits, for chrissake!

Just a simple "is_power_of_2()" would work. But for anybody who cares
about how it works, here's how to see if there is just a single bit
set:

   n & (n-1)

and then zero is a special case. _Why_ it works is left as an exercise
for the reader, because it's an interesting trick that becomes obvious
once you start thinking about how borrowing works in binary
arithmetic, and what that "subtract one" does for the borrow case for
a power-of-two value vs a non-power-of-two. You can also think about
why zero is a special case, and why you might sometimes consider it an
acceptable value (it's basically the overflow case for shifting bits).

> Too clever?

Not clever at all, I'm afraid.

                     Linus
