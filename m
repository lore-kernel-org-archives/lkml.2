Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933455Ab0FCAvc (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Jun 2010 20:51:32 -0400
Received: from mail-vw0-f46.google.com ([209.85.212.46]:51015 "EHLO
	mail-vw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932771Ab0FCAva convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Jun 2010 20:51:30 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=tQH4CVvzPC/iwGSjzDnaPK3rufYv1d5OsqLDYW2Ck8HlN0EQare3JpC0wzZRPfWpWz
         XPw/SnOLGAqqrQgEIAOZb2EZ17Vgy6lmgJtLAZblihAYnoO1dseBtIBeuUPP7x33GCbK
         IXT6biagmAADHp0SgfTW9ujIJl2Lb8yf92UuI=
MIME-Version: 1.0
In-Reply-To: <20100602222302.GC6554@outflux.net>
References: <20100602222302.GC6554@outflux.net>
Date: Thu, 3 Jun 2010 08:51:28 +0800
Message-ID: <AANLkTinnzPBlbB6q2v9Bfg55Rum809ko-K0ecWQJwWbB@mail.gmail.com>
Subject: Re: [PATCH v4] fs: allow protected cross-uid sticky symlinks
From: Dave Young <hidave.darkstar@gmail.com>
To: Kees Cook <kees.cook@canonical.com>
Cc: Al Viro <viro@zeniv.linux.org.uk>, Eric Paris <eparis@redhat.com>,
       Christoph Hellwig <hch@infradead.org>, James Morris <jmorris@namei.org>,
       linux-kernel@vger.kernel.org, linux-security-module@vger.kernel.org,
       linux-fsdevel@vger.kernel.org, linux-doc@vger.kernel.org,
       Randy Dunlap <rdunlap@xenotime.net>,
       Andrew Morton <akpm@linux-foundation.org>,
       Jiri Kosina <jkosina@suse.cz>,
       Martin Schwidefsky <schwidefsky@de.ibm.com>,
       David Howells <dhowells@redhat.com>, Ingo Molnar <mingo@elte.hu>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       "Eric W. Biederman" <ebiederm@xmission.com>,
       Tim Gardner <tim.gardner@canonical.com>,
       "Serge E. Hallyn" <serue@us.ibm.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jun 3, 2010 at 6:23 AM, Kees Cook <kees.cook@canonical.com> wrote:
> A long-standing class of security issues is the symlink-based
> time-of-check-time-of-use race, most commonly seen in world-writable
> directories like /tmp. The common method of exploitation of this flaw
> is to cross privilege boundaries when opening a file through a given
> symlink (i.e. a root process opens a symlink belonging to another user).
> For a likely incomplete list of hundreds of examples across the years,
> please see: http://cve.mitre.org/cgi-bin/cvekey.cgi?keyword=/tmp
>
> The solution is to permit symlinks to only be opened when outside a sticky
> world-writable directory, or when the uid of the symlink and opener match,
> or when the directory owner matches the symlink's owner.
>
> Some pointers to the history of earlier discussion that I could find:
>
>  1996 Aug, Zygo Blaxell
>  http://marc.info/?l=bugtraq&m=87602167419830&w=2
>  1996 Oct, Andrew Tridgell
>  http://lkml.indiana.edu/hypermail/linux/kernel/9610.2/0086.html
>  1997 Dec, Albert D Cahalan
>  http://lkml.org/lkml/1997/12/16/4
>  2005 Feb, Lorenzo Hernández García-Hierro
>  http://lkml.indiana.edu/hypermail/linux/kernel/0502.0/1896.html
>
> Past objections and rebuttals could be summarized as:
>
>  - Violates POSIX.
>   - POSIX didn't consider this situation and it's not useful to follow
>     a broken specification at the cost of security.
>  - Might break unknown applications that use this feature.
>   - Applications that break because of the change are easy to spot and
>     fix. Applications that are vulnerable to symlink ToCToU by not having
>     the change aren't.
>  - Applications should just use mkstemp() or O_CREATE|O_EXCL.
>   - True, but applications are not perfect, and new software is written
>     all the time that makes these mistakes; blocking this flaw at the
>     kernel is a single solution to the entire class of vulnerability.
>
> This patch is based on the patch in Openwall and grsecurity, but with the
> scope changed to be only "opening" a symlink.  I have added a sysctl to
> enable the protected behavior, documentation, and a ratelimited warning.
>
> v2:
>  - dropped redundant S_ISLNK check.
>  - moved sysctl extern into security.h.

Not in v4?

>  - asked to include CC to linux-fsdevel.
>
> v3:
>  - move into VFS core.
>  - add CONFIG entry for build-time default.
>  - rename sysctl, invert logic.
>  - use get_task_comm for task name.
>  - lock dentry when checking parent.
>
> v4:
>  - limit check to leaf symlink opening.
>
> Signed-off-by: Kees Cook <kees.cook@canonical.com>
> ---
>  Documentation/sysctl/fs.txt |   15 ++++++++++
>  fs/Kconfig                  |   15 ++++++++++
>  fs/namei.c                  |   61 +++++++++++++++++++++++++++++++++++++++++++
>  kernel/sysctl.c             |   10 +++++++
>  4 files changed, 101 insertions(+), 0 deletions(-)
>
> diff --git a/Documentation/sysctl/fs.txt b/Documentation/sysctl/fs.txt
> index 6268250..9986bce 100644
> --- a/Documentation/sysctl/fs.txt
> +++ b/Documentation/sysctl/fs.txt
> @@ -32,6 +32,7 @@ Currently, these files are in /proc/sys/fs:
>  - nr_open
>  - overflowuid
>  - overflowgid
> +- protected-sticky-symlinks
>  - suid_dumpable
>  - super-max
>  - super-nr
> @@ -158,6 +159,20 @@ The default is 65534.
>
>  ==============================================================
>
> +protected-sticky-symlinks:
> +
> +Opening symlinks in sticky world-writable directories (like /tmp) can be
> +dangerous due to time-of-check-time-of-use races that frequently result
> +in security vulnerabilities.
> +
> +The default value is "0", leaving the behavior of symlink opening
> +unchanged from POSIX.  A value of "1" will enable the protection, causing
> +symlinks to be openable only if outside a sticky world-writable directory,
> +or if the symlink and the opener's uid match, or if the symlink and its
> +directory are owned by the same uid.
> +
> +==============================================================
> +
>  suid_dumpable:
>
>  This value can be used to query and set the core dump mode for setuid
> diff --git a/fs/Kconfig b/fs/Kconfig
> index 5f85b59..48df7cd 100644
> --- a/fs/Kconfig
> +++ b/fs/Kconfig
> @@ -256,3 +256,18 @@ source "fs/nls/Kconfig"
>  source "fs/dlm/Kconfig"
>
>  endmenu
> +
> +config PROTECTED_STICKY_SYMLINKS
> +       bool "Protect symlink opening in sticky world-writable directories"
> +       help
> +         A long-standing class of security issues is the symlink-based
> +         time-of-check-time-of-use race, most commonly seen in
> +         world-writable directories like /tmp. The common method of
> +         exploitation of this flaw is to cross privilege boundaries
> +         when opening a given symlink (i.e. a root process opens a
> +          malicious symlink belonging to another user).
> +
> +         Enabling this solves the problem by permitting symlinks to only
> +         be opened when outside a sticky world-writable directory, or
> +          when the uid of the symlink and opener match, or when the
> +          directory and symlink owners match.
> diff --git a/fs/namei.c b/fs/namei.c
> index 868d0cb..ee9d493 100644
> --- a/fs/namei.c
> +++ b/fs/namei.c
> @@ -32,6 +32,7 @@
>  #include <linux/fcntl.h>
>  #include <linux/device_cgroup.h>
>  #include <linux/fs_struct.h>
> +#include <linux/ratelimit.h>
>  #include <asm/uaccess.h>
>
>  #include "internal.h"
> @@ -530,6 +531,60 @@ static inline void path_to_nameidata(struct path *path, struct nameidata *nd)
>        nd->path.dentry = path->dentry;
>  }
>
> +int protected_sticky_symlinks = CONFIG_PROTECTED_STICKY_SYMLINKS;
> +
> +/**
> + * may_open_sticky_symlink - Check symlink opening for unsafe situations
> + * @dentry: The inode/dentry of the symlink
> + * @nameidata: The path data of the symlink
> + *
> + * In the case of the protected_sticky_symlinks sysctl being enabled,
> + * CAP_DAC_OVERRIDE needs to be specifically ignored if the symlink is
> + * in a sticky world-writable directory.  This is to protect privileged
> + * processes from failing races against path names that may change out
> + * from under them by way of other users creating malicious symlinks.
> + * It will permit symlinks to only be opened when outside a sticky
> + * world-writable directory, or when the uid of the symlink and opener
> + * match, or when the directory owner matches the symlink's owner.
> + *
> + * Returns 0 if opening the symlink is allowed, -ve on error.
> + */
> +static __always_inline int
> +may_open_sticky_symlink(struct dentry *dentry, struct nameidata *nameidata)
> +{
> +       int error = 0;
> +       const struct inode *parent;
> +       const struct inode *inode;
> +       const struct cred *cred;
> +
> +       if (!protected_sticky_symlinks)
> +               return 0;
> +
> +       /* owner and opener match? */
> +       cred = current_cred();
> +       inode = dentry->d_inode;
> +       if (cred->fsuid == inode->i_uid)
> +               return 0;
> +
> +       /* check parent directory mode and owner */
> +       spin_lock(&dentry->d_lock);
> +       parent = dentry->d_parent->d_inode;
> +       if ((parent->i_mode & (S_ISVTX|S_IWOTH)) == (S_ISVTX|S_IWOTH) &&
> +           parent->i_uid != inode->i_uid) {
> +               error = -EACCES;
> +       }
> +       spin_unlock(&dentry->d_lock);
> +
> +       if (error) {
> +               char name[sizeof(current->comm)];
> +               printk_ratelimited(KERN_NOTICE "non-matching-uid symlink "
> +                       "opening attempted in sticky world-writable "
> +                       "directory by %s (fsuid %d)\n",
> +                       get_task_comm(name, current), cred->fsuid);
> +       }
> +       return error;
> +}
> +
>  static __always_inline int
>  __do_follow_link(struct path *path, struct nameidata *nd, void **p)
>  {
> @@ -1844,6 +1899,12 @@ reval:
>                        goto exit_dput;
>                if (count++ == 32)
>                        goto exit_dput;
> +
> +               /* check if this symlink is in a sticky world-write dir */
> +               error = may_open_sticky_symlink(path.dentry, &nd);
> +               if (error)
> +                       goto exit_dput;
> +
>                /*
>                 * This is subtle. Instead of calling do_follow_link() we do
>                 * the thing by hands. The reason is that this way we have zero
> diff --git a/kernel/sysctl.c b/kernel/sysctl.c
> index 997080f..56affd6 100644
> --- a/kernel/sysctl.c
> +++ b/kernel/sysctl.c
> @@ -87,6 +87,7 @@ extern int sysctl_oom_kill_allocating_task;
>  extern int sysctl_oom_dump_tasks;
>  extern int max_threads;
>  extern int core_uses_pid;
> +extern int protected_sticky_symlinks;
>  extern int suid_dumpable;
>  extern char core_pattern[];
>  extern unsigned int core_pipe_limit;
> @@ -1455,6 +1456,15 @@ static struct ctl_table fs_table[] = {
>  #endif
>  #endif
>        {
> +               .procname       = "protected-sticky-symlinks",
> +               .data           = &protected_sticky_symlinks,
> +               .maxlen         = sizeof(int),
> +               .mode           = 0644,
> +               .proc_handler   = proc_dointvec_minmax,
> +               .extra1         = &zero,
> +               .extra2         = &one,
> +       },
> +       {
>                .procname       = "suid_dumpable",
>                .data           = &suid_dumpable,
>                .maxlen         = sizeof(int),
> --
> 1.7.0.4
>
>
> --
> Kees Cook
> Ubuntu Security Team
>



-- 
Regards
dave
