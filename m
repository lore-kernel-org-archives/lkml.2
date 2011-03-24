Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934322Ab1CXVB0 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Mar 2011 17:01:26 -0400
Received: from mx2.fusionio.com ([64.244.102.31]:58177 "EHLO mx2.fusionio.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S934098Ab1CXVBZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Mar 2011 17:01:25 -0400
X-ASG-Debug-ID: 1301000472-01de284cf8b74c0001-xx1T2L
X-Barracuda-Envelope-From: JAxboe@fusionio.com
Message-ID: <4D8BB114.2070002@fusionio.com>
Date: Thu, 24 Mar 2011 22:01:08 +0100
From: Jens Axboe <jaxboe@fusionio.com>
MIME-Version: 1.0
To: Markus Trippelsdorf <markus@trippelsdorf.de>
CC: Linus Torvalds <torvalds@linux-foundation.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Chris Mason <chris.mason@oracle.com>
Subject: Re: [GIT PULL] Core block IO bits for 2.6.39 - early Oops
References: <4D8B4A89.80608@fusionio.com> <20110324183019.GA1676@gentoo.trippels.de> <4D8B8F34.5000203@fusionio.com> <4D8B92AE.8090308@fusionio.com> <20110324185445.GB1696@gentoo.trippels.de> <4D8B9457.2020608@fusionio.com> <20110324193441.GA1723@gentoo.trippels.de> <4D8B9D2F.4010504@fusionio.com> <20110324194546.GA1741@gentoo.trippels.de> <4D8BA235.7060904@fusionio.com> <20110324200613.GA1724@gentoo.trippels.de>
X-ASG-Orig-Subj: Re: [GIT PULL] Core block IO bits for 2.6.39 - early Oops
In-Reply-To: <20110324200613.GA1724@gentoo.trippels.de>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
X-Barracuda-Connect: mail1.int.fusionio.com[10.101.1.21]
X-Barracuda-Start-Time: 1301000472
X-Barracuda-URL: http://10.101.1.181:8000/cgi-mod/mark.cgi
X-Barracuda-Spam-Score: 0.00
X-Barracuda-Spam-Status: No, SCORE=0.00 using global scores of TAG_LEVEL=1000.0 QUARANTINE_LEVEL=1000.0 KILL_LEVEL=9.0 tests=
X-Barracuda-Spam-Report: Code version 3.2, rules version 3.2.2.58864
	Rule breakdown below
	 pts rule name              description
	---- ---------------------- --------------------------------------------------
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2011-03-24 21:06, Markus Trippelsdorf wrote:
> On 2011.03.24 at 20:57 +0100, Jens Axboe wrote:
>>
>> OK, still a data point. What was the last -git kernel you used?
> 
> This one was the last and gave me no problems:
> 
> commit b81a618dcd3ea99de292dbe624f41ca68f464376
> Merge: 2f284c8 a9712bc
> Author: Linus Torvalds <torvalds@linux-foundation.org>
> Date:   Wed Mar 23 20:51:42 2011 -0700
> 
>     Merge branch 'for-linus' of git://git.kernel.org/pub/scm/linux/kernel/git/viro/vfs-2.6

Puzzling... Poking at straws here so far. Does this make any difference
whatsoever?

diff --git a/fs/xfs/linux-2.6/xfs_buf.c b/fs/xfs/linux-2.6/xfs_buf.c
index c05324d..580966f 100644
--- a/fs/xfs/linux-2.6/xfs_buf.c
+++ b/fs/xfs/linux-2.6/xfs_buf.c
@@ -989,8 +989,6 @@ xfs_buf_lock(
 
 	if (atomic_read(&bp->b_pin_count) && (bp->b_flags & XBF_STALE))
 		xfs_log_force(bp->b_target->bt_mount, 0);
-	if (atomic_read(&bp->b_io_remaining))
-		blk_flush_plug(current);
 	down(&bp->b_sema);
 	XB_SET_OWNER(bp);
 
@@ -1439,8 +1437,6 @@ xfs_buf_iowait(
 {
 	trace_xfs_buf_iowait(bp, _RET_IP_);
 
-	if (atomic_read(&bp->b_io_remaining))
-		blk_flush_plug(current);
 	wait_for_completion(&bp->b_iowait);
 
 	trace_xfs_buf_iowait_done(bp, _RET_IP_);
@@ -1943,9 +1939,6 @@ xfsbufd(
 			xfs_bdstrat_cb(bp);
 			count++;
 		}
-		if (count)
-			blk_flush_plug(current);
-
 	} while (!kthread_should_stop());
 
 	return 0;
@@ -1992,7 +1985,6 @@ xfs_flush_buftarg(
 
 	if (wait) {
 		/* Expedite and wait for IO to complete. */
-		blk_flush_plug(current);
 		while (!list_empty(&wait_list)) {
 			bp = list_first_entry(&wait_list, struct xfs_buf, b_list);
 

-- 
Jens Axboe

