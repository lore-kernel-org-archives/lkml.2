Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751043Ab2AWPVB (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Jan 2012 10:21:01 -0500
Received: from mx1.redhat.com ([209.132.183.28]:16563 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750754Ab2AWPVA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Jan 2012 10:21:00 -0500
Date: Mon, 23 Jan 2012 10:20:55 -0500
From: Vivek Goyal <vgoyal@redhat.com>
To: Tejun Heo <tj@kernel.org>
Cc: axboe@kernel.dk, ctalbott@google.com, rni@google.com,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 08/17] blkcg: shoot down blkio_groups on elevator switch
Message-ID: <20120123152055.GD25986@redhat.com>
References: <1327202725-3383-1-git-send-email-tj@kernel.org>
 <1327202725-3383-9-git-send-email-tj@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1327202725-3383-9-git-send-email-tj@kernel.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Jan 21, 2012 at 07:25:16PM -0800, Tejun Heo wrote:

[..]
> diff --git a/block/elevator.c b/block/elevator.c
> index 078a491..5e371e4 100644
> --- a/block/elevator.c
> +++ b/block/elevator.c
> @@ -38,6 +38,7 @@
>  #include <trace/events/block.h>
>  
>  #include "blk.h"
> +#include "blk-cgroup.h"
>  
>  static DEFINE_SPINLOCK(elv_list_lock);
>  static LIST_HEAD(elv_list);
> @@ -939,6 +940,7 @@ static int elevator_switch(struct request_queue *q, struct elevator_type *new_e)
>  
>  	spin_lock_irq(q->queue_lock);
>  	ioc_clear_queue(q);
> +	blkcg_clear_queue(q);

What happens to per device rules (per device weight and per device
throttling rules)? IIUC, in new scheme of things, upon elevator switch
these rules will be gone.

I can understand per device weight rules disappearing but what about 
throttling rules. They are independent of IO scheduler and change of
io scheduler should not cause per device throttling rules to get lost.

This just gets worse if elevator switch fails and we fall back to old
elevator. But now we have lost of the rules as rules were part of
blkg.conf and old groups are gone.

Thanks
Vivek
