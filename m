Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755122Ab1IFPnF (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Sep 2011 11:43:05 -0400
Received: from mail-vx0-f174.google.com ([209.85.220.174]:34245 "EHLO
	mail-vx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755054Ab1IFPm5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Sep 2011 11:42:57 -0400
MIME-Version: 1.0
In-Reply-To: <CANejiEV7UfEHEMwokKwE+Pwqn_HRUT0_9wHakhOYj8r0roGYuw@mail.gmail.com>
References: <1313768318-7960-1-git-send-email-maxim.patlasov@gmail.com>
	<1313768318-7960-2-git-send-email-maxim.patlasov@gmail.com>
	<CANejiEWadFK9GdXSwKgzNoj1Da_4QTUidTp-6FGkBtZwhbKvfw@mail.gmail.com>
	<CA+X1aCRSADrUB+YVJ9j5u+VgGn=8fKw7A1eVVzPtODg+hK-B-w@mail.gmail.com>
	<CANejiEX=S8tyPDhAjm84+9xBNt08Q0mjWHjqh-kFqL4H1ME-RA@mail.gmail.com>
	<CA+X1aCSMb9CTpoHWv=UiMg-mHkB2ssmKRACtbDofWG=QSxXOdg@mail.gmail.com>
	<CANejiEV7UfEHEMwokKwE+Pwqn_HRUT0_9wHakhOYj8r0roGYuw@mail.gmail.com>
Date: Tue, 6 Sep 2011 19:42:56 +0400
Message-ID: <CA+X1aCR6Rptj_7bKf7O7TJ8a9z7AH0vXL90XAgY=+054WegsgQ@mail.gmail.com>
Subject: Re: [PATCH 1/1] CFQ: fix handling 'deep' cfqq
From: Maxim Patlasov <maxim.patlasov@gmail.com>
To: Shaohua Li <shli@kernel.org>
Cc: axboe@kernel.dk, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Shaohua,

>> If the queue does dispatch > 4 requests in one jiffy, only
>> cfq_disk_looks_fast is updated - that's right. But if the queue
>> dispatches first 4 requests in *more* than one jiffy,
>> cfq_disk_looks_slow is updated.
> So the case is in first round, the queue dispatch > 4 requests in one jiffy,
> looks_fast gets updated. Later, if the queue always only dispatch < 4 requests
> or has < 4 requests queued, no looks_fast/looks_slow gets updated till
> 10*HZ later.
> CFQD_DISK_LOOKS_FAST() always returns true in the period. is this sane?

Thanks a lot for feedback. I agree, a single accidental event should
not affect the whole system for so long. What do you think about
making positive decision only if some amount of events were gathered
recently:

#define CFQD_DISK_LOOKS_FAST(cfqd)				    \
	(cfqd->cfq_disk_looks_fast > cfqd->cfq_disk_looks_slow &&   \
	 cfqd->cfq_disk_looks_fast + cfqd->cfq_disk_looks_slow > 10)

Btw, CFQD_DISK_LOOKS_FAST() affects only idle/noidle behaviour for
seeky&deep queues. The question is which queues should be regarded as
'deep'. I tend to think that they experience deep queue quite often
and regularly. Then the chances to update looks_fast/looks_slow in
timely manner are high. At least "always ...  has < 4 requests queued"
is not the case for really 'deep' queues. As for "always only dispatch
< 4 requests", it's theoretically possible but should not happen often
for really 'deep' queues. And conversely, if a queue experienced deep
queue only once, is it good idea to regard it as 'deep' and grant
idle-window to it?

Thanks,
Maxim
