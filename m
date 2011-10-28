Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755921Ab1J1Ors (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Oct 2011 10:47:48 -0400
Received: from mail-ww0-f44.google.com ([74.125.82.44]:61328 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753411Ab1J1Orq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Oct 2011 10:47:46 -0400
Message-ID: <1319813252.23112.122.camel@edumazet-laptop>
Subject: Re: >Re: [RFC] should VM_BUG_ON(cond) really evaluate cond
From: Eric Dumazet <eric.dumazet@gmail.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Ben Hutchings <bhutchings@solarflare.com>,
        Andi Kleen <andi@firstfloor.org>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        netdev <netdev@vger.kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>
Date: Fri, 28 Oct 2011 16:47:32 +0200
In-Reply-To: <CA+55aFxy6VSBbikFrfXwUPOafihR+MOdi+yKSp_6qz7_Vax_YA@mail.gmail.com>
References: <1319764761.23112.14.camel@edumazet-laptop>
	 <20111028012521.GF25795@one.firstfloor.org>
	 <CA+55aFy9oJSK99K=brRzSfSnLocO=PuS7yuKkAcw3t5hATJrfw@mail.gmail.com>
	 <1319766293.6759.17.camel@deadeye>
	 <1319770376.23112.58.camel@edumazet-laptop>
	 <1319772566.6759.27.camel@deadeye>
	 <1319777025.23112.67.camel@edumazet-laptop>
	 <CA+55aFzHf563auNYdNeJnsbbry1OUfkepkiVHt7Fy-bG64Fruw@mail.gmail.com>
	 <1319803781.23112.113.camel@edumazet-laptop>
	 <CA+55aFxzgc5pC1p6J8YADNDwmAjUYNRKLvir6OQMueWqUXOaEQ@mail.gmail.com>
	 <CA+55aFxy6VSBbikFrfXwUPOafihR+MOdi+yKSp_6qz7_Vax_YA@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.0- 
Content-Transfer-Encoding: 8bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Le vendredi 28 octobre 2011 à 05:40 -0700, Linus Torvalds a écrit :
> On Fri, Oct 28, 2011 at 5:19 AM, Linus Torvalds
> <torvalds@linux-foundation.org> wrote:
> >
> > "Sane interfaces" are important. Insane interfaces lead to bugs.
> 
> Qutie frankly, if I do "atomic_read()", I do expect to get a single
> value. If I don't get a single value, but some mixture of two values,
> I'd personally go
> 
>   wtf, what does that "atomic" mean in "atomic_read()"?
> 
> and I think that's a reasonable wtf to ask.
> 
> That said, as mentioned, I don't know of any way to tell gcc "at most once".
> 
> Hmm.
> 
> Except perhaps using inline asm. Something like this might work:
> 
>   static inline int atomic_read(const atomic_t *v)
>   {
>        int val;
>        asm("":"=r" (val):"0" (v->value));
>        return val;
>   }
> 
> (totally untested, but you get the idea: use a non-volatile asm to
> make sure that gcc doesn't think it can re-load the value).
> 
> That's the trick we use in asmlinkage_protect() and a couple of other
> places. It *should* make gcc able to optimize the value away entirely
> if it isn't used, but will stop gcc from doing the reload magic.
> 
> Does that work for the test-case with VM_BUG_ON()?


On x86 it seems to work :

c050f80f: 0f 84 ea 00 00 00       je     c050f8ff <tcp_sendmsg+0xa1f>
c050f815: 8b 55 bc                mov    -0x44(%ebp),%edx
c050f818: f0 ff 42 10             lock incl 0x10(%edx)      atomic_inc(&page->count)
c050f81c: 8b 02                   mov    (%edx),%eax        page->flags
c050f81e: 25 00 40 02 00          and    $0x24000,%eax
c050f823: 3d 00 40 02 00          cmp    $0x24000,%eax
c050f828: 0f 84 9f 01 00 00       je     c050f9cd <tcp_sendmsg+0xaed>

On x86_64 (gcc-4.6.1 Debian-4.6.1-4) we still have a page->flags useless load,
but the atomic_read() itself is removed.


This looks like a CONFIG_PAGEFLAGS_EXTENDED difference.

In this case, PageTail() is :

#define TESTPAGEFLAG(uname, lname)                  \
static inline int Page##uname(const struct page *page)          \
	{ return test_bit(PG_##lname, &page->flags); } 


So we need a similar idea to remove the volatile from :

static __always_inline int constant_test_bit(unsigned int nr, const volatile unsigned long *addr)
{
return ((1UL << (nr % BITS_PER_LONG)) &
	 (addr[nr / BITS_PER_LONG])) != 0;
}



