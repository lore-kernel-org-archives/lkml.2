Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754837Ab1HWI4G (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Aug 2011 04:56:06 -0400
Received: from mail-vx0-f174.google.com ([209.85.220.174]:52780 "EHLO
	mail-vx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754345Ab1HWI4D convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Aug 2011 04:56:03 -0400
MIME-Version: 1.0
In-Reply-To: <CANejiEWadFK9GdXSwKgzNoj1Da_4QTUidTp-6FGkBtZwhbKvfw@mail.gmail.com>
References: <1313768318-7960-1-git-send-email-maxim.patlasov@gmail.com>
	<1313768318-7960-2-git-send-email-maxim.patlasov@gmail.com>
	<CANejiEWadFK9GdXSwKgzNoj1Da_4QTUidTp-6FGkBtZwhbKvfw@mail.gmail.com>
Date: Tue, 23 Aug 2011 12:56:02 +0400
Message-ID: <CA+X1aCRSADrUB+YVJ9j5u+VgGn=8fKw7A1eVVzPtODg+hK-B-w@mail.gmail.com>
Subject: Re: [PATCH 1/1] CFQ: fix handling 'deep' cfqq
From: Maxim Patlasov <maxim.patlasov@gmail.com>
To: Shaohua Li <shli@kernel.org>
Cc: axboe@kernel.dk, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

>> An aproach suggested here avoids performance degradations mentioned above.
>> With this patch applied, the performance on slow hdd is the same as it used
>> to be before 8e1ac6655104bc6e1e79d67e2df88cc8fa9b6e07, and, on fast h/w-raids,
>> it's roughly the same as for noop scheduler or CFQ with slice_idle=0.
> idle is a usual cause of cfq performance issue. did you have test in
> disk without NCQ?

Yes, on the node with "slow hdd" CFQ detected it as hw_tag=0. I
explained what I tested in cover message (subj: [PATCH 0/1] CFQ:
fixing performance issues).

> And did you test if this will hurt the performance of Vivek's original problem?

No. What's Vivek's original problem?

> snip
>> +       if (cfq_cfqq_deep_early(cfqq) && cfqq->n_dispatched >= CFQQ_DEEP_THR) {
>> +               if (cfqq->first_dispatch == jiffies)
>> +                       cfqd->cfq_disk_looks_fast++;
>> +               else
>> +                       cfqd->cfq_disk_looks_slow++;
>> +
> jiffies is too coarse here. A disk with NCQ can dispatch several
> requests within one jiffy.

If a disk with NCQ dispatches four requests in raw within one jiffy
regularly, the patch I suggested will claim it as "fast enough". It
should be beneficial to disable idling for deep&seeky cfqq in this
case, imho. Anyway, existing code:

>	/*
>	 * This is a deep seek queue, but the device is much faster than
>	 * the queue can deliver, don't idle
>	 **/
>	if (CFQQ_SEEKY(cfqq) && cfq_cfqq_idle_window(cfqq) &&
>	    (cfq_cfqq_slice_new(cfqq) ||
>	    (cfqq->slice_end - jiffies > jiffies - cfqq->slice_start))) {
>		cfq_clear_cfqq_deep(cfqq);
>		cfq_clear_cfqq_idle_window(cfqq);
>	}
>

would surely disable idling in this case. So, the patch I suggested
doesn't make things worse (as compared with existing implementation).

Thanks,
Maxim
