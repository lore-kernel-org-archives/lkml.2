Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933306Ab2IGO0e (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Sep 2012 10:26:34 -0400
Received: from mail-vb0-f46.google.com ([209.85.212.46]:58266 "EHLO
	mail-vb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932117Ab2IGO0c (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Sep 2012 10:26:32 -0400
From: Jeff Layton <jlayton@redhat.com>
To: viro@ZenIV.linux.org.uk
Cc: linux-fsdevel@vger.kernel.org, linux-nfs@vger.kernel.org,
        linux-kernel@vger.kernel.org, michael.brantley@deshaw.com,
        hch@infradead.org, miklos@szeredi.hu, pstaubach@exagrid.com
Subject: [PATCH v6 00/20] vfs: add the ability to retry on ESTALE to several syscalls
Date: Fri,  7 Sep 2012 10:18:07 -0400
Message-Id: <1347027507-20956-1-git-send-email-jlayton@redhat.com>
X-Mailer: git-send-email 1.7.11.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patchset is a respin of the one I sent on August 8th. The main
reason is to respin this series on top of my getname/putname overhaul,
which simplifies the set greatly and doesn't require so many getname
callers.

This series depends on the "getname" series that I sent earlier today.

This set (and the prerequiste patches) are also available via the
"estale" branch of my git tree:

    git://git.samba.org/jlayton/linux.git estale

I'd like to see this go in for 3.7 if at all possible.

The original cover letter text follows:

ESTALE errors are a source of pain for many users, primarily those who
are doing work on NFS. When userspace provides a path to a syscall, then
there's really little excuse for returning ESTALE. If userspace gave us
a path that we had to lookup in order to do the call, then it's not
particularly helpful to return ESTALE just because that path went stale
before we could do the actual operation.

We can and should do better here. The kernel should instead catch that
error and retry the lookup and call, while forcing a revalidation of all
dentries involved.

Unfortunately fixing this requires touching the syscalls themselves, or
at least their immediate helper functions. Not all syscalls can be
retried -- only those that take a pathname as an argument.

With this patchset, I've decided to take the relatively less
controversial approach of just having the kernel retry once when it gets
an ESTALE error. I still think that it's not as strong as it should be,
but it should improve the situation in many common cases.

I've also tried to engineer this in such a way that if we do decide that
we need to retry more than once, then it should be easy to change that
later. This should cover all of the syscalls in fs/stat.c and
fs/namei.c, and most of fs/open.c.

Once these are merged, I'll look at adding similar handling to other
path-based syscalls in a later set. A quick look shows that we have
about 50-odd path-based syscalls that will need similar handling, so
this is just a start.

Jeff Layton (20):
  vfs: add a retry_estale helper function to handle retries on ESTALE
  vfs: make fstatat retry on ESTALE errors from getattr call
  vfs: fix readlinkat to retry on ESTALE
  vfs: add new "reval" argument to kern_path_create and
    user_path_create
  vfs: fix mknodat to retry on ESTALE errors
  vfs: fix mkdir to retry on ESTALE errors
  vfs: fix symlinkat to retry on ESTALE errors
  vfs: fix linkat to retry on ESTALE errors
  vfs: add a reval argument to user_path_parent
  vfs: make rmdir retry on ESTALE errors
  vfs: make do_unlinkat retry on ESTALE errors
  vfs: fix renameat to retry on ESTALE errors
  vfs: have do_sys_truncate retry once on an ESTALE error
  vfs: have faccessat retry once on an ESTALE error
  vfs: have chdir retry lookup and call once on ESTALE error
  vfs: make chroot retry once on ESTALE error
  vfs: make fchmodat retry once on ESTALE errors
  vfs: make fchownat retry once on ESTALE errors
  vfs: convert do_filp_open to use retry_estale helper
  vfs: convert do_file_open_root to use retry_estale helper

 arch/powerpc/platforms/cell/spufs/syscalls.c |   2 +-
 drivers/base/devtmpfs.c                      |   7 +-
 fs/namei.c                                   | 265 ++++++++++++++++-----------
 fs/ocfs2/refcounttree.c                      |   3 +-
 fs/open.c                                    | 252 +++++++++++++------------
 fs/stat.c                                    |  32 +++-
 include/linux/fs.h                           |  21 +++
 include/linux/namei.h                        |   4 +-
 net/unix/af_unix.c                           |   2 +-
 9 files changed, 352 insertions(+), 236 deletions(-)

-- 
1.7.11.4

