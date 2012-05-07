Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754956Ab2EGAYW (ORCPT <rfc822;w@1wt.eu>);
	Sun, 6 May 2012 20:24:22 -0400
Received: from zeniv.linux.org.uk ([195.92.253.2]:48556 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754732Ab2EGAYV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 6 May 2012 20:24:21 -0400
Date: Mon, 7 May 2012 01:24:19 +0100
From: Al Viro <viro@ZenIV.linux.org.uk>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, "H. Peter Anvin" <hpa@zytor.com>,
        Ralf Baechle <ralf@linux-mips.org>
Subject: Re: [PATCH] broken TASK_SIZE for ia32_aout
Message-ID: <20120507002419.GD22082@ZenIV.linux.org.uk>
References: <20120506162000.GT6871@ZenIV.linux.org.uk>
 <CA+55aFzj3Ocjpnw3WdmKjp3oELwmXt=Zs2=fZuYy0TUyF4nXiA@mail.gmail.com>
 <20120506175451.GU6871@ZenIV.linux.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120506175451.GU6871@ZenIV.linux.org.uk>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, May 06, 2012 at 06:54:51PM +0100, Al Viro wrote:
> On Sun, May 06, 2012 at 10:16:11AM -0700, Linus Torvalds wrote:
> > On Sun, May 6, 2012 at 9:20 AM, Al Viro <viro@zeniv.linux.org.uk> wrote:
> > > Setting TIF_IA32 in load_aout_binary() used to be enough; these days
> > > TASK_SIZE is controlled by TIF_ADDR32 and that one doesn't get set
> > > there. ?Switch to use of set_personality_ia32()...
> > 
> > Applied. Just out of curiosity, how did you notice? Just looking at
> > TIF_IA32 usage, or do you actually have some old app?
> 
> Putting together an idiot's guide to thread flags ;-)

BTW, in process something else got found:
---
TIF_IRET(i386) is used to force return to userland via iret, even
if we'd entered the kernel via sysenter.  This, to put it mildly,
is a fucking ugly hack.  Essentially, it acts as a silent duplicate of
NOTIFY_RESUME.  do_notify_resume() clears it (as it clears NOTIFY_RESUME
itself).  And i386 has glue treat it as something indistinguishable from
NOTIFY_RESUME, never mentioning either explicitly.  _Any_ path going
through do_notify_resume() there will leave via iret - sysret is for fast
path only.  So setting TIF_IRET (or, for that matter, TIF_NOTIFY_RESUME)
has an effect of forcing exit via iret.

That had been obfuscated just enough to have it copied to hexagon, m32r,
microblaze and xtensa.  None of those ever set it.  Or have an analog of
the x86 issues that make forcing exit via iret needed there.  Or give
a flying fuck for all that crap anyway.  Pure and simple cargo-cult
programming.

IMO we should kill it everywhere, starting at i386.  There we can simply
set TIF_NOTIFY_RESUME instead.
---

Comments?  It's _not_ 3.4.0 material, obviously, but unless I'm missing
something, killing that thing would be a a Good Thing(tm), especially
since reconstructing the reasons it works at all really takes a non-trivial
amount of crawling throught entry_32.S...
