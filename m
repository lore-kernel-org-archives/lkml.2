Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932624Ab2JRVDD (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Oct 2012 17:03:03 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:40154 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756176Ab2JRVDA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Oct 2012 17:03:00 -0400
Date: Thu, 18 Oct 2012 14:02:59 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Cyrill Gorcunov <gorcunov@openvz.org>
Cc: LKML <linux-kernel@vger.kernel.org>, Pavel Emelyanov <xemul@parallels.com>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>
Subject: Re: [RFC] procfs: Add VmFlags field in smaps output
Message-Id: <20121018140259.dad6d5b5.akpm@linux-foundation.org>
In-Reply-To: <20121018103118.GC11750@moon>
References: <20121018095503.GB8790@moon>
	<20121018103118.GC11750@moon>
X-Mailer: Sylpheed 3.0.2 (GTK+ 2.20.1; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 18 Oct 2012 14:31:18 +0400
Cyrill Gorcunov <gorcunov@openvz.org> wrote:

> On Thu, Oct 18, 2012 at 01:55:03PM +0400, Cyrill Gorcunov wrote:
> > Hi guys, in a sake of c/r we need to fetch additional
> > VMA characteristics, so I though would /proc/pid/smaps
> > be appropriate place for it? If yes, I would like to
> > know if the output format provided below looks reasonable.
> > 
> > Please review, thanks!
> > ---
> 
> Also I've had a bit different output format, not sure
> which one is better.
> ---
> From: Cyrill Gorcunov <gorcunov@openvz.org>
> Subject: [RFC] procfs: Add VmFlags field in smaps output
> 
> When we do restore VMA area after checkpoint
> we would like to know if the area was locked
> or say it has mergeable attribute, but at moment
> the kernel does not provide such information, thus
> we can't figure out if we should call mlock/madvise
> on VMA restore.
> 
> This patch adds new VmFlags field to smaps output
> with vma->vm_flags encoded.
> 
> This field is CONFIG_CHECKPOINT_RESTORE dependent
> since at moment I don't know if someone else might
> need it.
> 
> Signed-off-by: Cyrill Gorcunov <gorcunov@openvz.org>
> CC: Pavel Emelyanov <xemul@parallels.com>
> CC: Andrew Morton <akpm@linux-foundation.org>
> CC: Peter Zijlstra <a.p.zijlstra@chello.nl>
> ---
>  fs/proc/task_mmu.c |   21 +++++++++++++++++++++
>  1 file changed, 21 insertions(+)
> 
> Index: linux-2.6.git/fs/proc/task_mmu.c
> ===================================================================
> --- linux-2.6.git.orig/fs/proc/task_mmu.c
> +++ linux-2.6.git/fs/proc/task_mmu.c
> @@ -480,6 +480,25 @@ static int smaps_pte_range(pmd_t *pmd, u
>  	return 0;
>  }
>  
> +#ifdef CONFIG_CHECKPOINT_RESTORE
> +static void show_smap_vma_flags(struct seq_file *m, struct vm_area_struct *vma)
> +{
> +	seq_printf(m,
> +		   "VmFlags:               %c%c%c%c%c%c%c%c%c\n",
> +		   vma->vm_flags & VM_LOCKED ?		'l' : '-',
> +		   vma->vm_flags & VM_GROWSDOWN ?	'g' : '-',
> +		   vma->vm_flags & VM_RAND_READ ?	'r' : '-',
> +		   vma->vm_flags & VM_SEQ_READ ?	'q' : '-',
> +		   vma->vm_flags & VM_DONTCOPY ?	'-' : 'c',
> +		   vma->vm_flags & VM_MERGEABLE ?	'm' : '-',
> +		   vma->vm_flags & VM_HUGEPAGE ?	'h' : '-',
> +		   vma->vm_flags & VM_NOHUGEPAGE ?	'-' : 'h',
> +		   vma->vm_flags & VM_DONTDUMP ?	'-' : 'd');
> +}
> +#else
> +static void show_smap_vma_flags(struct seq_file *m, struct vm_area_struct *vma) { }
> +#endif

I guess this more terse output is better.  It should be documented (in
Documentation/filesystems/proc.txt, I suppose) and we should add a code
comment here reminding people to update that documentation when they
change this function.

There are about 28 VM_foo flags and here you've semi-randomly chosen 9
of them for display.  This seems rather ugly and we should expect that
people will change this code to display additional flags in the future.

And we should also expect some of the flags which _are_ displayed to
vanish in the future as the code evolves.

This data is pretty dependent upon internal kernel implementation
details, so it is something we normally try to avoid exporting to
userspace.

We should design the interface with these future changes in mind.  That
means careful documentation and perhaps a format which discourages
userspace programmers from assuming that there will always be nine
fields.

A common way in which we do this future-proofing is to display the info
in name:value tuples (eg, /proc/meminfo).  So userspace parses for the
"name" rather than looking into a fixed position in the /proc output.

So....  with this thought in mind, perhaps a better output format would
be something like:

	VmFlags: LO:1 GR:0 RA:0 SE:1 ...

ie: a two-character "name" and a boolean "value".  Something like that.


Also, it worries me a bit that this interface vanishes if
CONFIG_CHECKPOINT_RESTORE=n.  One can easily anticipate that non-c/r
userspace programs will start to use this interface, and they will want
it to be present in CONFIG_CHECKPOINT_RESTORE=n kernels.  

