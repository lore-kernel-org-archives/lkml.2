Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752685Ab1BLTjl (ORCPT <rfc822;w@1wt.eu>);
	Sat, 12 Feb 2011 14:39:41 -0500
Received: from smtp-out-246.synserver.de ([212.40.185.246]:1057 "HELO
	smtp-out-246.synserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1752521Ab1BLTjf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 12 Feb 2011 14:39:35 -0500
X-SynServer-TrustedSrc: 1
X-SynServer-AuthUser: lars@laprican.de
X-SynServer-PPID: 24377
From: Lars-Peter Clausen <lars@metafoo.de>
To: Anton Vorontsov <cbouatmailru@gmail.com>
Cc: Rodolfo Giometti <giometti@linux.it>,
        Grazvydas Ignotas <notasas@gmail.com>, linux-kernel@vger.kernel.org,
        Lars-Peter Clausen <lars@metafoo.de>
Subject: [PATCH v2 00/14] POWER: BQ27x00: New Properties, fixes, bq27000 support
Date: Sat, 12 Feb 2011 20:38:59 +0100
Message-Id: <1297539554-13957-1-git-send-email-lars@metafoo.de>
X-Mailer: git-send-email 1.7.2.3
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch series contains a few updates for the bq27x00 driver:
* Support for additional power supply properties
* Support for the bq27000 battery which is identical to the bq27200 but is
  connected through the HDQ bus.
* Adds a register cache to the driver and introduces polling the batteries state
* Minor improvements and cleanups

The last patch in this series is not specific to the bq27x00 driver but is
required for uevents to be generated properly for this driver.
The patch makes properties which return -ENODATA to be ignored when generating
uevents. Previously in such a case uevent generation would have been aborted
with an error. But since the bq27x00 return -ENODATA for the TIME_TO_FULL
property when the battery is not charging and for the TIME_TO_EMPTY property
when the battery is not discharging and at least one of them is always true
uevent generation would always fail.

This series has so far been tested with the bq27000 and the bq27200 battery,
but not with the bq27500 battery, so it would be nice if somebody with a board
containing such a battery could test the patches to make sure that there are no
regressions.

Changes since v1:
Don't cache registers for fast changing properties like VOLTAGE_NOW,
CURRENT_NOW, ENERGY_NOW and CHARGE_NOW which can be obtained by reading
only a single register.
These were ignored anyway when comparing two battery states and since
their register is not shared between different properties we gain nothing
by caching them. On the other hand it allows the property to be queried at
a higher rate then the caching time.

This series is also available at
git://git.metafoo.de/linux-2.6 bq27x00-for-upstream

Lars-Peter Clausen (10):
  bq27x00: Add type property
  bq27x00: Improve temperature property precession
  bq27x00: Return -ENODEV for properties if the battery is not present
  bq27x00: Prepare code for addition of bq27000 platform driver
  bq27x00: Add bq27000 support
  bq27X00: Cache battery registers
  bq27x00: Poll battery state
  bq27x00: Give more specific reports on battery status
  bq27x00: Cleanup bq27x00_i2c_read
  Ignore -ENODATA errors when generating a uevent

Pali Rohár (4):
  bq27x00: Fix CURRENT_NOW property
  bq27x00: Add new properties
  bq27x00: Add MODULE_DEVICE_TABLE
  bq27x00: Minor cleanups

 drivers/power/Kconfig                 |   14 +
 drivers/power/bq27x00_battery.c       |  726 +++++++++++++++++++++++++--------
 drivers/power/power_supply_sysfs.c    |    2 +-
 include/linux/power/bq27x00_battery.h |   19 +
 4 files changed, 594 insertions(+), 167 deletions(-)
 create mode 100644 include/linux/power/bq27x00_battery.h

-- 
1.7.2.3

