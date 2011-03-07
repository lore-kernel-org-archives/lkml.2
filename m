Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755582Ab1CGUNw (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Mar 2011 15:13:52 -0500
Received: from mx1.fusionio.com ([64.244.102.30]:38597 "EHLO mx1.fusionio.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752590Ab1CGUNu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Mar 2011 15:13:50 -0500
X-ASG-Debug-ID: 1299528829-03d6a54f631d290001-xx1T2L
X-Barracuda-Envelope-From: JAxboe@fusionio.com
Message-ID: <4D753C79.4020800@fusionio.com>
Date: Mon, 7 Mar 2011 21:13:45 +0100
From: Jens Axboe <jaxboe@fusionio.com>
MIME-Version: 1.0
To: Vivek Goyal <vgoyal@redhat.com>
CC: "oleg@redhat.com" <oleg@redhat.com>,
        "paulmck@linux.vnet.ibm.com" <paulmck@linux.vnet.ibm.com>,
        linux kernel mailing list <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 0/2] blk-throttle: Couple of cleanup and fixes for limit
  update code
References: <1298331770-20079-1-git-send-email-vgoyal@redhat.com> <20110307155006.GF9540@redhat.com>
X-ASG-Orig-Subj: Re: [PATCH 0/2] blk-throttle: Couple of cleanup and fixes for limit
  update code
In-Reply-To: <20110307155006.GF9540@redhat.com>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
X-Barracuda-Connect: mail1.int.fusionio.com[10.101.1.21]
X-Barracuda-Start-Time: 1299528829
X-Barracuda-URL: http://10.101.1.180:8000/cgi-mod/mark.cgi
X-Barracuda-Spam-Score: 0.00
X-Barracuda-Spam-Status: No, SCORE=0.00 using per-user scores of TAG_LEVEL=1000.0 QUARANTINE_LEVEL=1000.0 KILL_LEVEL=9.0 tests=
X-Barracuda-Spam-Report: Code version 3.2, rules version 3.2.2.57341
	Rule breakdown below
	 pts rule name              description
	---- ---------------------- --------------------------------------------------
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2011-03-07 16:50, Vivek Goyal wrote:
> On Mon, Feb 21, 2011 at 06:42:48PM -0500, Vivek Goyal wrote:
>> Hi Jens,
>>
>> Couple of throttle fixes seem to have fallen through cracks.
>>
>> https://lkml.org/lkml/2010/12/15/331
>>
>> I am reposting it for inclusion. Please let me know if you have any concerns.
>> Oleg and Paul acked the patch in the past so I am retaining their Reviewed-by:
>> lines.
>>
> 
> Hi Jens,
> 
> Can you please apply following patches for 2.6.39. These are good for fixing
> couple of race conditions in block throttle code w.r.t limit updates.
> Please let me know if you have concernes with these patches.

I have applied them now. 2/2 is a nice cleanup. But it does not apply
cleanly after the workqueue change we merged last week. I fixed it up
for you, manually applied hunk #5 and added the below diff. Please
inspect the end result. You should have rebased that patch.

Also note that you seem to have a double xchg() in there, also added
from 2/2.

diff --git a/block/blk-throttle.c b/block/blk-throttle.c
index 7a833c9..32dd3e4 100644
--- a/block/blk-throttle.c
+++ b/block/blk-throttle.c
@@ -898,7 +898,7 @@ static void throtl_update_blkio_group_common(struct throtl_data *td,
 	xchg(&tg->limits_changed, true);
 	xchg(&td->limits_changed, true);
 	/* Schedule a work now to process the limit change */
-	throtl_schedule_delayed_work(td->queue, 0);
+	throtl_schedule_delayed_work(td, 0);
 }
 
 /*

-- 
Jens Axboe

