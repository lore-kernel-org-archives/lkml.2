Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756817Ab2JRV2k (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Oct 2012 17:28:40 -0400
Received: from mail-lb0-f174.google.com ([209.85.217.174]:45702 "EHLO
	mail-lb0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752080Ab2JRV2j (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Oct 2012 17:28:39 -0400
Date: Fri, 19 Oct 2012 01:28:35 +0400
From: Cyrill Gorcunov <gorcunov@openvz.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: LKML <linux-kernel@vger.kernel.org>, Pavel Emelyanov <xemul@parallels.com>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>
Subject: Re: [RFC] procfs: Add VmFlags field in smaps output
Message-ID: <20121018212835.GK8790@moon>
References: <20121018095503.GB8790@moon>
 <20121018103118.GC11750@moon>
 <20121018140259.dad6d5b5.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20121018140259.dad6d5b5.akpm@linux-foundation.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Oct 18, 2012 at 02:02:59PM -0700, Andrew Morton wrote:
> > +#ifdef CONFIG_CHECKPOINT_RESTORE
> > +static void show_smap_vma_flags(struct seq_file *m, struct vm_area_struct *vma)
> > +{
> > +	seq_printf(m,
> > +		   "VmFlags:               %c%c%c%c%c%c%c%c%c\n",
> > +		   vma->vm_flags & VM_LOCKED ?		'l' : '-',
> > +		   vma->vm_flags & VM_GROWSDOWN ?	'g' : '-',
> > +		   vma->vm_flags & VM_RAND_READ ?	'r' : '-',
> > +		   vma->vm_flags & VM_SEQ_READ ?	'q' : '-',
> > +		   vma->vm_flags & VM_DONTCOPY ?	'-' : 'c',
> > +		   vma->vm_flags & VM_MERGEABLE ?	'm' : '-',
> > +		   vma->vm_flags & VM_HUGEPAGE ?	'h' : '-',
> > +		   vma->vm_flags & VM_NOHUGEPAGE ?	'-' : 'h',
> > +		   vma->vm_flags & VM_DONTDUMP ?	'-' : 'd');
> > +}
> > +#else
> > +static void show_smap_vma_flags(struct seq_file *m, struct vm_area_struct *vma) { }
> > +#endif
> 
> I guess this more terse output is better.  It should be documented (in

Well, I started with terse output but then I thought that if one day
some flag get vanished we will have to remember which character has been
used for it to not reassign it to some new flag in future. That's from where
this long words came.

> Documentation/filesystems/proc.txt, I suppose) and we should add a code
> comment here reminding people to update that documentation when they
> change this function.

Sure, thanks for reminder Andrew, I must admit I forgot about docs.

> There are about 28 VM_foo flags and here you've semi-randomly chosen 9
> of them for display.  This seems rather ugly and we should expect that

Yes, but I choose only those flags which can be used/modified from user
space and which can't be fetched by other way (for example we can figure
out if vma is executable/shared/private from /proc/pid/map).

Thus I think better try to not display flags which are pretty kernel
internal, no?

> people will change this code to display additional flags in the future.
> 
> And we should also expect some of the flags which _are_ displayed to
> vanish in the future as the code evolves.
> 
> This data is pretty dependent upon internal kernel implementation
> details, so it is something we normally try to avoid exporting to
> userspace.

Yes, but I fear here I have no choise. These flags modify the kernel
behaviour and they are set from userspace (mlock/madvise) so we need
some way to fetch them back and do yield appropriate syscalls on
restore procedure.

> We should design the interface with these future changes in mind.  That
> means careful documentation and perhaps a format which discourages
> userspace programmers from assuming that there will always be nine
> fields.
> 
> A common way in which we do this future-proofing is to display the info
> in name:value tuples (eg, /proc/meminfo).  So userspace parses for the
> "name" rather than looking into a fixed position in the /proc output.
> 
> So....  with this thought in mind, perhaps a better output format would
> be something like:
> 
> 	VmFlags: LO:1 GR:0 RA:0 SE:1 ...
> 
> ie: a two-character "name" and a boolean "value".  Something like that.

OK, Andrew, I'll try to come with something like that tomorrow, thanks!

> Also, it worries me a bit that this interface vanishes if
> CONFIG_CHECKPOINT_RESTORE=n.  One can easily anticipate that non-c/r
> userspace programs will start to use this interface, and they will want
> it to be present in CONFIG_CHECKPOINT_RESTORE=n kernels.

Well, hard to tell, I personally can't imagine who else and why might
need this flags, but there is no problem to drop this CONFIG wrap if
needed.
