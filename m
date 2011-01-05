Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751448Ab1AEGoe (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Jan 2011 01:44:34 -0500
Received: from ipmail07.adl2.internode.on.net ([150.101.137.131]:17917 "EHLO
	ipmail07.adl2.internode.on.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751166Ab1AEGod (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Jan 2011 01:44:33 -0500
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AvsEANOgI015Ldpx/2dsb2JhbACkK3S9MYVLBA
Date: Wed, 5 Jan 2011 17:44:25 +1100
From: Nick Piggin <npiggin@kernel.dk>
To: "Venkateswararao Jujjuri (JV)" <jvrao@linux.vnet.ibm.com>
Cc: Stephen Rothwell <sfr@canb.auug.org.au>, Nick Piggin <npiggin@kernel.dk>,
        linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>,
        Eric Van Hensbergen <ericvh@gmail.com>
Subject: Re: linux-next: manual merge of the vfs-scale tree with the v9fs
  tree
Message-ID: <20110105064425.GA3161@amd>
References: <20110104124054.c767a4ee.sfr@canb.auug.org.au>
 <4D2363E7.30101@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4D2363E7.30101@linux.vnet.ibm.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jan 04, 2011 at 10:16:07AM -0800, Venkateswararao Jujjuri (JV) wrote:
> On 1/3/2011 5:40 PM, Stephen Rothwell wrote:
> > Hi Nick,
> > 
> > Today's linux-next merge of the vfs-scale tree got a conflict in
> > fs/9p/vfs_inode.c between commit 3d21652a1d23591e7f0bbbbedae29ce78c2c1113
> > ("fs/9p: Move dotl inode operations into a seperate file") from the v9fs
> > tree and various commits from the vfs-scale tree.
> > 
> > I fixed it up by using the v9fs changes to that file and then applying
> > the following merge fixup patch (which I can carry as necessary).
> > 
> > Someone will need to fix this up before one of these trees is merged by
> > Linus, or to send this merge fix to Linus.
> > 
> > From: Stephen Rothwell <sfr@canb.auug.org.au>
> > Date: Tue, 4 Jan 2011 12:33:54 +1100
> > Subject: [PATCH] v9fs: merge fix for changes in the vfs-scale tree
> > 
> > Signed-off-by: Stephen Rothwell <sfr@canb.auug.org.au>
> > ---
> >  fs/9p/vfs_inode_dotl.c |   22 +++++++++++-----------
> >  1 files changed, 11 insertions(+), 11 deletions(-)
> > 
> > diff --git a/fs/9p/vfs_inode_dotl.c b/fs/9p/vfs_inode_dotl.c
> > index 38d5880..9dd534b 100644
> > --- a/fs/9p/vfs_inode_dotl.c
> > +++ b/fs/9p/vfs_inode_dotl.c
> > @@ -78,11 +78,11 @@ static struct dentry *v9fs_dentry_from_dir_inode(struct inode *inode)
> >  {
> >  	struct dentry *dentry;
> > 
> > -	spin_lock(&dcache_lock);
> > +	spin_lock(&inode->i_lock);
> >  	/* Directory should have only one entry. */
> >  	BUG_ON(S_ISDIR(inode->i_mode) && !list_is_singular(&inode->i_dentry));
> >  	dentry = list_entry(inode->i_dentry.next, struct dentry, d_alias);
> > -	spin_unlock(&dcache_lock);
> > +	spin_unlock(&inode->i_lock);
> 
> Are we doing away with dcache_lock?

It's on its last legs...

 
> I am not sure if the i_lock can serve the same purpose..but looks like with the
> current code
> there may not need any lock around this code. Aneesh/Eric do you guys have any
> comments?

Well first of all, why do you say i_lock can't serve the same purpose?
Removing locks is well and good, but if i_lock doesn't work here, then
I've made a mistake either fudnamentally in the dcache, or with a
particular pattern that v9fs uses -- either way it has to be understood.

dcache lock removal of course isn't done ad-hoc. These two patches
specifically are the ones which aim to replace this particular instance
of locking:

http://git.kernel.org/?p=linux/kernel/git/npiggin/linux-npiggin.git;a=commit;h=5d30c20d47023b95b2a0d4820917dba8ba218d1a
http://git.kernel.org/?p=linux/kernel/git/npiggin/linux-npiggin.git;a=commit;h=ef4953a772e04aef8cf5b94a9b70ffbb12b576e2


> >  	return dentry;
> >  }
> > 
> > @@ -215,7 +215,7 @@ v9fs_vfs_create_dotl(struct inode *dir, struct dentry *dentry, int omode,
> >  				err);
> >  			goto error;
> >  		}
> > -		dentry->d_op = &v9fs_cached_dentry_operations;
> > +		d_set_d_op(dentry, &v9fs_cached_dentry_operations);
> 
> Assuming that this is a macro to the same operation.. rest of the changes look
> fine to me.

Yes it's equivalent.

Thanks,
Nick

