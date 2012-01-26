Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753076Ab2AZSFg (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Jan 2012 13:05:36 -0500
Received: from mail-pz0-f46.google.com ([209.85.210.46]:56958 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752011Ab2AZSFf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Jan 2012 13:05:35 -0500
Date: Thu, 26 Jan 2012 10:05:32 -0800
From: Tejun Heo <tj@kernel.org>
To: Vivek Goyal <vgoyal@redhat.com>
Cc: Suresh Jayaraman <sjayaraman@suse.com>,
        LKML <linux-kernel@vger.kernel.org>, Jens Axboe <axboe@kernel.dk>,
        Dirk Gouders <gouders@et.bocholt.fh-gelsenkirchen.de>
Subject: Re: Slab corruption in floppy driver module
Message-ID: <20120126180532.GA4077@dhcp-172-17-108-109.mtv.corp.google.com>
References: <4F1EAFE9.5000306@suse.com>
 <20120124223153.GG17291@redhat.com>
 <20120126150420.GD1891@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120126150420.GD1891@redhat.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

On Thu, Jan 26, 2012 at 10:04:20AM -0500, Vivek Goyal wrote:
>  out_put_disk:
>  	while (dr--) {
>  		del_timer_sync(&motor_off_timer[dr]);
> -		if (disks[dr]->queue)
> +		if (disks[dr]->queue) {
>  			blk_cleanup_queue(disks[dr]->queue);
> +			/*
> +			 * The request queue reference we took at device
> +			 * creation time has been put by above
> +			 * blk_cleanup_queue(). We have not called add_disk()
> +			 * yet and due to failure calling put_disk(). Put disk
> +			 * will try to put a reference to disk->queue which is
> +			 * taken in add_disk(). As we have not taken that
> +			 * extra reference, putting extra reference down
> +			 * will try to access already freed queue. Clear
> +			 * disk->queue before calling put_disk().
> +			 */
> +			disks[dr]->queue = NULL;

Yeah, this looks correct to me.  It might be better to tone down the
comment a bit tho.  Wouldn't it be sufficient to say put_disk() isn't
paired with add_disk() and will put one extra time?

Thanks.

-- 
tejun
