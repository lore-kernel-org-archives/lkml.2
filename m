Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757259Ab2CERka (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Mar 2012 12:40:30 -0500
Received: from mx1.redhat.com ([209.132.183.28]:24120 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755567Ab2CERk1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Mar 2012 12:40:27 -0500
Date: Mon, 5 Mar 2012 18:33:14 +0100
From: Oleg Nesterov <oleg@redhat.com>
To: Cyrill Gorcunov <gorcunov@openvz.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        Matt Helsley <matthltc@us.ibm.com>,
        Alexey Dobriyan <adobriyan@gmail.com>,
        "Eric W. Biederman" <ebiederm@xmission.com>,
        Kees Cook <keescook@chromium.org>,
        KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
        Pavel Emelyanov <xemul@parallels.com>, Tejun Heo <tj@kernel.org>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 0/1] turn mm->exe_file into mm->exe_path
Message-ID: <20120305173314.GA17895@redhat.com>
References: <20120305152826.GA12419@redhat.com> <20120305170556.GC12341@moon>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120305170556.GC12341@moon>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/05, Cyrill Gorcunov wrote:
>
> On Mon, Mar 05, 2012 at 04:28:26PM +0100, Oleg Nesterov wrote:
> > I think the patch is simple and self-explanatory, it simply
> > does s/mm->exe_file/mm->exe_path/.
> >
> > Why do we need mm->exe_file? IIUC, there are 2 reasons:
> >
> > 	1. we do not want O(n) proc/pid/exe looking for the 1st
> > 	   VM_EXECUTABLE vma.
> >
> > 	2. we do not want to rely on vma->vm_file->f_path,
> > 	   bprm->file->f_op->mmap can change ->vm_file.
> >
> > Unless there was another subtle reason, "struct path *exe_path"
> > can equally work but it looks more clear.
> >
> > And can't we also remove added_exe_file_vma/removed_exe_file_vma?
> > Why do we need mm->num_exe_file_vmas? Afaics it is only needed to
> > "free" mm->exe_file if the application unmaps all these vmas. Say,
> > to allow to unmount fs.
> >
> > Can't we simply add PR_CLEAR_MM_EXE_PATH instead? Of course it is
> > not enough if ->vm_file still has a reference. But c/r people want
> > PR_SET_MM_EXE_FILE anyway, see http://marc.info/?t=133052865500016
> > So perhaps we can add PR_SET_MM_EXE_PATH which accepts NULL as well
> > and kill this counter?
> >
>
> So, if I understand you correctly, if there is exe_path, I would
> simply put() it and get() and assign new one. Looks cool for me.

Yes,

> Not sure where we may use PR_SET_MM_EXE_PATH with NULL to kill
> num_exe_file_vmas from user space though

Please see above:

	Why do we need mm->num_exe_file_vmas? Afaics it is only needed to
	"free" mm->exe_file if the application unmaps all these vmas. Say,
	to allow to unmount fs.

If we remove this counter, the application can't do the final put.
But if we add PR_SET_MM_EXE_PATH which accepts NULL we solve this
problem and this works for c/r too.

Of course, this is orthogonal to the patch I sent.

Oleg.

