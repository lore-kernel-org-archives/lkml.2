Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754301Ab2BPSRo (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Feb 2012 13:17:44 -0500
Received: from mx1.redhat.com ([209.132.183.28]:4440 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753636Ab2BPSRn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Feb 2012 13:17:43 -0500
From: David Howells <dhowells@redhat.com>
Subject: [PATCH 0/3] Eliminating __FD_*() functions from the kernel
References: <1328677745-20121-1-git-send-email-hpa@zytor.com>
To: linux-arch@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-fsdevel@vger.kernel.org, viro@ZenIV.linux.org.uk
Cc: hpa@zytor.com, torvalds@osdl.org, arnd@arndb.de, dhowells@redhat.com
Date: Thu, 16 Feb 2012 17:49:30 +0000
Message-ID: <20120216174930.23314.69764.stgit@warthog.procyon.org.uk>
User-Agent: StGIT/0.14.3
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Having examined H. Peter Anvin's patches to merge asm/posix_types.h together, I
think that we can go further: The FD_SET(), FD_CLR() and FD_ISSET() macros are
only used within the kernel itself in relation to the arrays of fd-is-open
flags and close-on-exec flags.  FD_ZERO() is not used at all within the kernel.

Now, the FD_SET() & co. wrappers must be exported to userspace, so they must be
kept, but the __FD_SET() & co. implementations behind them on most arches are
_not_ so exported.  Possibly PowerPC, MN10300 and Xtensa would survive their
removal entirely from the userspace API as per Peter's patches.

Examining the two remaining usages of struct fd_set, and FD_*() and __FD_*()
for the arrays of bits in struct fdtable, it would seem that we could just move
to using unsigned long directly rather than fd_set, and using __set_bit(),
__clear_bit() and test_bit() upon those.

This would also get rid of two abuses of the fd_set struct within this code:

 (1) Most of the time, the two fd_sets pointed to by struct fdtable are not the
     length they're supposed to be, and are, in fact, allocated short.  This
     means FD_ZERO() may not be used on them, for example.

     Basically, in effect, alloc_fdmem() allocates an array of unsigned longs
     just long enough and then casts it to an fd_set - so why bother with the
     fd_set at all?

 (2) Non-core VFS code (such as SELinux) sometimes wants to look through the
     array of unsigned longs inside the fd_set for the purposes of more
     efficient iteration over the entire set of open fds - so why not just
     eliminate the fd_set and go directly with an array of unsigned longs?

Furthermore, within the kernel, __FD_SET() and co. are redundant bitops and,
in the original implementation, may actually be less efficient.  For instance,
on x86/x86_64, __set_bit() uses the BTS instruction, but __FD_SET() may well
not (depending on the optimiser).  I note that Peter's patch does alter this.


So my patches do the following:

 (1) Wrap the normal set/bit/test operations on the open_fds and close_on_exec
     fd_sets so that the access to them is, for the most part, not open coded.

     There's still the issue of the things that poke around inside the fd_sets
     behind the scenes (SELinux for example).

 (2) Replace the fd_set with an unsigned long array and use __set_bit() and
     co. instead of FD_SET() and co.

     It might just be better to replace the uses of FD_SET() and co. with
     __set_bit() and co. directly, and not bother with wrappers, but the
     wrappers are more greppable.

 (3) Delete __FD_SET() and co. from linux/time.h.

And are implemented to go on top of Peter's posix_types patchset.

David
---
David Howells (3):
      Delete the __FD_*() funcs for operating on fd_set from linux/time.h
      Replace the fd_sets in struct fdtable with an array of unsigned longs
      Wrap accesses to the fd_sets in struct fdtable


 Documentation/filesystems/files.txt          |    4 +-
 arch/powerpc/platforms/cell/spufs/coredump.c |    2 -
 drivers/staging/android/binder.c             |   10 ++---
 fs/autofs4/dev-ioctl.c                       |    2 -
 fs/exec.c                                    |    8 ++--
 fs/fcntl.c                                   |   18 ++++-----
 fs/file.c                                    |   54 +++++++++++++-------------
 fs/open.c                                    |    4 +-
 fs/proc/base.c                               |    2 -
 fs/select.c                                  |    2 -
 include/linux/fdtable.h                      |   46 ++++++++++++++++------
 include/linux/time.h                         |   22 -----------
 kernel/exit.c                                |    2 -
 security/selinux/hooks.c                     |    2 -
 14 files changed, 88 insertions(+), 90 deletions(-)

