Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754442Ab0I1NFT (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Sep 2010 09:05:19 -0400
Received: from usmamail.tilera.com ([72.1.168.231]:64999 "EHLO
	USMAMAIL.TILERA.COM" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753069Ab0I1NFS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Sep 2010 09:05:18 -0400
Message-ID: <4CA1E809.5010103@tilera.com>
Date: Tue, 28 Sep 2010 09:05:13 -0400
From: Chris Metcalf <cmetcalf@tilera.com>
User-Agent: Mozilla/5.0 (Windows; U; Windows NT 5.1; en-US; rv:1.9.2.9) Gecko/20100915 Thunderbird/3.1.4
MIME-Version: 1.0
To: Arnd Bergmann <arnd@arndb.de>
CC: <linasvepstas@gmail.com>, GLIBC Devel <libc-alpha@sourceware.org>,
        <linux-kernel@vger.kernel.org>, <libc-ports@sourceware.org>
Subject: Re: asm-generic/unistd.h and glibc use of NR_ipc
References: <AANLkTi=33kimswSJ1tYsnG-PVs6Z4dVBtnqq65GN8Vxw@mail.gmail.com> <201009281040.09728.arnd@arndb.de>
In-Reply-To: <201009281040.09728.arnd@arndb.de>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

 (Adding libc-ports to the cc list.)

On 9/28/2010 4:40 AM, Arnd Bergmann wrote:
> Chris Metcalf is using the generic unistd.h file on the tile architecture
> and has a glibc port that should be easily portable to all future
> architectures. There are a few of them getting ready to be merged
> now (c6x, lm32, nios2, and some people have contacted me privately
> for architectures I cannot name).
>
> I expect that all of them will just use the same syscall ABI and glibc
> port.

I'm happy to provide some previews of the work I'm doing to interested parties.

One question for the libc folks is nomenclature.  For now I'm using
"sysdeps/unix/sysv/linux/generic" to hold the sources that are meant to be
used for any architecture that uses Arnd's <asm-generic/unistd.h> along
with the other asm-generic headers, e.g. <asm-generic/stat.h>.   I've
appended a list of the files that I've put in that directory to this
email.  Many of them are there just for handling missing "standard"
syscalls in <asm-generic/unistd.h>; for example the "readlink" syscall
becomes "readlinkat" in dl-origin.c, etc.

Is this the best name to use for the directory, though?  In particular,
glibc already uses "sysdeps/generic" in a slightly special sense to provide
the fallback if no sysdeps override is available for a given file.  But the
Linux naming of "generic unistd.h" is pretty commonplace, so I assume that
in the "linux/" hierarchy it is reasonably clear what that subdirectory means.

In practice, of course, there's still lots of architecture-specific code
that is needed above and beyond the generic Linux subdirectory.  Our 32-bit
platform ("tile/tilepro") has an "Implies" file with
unix/sysv/linux/generic and unix/sysv/linux/generic/wordsize-32; our 64-bit
platform ("tile/tilegx") has an "Implies" file with unix/sysv/linux/generic
and unix/sysv/linux/wordsize-64.  Beyond that we have another 30-odd files
in sysdeps/unix/sysv/linux/tile to implement the non-NPTL part of our glibc
support, plus 50-odd files in sysdeps/tile.

I haven't provided an "nptl/sysdeps/unix/sysv/linux/generic/" directory
since there wasn't anything obviously generic about the "tile" support I
added for NPTL.

Another point where I'd appreciate guidance from libc-alpha is the sysctl()
and ustat() APIs.  The corresponding system calls are missing from
<asm-generic/unistd.h>, since they are deprecated and their functionality
is better provided by other means (/proc/sys, fstat).  So I've simply had
them return -1 with errno == ENOSYS.  Is there any reason to think they
merit more substantial work?  One could imagine baking in some horrible
mapping of "integer names" into path components for a sysctl()
implementation and reading /proc/sys to provide results, or walking all of
the mount points looking for a matching device number to pass a name to
fstat(), but I'm not sure it's worth the bloat to the library.

I have a few patches for the platform-independent glibc code, mostly for
things which are exposed in our platform but not in others.  E.g.
__readlink() in include/unistd.h returns the wrong type (int not ssize_t),
and some of the standard Linux implementations of things like fxstat64.c
need to be completely wrapped with "#ifndef XSTAT_IS_XSTAT64" so that
fxstat.c can provide the alias, since all the stat structures are the same
everywhere.  I will submit some separate patches to libc-alpha for this.

Thanks in advance for any feedback.  Please keep me cc'ed on any
discussions of the generic Linux syscall ABI.  Thanks!

sysdeps/unix/sysv/linux/generic/access.c
sysdeps/unix/sysv/linux/generic/bits/fcntl.h
sysdeps/unix/sysv/linux/generic/bits/sem.h
sysdeps/unix/sysv/linux/generic/bits/stat.h
sysdeps/unix/sysv/linux/generic/bits/typesizes.h
sysdeps/unix/sysv/linux/generic/chmod.c
sysdeps/unix/sysv/linux/generic/chown.c
sysdeps/unix/sysv/linux/generic/lxstat.c
sysdeps/unix/sysv/linux/generic/xstat.c
sysdeps/unix/sysv/linux/generic/Versions
sysdeps/unix/sysv/linux/generic/fxstatat.c
sysdeps/unix/sysv/linux/generic/lchown.c
sysdeps/unix/sysv/linux/generic/link.c
sysdeps/unix/sysv/linux/generic/readlink.c
sysdeps/unix/sysv/linux/generic/open.c
sysdeps/unix/sysv/linux/generic/open64.c
sysdeps/unix/sysv/linux/generic/pipe.c
sysdeps/unix/sysv/linux/generic/poll.c
sysdeps/unix/sysv/linux/generic/recv.c
sysdeps/unix/sysv/linux/generic/rmdir.c
sysdeps/unix/sysv/linux/generic/send.c
sysdeps/unix/sysv/linux/generic/symlink.c
sysdeps/unix/sysv/linux/generic/syscalls.list
sysdeps/unix/sysv/linux/generic/sysdep.h
sysdeps/unix/sysv/linux/generic/unlink.c
sysdeps/unix/sysv/linux/generic/xmknod.c
sysdeps/unix/sysv/linux/generic/sysctl.c
sysdeps/unix/sysv/linux/generic/readlink_chk.c
sysdeps/unix/sysv/linux/generic/ustat.c
sysdeps/unix/sysv/linux/generic/wordsize-32/fcntl.c
sysdeps/unix/sysv/linux/generic/wordsize-32/fstatfs.c
sysdeps/unix/sysv/linux/generic/wordsize-32/ftruncate.c
sysdeps/unix/sysv/linux/generic/wordsize-32/fxstat.c
sysdeps/unix/sysv/linux/generic/wordsize-32/llseek.c
sysdeps/unix/sysv/linux/generic/wordsize-32/lseek.c
sysdeps/unix/sysv/linux/generic/wordsize-32/mmap.c
sysdeps/unix/sysv/linux/generic/wordsize-32/posix_fadvise.c
sysdeps/unix/sysv/linux/generic/wordsize-32/sendfile.c
sysdeps/unix/sysv/linux/generic/wordsize-32/statfs.c
sysdeps/unix/sysv/linux/generic/wordsize-32/truncate.c
sysdeps/unix/sysv/linux/generic/brk.c
sysdeps/unix/sysv/linux/generic/dl-origin.c
sysdeps/unix/sysv/linux/generic/umount.c
sysdeps/unix/sysv/linux/generic/creat.c
sysdeps/unix/sysv/linux/generic/pause.c
sysdeps/unix/sysv/linux/generic/Makefile
sysdeps/unix/sysv/linux/generic/select.c
sysdeps/unix/sysv/linux/generic/epoll_create.c
sysdeps/unix/sysv/linux/generic/epoll_wait.c
sysdeps/unix/sysv/linux/generic/inotify_init.c
sysdeps/unix/sysv/linux/generic/dup2.c
sysdeps/unix/sysv/linux/generic/mkdir.c
sysdeps/unix/sysv/linux/generic/rename.c
sysdeps/unix/sysv/linux/generic/utimes.c

-- 
Chris Metcalf, Tilera Corp.
http://www.tilera.com

