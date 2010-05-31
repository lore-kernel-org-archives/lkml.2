Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751310Ab0EaEYS (ORCPT <rfc822;w@1wt.eu>);
	Mon, 31 May 2010 00:24:18 -0400
Received: from smtp.outflux.net ([198.145.64.163]:51189 "EHLO smtp.outflux.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750730Ab0EaEYQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 31 May 2010 00:24:16 -0400
Date: Sun, 30 May 2010 21:23:37 -0700
From: Kees Cook <kees.cook@canonical.com>
To: Eric Paris <eparis@redhat.com>
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
Subject: Re: [PATCH v2] fs: block cross-uid sticky symlinks
Message-ID: <20100531042336.GS6056@outflux.net>
References: <20100531030402.GQ6056@outflux.net>
 <1275278063.20730.16.camel@localhost>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1275278063.20730.16.camel@localhost>
Organization: Canonical
X-HELO: www.outflux.net
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Eric,

On Sun, May 30, 2010 at 11:54:23PM -0400, Eric Paris wrote:
> We need to call this function in the SELinux case.  So you'll need a
> patch like the one attached (not even compiled but I think it is right)
> [..]
>  static int selinux_inode_follow_link(struct dentry *dentry, struct nameidata *nameidata)
> [..]
> +       rc = cap_inode_follow_link(dentry, nameidata);

Yeah, when I quickly checked SELinux and AppArmor, it seemed that they
were always calling down to all commoncaps functions, but it looks like
not in all cases.  I think that Eric Biederman's observations here makes
the most sense: this check needs to happen without involving the LSMs
at all.

> > +int cap_inode_follow_link(struct dentry *dentry,
> > +			  struct nameidata *nameidata)
> > +{
> > +	const struct inode *parent = dentry->d_parent->d_inode;
> > +	const struct inode *inode = dentry->d_inode;
> > +	const struct cred *cred = current_cred();
> > +
> > +	if (weak_sticky_symlinks)
> > +		return 0;
> > +
> > +	if ((parent->i_mode & (S_ISVTX|S_IWOTH)) == (S_ISVTX|S_IWOTH) &&
> > +	    parent->i_uid != inode->i_uid &&
> > +	    cred->fsuid != inode->i_uid) {
> > +		printk_ratelimited(KERN_NOTICE "non-matching-uid symlink "
> > +			"following attempted in sticky-directory by "
> > +			"%s (fsuid %d)\n", current->comm, cred->fsuid);
> > +		return -EACCES;
> > +	}
> > +	return 0;
> > +}
> 
> What stops us from racing between the assignment of parent and it's
> first use with a rename on our object and rmdir on the old parent?  I'm
> wondering if we need to be doing this test holding dentry->d_lock (which
> is what protects dentry->d_parent if I recall correctly)
> 
> Certainly doesn't fix all of the raciness, but I think it would close
> the opps part.  Maybe someone who knows the VFS better can tell me if I
> am misguided.

The only other use of d_parent I can see there is in may_delete().  With
vfs_unlink() calling that, it would seem to be racey too if we needed to
hold a lock for that.  But it's not clear to me in vfs_follow_link is doing
locking somehow.

Thanks,

-Kees

-- 
Kees Cook
Ubuntu Security Team
