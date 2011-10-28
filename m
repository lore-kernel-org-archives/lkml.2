Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932472Ab1J1MJ5 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Oct 2011 08:09:57 -0400
Received: from mail-wy0-f174.google.com ([74.125.82.174]:45806 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755484Ab1J1MJz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Oct 2011 08:09:55 -0400
Message-ID: <1319803781.23112.113.camel@edumazet-laptop>
Subject: Re: >Re: [RFC] should VM_BUG_ON(cond) really evaluate cond
From: Eric Dumazet <eric.dumazet@gmail.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Ben Hutchings <bhutchings@solarflare.com>,
        Andi Kleen <andi@firstfloor.org>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        netdev <netdev@vger.kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>
Date: Fri, 28 Oct 2011 14:09:41 +0200
In-Reply-To: <CA+55aFzHf563auNYdNeJnsbbry1OUfkepkiVHt7Fy-bG64Fruw@mail.gmail.com>
References: <1319764761.23112.14.camel@edumazet-laptop>
	 <20111028012521.GF25795@one.firstfloor.org>
	 <CA+55aFy9oJSK99K=brRzSfSnLocO=PuS7yuKkAcw3t5hATJrfw@mail.gmail.com>
	 <1319766293.6759.17.camel@deadeye>
	 <1319770376.23112.58.camel@edumazet-laptop>
	 <1319772566.6759.27.camel@deadeye>
	 <1319777025.23112.67.camel@edumazet-laptop>
	 <CA+55aFzHf563auNYdNeJnsbbry1OUfkepkiVHt7Fy-bG64Fruw@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.0- 
Content-Transfer-Encoding: 8bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Le vendredi 28 octobre 2011 à 04:37 -0700, Linus Torvalds a écrit :
> On Thu, Oct 27, 2011 at 9:43 PM, Eric Dumazet <eric.dumazet@gmail.com> wrote:
> >
> > The only requirement of atomic_read() is that it must return value
> > before or after an atomic_write(), not a garbled value.
> 
> The problem is that gcc *can* return a garbled value.
> 
> > In fact, if a compiler is stupid enough to issue two reads on following
> > code :
> 
> The compiler really *can* be that "stupid". Except the code tends to
> look like this:
> 
>    int value = atomic_read(&atomic_var);
>    if (value > 10)
>      return;
>    .. do something with value ..
> 
> and gcc may decide - under register pressure, and in the absense of a
> 'volatile' - to read 'value' first once for that "> 10" check, and
> then it drops the registers and instead of saving it on the stack
> frame, it can decide to re-load it from atomic_var.
> 
> IOW, "value" could be two or more different values: one value when
> testing, and *another* value in "do something with value".
> 
> This is why we have "ACCESS_ONCE()".
> 
> Whether atomics guarantee ACCESS_ONCE() semantics or not is not
> entirely clear. But afaik, there is no way to tell gcc "access at
> *most* once, and never ever reload".
> 

What you describe is true for non atomic variables as well, its not part
of the atomic_ops documented semantic.

And we do use ACCESS_ONCE() on the rare cases we need to make sure no
reload is done.

RCU use makes this implied (ACCESS_ONCE() being done in
rcu_dereference()), so we dont have many raw ACCESS_ONCE() in our code.

int value = ACCESS_ONCE(atomic_read(&atomic_var));
if (value > 10)
     return;
.. do something with value ..

One of such rare use is explained in commit f1987257
(tcp: protect sysctl_tcp_cookie_size reads)

Since its a bit ugly, I suggested :

int value = atomic_read_once(&atomic_var);
if (value > 10)
     return;
    .. do something with value ..

I dont know, it seems the right way, but yes it might break things.

We can take the otherway and patch thousand atomic_read() to
atomic_read_stable(), its safer but very boring :)



