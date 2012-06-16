Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758478Ab2FPDG0 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Jun 2012 23:06:26 -0400
Received: from mail-qc0-f174.google.com ([209.85.216.174]:51586 "EHLO
	mail-qc0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755835Ab2FPDGZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Jun 2012 23:06:25 -0400
From: Filipe Brandenburger <filbranden@gmail.com>
To: "J. Bruce Fields" <bfields@fieldses.org>,
        Al Viro <viro@zeniv.linux.org.uk>, Matthew Wilcox <matthew@wil.cx>
Cc: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
        Filipe Brandenburger <filbranden@gmail.com>
Subject: [PATCH 0/1] locks: prevent side-effects of locks_release_private before file_lock is initialized
Date: Fri, 15 Jun 2012 23:06:04 -0400
Message-Id: <1339815965-1171-1-git-send-email-filbranden@gmail.com>
X-Mailer: git-send-email 1.7.7.6
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

There seems to be a regression in kernel 2.6.37 regarding the behavior of
fcntl(F_SETLEASE) when called for the second or third time. If fcntl(F_SETOWN)
or fcntl(F_SETSIG) was called before it, the second fcntl(F_SETLEASE) would undo
those settings.

It seems that the regression was introduced by these two commits which were
fixing a leak in a file_lock struct:
* 3df057ac9afe83c4af84016df3baf3a0eb1d3d33
* 8896b93f42459b18b145c69d399b62870df48061

To prevent the leak, a call to locks_free_lock() was added to free the file_lock
struct that was allocated but not used because the old one was reused. The
problem is that the allocated file_lock was already partially initialized with a
pointer to the file descriptor and that locks_free_lock() will then call
locks_release_private() which will call lease_release_private_callback() which
will call f_delown() and set f_owner.signum to 0, effectively undoing the
effects of fcntl(F_SETOWN) and fcntl(F_SETSIG) on that same file descriptor.

I thought of a solution in the lines of having lease_init() set fl_lmops = NULL
and have it set back to point to lease_manager_ops inside do_fcntl_add_lease()
only after it is valid, but I didn't manage to make that work... I also thought
of changing locks_free_lock() somehow to decide whether locks_release_private()
should be called or not (maybe an extra __locks_free_lock() function that would
not call locks_release_private() and could be inlined into locks_free_lock()?)
but in the end I decided to just replace the calls to locks_free_lock(fl) with
kmem_cache_free(filelock_cache, fl) directly on the places where the file_lock
struct was not yet fully initialized.

This issue was found on Samba and reported to their bugzilla at:
https://bugzilla.samba.org/show_bug.cgi?id=8974

A more detailed description and discussion including a test case is at:
https://bugzilla.kernel.org/show_bug.cgi?id=43336

Thanks,
Filipe


Filipe Brandenburger (1):
  locks: prevent side-effects of locks_release_private before file_lock
    is initialized

 fs/locks.c |    8 ++++----
 1 files changed, 4 insertions(+), 4 deletions(-)

-- 
1.7.7.6

