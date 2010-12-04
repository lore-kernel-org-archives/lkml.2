Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755455Ab0LDO5v (ORCPT <rfc822;w@1wt.eu>);
	Sat, 4 Dec 2010 09:57:51 -0500
Received: from mail-pv0-f174.google.com ([74.125.83.174]:42810 "EHLO
	mail-pv0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754336Ab0LDO5u (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 4 Dec 2010 09:57:50 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=tnPp3IFGJyr5tiFYObHIy6DV5s+hdfRf0YQqvoWUxaZpAdiVsRzIF/TdODaEaw6dB+
         GIJtizUggMbK3JY1V0ewwTFEPP0GADsj5DoflHfNj0TlbVYTUqibBF222j5rfkhv3bok
         Eoib7G9OgQyob8TgTRb3INX3LzOq7S9yTfj9w=
Date: Sat, 4 Dec 2010 23:57:40 +0900
From: Minchan Kim <minchan.kim@gmail.com>
To: Oleg Nesterov <oleg@redhat.com>
Cc: Roland McGrath <roland@redhat.com>, michal.simek@petalogix.com,
        Andrew Morton <akpm@linux-foundation.org>,
        LKML <linux-kernel@vger.kernel.org>, linux-mm@kvack.org,
        John Williams <john.williams@petalogix.com>,
        "Edgar E. Iglesias" <edgar.iglesias@gmail.com>,
        Hugh Dickins <hughd@google.com>, Nick Piggin <npiggin@kernel.dk>
Subject: Re: Flushing whole page instead of work for ptrace
Message-ID: <20101204145740.GA1725@barrios-desktop>
References: <4CEFA8AE.2090804@petalogix.com>
 <20101130233250.35603401C8@magilla.sf.frob.com>
 <20101203150021.GA11114@redhat.com>
 <20101203162817.GA21438@barrios-desktop>
 <20101203170712.GA16642@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20101203170712.GA16642@redhat.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Dec 03, 2010 at 06:07:12PM +0100, Oleg Nesterov wrote:
> On 12/04, Minchan Kim wrote:
> >
> > On Fri, Dec 03, 2010 at 04:00:21PM +0100, Oleg Nesterov wrote:
> > > On 11/30, Roland McGrath wrote:
> > > >
> > > > Documentation/cachetlb.txt says:
> > > >
> > > > 	Any time the kernel writes to a page cache page, _OR_
> > > > 	the kernel is about to read from a page cache page and
> > > > 	user space shared/writable mappings of this page potentially
> > > > 	exist, this routine is called.
> > > >
> > > > In your case, the kernel is only reading (write=0 passed to
> > > > access_process_vm and get_user_pages).  In normal situations,
> > > > the page in question will have only a private and read-only
> > > > mapping in user space.  So the call should not be required in
> > > > these cases--if the code can tell that's so.
> > > >
> > > > Perhaps something like the following would be safe.
> > > > But you really need some VM folks to tell you for sure.
> > > >
> > > > diff --git a/mm/memory.c b/mm/memory.c
> > > > index 02e48aa..2864ee7 100644
> > > > --- a/mm/memory.c
> > > > +++ b/mm/memory.c
> > > > @@ -1484,7 +1484,8 @@ int __get_user_pages(struct task_struct *tsk, struct mm_struct *mm,
> > > >  				pages[i] = page;
> > > >
> > > >  				flush_anon_page(vma, page, start);
> > > > -				flush_dcache_page(page);
> > > > +				if ((vm_flags & VM_WRITE) || (vma->vm_flags & VM_SHARED)
> > > > +					flush_dcache_page(page);
> > >
> > > First of all, I know absolutely nothing about D-cache aliasing.
> > > My poor understanding of flush_dcache_page() is: synchronize the
> > > kernel/user vision of this memory, in the case when either side
> > > can change it.
> > >
> > > If this is true, then this change doesn't look right in general.
> > >
> > > Even if (vma->vm_flags & VM_SHARED) == 0, it is possible that
> > > tsk can write to this memory, this mapping can be writable and
> > > private.
> > >
> > > Even if we ensure that this mapping is readonly/private, another
> > > user-space process can write to this page via shared/writable
> > > mapping.
> > >
> >
> > I think you're right. It has a portential that other processes have
> > a such mapping.
> >
> > >
> > > I'd like to know if my understanding is correct, I am just curious.
> > >
> > > Oleg.
> >
> > How about this?
> > Maybe this patch would mitigate the overhead.
> > But I am not sure this patch. Cced GUP experts.
> >
> > From 8fb3d84c7bb32c4ba9c4a0063198ce7cfcca6b37 Mon Sep 17 00:00:00 2001
> > From: Minchan Kim <minchan.kim@gmail.com>
> > Date: Sat, 4 Dec 2010 01:19:43 +0900
> > Subject: [PATCH] Remove redundant flush_dcache_page in GUP
> >
> > If we get the page with handle_mm_fault, it already handled
> > page flush. So GUP's flush_dcache_page call is redundant.
> 
> Oh, I am not sure. Say, do_wp_page() can only clear !pte_write(),
> but let me remind I do not understand this magic.

You're right. I missed that.
In dirty/young bit emulation arch, it doesn't call flush_dcache_page.

> 
> However, evem if this change is correct, I am not sure it can solve
> the original problem. Debugger issues a lot of short reads, I don't
> think follow_page() fails that often.

Absolutely. I was in a hurry.
Anyway, It's a interesting. I agree whole page flush for just short
some bytes is overkill. But in concept of VM, page flush of GUP is right.

Do we really need new interface for this problem?
It avoids page flush and just returns the page which includes data for ptrace.
Then, arch_ptrace have to flush the data(page or bytes) before some operation(ex, copy)

It makes ptrace code very ugly.
Hmm.. Sorry, I don't have no idea.

-- 
Kind regards,
Minchan Kim
