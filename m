Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756003Ab2CLPTI (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Mar 2012 11:19:08 -0400
Received: from mx1.redhat.com ([209.132.183.28]:45857 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755718Ab2CLPTE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Mar 2012 11:19:04 -0400
Date: Mon, 12 Mar 2012 10:22:26 -0400
From: Vivek Goyal <vgoyal@redhat.com>
To: Xiaotian Feng <xtfeng@gmail.com>
Cc: linux-kernel@vger.kernel.org, Xiaotian Feng <xtfeng@gmail.com>,
        Xiaotian Feng <dannyfeng@tencent.com>, Tejun Heo <tj@kernel.org>
Subject: Re: [PATCH] block: fix ioc leak in put_io_context
Message-ID: <20120312142226.GD17288@redhat.com>
References: <1331564358-3058-1-git-send-email-xtfeng@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1331564358-3058-1-git-send-email-xtfeng@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Mar 12, 2012 at 10:59:18AM -0400, Xiaotian Feng wrote:
> When put_io_context is called, if ioc->icq_list is empty and refcount
> is 1, kernel will not free the ioc.
> 
> This is caught by following kmemleak:
> 
> unreferenced object 0xffff880036349fe0 (size 216):
>   comm "sh", pid 2137, jiffies 4294931140 (age 290579.412s)
>   hex dump (first 32 bytes):
>     00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
>     01 00 01 00 ad 4e ad de ff ff ff ff 00 00 00 00  .....N..........
>   backtrace:
>     [<ffffffff8169f926>] kmemleak_alloc+0x26/0x50
>     [<ffffffff81195a9c>] kmem_cache_alloc_node+0x1cc/0x2a0
>     [<ffffffff81356b67>] create_io_context_slowpath+0x27/0x130
>     [<ffffffff81356d2b>] get_task_io_context+0xbb/0xf0
>     [<ffffffff81055f0e>] copy_process+0x188e/0x18b0
>     [<ffffffff8105609b>] do_fork+0x11b/0x420
>     [<ffffffff810247f8>] sys_clone+0x28/0x30
>     [<ffffffff816d3373>] stub_clone+0x13/0x20
>     [<ffffffffffffffff>] 0xffffffffffffffff
> 
> ioc->release_work() should be used even if ioc->icq_list is empty.
> 
> Signed-off-by: Xiaotian Feng <dannyfeng@tencent.com>
> Cc: Tejun Heo <tj@kernel.org>
> Cc: Jens Axboe <axboe@kernel.dk> 
> ---
>  block/blk-ioc.c |    3 +--
>  1 files changed, 1 insertions(+), 2 deletions(-)
> 
> diff --git a/block/blk-ioc.c b/block/blk-ioc.c
> index 8b782a6..d74a8ce 100644
> --- a/block/blk-ioc.c
> +++ b/block/blk-ioc.c
> @@ -157,8 +157,7 @@ void put_io_context(struct io_context *ioc)
>  	 */
>  	if (atomic_long_dec_and_test(&ioc->refcount)) {
>  		spin_lock_irqsave(&ioc->lock, flags);
> -		if (!hlist_empty(&ioc->icq_list))
> -			schedule_work(&ioc->release_work);
> +		schedule_work(&ioc->release_work);
>  		spin_unlock_irqrestore(&ioc->lock, flags);

May be free the ioc right here instead of invoking release_work(). 

Thanks
Vivek
