Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754569Ab0DOFQ5 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Apr 2010 01:16:57 -0400
Received: from [76.245.85.235] ([76.245.85.235]:52898 "EHLO cynthia.pants.nu"
	rhost-flags-FAIL-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1753558Ab0DOFQz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Apr 2010 01:16:55 -0400
X-Greylist: delayed 3665 seconds by postgrey-1.27 at vger.kernel.org; Thu, 15 Apr 2010 01:16:55 EDT
Date: Wed, 14 Apr 2010 21:14:49 -0700
From: Brad Boyer <flar@allandria.com>
To: Arnd Bergmann <arnd@arndb.de>
Cc: Matthew Wilcox <willy@linux.intel.com>, Christoph Hellwig <hch@lst.de>,
       Trond Myklebust <trond.myklebust@fys.uio.no>,
       "J. Bruce Fields" <bfields@fieldses.org>,
       Miklos Szeredi <mszeredi@suse.cz>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       Ingo Molnar <mingo@redhat.com>, John Kacur <jkacur@redhat.com>,
       linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org
Subject: Re: [PATCH 2/2] [RFC] Remove BKL from fs/locks.c
Message-ID: <20100415041449.GA4913@cynthia.pants.nu>
References: <1271277384-7627-1-git-send-email-arnd@arndb.de> <1271277384-7627-2-git-send-email-arnd@arndb.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1271277384-7627-2-git-send-email-arnd@arndb.de>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Apr 14, 2010 at 10:36:24PM +0200, Arnd Bergmann wrote:
> From: Matthew Wilcox <willy@linux.intel.com>
> 
> I've taken a patch originally written by Matthew Wilcox and
> ported it to the current version. It seems that there were
> originally concerns that this breaks NFS, but since Trond
> has recently removed the BKL from NFS, my naive assumption
> would be that it's all good now, despite not having tried to
> understand what it does.
> 
> Original introduction from Willy:
> 
>    I've been promising to do this for about seven years now.
> 
>    It seems to work well enough, but I haven't run any serious stress
>    tests on it.  This implementation uses one spinlock to protect both lock
>    lists and all the i_flock chains.  It doesn't seem worth splitting up
>    the locking any further.
> 
>    I had to move one memory allocation out from under the file_lock_lock.
>    I hope I got that logic right.  I'm rather tempted to split out the
>    find_conflict algorithm from that function into something that can be
>    called separately for the FL_ACCESS case.
> 
>    I also have to drop and reacquire the file_lock_lock around the call
>    to cond_resched().  This was done automatically for us before by the
>    special BKL semantics.
> 
>    I had to change vfs_setlease() as it relied on the special BKL ability
>    to recursively acquire the same lock.  The internal caller now calls
>    __vfs_setlease and the exported interface acquires and releases the
>    file_lock_lock around calling __vfs_setlease.
> 
>    I should probably split out the removal of interruptible_sleep_on_locked()
>    as it's basically unrelated to all this.

Don't we need to have access to this new lock from modules? In particular,
nfsd/lockd currently call lock_kernel to be able to safely access i_flock.
This would seem to imply that they would either need new functions inside
locks.c to do the same work or export the new lock functions. It seems
easiest to just do EXPORT_SYMBOL on the new lock/unlock functions added
in this patch, but I do understand if that isn't desireable.

	Brad Boyer
	flar@allandria.com

