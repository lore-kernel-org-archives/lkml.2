Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758601Ab2FZQfr (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Jun 2012 12:35:47 -0400
Received: from mail-yx0-f174.google.com ([209.85.213.174]:33496 "EHLO
	mail-yx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757591Ab2FZQfo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Jun 2012 12:35:44 -0400
From: Jeff Layton <jlayton@redhat.com>
To: eparis@redhat.com, viro@zeniv.linux.org.uk
Cc: linux-audit@redhat.com, linux-fsdevel@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH v4 0/9] audit: overhaul audit_names handling to allow for retrying on path-based syscalls
Date: Tue, 26 Jun 2012 12:35:28 -0400
Message-Id: <1340728537-25599-1-git-send-email-jlayton@redhat.com>
X-Mailer: git-send-email 1.7.7.6
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I recently posted a set of patches to have the kernel retry the lookup
and call when path-based syscalls would ordinarily return ESTALE. Al
took a look and pointed out that this would break the fragile logic that
handles the audit_names for syscall auditing.

This patchset comprises a number of incremental changes that should make
it ok to retry on a path-based syscall. The main caveat is that the retry
mustn't redo the getname() on the strings involved.

Unfortunately, we don't have anything that really describes what the
correct behavior is for this stuff, so I'm shooting here for "no
discernable difference" on a retry.

This seems to do the right thing in the cases that I've tested; mostly
the normal case where things succeed or fail for some reason and where
the syscall is retried after an ESTALE error.

Review is of course appreciated. There are some fixes in here too for
some subtle bugs in the existing code. Some of these patches may also
help performance in some cases, but I haven't measured it for that.

I'd like to see this patchset go into 3.6 if at all possible.

Eric Paris (1):
  audit: make audit_compare_dname_path use parent_len helper

Jeff Layton (8):
  audit: remove unnecessary NULL ptr checks from do_path_lookup
  audit: pass in dentry to audit_copy_inode wherever possible
  audit: reverse arguments to audit_inode_child
  audit: add a new "type" field to audit_names struct
  audit: set the name_len in audit_inode for parent lookups
  audit: remove dirlen argument to audit_compare_dname_path
  audit: optimize audit_compare_dname_path
  audit: overhaul __audit_inode_child to accomodate retrying

 fs/btrfs/ioctl.c         |    2 +-
 fs/namei.c               |   20 +++-----
 fs/open.c                |    4 +-
 fs/xattr.c               |    8 ++--
 include/linux/audit.h    |   36 ++++++++++-----
 include/linux/fsnotify.h |    8 ++--
 ipc/mqueue.c             |    8 ++--
 kernel/audit.h           |    7 ++-
 kernel/audit_watch.c     |    3 +-
 kernel/auditfilter.c     |   65 +++++++++++++++++---------
 kernel/auditsc.c         |  115 +++++++++++++++++++++++++++------------------
 11 files changed, 165 insertions(+), 111 deletions(-)

-- 
1.7.7.6

