Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753244Ab1C2Lij (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Mar 2011 07:38:39 -0400
Received: from mx1.fusionio.com ([64.244.102.30]:47046 "EHLO mx1.fusionio.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752928Ab1C2Lii (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Mar 2011 07:38:38 -0400
X-ASG-Debug-ID: 1301398716-03d6a55d3811e30001-xx1T2L
X-Barracuda-Envelope-From: JAxboe@fusionio.com
Message-ID: <4D91C4BA.9030502@fusionio.com>
Date: Tue, 29 Mar 2011 13:38:34 +0200
From: Jens Axboe <jaxboe@fusionio.com>
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>
CC: Linus Torvalds <torvalds@linux-foundation.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>, Tejun Heo <tj@kernel.org>
Subject: Re: [sporadic crash] blk: request botched
References: <4D8E36CC.7080707@fusionio.com> <20110329111755.GA1760@elte.hu>
X-ASG-Orig-Subj: Re: [sporadic crash] blk: request botched
In-Reply-To: <20110329111755.GA1760@elte.hu>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
X-Barracuda-Connect: mail1.int.fusionio.com[10.101.1.21]
X-Barracuda-Start-Time: 1301398716
X-Barracuda-URL: http://10.101.1.180:8000/cgi-mod/mark.cgi
X-Barracuda-Spam-Score: 0.00
X-Barracuda-Spam-Status: No, SCORE=0.00 using per-user scores of TAG_LEVEL=1000.0 QUARANTINE_LEVEL=1000.0 KILL_LEVEL=9.0 tests=
X-Barracuda-Spam-Report: Code version 3.2, rules version 3.2.2.59304
	Rule breakdown below
	 pts rule name              description
	---- ---------------------- --------------------------------------------------
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2011-03-29 13:17, Ingo Molnar wrote:
> 
> FYI, i'm seeing a new block IO related boot failure. It starts by the kernel spewing:
> 
>  [   84.434778] blk: request botched
>  [   84.437546] blk: request botched
>  [   84.441532] blk: request botched
> 
> And after more dying noises, a colorful kernel crash in an apparently rarely
> excercised error handler:

I don't think it's the error handler being broken, it simply looks like
a request that is in a bad bad state thus causing the normal rq -> bio
-> bvec run through to bomb out.

So the 'request botched' is the real BUG here.

Is that part reproducible? If so, can you please try with this patch?

diff --git a/block/blk-core.c b/block/blk-core.c
index e0a0623..3045d0e 100644
--- a/block/blk-core.c
+++ b/block/blk-core.c
@@ -2163,7 +2163,8 @@ bool blk_update_request(struct request *req, int error, unsigned int nr_bytes)
 	 * size, something has gone terribly wrong.
 	 */
 	if (blk_rq_bytes(req) < blk_rq_cur_bytes(req)) {
-		printk(KERN_ERR "blk: request botched\n");
+		blk_dump_rq_flags(req, "request botched");
+		WARN_ON(1);
 		req->__data_len = blk_rq_cur_bytes(req);
 	}
 

-- 
Jens Axboe

