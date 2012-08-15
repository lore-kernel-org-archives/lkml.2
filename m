Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754766Ab2HORII (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Aug 2012 13:08:08 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:35887 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751457Ab2HORIG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Aug 2012 13:08:06 -0400
Date: Wed, 15 Aug 2012 18:07:58 +0100
From: Andy Whitcroft <apw@canonical.com>
To: Casey Schaufler <casey@schaufler-ca.com>
Cc: Miklos Szeredi <miklos@szeredi.hu>, viro@ZenIV.linux.org.uk,
        linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
        hch@infradead.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, nbd@openwrt.org, neilb@suse.de,
        hramrach@centrum.cz, jordipujolp@gmail.com, ezk@fsl.cs.sunysb.edu,
        ricwheeler@gmail.com, dhowells@redhat.com, hpj@urpla.net,
        sedat.dilek@googlemail.com, penberg@kernel.org,
        goran.cetusic@gmail.com, romain@orebokech.com, mszeredi@suse.cz
Subject: Re: [PATCH 12/13] ovl: switch to __inode_permission()
Message-ID: <20120815170758.GP29100@dm>
References: <1345045700-9062-1-git-send-email-miklos@szeredi.hu>
 <1345045700-9062-13-git-send-email-miklos@szeredi.hu>
 <502BD587.6090807@schaufler-ca.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <502BD587.6090807@schaufler-ca.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Aug 15, 2012 at 09:59:51AM -0700, Casey Schaufler wrote:
> On 8/15/2012 8:48 AM, Miklos Szeredi wrote:
> > From: Andy Whitcroft <apw@canonical.com>
> >
> > When checking permissions on an overlayfs inode we do not take into
> > account either device cgroup restrictions nor security permissions.
> > This allows a user to mount an overlayfs layer over a restricted device
> > directory and by pass those permissions to open otherwise restricted
> > files.
> 
> Why is this a good idea? Either you're not including enough context
> about the conditions under which this can occur, or you're suggesting
> the introduction of a trivial mechanism for bypassing all file access
> controls. This does not seem right.

It is stating that the unprotected case is how things was before this
patch switches us over to __inode_permisssions.  The patch is closing
the hole indicated.

-apw
> >
> > Switch over to __inode_permissions.
> >
> > Signed-off-by: Andy Whitcroft <apw@canonical.com>
> > Signed-off-by: Miklos Szeredi <mszeredi@suse.cz>
> > ---
> >  fs/overlayfs/inode.c |   12 +-----------
> >  1 files changed, 1 insertions(+), 11 deletions(-)
> >
> > diff --git a/fs/overlayfs/inode.c b/fs/overlayfs/inode.c
> > index e854720..f3a534f 100644
> > --- a/fs/overlayfs/inode.c
> > +++ b/fs/overlayfs/inode.c
> > @@ -100,19 +100,9 @@ int ovl_permission(struct inode *inode, int mask)
> >  		if (is_upper && !IS_RDONLY(inode) && IS_RDONLY(realinode) &&
> >  		    (S_ISREG(mode) || S_ISDIR(mode) || S_ISLNK(mode)))
> >  			goto out_dput;
> > -
> > -		/*
> > -		 * Nobody gets write access to an immutable file.
> > -		 */
> > -		err = -EACCES;
> > -		if (IS_IMMUTABLE(realinode))
> > -			goto out_dput;
> >  	}
> >  
> > -	if (realinode->i_op->permission)
> > -		err = realinode->i_op->permission(realinode, mask);
> > -	else
> > -		err = generic_permission(realinode, mask);
> > +	err = __inode_permission(realinode, mask);
> >  out_dput:
> >  	dput(alias);
> >  	return err;
> 
