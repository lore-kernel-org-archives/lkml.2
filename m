Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752880Ab0LSJSJ (ORCPT <rfc822;w@1wt.eu>);
	Sun, 19 Dec 2010 04:18:09 -0500
Received: from mail.skyhub.de ([78.46.96.112]:35536 "EHLO mail.skyhub.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750904Ab0LSJR7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 19 Dec 2010 04:17:59 -0500
Date: Sun, 19 Dec 2010 10:17:52 +0100
From: Borislav Petkov <bp@alien8.de>
To: Tony Luck <tony.luck@gmail.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        "H. Peter Anvin" <hpa@zytor.com>, linux-kernel@vger.kernel.org,
        linux-arch@vger.kernel.org, tglx@linutronix.de, mingo@elte.hu,
        greg@kroah.com, akpm@linux-foundation.org, ying.huang@intel.com,
        David Miller <davem@davemloft.net>,
        Alan Cox <alan@lxorguk.ukuu.org.uk>,
        Jim Keniston <jkenisto@linux.vnet.ibm.com>,
        Kyungmin Park <kmpark@infradead.org>,
        Geert Uytterhoeven <geert@linux-m68k.org>
Subject: Re: [concept & "good taste" review] persistent store
Message-ID: <20101219091752.GA16150@liondog.tnic>
Mail-Followup-To: Borislav Petkov <bp@alien8.de>,
	Tony Luck <tony.luck@gmail.com>,
	Linus Torvalds <torvalds@linux-foundation.org>,
	"H. Peter Anvin" <hpa@zytor.com>, linux-kernel@vger.kernel.org,
	linux-arch@vger.kernel.org, tglx@linutronix.de, mingo@elte.hu,
	greg@kroah.com, akpm@linux-foundation.org, ying.huang@intel.com,
	David Miller <davem@davemloft.net>,
	Alan Cox <alan@lxorguk.ukuu.org.uk>,
	Jim Keniston <jkenisto@linux.vnet.ibm.com>,
	Kyungmin Park <kmpark@infradead.org>,
	Geert Uytterhoeven <geert@linux-m68k.org>
References: <4d0662e511688484b3@agluck-desktop.sc.intel.com>
 <AANLkTindPUkF7fCkdbqSstNHFjF3_7fEYh18nhQFx_AJ@mail.gmail.com>
 <AANLkTim3OpjPysjdCLDuFgFOipmcxyr2ay5cvUAu5PHi@mail.gmail.com>
 <AANLkTinpYJddhgbf7=Pw_TtGrnWaC8fwo2xv1XRsT1w7@mail.gmail.com>
 <AANLkTimA4x8oWyq71nOxB=Otp3Y0i3Kcu27DG0ajaXUG@mail.gmail.com>
 <AANLkTinCG+E6ZzpeRqsJP+-qvNDQXW4VZFgJ1c-sTryL@mail.gmail.com>
 <4D0BEE1F.7020008@zytor.com>
 <AANLkTinwFt+KDKNEYP9MWQ7wGb9qk=E2Xa3RJB3+MJnN@mail.gmail.com>
 <AANLkTinoV_pL=Ygqq4qt4f8c+wsdc9r9K7rcJ58aHjD1@mail.gmail.com>
 <AANLkTikhtWjFBQmA111Q+2JGRudrRNAmegGThMagr4vF@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <AANLkTikhtWjFBQmA111Q+2JGRudrRNAmegGThMagr4vF@mail.gmail.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Dec 18, 2010 at 03:06:57PM -0800, Tony Luck wrote:
> > Doesn't that sound like the best of both worlds?
> 
> It sounds like an excellent heuristic for how the platform layer
> should manage the persistent store when space is tight. But
> I think that I can still keep my /dev/pstore filesystem as a
> presentation layer to make the bits available to the user in
> a device independent way.
> 
> Or perhaps the pstore layer can help with the implementation
> of the heuristic. It knows what items are in the pstore, so it
> could build & maintain the "ring" and pass the id of the least
> wanted item down to the platform layer whenever it wants to
> write a record ... with the platform layer giving a status to
> say whether it had to delete that item to make space for the
> new one?

Before we go and delve into priority-sorting the oopses in the pstore,
let me ask this: how big an actual persistent storage device are we
talking?

Because if it is big enough - for some value of 'big' - we could try to
never let it fill up. If want to save space we might even do something
crazy like compressing the oops info. In the rare event it fills up or
hits some 'almost-full' watermarks, we can kick some userspace daemon
to start writing the oopses to fs and clear the pstore. This all should
happen in the case where all you get is non-critical warnings and the
system is still alive.

However, in the critical cases, you get a single "stream" of oopses with
the first one being the most important one and then you panic. And in
most cases that stream is only a couple of oopses long. For that, the
pstore should be big enough to easily contain it.

  [ Btw, if we are able to write that stream to pstore before we panic,
 we solve all the problems we have with catching oopses with cameras,
 serial consoles, netconsoles, firewire and pen and paper! ]

In that case, when you restart the machine, the same daemon notices the
existence of the oopses and starts writing them to fs, notifies the
users and clears the pstore.

So, I think what we could do is keep our big enough pstore with enough
free space for a bunch of oopses in case we panic. In the remaining
cases, we write them out thus freeing some more space.

Hmmm..

-- 
Regards/Gruss,
    Boris.
