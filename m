Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758601Ab2CHUCl (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Mar 2012 15:02:41 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:60490 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758547Ab2CHUCk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Mar 2012 15:02:40 -0500
Date: Thu, 8 Mar 2012 12:02:38 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: David Rientjes <rientjes@google.com>
Cc: Dave Jones <davej@redhat.com>, linux-kernel@vger.kernel.org,
        linux-mm@kvack.org
Subject: Re: [patch] mm, hugetlb: add thread name and pid to SHM_HUGETLB
 mlock rlimit warning
Message-Id: <20120308120238.c4486547.akpm@linux-foundation.org>
In-Reply-To: <alpine.DEB.2.00.1203061825070.9015@chino.kir.corp.google.com>
References: <alpine.DEB.2.00.1203061825070.9015@chino.kir.corp.google.com>
X-Mailer: Sylpheed 3.0.2 (GTK+ 2.20.1; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 6 Mar 2012 18:26:11 -0800 (PST)
David Rientjes <rientjes@google.com> wrote:

> Add the thread name and pid of the application that is allocating shm
> segments with MAP_HUGETLB without being a part of
> /proc/sys/vm/hugetlb_shm_group or having CAP_IPC_LOCK.
> 
> This identifies the application so it may be fixed by avoiding using the
> deprecated exception (see Documentation/feature-removal-schedule.txt).
> 
> ...
>
> --- a/fs/hugetlbfs/inode.c
> +++ b/fs/hugetlbfs/inode.c
> @@ -946,7 +946,11 @@ struct file *hugetlb_file_setup(const char *name, size_t size,
>  	if (creat_flags == HUGETLB_SHMFS_INODE && !can_do_hugetlb_shm()) {
>  		*user = current_user();
>  		if (user_shm_lock(size, *user)) {
> -			printk_once(KERN_WARNING "Using mlock ulimits for SHM_HUGETLB is deprecated\n");
> +			task_lock(current);
> +			printk_once(KERN_WARNING
> +				"%s (%d): Using mlock ulimits for SHM_HUGETLB is deprecated\n",
> +				current->comm, current->pid);
> +			task_unlock(current);

I assume the task_lock() is there to protect current->comm.  If so, it
is unneeded - we're protecting against prctl(PR_SET_NAME), and
PR_SET_NAME only operates on current, and we know this task isn't
currently running PR_SET_NAME.

If there's a way for another task to alter this task's ->comm then we
_do_ need locking.  But there isn't a way, I hope.

