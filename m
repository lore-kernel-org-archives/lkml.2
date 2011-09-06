Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753502Ab1IFBDk (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Sep 2011 21:03:40 -0400
Received: from mail-qy0-f174.google.com ([209.85.216.174]:62187 "EHLO
	mail-qy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752736Ab1IFBDf convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Sep 2011 21:03:35 -0400
MIME-Version: 1.0
In-Reply-To: <CA+X1aCSMb9CTpoHWv=UiMg-mHkB2ssmKRACtbDofWG=QSxXOdg@mail.gmail.com>
References: <1313768318-7960-1-git-send-email-maxim.patlasov@gmail.com>
	<1313768318-7960-2-git-send-email-maxim.patlasov@gmail.com>
	<CANejiEWadFK9GdXSwKgzNoj1Da_4QTUidTp-6FGkBtZwhbKvfw@mail.gmail.com>
	<CA+X1aCRSADrUB+YVJ9j5u+VgGn=8fKw7A1eVVzPtODg+hK-B-w@mail.gmail.com>
	<CANejiEX=S8tyPDhAjm84+9xBNt08Q0mjWHjqh-kFqL4H1ME-RA@mail.gmail.com>
	<CA+X1aCSMb9CTpoHWv=UiMg-mHkB2ssmKRACtbDofWG=QSxXOdg@mail.gmail.com>
Date: Tue, 6 Sep 2011 09:03:34 +0800
X-Google-Sender-Auth: zaeDwYvL7DGsy7yyI-1fEQgBpJA
Message-ID: <CANejiEV7UfEHEMwokKwE+Pwqn_HRUT0_9wHakhOYj8r0roGYuw@mail.gmail.com>
Subject: Re: [PATCH 1/1] CFQ: fix handling 'deep' cfqq
From: Shaohua Li <shli@kernel.org>
To: Maxim Patlasov <maxim.patlasov@gmail.com>
Cc: axboe@kernel.dk, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2011/8/31 Maxim Patlasov <maxim.patlasov@gmail.com>:
> Shaohua,
>
> Sorry for not getting back to you for long. See please inline comments below.
>
>> but the cfq_disk_looks_slow isn't updated if the queue doesn't have 4 requests
>> or doesn't dispatch > 4 requests, so you always have CFQD_DISK_LOOKS_FAST()
>> return true if the first slice gets it to true. And if the queue does
>> dispatch > 4 requests in one jiffy, only cfq_disk_looks_fast is updated,
>> CFQD_DISK_LOOKS_FAST returns true too. I don't understand when
>> CFQD_DISK_LOOKS_FAST can be false.
>
> The patch essentially gathers events when cfqq experiences deep queue
> early and dispatches 4 requests in one dispatch round. As soon as such
> an event detected, we're drop inside outer 'if' clause:
>
>> +     if (cfq_cfqq_deep_early(cfqq) && cfqq->n_dispatched >= CFQQ_DEEP_THR) {
>> +             if (cfqq->first_dispatch == jiffies)
>> +                     cfqd->cfq_disk_looks_fast++;
>> +             else
>> +                     cfqd->cfq_disk_looks_slow++;
>> +
>> +             cfqq->first_dispatch = 0;
>> +             cfqq->n_dispatched = 0;
>> +             cfq_clear_cfqq_deep_early(cfqq);
>> +             cfqd->cfq_disk_last_updated = jiffies;
>> +     }
>
> and either increment disk_looks_fast or disk_looks_slow.
>
> If the queue doesn't have 4 requests, cfqq is not 'deep' - no events
> to gather. Neither disk_looks_fast nor disk_looks_slow is updated.
>
> If the queue doesn't dispatch 4 requests in a raw, the event will be
> discarded, and again, neither disk_looks_fast nor disk_looks_slow is
> updated.
>
> If the queue does dispatch > 4 requests in one jiffy, only
> cfq_disk_looks_fast is updated - that's right. But if the queue
> dispatches first 4 requests in *more* than one jiffy,
> cfq_disk_looks_slow is updated.
So the case is in first round, the queue dispatch > 4 requests in one jiffy,
looks_fast gets updated. Later, if the queue always only dispatch < 4 requests
or has < 4 requests queued, no looks_fast/looks_slow gets updated till
10*HZ later.
CFQD_DISK_LOOKS_FAST() always returns true in the period. is this sane?

Thanks,
Shaohua
