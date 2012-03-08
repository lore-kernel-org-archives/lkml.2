Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758194Ab2CHTMx (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Mar 2012 14:12:53 -0500
Received: from mx1.redhat.com ([209.132.183.28]:30639 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757796Ab2CHTMw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Mar 2012 14:12:52 -0500
Date: Thu, 8 Mar 2012 20:05:34 +0100
From: Oleg Nesterov <oleg@redhat.com>
To: Cyrill Gorcunov <gorcunov@openvz.org>
Cc: Matt Helsley <matthltc@us.ibm.com>,
        KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
        Pavel Emelyanov <xemul@parallels.com>,
        Kees Cook <keescook@chromium.org>, Tejun Heo <tj@kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: [RFC] c/r: prctl: Add ability to set new mm_struct::exe_file v3
Message-ID: <20120308190534.GA19827@redhat.com>
References: <20120308165112.GF21812@moon> <20120308182623.GA17221@redhat.com> <20120308190303.GG21812@moon>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120308190303.GG21812@moon>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/08, Cyrill Gorcunov wrote:
>
> On Thu, Mar 08, 2012 at 07:26:23PM +0100, Oleg Nesterov wrote:
> > I think that you should do
> >
> > 	down_write(&mm->mmap_sem);
> > 	if (mm->num_exe_file_vmas) {
> > 		fput(mm->exe_file);
> > 		mm->exe_file = exe_file;
> > 		exe_file = NULL;
> > 	}
> > 	up_write(&mm->mmap_sem);
> >
> > to keep the current "mm->exe_file goes away after the final
> > unmap(MAP_EXECUTABLE)" logic.
> >
> > OK, may be this doesn't work in c/r case because you are actually
> > going to remove the old mappings? But in this case the new exe_file
> > will go away anyway, afaics PR_SET_MM_EXE_FILE is called when you
> > still have the old mappings.
>
> Yes, exactly, I need to remove old mappings first (because VMAs
> we're about to restore may intersect with current map the host
> program has). And yes, once they all are removed I don't have
> /proc/pid/exe anymore. That's why I need num_exe_file_vmas == 0
> case.

OK, in this case PR_SET_MM_EXE_FILE should probably fail if
mm->num_exe_file_vmas != 0 ? This way it would be more or less
consistent or at least understandable. Just we add the new
special case: num_exe_file_vmas == 0 but exe_file != NULL
because c/r people are crazy.

> > And I don't think the unconditional
> >
> > 	down_write(&mm->mmap_sem);
> > 	set_mm_exe_file(mm, exe_file);
> > 	up_write(&mm->mmap_sem);
> >
> > is 100% right, this clears ->num_exe_file_vmas. This means that
> > (if you still have the old mapping) the new exe_file can go away
> > after added_exe_file_vma() + removed_exe_file_vma(). Normally this
> > should happen, but afaics this is possible. Note that even, say,
> > mprotect() can trigger added_exe_file_vma().
> >
>
> Wait, Oleg, I'm confused, in case if there *is* exitsting VM_EXECUTABLEs
> then we jump into first banch and simply replace old exe_file.

Yes. And then later you remove the old mapping (which do not match
the new file anyway) and the new exe_file goes away. Unlikely you
want this.

Oleg.

