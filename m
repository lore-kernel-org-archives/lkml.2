Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752688Ab0HRBcY (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Aug 2010 21:32:24 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:39333 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752453Ab0HRBcS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Aug 2010 21:32:18 -0400
MIME-Version: 1.0
In-Reply-To: <20100817.180325.104051399.davem@davemloft.net>
References: <20100817.180325.104051399.davem@davemloft.net>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Tue, 17 Aug 2010 18:31:50 -0700
Message-ID: <AANLkTikQ1dGw0aO10_ZwmVEc-JAVhB==3HS7SrWycE49@mail.gmail.com>
Subject: Re: [GIT] Sparc
To: David Miller <davem@davemloft.net>
Cc: akpm@linux-foundation.org, sparclinux@vger.kernel.org,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Aug 17, 2010 at 6:03 PM, David Miller <davem@davemloft.net> wrote:
>
> Among other things, this fixes the rwsem signedness issue we
> were discussing earlier today.

Your commit message is missing the C rules for hex constants. It says

  "hex constants are unsigned unless explicitly casted or negated."

and that's not true.

The rule is that hex constants are signed _except_ if they don't fit
in a signed.

So with a 32-bit 'int', 0x123 is signed, but 0x80000000 is unsigned.

So the reason (-0x00010000) is signed is _not_ because of the
negation, but simply because 0x00010000 fits in a signed int. So for
example, the constant (-0xf0000000) is still unsigned, despite the
negation.

So to make something signed, you need to either cast it, make sure it
fits in a signed int, use the 'l' postfix (which also makes it long,
of course), or use a decimal representation. So

   #define X 4294901760

is a _signed_ constant with same value as 0xffff0000 (but it's "signed
long", because the rules for decimal numbers and hex numbers are
different: a decimal number is always signed and because it doesn't
fit in 'int' it will extend to 'long'. A hex number is first done as
unsigned, and only extended to long if it doesn't fit in that.

To make things _really_ confused, sometimes the types actually depend
on whether you're compiling with the c90 standards. A decimal constant
is _always_ signed in traditional C - it goes from 'int' to 'long',
and stays 'long' even if it doesn't fit (ie with a 32-bit long,
2147483648 is of type 'long' even though it doesn't fit in 'long' and
is negative). But in c90, it does from 'int' to 'long' to 'unsigned
long'.

Or maybe it was the other way around. I forget.

Confused yet?

The basic rule becomes: never _ever_ overflow 'int' in a constant,
without specifying the exact type you want. That way you avoid all the
subtle cases.

                     Linus
