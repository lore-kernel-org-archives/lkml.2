Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751879Ab1GTNjX (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Jul 2011 09:39:23 -0400
Received: from smtp-out.google.com ([216.239.44.51]:37514 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750994Ab1GTNjU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Jul 2011 09:39:20 -0400
From: djkurtz@chromium.org
To: dmitry.torokhov@gmail.com, rydberg@euromail.se,
        chase.douglas@canonical.com, rubini@cvml.unipv.it
Cc: linux-input@vger.kernel.org, linux-kernel@vger.kernel.org,
        derek.foreman@collabora.co.uk, daniel.stone@collabora.co.uk,
        olofj@chromium.org, Daniel Kurtz <djkurtz@chromium.org>
Subject: [PATCH 0/9 v2] Synaptics image sensor support
Date: Wed, 20 Jul 2011 21:38:57 +0800
Message-Id: <1311169146-20066-1-git-send-email-djkurtz@chromium.org>
X-Mailer: git-send-email 1.7.3.1
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Daniel Kurtz <djkurtz@chromium.org>

Hello,

This patch set (against next) is intended to add support for synaptics
"image sensor" touchpads.

Patches 1-3 clean up the current driver slightly and prepare for the image
sensor patches which follow.

Patches 4-7 add up to 3 finger support for image sensor touchpads.
Image sensors do not suffer from the finger tracking issues that plagued
the earlier "profile sensors", and which required the invention of "semi-mt"
(Semi-mt reports a bounding box around two fingers instead of the fingers
themselves).  Instead, the image sensors report the actual positions of two
fingers using the same "Advanced Gesture Mode".  This driver uses two MT-B slots
to report these two fingers to userspace.  In addition, it will also report
the total number of fingers using BTN_TOOL_*TAP EV_KEY events.
Userspace drivers should be aware that the number of fingers reported via
BTN_TOOL_*TAP can be greater than the total number MT-B slots with non-negative
track_ids.  Upon opening the device node, userspace should query the maximum
values supported ABS_MT_SLOT, and note the number of supported BTN_TOOL_*TAP
events.

Patches 8-9 adds up to 5 finger support.
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
  Input: synaptics - process finger (<=3) transitions
  Input: synaptics - improved 2->3 finger transition handling
  Input: add BTN_TOOL_QUINTTAP for reporting 5 fingers on touchpad
  Input: synaptics - process finger (<=5) transitions

 drivers/input/input-mt.c        |    1 +
 drivers/input/mouse/synaptics.c |  466 ++++++++++++++++++++++++++++++++++++---
 drivers/input/mouse/synaptics.h |   27 ++-
 include/linux/input.h           |    1 +
 4 files changed, 458 insertions(+), 37 deletions(-)

-- 
1.7.3.1

