Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754433Ab1E0SGD (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 May 2011 14:06:03 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:54441 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750922Ab1E0SGB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 May 2011 14:06:01 -0400
MIME-Version: 1.0
In-Reply-To: <4DDFE52D.4070308@zytor.com>
References: <1306269105.21443.20.camel@dan> <201105270018.36835.rjw@sisk.pl>
 <BANLkTin+Vjhqtv5-N07G9P9_asNQnrnhVg@mail.gmail.com> <20110527170045.GB4356@elte.hu>
 <1306516230.3339.17.camel@dan> <20110527171611.GE4356@elte.hu>
 <BANLkTim7+gPdvQS99oJ7xteYOAQaSSr8Sw@mail.gmail.com> <20110527174644.GG4356@elte.hu>
 <4DDFE52D.4070308@zytor.com>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Fri, 27 May 2011 11:05:07 -0700
Message-ID: <BANLkTimVQbHvW8tCACAcC8zRkyY1KyU2ww@mail.gmail.com>
Subject: Re: [RFC][PATCH] Randomize kernel base address on boot
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: Ingo Molnar <mingo@elte.hu>, Dan Rosenberg <drosenberg@vsecurity.com>,
        "Rafael J. Wysocki" <rjw@sisk.pl>, Tony Luck <tony.luck@gmail.com>,
        linux-kernel@vger.kernel.org, davej@redhat.com,
        kees.cook@canonical.com, davem@davemloft.net, eranian@google.com,
        adobriyan@gmail.com, penberg@kernel.org,
        Arjan van de Ven <arjan@infradead.org>,
        Andrew Morton <akpm@linux-foundation.org>, Valdis.Kletnieks@vt.edu,
        pageexec@freemail.hu
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, May 27, 2011 at 10:53 AM, H. Peter Anvin <hpa@zytor.com> wrote:
>
> That doesn't solve any problems with the memory map.

Actually, it does.

You can load the kernel at the same virtual address we always load it,
and/or perhaps shift it up by just small amounts (ie "single pages"
rather than "ten bits worth of pages")

And then rely on the fact that you mixed up symbols in other ways.

"Look ma, no need to worry about memory map". At least no more than we do now.

Put another way: think about our /proc/iomem right now:

  00100000-bdc6ffff : System RAM
    01000000-016bdced : Kernel code
    016bdcee-01ca8b7f : Kernel data
    01d36000-01de2fff : Kernel bss

with the "shift kernel up at load-time", the above information is
suddenly very scary, because the "Kernel code" part is magically
important.

In contrast, if your randomization depends on just relinking things a
bit differently, you don't really give out any of the random
information in /proc/iomem. Nor does it affect the load address and
the e820 memory map.

And, in fact, it does give you way more bits of randomness to play
around with the text addresses.

With something like function-sections, it should be possible to do
quite a serious job of relinking (and then keep some "function section
to actual relinked address" mapping around so that you can do the
/proc/kallsyms mappings).

But that's actually the "fancy" model. I don't think we should aim at
that to begin with. Start off with something much less ambitious, like
just shifting the kernel by a few pages. People have argued that even
just a 50% chance of an oops is preferable to nothing. So we can start
small and stupid.

See?

                     Linus
