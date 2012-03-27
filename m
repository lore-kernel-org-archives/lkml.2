Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757125Ab2C0WvD (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Mar 2012 18:51:03 -0400
Received: from ipmail06.adl6.internode.on.net ([150.101.137.145]:4293 "EHLO
	ipmail06.adl6.internode.on.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756491Ab2C0WvA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Mar 2012 18:51:00 -0400
X-Greylist: delayed 303 seconds by postgrey-1.27 at vger.kernel.org; Tue, 27 Mar 2012 18:51:00 EDT
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: Av0EAAtCck95LEyG/2dsb2JhbABDuG2BCIIJAQEFJxMcIxAIAw4KLhQlAyETiAm2HROQfASVYIlQhl6Cew
Date: Wed, 28 Mar 2012 09:45:53 +1100
From: Dave Chinner <david@fromorbit.com>
To: Jan Kara <jack@suse.cz>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        LKML <linux-kernel@vger.kernel.org>, linux-fsdevel@vger.kernel.org,
        Al Viro <viro@ZenIV.linux.org.uk>,
        Christoph Hellwig <hch@infradead.org>, dchinner@redhat.com,
        sandeen@redhat.com, Kamal Mostafa <kamal@canonical.com>
Subject: Re: [PATCH 01/19] mm: Make default vm_ops provide ->page_mkwrite
 handler
Message-ID: <20120327224553.GG5091@dastard>
References: <1330963277-26336-1-git-send-email-jack@suse.cz>
 <1330963277-26336-2-git-send-email-jack@suse.cz>
 <20120323154502.8072a755.akpm@linux-foundation.org>
 <20120327075527.GA5020@quack.suse.cz>
 <20120327143815.40456d38.akpm@linux-foundation.org>
 <20120327220819.GK5020@quack.suse.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120327220819.GK5020@quack.suse.cz>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Mar 28, 2012 at 12:08:19AM +0200, Jan Kara wrote:
> On Tue 27-03-12 14:38:15, Andrew Morton wrote:
> > On Tue, 27 Mar 2012 09:55:27 +0200
> > Jan Kara <jack@suse.cz> wrote:
> > > On Fri 23-03-12 15:45:02, Andrew Morton wrote:
> > > > On Mon,  5 Mar 2012 17:00:59 +0100
> > > > Jan Kara <jack@suse.cz> wrote:
> > > > 
> > > > > --- a/mm/filemap.c
> > > > > +++ b/mm/filemap.c
> > > > > @@ -1759,8 +1759,28 @@ page_not_uptodate:
> > > > >  }
> > > > >  EXPORT_SYMBOL(filemap_fault);
> > > > >  
> > > > > +int filemap_page_mkwrite(struct vm_area_struct *vma, struct vm_fault *vmf)
> > > > > +{
> > > > > +	struct page *page = vmf->page;
> > > > > +	struct inode *inode = vma->vm_file->f_path.dentry->d_inode;
> > > > > +	int ret = VM_FAULT_LOCKED;
> > > > > +
> > > > > +	file_update_time(vma->vm_file);
> > > > > +	lock_page(page);
> > > > > +	if ((page->mapping != inode->i_mapping) ||
> > > > > +	    (page_offset(page) > i_size_read(inode))) {
> > > > 
> > > > Would benefit from a comment explaining how the page can come to be
> > > > outside i_size, and why we fail in that case.
> > 
> > This?
> > 
> > > > I don't think i_mutex is held here, so this test is rather meaningless
> > > > and racy anyway?
> > >   i_size test is racy if that's what you mean by "this test". Just I did
> > > the test this way because it's like this in other places and I figured
> > > truncate_pagecache() can take relatively long time so the test has some
> > > effect. But if you think it's not worth it, I can remove it.
> > 
> > It bugs me when we copy-n-paste code without remembering why we had it
> > there in the first place :( iirc, mmapped pages outside i_size can and
> > do happen in some race situations, and are benign.
>   Yeah. Certainly there can be pages beyond i_size because we first set
> file size and then go and remove pages beyond new i_size one by one when we
> do truncate. We must be careful not to create any new pages beyond i_size
> but that's what filemap_fault() takes care of. So I think i_size check in
> ->page_mkwrite() isn't strictly needed.

Actually, I think it is. In __do_fault(), we drop the page lock
between the .fault call and the .page_mkwrite() call, so the size
checks in .fault for the given page being faulted are no longer
valid as truncate serialises only on the page lock. Hence we have to
repeat the truncate race checks again in .page_mkwrite() after we
relock the page.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
