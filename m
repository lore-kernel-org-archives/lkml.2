Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754778Ab1CVTyO (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Mar 2011 15:54:14 -0400
Received: from mx1.fusionio.com ([64.244.102.30]:38122 "EHLO mx1.fusionio.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753341Ab1CVTyM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Mar 2011 15:54:12 -0400
X-ASG-Debug-ID: 1300823651-03d6a54f60bc680001-xx1T2L
X-Barracuda-Envelope-From: JAxboe@fusionio.com
Message-ID: <4D88FE5E.1010204@fusionio.com>
Date: Tue, 22 Mar 2011 20:54:06 +0100
From: Jens Axboe <jaxboe@fusionio.com>
MIME-Version: 1.0
To: Christoph Hellwig <hch@infradead.org>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: merging discard request in the block layer
References: <20110322194755.GA20122@infradead.org>
X-ASG-Orig-Subj: Re: merging discard request in the block layer
In-Reply-To: <20110322194755.GA20122@infradead.org>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
X-Barracuda-Connect: mail1.int.fusionio.com[10.101.1.21]
X-Barracuda-Start-Time: 1300823651
X-Barracuda-URL: http://10.101.1.180:8000/cgi-mod/mark.cgi
X-Barracuda-Spam-Score: 0.00
X-Barracuda-Spam-Status: No, SCORE=0.00 using per-user scores of TAG_LEVEL=1000.0 QUARANTINE_LEVEL=1000.0 KILL_LEVEL=9.0 tests=
X-Barracuda-Spam-Report: Code version 3.2, rules version 3.2.2.58667
	Rule breakdown below
	 pts rule name              description
	---- ---------------------- --------------------------------------------------
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2011-03-22 20:47, Christoph Hellwig wrote:
> It seems the current block layer wil happily try to merge discard
> requests that were split because they are at the max that bi_size
> can hold together again.  At least that's what the
> 
> 	blk: request botched

That would seem to indicate a bug in the merging logic instead.

> make me believe when testing XFS code that allows multiple
> asynchronous discard request, unlike the current blkdev_issue_discard
> which always waits for one before starting the next.
> 
> I tried this little sniplet to prevent it:
> 
> Index: xfs/block/blk-merge.c
> ===================================================================
> --- xfs.orig/block/blk-merge.c	2011-03-22 13:07:24.733857580 +0100
> +++ xfs/block/blk-merge.c	2011-03-22 13:08:17.448856577 +0100
> @@ -373,7 +373,7 @@ static int attempt_merge(struct request_
>  	/*
>  	 * Don't merge file system requests and discard requests
>  	 */
> -	if ((req->cmd_flags & REQ_DISCARD) != (next->cmd_flags & REQ_DISCARD))
> +	if ((req->cmd_flags & REQ_DISCARD) || (next->cmd_flags & REQ_DISCARD))
>  		return 0;
>  
>  	/*

That's not going to be enough, you want to disable the bio to request
merging of discards as well in elevator.c:elv_rq_merge_ok(). Does
that then fix it?


-- 
Jens Axboe

