Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753821Ab0HWRkm (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Aug 2010 13:40:42 -0400
Received: from casper.infradead.org ([85.118.1.10]:34563 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752964Ab0HWRkk convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Aug 2010 13:40:40 -0400
Subject: Re: [RFC] mlock/stack guard interaction fixup
From: Peter Zijlstra <peterz@infradead.org>
To: Ian Jackson <ijackson@chiark.greenend.org.uk>
Cc: Linus Torvalds <torvalds@linux-foundation.org>, Greg KH <gregkh@suse.de>,
        Ian Campbell <ijc@hellion.org.uk>, linux-kernel@vger.kernel.org,
        stable@kernel.org, stable-review@kernel.org, akpm@linux-foundation.org,
        alan@lxorguk.ukuu.org.uk, Jeremy Fitzhardinge <jeremy@goop.org>
In-Reply-To: <19570.44367.719276.128881@chiark.greenend.org.uk>
References: <AANLkTimuP9cFvd4pfqy6=vixSMdagrSEv1-VLNAEuWgr@mail.gmail.com>
	 <1282391770.29609.1223.camel@localhost.localdomain>
	 <AANLkTimYnfewBCDNYXZHxbcX=TRE__Cu07_FFK_kAK2h@mail.gmail.com>
	 <1282460275.11348.865.camel@localhost.localdomain>
	 <1282462386.11348.871.camel@localhost.localdomain>
	 <1282470917.11348.891.camel@localhost.localdomain>
	 <20100822172548.GB8957@suse.de>
	 <AANLkTi=wWcAg8MdWy4O-0au3m6mH+9xWDOKVCJ_x5G_v@mail.gmail.com>
	 <19570.38608.79434.179797@chiark.greenend.org.uk>
	 <1282580751.2605.1997.camel@laptop>
	 <19570.44367.719276.128881@chiark.greenend.org.uk>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
Date: Mon, 23 Aug 2010 19:40:21 +0200
Message-ID: <1282585221.2605.2088.camel@laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2010-08-23 at 18:18 +0100, Ian Jackson wrote:
> Peter Zijlstra writes ("Re: [RFC] mlock/stack guard interaction fixup"):
> > On Mon, 2010-08-23 at 16:42 +0100, ijackson@chiark.greenend.org.uk
> > wrote:
> > > mlocking the stack is entirely sensible and normal for a real-time
> > > program.  Most such programs use mlockall but there is no particular
> > > reason why a program that has some more specific requirements should
> > > use mlock to lock only a part of the stack.  (Perhaps it has only one
> > > real-time thread?) 
> > 
> > RT apps should pre-allocate and mlock their stack in advance (and
> > pre-fault too for the paranoid).
> 
> Are you allowed to mlock a stack page which has not yet been faulted
> in ?  What effect does it have ?  I wasn't able to find a convincing
> de jure answer to this question.

mlock() seems to call make_pages_present(), so its a moot point.

> But you seem, like me, to be disagreeing with Linus's assertion that
> calling mlock() on the stack is something no sane programs does ?

I think the case that Linus called daft is splitting the stack vma
through mlock/mprotect, which is indeed something rarely done.

> > mlockall is a very bad interface and should really not be used.
> 
> You are directly contradicting the advice in SuS, to which I just gave
> a reference.  You're free to do so of course but it might be worth
> explaining in a bit more detail why the advice in SuS is wrong.

Because a real RT program will have a significant !RT part, and calling
mlock on everything is a massive resource waste.

Furthermore, mlockall gives the false impression that everything is good
to go for RT, disregarding pretty much everything that makes a RT app.

There's lots more to RT than sched_setscheduler() and
mlockall(MCL_FUTURE).

If a library is RT suited, it will already mlock() all relevant memory
allocations (or provide an option to do so, or strictly work on
externally allocated memory, which the user will then have mlock()'ed).


