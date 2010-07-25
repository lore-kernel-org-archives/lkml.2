Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752519Ab0GYTmT (ORCPT <rfc822;w@1wt.eu>);
	Sun, 25 Jul 2010 15:42:19 -0400
Received: from mx1.redhat.com ([209.132.183.28]:31326 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751884Ab0GYTmR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 25 Jul 2010 15:42:17 -0400
Date: Sun, 25 Jul 2010 15:36:19 -0400
From: Chuck Ebbert <cebbert@redhat.com>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Kernel Testers List <kernel-testers@vger.kernel.org>,
        Maciej Rutecki <maciej.rutecki@gmail.com>,
        "Ales Teska" <ales.teska@gmail.com>,
        Alan Cox <alan@lxorguk.ukuu.org.uk>
Subject: Re: [Bug #16206] PROBLEM: PPP and other serial port related
 application hangs in kernel space
Message-ID: <20100725153619.54280d71@katamari>
In-Reply-To: <PRbv8sgxY6G.A.k7F.dVYSMB@chimera>
References: <wQMMFC59mnE.A.v-E.iUYSMB@chimera>
	<PRbv8sgxY6G.A.k7F.dVYSMB@chimera>
Organization: Red Hat, Inc.
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 23 Jul 2010 14:15:51 +0200 (CEST)
"Rafael J. Wysocki" <rjw@sisk.pl> wrote:

> This message has been generated automatically as a part of a report
> of regressions introduced between 2.6.33 and 2.6.34.
> 
> The following bug entry is on the current list of known regressions
> introduced between 2.6.33 and 2.6.34.  Please verify if it still should
> be listed and let the tracking team know (either way).
> 
> 
> Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=16206
> Subject		: PROBLEM: PPP and other serial port related application hangs in kernel space
> Submitter	: Ales Teska <ales.teska@gmail.com>
> Date		: 2010-06-09 20:46 (45 days old)
> Message-ID	: <900E3B14-5B92-4A37-9581-049DB40F4D1C@gmail.com>
> References	: http://marc.info/?l=linux-kernel&m=127611640301071&w=2
> 

I think this is some kind of race in the ldisc handling code.

This patch went in 2.6.34:

http://git.kernel.org/?p=linux/kernel/git/torvalds/linux-2.6.git;a=commitdiff_plain;h=638b9648ab51c9c549ff5735d3de519ef6199df3

"tty: Fix the ldisc hangup race"

Warning message from the original report:

Line 1278 is:
        WARN_ON(!test_bit(TTY_LDISC, &tty->flags));

[ 1673.660876] ------------[ cut here ]------------
[ 1673.661471] WARNING: at drivers/char/tty_io.c:1278 tty_open+0x213/0x451()
[ 1673.689168] Pid: 1275, comm: ufoprobe_client Not tainted
2.6.34-486-exiprobes #1
[ 1673.690452] Call Trace:
[ 1673.690947]  [<c10e93af>] ? tty_open+0x213/0x451
[ 1673.691926]  [<c1018f51>] warn_slowpath_common+0x45/0x5c
[ 1673.693006]  [<c1018f75>] warn_slowpath_null+0xd/0x10
[ 1673.694293]  [<c10e93af>] tty_open+0x213/0x451

With softlockup detection enabled, there is also this trace:

[  841.121579] INFO: task pppd:1390 blocked for more than 120 seconds.
[  841.122613] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this
message.
[  841.123578] pppd          D cec53ea4     0  1390   1139 0x00000000
[  841.151250] Call Trace:
[  841.151815]  [<c1037b30>] ? trace_hardirqs_on+0xb/0xd
[  841.152755]  [<c1198bf6>] ? _raw_spin_unlock_irqrestore+0x53/0x60
[  841.153657]  [<c10f7049>] ? spin_unlock_irqrestore+0x8/0xa
[  841.154601]  [<c10f79fb>] tty_ldisc_ref_wait+0x5d/0x75
[  841.155265]  [<c102b471>] ? autoremove_wake_function+0x0/0x33
[  841.156456]  [<d0c35211>] ? serial_ioctl+0x0/0x68 [usbserial]
[  841.157913]  [<c10f3c54>] tty_ioctl+0x6d1/0x731

I put the full traces into the bug report.
