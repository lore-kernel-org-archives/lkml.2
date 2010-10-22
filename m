Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756395Ab0JVMAi (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Oct 2010 08:00:38 -0400
Received: from mgw-sa02.nokia.com ([147.243.1.48]:30010 "EHLO
	mgw-sa02.nokia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754468Ab0JVL5t (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Oct 2010 07:57:49 -0400
From: Samu Onkalo <samu.p.onkalo@nokia.com>
To: eric.piel@tremplin-utc.net, khali@linux-fr.org, guenter.roeck@ericsson.com,
        jic23@cam.ac.uk
Cc: lm-sensors@lm-sensors.org, linux-i2c@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH 00/12] lis3 accelerator feature update
Date: Fri, 22 Oct 2010 14:57:22 +0300
Message-Id: <1287748654-2626-1-git-send-email-samu.p.onkalo@nokia.com>
X-Mailer: git-send-email 1.6.0.4
X-Nokia-AV: Clean
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Changes are tested only with I2C interface using 8bit sensor since I don't
have other possibilities. Some features are not enabled
by default since I can't test them with all possible configurations.
Platform data contains field which controls new features.

Description about the changes:

0001: pm_runtime support
Add support for pm_runtime framework for lis3 core driver and lis3-i2c
interface code. hp_accel and spi should not be affected by the changes.
When either input device or freefall device is opened, chip is powered up.
When a sysfs entry is accessed, chip is powered up and scheduled power down
is requested to happen within 5 seconds.

0002: regulator control
Regulator frame work support added. Regulators are controlled based on
pm_runtime state transitions. Chip register context is stored at power down
and restored at power up. Regulators are controlled only when I2C interface is
used since the implementation requires pm_runtime support.
Regulator control is disabled by default. It can be enabled via platform data.

0003: Cleanup interrupt handling
Interrupt control is cleaned up little bit. The need for threaded interrupt
is controlled by the input layer open / close function. In the interrupt,
only one check is needed instead of several one.
Platform information is copied to lis3_dev structure to shorten access
in interrupt code.
Interrupt handling for the WU blocks doesn't check interrupt source anymore.
It is not necessary since interrupt handler is called only when WU unit causes
an interrupt.

0004: Update coordinates at polled device open
It is possible to use input interface purely under threshold interrupt control
by setting polling interval to 0. In that case, it may take a long time
when coordinates are updated after the input device open. Applications can see
totally outdated information. Coordinates are now refreshed at the device open.

0005: Power on corrections
We have faced sometimes situation where lis3 powerup fails somehow. BOOT
bit is set at device init to force boot sequence. This way lis3 recovers
from the failed boot.

0006: restore axis enabled bits
Data ready interrupts are enabled at init (reset default value). They
have been removed if the module is unloaded and loaded back.

0007: New parameters to platform data
Add some missing parameters to 8bit chip platform data.
Chip interrupt generation features can now be controlled better.
Chip default sampling rate can be controlled via platform data.
It is also possible to configure interrupts at both rising and falling edges.
With some fancy interrupt configuration, this gives fresh coordinates
at the beginning and end of the acceleration event.

0008: Adjust fuzziness for 8 bit device
Set lower default fuzziness for 8bit device. Original value was from 12bit
device which is much more sensitive than the 8 bit device.

0009: use block read to access data registers
If enabled in platform data and supported by the I2C controller block
read is used for accessing the coordinate data.

0010: Enhance lis3 selftest with IRQ line test
Selftest is enhanced to test also IRQ lines in 8bit device.
This is done by enabling data_ready interrupt during selftest and
calculating number of received interrupts during the test.

0011: Short explanations of platform data fields 
Short explanations in kernel doc format

0012: Release resources is case of failure
I2C interface driver was not releasing HW resources if the probe failed.
That made re-attempt to always fail.

Samu Onkalo (12):
  hwmon: lis3: pm_runtime support
  hwmon: lis3: regulator control
  hwmon: lis3: Cleanup interrupt handling
  hwmon: lis3: Update coordinates at polled device open
  hwmon: lis3: Power on corrections
  hwmon: lis3: restore axis enabled bits
  hwmon: lis3: New parameters to platform data
  hwmon: lis3: Adjust fuzziness for 8 bit device
  hwmon: lis3: use block read to access data registers
  hwmon: lis3: Enhance lis3 selftest with IRQ line test
  hwmon: lis3: Short explanations of platform data fields
  hwmon: lis3: Release resources is case of failure

 drivers/hwmon/lis3lv02d.c     |  304 ++++++++++++++++++++++++++++++++++------
 drivers/hwmon/lis3lv02d.h     |   18 +++
 drivers/hwmon/lis3lv02d_i2c.c |  127 +++++++++++++++--
 drivers/hwmon/lis3lv02d_spi.c |    2 +-
 include/linux/lis3lv02d.h     |   50 +++++++-
 5 files changed, 439 insertions(+), 62 deletions(-)

