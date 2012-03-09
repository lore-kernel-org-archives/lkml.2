Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758697Ab2CIVq4 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Mar 2012 16:46:56 -0500
Received: from e38.co.us.ibm.com ([32.97.110.159]:38600 "EHLO
	e38.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758547Ab2CIVqx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Mar 2012 16:46:53 -0500
Date: Fri, 9 Mar 2012 13:46:37 -0800
From: Matt Helsley <matthltc@us.ibm.com>
To: Cyrill Gorcunov <gorcunov@openvz.org>
Cc: Oleg Nesterov <oleg@redhat.com>, Matt Helsley <matthltc@us.ibm.com>,
        KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
        Pavel Emelyanov <xemul@parallels.com>,
        Kees Cook <keescook@chromium.org>, Tejun Heo <tj@kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: [RFC] c/r: prctl: Add ability to set new mm_struct::exe_file v3
Message-ID: <20120309214637.GC19584@count0.beaverton.ibm.com>
References: <20120308165112.GF21812@moon>
 <20120308182623.GA17221@redhat.com>
 <20120308190303.GG21812@moon>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120308190303.GG21812@moon>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 12030921-5518-0000-0000-000002DA2F2D
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Mar 08, 2012 at 11:03:03PM +0400, Cyrill Gorcunov wrote:
> On Thu, Mar 08, 2012 at 07:26:23PM +0100, Oleg Nesterov wrote:
> > On 03/08, Cyrill Gorcunov wrote:
> > >
> > > Hi Oleg, could you please take a look once you get a minute (no urgency).
> > 
> > Add Matt. I won't touch the text below to keep the patch intact.
> 
> Thanks for CC'ing Matt, Oleg (I forgot, sorry).
> 
> > 
> > With this change
> > 
> > 	down_write(&mm->mmap_sem);
> > 	if (mm->num_exe_file_vmas) {
> > 		fput(mm->exe_file);
> > 		mm->exe_file = exe_file;
> > 		exe_file = NULL;
> > 	} else
> > 		set_mm_exe_file(mm, exe_file);
> > 	up_write(&mm->mmap_sem);
> > 
> > I simply do not understand what mm->num_exe_file_vmas means after
> > PR_SET_MM_EXE_FILE.

I think it should fail if the num_exe_file_vmas is not 0 when
PR_SET_MM_EXE_FILE is used. It's simple, keeps things clear, might
catch userspace bugs (harder to accidentally leave a mapping of the original
executable), and could avoid kernel bugs too.

> > 
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
> 
> When I setup new exe_file with num_exe_file_vmas = 0, this reference
> to a file brings /proc/pid/exe back to live (and when process exiting
> it'll call set_mm_exe_file(mm, NULL) and the new exe_file will be dropped,
> so no leak here).

Makes sense, I think.

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

What happens if multiple prctl calls are made? We'll have a mix of N
executable files that've been mapped n_i times. I think we're better off
just returning an error in that case -- -EBUSY or something.

> If there is no VM_EXECUTABLEs, then we simply setup new exe_file
> and num_exe_file_vmas remains zero.

Which is fine.

Cheers,
	-Matt

