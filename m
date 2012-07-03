Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757143Ab2GCTgq (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Jul 2012 15:36:46 -0400
Received: from mail-yx0-f174.google.com ([209.85.213.174]:53214 "EHLO
	mail-yx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753980Ab2GCTgo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Jul 2012 15:36:44 -0400
Message-ID: <1341344200.2413.4.camel@nayuki.kepstin.ca>
Subject: Re: long boot delays caused by 070ad7e7 floppy change
From: Calvin Walton <calvin.walton@kepstin.ca>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Andi Kleen <andi@firstfloor.org>, Jiri Kosina <jkosina@suse.cz>,
        linux-kernel@vger.kernel.org, shemminger@vyatta.com
Date: Tue, 03 Jul 2012 15:36:40 -0400
In-Reply-To: <CA+55aFzFQiYhJcBfGD7moL3gC-ocwXJ2-kTjuNrw5hBGGbz4ag@mail.gmail.com>
References: <20120702224648.GA20361@tassilo.jf.intel.com>
	 <CA+55aFwre6s=orjUaNKJA=51Fc1mxu_XGX80Bex4Sn-=mWPx5Q@mail.gmail.com>
	 <1341323230.3292.10.camel@nayuki.kepstin.ca>
	 <CA+55aFyvzz3Lp9zeA6X+QMan0iZFWq_0Xd+ff_trnP1tpn2iJQ@mail.gmail.com>
	 <1341337257.2406.1.camel@nayuki.kepstin.ca>
	 <CA+55aFzOD33eWj0FQuZ7RWmF-yYwaeNB-9J-YY+mX4mwP7VXuA@mail.gmail.com>
	 <CA+55aFwQqTAHNafGBXaoPCzVYw83OZvbG_hOYEDUxmuoMODO3Q@mail.gmail.com>
	 <alpine.LNX.2.00.1207032008350.17304@pobox.suse.cz>
	 <20120703185808.GM11413@one.firstfloor.org>
	 <CA+55aFzFQiYhJcBfGD7moL3gC-ocwXJ2-kTjuNrw5hBGGbz4ag@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.4.3 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2012-07-03 at 12:12 -0700, Linus Torvalds wrote:
> What happens if you add a
> 
>         cancel_delayed_work(&fd_timeout);
> 
> to before the queue_delayed_work() in __reschedule_timeout()? Does
> that possibly make the delay really be 3 seconds?

Yes, it does...
[    0.718571] floppy0: reschedule timeout lock fdc
[    1.650956] Refined TSC clocksource calibration: 2698.760 MHz.
[    1.651109] Switching to clocksource tsc
[    3.724664] floppy0: reschedule timeout do wakeup
[    3.724815] floppy0: no floppy controllers found

diff --git a/drivers/block/floppy.c b/drivers/block/floppy.c
index cce7df3..c8064e4 100644
--- a/drivers/block/floppy.c
+++ b/drivers/block/floppy.c
@@ -678,6 +678,8 @@ static void __reschedule_timeout(int drive, const char *message)
 	} else
 		delay = UDP->timeout;
 
+	cancel_delayed_work(&fd_timeout);
+
 	queue_delayed_work(floppy_wq, &fd_timeout, delay);
 	if (UDP->flags & FD_DEBUG)
 		DPRINT("reschedule timeout %s\n", message);

Of course, a 3 second delay at this point in boot is still a fairly big
bit of waiting, given how fast everything else is nowadays.

-- 
Calvin Walton <calvin.walton@kepstin.ca>

