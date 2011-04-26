Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932705Ab1DZVZm (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Apr 2011 17:25:42 -0400
Received: from e2.ny.us.ibm.com ([32.97.182.142]:38548 "EHLO e2.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932391Ab1DZVZi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Apr 2011 17:25:38 -0400
Subject: Re: [PATCH 1/2] break out page allocation warning code
From: john stultz <johnstul@us.ibm.com>
To: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Cc: David Rientjes <rientjes@google.com>,
        Dave Hansen <dave@linux.vnet.ibm.com>, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org, Johannes Weiner <hannes@cmpxchg.org>,
        Michal Nazarewicz <mina86@mina86.com>,
        Andrew Morton <akpm@linux-foundation.org>
In-Reply-To: <20110421103009.731B.A69D9226@jp.fujitsu.com>
References: <alpine.DEB.2.00.1104201317410.31768@chino.kir.corp.google.com>
	 <1303331695.2796.159.camel@work-vm>
	 <20110421103009.731B.A69D9226@jp.fujitsu.com>
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 26 Apr 2011 14:25:15 -0700
Message-ID: <1303853115.2816.129.camel@work-vm>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2011-04-21 at 10:29 +0900, KOSAKI Motohiro wrote:
> And one correction.
> ------------------------------------------------------------------
> static ssize_t comm_write(struct file *file, const char __user *buf,
>                                 size_t count, loff_t *offset)
> {
>         struct inode *inode = file->f_path.dentry->d_inode;
>         struct task_struct *p;
>         char buffer[TASK_COMM_LEN];
> 
>         memset(buffer, 0, sizeof(buffer));
>         if (count > sizeof(buffer) - 1)
>                 count = sizeof(buffer) - 1;
>         if (copy_from_user(buffer, buf, count))
>                 return -EFAULT;
> 
>         p = get_proc_task(inode);
>         if (!p)
>                 return -ESRCH;
> 
>         if (same_thread_group(current, p))
>                 set_task_comm(p, buffer);
>         else
>                 count = -EINVAL;
> ------------------------------------------------------------------
> 
> This code doesn't have proper credential check. IOW, you forgot to
> pthread_setuid_np() case.

Sorry, could you expand on this a bit? Google isn't coming up with much
for pthread_setuid_np. Can a thread actually end up with different uid
then the process it is a member of?

Or is same_thread_group not really what I think it is? What would be a
better way to check that the two threads are members of the same
process?

thanks
-john


