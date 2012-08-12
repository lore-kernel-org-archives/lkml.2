Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752620Ab2HLVj1 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 12 Aug 2012 17:39:27 -0400
Received: from smtprelay-b11.telenor.se ([62.127.194.20]:44537 "EHLO
	smtprelay-b11.telenor.se" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751544Ab2HLVjZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 12 Aug 2012 17:39:25 -0400
X-SENDER-IP: [85.230.170.20]
X-LISTENER: [smtp.bredband.net]
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: ApJOALghKFBV5qoUPGdsb2JhbABEhRiFI68/GQEBAQE3NIJ9IxiBAgoaAYgjtjoUkS8DmzaNBg
X-IronPort-AV: E=Sophos;i="4.77,756,1336341600"; 
   d="scan'208";a="95328046"
From: "Henrik Rydberg" <rydberg@euromail.se>
To: Dmitry Torokhov <dmitry.torokhov@gmail.com>, Jiri Kosina <jkosina@suse.cz>
Cc: linux-input@vger.kernel.org, linux-kernel@vger.kernel.org,
        Henrik Rydberg <rydberg@euromail.se>
Subject: [PATCH 00/19] Input and HID updates for 3.7
Date: Sun, 12 Aug 2012 23:42:18 +0200
Message-Id: <1344807757-2217-1-git-send-email-rydberg@euromail.se>
X-Mailer: git-send-email 1.7.11.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Dmitry, Jiri,

Here is the tentative patchset planned for 3.7. It touches both the
Input and HID subsystems, so I decided to send it to both of you at
once. How to distribute the patches can be decided later.

The gist of the set is in-kernel tracking and latency. As I started
measuring irqsoff times, I realized we did quite poorly in that
department. Consequently, some of the patches are general and
substantial speedups which ought to make everybody happy.

Patches 1-6 rearranges the input core to send packets of events
instead of one event at a time.

Patch 7 implements this in evdev.

Patches 8-11 incorporate more duplicated code into mt core, and
implements a simple - but correct - form of tracking. Earlier variants
have either been complex, approximate or slow. This one is only about
50 lines of code and fast enough to handle ten fingers in interrupt
context.

Patches 12-15 convert bcm5974 to MT-B.

Patch 16 is janitory.

Patch 17 provides a substantial latency improvement on simple key
strokes.

Patches 18-19 are for hid-multitouch, reducing memory and simplifying
the driver.

Thanks,
Henrik

Henrik Rydberg (19):
  Input: Break out MT data
  Input: Improve the events-per-packet estimate
  Input: Remove redundant packet estimates
  Input: Make sure we follow all EV_KEY events
  Input: Move autorepeat to the event-passing phase
  Input: Send events one packet at a time
  Input: evdev - Add the events() callback
  Input: MT - Add flags to input_mt_init_slots()
  Input: MT - Handle frame synchronization in core
  Input: MT - Add in-kernel tracking
  Input: MT - Add slot assignment by id
  Input: bcm5974 - Preparatory renames
  Input: bcm5974 - Drop pressure and width emulation
  Input: bcm5974 - Drop the logical dimensions
  Input: bcm5974 - Convert to MT-B
  HID: hid-multitouch: Remove misleading null test
  HID: Only dump input if someone is listening
  HID: Add an input configured notification callback
  HID: multitouch: Remove the redundant touch state

 drivers/hid/hid-core.c                   |   3 +-
 drivers/hid/hid-input.c                  |  15 +-
 drivers/hid/hid-magicmouse.c             |   4 +-
 drivers/hid/hid-multitouch.c             | 172 ++++++++----------
 drivers/input/evdev.c                    |  78 +++++---
 drivers/input/input-mt.c                 | 297 ++++++++++++++++++++++++++++---
 drivers/input/input.c                    | 252 +++++++++++++++-----------
 drivers/input/misc/uinput.c              |   2 +-
 drivers/input/mouse/alps.c               |   2 +-
 drivers/input/mouse/bcm5974.c            | 274 ++++++++++------------------
 drivers/input/mouse/elantech.c           |   4 +-
 drivers/input/mouse/sentelic.c           |   2 +-
 drivers/input/mouse/synaptics.c          |   4 +-
 drivers/input/tablet/wacom_wac.c         |   6 +-
 drivers/input/touchscreen/atmel_mxt_ts.c |   2 +-
 drivers/input/touchscreen/cyttsp_core.c  |   2 +-
 drivers/input/touchscreen/edt-ft5x06.c   |   2 +-
 drivers/input/touchscreen/egalax_ts.c    |   2 +-
 drivers/input/touchscreen/ili210x.c      |   2 +-
 drivers/input/touchscreen/mms114.c       |   2 +-
 drivers/input/touchscreen/penmount.c     |   2 +-
 drivers/input/touchscreen/wacom_w8001.c  |   2 +-
 include/linux/hid.h                      |   3 +
 include/linux/input.h                    |  35 ++--
 include/linux/input/mt.h                 |  53 +++++-
 25 files changed, 744 insertions(+), 478 deletions(-)

-- 
1.7.11.4

