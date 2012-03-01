Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758091Ab2CAWKL (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Mar 2012 17:10:11 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:51039 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756707Ab2CAWKJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Mar 2012 17:10:09 -0500
Date: Thu, 1 Mar 2012 14:10:07 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
Cc: linux-mm@kvack.org, mgorman@suse.de, kamezawa.hiroyu@jp.fujitsu.com,
        dhillf@gmail.com, viro@zeniv.linux.org.uk, hughd@google.com,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH -V2] hugetlbfs: Drop taking inode i_mutex lock from
 hugetlbfs_read
Message-Id: <20120301141007.274ad458.akpm@linux-foundation.org>
In-Reply-To: <1330593530-2022-1-git-send-email-aneesh.kumar@linux.vnet.ibm.com>
References: <1330593530-2022-1-git-send-email-aneesh.kumar@linux.vnet.ibm.com>
X-Mailer: Sylpheed 3.0.2 (GTK+ 2.20.1; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu,  1 Mar 2012 14:48:50 +0530
"Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com> wrote:

> Taking i_mutex lock in hugetlbfs_read can result in deadlock with mmap
> as explained below
>  Thread A:
>   read() on hugetlbfs
>    hugetlbfs_read() called
>     i_mutex grabbed
>      hugetlbfs_read_actor() called
>       __copy_to_user() called
>        page fault is triggered
>  Thread B, sharing address space with A:
>   mmap() the same file
>    ->mmap_sem is grabbed on task_B->mm->mmap_sem
>     hugetlbfs_file_mmap() is called
>      attempt to grab ->i_mutex and block waiting for A to give it up
>  Thread A:
>   pagefault handled blocked on attempt to grab task_A->mm->mmap_sem,
>  which happens to be the same thing as task_B->mm->mmap_sem.  Block waiting
>  for B to give it up.
> 
> AFAIU i_mutex lock got added to  hugetlbfs_read as per
> http://lkml.indiana.edu/hypermail/linux/kernel/0707.2/3066.html
> to take care of the race between truncate and read. This patch fix
> this by looking at page->mapping under page_lock (find_lock_page())
> to ensure; the inode didn't get truncated in the range during a
> parallel read.
> 
> Ideally we can extend the patch to make sure we don't increase i_size
> in mmap. But that will break userspace, because application will now
> have to use truncate(2) to increase i_size in hugetlbfs.

Looks OK to me.

Given that the bug has been there for four years, I'm assuming that
we'll be OK merging this fix into 3.4.  Or we could merge it into 3.4
and tag it for backporting into earlier kernels - it depends on whether
people are hurting from it, which I don't know?


