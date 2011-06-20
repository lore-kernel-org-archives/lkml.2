Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755919Ab1FTVcK (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Jun 2011 17:32:10 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:55219 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755412Ab1FTVcF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Jun 2011 17:32:05 -0400
Date: Mon, 20 Jun 2011 14:31:31 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: drepper@akkadia.org
Cc: kosaki.motohiro@jp.fujitsu.com, linux-kernel@vger.kernel.org,
        rientjes@google.com, torvalds@linux-foundation.org,
        viro@zeniv.linux.org.uk, wilsons@start.ca, linux-man@vger.kernel.org,
        Yoshinori Sato <ysato@users.sourceforge.jp>,
        Geert Uytterhoeven <geert@linux-m68k.org>,
        Chris Zankel <chris@zankel.net>
Subject: Re: [PATCH] Add cloexec information to fdinfo
Message-Id: <20110620143131.9c6e040c.akpm@linux-foundation.org>
In-Reply-To: <201106100355.p5A3t8Aa024924@drepperk.user.openhosting.com>
References: <201106100355.p5A3t8Aa024924@drepperk.user.openhosting.com>
X-Mailer: Sylpheed 3.0.2 (GTK+ 2.20.1; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 9 Jun 2011 23:55:08 -0400
drepper@akkadia.org wrote:

> There is one piece of information about a file descriptor which is
> currently not visible from the outside: the close-on-exec flag.  The
> /proc/PID/fdinfo/* files have the mode information but this is
> missing.  Is the following patch acceptable?
> 
> What I don't know is whether the RCU locking is needed given that
> real locks are taken.  Someone with more knowledge could just
> remove those two lines.

The locking looks OK to me.

Hopefully /prod/pid/fdinfo is documented somewhere. 
linux-man@vger.kernel.org appears to be the email address we use to rub
the documentation lamp.

> diff --git a/fs/proc/base.c b/fs/proc/base.c
> index 14def99..bda3651 100644
> --- a/fs/proc/base.c
> +++ b/fs/proc/base.c
> @@ -1924,12 +1924,23 @@ static int proc_fd_info(struct inode *inode, struct path *path, char *info)
>  				*path = file->f_path;
>  				path_get(&file->f_path);
>  			}
> -			if (info)
> +			if (info) {
> +				int cloexec;
> +				struct fdtable *fdt;
> +
> +				rcu_read_lock();
> +				fdt = files_fdtable(files);
> +				cloexec = FD_ISSET(fd, fdt->close_on_exec);

Does FD_ISSET return 0 or 1?  Or 0 or non-zero?

For x86 it's the former.

<checks the architectures>

arch/h8300/include/asm/posix_types.h: busted
#define __FD_ISSET(d, set)      ((set)->fds_bits[__FDELT(d)] & __FDMASK(d))

arch/m68k/include/asm/posix_types.h: busted
#define __FD_ISSET(d, set)      ((set)->fds_bits[__FDELT(d)] & __FDMASK(d))

arch/xtensa/include/asm/posix_types.h: busted
#define __FD_ISSET(d, set)      ((set)->fds_bits[__FDELT(d)] & __FDMASK(d))


From: Andrew Morton <akpm@linux-foundation.org>

Harmonise these return values with other architectures.  In some cases
this affects all compilers and in other cases non-gcc compilers only.

Cc: Yoshinori Sato <ysato@users.sourceforge.jp>
Cc: Geert Uytterhoeven <geert@linux-m68k.org>
Cc: Chris Zankel <chris@zankel.net>
Cc: Ulrich Drepper <drepper@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/h8300/include/asm/posix_types.h  |    2 +-
 arch/m68k/include/asm/posix_types.h   |    2 +-
 arch/xtensa/include/asm/posix_types.h |    2 +-
 3 files changed, 3 insertions(+), 3 deletions(-)

diff -puN arch/h8300/include/asm/posix_types.h~h8300-m68k-xtensa-__fd_isset-should-return-0-1 arch/h8300/include/asm/posix_types.h
--- a/arch/h8300/include/asm/posix_types.h~h8300-m68k-xtensa-__fd_isset-should-return-0-1
+++ a/arch/h8300/include/asm/posix_types.h
@@ -50,7 +50,7 @@ typedef struct {
 #define	__FD_CLR(d, set)	((set)->fds_bits[__FDELT(d)] &= ~__FDMASK(d))
 
 #undef	__FD_ISSET
-#define	__FD_ISSET(d, set)	((set)->fds_bits[__FDELT(d)] & __FDMASK(d))
+#define	__FD_ISSET(d, set)	(!!((set)->fds_bits[__FDELT(d)] & __FDMASK(d)))
 
 #undef	__FD_ZERO
 #define __FD_ZERO(fdsetp) (memset (fdsetp, 0, sizeof(*(fd_set *)fdsetp)))
diff -puN arch/m68k/include/asm/posix_types.h~h8300-m68k-xtensa-__fd_isset-should-return-0-1 arch/m68k/include/asm/posix_types.h
--- a/arch/m68k/include/asm/posix_types.h~h8300-m68k-xtensa-__fd_isset-should-return-0-1
+++ a/arch/m68k/include/asm/posix_types.h
@@ -51,7 +51,7 @@ typedef struct {
 #define	__FD_CLR(d, set)	((set)->fds_bits[__FDELT(d)] &= ~__FDMASK(d))
 
 #undef	__FD_ISSET
-#define	__FD_ISSET(d, set)	((set)->fds_bits[__FDELT(d)] & __FDMASK(d))
+#define	__FD_ISSET(d, set)	(!!((set)->fds_bits[__FDELT(d)] & __FDMASK(d)))
 
 #undef	__FD_ZERO
 #define __FD_ZERO(fdsetp) (memset (fdsetp, 0, sizeof(*(fd_set *)fdsetp)))
diff -puN arch/xtensa/include/asm/posix_types.h~h8300-m68k-xtensa-__fd_isset-should-return-0-1 arch/xtensa/include/asm/posix_types.h
--- a/arch/xtensa/include/asm/posix_types.h~h8300-m68k-xtensa-__fd_isset-should-return-0-1
+++ a/arch/xtensa/include/asm/posix_types.h
@@ -58,7 +58,7 @@ typedef struct {
 
 #define	__FD_SET(d, set)	((set)->fds_bits[__FDELT(d)] |= __FDMASK(d))
 #define	__FD_CLR(d, set)	((set)->fds_bits[__FDELT(d)] &= ~__FDMASK(d))
-#define	__FD_ISSET(d, set)	((set)->fds_bits[__FDELT(d)] & __FDMASK(d))
+#define	__FD_ISSET(d, set)	(!!((set)->fds_bits[__FDELT(d)] & __FDMASK(d)))
 #define	__FD_ZERO(set)	\
   ((void) memset ((void *) (set), 0, sizeof (__kernel_fd_set)))
 
_


> +				rcu_read_unlock();
> +
>  				snprintf(info, PROC_FDINFO_MAX,
>  					 "pos:\t%lli\n"
> -					 "flags:\t0%o\n",
> +					 "flags:\t0%o\n"
> +					 "cloexec: %d\n",

Should use a tab here for consistency.

--- a/fs/proc/base.c~proc-pid-fdinfo-add-cloexec-information-fix
+++ a/fs/proc/base.c
@@ -1936,7 +1936,7 @@ static int proc_fd_info(struct inode *in
 				snprintf(info, PROC_FDINFO_MAX,
 					 "pos:\t%lli\n"
 					 "flags:\t0%o\n"
-					 "cloexec: %d\n",
+					 "cloexec:\t%d\n",
 					 (long long) file->f_pos,
 					 file->f_flags,
 					 cloexec);
_

>  					 (long long) file->f_pos,
> -					 file->f_flags);
> +					 file->f_flags,
> +					 cloexec);
> +			}
>  			spin_unlock(&files->file_lock);
>  			put_files_struct(files);
>  			return 0;
