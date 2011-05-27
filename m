Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755403Ab1E0TQM (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 May 2011 15:16:12 -0400
Received: from mx1.redhat.com ([209.132.183.28]:10750 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751131Ab1E0TQL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 May 2011 15:16:11 -0400
Date: Fri, 27 May 2011 15:15:00 -0400
From: Vivek Goyal <vgoyal@redhat.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: "H. Peter Anvin" <hpa@zytor.com>, Ingo Molnar <mingo@elte.hu>,
        Dan Rosenberg <drosenberg@vsecurity.com>,
        "Rafael J. Wysocki" <rjw@sisk.pl>, Tony Luck <tony.luck@gmail.com>,
        linux-kernel@vger.kernel.org, davej@redhat.com,
        kees.cook@canonical.com, davem@davemloft.net, eranian@google.com,
        adobriyan@gmail.com, penberg@kernel.org,
        Arjan van de Ven <arjan@infradead.org>,
        Andrew Morton <akpm@linux-foundation.org>, Valdis.Kletnieks@vt.edu,
        pageexec@freemail.hu
Subject: Re: [RFC][PATCH] Randomize kernel base address on boot
Message-ID: <20110527191500.GJ8053@redhat.com>
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
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, May 27, 2011 at 11:05:07AM -0700, Linus Torvalds wrote:
> On Fri, May 27, 2011 at 10:53 AM, H. Peter Anvin <hpa@zytor.com> wrote:
> >
> > That doesn't solve any problems with the memory map.
> 
> Actually, it does.
> 
> You can load the kernel at the same virtual address we always load it,
> and/or perhaps shift it up by just small amounts (ie "single pages"
> rather than "ten bits worth of pages")
> 
> And then rely on the fact that you mixed up symbols in other ways.
> 
> "Look ma, no need to worry about memory map". At least no more than we do now.
> 
> Put another way: think about our /proc/iomem right now:
> 
>   00100000-bdc6ffff : System RAM
>     01000000-016bdced : Kernel code
>     016bdcee-01ca8b7f : Kernel data
>     01d36000-01de2fff : Kernel bss
> 
> with the "shift kernel up at load-time", the above information is
> suddenly very scary, because the "Kernel code" part is magically
> important.
> 
> In contrast, if your randomization depends on just relinking things a
> bit differently, you don't really give out any of the random
> information in /proc/iomem. Nor does it affect the load address and
> the e820 memory map.
> 
> And, in fact, it does give you way more bits of randomness to play
> around with the text addresses.

I am wondering what happens to crash analysis tools if per system 
virtual addresses are shifted by some offset. I guess tools like
"crash" can adjust to this by looking at vmcore ELF headers but
I think gdb does not expect change of virtual addresses.

That would essentially mean that apart from vmcore one shall have to
store the vmlinux file also from the system crashed. Currently we don't
have to save vmlinux. In fact for analysis we can install distro provided
debug compiled vmlinux later and just need to get the vmcore file from
crashed system and do the analysis.

So IIUC, with above model, I guess "crash" should be able to adjust
to it quickly but gdb will have issues.

Thanks
Vivek
