Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756746Ab0HCOM2 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Aug 2010 10:12:28 -0400
Received: from smtp.nokia.com ([192.100.105.134]:24382 "EHLO
	mgw-mx09.nokia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756585Ab0HCOM0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Aug 2010 10:12:26 -0400
Subject: Re: [PATCHv6 00/15] kill unnecessary bdi wakeups + cleanups
From: Artem Bityutskiy <dedekind1@gmail.com>
Reply-To: dedekind1@gmail.com
To: Jens Axboe <axboe@kernel.dk>
Cc: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org
In-Reply-To: <4C580B1C.3020409@kernel.dk>
References: <1280057365-10297-1-git-send-email-dedekind1@gmail.com>
	 <4C580B1C.3020409@kernel.dk>
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 03 Aug 2010 17:11:21 +0300
Message-ID: <1280844681.15689.59.camel@localhost>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.2 (2.30.2-4.fc13) 
Content-Transfer-Encoding: 8bit
X-OriginalArrivalTime: 03 Aug 2010 14:12:19.0266 (UTC) FILETIME=[E2353A20:01CB3315]
X-Nokia-AV: Clean
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2010-08-03 at 14:27 +0200, Jens Axboe wrote:
> On 2010-07-25 13:29, Artem Bityutskiy wrote:
> > Hi,
> > 
> > here is v6 of the patch series which clean-ups bdi threads and substantially
> > lessens amount of unnecessary kernel wake-ups, which is very important on
> > battery-powered devices.
> > 
> > This patch-set is also available at:
> > git://git.infradead.org/users/dedekind/misc-2.6.git flushers_v6
> 
> Thanks Artem, for sticking around long enough to get this into
> shape. I have finally merged it.
> 
> > 1. Use 'spin_lock_bh' for the 'bdi->wb_lock' (changed patch N12)
> 
> I'd rather not, question is how to avoid it. Either just wakeup the
> default thread, or punt the lock-and-check bdi->wb.task to a thread.

Jens, here are my quick thoughts, will come back to this tomorrow.

The spin_lock_bh(&bdi->wb_lock) in 'wakeup_timer_fn()' is needed:

a) to make sure the forker thread does not decide to kill the bdi
   thread at the same time, which could cause an oops on
   'wake_up_process(bdi->wb.task)'.
b) to make sure the forker thread does not decide to spawn a bdi thread
   at the same time, in which case we could lose a wake-up.

I without the "_bh" suffix lockdep complains with a warning. Cannot cite
the complained, but it is a fair warning about a possible deadlock if
the timer function interrupts the CPU while it is already holding the
spinlock, or something like that. The easiest way to address it was to
use "_bh".

The only way to avoid "_bh" I see right now is to not 'bdi->wb_lock' at
all in  'wakeup_timer_fn()'. In this case we cannot touch 'bdi->wb.task'
because it can become NULL at any point of time.

Your first suggestion ("just wakeup the default thread") will work only
if we add a new BDI_wakeup_thread or something like that. Not sure it is
worth it.

The second suggestion ("punt the lock-and-check bdi->wb.task to a
thread") is vague. "A thread" - this must be the forker thread, what
else could that be? So basically this is the same as the first
suggestion - we set a flag in 'bdi->wb.state' and wake up the forker,
which should wake up the bdi thread?

-- 
Best Regards,
Artem Bityutskiy (Артём Битюцкий)

