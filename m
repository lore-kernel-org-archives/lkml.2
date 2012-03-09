Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751142Ab2CIFDl (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Mar 2012 00:03:41 -0500
Received: from e23smtp02.au.ibm.com ([202.81.31.144]:36422 "EHLO
	e23smtp02.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750760Ab2CIFDk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Mar 2012 00:03:40 -0500
From: "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
To: Andrew Morton <akpm@linux-foundation.org>,
        Tyler Hicks <tyhicks@canonical.com>
Cc: linux-mm@kvack.org, davej@redhat.com, jboyer@redhat.com,
        linux-kernel@vger.kernel.org, Al Viro <viro@zeniv.linux.org.uk>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Mimi Zohar <zohar@linux.vnet.ibm.com>,
        David Gibson <david@gibson.dropbear.id.au>
Subject: Re: [PATCH] hugetlbfs: lockdep annotate root inode properly
In-Reply-To: <20120308134050.f53a0b2f.akpm@linux-foundation.org>
References: <1331198116-13670-1-git-send-email-aneesh.kumar@linux.vnet.ibm.com> <20120308130256.c7855cbd.akpm@linux-foundation.org> <20120308211926.GB6546@boyd> <20120308134050.f53a0b2f.akpm@linux-foundation.org>
User-Agent: Notmuch/0.11.1+190~g31a336a (http://notmuchmail.org) Emacs/23.3.1 (x86_64-pc-linux-gnu)
Date: Fri, 09 Mar 2012 10:33:24 +0530
Message-ID: <87vcme8ixv.fsf@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
x-cbid: 12030818-5490-0000-0000-000000E9691E
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 8 Mar 2012 13:40:50 -0800, Andrew Morton <akpm@linux-foundation.org> wrote:
> On Thu, 8 Mar 2012 15:19:27 -0600
> Tyler Hicks <tyhicks@canonical.com> wrote:
> 
> > > 
> > > 
> > > Sigh.  Was lockdep_annotate_inode_mutex_key() sufficiently
> > > self-explanatory to justify leaving it undocumented?
> > > 
> > > <goes off and reads e096d0c7e2e>
> > > 
> > > OK, the patch looks correct given the explanation in e096d0c7e2e, but
> > > I'd like to understand why it becomes necessary only now.
> > > 
> > > > NOTE: This patch also require 
> > > > http://thread.gmane.org/gmane.linux.file-systems/58795/focus=59565
> > > > to remove the lockdep warning
> > > 
> > > And that patch has been basically ignored.
> > 
> > Al commented on it here:
> > 
> > https://lkml.org/lkml/2012/2/16/518
> > 
> > He said that while my patch is correct, taking i_mutex inside mmap_sem
> > is still wrong.
> 
> OK, thanks, yup.  Taking i_mutex in file_operations.mmap() is wrong.
> 
> Is hugetlbfs actually deadlockable because of this, or is it the case
> that the i_mutex->mmap_sem ordering happens to never happen for this
> filesystem?  Although we shouldn't go and create incompatible lock
> ranking rules for different filesystems!
> 
> So we need to pull the i_mutex out of hugetlbfs_file_mmap().  What's it
> actually trying to do in there?  If we switch to
> i_size_read()/i_size_write() then AFAICT the problem comes down to
> hugetlb_reserve_pages().
> 
> hugetlb_reserve_pages() fiddles with i_mapping->private_list and the fs
> owns private_list and is free to use a lock other than i_mutex to
> protect it.  (In fact i_mapping.private_lock is the usual lock for
> private_list).
> 
> 
> 
> So from a quick scan here I'm thinking that a decent fix is to remove
> the i_mutex locking from hugetlbfs_file_mmap(), switch
> hugetlbfs_file_mmap() to i_size_read/write then use a hugetlb-private
> lock to protect i_mapping->private_list.  region_chg() will do
> GFP_KERNEL allocations under that lock, so some care is needed.
> 

But as per 7762f5a0b709b415fda132258ad37b9f2a1db994 i_size_write should
always happen with i_mutex held 

-aneesh

