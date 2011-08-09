Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751867Ab1HIS3d (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Aug 2011 14:29:33 -0400
Received: from mx2.fusionio.com ([66.114.96.31]:48906 "EHLO mx2.fusionio.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750780Ab1HIS3c (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Aug 2011 14:29:32 -0400
X-ASG-Debug-ID: 1312914571-01de280c1e1336c0001-xx1T2L
X-Barracuda-Envelope-From: JAxboe@fusionio.com
Message-ID: <4E417C87.5040105@fusionio.com>
Date: Tue, 9 Aug 2011 20:29:27 +0200
From: Jens Axboe <jaxboe@fusionio.com>
MIME-Version: 1.0
To: Jeff Moyer <jmoyer@redhat.com>
CC: Tejun Heo <tj@kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [block] allow blk_flush_policy to return REQ_FSEQ_DATA independent
  of *FLUSH
References: <x49ty9qehg7.fsf@segfault.boston.devel.redhat.com>
X-ASG-Orig-Subj: Re: [block] allow blk_flush_policy to return REQ_FSEQ_DATA independent
  of *FLUSH
In-Reply-To: <x49ty9qehg7.fsf@segfault.boston.devel.redhat.com>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
X-Barracuda-Connect: mail1.int.fusionio.com[10.101.1.21]
X-Barracuda-Start-Time: 1312914571
X-Barracuda-URL: http://10.101.1.181:8000/cgi-mod/mark.cgi
X-Barracuda-Spam-Score: 0.00
X-Barracuda-Spam-Status: No, SCORE=0.00 using global scores of TAG_LEVEL=1000.0 QUARANTINE_LEVEL=1000.0 KILL_LEVEL=9.0 tests=
X-Barracuda-Spam-Report: Code version 3.2, rules version 3.2.2.71305
	Rule breakdown below
	 pts rule name              description
	---- ---------------------- --------------------------------------------------
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2011-08-09 17:24, Jeff Moyer wrote:
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

Thanks Jeff, applied.

-- 
Jens Axboe

