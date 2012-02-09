Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757991Ab2BIR5F (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Feb 2012 12:57:05 -0500
Received: from mail-pw0-f46.google.com ([209.85.160.46]:58004 "EHLO
	mail-pw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757467Ab2BIR5B (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Feb 2012 12:57:01 -0500
MIME-Version: 1.0
In-Reply-To: <7095.1328809567@redhat.com>
References: <20120209154819.32070.93358.stgit@warthog.procyon.org.uk>
 <1328804920.6099.3.camel@edumazet-HP-Compaq-6005-Pro-SFF-PC>
 <CA+55aFxHdFa4otDWJg4f+8sKEP3MBZqKBQCnH0Q8LXYtpdt1EA@mail.gmail.com>
 <CA+55aFyw1n=Bz3vi73RD5R13HyWLaVyPZc_z5rR7nGPzvs-BOw@mail.gmail.com> <7095.1328809567@redhat.com>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Thu, 9 Feb 2012 09:56:41 -0800
X-Google-Sender-Auth: WWKkXg3WE8ijBDY-S4oIU6HOjd0
Message-ID: <CA+55aFw5z85wuU8xJ_YFp0QB653yAGPOqeGXhJLbdj9ogpHqOA@mail.gmail.com>
Subject: Re: [PATCH] Reduce the number of expensive division instructions done
 by _parse_integer()
To: David Howells <dhowells@redhat.com>
Cc: Eric Dumazet <eric.dumazet@gmail.com>, adobriyan@gmail.com,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Feb 9, 2012 at 9:46 AM, David Howells <dhowells@redhat.com> wrote:
>
> On fixed-size instruction arches, the runtime shift is probably the better
> option, as simply loading 64-bit large constant would take likely take at
> least four instructions - and might involve a shift anyway.

Bah. The constant is hoisted out of the loop on anything that has
enough registers - and "cannot generate constants" is almost
universally associated with "fair amount of registers".

The exception to that would be architectures with small register sets,
and particularly 32-bit ones. There, the 64-bit value and the multiply
likely not only takes more registers, but also kills registers due to
a function call. On the other hand "few 32-bit registers" is mainly
32-bit 386, which has no problems with a 32-bit constant.

And even if you have "out-of-line 64-bit multiply killing registers so
that you can't hoist the constant", even then gcc knows all about
those "big constants can be expensive" and likely knows how to
optimize them.

In particular, this big constant takes two instructions to generate
even in the absolute *worst* case: one to generate the constant 15,
one to shift it left by 60 (or 28, on a 32-bit setup).

But I don't have access to some broken "I can't do constants well"
architecture to actually test. Gcc could generate crazy bad code, but
almost certainly won't.

                           Linus
