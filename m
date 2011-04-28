Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755307Ab1D1Vfv (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Apr 2011 17:35:51 -0400
Received: from smtp-out.google.com ([74.125.121.67]:40560 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754290Ab1D1Vft (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Apr 2011 17:35:49 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=google.com; s=beta;
        h=date:from:x-x-sender:to:cc:subject:in-reply-to:message-id
         :references:user-agent:mime-version:content-type;
        b=kUjufzLe8HzQj3Q7PrilzYg8O5Rgsji9KfJgqw6TxDn5f6Ef0oxiIyLk6wKJ06I01u
         XvC6yZ3Fb61M8OnzA+nw==
Date: Thu, 28 Apr 2011 14:35:32 -0700 (PDT)
From: David Rientjes <rientjes@google.com>
X-X-Sender: rientjes@chino.kir.corp.google.com
To: John Stultz <john.stultz@linaro.org>
cc: LKML <linux-kernel@vger.kernel.org>,
        KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
        Dave Hansen <dave@linux.vnet.ibm.com>,
        Andrew Morton <akpm@linux-foundation.org>, linux-mm@kvack.org
Subject: Re: [PATCH 3/3] comm: ext4: Protect task->comm access by using
 get_task_comm()
In-Reply-To: <1303963411-2064-4-git-send-email-john.stultz@linaro.org>
Message-ID: <alpine.DEB.2.00.1104281426210.21665@chino.kir.corp.google.com>
References: <1303963411-2064-1-git-send-email-john.stultz@linaro.org> <1303963411-2064-4-git-send-email-john.stultz@linaro.org>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 27 Apr 2011, John Stultz wrote:

> diff --git a/fs/ext4/file.c b/fs/ext4/file.c
> index 7b80d54..d37414e 100644
> --- a/fs/ext4/file.c
> +++ b/fs/ext4/file.c
> @@ -124,11 +124,15 @@ ext4_file_write(struct kiocb *iocb, const struct iovec *iov,
>  		static unsigned long unaligned_warn_time;
>  
>  		/* Warn about this once per day */
> -		if (printk_timed_ratelimit(&unaligned_warn_time, 60*60*24*HZ))
> +		if (printk_timed_ratelimit(&unaligned_warn_time, 60*60*24*HZ)) {
> +			char comm[TASK_COMM_LEN];
> +
> +			get_task_comm(comm, current);
>  			ext4_msg(inode->i_sb, KERN_WARNING,
>  				 "Unaligned AIO/DIO on inode %ld by %s; "
>  				 "performance will be poor.",
> -				 inode->i_ino, current->comm);
> +				 inode->i_ino, comm);
> +		}
>  		mutex_lock(ext4_aio_mutex(inode));
>  		ext4_aiodio_wait(inode);
>  	}

Thanks very much for looking into concurrent readers of current->comm, 
John!

This patch in the series demonstrates one of the problems with using 
get_task_comm(), however: we must allocate a 16-byte buffer on the stack 
and that could become risky if we don't know its current depth.  We may be 
particularly deep in the stack and then cause an overflow because of the 
16 bytes.

I'm wondering if it would be better for ->comm to be protected by a 
spinlock (or rwlock) other than ->alloc_lock and then just require readers 
to take the lock prior to dereferencing it?  That's what is done in the 
oom killer with task_lock().  Perhaps you could introduce new 
task_comm_lock() and task_comm_unlock() to prevent the extra stack usage 
in over 300 locations within the kernel?
