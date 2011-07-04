Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751753Ab1GDTrR (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Jul 2011 15:47:17 -0400
Received: from 0122700014.0.fullrate.dk ([95.166.99.235]:47249 "EHLO kernel.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751637Ab1GDTrP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Jul 2011 15:47:15 -0400
Message-ID: <4E1218C1.5030403@kernel.dk>
Date: Mon, 04 Jul 2011 21:47:13 +0200
From: Jens Axboe <axboe@kernel.dk>
MIME-Version: 1.0
To: Maxim Patlasov <maxim.patlasov@gmail.com>
CC: linux-kernel@vger.kernel.org
Subject: Re: bi_end_io() is called with lock held: bug or feature?
References: <CA+X1aCRtR8gdLj5ekUL3_gBeULEPMedjNyNreABEmoCnceFV0Q@mail.gmail.com>
In-Reply-To: <CA+X1aCRtR8gdLj5ekUL3_gBeULEPMedjNyNreABEmoCnceFV0Q@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2011-07-04 17:56, Maxim Patlasov wrote:
> Hi Jens,
> 
> While experimenting with some third-party driver, I noticed that
> sometimes (at least for empty flush requests) bi_end_io callback is
> called with IRQs locally disabled. The cause turned out to be in
> blk_end_bidi_request():
> 
>> 	spin_lock_irqsave(q->queue_lock, flags);
>> 	blk_finish_request(rq, error);
>> 	spin_unlock_irqrestore(q->queue_lock, flags);
> 
> A relevant part of stack trace is:
> 
>> bio_endio+0x18/0x30
>> dec_pending+0x172/0x2b0
>> clone_endio+0x99/0xd0
>> bio_endio+0x18/0x30
>> req_bio_endio+0x83/0xc0
>> blk_update_request+0xff/0x470
>> blk_update_bidi_request+0x22/0xa0
>> __blk_end_bidi_request+0x1c/0x40
>> __blk_end_request_all+0x1a/0x30
>> blk_flush_complete_seq+0x258/0x280
>> flush_end_io+0xe5/0x170
>> blk_finish_request+0x86/0x280
>> blk_end_bidi_request+0x4f/0x80
> 
> At first glance it looks a bit weird that in most cases bi_end_io
> callback is called w/o any locks held but under some conditions (e.g.
> completing empty REQ_FLUSH bio) - with q->queue_lock acquired. Is it a
> bug or expected behaviour?

There's generally not any guarentees as to whether bi_end_io is called
with the queue lock held (and ints disabled) or not. It largely depends
on the driver.

IOW, you cannot rely on process context. That is also why eg
bio_set_pages_dirty() is punted to a work queue.

-- 
Jens Axboe

