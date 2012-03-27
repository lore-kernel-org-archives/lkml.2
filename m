Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756381Ab2C0ViT (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Mar 2012 17:38:19 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:46106 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755954Ab2C0ViQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Mar 2012 17:38:16 -0400
Date: Tue, 27 Mar 2012 14:38:15 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Jan Kara <jack@suse.cz>
Cc: LKML <linux-kernel@vger.kernel.org>, linux-fsdevel@vger.kernel.org,
        Al Viro <viro@ZenIV.linux.org.uk>,
        Christoph Hellwig <hch@infradead.org>, dchinner@redhat.com,
        sandeen@redhat.com, Kamal Mostafa <kamal@canonical.com>
Subject: Re: [PATCH 01/19] mm: Make default vm_ops provide ->page_mkwrite
 handler
Message-Id: <20120327143815.40456d38.akpm@linux-foundation.org>
In-Reply-To: <20120327075527.GA5020@quack.suse.cz>
References: <1330963277-26336-1-git-send-email-jack@suse.cz>
	<1330963277-26336-2-git-send-email-jack@suse.cz>
	<20120323154502.8072a755.akpm@linux-foundation.org>
	<20120327075527.GA5020@quack.suse.cz>
X-Mailer: Sylpheed 3.0.2 (GTK+ 2.20.1; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 27 Mar 2012 09:55:27 +0200
Jan Kara <jack@suse.cz> wrote:

> On Fri 23-03-12 15:45:02, Andrew Morton wrote:
> > On Mon,  5 Mar 2012 17:00:59 +0100
> > Jan Kara <jack@suse.cz> wrote:
> > 
> > > --- a/mm/filemap.c
> > > +++ b/mm/filemap.c
> > > @@ -1759,8 +1759,28 @@ page_not_uptodate:
> > >  }
> > >  EXPORT_SYMBOL(filemap_fault);
> > >  
> > > +int filemap_page_mkwrite(struct vm_area_struct *vma, struct vm_fault *vmf)
> > > +{
> > > +	struct page *page = vmf->page;
> > > +	struct inode *inode = vma->vm_file->f_path.dentry->d_inode;
> > > +	int ret = VM_FAULT_LOCKED;
> > > +
> > > +	file_update_time(vma->vm_file);
> > > +	lock_page(page);
> > > +	if ((page->mapping != inode->i_mapping) ||
> > > +	    (page_offset(page) > i_size_read(inode))) {
> > 
> > Would benefit from a comment explaining how the page can come to be
> > outside i_size, and why we fail in that case.

This?

> > I don't think i_mutex is held here, so this test is rather meaningless
> > and racy anyway?
>   i_size test is racy if that's what you mean by "this test". Just I did
> the test this way because it's like this in other places and I figured
> truncate_pagecache() can take relatively long time so the test has some
> effect. But if you think it's not worth it, I can remove it.

It bugs me when we copy-n-paste code without remembering why we had it
there in the first place :( iirc, mmapped pages outside i_size can and
do happen in some race situations, and are benign.  But it's several
years since I thought about it and all the details have evaporated and
it would take a lot of work to reinstantiate it all.  argh.

Also, it's off-by-one, isn't it?  Should be page_offset(page) >= i_size?
