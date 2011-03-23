Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753606Ab1CWBEV (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Mar 2011 21:04:21 -0400
Received: from mail-iw0-f174.google.com ([209.85.214.174]:54622 "EHLO
	mail-iw0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753009Ab1CWBEP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Mar 2011 21:04:15 -0400
From: Jeff Brown <jeffbrown@android.com>
To: linux-input@vger.kernel.org
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH 0/4] input: Sizing the evdev ring buffer for MT devices and reporting overruns.
Date: Tue, 22 Mar 2011 18:04:00 -0700
Message-Id: <1300842244-42723-1-git-send-email-jeffbrown@android.com>
X-Mailer: git-send-email 1.7.0.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

In recent kernels, input device drivers can specify a hint for the number of input events per packet.  However, most drivers don't do this.  There is some code in hid/hid-input.c that attempts to choose a larger default for MT devices but it does not apply to all input devices.  In particular, it does not apply to embedded touchscreens in phones and the like.

Currently, when the evdev ring buffer overflows, all old events are dropped.  (See input/evdev.c: evdev_pass_event)

Unfortunately, the reader has no idea that this has occurred.  The next event that the reader receives will likely be in the middle of a new packet.  This can cause the reader getting confused about which fingers are down or which slots are in use.

There are also problems on SMP systems where an evdev client may end up in a degenerate case where it reads events one at a time at the same rate they are produced instead of reading the entire packet all at once when it is ready.  This causes high CPU usage, particularly when reading from MT devices.  Ideally, evdev should only wake up poll() when the packet is complete.  (Assuming all input drivers call input_sync after they are finished writing events.  Some drivers seem to be broken in this regard.)

As a point of departure for further discussion, here are four patches.

1. During input device registration, choose a default size for the buffer based on the number of slots or tracking ids that a device reports and the number of axes it has.

2. Remove a redundant hardcoded default from hid-input.c.

3. Add a new SYN_DROPPED code that is used by evdev to indicate that some input events were dropped from the ring buffer and are missing.  The client can use this event as a hint that it should reset its state or ignore all following events until the next packet begins.

4. Only wake evdev clients from poll() when an EV_SYN is enqueued, excluding SYN_MT_REPORT.

Thanks,
Jeff.
