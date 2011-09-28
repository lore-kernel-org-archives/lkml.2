Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755255Ab1I1Wdl (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Sep 2011 18:33:41 -0400
Received: from www.linutronix.de ([62.245.132.108]:36003 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755178Ab1I1Wdj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Sep 2011 18:33:39 -0400
Date: Thu, 29 Sep 2011 00:33:35 +0200 (CEST)
From: Thomas Gleixner <tglx@linutronix.de>
To: Dimitri Sivanich <sivanich@sgi.com>
cc: LKML <linux-kernel@vger.kernel.org>, Peter Zijlstra <peterz@infradead.org>,
        John Stultz <johnstul@us.ibm.com>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: mmtimer - posixtimer abuse
Message-ID: <alpine.LFD.2.02.1109290031300.2711@ionos>
User-Agent: Alpine 2.02 (LFD 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Dimitry,

I'm fixing a few odds and ends in the posix timer code and stumbled
over drivers/char/mmtimer.c

I have seen lots of crap in my life, but this stuff is broken beyond
everything.

1) Locking issues vs. timer delivery, i.e. posix_timer_event() is
   called w/o tmr->it_lock held.

2) overrun accounting for periodic timers is completely broken

3) timer_del() can deadlock

4) clock_set()/clock_get()

   What the hell are you doing with that offset? It's just used in
   those functions - of course unlocked and has nothing to with the
   actual expiry time of the timers.

   What's the point of this ????

5) The whole notion of struct mmtimer is completely ass backwards

   Instead of adding the proper fields to k_itimer.it.mmtimer you
   allocate a separate data structure with separate lifetime rules.

   That makes you do a reverse lookup dance through the rbtree in
   timer_del() and random points where you actually kfree that extra
   thing.

6) As far as I can tell from looking at timer_set() this clock tries
   to resemble CLOCK_REALTIME, but lacks any checks of timers expiring
   early. It does not handle when the clock was set 

7) Periodic timers are subject to random rounding errors and the
   MMTIMER_INTERVAL_RETRY_INCREMENT_DEFAULT hackery which was
   introduced in commit dcade5ed16 just proves how broken that whole
   thing is. Why the hell does it not rearm the timers in the signal
   delivery path and do proper forwarding instead of using disgusting
   heuristics to work around the rounding problems.
   
7) Why is that using a tasklet? 

8) Why does it expire each timer seperately instead of looking at all
   expired timers and bulk expire them.

Is actually anyone using this trainwreck or can we simply kill it
entirely?

If it's used and wants to be supported, then please explain what the
properties of CLOCK_SGI should be, so we can fix that mess.

Please do that fast, as I don't see any reason to hold off
improvements and fixes for the core and the sane users for something
which should have never been merged in the first place.

Thanks,

	tglx
