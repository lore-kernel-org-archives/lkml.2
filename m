Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752363Ab1AQGHY (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Jan 2011 01:07:24 -0500
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:42959
	"EHLO sunset.davemloft.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751102Ab1AQGHW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Jan 2011 01:07:22 -0500
Date: Sun, 16 Jan 2011 22:07:55 -0800 (PST)
Message-Id: <20110116.220755.179947617.davem@davemloft.net>
To: richm@oldelvet.org.uk
Cc: 609371@bugs.debian.org, ben@decadent.org.uk, sparclinux@vger.kernel.org,
        linux-kernel@vger.kernel.org, rostedt@goodmis.org, fweisbec@gmail.com,
        mingo@redhat.com, Jesper.Nilsson@axis.com, jeffm@suse.com
Subject: Re: Bug#609371: linux-image-2.6.37-trunk-sparc64: module scsi_mod:
 Unknown relocation: 36
From: David Miller <davem@davemloft.net>
In-Reply-To: <20110115.211722.39173519.davem@davemloft.net>
References: <4D302B2F.7030108@oldelvet.org.uk>
	<4D3074FE.3030707@oldelvet.org.uk>
	<20110115.211722.39173519.davem@davemloft.net>
X-Mailer: Mew version 6.3 on Emacs 23.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: David Miller <davem@davemloft.net>
Date: Sat, 15 Jan 2011 21:17:22 -0800 (PST)

[ Please, everyone, retain the full CC: on all replies, thanks.  Some
  people are replying only into the debian bug alias, and that loses
  information and exposure for fixing this bug.  ]

> I think the problem we have here is that the _ftrace_events section is
> not aligned sufficiently.  That ".align 4" mnemonic is a good indication
> of this.  It should at least "8" on sparc64.

I did some more research.

Although I've seen commentary to the contrary, in fact using a too-small
__attribute__((aligned())) directive will lower the alignment of data
members, and yes that means it will lower the alignemnt to be below the
natural and required alignment for the given type.

So if you have, on 64-bit:

struct foo {
	void *bar;
};

static struct foo test __attribute__((__aligned__(4)));

The compiler will emit "test" with 4-byte alignment into the data
section, even though 8-byte alignment is required for "test.bar"

Assuming we wanted that to actually happen, the GCC manual is very
explicit to state that in order for this to work, such down-aligned
data structures must also use the "packed" attribute.

I think we want none of this, and I think we should elide the align
directives entirely, or at least fix them so we don't get unaligned
stuff on 64-bit.

Ugh, and I just noticed that include/linux/klist.h does this fixed
alignment of "4" too, where is this stuff coming from?  It's
wrong on 64-bit, at best.  But I can't see the impetus behind doing
this at all in the first place.

Oh, this is some CRIS thing, because it only byte aligns.  See:

commit c0e69a5bbc6fc74184aa043aadb9a53bc58f953b
Author: Jesper Nilsson <Jesper.Nilsson@axis.com>
Date:   Wed Jan 14 11:19:08 2009 +0100

    klist.c: bit 0 in pointer can't be used as flag

That's where the klist one comes from.

The ftrace ones come from:

commit 86c38a31aa7f2dd6e74a262710bf8ebf7455acc5
Author: Jeff Mahoney <jeffm@suse.com>
Date:   Wed Feb 24 13:59:23 2010 -0500

    tracing: Fix ftrace_event_call alignment for use with gcc 4.5
    
We really can't handle this that way, it's going to break stuff
on 64-bit systems at the very least.

How about we use __BIGGEST_ALIGNMENT__ or something arch-defined value
instead?
