Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757327Ab0FOCwO (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Jun 2010 22:52:14 -0400
Received: from mail-gy0-f174.google.com ([209.85.160.174]:45778 "EHLO
	mail-gy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754182Ab0FOCwM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Jun 2010 22:52:12 -0400
Date: Mon, 14 Jun 2010 22:52:08 -0400 (EDT)
From: Tim Abbott <tabbott@ksplice.com>
X-X-Sender: tabbott@dr-wily.mit.edu
To: James Bottomley <James.Bottomley@HansenPartnership.com>
cc: Matt Fleming <matt@console-pimps.org>, linux-arch@vger.kernel.org,
       Arnd Bergmann <arnd@arndb.de>, linux-kernel@vger.kernel.org,
       Sam Ravnborg <sam@ravnborg.org>, Michal Marek <mmarek@suse.cz>,
       Denys Vlasenko <vda.linux@googlemail.com>, linux-parisc@vger.kernel.org
Subject: Re: [PATCH 1/5] vmlinux.lds.h: Include *(.text.*) in TEXT_TEXT
In-Reply-To: <1276557299.5374.847.camel@mulgrave.site>
Message-ID: <alpine.DEB.1.10.1006142245560.1248@dr-wily.mit.edu>
References: <1276519112-11649-1-git-send-email-matt@console-pimps.org>  <alpine.DEB.1.10.1006141014360.1432@dr-wily.mit.edu>  <87y6ehxvby.fsf@linux-g6p1.site>  <alpine.DEB.1.10.1006141534490.1248@dr-wily.mit.edu> <1276557299.5374.847.camel@mulgrave.site>
User-Agent: Alpine 1.10 (DEB 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 14 Jun 2010, James Bottomley wrote:

> On Mon, 2010-06-14 at 18:21 -0400, Tim Abbott wrote:
> > On Mon, 14 Jun 2010, Matt Fleming wrote:
> > 
> > > Do these special kernel sections include things like the parisc
> > > .text.do_softirq, .text.sys_exit, etc? James raised a good objection to
> > > the parisc patch of this series. I'm guessing most people saw it already
> > > but I'll paste it here for reference,
> > > 
> > >     This would destroy all of the named parisc text ordering we do above the
> > >     removed line because now you'd have swept up all the function sections
> > >     before we get to them, won't it?
> > > 
> > >     The ordering is an execution speed up on 32 bit systems because our
> > >     relative jump is so short.
> > > 
> > > Will you changes handle this OK?
> > 
> > I think I addressed this in my reply to James just now, but to be super 
> > clear, this -ffunction-sections plan involves renaming .text.do_softirq to 
> > .text..do_softirq (etc.) first.
> 
> OK, so that doesn't make a lot of sense to me; I suspect because you
> don't understand what parisc is doing.  These aren't names of linux
> special sections ... they're names of function sections.  For
> efficiency, we take specific hot functions and place them together in
> the linker script so the jumps between them are small enough to be coded
> as relative on the 32 bit architecture.  It's really just a more
> efficient way of laying out the binary.

Yeah, I'd forgotten parisc was doing -ffunction-sections, now I understand 
what you're talking about.  What I'd recommend is just moving the 
.text.do_softirq and friends like in the hunk below -- I believe that 
should achieve the same performance goals, and should have no conflict 
with adding a wildcard for -ffunction-sections generated sections to 
TEXT_TEXT.

	-Tim Abbott

diff --git a/arch/parisc/kernel/vmlinux.lds.S 
b/arch/parisc/kernel/vmlinux.lds.S
index d64a6bb..ad0d3d3 100644
--- a/arch/parisc/kernel/vmlinux.lds.S
+++ b/arch/parisc/kernel/vmlinux.lds.S
@@ -52,15 +52,15 @@ SECTIONS
        _text = .;              /* Text and read-only data */
        .text ALIGN(16) : {
                HEAD_TEXT
+               *(.text.do_softirq)
+               *(.text.sys_exit)
+               *(.text.do_sigaltstack)
+               *(.text.do_fork)
                TEXT_TEXT
                SCHED_TEXT
                LOCK_TEXT
                KPROBES_TEXT
                IRQENTRY_TEXT
-               *(.text.do_softirq)
-               *(.text.sys_exit)
-               *(.text.do_sigaltstack)
-               *(.text.do_fork)
                *(.text.*)
                *(.fixup)
                *(.lock.text)           /* out-of-line lock text */


