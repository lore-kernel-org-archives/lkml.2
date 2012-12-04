Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751556Ab2LDHIr (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Dec 2012 02:08:47 -0500
Received: from mailout39.mail01.mtsvc.net ([216.70.64.83]:43961 "EHLO
	n12.mail01.mtsvc.net" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751212Ab2LDHIo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Dec 2012 02:08:44 -0500
From: Peter Hurley <peter@hurleysoftware.com>
To: Alan Cox <alan@linux.intel.com>, Jiri Slaby <jslaby@suse.cz>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: linux-serial@vger.kernel.org, linux-kernel@vger.kernel.org,
        Peter Hurley <peter@hurleysoftware.com>
Subject: [PATCH -next 0/9] tty: Fix buffer work access-after-free
Date: Tue,  4 Dec 2012 02:07:36 -0500
Message-Id: <1354604865-10278-1-git-send-email-peter@hurleysoftware.com>
X-Mailer: git-send-email 1.8.0
X-Authenticated-User: 125194 peter@hurleysoftware.com
X-MT-ID: 8fa290c2a27252aacf65dbc4a42f3ce3735fb2a4
X-MT-INTERNAL-ID: 8fa290c2a27252aacf65dbc4a42f3ce3735fb2a4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch series addresses the causes of flush_to_ldisc accessing
the tty after freeing.

The most common cause stems from the n_tty_close() path spuriously
scheduling buffer work, when the ldisc has already been halted.
This is fixed in 'tty: Don't reschedule buffer work while closing'

The other causes have a central theme: incorrect order-of-operations
when halting a line discipline. In general, to prevent buffer work
from being scheduled requires:
  1. Disallowing further ldisc references
  2. Waiting for all existing ldisc references to be released
  3. Cancelling existing buffer work
If the wait takes place _after_ cancellation, then new work
can be scheduled by existing holder(s) of ldisc reference(s). That's
bad.

Halting the line discipline is performed when,
 - hanging up the tty (tty_ldisc_hangup())
 - TIOCSETD ioctl (tty_set_ldisc())
 - finally closing the tty (pair) (tty_ldisc_release())

Concurrent halts are governed by the following requirements:
1. tty_ldisc_release is not concurrent with the other two and so
   does not need lock or state protection during the ldiscs halt.
2. Accesses through tty->ldisc must be protected by the ldisc_mutex.
   The wait operation checks the user count (ldisc references)
   in tty->ldisc->users.
3. tty_set_ldisc() reschedules buffer work that was pending when
   the ldiscs were halted. That must be an atomic operation in
   conjunction with re-enabling the ldisc -- which necessitates
   locking concurrent halts (tty_ldisc_release is exempt here)
4. The legacy mutex cannot be held while waiting for ldisc
   reference(s) release -or- for cancelling buffer work.
5. Because of #4, the legacy mutex must be dropped prior to or
   during the halt. Which means reacquiring after the halt. But
   to preserve lock order the ldisc_mutex must be dropped and
   reacquired after reacquiring the legacy mutex.
6. Because of #5, the ldisc state may have changed while the
   ldisc mutex was dropped.

Note: this series does not include the lock correction initially
reported on by Sebastian Andrzej Siewior <bigeasy@linutronix.de> here
https://lkml.org/lkml/2012/11/21/267 . I commented on the latest
version here https://lkml.org/lkml/2012/12/3/362

This series also does not include Jiri's debug patch here
https://lkml.org/lkml/2012/11/2/278 for identifying which itty cleanup
path is used. I think it may be helpful to include this in -next.

Peter Hurley (9):
  tty: WARN if buffer work racing with tty free
  tty: Add diagnostic for halted line discipline
  tty: Don't reschedule buffer work while closing
  tty: Refactor wait for ldisc refs out of tty_ldisc_hangup()
  tty: Remove unnecessary re-test of ldisc ref count
  tty: Fix ldisc halt sequence on hangup
  tty: Strengthen no-subsequent-use guarantee of tty_ldisc_halt()
  tty: Remove unnecessary buffer work flush
  tty: Halt both ldiscs concurrently

 drivers/tty/n_tty.c      |   8 ++-
 drivers/tty/tty_buffer.c |   3 +
 drivers/tty/tty_io.c     |   2 +
 drivers/tty/tty_ldisc.c  | 171 +++++++++++++++++++++++++++++------------------
 include/linux/tty.h      |   1 +
 5 files changed, 119 insertions(+), 66 deletions(-)

-- 
1.8.0

