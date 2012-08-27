Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753156Ab2H0Kj0 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Aug 2012 06:39:26 -0400
Received: from e06smtp17.uk.ibm.com ([195.75.94.113]:56308 "EHLO
	e06smtp17.uk.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752153Ab2H0KjZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Aug 2012 06:39:25 -0400
Date: Mon, 27 Aug 2012 12:39:17 +0200
From: Gerald Schaefer <gerald.schaefer@de.ibm.com>
To: Hillf Danton <dhillf@gmail.com>
Cc: akpm@linux-foundation.org, aarcange@redhat.com, linux-mm@kvack.org,
        ak@linux.intel.com, hughd@google.com, linux-kernel@vger.kernel.org,
        schwidefsky@de.ibm.com, heiko.carstens@de.ibm.com
Subject: Re: [RFC patch 3/7] thp: make MADV_HUGEPAGE check for mm->def_flags
Message-ID: <20120827123917.3313dfda@thinkpad>
In-Reply-To: <CAJd=RBBJa934R53AHYVhkxE+2e=RiKU1zJXsLMCBFw_NHZE0oQ@mail.gmail.com>
References: <20120823171733.595087166@de.ibm.com>
	<20120823171854.580076595@de.ibm.com>
	<CAJd=RBBJa934R53AHYVhkxE+2e=RiKU1zJXsLMCBFw_NHZE0oQ@mail.gmail.com>
Reply-To: gerald.schaefer@de.ibm.com
X-Mailer: Claws Mail 3.7.9 (GTK+ 2.24.6; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
x-cbid: 12082710-0542-0000-0000-000002D7C8C4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 25 Aug 2012 20:47:37 +0800
Hillf Danton <dhillf@gmail.com> wrote:

> On Fri, Aug 24, 2012 at 1:17 AM, Gerald Schaefer
> <gerald.schaefer@de.ibm.com> wrote:
> > This adds a check to hugepage_madvise(), to refuse MADV_HUGEPAGE
> > if VM_NOHUGEPAGE is set in mm->def_flags. On System z, the VM_NOHUGEPAGE
> > flag will be set in mm->def_flags for kvm processes, to prevent any
> > future thp mappings. In order to also prevent MADV_HUGEPAGE on such an
> > mm, hugepage_madvise() should check mm->def_flags.
> >
> > Signed-off-by: Gerald Schaefer <gerald.schaefer@de.ibm.com>
> > ---
> >  mm/huge_memory.c |    4 ++++
> >  1 file changed, 4 insertions(+)
> >
> > --- a/mm/huge_memory.c
> > +++ b/mm/huge_memory.c
> > @@ -1464,6 +1464,8 @@ out:
> >  int hugepage_madvise(struct vm_area_struct *vma,
> >                      unsigned long *vm_flags, int advice)
> >  {
> > +       struct mm_struct *mm = vma->vm_mm;
> > +
> >         switch (advice) {
> >         case MADV_HUGEPAGE:
> >                 /*
> > @@ -1471,6 +1473,8 @@ int hugepage_madvise(struct vm_area_stru
> >                  */
> >                 if (*vm_flags & (VM_HUGEPAGE | VM_NO_THP))
> >                         return -EINVAL;
> > +               if (mm->def_flags & VM_NOHUGEPAGE)
> > +                       return -EINVAL;
> 
> Looks ifdefinery needed for s390 to wrap the added check, and
> a brief comment?

Hmm, architecture #ifdefs in common code are ugly. I'd rather keep
the check even if it is redundant right now for other architectures
than s390. It is not a performance critical path, and there may be
other users of that in the future.

