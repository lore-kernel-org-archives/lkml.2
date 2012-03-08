Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756272Ab2CHTDL (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Mar 2012 14:03:11 -0500
Received: from mail-bk0-f46.google.com ([209.85.214.46]:61954 "EHLO
	mail-bk0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751154Ab2CHTDI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Mar 2012 14:03:08 -0500
Date: Thu, 8 Mar 2012 23:03:03 +0400
From: Cyrill Gorcunov <gorcunov@openvz.org>
To: Oleg Nesterov <oleg@redhat.com>
Cc: Matt Helsley <matthltc@us.ibm.com>,
        KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
        Pavel Emelyanov <xemul@parallels.com>,
        Kees Cook <keescook@chromium.org>, Tejun Heo <tj@kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: [RFC] c/r: prctl: Add ability to set new mm_struct::exe_file v3
Message-ID: <20120308190303.GG21812@moon>
References: <20120308165112.GF21812@moon>
 <20120308182623.GA17221@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120308182623.GA17221@redhat.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Mar 08, 2012 at 07:26:23PM +0100, Oleg Nesterov wrote:
> On 03/08, Cyrill Gorcunov wrote:
> >
> > Hi Oleg, could you please take a look once you get a minute (no urgency).
> 
> Add Matt. I won't touch the text below to keep the patch intact.

Thanks for CC'ing Matt, Oleg (I forgot, sorry).

> 
> With this change
> 
> 	down_write(&mm->mmap_sem);
> 	if (mm->num_exe_file_vmas) {
> 		fput(mm->exe_file);
> 		mm->exe_file = exe_file;
> 		exe_file = NULL;
> 	} else
> 		set_mm_exe_file(mm, exe_file);
> 	up_write(&mm->mmap_sem);
> 
> I simply do not understand what mm->num_exe_file_vmas means after
> PR_SET_MM_EXE_FILE.
> 
> I think that you should do
> 
> 	down_write(&mm->mmap_sem);
> 	if (mm->num_exe_file_vmas) {
> 		fput(mm->exe_file);
> 		mm->exe_file = exe_file;
> 		exe_file = NULL;
> 	}
> 	up_write(&mm->mmap_sem);
> 
> to keep the current "mm->exe_file goes away after the final
> unmap(MAP_EXECUTABLE)" logic.
> 
> OK, may be this doesn't work in c/r case because you are actually
> going to remove the old mappings? But in this case the new exe_file
> will go away anyway, afaics PR_SET_MM_EXE_FILE is called when you
> still have the old mappings.

Yes, exactly, I need to remove old mappings first (because VMAs
we're about to restore may intersect with current map the host
program has). And yes, once they all are removed I don't have
/proc/pid/exe anymore. That's why I need num_exe_file_vmas == 0
case.

When I setup new exe_file with num_exe_file_vmas = 0, this reference
to a file brings /proc/pid/exe back to live (and when process exiting
it'll call set_mm_exe_file(mm, NULL) and the new exe_file will be dropped,
so no leak here).

> 
> And I don't think the unconditional
> 
> 	down_write(&mm->mmap_sem);
> 	set_mm_exe_file(mm, exe_file);
> 	up_write(&mm->mmap_sem);
> 
> is 100% right, this clears ->num_exe_file_vmas. This means that
> (if you still have the old mapping) the new exe_file can go away
> after added_exe_file_vma() + removed_exe_file_vma(). Normally this
> should happen, but afaics this is possible. Note that even, say,
> mprotect() can trigger added_exe_file_vma().
> 

Wait, Oleg, I'm confused, in case if there *is* exitsting VM_EXECUTABLEs
then we jump into first banch and simply replace old exe_file.
If there is no VM_EXECUTABLEs, then we simply setup new exe_file
and num_exe_file_vmas remains zero.

Or I miss something obvious and we somehow can cause the kernel
to map VM_EXECUTABLEs out of binfmt-elf loader?

> May be we can do something like
> 
> 	down_write(&mm->mmap_sem);
> 	set_mm_exe_file(mm, exe_file);
> 	// we are cheating anyway, make sure it can never == 0
> 	// if we have the "old" VM_EXECUTABLE vmas.
> 	mm->num_exe_file_vmas = LONG_MAX;
> 	up_write(&mm->mmap_sem);
> 
> I dunno. Matt, could you help?

	Cyrill
