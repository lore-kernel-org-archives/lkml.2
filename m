Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753430Ab1DSQsY (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Apr 2011 12:48:24 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:45846 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752223Ab1DSQsW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Apr 2011 12:48:22 -0400
Date: Tue, 19 Apr 2011 12:48:15 -0400
From: Christoph Hellwig <hch@infradead.org>
To: Jens Axboe <jaxboe@fusionio.com>
Cc: Bart Van Assche <bvanassche@acm.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        "Rafael J. Wysocki" <rjw@sisk.pl>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Kernel Testers List <kernel-testers@vger.kernel.org>,
        Maciej Rutecki <maciej.rutecki@gmail.com>,
        Florian Mickler <florian@mickler.org>, Neil Brown <neilb@suse.de>
Subject: Re: [Bug #32982] Kernel locks up a few minutes after boot
Message-ID: <20110419164815.GA30616@infradead.org>
References: <OlQwC5HnRsN.A.ULB.OGuqNB@chimera>
 <_H4l51C1wXN.A.yDC.yGuqNB@chimera>
 <BANLkTimeaHwBiZoz=isCM=qtBxoxaBqDUw@mail.gmail.com>
 <BANLkTi=1jO73DXDTD50bVpU82qphVKmRCw@mail.gmail.com>
 <4DAC2429.5000105@fusionio.com>
 <BANLkTinCWWYqnksxevho9TN3u6ZC_Rjzwg@mail.gmail.com>
 <4DAC82E6.3020809@fusionio.com>
 <BANLkTimaekpwmK+z=ePE+XSP6GUteidwfw@mail.gmail.com>
 <4DAD5156.2050300@fusionio.com>
 <4DAD6EF2.5070405@fusionio.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4DAD6EF2.5070405@fusionio.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> +		blk_run_queue_async(sdev->request_queue);

This doesn't even have to be async except when scsi drivers call
cmd->scsi_done directly.  It seems like if this always went through the
softirq (or kblockd) we could still run it in context for the others.

> +	/*
> +	 * This get/put dance makes no sense
> +	 */
>  	get_device(&rport->dev);
> -
> -	spin_lock_irqsave(rport->rqst_q->queue_lock, flags);
> -	flagset = test_bit(QUEUE_FLAG_REENTER, &rport->rqst_q->queue_flags) &&
> -		  !test_bit(QUEUE_FLAG_REENTER, &rport->rqst_q->queue_flags);
> -	if (flagset)
> -		queue_flag_set(QUEUE_FLAG_REENTER, rport->rqst_q);
> -	__blk_run_queue(rport->rqst_q);
> -	if (flagset)
> -		queue_flag_clear(QUEUE_FLAG_REENTER, rport->rqst_q);
> -	spin_unlock_irqrestore(rport->rqst_q->queue_lock, flags);
> -
> +	blk_run_queue_async(rport->rqst_q);

And the QUEUE_FLAG_REENTER mess here never made sense either as it
tested for a bit beeing set and not set at the same time.  So this one
actually should be able to be replaced by a plain blk_run_queue.

