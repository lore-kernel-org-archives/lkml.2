Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752515Ab0HVTJk (ORCPT <rfc822;w@1wt.eu>);
	Sun, 22 Aug 2010 15:09:40 -0400
Received: from cantor2.suse.de ([195.135.220.15]:42658 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750882Ab0HVTJi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 22 Aug 2010 15:09:38 -0400
Date: Sun, 22 Aug 2010 12:04:04 -0700
From: Greg KH <gregkh@suse.de>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Ian Campbell <ijc@hellion.org.uk>, linux-kernel@vger.kernel.org,
        stable@kernel.org, stable-review@kernel.org, akpm@linux-foundation.org,
        alan@lxorguk.ukuu.org.uk, Peter Zijlstra <peterz@infradead.org>,
        Jeremy Fitzhardinge <jeremy@goop.org>
Subject: Re: [RFC] mlock/stack guard interaction fixup
Message-ID: <20100822190404.GA12445@suse.de>
References: <AANLkTimuP9cFvd4pfqy6=vixSMdagrSEv1-VLNAEuWgr@mail.gmail.com> <1282391770.29609.1223.camel@localhost.localdomain> <AANLkTimYnfewBCDNYXZHxbcX=TRE__Cu07_FFK_kAK2h@mail.gmail.com> <1282460275.11348.865.camel@localhost.localdomain> <1282462386.11348.871.camel@localhost.localdomain> <1282470917.11348.891.camel@localhost.localdomain> <20100822172548.GB8957@suse.de> <AANLkTi=wWcAg8MdWy4O-0au3m6mH+9xWDOKVCJ_x5G_v@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <AANLkTi=wWcAg8MdWy4O-0au3m6mH+9xWDOKVCJ_x5G_v@mail.gmail.com>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Aug 22, 2010 at 11:21:34AM -0700, Linus Torvalds wrote:
> On Sun, Aug 22, 2010 at 10:25 AM, Greg KH <gregkh@suse.de> wrote:
> >>
> >> Greg, we are talking about:
> >> 0e8e50e20c837eeec8323bba7dcd25fe5479194c mm: make stack guard page logic use vm_prev pointer
> >> 7798330ac8114c731cfab83e634c6ecedaa233d7 mm: make the mlock() stack guard page checks stricter
> >> 297c5eee372478fc32fec5fe8eed711eedb13f3d mm: make the vma list be doubly linked
> >
> > I must be missing something, but aren't these patches just "cleanups"
> > and changing the logic here to be nicer? ?Or do they fix real problems
> > with the previous stack guard stuff?
> >
> > Is it the second one you really need here?
> 
> They're all "required" (#2 needs #1, and #3 is a fix for something
> that can happen in the same circumstances that #2 makes any
> difference).

Ok, thanks.

> Although you do need to have some really odd things going on for any
> of them to make any difference. Notably, you need to do mlock or
> mprotect on the stack segment, which no sane program does.
> 
> That said, the change from
> 
>     start += PAGE_SIZE;
> 
> to
> 
>     addr += PAGE_SIZE;
> 
> in __mlock_vma_pages_range() (in #3) is a bugfix even for the normal
> mlockall() case. Not that anybody will realistically care about that
> either: the failure case just doesn't really realistically ever matter
> (it expands the stack which the code tries to avoid, and possibly
> forgets to mlock the bottom of the stack).
> 
> So I wouldn't call them high priority. Ian is doing something _really_
> odd. Doing hypercalls from user space on stuff that is on the stack,
> rather than just copying it to some stable area is dodgy. And I
> guarantee that doing the crazy mlock dance is slower than the copy, so
> it's complex, fragile, _and_ slow.

Heh, ok, I'll not worry about this for the .27 kernel then, that makes
it a lot easier for me :)

thanks,

greg k-h
