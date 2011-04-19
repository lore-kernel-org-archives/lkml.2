Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753616Ab1DSRGX (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Apr 2011 13:06:23 -0400
Received: from mx2.fusionio.com ([64.244.102.31]:47956 "EHLO mx2.fusionio.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752569Ab1DSRGW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Apr 2011 13:06:22 -0400
X-ASG-Debug-ID: 1303232779-01de284cf8168240001-xx1T2L
X-Barracuda-Envelope-From: JAxboe@fusionio.com
Message-ID: <4DADC10A.3060809@fusionio.com>
Date: Tue, 19 Apr 2011 19:06:18 +0200
From: Jens Axboe <jaxboe@fusionio.com>
MIME-Version: 1.0
To: Christoph Hellwig <hch@infradead.org>
CC: Bart Van Assche <bvanassche@acm.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        "Rafael J. Wysocki" <rjw@sisk.pl>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Kernel Testers List <kernel-testers@vger.kernel.org>,
        Maciej Rutecki <maciej.rutecki@gmail.com>,
        Florian Mickler <florian@mickler.org>, Neil Brown <neilb@suse.de>
Subject: Re: [Bug #32982] Kernel locks up a few minutes after boot
References: <OlQwC5HnRsN.A.ULB.OGuqNB@chimera> <_H4l51C1wXN.A.yDC.yGuqNB@chimera> <BANLkTimeaHwBiZoz=isCM=qtBxoxaBqDUw@mail.gmail.com> <BANLkTi=1jO73DXDTD50bVpU82qphVKmRCw@mail.gmail.com> <4DAC2429.5000105@fusionio.com> <BANLkTinCWWYqnksxevho9TN3u6ZC_Rjzwg@mail.gmail.com> <4DAC82E6.3020809@fusionio.com> <BANLkTimaekpwmK+z=ePE+XSP6GUteidwfw@mail.gmail.com> <4DAD5156.2050300@fusionio.com> <4DAD6EF2.5070405@fusionio.com> <20110419164815.GA30616@infradead.org>
X-ASG-Orig-Subj: Re: [Bug #32982] Kernel locks up a few minutes after boot
In-Reply-To: <20110419164815.GA30616@infradead.org>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
X-Barracuda-Connect: mail1.int.fusionio.com[10.101.1.21]
X-Barracuda-Start-Time: 1303232779
X-Barracuda-URL: http://10.101.1.181:8000/cgi-mod/mark.cgi
X-Barracuda-Spam-Score: 0.00
X-Barracuda-Spam-Status: No, SCORE=0.00 using global scores of TAG_LEVEL=1000.0 QUARANTINE_LEVEL=1000.0 KILL_LEVEL=9.0 tests=
X-Barracuda-Spam-Report: Code version 3.2, rules version 3.2.2.61328
	Rule breakdown below
	 pts rule name              description
	---- ---------------------- --------------------------------------------------
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2011-04-19 18:48, Christoph Hellwig wrote:
>> +		blk_run_queue_async(sdev->request_queue);
> 
> This doesn't even have to be async except when scsi drivers call
> cmd->scsi_done directly.  It seems like if this always went through the
> softirq (or kblockd) we could still run it in context for the others.

Exactly. I'll pass an 'optimize' patch past James.

>> +	/*
>> +	 * This get/put dance makes no sense
>> +	 */
>>  	get_device(&rport->dev);
>> -
>> -	spin_lock_irqsave(rport->rqst_q->queue_lock, flags);
>> -	flagset = test_bit(QUEUE_FLAG_REENTER, &rport->rqst_q->queue_flags) &&
>> -		  !test_bit(QUEUE_FLAG_REENTER, &rport->rqst_q->queue_flags);
>> -	if (flagset)
>> -		queue_flag_set(QUEUE_FLAG_REENTER, rport->rqst_q);
>> -	__blk_run_queue(rport->rqst_q);
>> -	if (flagset)
>> -		queue_flag_clear(QUEUE_FLAG_REENTER, rport->rqst_q);
>> -	spin_unlock_irqrestore(rport->rqst_q->queue_lock, flags);
>> -
>> +	blk_run_queue_async(rport->rqst_q);
> 
> And the QUEUE_FLAG_REENTER mess here never made sense either as it
> tested for a bit beeing set and not set at the same time.  So this one
> actually should be able to be replaced by a plain blk_run_queue.

Yep, it's completely broken as-is.

-- 
Jens Axboe

