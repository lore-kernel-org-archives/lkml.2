Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933140Ab1KGS0S (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Nov 2011 13:26:18 -0500
Received: from 95-31-19-74.broadband.corbina.ru ([95.31.19.74]:59843 "EHLO
	dnet.ilyx.ru" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755817Ab1KGS0R (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Nov 2011 13:26:17 -0500
Message-ID: <4EB822C7.6070200@ilyx.ru>
Date: Mon, 07 Nov 2011 22:26:15 +0400
From: Ilya Zykov <ilya@ilyx.ru>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.16) Gecko/20110929 Iceape/2.0.11
MIME-Version: 1.0
To: Alan Cox <alan@linux.intel.com>
CC: Greg Kroah-Hartman <gregkh@suse.de>, linux-kernel@vger.kernel.org
Subject: Re: PROBLEM: Race condition in tty buffer's function flush_to_ldisc().
References: <4EB7BD9A.7070600@ilyx.ru>	<20111107115802.23201d45@bob.linux.org.uk>	<4EB7CCFF.5090304@ilyx.ru>	<20111107130643.07e84fca@bob.linux.org.uk>	<4EB7E0C6.7050909@ilyx.ru> <20111107145005.68ca1050@bob.linux.org.uk>
In-Reply-To: <20111107145005.68ca1050@bob.linux.org.uk>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Alan Cox wrote:

>> Of course I know about tty_buffer_flush(), it only read TTY_FLUSHING,
>> it can't change TTY_FLUSHING, if flush_to_ldisc() single threaded,
>> we can change TTY_FLUSHING only in one place in one time(in
>> flush_to_ldisc()), therefor we can use only "set_bit(TTY_FLUSHING,
>> &tty->flags)" without test.
> 
> Yes.. if you can pin down why in your testing you see the other case
> sometimes being true.
> 
> Alan
>  

Nested call flush_to_ldisc() happened on different CPU only. It happens because
one side pty call "schedule_work(&tty->buf.work)" on one CPU from "tty_flip_buffer_push()",
the other side call "schedule_work(&tty->buf.work)" from n_tty's layer from "n_tty_set_room()"
on different CPU. It also can happen in interrupt if interrupt handle on 
different CPU. Schedule_work() schedule work on CPU which was called(IMHO).

For testing I use in xterminal: cat big_file
and flush_to_ldisc() with this patch:

diff -uprN -X ../../../dontdiff a/drivers/tty/tty_buffer.c c/drivers/tty/tty_buffer.c
--- a/drivers/tty/tty_buffer.c	2011-11-07 14:45:27.000000000 +0400
+++ c/drivers/tty/tty_buffer.c	2011-11-07 21:48:49.000000000 +0400
@@ -405,13 +405,14 @@ static void flush_to_ldisc(struct work_s
 		container_of(work, struct tty_struct, buf.work);
 	unsigned long 	flags;
 	struct tty_ldisc *disc;
+	static int mthread;
 
 	disc = tty_ldisc_ref(tty);
 	if (disc == NULL)	/*  !TTY_LDISC */
 		return;
 
 	spin_lock_irqsave(&tty->buf.lock, flags);
-
+	mthread = 0;
 	if (!test_and_set_bit(TTY_FLUSHING, &tty->flags)) {
 		struct tty_buffer *head;
 		while ((head = tty->buf.head) != NULL) {
@@ -445,6 +446,12 @@ static void flush_to_ldisc(struct work_s
 			spin_lock_irqsave(&tty->buf.lock, flags);
 		}
 		clear_bit(TTY_FLUSHING, &tty->flags);
+	} else {
+		mthread = 1;
+		printk(KERN_WARNING "Tty %s FLUSHING CPU %d.\n", tty->name, percpu_read(cpu_number));
+	}
+	if (mthread) {
+		printk(KERN_WARNING "Tty %s FLUSHING multithreaded CPU %d.\n", tty->name, percpu_read(cpu_number));
 	}
 
 	/* We may have a deferred request to flush the input buffer,

And get in my syslog:

Nov  7 21:34:13 serh kernel: [   76.323848] Tty ptm0 FLUSHING CPU 0.
Nov  7 21:34:13 serh kernel: [   76.323850] Tty ptm0 FLUSHING multithreaded CPU 0.
Nov  7 21:34:13 serh kernel: [   76.323856] Tty ptm0 FLUSHING CPU 0.
Nov  7 21:34:13 serh kernel: [   76.323857] Tty ptm0 FLUSHING multithreaded CPU 0.
Nov  7 21:34:13 serh kernel: [   76.323861] Tty ptm0 FLUSHING multithreaded CPU 1.
Nov  7 21:34:13 serh kernel: [   76.336022] Tty ptm0 FLUSHING CPU 0.
Nov  7 21:34:13 serh kernel: [   76.336024] Tty ptm0 FLUSHING multithreaded CPU 0.
Nov  7 21:34:13 serh kernel: [   76.336030] Tty ptm0 FLUSHING multithreaded CPU 1.
Nov  7 21:34:13 serh kernel: [   76.353134] Tty ptm0 FLUSHING CPU 0.
Nov  7 21:34:13 serh kernel: [   76.353136] Tty ptm0 FLUSHING multithreaded CPU 0.
Nov  7 21:34:13 serh kernel: [   76.353143] Tty ptm0 FLUSHING CPU 0.
Nov  7 21:34:13 serh kernel: [   76.353145] Tty ptm0 FLUSHING multithreaded CPU 0.
Nov  7 21:34:13 serh kernel: [   76.353148] Tty ptm0 FLUSHING multithreaded CPU 1.
......
......
