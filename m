Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752650Ab1HLWUJ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Aug 2011 18:20:09 -0400
Received: from verein.lst.de ([213.95.11.211]:37239 "EHLO newverein.lst.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752167Ab1HLWUF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Aug 2011 18:20:05 -0400
Date: Sat, 13 Aug 2011 00:20:03 +0200
From: Christoph Hellwig <hch@lst.de>
To: Linus Torvalds <torvalds@osdl.org>, Avi Kivity <avi@redhat.com>,
        Marcelo Tosatti <mtosatti@redhat.com>, Jan Kiszka <jan.kiszka@web.de>,
        qemu-devel@nongnu.org, agraf@suse.de, kvm <kvm@vger.kernel.org>,
        Paul Mackerras <paulus@samba.org>, linux-kernel@vger.kernel.org
Subject: Re: [Qemu-devel] Fix refcounting in hugetlbfs quota handling
Message-ID: <20110812222003.GA8300@lst.de>
References: <20110811064059.GU6342@yookeroo.fritz.box>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110811064059.GU6342@yookeroo.fritz.box>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Aug 11, 2011 at 04:40:59PM +1000, David Gibson wrote:
> Linus, please apply
> 
> hugetlbfs tracks the current usage of hugepages per hugetlbfs
> mountpoint.  To correctly track this when hugepages are released, it
> must find the right hugetlbfs super_block from the struct page
> available in free_huge_page().

a superblock is not a mountpoint, it's a filesystem instance.  You can happily
have a single filesystem mounted at multiple mount points.

> However, this usage is buggy, because nothing ensures that the
> address_space is not freed before all the hugepages that belonged to
> it are.  In practice that will usually be the case, but if extra page
> references have been taken by e.g. drivers or kvm doing
> get_user_pages() then the file, inode and address space may be
> destroyed before all the pages.
> 
> In addition, the quota functions use the mapping only to get the inode
> then the super_block.  However, most of the callers already have the
> inode anyway and have to get the mapping from there.
> 
> This patch, therefore, stores a pointer to the inode instead of the
> address_space in the page private data for hugepages.

What's sthe point?  The lifetime of inode->i_mapping is exactly the
same as that of the inode, except for those few filesystem that use
one from a different inode (and then for the whole lifetime of the
inode), so I can't see how your patch will make a difference.

> More
> importantly it correctly adjusts the reference count on the inodes
> when they're added to the page private data.  This ensures that the
> inode (and therefore the super block) will not be freed before we use
> it from free_huge_page.

That seems like the real fix.  And even if you'd still do the other bits
it should be a separate patch/

