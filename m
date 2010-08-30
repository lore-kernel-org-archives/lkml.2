Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755629Ab0H3PiF (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Aug 2010 11:38:05 -0400
Received: from daytona.panasas.com ([67.152.220.89]:48352 "EHLO
	daytona.int.panasas.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751590Ab0H3PiD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Aug 2010 11:38:03 -0400
Message-ID: <4C7BD051.70302@panasas.com>
Date: Mon, 30 Aug 2010 18:37:53 +0300
From: Boaz Harrosh <bharrosh@panasas.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.9) Gecko/20100430 Fedora/3.0.4-2.fc12 Thunderbird/3.0.4
MIME-Version: 1.0
To: Tejun Heo <tj@kernel.org>
CC: jaxboe@fusionio.com, linux-kernel@vger.kernel.org,
        linux-fsdevel@vger.kernel.org, linux-scsi@vger.kernel.org,
        linux-ide@vger.kernel.org, linux-raid@vger.kernel.org, hch@lst.de,
        James.Bottomley@suse.de, tytso@mit.edu, chris.mason@oracle.com,
        swhiteho@redhat.com, konishi.ryusuke@lab.ntt.co.jp,
        dm-devel@redhat.com, vst@vlnb.net, jack@suse.cz, rwheeler@redhat.com,
        hare@suse.de, neilb@suse.de, rusty@rustcorp.com.au, mst@redhat.com,
        jeremy@goop.org, snitzer@redhat.com, k-ueda@ct.jp.nec.com,
        Christoph Hellwig <hch@infradead.org>, Nick Piggin <npiggin@kernel.dk>,
        Jeremy Fitzhardinge <jeremy@xensource.com>,
        Chris Wright <chrisw@sous-sol.org>,
        FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>,
        Geert Uytterhoeven <Geert.Uytterhoeven@sonycom.com>,
        "David S. Miller" <davem@davemloft.net>,
        Alasdair G Kergon <agk@redhat.com>, Pierre Ossman <drzeus@drzeus.cx>,
        Stefan Weinhuber <wein@de.ibm.com>
Subject: Re: [PATCH 04/30] block: deprecate barrier and replace blk_queue_ordered()
 with blk_queue_flush()
References: <1282751267-3530-1-git-send-email-tj@kernel.org> <1282751267-3530-5-git-send-email-tj@kernel.org>
In-Reply-To: <1282751267-3530-5-git-send-email-tj@kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 30 Aug 2010 15:38:01.0227 (UTC) FILETIME=[543575B0:01CB4859]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/25/2010 06:47 PM, Tejun Heo wrote:
> Barrier is deemed too heavy and will soon be replaced by FLUSH/FUA
> requests.  Deprecate barrier.  All REQ_HARDBARRIERs are failed with
> -EOPNOTSUPP and blk_queue_ordered() is replaced with simpler
> blk_queue_flush().
> 
> blk_queue_flush() takes combinations of REQ_FLUSH and FUA.  If a
> device has write cache and can flush it, it should set REQ_FLUSH.  If
> the device can handle FUA writes, it should also set REQ_FUA.
> 
> All blk_queue_ordered() users are converted.
> 
> * ORDERED_DRAIN is mapped to 0 which is the default value.
> * ORDERED_DRAIN_FLUSH is mapped to REQ_FLUSH.
> * ORDERED_DRAIN_FLUSH_FUA is mapped to REQ_FLUSH | REQ_FUA.
> 
> Signed-off-by: Tejun Heo <tj@kernel.org>
> Cc: Christoph Hellwig <hch@infradead.org>
> Cc: Nick Piggin <npiggin@kernel.dk>
> Cc: Michael S. Tsirkin <mst@redhat.com>
> Cc: Jeremy Fitzhardinge <jeremy@xensource.com>
> Cc: Chris Wright <chrisw@sous-sol.org>
> Cc: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
> Cc: Boaz Harrosh <bharrosh@panasas.com>

Acked-by: Boaz Harrosh <bharrosh@panasas.com>

Actually osd as support for FUA as well. It's on my todo
to implement it.

Thanks Tejun, as usual, after your visit there is more room
in the house.

> Cc: Geert Uytterhoeven <Geert.Uytterhoeven@sonycom.com>
> Cc: David S. Miller <davem@davemloft.net>
> Cc: Alasdair G Kergon <agk@redhat.com>
> Cc: Pierre Ossman <drzeus@drzeus.cx>
> Cc: Stefan Weinhuber <wein@de.ibm.com>
> ---
<snip>
>  drivers/block/osdblk.c       |    2 +-
> diff --git a/drivers/block/osdblk.c b/drivers/block/osdblk.c
> index 2284b4f..72d6246 100644
> --- a/drivers/block/osdblk.c
> +++ b/drivers/block/osdblk.c
> @@ -439,7 +439,7 @@ static int osdblk_init_disk(struct osdblk_device *osdev)
>  	blk_queue_stack_limits(q, osd_request_queue(osdev->osd));
>  
>  	blk_queue_prep_rq(q, blk_queue_start_tag);
> -	blk_queue_ordered(q, QUEUE_ORDERED_DRAIN_FLUSH);
> +	blk_queue_flush(q, REQ_FLUSH);
>  
>  	disk->queue = q;
>  
<snip>

Also this mail
On 08/25/2010 06:47 PM, Tejun Heo wrote:
> REQ_HARDBARRIER is deprecated.  Remove spurious uses in the following
> users.  Please note that other than osdblk, all other uses were
> already spurious before deprecation.
> 
> * osdblk: osdblk_rq_fn() won't receive any request with
>   REQ_HARDBARRIER set.  Remove the test for it.
> 
> * pktcdvd: use of REQ_HARDBARRIER in pkt_generic_packet() doesn't mean
>   anything.  Removed.
> 
> * aic7xxx_old: Setting MSG_ORDERED_Q_TAG on REQ_HARDBARRIER is
>   spurious.  Removed.
> 
> * sas_scsi_host: Setting TASK_ATTR_ORDERED on REQ_HARDBARRIER is
>   spurious.  Removed.
> 
> * scsi_tcq: The ordered tag path wasn't being used anyway.  Removed.
> 
> Signed-off-by: Tejun Heo <tj@kernel.org>
> Cc: Boaz Harrosh <bharrosh@panasas.com>

Acked-by: Boaz Harrosh <bharrosh@panasas.com>

> Cc: James Bottomley <James.Bottomley@suse.de>
> Cc: Peter Osterlund <petero2@telia.com>
> ---
>  drivers/block/osdblk.c              |    3 +--
<snip>
> diff --git a/drivers/block/osdblk.c b/drivers/block/osdblk.c
> index 72d6246..87311eb 100644
> --- a/drivers/block/osdblk.c
> +++ b/drivers/block/osdblk.c
> @@ -310,8 +310,7 @@ static void osdblk_rq_fn(struct request_queue *q)
>  			break;
>  
>  		/* filter out block requests we don't understand */
> -		if (rq->cmd_type != REQ_TYPE_FS &&
> -		    !(rq->cmd_flags & REQ_HARDBARRIER)) {
> +		if (rq->cmd_type != REQ_TYPE_FS) {
>  			blk_end_request_all(rq, 0);
>  			continue;
>  		}

