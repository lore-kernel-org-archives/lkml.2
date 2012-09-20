Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755453Ab2ITOX3 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Sep 2012 10:23:29 -0400
Received: from mail-qc0-f174.google.com ([209.85.216.174]:47893 "EHLO
	mail-qc0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755344Ab2ITOX0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Sep 2012 10:23:26 -0400
From: Jeff Layton <jlayton@redhat.com>
To: viro@zeniv.linux.org.uk
Cc: eparis@redhat.com, linux-audit@redhat.com, linux-fsdevel@vger.kernel.org,
        linux-kernel@vger.kernel.org, acme@ghostprotocols.net
Subject: [PATCH v2 00/10] vfs: getname/putname overhaul
Date: Thu, 20 Sep 2012 10:23:09 -0400
Message-Id: <1348150999-13028-1-git-send-email-jlayton@redhat.com>
X-Mailer: git-send-email 1.7.11.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patchset is a second pass at overhauling the getname/putname
interface to use a struct.  The main differences from the last set are a
few bugfixes and changes to account for Al's execve overhaul. 

The idea here is to add a new getname_info struct that allow us to pass
around some auxillary info along with the string that getname() returns.

This allows us to do some interesting things:

- no need to walk the list of audit_names in certain cases since we
  can store a pointer to the correct audit_name

- we can now call getname() more than once on a userland string. Since
  we track the original userland pointer, we can avoid doing a second
  allocation, and can instead fill out the getname_info from the
  audit_names struct. That makes the ESTALE patchset cleaner, and doesn't
  explode out the list of getname() callers like the last set.

- eventually we might be able to track the length of the parent portion
  of the string so the audit code doesn't need to walk it again. I
  haven't implemented that yet, but it doesn't look too hard to do.

This is based on top of Al's signal.git#experimental-kernel_thread
branch, with my most recent audit series on top of that. Al is working
on unifying much of the execve code, which will reduce the number of
getname callers greatly.

This set is still preliminary since Al's set isn't complete yet and will
probably need to be respun again once he's completed that work. That
should shrink patch #4 since we'll have fewer getname callers to deal
with at that point.

This set is based on top of my audit overhaul patchset (posted earlier
today). My most recent ESTALE retry set should also apply cleanly on top
of this set.

The stack of all three sets is also available in my git tree at:

    git://git.samba.org/jlayton/linux.git#estale

While this all seems to work correctly, I have my doubts about patch #9
in this series. That was suggested by Al and should make it so that we
only need a single allocation per getname() call in most cases. OTOH, it
adds a rarely traveled codepath that could be a source of bugs in the
future.

Jeff Layton (10):
  vfs: allocate page instead of names_cache buffer in mount_block_root
  vfs: make dir_name arg to do_mount a const char *
  acct: constify the name arg to acct_on
  vfs: define getname_info struct and have getname() return it
  audit: allow audit code to satisfy getname requests from its
    names_list
  vfs: turn do_path_lookup into wrapper around getname_info variant
  vfs: make path_openat take a getname_info pointer
  audit: make audit_inode take getname_info
  vfs: embed getname_info inside of names_cache allocation if possible
  vfs: unexport getname and putname symbols

 arch/alpha/kernel/osf_sys.c             |  16 +--
 arch/avr32/kernel/process.c             |   4 +-
 arch/blackfin/kernel/process.c          |   4 +-
 arch/cris/arch-v10/kernel/process.c     |   4 +-
 arch/cris/arch-v32/kernel/process.c     |   4 +-
 arch/h8300/kernel/process.c             |   4 +-
 arch/hexagon/kernel/syscall.c           |   4 +-
 arch/ia64/kernel/process.c              |   4 +-
 arch/m32r/kernel/process.c              |   4 +-
 arch/microblaze/kernel/sys_microblaze.c |   4 +-
 arch/mips/kernel/linux32.c              |   4 +-
 arch/mips/kernel/syscall.c              |   4 +-
 arch/openrisc/kernel/process.c          |   4 +-
 arch/parisc/hpux/fs.c                   |   4 +-
 arch/parisc/kernel/process.c            |   4 +-
 arch/parisc/kernel/sys_parisc32.c       |   4 +-
 arch/score/kernel/sys_score.c           |   4 +-
 arch/sh/kernel/process_32.c             |   4 +-
 arch/sh/kernel/process_64.c             |   4 +-
 arch/sparc/kernel/process_32.c          |   4 +-
 arch/sparc/kernel/process_64.c          |   4 +-
 arch/sparc/kernel/sys_sparc32.c         |   4 +-
 arch/tile/kernel/process.c              |   8 +-
 arch/unicore32/kernel/sys.c             |   4 +-
 arch/xtensa/kernel/process.c            |   4 +-
 fs/compat.c                             |  12 +-
 fs/exec.c                               |  14 +-
 fs/filesystems.c                        |   4 +-
 fs/internal.h                           |   4 +-
 fs/namei.c                              | 218 +++++++++++++++++++++-----------
 fs/namespace.c                          |   6 +-
 fs/open.c                               |  33 ++++-
 fs/quota/quota.c                        |   4 +-
 include/linux/audit.h                   |  26 ++--
 include/linux/fs.h                      |  23 +++-
 init/do_mounts.c                        |   7 +-
 ipc/mqueue.c                            |   9 +-
 kernel/acct.c                           |   6 +-
 kernel/auditsc.c                        | 136 +++++++++++++-------
 mm/swapfile.c                           |  11 +-
 40 files changed, 400 insertions(+), 229 deletions(-)

-- 
1.7.11.4

