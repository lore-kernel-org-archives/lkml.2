Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759259Ab0KQWMc (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Nov 2010 17:12:32 -0500
Received: from mx1.redhat.com ([209.132.183.28]:61737 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758606Ab0KQWMb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Nov 2010 17:12:31 -0500
Subject: Re: [PATCH] fs: call security_d_instantiate in d_obtain_alias
From: Eric Paris <eparis@redhat.com>
To: "J. Bruce Fields" <bfields@fieldses.org>
Cc: Josef Bacik <josef@redhat.com>, linux-fsdevel@vger.kernel.org,
        linux-kernel@vger.kernel.org, sds@tycho.nsa.gov, selinux@tycho.nsa.gov,
        linux-security-module@vger.kernel.org
In-Reply-To: <20101117202617.GA31009@fieldses.org>
References: <1290016263-1637-1-git-send-email-josef@redhat.com>
	 <20101117191817.GA26575@fieldses.org>
	 <20101117192822.GB3818@localhost.localdomain>
	 <20101117202617.GA31009@fieldses.org>
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 17 Nov 2010 17:12:21 -0500
Message-ID: <1290031941.14282.101.camel@localhost.localdomain>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2010-11-17 at 15:26 -0500, J. Bruce Fields wrote:
> On Wed, Nov 17, 2010 at 02:28:22PM -0500, Josef Bacik wrote:
> > On Wed, Nov 17, 2010 at 02:18:17PM -0500, J. Bruce Fields wrote:
> > > On Wed, Nov 17, 2010 at 12:51:03PM -0500, Josef Bacik wrote:
> > > > While trying to track down some NFS problems with BTRFS, I kept noticing I was
> > > > getting -EACCESS for no apparent reason.  Eric Paris and printk() helped me
> > > > figure out that it was SELinux that was giving me grief, with the following
> > > > denial
> > > > 
> > > > type=AVC msg=audit(1290013638.413:95): avc:  denied  { 0x800000 } for  pid=1772
> > > > comm="nfsd" name="" dev=sda1 ino=256 scontext=system_u:system_r:kernel_t:s0
> > > > tcontext=system_u:object_r:unlabeled_t:s0 tclass=file
> > > > 
> > > > Turns out this is because in d_obtain_alias if we can't find an alias we create
> > > > one and do all the normal instantiation stuff, but we don't do the
> > > > security_d_instantiate.  With this patch I'm no longer seeing these errant
> > > > -EACCESS return values.  Thanks,
> > > 
> > > Possibly dumb question: Is there still a small race here?  Is it
> > > possible for another nfsd thread to find the new alias on the list while
> > > this thread is still:
> > > 
> > > > 
> > > > Signed-off-by: Josef Bacik <josef@redhat.com>
> > > > ---
> > > >  fs/dcache.c |    1 +
> > > >  1 files changed, 1 insertions(+), 0 deletions(-)
> > > > 
> > > > diff --git a/fs/dcache.c b/fs/dcache.c
> > > > index 23702a9..890a59e 100644
> > > > --- a/fs/dcache.c
> > > > +++ b/fs/dcache.c
> > > > @@ -1201,6 +1201,7 @@ struct dentry *d_obtain_alias(struct inode *inode)
> > > >  	spin_unlock(&tmp->d_lock);
> > > >  
> > > >  	spin_unlock(&dcache_lock);
> > > 
> > > ... right here, so that that other nfsd thread still ends up trying to
> > > do something with a dentry that hasn't had security_d_instantiate called
> > > on it yet?
> > > 
> > > > +	security_d_instantiate(tmp, inode);
> > > >  	return tmp;
> > > >  
> > > >   out_iput:
> > > > -- 
> > > 
> > > Or does something else prevent that?
> > > 
> > 
> > That's a good question, I have no idea actually.  Every other consumer of
> > security_d_instantiate seems to hold the i_mutex of the parent directory inode,
> > tho I'm not sure if that is appropriate for d_obtain_alias, maybe somebody else
> > has an idea?  Thanks,
> 
> Actually, I don't get it:
> 
> 	- Why is selinux using a *dentry* operation to initialize an
> 	  *inode*?
> 	- Are security hooks necessarily prepared to handle a
> 	  disconnected dentry?  (Which has no real parent, name an empty
> 	  string, etc.)
> 	- What use is the dentry to the security module in this case
> 	  anyway?

I only know a bit from the SELinux world and can't speak at all for any
other LSMs.  SELinux however needs the dentry when an inode first enters
core for a couple of reasons.  (once the inode is in core it should have
already been initialized and we skip all this)

If you have persistent xattr support we need the dentry since the xattr
code requires a dentry.  I have no idea why but that's what
inode->i_op->getxattr() requires.

Then we come to procfs.  In that filesystem we actually label based on
the pathname.  oh no did I say SELinux uses pathnames?  yes, I did, but
we only use the part of the pathname relative to the procfs root, so
really it's a static identifier which is immutable.

>From what I can see SELinux doesn't really care about the dentry, we
don't care about IS_ROOT() or the name or any of that crap (in the
non-procfs case).  All we really about is that if something can find an
inode and use it that security_d_instantiate() was called....

Calling security_d_instantiate() extra times is very low overhead and
not harmful.  the dirtiest (but easiest I guess) fix would be to add it
into the out_iput path as well.  I feel like there has to be an easier
solution, I'm just not sure what it is...

-Eric

