Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753638Ab0HTToU (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Aug 2010 15:44:20 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:56699 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751905Ab0HTToS convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Aug 2010 15:44:18 -0400
MIME-Version: 1.0
In-Reply-To: <AANLkTi=racCPiDmbL0pEfH3Ew2_gJzJwmR3B1Vt=AZuz@mail.gmail.com>
References: <20100818203143.735033743@clark.site> <1282308887.3170.5439.camel@zakaz.uk.xensource.com>
 <AANLkTin7L=v1GR2=U-mvESyrP2vySYLRa4U-fh9-L38F@mail.gmail.com>
 <AANLkTim1ABgiwscmaTZxeO9FxB4FacUNe0ahzUctQkn6@mail.gmail.com>
 <AANLkTinqUa6qwFKCjG0ww7Rq4ath0LtNH5yuMNOai=Z7@mail.gmail.com>
 <1282326182.29609.789.camel@localhost.localdomain> <AANLkTi=racCPiDmbL0pEfH3Ew2_gJzJwmR3B1Vt=AZuz@mail.gmail.com>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Fri, 20 Aug 2010 12:43:28 -0700
Message-ID: <AANLkTimTZKzXfBJCbzCyq3LwKvn3aCqyHjd5VXhnejfV@mail.gmail.com>
Subject: Re: [2/3] mm: fix up some user-visible effects of the stack guard page
To: Ian Campbell <ijc@hellion.org.uk>
Cc: linux-kernel@vger.kernel.org, stable@kernel.org, stable-review@kernel.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Greg KH <gregkh@suse.de>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Aug 20, 2010 at 11:59 AM, Linus Torvalds
<torvalds@linux-foundation.org> wrote:
>
> It should be a pretty straightforward search-and-replace. And almost
> all of it would be real cleanups.

I take that back. Cleanups - probably. Simple search-and-replace? No.
That vm_next thing is all over the place, and all of the code knows
that the last vma has a vm_next that is NULL.

So switching it to the "<linux/list.h>" kind of accessors would be a major pain.

There's also lots of really ugly code that is all about the "we can't
easily get to the 'prev' entry in the list". Stuff that would be
cleaned up if we just had a vm_prev, but where the cleanups is just
pretty painful.

> And it would be trivial to change the loops like
>
>    for (vma = mm->mmap; vma; vma = vma->vm_next)
>
> into basically just
>
>   list_for_each_entry(vma, &mm->mmap, vm_list)

Yeah, no. It looks like adding a "vm_prev" and doing a regular doubly
linked list thing wouldn't be too bad. But switching over to the
list.h version looks like a nightmare.

Too bad.

                  Linus
