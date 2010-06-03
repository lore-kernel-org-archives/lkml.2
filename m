Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933542Ab0FCB6O (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Jun 2010 21:58:14 -0400
Received: from e32.co.us.ibm.com ([32.97.110.150]:47730 "EHLO
	e32.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932590Ab0FCB6N (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Jun 2010 21:58:13 -0400
Date: Thu, 3 Jun 2010 07:28:06 +0530
From: Balbir Singh <balbir@linux.vnet.ibm.com>
To: Rafael Tinoco <tinhocas@gmail.com>
Cc: LKML <linux-kernel@vger.kernel.org>,
       Scrum - Linux <scrum-linux@locaweb.com.br>,
       Juliano Martinez <juliano.martinez@locaweb.com.br>,
       Gleicon Moraes <gleicon.moraes@locaweb.com.br>
Subject: Re: [PATCH] task_io_accounting, taskstats
Message-ID: <20100603015806.GD4603@balbir.in.ibm.com>
Reply-To: balbir@linux.vnet.ibm.com
References: <AANLkTikfoquMibVsd1dTtrFTDvaKVn1bmL_SfbjyZUoR@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
In-Reply-To: <AANLkTikfoquMibVsd1dTtrFTDvaKVn1bmL_SfbjyZUoR@mail.gmail.com>
User-Agent: Mutt/1.5.20 (2009-12-10)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Rafael Tinoco <tinhocas@gmail.com> [2010-06-02 18:56:43]:

> Hello,
> 
> I'm proposing this patch to extend taskstats capability of
> IO_ACCOUTING based on socket msg size.
> Already discussed with Balbir about it. The idea was to keep the
> "socket" accounting generic.
> Not taking in consideration witch type of socket or protocol is used.
> I'm using this in a user land tool called ustats for uid accounting
> with very low overhead (cn_msg and taskstats through netlink).
> 

Hi, Rafael

You've not signed-off on the patch. The coding style/patch seems off.
Could you please run scripts/checkpatch.pl to verify the patch.

Other comments

1. Test results are good to see in the posting
2. Documentation Update
3. User space component updates - getdelays.c

Also cc'ing netdev for more feedback.


> diff --git a/include/linux/task_io_accounting.h
> b/include/linux/task_io_accounting.h
> index bdf855c..ed54fab 100644
> --- a/include/linux/task_io_accounting.h
> +++ b/include/linux/task_io_accounting.h
> @@ -41,5 +41,16 @@ struct task_io_accounting {
>  	 * information loss in doing that.
>  	 */
>  	u64 cancelled_write_bytes;
> +
> +	/*
> +	 * The number of bytes which this task has read from a socket
> +	 */
> +	u64 read_net_bytes;
> +
> +        /*
> +	 * The number of bytes which this task has written to a socket
> +	 */
> +	u64 write_net_bytes;
> +
>  #endif /* CONFIG_TASK_IO_ACCOUNTING */
>  };
> diff --git a/include/linux/task_io_accounting_ops.h
> b/include/linux/task_io_accounting_ops.h
> index 4d090f9..f28aa4c 100644
> --- a/include/linux/task_io_accounting_ops.h
> +++ b/include/linux/task_io_accounting_ops.h
> @@ -12,6 +12,11 @@ static inline void task_io_account_read(size_t bytes)
>  	current->ioac.read_bytes += bytes;
>  }
> 
> +static inline void task_io_account_read_net(size_t bytes)
> +{
> +        current->ioac.read_net_bytes += bytes;
> +}
> +
>  /*
>   * We approximate number of blocks, because we account bytes only.
>   * A 'block' is 512 bytes
> @@ -26,6 +31,11 @@ static inline void task_io_account_write(size_t bytes)
>  	current->ioac.write_bytes += bytes;
>  }
> 
> +static inline void task_io_account_write_net(size_t bytes)
> +{
> +        current->ioac.write_net_bytes += bytes;
> +}
> +
>  /*
>   * We approximate number of blocks, because we account bytes only.
>   * A 'block' is 512 bytes
> @@ -59,6 +69,10 @@ static inline void task_io_account_read(size_t bytes)
>  {
>  }
> 
> +static inline void task_io_account_read_net(size_t bytes)
> +{
> +}
> +
>  static inline unsigned long task_io_get_inblock(const struct task_struct *p)
>  {
>  	return 0;
> @@ -68,6 +82,10 @@ static inline void task_io_account_write(size_t bytes)
>  {
>  }
> 
> +static inline void task_io_account_write_net(size_t bytes)
> +{
> +}
> +
>  static inline unsigned long task_io_get_oublock(const struct task_struct *p)
>  {
>  	return 0;
> diff --git a/include/linux/taskstats.h b/include/linux/taskstats.h
> index 341dddb..5067376 100644
> --- a/include/linux/taskstats.h
> +++ b/include/linux/taskstats.h
> @@ -163,6 +163,10 @@ struct taskstats {
>  	/* Delay waiting for memory reclaim */
>  	__u64	freepages_count;
>  	__u64	freepages_delay_total;
> +
> +        /* Per-task network I/O accounting */
> +        __u64   read_net_bytes;         /* bytes of socket read I/O */
> +        __u64   write_net_bytes;        /* bytes of socket write I/O */
>  };
> 
> 
> diff --git a/net/socket.c b/net/socket.c
> index 769c386..93507a3 100644
> --- a/net/socket.c
> +++ b/net/socket.c
> @@ -103,6 +103,8 @@
>  #include <linux/sockios.h>
>  #include <linux/atalk.h>
> 
> +#include <linux/task_io_accounting_ops.h>
> +
>  static int sock_no_open(struct inode *irrelevant, struct file *dontcare);
>  static ssize_t sock_aio_read(struct kiocb *iocb, const struct iovec *iov,
>  			 unsigned long nr_segs, loff_t pos);
> @@ -550,6 +552,9 @@ static inline int __sock_sendmsg(struct kiocb
> *iocb, struct socket *sock,
>  	if (err)
>  		return err;
> 
> +        if(size > 0)
> +            task_io_account_read_net(size);
> +
>  	return sock->ops->sendmsg(iocb, sock, msg, size);
>  }
> 
> @@ -666,6 +671,7 @@ EXPORT_SYMBOL_GPL(sock_recv_ts_and_drops);
>  static inline int __sock_recvmsg_nosec(struct kiocb *iocb, struct socket *sock,
>  				       struct msghdr *msg, size_t size, int flags)
>  {
> +        int ret = 0;
>  	struct sock_iocb *si = kiocb_to_siocb(iocb);
> 
>  	si->sock = sock;
> @@ -674,7 +680,12 @@ static inline int __sock_recvmsg_nosec(struct
> kiocb *iocb, struct socket *sock,
>  	si->size = size;
>  	si->flags = flags;
> 
> -	return sock->ops->recvmsg(iocb, sock, msg, size, flags);
> +        ret = sock->ops->recvmsg(iocb, sock, msg, size, flags);
> +
> +        if(ret > 0)
> +            task_io_account_read_net(ret);
> +
> +        return ret;
>  }
> 
>  static inline int __sock_recvmsg(struct kiocb *iocb, struct socket *sock,

-- 
	Three Cheers,
	Balbir
