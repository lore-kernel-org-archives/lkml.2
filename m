Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932145Ab0EVVpS (ORCPT <rfc822;w@1wt.eu>);
	Sat, 22 May 2010 17:45:18 -0400
Received: from cantor2.suse.de ([195.135.220.15]:54154 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758808Ab0EVVpQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 22 May 2010 17:45:16 -0400
Date: Sun, 23 May 2010 07:44:53 +1000
From: Neil Brown <neilb@suse.de>
To: "Aneesh Kumar K. V" <aneesh.kumar@linux.vnet.ibm.com>
Cc: "J. Bruce Fields" <bfields@fieldses.org>, hch@infradead.org,
       viro@zeniv.linux.org.uk, adilger@sun.com, corbet@lwn.net,
       serue@us.ibm.com, hooanon05@yahoo.co.jp, linux-fsdevel@vger.kernel.org,
       sfrench@us.ibm.com, philippe.deniel@CEA.FR,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH -V11 1/9] exportfs: Return the minimum required handle
 size
Message-ID: <20100523074453.773532b9@notabene.brown>
In-Reply-To: <87y6fc2byh.fsf@linux.vnet.ibm.com>
References: <1274340938-29628-1-git-send-email-aneesh.kumar@linux.vnet.ibm.com>
	<1274340938-29628-2-git-send-email-aneesh.kumar@linux.vnet.ibm.com>
	<20100521221516.GD13227@fieldses.org>
	<87y6fc2byh.fsf@linux.vnet.ibm.com>
X-Mailer: Claws Mail 3.7.6 (GTK+ 2.20.1; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 22 May 2010 20:57:50 +0530
"Aneesh Kumar K. V" <aneesh.kumar@linux.vnet.ibm.com> wrote:

> On Fri, 21 May 2010 18:15:16 -0400, "J. Bruce Fields" <bfields@fieldses.org> wrote:
> > On Thu, May 20, 2010 at 01:05:30PM +0530, Aneesh Kumar K.V wrote:
> > > The exportfs encode handle function should return the minimum required
> > > handle size. This helps user to find out the handle size by passing 0
> > > handle size in the first step and then redoing to the call again with
> > > the returned handle size value.
> > 
> > The encode_fh() interface is a little confusing.  (Not your fault,
> > really, mainly it's the return value (and the special use of 255) that I
> > always find odd.)
> > 
> > But maybe it would help to have a little more documention in the
> > export_encode_fh() kerneldoc comment and/or in
> > Documentation/filesystems/nfs/Exporting?
> > 
> 
> Kernel documentation says 
> 
>  * encode_fh:
>  *    @encode_fh should store in the file handle fragment @fh (using at most
>  *    @max_len bytes) information that can be used by @decode_fh to recover the
>  *    file refered to by the &struct dentry @de.  If the @connectable flag is
>  *    set, the encode_fh() should store sufficient information so that a good
>  *    attempt can be made to find not only the file but also it's place in the
>  *    filesystem.   This typically means storing a reference to de->d_parent in
>  *    the filehandle fragment.  encode_fh() should return the number of bytes
>  *    stored or a negative error code such as %-ENOSPC
>  *
> 
> Clearly the file system encode_fh is not returning the correct return
> values. Should i fix the kernel to follow the documentation or should
> the kernel documentation should be fixed. I would prefer code, because
> the documentation look more easy/clear to follow that returning value 255.
>

The documentation is wrong in that it never returns the number of bytes.
The number of bytes is stored back in the 'max_len' by-reference argument.
The return value is a 'type' which is stored in the 4th byte of the
filehandle.

Error return is by a magic type number (255) simply because it is easier if
this is stored temporarily in fb_fileid_type which is __u8.  However it
doesn't need to be stored there.
code like
		_fh_update(fhp, fhp->fh_export, dentry);
		if (fhp->fh_handle.fh_fileid_type == 255)
			return nfserr_opnotsupp;

could be changed to
		err = _fh_update(fhp, fhp->fh_export, dentry);
		if (err < 0)
			return nfserr_opnotsupp;


and _fh_update could be changed from
		fhp->fh_handle.fh_fileid_type =
			exportfs_encode_fh(dentry, fid, &maxsize, subtreecheck);
to
		type = exportfs_encode_fh(dentry, fid, &maxsize, subtreecheck);
		if (type == 255) type = -ENOSPC; /* temp until filesystems changed*/
		if (type > 0)
			fhp-.fh_filehandle.fh_fileid_type = type;
		...
		return type;


And the documentation should be changed to report how the size is returned
and that the return value is a type, or an error.

NeilBrown
