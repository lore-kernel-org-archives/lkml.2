Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759512Ab2AMXjx (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Jan 2012 18:39:53 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:55431 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759463Ab2AMXjw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Jan 2012 18:39:52 -0500
Date: Fri, 13 Jan 2012 15:39:50 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Hillf Danton <dhillf@gmail.com>
Cc: Michal Hocko <mhocko@suse.cz>, linux-mm@kvack.org,
        LKML <linux-kernel@vger.kernel.org>,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Subject: Re: [PATCH] mm: hugetlb: undo change to page mapcount in fault
 handler
Message-Id: <20120113153950.7426eee2.akpm@linux-foundation.org>
In-Reply-To: <CAJd=RBDOn22=CAFcEx9try8onsaHsweny_B1ZvnGJO-0h7eZAQ@mail.gmail.com>
References: <CAJd=RBBF=K5hHvEwb6uwZJwS4=jHKBCNYBTJq-pSbJ9j_ZaiaA@mail.gmail.com>
	<20111222163604.GB14983@tiehlicka.suse.cz>
	<CAJd=RBBY0sKdtdx9d8KXTchjaN6au0_hvMfE2+9JkdhvJe7eAw@mail.gmail.com>
	<20120104151632.05e6b3b0.akpm@linux-foundation.org>
	<CAJd=RBDOn22=CAFcEx9try8onsaHsweny_B1ZvnGJO-0h7eZAQ@mail.gmail.com>
X-Mailer: Sylpheed 3.0.2 (GTK+ 2.20.1; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 11 Jan 2012 20:06:30 +0800
Hillf Danton <dhillf@gmail.com> wrote:

> On Thu, Jan 5, 2012 at 7:16 AM, Andrew Morton <akpm@linux-foundation.org> wrote:
> > On Fri, 23 Dec 2011 21:00:41 +0800
> > Hillf Danton <dhillf@gmail.com> wrote:
> >
> >> Page mapcount should be updated only if we are sure that the page ends
> >> up in the page table otherwise we would leak if we couldn't COW due to
> >> reservations or if idx is out of bounds.
> >
> > It would be much nicer if we could run vma_needs_reservation() before
> > even looking up or allocating the page.
> >
> > And afaict the interface is set up to do that: you run
> > vma_needs_reservation() before allocating the page and then
> > vma_commit_reservation() afterwards.
> >
> > But hugetlb_no_page() and hugetlb_fault() appear to have forgotten to
> > run vma_commit_reservation() altogether. __Why isn't this as busted as
> > it appears to be?
> 
> Hi Andrew
> 
> IIUC the two operations, vma_{needs, commit}_reservation, are folded in
> alloc_huge_page(), need to break the pair?

Looking at it again, it appears that the vma_needs_reservation() calls
are used to predict whether a subsequent COW attempt is going to fail.

If that's correct then things aren't as bad as I first thought. 
However I suspect the code in hugetlb_no_page() is a bit racy: the
vma_needs_reservation() call should happen after we've taken
page_table_lock.  As things stand, another thread could sneak in there
and steal the reservation which this thread thought was safe.

What do you think?

