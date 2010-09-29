Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751928Ab0I2FfG (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Sep 2010 01:35:06 -0400
Received: from e23smtp06.au.ibm.com ([202.81.31.148]:37261 "EHLO
	e23smtp06.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750951Ab0I2FfE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Sep 2010 01:35:04 -0400
From: "Aneesh Kumar K. V" <aneesh.kumar@linux.vnet.ibm.com>
To: "J. Bruce Fields" <bfields@fieldses.org>
Cc: hch@infradead.org, viro@zeniv.linux.org.uk, adilger@sun.com,
        corbet@lwn.net, neilb@suse.de, npiggin@kernel.dk,
        hooanon05@yahoo.co.jp, miklos@szeredi.hu,
        linux-fsdevel@vger.kernel.org, sfrench@us.ibm.com,
        philippe.deniel@CEA.FR, linux-kernel@vger.kernel.org
Subject: Re: [PATCH -V20 01/12] exportfs: Return the minimum required handle size
In-Reply-To: <20100928195250.GA10548@fieldses.org>
References: <1285702610-32733-1-git-send-email-aneesh.kumar@linux.vnet.ibm.com> <1285702610-32733-2-git-send-email-aneesh.kumar@linux.vnet.ibm.com> <20100928195250.GA10548@fieldses.org>
User-Agent: Notmuch/0.3.1-58-g6607fd6 (http://notmuchmail.org) Emacs/24.0.50.1 (i686-pc-linux-gnu)
Date: Wed, 29 Sep 2010 11:04:52 +0530
Message-ID: <m3mxr1864j.fsf@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 28 Sep 2010 15:52:50 -0400, "J. Bruce Fields" <bfields@fieldses.org> wrote:
> On Wed, Sep 29, 2010 at 01:06:39AM +0530, Aneesh Kumar K.V wrote:
> > The exportfs encode handle function should return the minimum required
> > handle size. This helps user to find out the handle size by passing 0
> > handle size in the first step and then redoing to the call again with
> > the returned handle size value.
> 
> Just nits; seems OK otherwise:
> 
> > diff --git a/fs/ocfs2/export.c b/fs/ocfs2/export.c
> > index 19ad145..250a347 100644
> > --- a/fs/ocfs2/export.c
> > +++ b/fs/ocfs2/export.c
> > @@ -201,8 +201,14 @@ static int ocfs2_encode_fh(struct dentry *dentry, u32 *fh_in, int *max_len,
> >  		   dentry->d_name.len, dentry->d_name.name,
> >  		   fh, len, connectable);
> >  
> > -	if (len < 3 || (connectable && len < 6)) {
> > +	if (connectable && (len < 6)) {
> >  		mlog(ML_ERROR, "fh buffer is too small for encoding\n");
> 
> Should that really be a printk(KERN_ERR, ...) if this is an expected use
> of the interface?
> 
> > +		*max_len = 6;
> > +		type = 255;
> > +		goto bail;
> > +	} else if (len < 3) {
> > +		mlog(ML_ERROR, "fh buffer is too small for encoding\n");
> 
> Ditto.

I removed the mlog(..) call at both sites. Considering that one would
use the callpath to find out minimum required handle size, I guess we
don't want logging there.

> 
> > +		*max_len = 3;
> >  		type = 255;
> >  		goto bail;
> >  	}
> > diff --git a/include/linux/exportfs.h b/include/linux/exportfs.h
> > index a9cd507..acd0b2d 100644
> > --- a/include/linux/exportfs.h
> > +++ b/include/linux/exportfs.h
> > @@ -108,8 +108,10 @@ struct fid {
> >   *    set, the encode_fh() should store sufficient information so that a good
> >   *    attempt can be made to find not only the file but also it's place in the
> >   *    filesystem.   This typically means storing a reference to de->d_parent in
> > - *    the filehandle fragment.  encode_fh() should return the number of bytes
> > - *    stored or a negative error code such as %-ENOSPC
> > + *    the filehandle fragment.  encode_fh() should return the fileid_type on
> > + *    success and on error returns 255 (if the space needed to encode fh is
> > + *    greater than @max_len*4 bytes). On error @max_len contain the minimum
> 
> s/contain/contains/.

Fixed


> 
> > + *    size(in 4 byte unit) needed to encode the file handle.
> >   *
> >   * fh_to_dentry:
> >   *    @fh_to_dentry is given a &struct super_block (@sb) and a file handle
> 


-aneesh
