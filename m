Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752513Ab2CEVOz (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Mar 2012 16:14:55 -0500
Received: from e1.ny.us.ibm.com ([32.97.182.141]:42462 "EHLO e1.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751337Ab2CEVOy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Mar 2012 16:14:54 -0500
Date: Mon, 5 Mar 2012 13:14:36 -0800
From: Matt Helsley <matthltc@us.ibm.com>
To: Oleg Nesterov <oleg@redhat.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        Matt Helsley <matthltc@us.ibm.com>,
        Alexey Dobriyan <adobriyan@gmail.com>,
        Cyrill Gorcunov <gorcunov@openvz.org>,
        "Eric W. Biederman" <ebiederm@xmission.com>,
        Kees Cook <keescook@chromium.org>,
        KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
        Pavel Emelyanov <xemul@parallels.com>, Tejun Heo <tj@kernel.org>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 0/1] turn mm->exe_file into mm->exe_path
Message-ID: <20120305211436.GM7666@count0.beaverton.ibm.com>
References: <20120305152826.GA12419@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120305152826.GA12419@redhat.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 12030521-6078-0000-0000-000008BC32A3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Mar 05, 2012 at 04:28:26PM +0100, Oleg Nesterov wrote:
> I think the patch is simple and self-explanatory, it simply
> does s/mm->exe_file/mm->exe_path/.
> 
> Why do we need mm->exe_file? IIUC, there are 2 reasons:
> 
> 	1. we do not want O(n) proc/pid/exe looking for the 1st
> 	   VM_EXECUTABLE vma.

(Frankly this always seemed like a bit of a hack to me. If someone got
creative with text layout then it could break this hack...)

> 
> 	2. we do not want to rely on vma->vm_file->f_path,
> 	   bprm->file->f_op->mmap can change ->vm_file.
> 
> Unless there was another subtle reason, "struct path *exe_path"
> can equally work but it looks more clear.

PATCH 1/1 looks fine. I think Alexey Dobriyan was working on a similar
patch years ago.

> And can't we also remove added_exe_file_vma/removed_exe_file_vma?
> Why do we need mm->num_exe_file_vmas? Afaics it is only needed to
> "free" mm->exe_file if the application unmaps all these vmas. Say,
> to allow to unmount fs.

Yup. I know it's not pretty to have to track the exe file refs this way
but I couldn't see any other way to keep a reference to the file (or
path) and avoid pinning the mounted filesystem the exectuable is on.

> Can't we simply add PR_CLEAR_MM_EXE_PATH instead? Of course it is
> not enough if ->vm_file still has a reference. But c/r people want

Relying solely on this prctl would break existing programs. I believe Al
Viro's example was a program that copies its text to a new executable
area, unmaps the original, performs a pivot_root(), and finally umounts
the old root. Removing the counter would cause the mount to be pinned
for these programs and the umount would fail.

> PR_SET_MM_EXE_FILE anyway, see http://marc.info/?t=133052865500016
> So perhaps we can add PR_SET_MM_EXE_PATH which accepts NULL as well
> and kill this counter?
> 
> Oleg.

Cheers,
	-Matt Helsley

