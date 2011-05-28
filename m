Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753374Ab1E1MSo (ORCPT <rfc822;w@1wt.eu>);
	Sat, 28 May 2011 08:18:44 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:60919 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751767Ab1E1MSm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 28 May 2011 08:18:42 -0400
Date: Sat, 28 May 2011 14:18:20 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: "H. Peter Anvin" <hpa@zytor.com>, Dan Rosenberg <drosenberg@vsecurity.com>,
        "Rafael J. Wysocki" <rjw@sisk.pl>, Tony Luck <tony.luck@gmail.com>,
        linux-kernel@vger.kernel.org, davej@redhat.com,
        kees.cook@canonical.com, davem@davemloft.net, eranian@google.com,
        adobriyan@gmail.com, penberg@kernel.org,
        Arjan van de Ven <arjan@infradead.org>,
        Andrew Morton <akpm@linux-foundation.org>, Valdis.Kletnieks@vt.edu,
        pageexec@freemail.hu
Subject: Re: [RFC][PATCH] Randomize kernel base address on boot
Message-ID: <20110528121820.GB12059@elte.hu>
References: <1306269105.21443.20.camel@dan>
 <201105270018.36835.rjw@sisk.pl>
 <BANLkTin+Vjhqtv5-N07G9P9_asNQnrnhVg@mail.gmail.com>
 <20110527170045.GB4356@elte.hu>
 <1306516230.3339.17.camel@dan>
 <20110527171611.GE4356@elte.hu>
 <BANLkTim7+gPdvQS99oJ7xteYOAQaSSr8Sw@mail.gmail.com>
 <20110527174644.GG4356@elte.hu>
 <4DDFE52D.4070308@zytor.com>
 <BANLkTimVQbHvW8tCACAcC8zRkyY1KyU2ww@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <BANLkTimVQbHvW8tCACAcC8zRkyY1KyU2ww@mail.gmail.com>
User-Agent: Mutt/1.5.20 (2009-08-17)
X-ELTE-SpamScore: -2.0
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-2.0 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.3.1
	-2.0 BAYES_00               BODY: Bayes spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Linus Torvalds <torvalds@linux-foundation.org> wrote:

> On Fri, May 27, 2011 at 10:53 AM, H. Peter Anvin <hpa@zytor.com> wrote:
> >
> > That doesn't solve any problems with the memory map.
> 
> Actually, it does.
> 
> You can load the kernel at the same virtual address we always load 
> it, and/or perhaps shift it up by just small amounts (ie "single 
> pages" rather than "ten bits worth of pages")

Note that if we do not limit it to just 'a few pages' then padding 
the randomization space into the kernel image:

 *also solves the memory map problem in the dynamic randomization case*

Having half a megabyte of '__init buffer' at the beginning or end of 
the kernel image is no big deal, it's more than enough for good 
randomization and makes the whole thing image-loader invariant: we 
can freely shift the 'real' kernel image within this larger boundary 
without consulting RAM maps.

And yes, you are right that smarter randomization like reordering of 
functions is probably more feasible with a static method - but i'm 
not sure we'd like to reorder functions: they are often ordered by 
importance within .c files, hence they are often ordered by cache 
hotness, so keeping them together makes sense to optimize icache 
footprint.

Further note that should anyone want to randomize the kernel position 
within a larger range, memory maps can still be consulted - but 
that's an optional enhancement, not a design requirement.

Note that such a larger range of randomization is not possible with 
the static install-time randomization method, as it needs the consult 
the memory maps on bootup.

So while i agree with you that install-time randomization has unique 
properties, i do not agree that all of those unique properties are 
advantages and thus i do not think that the case for static 
randomization is nearly as clear-cut as you made it appear.

Furthermore, the two main complications of dynamic randomizations 
that you highlighted are not really fundamental complications IMO:

 - the memory map consulation complexity can be completely eliminated
   in the dynamic randomization case as well

 - the hibernation complication is overstated i think: if on
   hibernation we save the randomization offset then the thawed 
   kernel can load at the very same address. [ We have no other
   choice anyway, pointers to the kernel image are stored all
   over the frozen image. ]

   This skips re-randomization across hibernation but that's ok:
   it's the functional equivalent of suspend-to-RAM.

Btw., there's another advantage of kernel image randomization in 
general that i have not mentioned before:

 - in addition to randomizing the kernel load physical image address, 
   on 64-bit x86 we could independently randomize the *virtual* 
   address of the kernel as well: within a rather large, 2GB address 
   space.

   This makes the very first step of buffer overflow (and pointer 
   overwrite) attacks very hard: they'd have to find the right 
   executable needle within a 2GB haystack.

Combined with SMEP this needle is the *only* place where a kernel 
mode exploit can execute. [*]

This kind of large-scale virtual address randomization could be 
performed both dynamically (boot time) and statically (install time).

Thanks,

	Ingo

[*] Assuming we get around sorting out the first 1MB compatibility
    constraints that force us to turn off NX there currently, and 
    review the pagetables for all remaining system mode mapped 
    executable pages.
