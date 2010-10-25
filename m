Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755427Ab0JYMiA (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Oct 2010 08:38:00 -0400
Received: from one.firstfloor.org ([213.235.205.2]:56108 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751285Ab0JYMh6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Oct 2010 08:37:58 -0400
Date: Mon, 25 Oct 2010 14:37:53 +0200
From: Andi Kleen <andi@firstfloor.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: Andi Kleen <andi@firstfloor.org>, Huang Ying <ying.huang@intel.com>,
        Len Brown <lenb@kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-acpi@vger.kernel.org" <linux-acpi@vger.kernel.org>,
        Borislav Petkov <petkovbb@googlemail.com>,
        Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>,
        Don Zickus <dzickus@redhat.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Mauro Carvalho Chehab <mchehab@redhat.com>,
        Arjan van de Ven <arjan@infradead.org>
Subject: Re: [NAK] Re: [PATCH -v2 9/9] ACPI, APEI, Generic Hardware Error
 Source POLL/IRQ/NMI notification type support
Message-ID: <20101025123753.GB17622@basil.fritz.box>
References: <1287992610-14996-1-git-send-email-ying.huang@intel.com>
 <1287992610-14996-10-git-send-email-ying.huang@intel.com>
 <20101025084553.GA27119@elte.hu>
 <1287997112.2862.322.camel@yhuang-dev>
 <20101025091913.GA17622@basil.fritz.box>
 <20101025111530.GA27659@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20101025111530.GA27659@elte.hu>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Oct 25, 2010 at 01:15:30PM +0200, Ingo Molnar wrote:

> > > > einj.c: it's about the 3rd separate 'error injection' concept that got 
> > > > introduced ...
> > > 
> > > EINJ is a true platform feature, not just software feature. We need to support 
> > > it to debug various hardware error features.
> > 
> > Also having multiple error injecting interfaces is a good thing.
> 
> It's never a good thing to have separate, vendor dependent interfaces for what to 
> the user is basically the same conceptual thing!

Perhaps a simple example (simplified, in practice there are more
complications) makes it more clear:

The memory error handler does different actions depending on what the 
state the page the error is happening on is in.

To get reasonable coverage of the recovery code you need to present it with 
pages in different states (like locked, clean, dirty, IO etc. etc. )

Now it turns out this is very hard to do if you just inject the error
at the hardware level, because there are lots of races and problems
ensuring the page is still in the expected state etc.etc.

So one of the solution hwpoison did for this was to have another injector
that works on the process level. At the process level you can get
pages into different stages and reasonably cleanly inject the right 
error with the right context. This is essentially error
injection at the VM level.

Again this is simplified, for coverage we actually needed multiple
injectors that work at different entry points, e.g. for example
to make sure buffered file system pages are correctly handled too.

Now that's great, but we still need other injectors that work 
on other level, otherwise the part that talks to the hardware
are not covered at all

But you cannot test all the code paths of that code either using
a single hardware injector.  So there's another one that can fake different
contexts at the software level and provides reasonable
coverage of this code.

But then you still didn't test the whole hardware to software
error path. Now yes you could use a EDAC like ECC bits injector
(which BTW doesn't really need a kernel driver, we did it just
using shell scripts fine before). But that also only tests
one path and not the others possibilities, and also only
works on specific hardware in specific modes with very careful
setup.

But that's just one type of error for one system.  So you need other 
interfaces for other hardware and for other errors etc.etc. 

In some cases you also need to talk to the BIOS to do this injection
for various reasons, that is where ACPI comes in (and all these 
acronyms you seem to object to)

Also it's not enough to do single error injection once
on some system. You need a repeatable regression test that
ensure the error handling stays operable for kernels as
they evolve. This requires that the error injection is reasonably 
portable. 

For this I tried to have a "software only" injector for
nearly everything just to make sure the code can be always
tested. Unfortunately the software injectors, especially
the ones aiming at larger coverage, also have quite different
interface requirements than hardware interfaces.

But again you still need to test the full hardware too,
otherwise we don't know if the error handling is really 
working on a real system in practice.

Error injection is just messy. There is no single general
solution that works for everything and solves all problems, but you
really need a pragmatic approach for every subsystem. 

In the end it means you end up with lots of different injectors,
all tied to some specific problem.

Would it be nice if there was a single great injector that covers
everything? Yes
Is it realistic? No.

-Andi
-- 
ak@linux.intel.com -- Speaking for myself only.
