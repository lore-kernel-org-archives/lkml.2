Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753605Ab3AHVFM (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Jan 2013 16:05:12 -0500
Received: from mail-qc0-f189.google.com ([209.85.216.189]:48320 "EHLO
	mail-qc0-f189.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753323Ab3AHVFL convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Jan 2013 16:05:11 -0500
X-Greylist: delayed 8649 seconds by postgrey-1.27 at vger.kernel.org; Tue, 08 Jan 2013 16:05:10 EST
Path: glegroupsg2000goo.googlegroups.com!not-for-mail
Newsgroups: fa.linux.kernel
Date: Tue, 8 Jan 2013 10:04:23 -0800 (PST)
In-Reply-To: <fa.WShHQz59YhGkw1sSCIqXCXLEJ3Q@ifi.uio.no>
Complaints-To: groups-abuse@google.com
Injection-Info: glegroupsg2000goo.googlegroups.com; posting-host=122.167.45.138;
 posting-account=NCRxaQoAAAD54XcIcQi1OXMFZuM4f-KP
NNTP-Posting-Host: 122.167.45.138
References: <fa.WShHQz59YhGkw1sSCIqXCXLEJ3Q@ifi.uio.no>
User-Agent: G2/1.0
X-Google-Web-Client: true
X-Google-IP: 122.167.45.138
MIME-Version: 1.0
Message-ID: <52efc2cd-6d8c-4195-882a-8bc4105bc715@googlegroups.com>
Subject: Re: [block] allow blk_flush_policy to return REQ_FSEQ_DATA
 independent of *FLUSH
From: ajithb.kumar@gmail.com
To: fa.linux.kernel@googlegroups.com
Cc: Tejun Heo <tj@kernel.org>, linux-kernel@vger.kernel.org,
        Jens Axboe <jaxboe@fusionio.com>
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,
Could you please provide clarity on the following.
">   Hmmm... yes, this can become a correctness issue if (and only if)
>   blk_queue_flush() is called to change q->flush_flags while requests
>   are in-flight;"
Could you please clarify as to why is it a correctness issue only if blk_queue_flush() is used to change flush_flags when requests are in flight ?  As I understand, XFS does set WRITE_FLUSH_FUA flag in _xfs_buf_ioapply() function irrespective of whether the underlying device supports flush capabilities or not which will flow into blk_insert_flush().  Is my reading of the code correct and is there a general correctness issue here which potentially results in XFS file system corruption in case of an abrupt shutdown independent of q->flush_flags getting changed while request is in flight.

Thanks,
Ajith

On Tuesday, 9 August 2011 20:54:35 UTC+5:30, Jeff Moyer  wrote:
> Hi,
> 
> blk_insert_flush has the following check:
> 
> 	/*
> 	 * If there's data but flush is not necessary, the request can be
> 	 * processed directly without going through flush machinery.  Queue
> 	 * for normal execution.
> 	 */
> 	if ((policy & REQ_FSEQ_DATA) &&
> 	    !(policy & (REQ_FSEQ_PREFLUSH | REQ_FSEQ_POSTFLUSH))) {
> 		list_add_tail(&rq->queuelist, &q->queue_head);
> 		return;
> 	}
> 
> However, blk_flush_policy will not return with policy set to only
> REQ_FSEQ_DATA:
> 
> static unsigned int blk_flush_policy(unsigned int fflags, struct request *rq)
> {
> 	unsigned int policy = 0;
> 
> 	if (fflags & REQ_FLUSH) {
> 		if (rq->cmd_flags & REQ_FLUSH)
> 			policy |= REQ_FSEQ_PREFLUSH;
> 		if (blk_rq_sectors(rq))
> 			policy |= REQ_FSEQ_DATA;
> 		if (!(fflags & REQ_FUA) && (rq->cmd_flags & REQ_FUA))
> 			policy |= REQ_FSEQ_POSTFLUSH;
> 	}
> 	return policy;
> }
> 
> Notice that REQ_FSEQ_DATA is only set if REQ_FLUSH is set.  Fix this
> mismatch by moving the setting of REQ_FSEQ_DATA outside of the REQ_FLUSH
> check.
> 
> Tejun notes:
> 
>   Hmmm... yes, this can become a correctness issue if (and only if)
>   blk_queue_flush() is called to change q->flush_flags while requests
>   are in-flight; otherwise, requests wouldn't reach the function at all.
>   Also, I think it would be a generally good idea to always set
>   FSEQ_DATA if the request has data.
> 
> Cheers,
> Jeff
> 
> Signed-off-by: Jeff Moyer <jmoyer@redhat.com>
> Acked-by: Tejun Heo <tj@kernel.org>
> 
> diff --git a/block/blk-flush.c b/block/blk-flush.c
> index bb21e4c..2d162bd 100644
> --- a/block/blk-flush.c
> +++ b/block/blk-flush.c
> @@ -95,11 +95,12 @@ static unsigned int blk_flush_policy(unsigned int fflags, struct request *rq)
>  {
>  	unsigned int policy = 0;
>  
> +	if (blk_rq_sectors(rq))
> +		policy |= REQ_FSEQ_DATA;
> +
>  	if (fflags & REQ_FLUSH) {
>  		if (rq->cmd_flags & REQ_FLUSH)
>  			policy |= REQ_FSEQ_PREFLUSH;
> -		if (blk_rq_sectors(rq))
> -			policy |= REQ_FSEQ_DATA;
>  		if (!(fflags & REQ_FUA) && (rq->cmd_flags & REQ_FUA))
>  			policy |= REQ_FSEQ_POSTFLUSH;
>  	}
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/

