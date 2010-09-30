Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753819Ab0I3F0R (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Sep 2010 01:26:17 -0400
Received: from e28smtp05.in.ibm.com ([122.248.162.5]:49789 "EHLO
	e28smtp05.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753481Ab0I3F0Q (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Sep 2010 01:26:16 -0400
From: "Aneesh Kumar K. V" <aneesh.kumar@linux.vnet.ibm.com>
To: Sage Weil <sage@newdream.net>
Cc: "J. Bruce Fields" <bfields@fieldses.org>, hch@infradead.org,
        viro@zeniv.linux.org.uk, adilger@sun.com, corbet@lwn.net,
        neilb@suse.de, npiggin@kernel.dk, hooanon05@yahoo.co.jp,
        miklos@szeredi.hu, linux-fsdevel@vger.kernel.org, sfrench@us.ibm.com,
        philippe.deniel@CEA.FR, linux-kernel@vger.kernel.org
Subject: Re: [PATCH -V20 02/12] vfs: Add name to file handle conversion support
In-Reply-To: <Pine.LNX.4.64.1009291022350.16498@cobra.newdream.net>
References: <1285702610-32733-1-git-send-email-aneesh.kumar@linux.vnet.ibm.com> <1285702610-32733-3-git-send-email-aneesh.kumar@linux.vnet.ibm.com> <20100928203045.GC10548@fieldses.org> <m3k4m57ync.fsf@linux.vnet.ibm.com> <Pine.LNX.4.64.1009291022350.16498@cobra.newdream.net>
User-Agent: Notmuch/0.3.1-58-g6607fd6 (http://notmuchmail.org) Emacs/24.0.50.1 (i686-pc-linux-gnu)
Date: Thu, 30 Sep 2010 10:56:00 +0530
Message-ID: <m3k4m3redz.fsf@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 29 Sep 2010 10:26:32 -0700 (PDT), Sage Weil <sage@newdream.net> wrote:
> Hi Aneesh,
> 
> On Wed, 29 Sep 2010, Aneesh Kumar K. V wrote:
> 
> > On Tue, 28 Sep 2010 16:30:45 -0400, "J. Bruce Fields" <bfields@fieldses.org> wrote:
> > > By the way, apologies, I can't remember from last time: did you decide
> > > that overflow was really the only case when 255 would be returned from
> > > exportfs_encode_fs()?
> > > 
> > 
> > All in kernel file system other than cepth return 255 on overflow.
> > ceph return -ENOSPC when there is an EOVERFLOW case. (I also
> > need to fix Ceph to return minimum handle size). I guess ceph usage was
> > correct as per the existing documentation. But the current documentation
> > is wrong and all the file system was returning 255 instead of ENOSPC
> > 
> > We look at the returned handle size of exportfs_encode_fh and determine
> > the overflow case in open by handle code. May be i should fix that to
> > include both 255 and ENOSPC ?
> > 
> > 	if ((handle->handle_bytes > f_handle.handle_bytes) ||
> > 	    (retval == 255) || (retval == -ENOSPC)) {
> > 		/* As per old exportfs_encode_fh documentation
> > 		 * we could return ENOSPC to indicate overflow
> > 		 * But file system returned 255 always. So handle
> > 		 * both the values
> > 		 */
> > 		/*
> > 		 * set the handle_size to zero so we copy only
> > 		 * non variable part of the file_handle
> > 		 */
> > 		handle->handle_bytes = 0;
> > 		retval = -EOVERFLOW;
> >       }
> > 
> > Attached ceph change below
> 
> This looks good to me.  If ceph is the only one returning ENOSPC we may as 
> well fix it there (and in the documentation) and avoid adding an 
> additional return code check.  Unless you're worried about out of tree 
> file systems?
> 
> In any case, I'll add the below patch to the ceph tree.  
> 
> Thanks!
> sage
> 
> 
> 
> 
> > 
> > diff --git a/fs/ceph/export.c b/fs/ceph/export.c
> > index 4480cb1..e38423e 100644
> > --- a/fs/ceph/export.c
> > +++ b/fs/ceph/export.c
> > @@ -42,32 +42,37 @@ struct ceph_nfs_confh {
> >  static int ceph_encode_fh(struct dentry *dentry, u32 *rawfh, int *max_len,
> >  			  int connectable)
> >  {
> > +	int type;
> >  	struct ceph_nfs_fh *fh = (void *)rawfh;
> >  	struct ceph_nfs_confh *cfh = (void *)rawfh;
> >  	struct dentry *parent = dentry->d_parent;
> >  	struct inode *inode = dentry->d_inode;
> > -	int type;
> > +	int connected_handle_length = sizeof(*cfh)/4;
> > +	int handle_length = sizeof(*fh)/4;
> >  
> >  	/* don't re-export snaps */
> >  	if (ceph_snap(inode) != CEPH_NOSNAP)
> >  		return -EINVAL;
> >  
> > -	if (*max_len >= sizeof(*cfh)) {
> > +	if (*max_len >= connected_handle_length) {
> >  		dout("encode_fh %p connectable\n", dentry);
> >  		cfh->ino = ceph_ino(dentry->d_inode);
> >  		cfh->parent_ino = ceph_ino(parent->d_inode);
> >  		cfh->parent_name_hash = parent->d_name.hash;
> > -		*max_len = sizeof(*cfh);
> > +		*max_len = connected_handle_length;
> >  		type = 2;
> > -	} else if (*max_len > sizeof(*fh)) {
> > -		if (connectable)
> > -			return -ENOSPC;
> > +	} else if (*max_len >= handle_length) {
> > +		if (connectable) {
> > +			*max_len = connected_handle_length;
> > +			return 255;
> > +		}
> >  		dout("encode_fh %p\n", dentry);
> >  		fh->ino = ceph_ino(dentry->d_inode);
> > -		*max_len = sizeof(*fh);
> > +		*max_len = handle_length;
> >  		type = 1;
> >  	} else {
> > -		return -ENOSPC;
> > +		*max_len = handle_length;
> > +		return 255;
> >  	}
> >  	return type;
> >  }
> > 

Part of the patch that update *max_len on error is added by the
open by handle patch series for other file system. If I split that
part from the patch above it will create merge conflict later. So i am not
sure how to handle that. But if you are ok with everything in a single
patch you can add 

Signed-off-by: Aneesh Kumar K.V <aneesh.kumar@linux.vnet.ibm.com>

-aneesh
