Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758403Ab2CHTZN (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Mar 2012 14:25:13 -0500
Received: from mail-bk0-f46.google.com ([209.85.214.46]:37834 "EHLO
	mail-bk0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757553Ab2CHTZK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Mar 2012 14:25:10 -0500
Date: Thu, 8 Mar 2012 23:25:04 +0400
From: Cyrill Gorcunov <gorcunov@openvz.org>
To: Oleg Nesterov <oleg@redhat.com>
Cc: Matt Helsley <matthltc@us.ibm.com>,
        KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
        Pavel Emelyanov <xemul@parallels.com>,
        Kees Cook <keescook@chromium.org>, Tejun Heo <tj@kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: [RFC] c/r: prctl: Add ability to set new mm_struct::exe_file v3
Message-ID: <20120308192504.GH21812@moon>
References: <20120308165112.GF21812@moon>
 <20120308182623.GA17221@redhat.com>
 <20120308190303.GG21812@moon>
 <20120308190534.GA19827@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120308190534.GA19827@redhat.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Mar 08, 2012 at 08:05:34PM +0100, Oleg Nesterov wrote:
...
> >
> > Yes, exactly, I need to remove old mappings first (because VMAs
> > we're about to restore may intersect with current map the host
> > program has). And yes, once they all are removed I don't have
> > /proc/pid/exe anymore. That's why I need num_exe_file_vmas == 0
> > case.
> 
> OK, in this case PR_SET_MM_EXE_FILE should probably fail if
> mm->num_exe_file_vmas != 0 ? This way it would be more or less
> consistent or at least understandable. Just we add the new
> special case: num_exe_file_vmas == 0 but exe_file != NULL
> because c/r people are crazy.
> 

Sure, I can drop num_exe_file_vmas != 0 case and refuse to
setup new exe symlink if there some VM_EXECUTABLE remains
unmapped. Sounds good?

> > > And I don't think the unconditional
> > >
> > > 	down_write(&mm->mmap_sem);
> > > 	set_mm_exe_file(mm, exe_file);
> > > 	up_write(&mm->mmap_sem);
> > >
> > > is 100% right, this clears ->num_exe_file_vmas. This means that
> > > (if you still have the old mapping) the new exe_file can go away
> > > after added_exe_file_vma() + removed_exe_file_vma(). Normally this
> > > should happen, but afaics this is possible. Note that even, say,
> > > mprotect() can trigger added_exe_file_vma().
> > >
> >
> > Wait, Oleg, I'm confused, in case if there *is* exitsting VM_EXECUTABLEs
> > then we jump into first banch and simply replace old exe_file.
> 
> Yes. And then later you remove the old mapping (which do not match
> the new file anyway) and the new exe_file goes away. Unlikely you
> want this.

Yes, unlikely ;)

	Cyrill
