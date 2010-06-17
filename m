Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760295Ab0FQQD2 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Jun 2010 12:03:28 -0400
Received: from casper.infradead.org ([85.118.1.10]:49151 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756511Ab0FQQD1 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Jun 2010 12:03:27 -0400
Subject: [PATCH] nohz: Fix nohz ratelimit
From: Peter Zijlstra <peterz@infradead.org>
To: Brian Bloniarz <bmb@athenacr.com>
Cc: Mike Galbraith <efault@gmx.de>, Jiri Kosina <jkosina@suse.cz>,
       Chris Wedgwood <cw@f00f.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Greg KH <gregkh@suse.de>, Alan Cox <alan@lxorguk.ukuu.org.uk>,
       OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>,
       Jef Driesen <jefdriesen@telenet.be>, linux-kernel@vger.kernel.org,
       Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>
In-Reply-To: <4C1A378F.7070604@athenacr.com>
References: <AANLkTinLth4iKXAwszEEsPm_9ZDlj8HtqsiG5cdFE1cZ@mail.gmail.com>
	 <20100610181042.GA19210@puku.stupidest.org> <4C116652.8010408@athenacr.com>
	 <alpine.LRH.2.00.1006161702470.2497@twin.jikos.cz>
	 <1276701411.30669.6.camel@marge.simson.net>
	 <1276756770.8248.20.camel@marge.simson.net>
	 <1276758038.9628.1.camel@marge.simson.net>
	 <1276771844.8121.14.camel@marge.simson.net>
	 <1276781044.27822.309.camel@twins>  <4C1A378F.7070604@athenacr.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
Date: Thu, 17 Jun 2010 18:02:37 +0200
Message-ID: <1276790557.27822.516.camel@twins>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Chris Wedgwood reports that 39c0cbe (sched: Rate-limit nohz) causes a
serial console regression, unresponsiveness, and indeed it does. The
below fixes it by not skipping out when the tick has been stopped.

Reported-by: Chris Wedgwood <cw@f00f.org>
Tested-by: Brian Bloniarz <bmb@athenacr.com>
Signed-off-by: Mike Galbraith <efault@gmx.de>
Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
---
 kernel/time/tick-sched.c |    5 +----
 1 files changed, 1 insertions(+), 4 deletions(-)

diff --git a/kernel/time/tick-sched.c b/kernel/time/tick-sched.c
index 5f171f0..e0707ea 100644
--- a/kernel/time/tick-sched.c
+++ b/kernel/time/tick-sched.c
@@ -315,9 +315,6 @@ void tick_nohz_stop_sched_tick(int inidle)
 		goto end;
 	}
 
-	if (nohz_ratelimit(cpu))
-		goto end;
-
 	ts->idle_calls++;
 	/* Read jiffies and the time when jiffies were updated last */
 	do {
@@ -328,7 +325,7 @@ void tick_nohz_stop_sched_tick(int inidle)
 	} while (read_seqretry(&xtime_lock, seq));
 
 	if (rcu_needs_cpu(cpu) || printk_needs_cpu(cpu) ||
-	    arch_needs_cpu(cpu)) {
+	    arch_needs_cpu(cpu) || nohz_ratelimit(cpu)) {
 		next_jiffies = last_jiffies + 1;
 		delta_jiffies = 1;
 	} else {

