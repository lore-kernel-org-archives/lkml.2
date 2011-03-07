Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753227Ab1CGU3U (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Mar 2011 15:29:20 -0500
Received: from mx1.redhat.com ([209.132.183.28]:35158 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751203Ab1CGU3T (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Mar 2011 15:29:19 -0500
Date: Mon, 7 Mar 2011 15:29:17 -0500
From: Vivek Goyal <vgoyal@redhat.com>
To: Jens Axboe <jaxboe@fusionio.com>
Cc: "oleg@redhat.com" <oleg@redhat.com>,
        "paulmck@linux.vnet.ibm.com" <paulmck@linux.vnet.ibm.com>,
        linux kernel mailing list <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 0/2] blk-throttle: Couple of cleanup and fixes for limit
 update code
Message-ID: <20110307202917.GI9540@redhat.com>
References: <1298331770-20079-1-git-send-email-vgoyal@redhat.com>
 <20110307155006.GF9540@redhat.com>
 <4D753C79.4020800@fusionio.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4D753C79.4020800@fusionio.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Mar 07, 2011 at 09:13:45PM +0100, Jens Axboe wrote:
> On 2011-03-07 16:50, Vivek Goyal wrote:
> > On Mon, Feb 21, 2011 at 06:42:48PM -0500, Vivek Goyal wrote:
> >> Hi Jens,
> >>
> >> Couple of throttle fixes seem to have fallen through cracks.
> >>
> >> https://lkml.org/lkml/2010/12/15/331
> >>
> >> I am reposting it for inclusion. Please let me know if you have any concerns.
> >> Oleg and Paul acked the patch in the past so I am retaining their Reviewed-by:
> >> lines.
> >>
> > 
> > Hi Jens,
> > 
> > Can you please apply following patches for 2.6.39. These are good for fixing
> > couple of race conditions in block throttle code w.r.t limit updates.
> > Please let me know if you have concernes with these patches.
> 
> I have applied them now. 2/2 is a nice cleanup. But it does not apply
> cleanly after the workqueue change we merged last week. I fixed it up
> for you, manually applied hunk #5 and added the below diff. Please
> inspect the end result. You should have rebased that patch.

Sorry, this patch was posted before workqueue change last week. I should
have rebased and reposted it before pinging you again. Will take care of
it next time onwards.

> 
> Also note that you seem to have a double xchg() in there, also added
> from 2/2.

Actually one xchg is tracking per group limit changes (tg) and one xchg()
it tracking overall limit change per queue (td), meaning if any of
the group on this queue has changed the limit or not. That avoids
traversal of list of all the groups if none of the group has changed
the limit.

> 
> diff --git a/block/blk-throttle.c b/block/blk-throttle.c
> index 7a833c9..32dd3e4 100644
> --- a/block/blk-throttle.c
> +++ b/block/blk-throttle.c
> @@ -898,7 +898,7 @@ static void throtl_update_blkio_group_common(struct throtl_data *td,
>  	xchg(&tg->limits_changed, true);
>  	xchg(&td->limits_changed, true);
>  	/* Schedule a work now to process the limit change */
> -	throtl_schedule_delayed_work(td->queue, 0);
> +	throtl_schedule_delayed_work(td, 0);

This looks good. Thanks Jens.

Vivek
