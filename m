Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757025Ab2GCSPO (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Jul 2012 14:15:14 -0400
Received: from cantor2.suse.de ([195.135.220.15]:36375 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751089Ab2GCSPM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Jul 2012 14:15:12 -0400
Date: Tue, 3 Jul 2012 20:15:06 +0200 (CEST)
From: Jiri Kosina <jkosina@suse.cz>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Calvin Walton <calvin.walton@kepstin.ca>, Andi Kleen <andi@firstfloor.org>,
        linux-kernel@vger.kernel.org, shemminger@vyatta.com
Subject: Re: long boot delays caused by 070ad7e7 floppy change
In-Reply-To: <CA+55aFwQqTAHNafGBXaoPCzVYw83OZvbG_hOYEDUxmuoMODO3Q@mail.gmail.com>
Message-ID: <alpine.LNX.2.00.1207032008350.17304@pobox.suse.cz>
References: <20120702224648.GA20361@tassilo.jf.intel.com> <CA+55aFwre6s=orjUaNKJA=51Fc1mxu_XGX80Bex4Sn-=mWPx5Q@mail.gmail.com> <1341323230.3292.10.camel@nayuki.kepstin.ca> <CA+55aFyvzz3Lp9zeA6X+QMan0iZFWq_0Xd+ff_trnP1tpn2iJQ@mail.gmail.com>
 <1341337257.2406.1.camel@nayuki.kepstin.ca> <CA+55aFzOD33eWj0FQuZ7RWmF-yYwaeNB-9J-YY+mX4mwP7VXuA@mail.gmail.com> <CA+55aFwQqTAHNafGBXaoPCzVYw83OZvbG_hOYEDUxmuoMODO3Q@mail.gmail.com>
User-Agent: Alpine 2.00 (LNX 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 3 Jul 2012, Linus Torvalds wrote:

> > It looks like the code meant for -1 to mean "regular delay"
> > (current_reqD), and -2 to mean MAXTIMEOUT. For some reason the "-1"
> > logic has gotten screwed.
> 
> So it looks like current_reqD still exists, and sets the drive to
> "current_drive". Which *should* be 0, as far as I can tell.  In fact,
> since "current_drive" is printed out by DPRINTK(), we *know* it's 0
> (it's the "0" in the "floppy0:" message).
> 
> But how the heck does it pick that bogus 20 second delay then? The -1
> should have been caught by
> 
>         if (drive == current_reqD)
>                 drive = current_drive;
> 
> and then we should have used the regular delay for drive 0.
> 
> Jiri, any ideas?

I am not seeing how this could be happening at the moment. I am also a bit 
puzzled by Andi's statement that reverting the conversion to the single wq 
is not fixing it.

Have we by any chance changed anything in wq processing during early 
bootup lately?

Calvin, Andi, could you please dump the value of UDP->timeout in 
__reschedule_timeout(), please?

diff --git a/drivers/block/floppy.c b/drivers/block/floppy.c
index cce7df3..9850120 100644
--- a/drivers/block/floppy.c
+++ b/drivers/block/floppy.c
@@ -675,8 +675,11 @@ static void __reschedule_timeout(int drive, const char *message)
 	if (drive < 0 || drive >= N_DRIVE) {
 		delay = 20UL * HZ;
 		drive = 0;
-	} else
+	} else {
+		DPRINT("__reschedule_timeout: setting timeout to %ld\n",
+				UDP->timeout);
 		delay = UDP->timeout;
+	}
 
 	queue_delayed_work(floppy_wq, &fd_timeout, delay);
 	if (UDP->flags & FD_DEBUG)

-- 
Jiri Kosina
SUSE Labs
