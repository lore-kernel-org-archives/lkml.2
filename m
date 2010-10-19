Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933927Ab0JSLJx (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Oct 2010 07:09:53 -0400
Received: from casper.infradead.org ([85.118.1.10]:49874 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932693Ab0JSLJw convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Oct 2010 07:09:52 -0400
Subject: Re: [PATCH] support polling of /proc/swaps
From: Peter Zijlstra <peterz@infradead.org>
To: Kay Sievers <kay.sievers@vrfy.org>
Cc: linux-kernel <linux-kernel@vger.kernel.org>, Greg KH <greg@kroah.com>,
        Andrew Morton <akpm@linux-foundation.org>, linux-mm@kvack.org
In-Reply-To: <1287479956.1729.1.camel@yio.site>
References: <1287479956.1729.1.camel@yio.site>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
Date: Tue, 19 Oct 2010 13:09:46 +0200
Message-ID: <1287486586.1994.3.camel@twins>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2010-10-19 at 11:19 +0200, Kay Sievers wrote:
> From: Kay Sievers <kay.sievers@vrfy.org>
> Subject: support polling of /proc/swaps
> 
> System management wants to subscribe to changes in swap
> configuration. Make /proc/swaps pollable like /proc/mounts.

And yet you didn't cc any of the mm/ folks on this patch...

> Signed-Off-By: Kay Sievers <kay.sievers@vrfy.org>
> ---
>  mm/swapfile.c |   48 +++++++++++++++++++++++++++++++++++++++++++++++-
>  1 file changed, 47 insertions(+), 1 deletion(-)
> 
> --- a/mm/swapfile.c
> +++ b/mm/swapfile.c
> @@ -30,6 +30,7 @@
>  #include <linux/capability.h>
>  #include <linux/syscalls.h>
>  #include <linux/memcontrol.h>
> +#include <linux/poll.h>
>  
>  #include <asm/pgtable.h>
>  #include <asm/tlbflush.h>
> @@ -58,6 +59,9 @@ static struct swap_info_struct *swap_inf
>  
>  static DEFINE_MUTEX(swapon_mutex);
>  
> +static DECLARE_WAIT_QUEUE_HEAD(proc_poll_wait);
> +static int proc_poll_event;
> +
>  static inline unsigned char swap_count(unsigned char ent)
>  {
>  	return ent & ~SWAP_HAS_CACHE;	/* may include SWAP_HAS_CONT flag */
> @@ -1680,6 +1684,8 @@ SYSCALL_DEFINE1(swapoff, const char __us
>  	}
>  	filp_close(swap_file, NULL);
>  	err = 0;
> +	proc_poll_event++;
> +	wake_up_interruptible(&proc_poll_wait);
>  
>  out_dput:
>  	filp_close(victim, NULL);
> @@ -1688,6 +1694,25 @@ out:
>  }
>  
>  #ifdef CONFIG_PROC_FS
> +struct proc_swaps {
> +	struct seq_file seq;
> +	int event;
> +};
> +
> +static unsigned swaps_poll(struct file *file, poll_table *wait)
> +{
> +	struct proc_swaps *s = file->private_data;
> +
> +	poll_wait(file, &proc_poll_wait, wait);
> +
> +	if (s->event != proc_poll_event) {
> +		s->event = proc_poll_event;
> +		return POLLIN | POLLRDNORM | POLLERR | POLLPRI;
> +	}
> +
> +	return POLLIN | POLLRDNORM;
> +}
> +
>  /* iterator */
>  static void *swap_start(struct seq_file *swap, loff_t *pos)
>  {
> @@ -1771,7 +1796,24 @@ static const struct seq_operations swaps
>  
>  static int swaps_open(struct inode *inode, struct file *file)
>  {
> -	return seq_open(file, &swaps_op);
> +	struct proc_swaps *s;
> +	int ret;
> +
> +	s = kmalloc(sizeof(struct proc_swaps), GFP_KERNEL);
> +	if (!s)
> +		return -ENOMEM;
> +
> +	file->private_data = &s->seq;
> +
> +	ret = seq_open(file, &swaps_op);
> +	if (ret) {
> +		kfree(s);
> +		return ret;
> +	}
> +
> +	s->seq.private = s;
> +	s->event = proc_poll_event;
> +	return ret;
>  }
>  
>  static const struct file_operations proc_swaps_operations = {
> @@ -1779,6 +1821,7 @@ static const struct file_operations proc
>  	.read		= seq_read,
>  	.llseek		= seq_lseek,
>  	.release	= seq_release,
> +	.poll		= swaps_poll,
>  };
>  
>  static int __init procswaps_init(void)
> @@ -2084,6 +2127,9 @@ SYSCALL_DEFINE2(swapon, const char __use
>  		swap_info[prev]->next = type;
>  	spin_unlock(&swap_lock);
>  	mutex_unlock(&swapon_mutex);
> +	proc_poll_event++;
> +	wake_up_interruptible(&proc_poll_wait);
> +
>  	error = 0;
>  	goto out;
>  bad_swap:
> 
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/

