Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757359Ab2CHViB (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Mar 2012 16:38:01 -0500
Received: from mail-iy0-f174.google.com ([209.85.210.174]:33331 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756298Ab2CHVh7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Mar 2012 16:37:59 -0500
Date: Thu, 8 Mar 2012 13:37:57 -0800 (PST)
From: David Rientjes <rientjes@google.com>
X-X-Sender: rientjes@chino.kir.corp.google.com
To: Andrew Morton <akpm@linux-foundation.org>
cc: Dave Jones <davej@redhat.com>, linux-kernel@vger.kernel.org,
        linux-mm@kvack.org
Subject: Re: [patch] mm, hugetlb: add thread name and pid to SHM_HUGETLB
 mlock rlimit warning
In-Reply-To: <20120308120238.c4486547.akpm@linux-foundation.org>
Message-ID: <alpine.DEB.2.00.1203081333300.23632@chino.kir.corp.google.com>
References: <alpine.DEB.2.00.1203061825070.9015@chino.kir.corp.google.com> <20120308120238.c4486547.akpm@linux-foundation.org>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 8 Mar 2012, Andrew Morton wrote:

> > --- a/fs/hugetlbfs/inode.c
> > +++ b/fs/hugetlbfs/inode.c
> > @@ -946,7 +946,11 @@ struct file *hugetlb_file_setup(const char *name, size_t size,
> >  	if (creat_flags == HUGETLB_SHMFS_INODE && !can_do_hugetlb_shm()) {
> >  		*user = current_user();
> >  		if (user_shm_lock(size, *user)) {
> > -			printk_once(KERN_WARNING "Using mlock ulimits for SHM_HUGETLB is deprecated\n");
> > +			task_lock(current);
> > +			printk_once(KERN_WARNING
> > +				"%s (%d): Using mlock ulimits for SHM_HUGETLB is deprecated\n",
> > +				current->comm, current->pid);
> > +			task_unlock(current);
> 
> I assume the task_lock() is there to protect current->comm.

Yup.

> If so, it
> is unneeded - we're protecting against prctl(PR_SET_NAME), and
> PR_SET_NAME only operates on current, and we know this task isn't
> currently running PR_SET_NAME.
> 
> If there's a way for another task to alter this task's ->comm then we
> _do_ need locking.  But there isn't a way, I hope.
> 

I wish there wasn't as well, it would prevent a lot of the currently buggy 
reads to current->comm and allow us to avoid so many otherwise pointless 
task_lock()s.

This protects against /proc/pid/comm, which is writable by threads in the 
same thread group.  We have a get_task_comm() that does the task_lock() 
internally but requires a TASK_COMM_LEN buffer in the calling code.  It's 
just easier for the calling code to the task_lock() itself for a tiny 
little printk().
