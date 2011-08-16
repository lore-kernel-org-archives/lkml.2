Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751925Ab1HPJdN (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Aug 2011 05:33:13 -0400
Received: from gir.skynet.ie ([193.1.99.77]:54495 "EHLO gir.skynet.ie"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751787Ab1HPJdM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Aug 2011 05:33:12 -0400
Date: Tue, 16 Aug 2011 10:33:03 +0100
From: Mel Gorman <mel@csn.ul.ie>
To: Will Drewry <wad@chromium.org>
Cc: linux-kernel@vger.kernel.org, mcgrathr@google.com,
        Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@linux-foundation.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Al Viro <viro@zeniv.linux.org.uk>, Eric Paris <eparis@redhat.com>,
        Andrea Arcangeli <aarcange@redhat.com>, Rik van Riel <riel@redhat.com>,
        Nitin Gupta <ngupta@vflare.org>, Hugh Dickins <hughd@google.com>,
        Shaohua Li <shaohua.li@intel.com>, linux-mm@kvack.org
Subject: Re: [PATCH] mmap: add sysctl for controlling ~VM_MAYEXEC taint
Message-ID: <20110816093303.GA4484@csn.ul.ie>
References: <1313441856-1419-1-git-send-email-wad@chromium.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-15
Content-Disposition: inline
In-Reply-To: <1313441856-1419-1-git-send-email-wad@chromium.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Aug 15, 2011 at 03:57:35PM -0500, Will Drewry wrote:
> This patch proposes a sysctl knob that allows a privileged user to
> disable ~VM_MAYEXEC tainting when mapping in a vma from a MNT_NOEXEC
> mountpoint.  It does not alter the normal behavior resulting from
> attempting to directly mmap(PROT_EXEC) a vma (-EPERM) nor the behavior
> of any other subsystems checking MNT_NOEXEC.
> 
> It is motivated by a common /dev/shm, /tmp usecase. There are few
> facilities for creating a shared memory segment that can be remapped in
> the same process address space with different permissions.  Often, a
> file in /tmp provides this functionality.  However, on distributions
> that are more restrictive/paranoid, world-writeable directories are
> often mounted "noexec".  The only workaround to support software that
> needs this behavior is to either not use that software or remount /tmp
> exec.  (E.g., https://bugs.gentoo.org/350336?id=350336) Given that
> the only recourse is using SysV IPC, the application programmer loses
> many of the useful ABI features that they get using a mmap'd file (and
> as such are often hesitant to explore that more painful path).
> 

Is using shm_open()+mmap instead of open()+mmap() to open a file on
/dev/shm really that difficult?

int shm_open(const char *name, int oflag, mode_t mode);
int open(const char *pathname, int flags, mode_t mode);

> With this patch, it would be possible to change the sysctl variable
> such that mprotect(PROT_EXEC) would succeed.

An ordinary user is not going to know that a segfault from an
application can be fixed with this sysctl. This looks like something
that should be fixed in the library so that it can work on kernels
that do not have the sysctl.

-- 
Mel Gorman
SUSE Labs
