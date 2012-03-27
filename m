Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756519Ab2C0WIc (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Mar 2012 18:08:32 -0400
Received: from cantor2.suse.de ([195.135.220.15]:41883 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755872Ab2C0WIb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Mar 2012 18:08:31 -0400
Date: Wed, 28 Mar 2012 00:08:19 +0200
From: Jan Kara <jack@suse.cz>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Jan Kara <jack@suse.cz>, LKML <linux-kernel@vger.kernel.org>,
        linux-fsdevel@vger.kernel.org, Al Viro <viro@ZenIV.linux.org.uk>,
        Christoph Hellwig <hch@infradead.org>, dchinner@redhat.com,
        sandeen@redhat.com, Kamal Mostafa <kamal@canonical.com>
Subject: Re: [PATCH 01/19] mm: Make default vm_ops provide ->page_mkwrite
 handler
Message-ID: <20120327220819.GK5020@quack.suse.cz>
References: <1330963277-26336-1-git-send-email-jack@suse.cz>
 <1330963277-26336-2-git-send-email-jack@suse.cz>
 <20120323154502.8072a755.akpm@linux-foundation.org>
 <20120327075527.GA5020@quack.suse.cz>
 <20120327143815.40456d38.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120327143815.40456d38.akpm@linux-foundation.org>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue 27-03-12 14:38:15, Andrew Morton wrote:
> On Tue, 27 Mar 2012 09:55:27 +0200
> Jan Kara <jack@suse.cz> wrote:
> > On Fri 23-03-12 15:45:02, Andrew Morton wrote:
> > > On Mon,  5 Mar 2012 17:00:59 +0100
> > > Jan Kara <jack@suse.cz> wrote:
> > > 
> > > > --- a/mm/filemap.c
> > > > +++ b/mm/filemap.c
> > > > @@ -1759,8 +1759,28 @@ page_not_uptodate:
> > > >  }
> > > >  EXPORT_SYMBOL(filemap_fault);
> > > >  
> > > > +int filemap_page_mkwrite(struct vm_area_struct *vma, struct vm_fault *vmf)
> > > > +{
> > > > +	struct page *page = vmf->page;
> > > > +	struct inode *inode = vma->vm_file->f_path.dentry->d_inode;
> > > > +	int ret = VM_FAULT_LOCKED;
> > > > +
> > > > +	file_update_time(vma->vm_file);
> > > > +	lock_page(page);
> > > > +	if ((page->mapping != inode->i_mapping) ||
> > > > +	    (page_offset(page) > i_size_read(inode))) {
> > > 
> > > Would benefit from a comment explaining how the page can come to be
> > > outside i_size, and why we fail in that case.
> 
> This?
> 
> > > I don't think i_mutex is held here, so this test is rather meaningless
> > > and racy anyway?
> >   i_size test is racy if that's what you mean by "this test". Just I did
> > the test this way because it's like this in other places and I figured
> > truncate_pagecache() can take relatively long time so the test has some
> > effect. But if you think it's not worth it, I can remove it.
> 
> It bugs me when we copy-n-paste code without remembering why we had it
> there in the first place :( iirc, mmapped pages outside i_size can and
> do happen in some race situations, and are benign.
  Yeah. Certainly there can be pages beyond i_size because we first set
file size and then go and remove pages beyond new i_size one by one when we
do truncate. We must be careful not to create any new pages beyond i_size
but that's what filemap_fault() takes care of. So I think i_size check in
->page_mkwrite() isn't strictly needed.

> But it's several
> years since I thought about it and all the details have evaporated and
> it would take a lot of work to reinstantiate it all.  argh.
> 
> Also, it's off-by-one, isn't it?  Should be page_offset(page) >= i_size?
  Yes, it is. I'll just remove it.

								Honza
-- 
Jan Kara <jack@suse.cz>
SUSE Labs, CR
