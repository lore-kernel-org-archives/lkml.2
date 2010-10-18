Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932734Ab0JRXoF (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Oct 2010 19:44:05 -0400
Received: from gate.crashing.org ([63.228.1.57]:44164 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754707Ab0JRXoE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Oct 2010 19:44:04 -0400
Subject: Re: Odd NFS related SIGBUS (& possible fix)
From: Benjamin Herrenschmidt <benh@kernel.crashing.org>
To: Trond Myklebust <Trond.Myklebust@netapp.com>
Cc: Nick Piggin <npiggin@kernel.dk>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Al Viro <viro@ZenIV.linux.org.uk>, linux-fsdevel@vger.kernel.org
In-Reply-To: <1285966635.2463.149.camel@pasglop>
References: <1285734825.14081.87.camel@pasglop>
	 <1285956768.30373.39.camel@heimdal.trondhjem.org>
	 <1285958104.30373.41.camel@heimdal.trondhjem.org>
	 <1285966635.2463.149.camel@pasglop>
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 19 Oct 2010 10:43:25 +1100
Message-ID: <1287445405.2341.43.camel@pasglop>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 2010-10-02 at 06:57 +1000, Benjamin Herrenschmidt wrote:
> On Fri, 2010-10-01 at 14:35 -0400, Trond Myklebust wrote:
> > On Fri, 2010-10-01 at 14:12 -0400, Trond Myklebust wrote:
> > > However, it looks to me as if the right thing to do when the
> > > page->mapping has changed would be to do the same thing as
> > > block_page_mkwrite(), and just return VM_FAULT_NOPAGE so that the VM can
> > > retry the fault.
> > > IMO: We should only SIGBUS if the calls to nfs_flush_incompatible()
> > > and/or nfs_updatepage() fail.
> > > 
> > > Cheers
> > >   Trond
> > 
> > IOW: Something like the following patch.
> 
> Thanks, I'll try it but it will have to wait about 10 days as I'm off on
> vacation.
> 
> I'll see if somebody here can do some tests while I'm away

BTW. I got some reports from testers that the patch fixes the issue.

Thanks !

Cheers,
Ben.

> Cheers,
> Ben.
> 
> > Cheers
> >   Trond
> > 
> > ---------------------------------------------------------------------------
> > NFS: Don't SIGBUS if nfs_vm_page_mkwrite races with a cache invalidation
> > 
> > From: Trond Myklebust <Trond.Myklebust@netapp.com>
> > 
> > In the case where we lock the page, and then find out that the page has
> > been thrown out of the page cache, we should just return VM_FAULT_NOPAGE.
> > This is what block_page_mkwrite() does in these situations.
> > 
> > Signed-off-by: Trond Myklebust <Trond.Myklebust@netapp.com>
> > ---
> > 
> >  fs/nfs/file.c |   17 ++++++++---------
> >  1 files changed, 8 insertions(+), 9 deletions(-)
> > 
> > 
> > diff --git a/fs/nfs/file.c b/fs/nfs/file.c
> > index 05bf3c0..6d95e24 100644
> > --- a/fs/nfs/file.c
> > +++ b/fs/nfs/file.c
> > @@ -551,7 +551,7 @@ static int nfs_vm_page_mkwrite(struct vm_area_struct *vma, struct vm_fault *vmf)
> >  	struct file *filp = vma->vm_file;
> >  	struct dentry *dentry = filp->f_path.dentry;
> >  	unsigned pagelen;
> > -	int ret = -EINVAL;
> > +	int ret = VM_FAULT_NOPAGE;
> >  	struct address_space *mapping;
> >  
> >  	dfprintk(PAGECACHE, "NFS: vm_page_mkwrite(%s/%s(%ld), offset %lld)\n",
> > @@ -567,21 +567,20 @@ static int nfs_vm_page_mkwrite(struct vm_area_struct *vma, struct vm_fault *vmf)
> >  	if (mapping != dentry->d_inode->i_mapping)
> >  		goto out_unlock;
> >  
> > -	ret = 0;
> >  	pagelen = nfs_page_length(page);
> >  	if (pagelen == 0)
> >  		goto out_unlock;
> >  
> > -	ret = nfs_flush_incompatible(filp, page);
> > -	if (ret != 0)
> > -		goto out_unlock;
> > +	ret = VM_FAULT_LOCKED;
> > +	if (nfs_flush_incompatible(filp, page) == 0 &&
> > +	    nfs_updatepage(filp, page, 0, pagelen) == 0)
> > +		goto out;
> >  
> > -	ret = nfs_updatepage(filp, page, 0, pagelen);
> > +	ret = VM_FAULT_SIGBUS;
> >  out_unlock:
> > -	if (!ret)
> > -		return VM_FAULT_LOCKED;
> >  	unlock_page(page);
> > -	return VM_FAULT_SIGBUS;
> > +out:
> > +	return ret;
> >  }
> >  
> >  static const struct vm_operations_struct nfs_file_vm_ops = {
> > 
> > --
> > To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> > the body of a message to majordomo@vger.kernel.org
> > More majordomo info at  http://vger.kernel.org/majordomo-info.html
> > Please read the FAQ at  http://www.tux.org/lkml/
> 
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/


