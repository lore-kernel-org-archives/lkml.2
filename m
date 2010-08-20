Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753372Ab0HTTBN (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Aug 2010 15:01:13 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:48359 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753235Ab0HTTBH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Aug 2010 15:01:07 -0400
MIME-Version: 1.0
In-Reply-To: <1282326182.29609.789.camel@localhost.localdomain>
References: <20100818203143.735033743@clark.site> <1282308887.3170.5439.camel@zakaz.uk.xensource.com>
 <AANLkTin7L=v1GR2=U-mvESyrP2vySYLRa4U-fh9-L38F@mail.gmail.com>
 <AANLkTim1ABgiwscmaTZxeO9FxB4FacUNe0ahzUctQkn6@mail.gmail.com>
 <AANLkTinqUa6qwFKCjG0ww7Rq4ath0LtNH5yuMNOai=Z7@mail.gmail.com> <1282326182.29609.789.camel@localhost.localdomain>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Fri, 20 Aug 2010 11:59:41 -0700
Message-ID: <AANLkTi=racCPiDmbL0pEfH3Ew2_gJzJwmR3B1Vt=AZuz@mail.gmail.com>
Subject: Re: [2/3] mm: fix up some user-visible effects of the stack guard page
To: Ian Campbell <ijc@hellion.org.uk>
Cc: linux-kernel@vger.kernel.org, stable@kernel.org, stable-review@kernel.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Greg KH <gregkh@suse.de>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Aug 20, 2010 at 10:43 AM, Ian Campbell <ijc@hellion.org.uk> wrote:
>
> If we could easily get at the previous VMA (instead of just the next
> one) then we could easily check if we were mlocking a VM_GROWSDOWN
> region which had another VM_GROWSDOWN region immediately below it and
> therefore avoid introducing a guard page at the boundary. Doing this
> check is currently too expensive because of the need to use
> find_vma_prev. Is that right?

Exactly.

> It does look like a big task, but if it seems like the only sane option
> I'll take a look at it and see if can be broken down into manageable
> stages.

It should be a pretty straightforward search-and-replace. And almost
all of it would be real cleanups.

And it would be trivial to change the loops like

    for (vma = mm->mmap; vma; vma = vma->vm_next)

into basically just

   list_for_each_entry(vma, &mm->mmap, vm_list)

etc.

> You mentioned making this a tunable in your original commit message,
> that would at least help in the short term so I may look into that too.
> (prctl would be the right interface?)

I'm not convinced a tunable is really the right thing, but in this
case it might be acceptable, since you really are doing something
rather specific and odd. Changing the VM to use doubly-linked lists
would be a lot _cleaner_, though.

> I wonder if there's any way to auto tune, for example automatically
> disabling the guard page for a process which mlocks only part of its
> stack VMA. That would obviously target the specific issue I'm seeing
> pretty directly and would only reopen the hole for applications which
> were already doing odd things (c.f. your earlier comment about the guard
> page not being magic or helping with wilfully crazy userspace).

I'd really hate to try to do something subtle that doesn't have
obvious semantics. Subtle code is buggy code. Maybe not today, but two
years from now..

                     Linus
