Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932517Ab1KCHtV (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Nov 2011 03:49:21 -0400
Received: from 173-166-109-252-newengland.hfc.comcastbusiness.net ([173.166.109.252]:55735
	"EHLO bombadil.infradead.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932075Ab1KCHtU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Nov 2011 03:49:20 -0400
Date: Thu, 3 Nov 2011 03:48:55 -0400
From: Christoph Hellwig <hch@infradead.org>
To: "J. R. Okajima" <hooanon05@yahoo.co.jp>
Cc: linux-kernel@vger.kernel.org, viro@zeniv.linux.org.uk, hch@infradead.org,
        jwboyer@gmail.com, wli@holomorphy.com
Subject: Re: [RFC 0/2] locking order of mm->mmap_sem and various FS
Message-ID: <20111103074855.GA6993@infradead.org>
References: <1320296035-8744-1-git-send-email-hooanon05@yahoo.co.jp>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1320296035-8744-1-git-send-email-hooanon05@yahoo.co.jp>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Nov 03, 2011 at 01:53:53PM +0900, J. R. Okajima wrote:
> There had ever been several posts which report a circular locking
> problem around mm->mmap_sem and FS. For instance
> "INFO: possible circular locking dependency detected 3.1.0-rc2-00190-g3210d19"
> <http://marc.info/?l=linux-kernel&m=131402669412658&w=2>
> 
> While the problem in ext4 evict_inode seems to be already solved, here
> I'll try fixing hugetlbfs as first step. The problem in hugetlbfs is
> 
> - read(2) -- hugetlbfs_read() -- ... --  __copy_to_user()
>   hugetlbfs_read() holds i_mutex. So this is i_mutex before mmap_sem
>   correctly.
> 
> - mmap(2) -- hugetlbfs_file_mmap()
>   hugetlbfs_file_mmap() holds i_mutex too. But mmap_sem is already held
>   before hugetlbfs_file_mmap(). This is an AB-BA problem.

And that is where the problem is.  ->mmap should not take i_mutex.

While a few filesystems abuse i_mutex it only has two clear defined
meanings:

 - protect the namespace topology (only on directories)
 - protect writes against each other and truncate.

The hugetlb use falls under neither category and should be switched
to an internal lock.  It seems like that look should in fact be taken
inside hugetlb_reserve_pages, as that is the only thing that appears
to need any protection.

> While I am not sure whether hugetlbfs_read() really needs to acquire
> i_mutex, if it really does, then I'd suggest f_op->{pre,post}_mmap().
> These two patches are just to show the approach and not intends to be
> merged into mainline now. I don't think it is the best solution, but I
> simply have no idea other than this.
> I'd like to hear comments from LKML people.
> 
> Taking a glance at ->mmap() functions in several FSs. I also found
> gfs2_mmap()/gfs2_readdir() which acquires gl->gl_spin and may cause a
> similar problem. And ocfs2_mmap()/ocfs2_readdir() too, but I don't
> understand it enough.

You can't mmap directories, so that is not a problem.

