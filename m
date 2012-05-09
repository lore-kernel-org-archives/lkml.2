Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759762Ab2EIOiA (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 May 2012 10:38:00 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:52183 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759751Ab2EIOh6 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 May 2012 10:37:58 -0400
MIME-Version: 1.0
In-Reply-To: <1336571457.30189.29.camel@joe2Laptop>
References: <1336004953.4240.9.camel@mop> <CA+1xoqdCk9FcqdLEvwgHtfrauNh=s0dDwcpaJimMC_H83N=_5w@mail.gmail.com>
 <1336475689.1179.12.camel@mop> <CA+55aFwbQTq_f7p2j-eu8-hVpiZ1Uf2MCU7R+DDWHimiVbcScg@mail.gmail.com>
 <CAPXgP13-XQdn0wMP=coVqS=Eko1vWkOrjOtfq4JQLHFZ3JNbgg@mail.gmail.com> <1336571457.30189.29.camel@joe2Laptop>
From: Kay Sievers <kay@vrfy.org>
Date: Wed, 9 May 2012 16:37:37 +0200
Message-ID: <CAPXgP11jt5u=wXs9Pe7QksZ25QTKCwNXgTHn+T6JXD6+2NzgBQ@mail.gmail.com>
Subject: Re: [PATCH RESEND 1/3] printk: convert byte-buffer to variable-length
 record buffer
To: Joe Perches <joe@perches.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        Sasha Levin <levinsasha928@gmail.com>,
        Greg Kroah-Hartmann <greg@kroah.com>, Ingo Molnar <mingo@kernel.org>,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, May 9, 2012 at 3:50 PM, Joe Perches <joe@perches.com> wrote:
> On Wed, 2012-05-09 at 11:38 +0200, Kay Sievers wrote:

> I think your premise is wrong for a couple of reasons.
>
> 1: printk content is not guaranteed to be stable.

Nobody talks about the content of the strings.

>   printk content should not be guaranteed to be stable.
>   It'd make it difficult to simply add a new message
>   or extend or correct an existing one.

Again, that's only what you make out of it.

My point is reliable log _storage_ and with that properly working, the
output _format_ gets as _reliable_ as possible. Continuation printk()
today is entirely unreliable, not only for the continuation users,
also for everybody else, because we merge randomly with atomic
printk() users.

We have (stupid ) scripts that diff dmesg after
supposed-to-be-harmless kernel changes to automatically spot problems.
You can see all the broken merges of continuation lines, and they also
affect lines which do simple and proper atomic printk()s. This is not
useful, and again it's the broken _logic_ of storage not the _content_
of the message.

> 2: There are _thousands_ of printks without prefix levels.

Right, and nobody is crazy enough to think we want to touch them all.

>   KERN_CONT was always kind of a half-stupid idea.
>   It's only real purpose is to designate message
>   continuations but it never gave enough information to
>   correctly coalesce the messages.

Right, it's the annotation of an exception; not nice, but pretty
well-defined, and can be isolated from the non-exception by software
instead of a human.

> I think you need to give up on the idea that printk
> output can be made to be machine readable.

Nobody talks about that in this very context. It is all about better
_reliability_ of the facility not about _content_.

The structured data, possibly attached to the log message, which
uniquely identifies the kernel device, is surely meant to be machine
readable, and no, I'm absolutely not giving up on that approach.

> If you really want to have users get complete and
> not-interleaved messages you need to buffer partial
> messages,  Whether or not printk message coalescing
> needs to have a cookie or can be done well enough by
> using call tree information as suggested by Andrew
> Morton is tbd.

I'm convinced, that we need something simpler than a new cookie logic.
It can work sure, but I doubt we really wants to change the code flow
of all the stuff.

> Changing printk semantics and trying to stabilize
> printk message content are bad ideas though.

Again, nobody talks about content of here.

But reliable context-aware facilities are almost never a bad idea. We
can certainly make printk() better without changing the whole source
tree.

You might not oppose to the heuristics and the "throw it all in a bag
an let's find out later" strategy, I certainly don't like it and think
it's very broken.

> I think printk_emit is an OK idea.  Having a
> per-subsystem notification mechanism, something
> like an expanded ethtool is certainly useful.
>
> Making the new additional content of printk_emit
> discoverable would be useful.

It is all available through /dev/kmsg,

Kay
