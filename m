Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756859Ab2LNSXT (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Dec 2012 13:23:19 -0500
Received: from mailout39.mail01.mtsvc.net ([216.70.64.83]:51115 "EHLO
	n12.mail01.mtsvc.net" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1756652Ab2LNSXQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Dec 2012 13:23:16 -0500
From: Peter Hurley <peter@hurleysoftware.com>
To: Alan Cox <alan@linux.intel.com>, Jiri Slaby <jslaby@suse.cz>
Cc: linux-serial@vger.kernel.org,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Ilya Zykov <ilya@ilyx.ru>, Sasha Levin <levinsasha928@gmail.com>,
        linux-kernel@vger.kernel.org, Peter Hurley <peter@hurleysoftware.com>
Subject: [PATCH v2 00/11] tty: Fix buffer work access-after-free
Date: Fri, 14 Dec 2012 13:22:39 -0500
Message-Id: <1355509370-5883-1-git-send-email-peter@hurleysoftware.com>
X-Mailer: git-send-email 1.8.0.1
X-Authenticated-User: 125194 peter@hurleysoftware.com
X-MT-ID: 8fa290c2a27252aacf65dbc4a42f3ce3735fb2a4
X-MT-INTERNAL-ID: 8fa290c2a27252aacf65dbc4a42f3ce3735fb2a4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I wasn't sure if this is something to squeeze into 3.8, so don't yell
if not. At least Sasha can apply this and re-test against trinity.

Changes in v2:

- Please review "tty: Don't flush buffer when closing ldisc".
  This patch replaces the earlier
  "tty: Don't reschedule buffer work while closing". The text of
  this commit details why not calling n_tty_flush_buffer() is the
  correct thing to do, so I won't repeat it here.

- Jiri's debug patch "tty: debug buffer work race with tty free"
  has been included (albeit a slightly different version)
  Jiri, please sign off (or point out what you'd like changed).

- The test jig has been included in the commit message for
  "tty: Don't flush buffer when closing ldisc" as Alan requested.

- Ilya Zykov was added as the Signed-off-by: for the test jig in
  that same commit message.

- Sasha Levin was added as the Reported-by: in that same patch.


This patch series addresses the causes of flush_to_ldisc accessing
the tty after freeing.

The most common cause stems from the n_tty_close() path spuriously
scheduling buffer work, when the ldisc has already been halted.
This is fixed in 'tty: Don't flush buffer when closing ldisc'

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


Peter Hurley (11):
  tty: debug buffer work race with tty free
  tty: WARN if buffer work racing with tty free
  tty: Add diagnostic for halted line discipline
  tty: Refactor n_tty_flush_buffer
  tty: Don't flush buffer when closing ldisc
  tty: Refactor wait for ldisc refs out of tty_ldisc_hangup()
  tty: Remove unnecessary re-test of ldisc ref count
  tty: Fix ldisc halt sequence on hangup
  tty: Strengthen no-subsequent-use guarantee of tty_ldisc_halt()
  tty: Remove unnecessary buffer work flush
  tty: Halt both ldiscs concurrently

 drivers/tty/n_tty.c      |  34 +++++++---
 drivers/tty/pty.c        |   3 +-
 drivers/tty/tty_buffer.c |   5 +-
 drivers/tty/tty_io.c     |   4 +-
 drivers/tty/tty_ldisc.c  | 171 +++++++++++++++++++++++++++++------------------
 include/linux/tty.h      |   1 +
 6 files changed, 139 insertions(+), 79 deletions(-)

-- 
1.8.0.1

