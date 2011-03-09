Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753061Ab1CIS0v (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Mar 2011 13:26:51 -0500
Received: from mx1.fusionio.com ([64.244.102.30]:37705 "EHLO mx1.fusionio.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751883Ab1CIS0u (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Mar 2011 13:26:50 -0500
X-ASG-Debug-ID: 1299695208-03d6a54f6037740001-xx1T2L
X-Barracuda-Envelope-From: JAxboe@fusionio.com
Message-ID: <4D77C664.3080803@fusionio.com>
Date: Wed, 9 Mar 2011 19:26:44 +0100
From: Jens Axboe <jaxboe@fusionio.com>
MIME-Version: 1.0
To: Tejun Heo <tj@kernel.org>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "kay.sievers@vrfy.org" <kay.sievers@vrfy.org>,
        "hch@infradead.org" <hch@infradead.org>
Subject: Re: block: Fix oops caused by __blkdev_get() calling  disk_unblock_events()
 with invalid @disk
References: <1299662016-7721-1-git-send-email-tj@kernel.org> <4D774641.3070806@kernel.dk> <4D779396.7050905@fusionio.com> <20110309153859.GD27010@htj.dyndns.org>
X-ASG-Orig-Subj: Re: block: Fix oops caused by __blkdev_get() calling  disk_unblock_events()
 with invalid @disk
In-Reply-To: <20110309153859.GD27010@htj.dyndns.org>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
X-Barracuda-Connect: mail1.int.fusionio.com[10.101.1.21]
X-Barracuda-Start-Time: 1299695208
X-Barracuda-URL: http://10.101.1.180:8000/cgi-mod/mark.cgi
X-Barracuda-Spam-Score: 0.00
X-Barracuda-Spam-Status: No, SCORE=0.00 using per-user scores of TAG_LEVEL=1000.0 QUARANTINE_LEVEL=1000.0 KILL_LEVEL=9.0 tests=
X-Barracuda-Spam-Report: Code version 3.2, rules version 3.2.2.57526
	Rule breakdown below
	 pts rule name              description
	---- ---------------------- --------------------------------------------------
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2011-03-09 16:38, Tejun Heo wrote:
> Commit 57c966b8b2 (block: Don't check events while open is in
> progress) made __blkdev_get() block events around open calls; however,
> it used invalid @disk pointer in the following cases.
> 
> * When ->open() returns -ERESTARTSYS, disk_unblock_events() is called
>   after @disk is put.  @disk may be invalid by the time unblock is
>   called.
> 
>   This is fixed by moving references after disk_unblock_events().
> 
> * When there are multiple openers, @disk is cleared to %NULL and later
>   disk_unblock_disk() is called with %NULL @disk causing oops.
> 
>   This is fixed by moving reference putting after open success is
>   determined and not clearing @disk to %NULL.  On success, @disk is
>   valid because there is another opener holding reference to it.  On
>   failure, the references are put after disk_unblock_events() is
>   called.

Thanks, applied. A bit unfortunate to have a 100% crasher in the tree,
though. Will suck for bisects.

-- 
Jens Axboe

