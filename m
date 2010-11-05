Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754854Ab0KETGF (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Nov 2010 15:06:05 -0400
Received: from mail.windriver.com ([147.11.1.11]:46570 "EHLO
	mail.windriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754710Ab0KETFk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Nov 2010 15:05:40 -0400
From: Jason Wessel <jason.wessel@windriver.com>
To: stern@rowland.harvard.edu
Cc: gregkh@suse.de, linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org,
        kgdb-bugreport@lists.sourceforge.net
Subject: [RFC PATCH 0/5] usb polling / reliable usb console / kdb usb keyboards
Date: Fri,  5 Nov 2010 14:05:01 -0500
Message-Id: <1288983906-31129-1-git-send-email-jason.wessel@windriver.com>
X-Mailer: git-send-email 1.6.4.rc1
X-OriginalArrivalTime: 05 Nov 2010 19:05:14.0573 (UTC) FILETIME=[60BCBFD0:01CB7D1C]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

-- The summary --

This patch series has 5 patches.  The two from Dmitry were cooked up
at the kernel summit to once and for all fix the keyboard release
issues.  These 2 patches are included in the usb series for
completeness and fact I like to post series you could actually try.
The usb keyboard patches for kdb rely upon the new API introduced in
Dmitry's patches.

The 3 usb patches do the following:
  * Introduce a specific device usb polling API mechanism though the hcd
  * Add polling support to the generic usb serial console
  * Implement usb keyboard support for kdb with the usb polling api

-- The story --

If we jump in the time machine and go back to LPC 2009, I presented a
todo list for kernel debugging.  I really think it absolutely amazing
the amount of progress we have made for kernel debugging in the last
year.  Especially if you consider kdb was nothing more than a rough
prototype this time last year.  If I pull out the high level todo
bullets out of the 2009 presentation it looks like this:

  *(done 2.6.33) HW breakpoints work with perf/ptrace/kgdb
  *(done 2.6.34) EHCI debug port reliable printk/early_printk
  *(done 2.6.35) Early debug support for kdb & EHCI debug port
  *(done 2.6.35) Move beyond the kdb prototype and merge kdb
  *(done 2.6.35) Low level exception trap support
  *(done) Finish atomic kernel mode setting kdb integration and merge it
     ** 2.6.36 mainline atomic kms for nouveau, radeon and i915
  * Design an atomic keyboard reset for entry exit
  * Reliable usb console
  * Redesign kdb usb keyboard implementation
  * kgdboe v2
  * Displaced stepping and kprobe integration
  * kgdb for usb serial

With this patch series, only the last 3 items in the list remain.
There has been some definite progress on each of these items, but
there is no definitive time table as to when they will complete due to
the complexity of the issues involved and more over, the need to get
some other folks in the community to work on these items.

At the kernel summit 2010, Dmitry and I were able to come to a final
consensus on how to solve the keyboard key release problems related to entry
and exit from the kernel debugger.  This turned my attention to
talking to Alan Stern to try to resolve the outstanding design issues
with implementing a generic form of usb device polling.  By the time
the LPC 2010 ended we had a complete design on a sheet of paper and
several hours later a preliminary implementation.

With the kernel debug core API now well established the focus will
change a bit in the coming year and I hope that we can post a new
public todo list and the status of the kernel debugger on the kgdb/kdb
website: http://kgdb.wiki.kernel.org/

After attending the most recent tracing summit, I am encouraged by the
progress.  The goal for the 2011 time frame is to begin the journey of
integrating debugging and tracing to aid in general understanding of
the kernel as well as to speed up how quickly and easily you can root
cause a problem.

Last but not least, I want to thank all the people that submit
patches, report problems and review patches. THANK YOU!

--
The following changes since commit e99d11d19977c74b18411cdb59cdebb788237a6e:
  Paul Mundt (1):
        fs: logfs: Fix up MTD=y build.

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/jwessel/linux-2.6-kgdb.git for_rfc

Dmitry Torokhov (2):
      Input: input_reset()
      kgdboc: reset input devices (keyboards) when exiting debugger

Jason Wessel (3):
      usb-hcd: implement polling a specific usb device
      usb-serial-console: try to poll the hcd vs dropping data
      usb,keyboard,kdb: Implement HID keyboard polling

 drivers/hid/usbhid/hid-core.c   |   18 +++-
 drivers/input/input.c           |   50 +++++++---
 drivers/serial/kgdboc.c         |   74 +++++++++++++++
 drivers/usb/core/hcd.c          |   57 +++++++++++
 drivers/usb/serial/console.c    |   42 ++++++---
 include/linux/input.h           |    4 +-
 include/linux/kdb.h             |   13 +++
 include/linux/usb.h             |    5 +
 kernel/debug/kdb/kdb_keyboard.c |  195 ++++++++++++++++++++++++++++++++++++++-
 lib/Kconfig.kgdb                |    7 ++
 10 files changed, 430 insertions(+), 35 deletions(-)
