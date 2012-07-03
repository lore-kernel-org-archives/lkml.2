Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933414Ab2GCTmg (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Jul 2012 15:42:36 -0400
Received: from one.firstfloor.org ([213.235.205.2]:44666 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757168Ab2GCTmf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Jul 2012 15:42:35 -0400
Date: Tue, 3 Jul 2012 21:42:34 +0200
From: Andi Kleen <andi@firstfloor.org>
To: Calvin Walton <calvin.walton@kepstin.ca>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        Andi Kleen <andi@firstfloor.org>, Jiri Kosina <jkosina@suse.cz>,
        linux-kernel@vger.kernel.org, shemminger@vyatta.com
Subject: Re: long boot delays caused by 070ad7e7 floppy change
Message-ID: <20120703194234.GO11413@one.firstfloor.org>
References: <CA+55aFwre6s=orjUaNKJA=51Fc1mxu_XGX80Bex4Sn-=mWPx5Q@mail.gmail.com> <1341323230.3292.10.camel@nayuki.kepstin.ca> <CA+55aFyvzz3Lp9zeA6X+QMan0iZFWq_0Xd+ff_trnP1tpn2iJQ@mail.gmail.com> <1341337257.2406.1.camel@nayuki.kepstin.ca> <CA+55aFzOD33eWj0FQuZ7RWmF-yYwaeNB-9J-YY+mX4mwP7VXuA@mail.gmail.com> <CA+55aFwQqTAHNafGBXaoPCzVYw83OZvbG_hOYEDUxmuoMODO3Q@mail.gmail.com> <alpine.LNX.2.00.1207032008350.17304@pobox.suse.cz> <20120703185808.GM11413@one.firstfloor.org> <CA+55aFzFQiYhJcBfGD7moL3gC-ocwXJ2-kTjuNrw5hBGGbz4ag@mail.gmail.com> <1341344200.2413.4.camel@nayuki.kepstin.ca>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1341344200.2413.4.camel@nayuki.kepstin.ca>
User-Agent: Mutt/1.4.2.2i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jul 03, 2012 at 03:36:40PM -0400, Calvin Walton wrote:
> On Tue, 2012-07-03 at 12:12 -0700, Linus Torvalds wrote:
> > What happens if you add a
> > 
> >         cancel_delayed_work(&fd_timeout);
> > 
> > to before the queue_delayed_work() in __reschedule_timeout()? Does
> > that possibly make the delay really be 3 seconds?
> 
> Yes, it does...
> [    0.718571] floppy0: reschedule timeout lock fdc
> [    1.650956] Refined TSC clocksource calibration: 2698.760 MHz.
> [    1.651109] Switching to clocksource tsc
> [    3.724664] floppy0: reschedule timeout do wakeup
> [    3.724815] floppy0: no floppy controllers found
> 
> diff --git a/drivers/block/floppy.c b/drivers/block/floppy.c
> index cce7df3..c8064e4 100644
> --- a/drivers/block/floppy.c
> +++ b/drivers/block/floppy.c
> @@ -678,6 +678,8 @@ static void __reschedule_timeout(int drive, const char *message)
>  	} else
>  		delay = UDP->timeout;
>  
> +	cancel_delayed_work(&fd_timeout);
> +
>  	queue_delayed_work(floppy_wq, &fd_timeout, delay);
>  	if (UDP->flags & FD_DEBUG)
>  		DPRINT("reschedule timeout %s\n", message);
> 
> Of course, a 3 second delay at this point in boot is still a fairly big
> bit of waiting, given how fast everything else is nowadays.

Here's the patch I did for that yesterday


>From 04a4d851d1c96b6685352d9cef41b77966cc7a1e Mon Sep 17 00:00:00 2001
From: Andi Kleen <ak@linux.intel.com>
Date: Mon, 2 Jul 2012 17:07:08 -0700
Subject: [PATCH] floppy: Run floppy initialization asynchronous

floppy_init is quite slow, 3s on my test system to determine
that there is no floppy. Run it asynchronous to the other
init calls to improve boot time.

Cuts down boot time by 1s on a system of mine.

Signed-off-by: Andi Kleen <ak@linux.intel.com>

diff --git a/drivers/block/floppy.c b/drivers/block/floppy.c
index cce7df3..8b5769b 100644
--- a/drivers/block/floppy.c
+++ b/drivers/block/floppy.c
@@ -191,6 +191,7 @@ static int print_unex = 1;
 #include <linux/mutex.h>
 #include <linux/io.h>
 #include <linux/uaccess.h>
+#include <linux/async.h>
 
 /*
  * PS/2 floppies have much slower step rates than regular floppies.
@@ -4122,7 +4123,7 @@ static struct kobject *floppy_find(dev_t dev, int *part, void *data)
 	return get_disk(disks[drive]);
 }
 
-static int __init floppy_init(void)
+static int __init do_floppy_init(void)
 {
 	int i, unit, drive;
 	int err, dr;
@@ -4337,6 +4338,24 @@ out_put_disk:
 	return err;
 }
 
+#ifndef MODULE
+static __init void floppy_async_init(void *data, async_cookie_t cookie)
+{
+	do_floppy_init();
+}
+#endif
+
+static int __init floppy_init(void)
+{
+#ifdef MODULE
+	return do_floppy_init(void);
+#else
+	/* Don't hold up the bootup by the floppy initialization */
+	async_schedule(floppy_async_init, NULL);
+	return 0;
+#endif
+}
+
 static const struct io_region {
 	int offset;
 	int size;
-- 
1.7.7.6





