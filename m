Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755614Ab2F1Wj7 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Jun 2012 18:39:59 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:42448 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751012Ab2F1Wj6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Jun 2012 18:39:58 -0400
Date: Thu, 28 Jun 2012 15:39:56 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Junxiao Bi <junxiao.bi@oracle.com>
Cc: ocfs2-devel@oss.oracle.com, linux-aio@kvack.org, mfasheh@suse.com,
        linux-kernel@vger.kernel.org, joe.jin@oracle.com,
        stable@vger.kernel.org
Subject: Re: [PATCH v4 1/2] aio: make kiocb->private NUll in
 init_sync_kiocb()
Message-Id: <20120628153956.9b7405d9.akpm@linux-foundation.org>
In-Reply-To: <1340788195-20623-2-git-send-email-junxiao.bi@oracle.com>
References: <1340788195-20623-1-git-send-email-junxiao.bi@oracle.com>
	<1340788195-20623-2-git-send-email-junxiao.bi@oracle.com>
X-Mailer: Sylpheed 3.0.2 (GTK+ 2.20.1; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 27 Jun 2012 17:09:54 +0800
Junxiao Bi <junxiao.bi@oracle.com> wrote:

> Ocfs2 uses kiocb.*private as a flag of unsigned long size. In
> commit a11f7e6 ocfs2: serialize unaligned aio, the unaligned
> io flag is involved in it to serialize the unaligned aio. As
> *private is not initialized in init_sync_kiocb() of do_sync_write(),
> this unaligned io flag may be unexpectly set in an aligned dio.
> And this will cause OCFS2_I(inode)->ip_unaligned_aio decreased
> to -1 in ocfs2_dio_end_io(), thus the following unaligned dio
> will hang forever at ocfs2_aiodio_wait() in ocfs2_file_aio_write().
> 
> Signed-off-by: Junxiao Bi <junxiao.bi@oracle.com>
> Cc: stable@vger.kernel.org
> Acked-by: Jeff Moyer <jmoyer@redhat.com>
> Acked-by: Joel Becker <jlbec@evilplan.org>
> ---
>  include/linux/aio.h |    1 +
>  1 file changed, 1 insertion(+)
> 
> diff --git a/include/linux/aio.h b/include/linux/aio.h
> index 2314ad8..b1a520e 100644
> --- a/include/linux/aio.h
> +++ b/include/linux/aio.h
> @@ -140,6 +140,7 @@ struct kiocb {
>  		(x)->ki_dtor = NULL;			\
>  		(x)->ki_obj.tsk = tsk;			\
>  		(x)->ki_user_data = 0;                  \
> +		(x)->private = NULL;			\
>  	} while (0)
>  
>  #define AIO_RING_MAGIC			0xa10a10a1

hm, that code is rather cruddy.  Pointless macromania.


If we do this:

static inline void init_sync_kiocb(struct kiocb *kiocb, struct file *filp)
{
	struct task_struct *tsk = current;

	kiocb->ki_flags = 0;
	kiocb->ki_users = 1;
	kiocb->ki_key = KIOCB_SYNC_KEY;
	kiocb->ki_filp = filp;
	kiocb->ki_ctx = NULL;
	kiocb->ki_cancel = NULL;
	kiocb->ki_retry = NULL;
	kiocb->ki_dtor = NULL;
	kiocb->ki_obj.tsk = tsk;
	kiocb->ki_user_data = 0;
}

it is nicer and there is no impact on code size.


If we do this:

static inline void init_sync_kiocb(struct kiocb *kiocb, struct file *filp)
{
	*kiocb = (struct kiocb) {
			.ki_users = 1,
			.ki_key = KIOCB_SYNC_KEY,
			.ki_filp = filp,
			.ki_obj.tsk = current,
		};
}

then fs/read_write.o's .text is shrunk from 9857 bytes to 9714, which
is rather a lot.

But that's all rather irrelevant to your bugfix.
