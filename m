Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754386Ab0CYAwk (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Mar 2010 20:52:40 -0400
Received: from mx1.redhat.com ([209.132.183.28]:18193 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754226Ab0CYAwj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Mar 2010 20:52:39 -0400
Date: Wed, 24 Mar 2010 20:52:28 -0400
From: Vivek Goyal <vgoyal@redhat.com>
To: Ricky Benitez <rickyb@google.com>
Cc: Jens Axboe <axboe@kernel.dk>, Corrado Zoccolo <czoccolo@gmail.com>,
       Jeff Moyer <jmoyer@redhat.com>,
       Gui Jianfeng <guijianfeng@cn.fujitsu.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] Expose the statistics in blkio.time and blkio.sectors
	for the root cgroup
Message-ID: <20100325005228.GA13225@redhat.com>
References: <1269473756-30327-1-git-send-email-rickyb@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1269473756-30327-1-git-send-email-rickyb@google.com>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Mar 24, 2010 at 04:35:56PM -0700, Ricky Benitez wrote:
> Currently, the io statistics for the root cgroup are maintained, but
> they are not shown because the device information is not available at
> the point that the root blkio cgroup is created. This patch updates
> the device information when the statistics are updated so that the
> statistics become visible.
> 

Ok, root group is created when request queue is being initialized and
device information like major/minor number is not available. This is
not the cleanest solution but can't think of something better right now.

Acked-by: Vivek Goyal <vgoyal@redhat.com>

Thanks
Vivek

> Signed-off-by: Ricky Benitez <rickyb@google.com>
> ---
>  block/cfq-iosched.c |    5 +++++
>  1 files changed, 5 insertions(+), 0 deletions(-)
> 
> diff --git a/block/cfq-iosched.c b/block/cfq-iosched.c
> index dee9d93..4a3579a 100644
> --- a/block/cfq-iosched.c
> +++ b/block/cfq-iosched.c
> @@ -947,6 +947,11 @@ cfq_find_alloc_cfqg(struct cfq_data *cfqd, struct cgroup *cgroup, int create)
>  	unsigned int major, minor;
>  
>  	cfqg = cfqg_of_blkg(blkiocg_lookup_group(blkcg, key));
> +	if (cfqg && !cfqg->blkg.dev && bdi->dev && dev_name(bdi->dev)) {
> +		sscanf(dev_name(bdi->dev), "%u:%u", &major, &minor);
> +		cfqg->blkg.dev = MKDEV(major, minor);
> +		goto done;
> +	}
>  	if (cfqg || !create)
>  		goto done;
>  
> -- 
> 1.7.0.1
