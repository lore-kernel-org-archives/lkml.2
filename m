Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753511Ab0HXAA4 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Aug 2010 20:00:56 -0400
Received: from fgwmail5.fujitsu.co.jp ([192.51.44.35]:53465 "EHLO
	fgwmail5.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753158Ab0HXAAx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Aug 2010 20:00:53 -0400
X-SecurityPolicyCheck-FJ: OK by FujitsuOutboundMailChecker v1.3.1
From: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
To: Wu Fengguang <fengguang.wu@intel.com>
Subject: Re: [PATCH] writeback: remove the internal 5% low bound on dirty_ratio
Cc: kosaki.motohiro@jp.fujitsu.com, Neil Brown <neilb@suse.de>,
        Con Kolivas <kernel@kolivas.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>,
        "linux-mm@kvack.org" <linux-mm@kvack.org>,
        "riel@redhat.com" <riel@redhat.com>,
        "david@fromorbit.com" <david@fromorbit.com>, "hch@lst.de" <hch@lst.de>,
        "axboe@kernel.dk" <axboe@kernel.dk>
In-Reply-To: <20100823062359.GA19586@localhost>
References: <20100823144248.15fbb700@notabene> <20100823062359.GA19586@localhost>
Message-Id: <20100824085812.F3AD.A69D9226@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Content-Transfer-Encoding: 7bit
X-Mailer: Becky! ver. 2.50.07 [ja]
Date: Tue, 24 Aug 2010 09:00:51 +0900 (JST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> writeback: remove the internal 5% low bound on dirty_ratio
> 
> The dirty_ratio was silently limited in global_dirty_limits() to >= 5%. This
> is not a user expected behavior. And it's inconsistent with calc_period_shift(),
> which uses the plain vm_dirty_ratio value. So let's rip the internal bound.
> 
> At the same time, force a user visible low bound of 1% for the vm.dirty_ratio
> interface. Applications trying to write 0 will be rejected with -EINVAL. This
> will break user space applications if they
> 1) try to write 0 to vm.dirty_ratio
> 2) and check the return value
> That is very weird combination, so the risk of breaking user space is low.

I'm ok this one too. because I bet nobody use 0% dirty ratio on their production
server and/or their own desktop. (i.e. I don't mind lab machine crash)

	Reviewed-by: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>

> 
> CC: Jan Kara <jack@suse.cz>
> CC: Neil Brown <neilb@suse.de>
> CC: Rik van Riel <riel@redhat.com>
> CC: Con Kolivas <kernel@kolivas.org>
> CC: Peter Zijlstra <a.p.zijlstra@chello.nl>
> CC: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
> Signed-off-by: Wu Fengguang <fengguang.wu@intel.com>
> ---
>  kernel/sysctl.c     |    2 +-
>  mm/page-writeback.c |   10 ++--------
>  2 files changed, 3 insertions(+), 9 deletions(-)
> 
> --- linux-next.orig/mm/page-writeback.c	2010-08-20 20:14:11.000000000 +0800
> +++ linux-next/mm/page-writeback.c	2010-08-23 10:31:01.000000000 +0800
> @@ -415,14 +415,8 @@ void global_dirty_limits(unsigned long *
>  
>  	if (vm_dirty_bytes)
>  		dirty = DIV_ROUND_UP(vm_dirty_bytes, PAGE_SIZE);
> -	else {
> -		int dirty_ratio;
> -
> -		dirty_ratio = vm_dirty_ratio;
> -		if (dirty_ratio < 5)
> -			dirty_ratio = 5;
> -		dirty = (dirty_ratio * available_memory) / 100;
> -	}
> +	else
> +		dirty = (vm_dirty_ratio * available_memory) / 100;
>  
>  	if (dirty_background_bytes)
>  		background = DIV_ROUND_UP(dirty_background_bytes, PAGE_SIZE);
> --- linux-next.orig/kernel/sysctl.c	2010-08-23 14:06:11.000000000 +0800
> +++ linux-next/kernel/sysctl.c	2010-08-23 14:07:30.000000000 +0800
> @@ -1029,7 +1029,7 @@ static struct ctl_table vm_table[] = {
>  		.maxlen		= sizeof(vm_dirty_ratio),
>  		.mode		= 0644,
>  		.proc_handler	= dirty_ratio_handler,
> -		.extra1		= &zero,
> +		.extra1		= &one,
>  		.extra2		= &one_hundred,
>  	},
>  	{



