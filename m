Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751945Ab2EaEge (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 May 2012 00:36:34 -0400
Received: from rcsinet15.oracle.com ([148.87.113.117]:49585 "EHLO
	rcsinet15.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750911Ab2EaEgc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 May 2012 00:36:32 -0400
Message-ID: <4FC6F53E.9020103@oracle.com>
Date: Thu, 31 May 2012 12:36:14 +0800
From: Joe Jin <joe.jin@oracle.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:12.0) Gecko/20120430 Thunderbird/12.0.1
MIME-Version: 1.0
To: Junxiao Bi <junxiao.bi@oracle.com>
CC: ocfs2-devel@oss.oracle.com, linux-aio@kvack.org, mfasheh@suse.com,
        jlbec@evilplan.org, bcrl@kvack.org, linux-kernel@vger.kernel.org,
        stable@vger.kernel.org, David John Kleikamp <dave.kleikamp@oracle.com>
Subject: Re: [PATCH 1/2] aio: make kiocb->private NUll in init_sync_kiocb()
References: <1338437550-24499-1-git-send-email-junxiao.bi@oracle.com>
In-Reply-To: <1338437550-24499-1-git-send-email-junxiao.bi@oracle.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Source-IP: acsinet22.oracle.com [141.146.126.238]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Cc David.

On 05/31/12 12:12, Junxiao Bi wrote:
> Ocfs2 uses kiocb.*private as a flag of unsigned long size. In
> commit a11f7e6 ocfs2: serialize unaligned aio, the unaligned
> io flag is involved in it to serialize the unaligned aio. As
> *private is not initialized in init_sync_kiocb() of do_sync_write(),
> this unaligned io flag may be unexpectly set in an aligned dio.
> And this will cause OCFS2_I(inode)->ip_unaligned_aio decreased
> to -1 in ocfs2_dio_end_io(), thus the following unaligned dio
> will hang forever at ocfs2_aiodio_wait() in ocfs2_file_write_iter().
> 
> We can't initialized this flag in ocfs2_file_write_iter() since
> it may be invoked several times by do_sync_write(). So we initialize
> it in init_sync_kiocb(), it's also useful for other similiar use of
> it in the future.
> 
> Signed-off-by: Junxiao Bi <junxiao.bi@oracle.com>
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


-- 
Oracle <http://www.oracle.com>
Joe Jin | Software Development Senior Manager | +8610.6106.5624
ORACLE | Linux and Virtualization
No. 24 Zhongguancun Software Park, Haidian District | 100193 Beijing 
