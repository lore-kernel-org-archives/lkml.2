Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753375Ab2KUBxI (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Nov 2012 20:53:08 -0500
Received: from zeniv.linux.org.uk ([195.92.253.2]:38776 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752312Ab2KUBxG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Nov 2012 20:53:06 -0500
Date: Wed, 21 Nov 2012 01:53:02 +0000
From: Al Viro <viro@ZenIV.linux.org.uk>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Michal Simek <monstr@monstr.eu>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        "linux-arch@vger.kernel.org" <linux-arch@vger.kernel.org>
Subject: Re: sigaltstack fun (was Re: new execve/kernel_thread design)
Message-ID: <20121121015302.GQ16916@ZenIV.linux.org.uk>
References: <20121016223508.GR2616@ZenIV.linux.org.uk>
 <CACM3HyEpypULRWUc5ZnLnZ=uOWf3_j=9PXZiJrT_BXyGcQe9yg@mail.gmail.com>
 <CAHTX3dKDsOiUwtXxAUj-F4Y4rO+UZZDR4ufx_nxf+vuhmz46WA@mail.gmail.com>
 <20121017160702.GY2616@ZenIV.linux.org.uk>
 <20121017161953.GZ2616@ZenIV.linux.org.uk>
 <CAHTX3dJN4Jun2KVXpda1wTrwkjT0mmH4fYmUUwq69d9sCTjXnA@mail.gmail.com>
 <20121115215529.GU2616@ZenIV.linux.org.uk>
 <CAHTX3d+Ou3_4tGqwyWFfNMSumPw2770_nhV_cTQa89k7+sxdHw@mail.gmail.com>
 <20121118054510.GE16916@ZenIV.linux.org.uk>
 <CA+55aFxncW2pEhsjg0AO9YKyvPaHyiXZMjoJZ1J8gA+8sH7HNw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CA+55aFxncW2pEhsjg0AO9YKyvPaHyiXZMjoJZ1J8gA+8sH7HNw@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Nov 18, 2012 at 08:45:43AM -1000, Linus Torvalds wrote:
> On Sat, Nov 17, 2012 at 7:45 PM, Al Viro <viro@zeniv.linux.org.uk> wrote:
> >
> > Linus, do you have any objections to the above?  FWIW, I've a tentative
> > patchset in that direction (most of it from the last cycle); right now
> > it + stuff currently in signal.git#for-next is at -3.4KLoC and I hadn't
> > dealt with the biarch side of things yet...
> 
> I have absolutely no objections. sigaltstack has always been kind of
> messy, and made worse by the fact that it gets effectively no testing
> (because it's generally not used by normal code and even code that
> uses it tends to use it only for very uncommon events). So forcing all
> the sigaltstack code into generic code and at least avoiding the
> "different architectures can get things subtly - or not so subtly -
> wrong in different ways" sounds like a good thing.

OK...  Intermediate state (do_sigaltstack() guts still need to be cleaned up
and distributed between the 4 callers) is in signal.git#master right now;
_not_ for merge in that form.  Crap found in process:
	* microblaze, sparc64 and tile (compat side) have the same bug (see
above).  Fixed in that queue.
	* score, sh64 and openrisc all tried call do do_sigaltstack() passing
it an address of on-stack copy; no, set_fs() was not used.  Fixed in that queue.
	* alpha and c6x do not bother to restore saved altstack settings on
sigreturn.
	* c6x, cris and hexagon don't bother *saving* altstack settings on
signal arrival.  And yes, it does mean that cris and hexagon call
do_sigaltstack() on an unitialized chunk of userland stack.  Needs to be
fixed (and in a way that could go into -stable, unfortunately ;-/)

I hadn't done anything serious with altstack users yet; I'm afraid that
this code (i.e. sigframe allocation logics) will also bring a lot of
fun weirdness... ;-/
