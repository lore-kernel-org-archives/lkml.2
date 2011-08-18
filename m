Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755740Ab1HRL37 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Aug 2011 07:29:59 -0400
Received: from smtp-out.google.com ([74.125.121.67]:26720 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755576Ab1HRL2S (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Aug 2011 07:28:18 -0400
From: Daniel Kurtz <djkurtz@chromium.org>
To: chase.douglas@canonical.com, dmitry.torokhov@gmail.com,
        rydberg@euromail.se
Cc: linux-input@vger.kernel.org, linux-kernel@vger.kernel.org,
        olofj@chromium.org, chris@cnpbagwell.com,
        Daniel Kurtz <djkurtz@chromium.org>
Subject: [PATCH 0/9 v4] Synaptics image sensor support
Date: Thu, 18 Aug 2011 19:27:59 +0800
Message-Id: <1313666888-18939-1-git-send-email-djkurtz@chromium.org>
X-Mailer: git-send-email 1.7.3.1
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

----
For v4:
  Patch 4 & 7:
     Per Henrik: Do not report synaptics 'w' as ABS_MT_TOUCH_MAJOR.  This has
                 the nice side affect of cleaning up slot reporting.

  Patch 6 (new):
     Per Chase: Document 'report more touches than slots' behavior.
----

This patch set (against next) is intended to add support for synaptics
"image sensor" touchpads.

Patches 1-3 clean up the current driver slightly and prepare for the image
sensor patches which follow.

Patches 4-7 add 3 finger support for image sensor touchpads.
Image sensors do not suffer from the finger tracking issues that plagued
the earlier "profile sensors", and which required the invention of "semi-mt"
(Semi-mt reports a bounding box around two fingers instead of the fingers
themselves).  Instead, the image sensors report the actual positions of two
fingers using the same "Advanced Gesture Mode".  This driver uses two MT-B slots
to report these two fingers to userspace.  In addition, it will also report
the total number of fingers using BTN_TOOL_*TAP EV_KEY events.  This behavior
is documented in the multi-touch-protocol document.

Userspace drivers should be aware that the number of fingers reported via
BTN_TOOL_*TAP can be greater than the total number MT-B slots with non-negative
track_ids.  Upon opening the device node, userspace should query the maximum
values supported ABS_MT_SLOT, and note the number of supported BTN_TOOL_*TAP
events.

Patches 7-8 add 4 and 5 finger support.
In fact, the image sensor touchpads actually track 5 fingers while reporting
just 2 finger positions.  These patches add support for properly tracking the
reported slots through 4 and 5 finger transitions, while always reporting two of
them via 2 MT-B slots.  In addition, a new event, EV_KEY/BTN_TOOL_QUINTTAP, is
added to the event subsystem to allow reporting up to 5 fingers.

These patches are similar to, and inspired by, a similar patchset recently
submitted by Derek Foreman and Daniel Stone.  However, it is not directly built
upon, nor is it compatible with, those patches.

Thanks,
Daniel


Daniel Kurtz (9):
  Input: synaptics - refactor y inversion
  Input: synaptics - refactor agm packet parsing
  Input: synaptics - refactor initialization of abs position axes
  Input: synaptics - add image sensor support
  Input: synaptics - decode AGM packet types
  Input: mt - document devices reporting more touches than slots
  Input: synaptics - process finger (<=3) transitions
  Input: add BTN_TOOL_QUINTTAP for reporting 5 fingers on touchpad
  Input: synaptics - process finger (<=5) transitions

 Documentation/input/multi-touch-protocol.txt |   14 +
 drivers/input/input-mt.c                     |    1 +
 drivers/input/mouse/synaptics.c              |  489 ++++++++++++++++++++++++--
 drivers/input/mouse/synaptics.h              |   27 ++-
 include/linux/input.h                        |    1 +
 5 files changed, 495 insertions(+), 37 deletions(-)

-- 
1.7.3.1

