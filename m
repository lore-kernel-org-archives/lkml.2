Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754817Ab2LKWRT (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Dec 2012 17:17:19 -0500
Received: from mx3-phx2.redhat.com ([209.132.183.24]:39702 "EHLO
	mx3-phx2.redhat.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753634Ab2LKWRS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Dec 2012 17:17:18 -0500
Date: Tue, 11 Dec 2012 17:17:05 -0500 (EST)
From: Dave Anderson <anderson@redhat.com>
To: Vivek Goyal <vgoyal@redhat.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        Russell King <rmk+kernel@arm.linux.org.uk>, kexec@lists.infradead.org,
        linux-kernel@vger.kernel.org, linux-mm@kvack.org,
        Atsushi Kumagai <kumagai-atsushi@mxc.nes.nec.co.jp>,
        JoonSoo Kim <js1304@gmail.com>
Message-ID: <104724866.46130887.1355264225876.JavaMail.root@redhat.com>
In-Reply-To: <20121211214859.GG5580@redhat.com>
Subject: Re: [RFC PATCH 0/8] remove vm_struct list management
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.16.187.10]
X-Mailer: Zimbra 7.2.0_GA_2669 (ZimbraWebClient - FF3.0 (Linux)/7.2.0_GA_2669)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



----- Original Message -----
> On Mon, Dec 10, 2012 at 11:40:47PM +0900, JoonSoo Kim wrote:
> 
> [..]
> > > So without knowing details of both the data structures, I think if vmlist
> > > is going away, then user space tools should be able to traverse vmap_area_root
> > > rb tree. I am assuming it is sorted using ->addr field and we should be
> > > able to get vmalloc area start from there. It will just be a matter of
> > > exporting right fields to user space (instead of vmlist).
> > 
> > There is address sorted list of vmap_area, vmap_area_list.
> > So we can use it for traversing vmalloc areas if it is necessary.
> > But, as I mentioned before, kexec write *just* address of vmlist and
> > offset of vm_struct's address field.  It imply that they don't traverse vmlist,
> > because they didn't write vm_struct's next field which is needed for traversing.
> > Without vm_struct's next field, they have no method for traversing.
> > So, IMHO, assigning dummy vm_struct to vmlist which is implemented by [7/8] is
> > a safe way to maintain a compatibility of userspace tool. :)
> 
> Actually the design of "makedumpfile" and "crash" tool is that they know
> about kernel data structures and they adopt to changes. So for major
> changes they keep track of kernel version numbers and if access the
> data structures accordingly.
> 
> Currently we access first element of vmlist to determine start of vmalloc
> address. True we don't have to traverse the list.
> 
> But as you mentioned we should be able to get same information by
> traversing to left most element of vmap_area_list rb tree. So I think
> instead of trying to retain vmlist first element just for backward
> compatibility, I will rather prefer get rid of that code completely
> from kernel and let user space tool traverse rbtree. Just export
> minimum needed info for traversal in user space.

There's no need to traverse the rbtree.  There is a vmap_area_list
linked list of vmap_area structures that is also sorted by virtual
address.

All that makedumpfile would have to do is to access the first vmap_area
in the vmap_area_list -- as opposed to the way that it does now, which is
by accessing the first vm_struct in the to-be-obsoleted vmlist list.

So it seems silly to keep the dummy "vmlist" around.

Dave
