Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756347Ab0IXDv0 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Sep 2010 23:51:26 -0400
Received: from ironport2-out.teksavvy.com ([206.248.154.183]:47426 "EHLO
	ironport2-out.pppoe.ca" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1755560Ab0IXDvY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Sep 2010 23:51:24 -0400
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: ArsBAIq8m0xLd/sX/2dsb2JhbAAHgxSRJYcyvDmSL4Eigy1zBA
X-IronPort-AV: E=Sophos;i="4.57,227,1283745600"; 
   d="scan'208";a="76603096"
Message-ID: <4C9C2039.8050903@teksavvy.com>
Date: Thu, 23 Sep 2010 23:51:21 -0400
From: Mark Lord <kernel@teksavvy.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.2.9) Gecko/20100915 Thunderbird/3.1.4
MIME-Version: 1.0
To: dgilbert@interlog.com
CC: Linux Kernel <linux-kernel@vger.kernel.org>,
        IDE/ATA development list <linux-ide@vger.kernel.org>,
        linux-scsi <linux-scsi@vger.kernel.org>, Jens Axboe <axboe@kernel.dk>,
        Joel Becker <joel.becker@oracle.com>
Subject: Re: "blocked for more than 120 secs" --> a valid situation, how to
 prevent?
References: <4C9BE5A8.1090002@teksavvy.com> <4C9BEB49.2060208@interlog.com> <4C9C129E.5050504@teksavvy.com>
In-Reply-To: <4C9C129E.5050504@teksavvy.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10-09-23 10:53 PM, Mark Lord wrote:
> On 10-09-23 08:05 PM, Douglas Gilbert wrote:
>> Mark,
>> If you issued the SG_IO ioctl with a timeout of at
>> least 66 minutes (expressed in milliseconds) then
>> it looks like ata_scsi_queuecmd() has a problem.
> ..
>
> Mmm.. more like blk_execute_rq() perhaps.
> That's where the wait_for_completion(&wait) call is at.
>
> Perhaps I should change it to wait in smaller increments,
> so that the lockup detection doesn't trigger on it..
..

This patch (below) seems to work.

Does this look kosher enough for me to roll it up
as a proper patch submission?   Jens?  Joel?

The problem, again, is that the hangcheck timer fires
inappropriately during very long SG_IO commands,
such as --security-erase operations which take minutes/hours to complete.

Thanks

--- old/block/blk-exec.c	2010-08-26 19:47:12.000000000 -0400
+++ linux/block/blk-exec.c	2010-09-23 23:41:47.478826002 -0400
@@ -95,7 +95,8 @@
  
  	rq->end_io_data = &wait;
  	blk_execute_rq_nowait(q, bd_disk, rq, at_head, blk_end_sync_rq);
-	wait_for_completion(&wait);
+	while (!wait_for_completion_timeout(&wait, (sysctl_hung_task_timeout_secs >> 1) * HZ))
+		; /* periodic wakeup prevents "hung_task" warnings */
  
  	if (rq->errors)
  		err = -EIO;
