Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932387Ab1J1LiR (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Oct 2011 07:38:17 -0400
Received: from mail-wy0-f174.google.com ([74.125.82.174]:43308 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751636Ab1J1LiP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Oct 2011 07:38:15 -0400
MIME-Version: 1.0
In-Reply-To: <1319777025.23112.67.camel@edumazet-laptop>
References: <1319764761.23112.14.camel@edumazet-laptop> <20111028012521.GF25795@one.firstfloor.org>
 <CA+55aFy9oJSK99K=brRzSfSnLocO=PuS7yuKkAcw3t5hATJrfw@mail.gmail.com>
 <1319766293.6759.17.camel@deadeye> <1319770376.23112.58.camel@edumazet-laptop>
 <1319772566.6759.27.camel@deadeye> <1319777025.23112.67.camel@edumazet-laptop>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Fri, 28 Oct 2011 04:37:53 -0700
X-Google-Sender-Auth: 8U7IFAVyCxEZEq5SuyJghfPp8tk
Message-ID: <CA+55aFzHf563auNYdNeJnsbbry1OUfkepkiVHt7Fy-bG64Fruw@mail.gmail.com>
Subject: Re: >Re: [RFC] should VM_BUG_ON(cond) really evaluate cond
To: Eric Dumazet <eric.dumazet@gmail.com>
Cc: Ben Hutchings <bhutchings@solarflare.com>,
        Andi Kleen <andi@firstfloor.org>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        netdev <netdev@vger.kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Oct 27, 2011 at 9:43 PM, Eric Dumazet <eric.dumazet@gmail.com> wrote:
>
> The only requirement of atomic_read() is that it must return value
> before or after an atomic_write(), not a garbled value.

The problem is that gcc *can* return a garbled value.

> In fact, if a compiler is stupid enough to issue two reads on following
> code :

The compiler really *can* be that "stupid". Except the code tends to
look like this:

   int value = atomic_read(&atomic_var);
   if (value > 10)
     return;
   .. do something with value ..

and gcc may decide - under register pressure, and in the absense of a
'volatile' - to read 'value' first once for that "> 10" check, and
then it drops the registers and instead of saving it on the stack
frame, it can decide to re-load it from atomic_var.

IOW, "value" could be two or more different values: one value when
testing, and *another* value in "do something with value".

This is why we have "ACCESS_ONCE()".

Whether atomics guarantee ACCESS_ONCE() semantics or not is not
entirely clear. But afaik, there is no way to tell gcc "access at
*most* once, and never ever reload".

                             Linus
