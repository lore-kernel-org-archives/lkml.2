Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753040Ab0E1GKn (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 May 2010 02:10:43 -0400
Received: from mail-vw0-f46.google.com ([209.85.212.46]:59052 "EHLO
	mail-vw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751582Ab0E1GKj convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 May 2010 02:10:39 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=t7YYdEJXkaVlkZu9r1chH8DC0YDAd0QPjPsjOka0plw0pUKChWM1DAZg3HeiT9aSS6
         uzhAhj4M2uJ7NKQWMYcADLdTNb8gs58kxAxVCkb9C4aC7TYiey1HucHE4ld31/YAxz8C
         gUEdk2UkcCsTiYhcTpYGE6BQzwbLAc8RZElr4=
MIME-Version: 1.0
In-Reply-To: <20100527201635.GU6056@outflux.net>
References: <20100527201635.GU6056@outflux.net>
Date: Fri, 28 May 2010 14:10:37 +0800
Message-ID: <AANLkTil8HX2Eko4q7kZYQjoN5C9oPaMvBFZX0oSzBKP6@mail.gmail.com>
Subject: Re: [PATCH] fs: block cross-uid sticky symlinks
From: Dave Young <hidave.darkstar@gmail.com>
To: Kees Cook <kees.cook@canonical.com>
Cc: linux-kernel@vger.kernel.org, linux-security-module@vger.kernel.org,
       linux-doc@vger.kernel.org, Randy Dunlap <rdunlap@xenotime.net>,
       Andrew Morton <akpm@linux-foundation.org>,
       Jiri Kosina <jkosina@suse.cz>,
       Martin Schwidefsky <schwidefsky@de.ibm.com>,
       James Morris <jmorris@namei.org>, Eric Paris <eparis@redhat.com>,
       Serge Hallyn <serue@us.ibm.com>, David Howells <dhowells@redhat.com>,
       Ingo Molnar <mingo@elte.hu>, Peter Zijlstra <a.p.zijlstra@chello.nl>,
       "Eric W. Biederman" <ebiederm@xmission.com>,
       Tim Gardner <tim.gardner@canonical.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, May 28, 2010 at 4:16 AM, Kees Cook <kees.cook@canonical.com> wrote:
> A long-standing class of security issues is the symlink-based
> time-of-check-time-of-use race, most commonly seen in world-writable
> directories like /tmp. The common method of exploitation of this flaw
> is to cross privilege boundaries when following a given symlink (i.e. a
> root process follows a symlink belonging to another user).  For a likely
> incomplete list of hundreds of examples across the years, please see:
> http://cve.mitre.org/cgi-bin/cvekey.cgi?keyword=/tmp
>
> The solution is to permit symlinks to only be followed when outside a sticky
> world-writable directory, or when the uid of the symlink and follower match,
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
> - Violates POSIX.
>  - POSIX didn't consider this situation and it's not useful to follow
>    a broken specification at the cost of security.
> - Might break unknown applications that use this feature.
>   - Applications that break because of the change are easy to spot and
>     fix. Applications that are vulnerable to symlink ToCToU by not having
>     the change aren't.
> - Applications should just use mkstemp() or O_CREATE|O_EXCL.
>  - True, but applications are not perfect, and new software is written
>    all the time that makes these mistakes; blocking this flaw at the
>    kernel is a single solution to the entire class of vulnerability.
>
> This patch is based on the patch in Openwall and grsecurity.  I have
> added a sysctl to toggle the behavior back to the old handling via
> /proc/sys/fs/weak-sticky-symlinks, documentation, and a ratelimited
> warning.
>
> Signed-off-by: Kees Cook <kees.cook@canonical.com>
> ---
>  Documentation/sysctl/kernel.txt |   16 ++++++++++++++++
>  include/linux/security.h        |    1 +
>  kernel/sysctl.c                 |   10 ++++++++++
>  security/capability.c           |    6 ------
>  security/commoncap.c            |   25 +++++++++++++++++++++++++
>  5 files changed, 52 insertions(+), 6 deletions(-)
>
> diff --git a/Documentation/sysctl/kernel.txt b/Documentation/sysctl/kernel.txt
> index 3894eaa..6b059f6 100644
> --- a/Documentation/sysctl/kernel.txt
> +++ b/Documentation/sysctl/kernel.txt
> @@ -66,6 +66,7 @@ show up in /proc/sys/kernel:
>  - threads-max
>  - unknown_nmi_panic
>  - version
> +- weak-sticky-symlinks
>
>  ==============================================================
>
> @@ -526,3 +527,18 @@ A small number of systems do generate NMI's for bizarre random reasons such as
>  power management so the default is off. That sysctl works like the existing
>  panic controls already in that directory.
>
> +==============================================================
> +
> +weak-sticky-symlinks:
> +
> +Following symlinks in world-writable sticky directories (like /tmp) can
> +be dangerous due to time-of-check-time-of-use races that frequently result
> +in security vulnerabilities.  By default, symlinks can only be followed in
> +sticky world-writable directories if the symlink and the follower's uid
> +match (or if the symlink is owned by the owner of the world-writable directory
> +itself).
> +
> +The default value is "0".  To disable this protection, setting a value of "1"
> +will allow symlinks in sticky world-writable directories to be followed by
> +anyone.
> +
> diff --git a/include/linux/security.h b/include/linux/security.h
> index 0c88191..a06d568 100644
> --- a/include/linux/security.h
> +++ b/include/linux/security.h
> @@ -67,6 +67,7 @@ extern int cap_inode_setxattr(struct dentry *dentry, const char *name,
>  extern int cap_inode_removexattr(struct dentry *dentry, const char *name);
>  extern int cap_inode_need_killpriv(struct dentry *dentry);
>  extern int cap_inode_killpriv(struct dentry *dentry);
> +extern int cap_inode_follow_link(struct dentry *dentry, struct nameidata *nd);
>  extern int cap_file_mmap(struct file *file, unsigned long reqprot,
>                         unsigned long prot, unsigned long flags,
>                         unsigned long addr, unsigned long addr_only);
> diff --git a/kernel/sysctl.c b/kernel/sysctl.c
> index 997080f..bf2d68b 100644
> --- a/kernel/sysctl.c
> +++ b/kernel/sysctl.c
> @@ -88,6 +88,7 @@ extern int sysctl_oom_dump_tasks;
>  extern int max_threads;
>  extern int core_uses_pid;
>  extern int suid_dumpable;
> +extern int weak_sticky_symlinks;

It will be better to put in security.h

>  extern char core_pattern[];
>  extern unsigned int core_pipe_limit;
>  extern int pid_max;
> @@ -1463,6 +1464,15 @@ static struct ctl_table fs_table[] = {
>                .extra1         = &zero,
>                .extra2         = &two,
>        },
> +       {
> +               .procname       = "weak-sticky-symlinks",
> +               .data           = &weak_sticky_symlinks,
> +               .maxlen         = sizeof(int),
> +               .mode           = 0644,
> +               .proc_handler   = proc_dointvec_minmax,
> +               .extra1         = &zero,
> +               .extra2         = &one,
> +       },
>  #if defined(CONFIG_BINFMT_MISC) || defined(CONFIG_BINFMT_MISC_MODULE)
>        {
>                .procname       = "binfmt_misc",
> diff --git a/security/capability.c b/security/capability.c
> index 8168e3e..ff34291 100644
> --- a/security/capability.c
> +++ b/security/capability.c
> @@ -169,12 +169,6 @@ static int cap_inode_readlink(struct dentry *dentry)
>        return 0;
>  }
>
> -static int cap_inode_follow_link(struct dentry *dentry,
> -                                struct nameidata *nameidata)
> -{
> -       return 0;
> -}
> -
>  static int cap_inode_permission(struct inode *inode, int mask)
>  {
>        return 0;
> diff --git a/security/commoncap.c b/security/commoncap.c
> index 4e01599..e7eb397 100644
> --- a/security/commoncap.c
> +++ b/security/commoncap.c
> @@ -29,6 +29,9 @@
>  #include <linux/securebits.h>
>  #include <linux/syslog.h>
>
> +/* sysctl for symlink permissions checking */
> +int weak_sticky_symlinks;
> +
>  /*
>  * If a non-root user executes a setuid-root binary in
>  * !secure(SECURE_NOROOT) mode, then we raise capabilities.
> @@ -281,6 +284,28 @@ int cap_inode_killpriv(struct dentry *dentry)
>        return inode->i_op->removexattr(dentry, XATTR_NAME_CAPS);
>  }
>
> +int cap_inode_follow_link(struct dentry *dentry,
> +                         struct nameidata *nameidata)
> +{
> +       const struct inode *parent = dentry->d_parent->d_inode;
> +       const struct inode *inode = dentry->d_inode;
> +       const struct cred *cred = current_cred();
> +
> +       if (weak_sticky_symlinks)
> +               return 0;
> +
> +       if (S_ISLNK(inode->i_mode) &&
> +           (parent->i_mode & (S_ISVTX|S_IWOTH)) == (S_ISVTX|S_IWOTH) &&
> +           parent->i_uid != inode->i_uid &&
> +           cred->fsuid != inode->i_uid) {
> +               printk_ratelimited(KERN_NOTICE "non-matching-uid symlink "
> +                       "following attempted in sticky-directory by "
> +                       "%s (fsuid %d)\n", current->comm, cred->fsuid);
> +               return -EACCES;
> +       }
> +       return 0;
> +}
> +
>  /*
>  * Calculate the new process capability sets from the capability sets attached
>  * to a file.
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
