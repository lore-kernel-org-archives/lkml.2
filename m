Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751506Ab1LHHHd (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Dec 2011 02:07:33 -0500
Received: from mail-bw0-f46.google.com ([209.85.214.46]:62067 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751340Ab1LHHHa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Dec 2011 02:07:30 -0500
Date: Thu, 8 Dec 2011 11:07:24 +0400
From: Cyrill Gorcunov <gorcunov@gmail.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Kees Cook <keescook@chromium.org>, linux-kernel@vger.kernel.org,
        Tejun Heo <tj@kernel.org>, Andrew Vagin <avagin@openvz.org>,
        Serge Hallyn <serge.hallyn@canonical.com>,
        Pavel Emelyanov <xemul@parallels.com>,
        Vasiliy Kulikov <segoon@openwall.com>,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        Michael Kerrisk <mtk.manpages@gmail.com>
Subject: Re: [rfc 3/3] prctl: Add PR_SET_MM codes to tune up mm_struct entires
Message-ID: <20111208070724.GW21678@moon>
References: <20111129201938.GP5169@outflux.net>
 <20111129202951.GG1775@moon>
 <20111129203714.GH1775@moon>
 <CAGXu5jKDLExXWi+_Hjc+8s7FeuDgQdZcPipMH80LQs+tRyJm2A@mail.gmail.com>
 <20111130173739.GI14515@moon>
 <CAGXu5jL=46_MyxrrB8G4FntnLJBtt+DbvVX0kEXh9n8Ss+Yfsw@mail.gmail.com>
 <20111130182310.GL14515@moon>
 <20111130210622.GM14515@moon>
 <20111207122718.GF21678@moon>
 <20111207144355.c889e22d.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20111207144355.c889e22d.akpm@linux-foundation.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Dec 07, 2011 at 02:43:55PM -0800, Andrew Morton wrote:
> On Wed, 7 Dec 2011 16:27:18 +0400
> Cyrill Gorcunov <gorcunov@gmail.com> wrote:
> 
> > At process of task restoration we need a way to tune up
> > a few members of mm_struct structure such as start_code,
> > end_code, start_data, end_data, start_stack, start_brk, brk.
> 
> I don't really know what "tune up" means in this context.  Can we
> please be more specific and detailed here?  It appears that the patch
> permits userspace to directly modify these fields.
> 

ok

> 
> The prctl(2) manpage will need to be updated.  Please Cc Michael on all
> such changes.
>

you mean -- Michael Kerrisk, mtk AT man7.org, right?

...
> > +
> > +	mm = get_task_mm(current);
> 
> Is it necessaary to run the expensive get_task_mm() for `current'? 
> `current' is known to be running and you have control of it here -
> nobody will be taking our mm away.  Simply use current->mm?  The
> function actually uses current->mm later on in several places.

hmm, indeed, i'll update, thanks!

> 
> > +	if (!mm)
> > +		return -ENOENT;
> > +
> > +	down_read(&mm->mmap_sem);
> > +	vma = find_vma(mm, addr);
> > +
> > +	if (opt != PR_SET_MM_START_BRK &&
> > +	    opt != PR_SET_MM_BRK) {
> 
> 80 columns, not 40 :)
> 
> > +		/* It must be existing VMA */
> > +		if (!vma || vma->vm_start > addr)
> > +			goto out;
> > +	}
> > +
> > +	error = -EINVAL;
> > +	switch (opt) {
> > +	case PR_SET_MM_START_CODE:
> > +	case PR_SET_MM_END_CODE:
> > +
> 
> You're adding unneeded and unconventional newlines after the `case'
> statements.
> 

no, I added them by a purpose -- it's a way easier to read these
assignments, but fine -- I'll drop this nits.

> 
> This is starting to add a non-trivial amount of code.  Perhaps we need
> to introduce a Kconfig variable to control such things as this, to
> prevent bloating up kernels which aren't require to support c/r?
> 

Dunno, Andrew. Actually I agreed that these snippets are mostly
needed for c/r only, but the initial idea over all changes was
to add levers into kernel which might be helpful not only
for c/r but for someone else as well.

	Cyrill
