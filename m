Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756152Ab2JRUb4 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Oct 2012 16:31:56 -0400
Received: from mail.pripojeni.net ([178.22.112.14]:56793 "EHLO
	smtp.pripojeni.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754441Ab2JRU0y (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Oct 2012 16:26:54 -0400
From: Jiri Slaby <jslaby@suse.cz>
To: gregkh@linuxfoundation.org
Cc: alan@linux.intel.com, linux-kernel@vger.kernel.org, jirislaby@gmail.com
Subject: [PATCH 00/21] TTY buffer in tty_port and other stuff
Date: Thu, 18 Oct 2012 22:26:26 +0200
Message-Id: <1350592007-9216-1-git-send-email-jslaby@suse.cz>
X-Mailer: git-send-email 1.7.12.3
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

this is the fifth series of patches which finally move tty buffers
from tty_struct (present from open to close/hangup) to tty_port
(present as long as the device). This allows us to get rid of the tty
refcounting in the interrupt service routines and other hot paths
after we are done. This is because we do not need to handle races
among ISRs, timers, hangups and others, because tty_port lives as long
as an interrupt/timer tick may occur. Unlike tty_struct.

This set also cleans up devpts handling a bit. Devpts used to play
with tty->driver_data which was a bit ugly. Now devpts returns a node
which we store to driver_data and pass it back when we need devpts to
kill that. As a result, we can do that in the pty code instead of an
ugly hook in tty_release.

Finally, the set moves all the n_tty private stuff from tty_struct to
its own (internal) structure. This was an intention last time ago (at
least here), but the races and undefined ldisc->open/close behavior
did not allow us to do that. Now that we have ldisc kills and waits
and bells and whistles we could finally go ahead.

As usual, standard x86 stuff was runtime-tested. The rest is only
checked to be compilation-errors free.

Jiri Slaby (21):
  TTY: devpts, don't care about TTY in devpts_get_tty
  TTY: devpts, return created inode from devpts_pty_new
  TTY: devpts, do not set driver_data
  TTY: devpts, document devpts inode operations
  TTY: move devpts kill to pty
  TTY: vt, fix paste_selection ldisc handling
  TTY: ldisc, wait for idle ldisc in release
  TTY: hci_ldisc, remove invalid check in open
  TTY: n_tty, simplify read_buf+echo_buf allocation
  TTY: n_tty, remove bogus checks
  TTY: audit, stop accessing tty->icount
  TTY: n_tty, add ldisc data to n_tty
  TTY: move ldisc data from tty_struct: simple members
  TTY: move ldisc data from tty_struct: bitmaps
  TTY: move ldisc data from tty_struct: read_* and echo_* and canon_*
    stuff
  TTY: move ldisc data from tty_struct: locks
  TTY: n_tty, propagate n_tty_data
  TTY: move TTY_FLUSH* flags to tty_port
  TTY: tty_buffer, cache pointer to tty->buf
  TTY: add port -> tty link
  TTY: move tty buffers to tty_port

 drivers/bluetooth/hci_ldisc.c |   7 +-
 drivers/tty/n_tty.c           | 752 ++++++++++++++++++++++--------------------
 drivers/tty/pty.c             |  30 +-
 drivers/tty/tty_audit.c       |  15 +-
 drivers/tty/tty_buffer.c      | 224 +++++++------
 drivers/tty/tty_io.c          |  15 +-
 drivers/tty/tty_ldisc.c       |  15 +-
 drivers/tty/tty_port.c        |   2 +
 drivers/tty/vt/selection.c    |   9 +-
 fs/devpts/inode.c             |  61 ++--
 include/linux/devpts_fs.h     |  20 +-
 include/linux/tty.h           |  44 +--
 include/linux/tty_flip.h      |   2 +-
 13 files changed, 633 insertions(+), 563 deletions(-)

-- 
1.7.12.3


