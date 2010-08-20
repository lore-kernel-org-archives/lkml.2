Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752514Ab0HTUfx (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Aug 2010 16:35:53 -0400
Received: from 1wt.eu ([62.212.114.60]:41766 "EHLO 1wt.eu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751164Ab0HTUfv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Aug 2010 16:35:51 -0400
Date: Fri, 20 Aug 2010 22:34:56 +0200
From: Willy Tarreau <w@1wt.eu>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Ian Campbell <ijc@hellion.org.uk>, Greg KH <gregkh@suse.de>,
        linux-kernel@vger.kernel.org, stable@kernel.org,
        akpm@linux-foundation.org, stable-review@kernel.org,
        alan@lxorguk.ukuu.org.uk
Subject: Re: [Stable-review] [2/3] mm: fix up some user-visible effects of the stack guard page
Message-ID: <20100820203456.GC32620@1wt.eu>
References: <20100818203143.735033743@clark.site> <1282308887.3170.5439.camel@zakaz.uk.xensource.com> <AANLkTin7L=v1GR2=U-mvESyrP2vySYLRa4U-fh9-L38F@mail.gmail.com> <AANLkTim1ABgiwscmaTZxeO9FxB4FacUNe0ahzUctQkn6@mail.gmail.com> <AANLkTinqUa6qwFKCjG0ww7Rq4ath0LtNH5yuMNOai=Z7@mail.gmail.com> <1282326182.29609.789.camel@localhost.localdomain> <AANLkTi=racCPiDmbL0pEfH3Ew2_gJzJwmR3B1Vt=AZuz@mail.gmail.com> <AANLkTimTZKzXfBJCbzCyq3LwKvn3aCqyHjd5VXhnejfV@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <AANLkTimTZKzXfBJCbzCyq3LwKvn3aCqyHjd5VXhnejfV@mail.gmail.com>
User-Agent: Mutt/1.4.2.3i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Aug 20, 2010 at 12:43:28PM -0700, Linus Torvalds wrote:
> So switching it to the "<linux/list.h>" kind of accessors would be a major pain.
> 
> There's also lots of really ugly code that is all about the "we can't
> easily get to the 'prev' entry in the list". Stuff that would be
> cleaned up if we just had a vm_prev, but where the cleanups is just
> pretty painful.
> 
> > And it would be trivial to change the loops like
> >
> >    for (vma = mm->mmap; vma; vma = vma->vm_next)
> >
> > into basically just
> >
> >   list_for_each_entry(vma, &mm->mmap, vm_list)
> 
> Yeah, no. It looks like adding a "vm_prev" and doing a regular doubly
> linked list thing wouldn't be too bad. But switching over to the
> list.h version looks like a nightmare.
> 
> Too bad.

I've had to convert normal linked lists to a dual linked list for a project
of mine in the past, and for the same reason I could not use the lists how
we use them in Linux. However I found an interesting tradeoff which consists
in having only the ->prev list circular but keep the ->next one null-
terminated.

In the end, the API is not much different. A few tests just on the ->next
pointer at some places, but you can still use ->prev everywhere to find
the list tail, for inserting and removing. And overall that was pretty
convenient. It was a lot better than the simple linked list and almost
as easy to use as the circular ones.

Just my 2 cents,
Willy

