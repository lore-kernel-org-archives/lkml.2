Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754941Ab1HWCoJ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Aug 2011 22:44:09 -0400
Received: from mail-qy0-f174.google.com ([209.85.216.174]:57187 "EHLO
	mail-qy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754742Ab1HWCoF convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Aug 2011 22:44:05 -0400
MIME-Version: 1.0
In-Reply-To: <1313768318-7960-2-git-send-email-maxim.patlasov@gmail.com>
References: <1313768318-7960-1-git-send-email-maxim.patlasov@gmail.com>
	<1313768318-7960-2-git-send-email-maxim.patlasov@gmail.com>
Date: Tue, 23 Aug 2011 10:44:03 +0800
X-Google-Sender-Auth: 6Ota6B9h_Yyur_HR91KiDCcqcxU
Message-ID: <CANejiEWadFK9GdXSwKgzNoj1Da_4QTUidTp-6FGkBtZwhbKvfw@mail.gmail.com>
Subject: Re: [PATCH 1/1] CFQ: fix handling 'deep' cfqq
From: Shaohua Li <shli@kernel.org>
To: Maxim Patlasov <maxim.patlasov@gmail.com>
Cc: axboe@kernel.dk, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2011/8/19 Maxim Patlasov <maxim.patlasov@gmail.com>:
> The patch re-works changes introduced by commit
> 8e1ac6655104bc6e1e79d67e2df88cc8fa9b6e07 to make decision about
> idle/noidle behaviour on seeky&deep cfqq-s more precise.
>
> The problems found in that former patch:
>
> 1. "the queue delivers all requests before half its slice is used" is too
> pessimistic estimation. It can be demonstrated by aio-stress on a commodity
> server with single slow SATA hdd that the estimate provides so many false
> positives to degrade performance significantly (up to 35% as compared with
> pristine 3.1.0-rc2 w/o that patch).
>
> 2. There is a time gap between marking cfqq as 'deep' and 'idle_window' in
> cfq_update_idle_window() and clearing these bits in cfq_select_queue(). Till
> these bits are cleared there may be pretty many cfqq-s marked as 'deep' and
> 'idle_window'. This effectively disables preemption becasue CFQ usually
> allows it only between SYNC_NOIDLE_WORKLOAD cfqq-s. It can be demostrated by
> slightly modified aio-stress (adding 1 msec think-time) that this problem may
> chews up to 30% of performance on fast h/w raids (as compared with setting
> slice_idle=0 or noop scheduler).
>
> 3. It's possible that a task was preempted in the middle of dispatch round.
> Then, condition "the queue delivers all requests before half its slice is used"
> will be checked for shallow queue. In such cases CFQ will regard slow disk as
> fast.
>
> 4. It's possible that the queue at the moment of marking a task as "deep" was
> much deeper than four requests. Then the fact that the queue haven't delivered
> all requests quickly doesn't imply that the disk is slow. In such cases CFQ
> may regard fast disk as slow.
>
> An aproach suggested here avoids performance degradations mentioned above.
> With this patch applied, the performance on slow hdd is the same as it used
> to be before 8e1ac6655104bc6e1e79d67e2df88cc8fa9b6e07, and, on fast h/w-raids,
> it's roughly the same as for noop scheduler or CFQ with slice_idle=0.
idle is a usual cause of cfq performance issue. did you have test in
disk without NCQ?
And did you test if this will hurt the performance of Vivek's original problem?

snip
> +       if (cfq_cfqq_deep_early(cfqq) && cfqq->n_dispatched >= CFQQ_DEEP_THR) {
> +               if (cfqq->first_dispatch == jiffies)
> +                       cfqd->cfq_disk_looks_fast++;
> +               else
> +                       cfqd->cfq_disk_looks_slow++;
> +
jiffies is too coarse here. A disk with NCQ can dispatch several
requests within one jiffy.

Thanks,
Shaohua
