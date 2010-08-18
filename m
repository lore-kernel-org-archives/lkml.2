Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751133Ab0HRCud (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Aug 2010 22:50:33 -0400
Received: from zeniv.linux.org.uk ([195.92.253.2]:47607 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750785Ab0HRCu2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Aug 2010 22:50:28 -0400
Date: Wed, 18 Aug 2010 03:50:23 +0100
From: Al Viro <viro@ZenIV.linux.org.uk>
To: David Miller <davem@davemloft.net>
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org,
        sparclinux@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [GIT] Sparc
Message-ID: <20100818025022.GM31363@ZenIV.linux.org.uk>
References: <20100817.180325.104051399.davem@davemloft.net>
 <AANLkTikQ1dGw0aO10_ZwmVEc-JAVhB==3HS7SrWycE49@mail.gmail.com>
 <20100817.191245.112612004.davem@davemloft.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100817.191245.112612004.davem@davemloft.net>
User-Agent: Mutt/1.5.20 (2009-08-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Aug 17, 2010 at 07:12:45PM -0700, David Miller wrote:
> From: Linus Torvalds <torvalds@linux-foundation.org>
> Date: Tue, 17 Aug 2010 18:31:50 -0700
> 
> > Confused yet?
> 
> Beyond...
> 
> > The basic rule becomes: never _ever_ overflow 'int' in a constant,
> > without specifying the exact type you want. That way you avoid all the
> > subtle cases.
> 
> That's easier to understand.

Actually, it's not that complicated:

1) base and suffices choose the possible types.
2) order of types is always the same: int -> unsigned -> long -> unsigned
long -> long long -> unsigned long long
3) we always choose the first type the value would fit into
4) L in suffix == "at least long"
5) LL in suffix == "at least long long"
6) U in suffix == "unsigned"
7) without U in suffix, base 10 == "signed"

That's it.  C90 differs from C99 only in one thing - long long (and LL) isn't
there.  The subtle mess Linus has mentioned is C90 gccism: gcc has allowed
unsigned long for decimal constants, as the last resort.  I.e. if you had
a plain decimal constant that wouldn't fit into long but would fit into
unsigned long, gcc generated a warning and treated it as unsigned long.
C90 would reject the damn thing.  _Bad_ extension, since in C99 the same
constant would be a legitimate signed long long.

But yes, "use the suffix when unsure" is a damn good idea, _especially_ since
the sizeof(long) actually varies between the targets we care about.
