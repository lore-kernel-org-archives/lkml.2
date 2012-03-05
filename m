Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751131Ab2CEPfq (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Mar 2012 10:35:46 -0500
Received: from mx1.redhat.com ([209.132.183.28]:51463 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750892Ab2CEPfp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Mar 2012 10:35:45 -0500
Date: Mon, 5 Mar 2012 16:28:26 +0100
From: Oleg Nesterov <oleg@redhat.com>
To: Andrew Morton <akpm@linux-foundation.org>,
        Matt Helsley <matthltc@us.ibm.com>
Cc: Alexey Dobriyan <adobriyan@gmail.com>,
        Cyrill Gorcunov <gorcunov@openvz.org>,
        "Eric W. Biederman" <ebiederm@xmission.com>,
        Kees Cook <keescook@chromium.org>,
        KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
        Pavel Emelyanov <xemul@parallels.com>, Tejun Heo <tj@kernel.org>,
        linux-kernel@vger.kernel.org
Subject: [PATCH 0/1] turn mm->exe_file into mm->exe_path
Message-ID: <20120305152826.GA12419@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I think the patch is simple and self-explanatory, it simply
does s/mm->exe_file/mm->exe_path/.

Why do we need mm->exe_file? IIUC, there are 2 reasons:

	1. we do not want O(n) proc/pid/exe looking for the 1st
	   VM_EXECUTABLE vma.

	2. we do not want to rely on vma->vm_file->f_path,
	   bprm->file->f_op->mmap can change ->vm_file.

Unless there was another subtle reason, "struct path *exe_path"
can equally work but it looks more clear.



And can't we also remove added_exe_file_vma/removed_exe_file_vma?
Why do we need mm->num_exe_file_vmas? Afaics it is only needed to
"free" mm->exe_file if the application unmaps all these vmas. Say,
to allow to unmount fs.

Can't we simply add PR_CLEAR_MM_EXE_PATH instead? Of course it is
not enough if ->vm_file still has a reference. But c/r people want
PR_SET_MM_EXE_FILE anyway, see http://marc.info/?t=133052865500016
So perhaps we can add PR_SET_MM_EXE_PATH which accepts NULL as well
and kill this counter?

Oleg.

