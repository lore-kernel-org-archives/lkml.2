Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755534Ab1D1DFs (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Apr 2011 23:05:48 -0400
Received: from fgwmail5.fujitsu.co.jp ([192.51.44.35]:39296 "EHLO
	fgwmail5.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752100Ab1D1DFq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Apr 2011 23:05:46 -0400
X-SecurityPolicyCheck-FJ: OK by FujitsuOutboundMailChecker v1.3.1
From: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
To: john stultz <johnstul@us.ibm.com>
Subject: Re: [PATCH 1/2] break out page allocation warning code
Cc: kosaki.motohiro@jp.fujitsu.com, David Rientjes <rientjes@google.com>,
        Dave Hansen <dave@linux.vnet.ibm.com>, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org, Johannes Weiner <hannes@cmpxchg.org>,
        Michal Nazarewicz <mina86@mina86.com>,
        Andrew Morton <akpm@linux-foundation.org>
In-Reply-To: <1303853115.2816.129.camel@work-vm>
References: <20110421103009.731B.A69D9226@jp.fujitsu.com> <1303853115.2816.129.camel@work-vm>
Message-Id: <20110428120736.D193.A69D9226@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8bit
X-Mailer: Becky! ver. 2.56.05 [ja]
Date: Thu, 28 Apr 2011 12:05:42 +0900 (JST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> On Thu, 2011-04-21 at 10:29 +0900, KOSAKI Motohiro wrote:
> > And one correction.
> > ------------------------------------------------------------------
> > static ssize_t comm_write(struct file *file, const char __user *buf,
> >                                 size_t count, loff_t *offset)
> > {
> >         struct inode *inode = file->f_path.dentry->d_inode;
> >         struct task_struct *p;
> >         char buffer[TASK_COMM_LEN];
> > 
> >         memset(buffer, 0, sizeof(buffer));
> >         if (count > sizeof(buffer) - 1)
> >                 count = sizeof(buffer) - 1;
> >         if (copy_from_user(buffer, buf, count))
> >                 return -EFAULT;
> > 
> >         p = get_proc_task(inode);
> >         if (!p)
> >                 return -ESRCH;
> > 
> >         if (same_thread_group(current, p))
> >                 set_task_comm(p, buffer);
> >         else
> >                 count = -EINVAL;
> > ------------------------------------------------------------------
> > 
> > This code doesn't have proper credential check. IOW, you forgot to
> > pthread_setuid_np() case.
> 
> Sorry, could you expand on this a bit? Google isn't coming up with much
> for pthread_setuid_np. Can a thread actually end up with different uid
> then the process it is a member of?

Yes. Linux kernel _always_ only care per-thread uid.
glibc 2.3.3 or earlier, it use kernel syscall straight forward. and then
userland application also don't have a way to change per-process uid.

glbc 2.3.4 or later, glibc implement per-process setuid by using signal
for inter thread communication. (ie, every thread call setuid() syscall
internally). Hm, currently pthread_setuid_np don't have proper exported
header file. so, parpaps, we need to only worry about syscall(NR_uid) and
old libc?

Anyway, If you see task_struct definition, you can easily find it has
cred.

Thanks.

> 
> Or is same_thread_group not really what I think it is? What would be a
> better way to check that the two threads are members of the same
> process?
> 
> thanks
> -john
> 
> 



