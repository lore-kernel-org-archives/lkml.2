Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753402Ab2ITRuZ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Sep 2012 13:50:25 -0400
Received: from mail-wg0-f44.google.com ([74.125.82.44]:54006 "EHLO
	mail-wg0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752192Ab2ITRuV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Sep 2012 13:50:21 -0400
From: David Herrmann <dh.herrmann@googlemail.com>
To: linux-input@vger.kernel.org
Cc: Dmitry Torokhov <dmitry.torokhov@gmail.com>, linux-kernel@vger.kernel.org,
        Bernie Thompson <bernie@plugable.com>,
        David Herrmann <dh.herrmann@googlemail.com>
Subject: [PATCH v2 0/3] input: Dynamic Minor Numbers
Date: Thu, 20 Sep 2012 19:52:00 +0200
Message-Id: <1348163523-2062-1-git-send-email-dh.herrmann@googlemail.com>
X-Mailer: git-send-email 1.7.12
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi

This is version 2 of the Dynamic Minor Numbers support for input devices.
Version 1 can be found here:
  http://thread.gmane.org/gmane.linux.kernel.input/26842

For historical reasons, each input-handler (like evdev, joydev etc.) gets 32
minor numbers assigned statically. That means, if we have more than 32 input
devices, then there will not be any /dev/input/eventX device that user-space can
use to access the device.
While 32 devices were enough for a long time, multi-seat machines currently
cannot create more than 8 seats due to this restriction (assuming 3 devices per
seat plus some static devices).

This patchset allows input-handlers to allocate dynamic minor numbers if they
run out of static numbers. Patch #1 adds the infrastructure to the input core,
patch #2 makes sure we allow enough devices so we actually have room for dynamic
minor numbers and patch #3 converts evdev to use it.

Unused static minors numbers are never used for the dynamic minor numbers pool.
So existing user-space does not break. But old user-space (not using udev) will
not be able to use the new devices.
Existing user-space with udev support will be able to use it, but the xserver
currently crashes when more than 40 devices are added (which is unrelated to
this patch).

If you want to test it, you can use this tool which creates dummy input devices
via uinput:
  https://gist.github.com/3756232

Example output for 'ls -la /dev/input':
https://gist.github.com/3755663

I fixed minor coding-style issues since version 1 and a NULL-dereference in
input_minor_alloc().

Regards
David

David Herrmann (3):
  input: add dynamic-minor allocation helpers
  input: increase INPUT_DEVICES to 512 to allow dynamic minors
  input: evdev: use dynamic-minors if running out of static minors

 drivers/input/evdev.c |  95 +++++++++++++++-------------
 drivers/input/input.c | 167 +++++++++++++++++++++++++++++++++++++++++++++++++-
 include/linux/input.h |   5 ++
 3 files changed, 222 insertions(+), 45 deletions(-)

-- 
1.7.12

