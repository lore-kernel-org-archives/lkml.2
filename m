Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756031Ab0EaDzd (ORCPT <rfc822;w@1wt.eu>);
	Sun, 30 May 2010 23:55:33 -0400
Received: from mx1.redhat.com ([209.132.183.28]:59572 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755832Ab0EaDza (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 30 May 2010 23:55:30 -0400
Subject: Re: [PATCH v2] fs: block cross-uid sticky symlinks
From: Eric Paris <eparis@redhat.com>
To: Kees Cook <kees.cook@canonical.com>
Cc: linux-kernel@vger.kernel.org, linux-security-module@vger.kernel.org,
       linux-fsdevel@vger.kernel.org, linux-doc@vger.kernel.org,
       Randy Dunlap <rdunlap@xenotime.net>,
       Andrew Morton <akpm@linux-foundation.org>,
       Jiri Kosina <jkosina@suse.cz>, Dave Young <hidave.darkstar@gmail.com>,
       Martin Schwidefsky <schwidefsky@de.ibm.com>,
       James Morris <jmorris@namei.org>, David Howells <dhowells@redhat.com>,
       Ingo Molnar <mingo@elte.hu>, Peter Zijlstra <a.p.zijlstra@chello.nl>,
       "Eric W. Biederman" <ebiederm@xmission.com>,
       Tim Gardner <tim.gardner@canonical.com>,
       "Serge E. Hallyn" <serue@us.ibm.com>, sds@tycho.nsa.gov,
       selinux@tycho.nsa.gov
In-Reply-To: <20100531030402.GQ6056@outflux.net>
References: <20100531030402.GQ6056@outflux.net>
Content-Type: text/plain; charset="UTF-8"
Date: Sun, 30 May 2010 23:54:23 -0400
Message-ID: <1275278063.20730.16.camel@localhost>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 2010-05-30 at 20:04 -0700, Kees Cook wrote:
> A long-standing class of security issues is the symlink-based
> time-of-check-time-of-use race, most commonly seen in world-writable
> directories like /tmp. The common method of exploitation of this flaw
> is to cross privilege boundaries when following a given symlink (i.e. a
> root process follows a symlink belonging to another user).  For a likely
> incomplete list of hundreds of examples across the years, please see:
> http://cve.mitre.org/cgi-bin/cvekey.cgi?keyword=/tmp
> 
> The solution is to permit symlinks to only be followed when outside a sticky
> world-writable directory, or when the uid of the symlink and follower match,
> or when the directory owner matches the symlink's owner.
> 
> Some pointers to the history of earlier discussion that I could find:
> 
>  1996 Aug, Zygo Blaxell
>   http://marc.info/?l=bugtraq&m=87602167419830&w=2
>  1996 Oct, Andrew Tridgell
>   http://lkml.indiana.edu/hypermail/linux/kernel/9610.2/0086.html
>  1997 Dec, Albert D Cahalan
>   http://lkml.org/lkml/1997/12/16/4
>  2005 Feb, Lorenzo Hernández García-Hierro
>   http://lkml.indiana.edu/hypermail/linux/kernel/0502.0/1896.html
> 
> Past objections and rebuttals could be summarized as:
> 
>  - Violates POSIX.
>    - POSIX didn't consider this situation and it's not useful to follow
>      a broken specification at the cost of security.
>  - Might break unknown applications that use this feature.
>    - Applications that break because of the change are easy to spot and
>      fix. Applications that are vulnerable to symlink ToCToU by not having
>      the change aren't.
>  - Applications should just use mkstemp() or O_CREATE|O_EXCL.
>    - True, but applications are not perfect, and new software is written
>      all the time that makes these mistakes; blocking this flaw at the
>      kernel is a single solution to the entire class of vulnerability.
> 
> This patch is based on the patch in Openwall and grsecurity.  I have
> added a sysctl to toggle the behavior back to the old logic via
> /proc/sys/fs/weak-sticky-symlinks, documentation, and a ratelimited
> warning.
> 
> v2:
>  - dropped redundant S_ISLNK check.
>  - moved sysctl extern into security.h.
>  - asked to include CC to linux-fsdevel.

We need to call this function in the SELinux case.  So you'll need a
patch like the one attached (not even compiled but I think it is right)

diff --git a/security/selinux/hooks.c b/security/selinux/hooks.c
index 5c9f25b..d6ebee2 100644
--- a/security/selinux/hooks.c
+++ b/security/selinux/hooks.c
@@ -2668,8 +2668,13 @@ static int selinux_inode_readlink(struct dentry *dentry)
 
 static int selinux_inode_follow_link(struct dentry *dentry, struct nameidata *nameidata)
 {
+       int rc;
        const struct cred *cred = current_cred();
 
+       rc = cap_inode_follow_link(dentry, nameidata);
+       if (rc)
+               return rc;
+
        return dentry_has_perm(cred, NULL, dentry, FILE__READ);
 }
 

> +int cap_inode_follow_link(struct dentry *dentry,
> +			  struct nameidata *nameidata)
> +{
> +	const struct inode *parent = dentry->d_parent->d_inode;
> +	const struct inode *inode = dentry->d_inode;
> +	const struct cred *cred = current_cred();
> +
> +	if (weak_sticky_symlinks)
> +		return 0;
> +
> +	if ((parent->i_mode & (S_ISVTX|S_IWOTH)) == (S_ISVTX|S_IWOTH) &&
> +	    parent->i_uid != inode->i_uid &&
> +	    cred->fsuid != inode->i_uid) {
> +		printk_ratelimited(KERN_NOTICE "non-matching-uid symlink "
> +			"following attempted in sticky-directory by "
> +			"%s (fsuid %d)\n", current->comm, cred->fsuid);
> +		return -EACCES;
> +	}
> +	return 0;
> +}

What stops us from racing between the assignment of parent and it's
first use with a rename on our object and rmdir on the old parent?  I'm
wondering if we need to be doing this test holding dentry->d_lock (which
is what protects dentry->d_parent if I recall correctly)

Certainly doesn't fix all of the raciness, but I think it would close
the opps part.  Maybe someone who knows the VFS better can tell me if I
am misguided.

-Eric


