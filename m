Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753245Ab2BZXq5 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 26 Feb 2012 18:46:57 -0500
Received: from bureau60.ns.utoronto.ca ([128.100.132.147]:57853 "EHLO
	bureau60.ns.utoronto.ca" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752381Ab2BZXq4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 26 Feb 2012 18:46:56 -0500
Message-ID: <4F4AC465.3020602@utoronto.ca>
Date: Sun, 26 Feb 2012 18:46:45 -0500
From: Steven Truelove <steven.truelove@utoronto.ca>
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:10.0.2) Gecko/20120216 Thunderbird/10.0.2
MIME-Version: 1.0
To: "wli@holomorphy.com" <wli@holomorphy.com>
CC: linux-kernel@vger.kernel.org
Subject: Re: [PATCH] Round up huge page count to avoid allocating too little
 memory when 'size' argument is not a multiple of the huge page size.
References: <1330003707-31739-1-git-send-email-steven.truelove@utoronto.ca> <684810209.212445.1330291482985.JavaMail.vpopmail@webmail1.networksolutionsemail.com
In-Reply-To: <684810209.212445.1330291482985.JavaMail.vpopmail@webmail1.networksolutionsemail.com
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Well, PAGE_ALIGN(addr) is already defined as  ALIGN(addr, PAGE_SIZE), so 
ALIGN can be used with the huge page size easily enough.

In this case however, the code is calculating a number of pages, not an 
address, so I feel my patch is appropriate.

FYI, I ran into this issue while allocating huge pages as shared memory 
in userspace.  shmget would always succeed, but shmat would fail unless 
the requested size mapped closely to the huge page size.  shmget would 
round up to the nearest PAGE_SIZE, but when allocating huge pages this 
obviously isn't enough.

On systems with multiple huge page sizes, it isn't obvious what the huge 
page size will be for a shmget request.  It only becomes obvious in 
hugetlbfs, so that is where I made the change.

Regards,

Steven Truelove

On 26/02/2012 4:24 PM, wli@holomorphy.com wrote:
>
> It might be a good idea to introduce a hugepage analogue of 
> PAGE_ALIGN() for this purpose.
>
> I'll try to get a more normal email setup at some point.
>
> -- wli
>
>
> On February 23, 2012 at 8:28 AM Steven Truelove 
> <steven.truelove@utoronto.ca> wrote:
>
> > Signed-off-by: Steven Truelove <steven.truelove@utoronto.ca>
> > ---
> >  fs/hugetlbfs/inode.c |    8 +++++---
> >  1 files changed, 5 insertions(+), 3 deletions(-)
> >
> > diff --git a/fs/hugetlbfs/inode.c b/fs/hugetlbfs/inode.c
> > index 1e85a7a..fce2527 100644
> > --- a/fs/hugetlbfs/inode.c
> > +++ b/fs/hugetlbfs/inode.c
> > @@ -938,6 +938,8 @@ struct file *hugetlb_file_setup(const char 
> *name, size_t size,
> >          struct path path;
> >          struct dentry *root;
> >          struct qstr quick_string;
> > +        struct hstate *hstate;
> > +        int num_pages;
> >
> >          *user = NULL;
> >          if (!hugetlbfs_vfsmount)
> > @@ -967,10 +969,10 @@ struct file *hugetlb_file_setup(const char 
> *name, size_t size,
> >          if (!inode)
> >                  goto out_dentry;
> >
> > +        hstate = hstate_inode(inode);
> > +        num_pages = (size + huge_page_size(hstate) - 1) >> 
> huge_page_shift(hstate);
> >          error = -ENOMEM;
> > -        if (hugetlb_reserve_pages(inode, 0,
> > -                        size >> 
> huge_page_shift(hstate_inode(inode)), NULL,
> > -                        acctflag))
> > +        if (hugetlb_reserve_pages(inode, 0, num_pages, NULL, 
> acctflag))
> >                  goto out_inode;
> >
> >          d_instantiate(path.dentry, inode);
> > --
> > 1.7.3.4
> >
