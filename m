Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761576Ab0GTUhh (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Jul 2010 16:37:37 -0400
Received: from hera.kernel.org ([140.211.167.34]:38638 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758689Ab0GTUfr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Jul 2010 16:35:47 -0400
From: Tejun Heo <tj@kernel.org>
To: linux-kernel@vger.kernel.org, dhowells@redhat.com, sfrench@samba.org,
        anton@samba.org, swhiteho@redhat.com, airlied@linux.ie,
        dri-devel@lists.freedesktop.org
Subject: [PATCHSET wq#for-next] workqueue: replace slow-work with workqueue
Date: Tue, 20 Jul 2010 22:34:55 +0200
Message-Id: <1279658102-20069-1-git-send-email-tj@kernel.org>
X-Mailer: git-send-email 1.6.4.2
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Tue, 20 Jul 2010 20:35:10 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

With cmwq, workqueue now can handle all use cases of slow-work.  This
patchset converts all slow-work users to use workqueue instead and
remove slow-work from the kernel.  The following users are converted.

* fscache-object: a dedicated unbound workqueue is used.
* fscache-operation: a dedicated unbound workqueue is used.
* cifs: system_nrt_wq is used.
* gfs2: a dedicated nrt workqueue is used.
* drm: system_nrt_wq is used.

cifs and gfs2 conversions largely remained unchanged from the last
posting.  fscache conversions are updated to use unbound workqueues
and debugfs support is dropped for now (workqueue debugfs support is
not included in wq#for-next).  Tracing API based debug implementation
is planned.

The drm conversion is new but the conversion is mostly trivial and my
simplistic testing involving plugging and unplugging monitor works
fine.

David, fscache conversion now uses unbound workqueues and it should
behave virtually the same with slow-work.

As whether cmwq will get merged isn't completely clear yet, I think it
would be better to keep these changes in the wq tree instead of
scattering them around multiple trees.  Would the maintainers be okay
with that?

This patchset contains the following patches.

 0001-fscache-convert-object-to-use-workqueue-instead-of-s.patch
 0002-fscache-convert-operation-to-use-workqueue-instead-o.patch
 0003-fscache-drop-references-to-slow-work.patch
 0004-cifs-use-workqueue-instead-of-slow-work.patch
 0005-gfs2-use-workqueue-instead-of-slow-work.patch
 0006-drm-use-workqueue-instead-of-slow-work.patch
 0007-slow-work-kill-it.patch

It's on top of the following branch.

 git://git.kernel.org/pub/scm/linux/kernel/git/tj/wq.git for-next

and is available in the following git branch

 git://git.kernel.org/pub/scm/linux/kernel/git/tj/wq.git review-slow-work-conversion

and contains the following changes.

 Documentation/filesystems/caching/fscache.txt |   10 
 Documentation/slow-work.txt                   |  322 -------
 drivers/gpu/drm/drm_crtc_helper.c             |   29 
 fs/cachefiles/namei.c                         |   13 
 fs/cachefiles/rdwr.c                          |    4 
 fs/cifs/Kconfig                               |    1 
 fs/cifs/cifsfs.c                              |    5 
 fs/cifs/cifsglob.h                            |    8 
 fs/cifs/dir.c                                 |    2 
 fs/cifs/file.c                                |   30 
 fs/cifs/misc.c                                |   20 
 fs/fscache/Kconfig                            |    1 
 fs/fscache/internal.h                         |    8 
 fs/fscache/main.c                             |  104 ++
 fs/fscache/object-list.c                      |   11 
 fs/fscache/object.c                           |  106 +-
 fs/fscache/operation.c                        |   67 -
 fs/fscache/page.c                             |   36 
 fs/gfs2/Kconfig                               |    1 
 fs/gfs2/incore.h                              |    3 
 fs/gfs2/main.c                                |   14 
 fs/gfs2/ops_fstype.c                          |    8 
 fs/gfs2/recovery.c                            |   54 -
 fs/gfs2/recovery.h                            |    6 
 fs/gfs2/sys.c                                 |    3 
 include/drm/drm_crtc.h                        |    3 
 include/linux/fscache-cache.h                 |   47 -
 include/linux/slow-work.h                     |  163 ---
 init/Kconfig                                  |   24 
 kernel/Makefile                               |    2 
 kernel/slow-work-debugfs.c                    |  227 -----
 kernel/slow-work.c                            | 1068 --------------------------
 kernel/slow-work.h                            |   72 -
 kernel/sysctl.c                               |    8 
 34 files changed, 292 insertions(+), 2188 deletions(-)

Thanks.

--
tejun
