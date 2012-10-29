Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758850Ab2J2UCA (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Oct 2012 16:02:00 -0400
Received: from comal.ext.ti.com ([198.47.26.152]:55209 "EHLO comal.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758465Ab2J2UB6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Oct 2012 16:01:58 -0400
From: Nishanth Menon <nm@ti.com>
To: linux-pm <linux-pm@vger.kernel.org>
CC: Nishanth Menon <nm@ti.com>, Rajagopal Venkat <rajagopal.venkat@linaro.org>,
        MyungJoo Ham <myungjoo.ham@samsung.com>,
        Kyungmin Park <kyungmin.park@samsung.com>,
        "Rafael J. Wysocki" <rjw@sisk.pl>, Kevin Hilman <khilman@ti.com>,
        <linux-kernel@vger.kernel.org>
Subject: [linux-next PATCH 0/7] PM / devfreq: allow governors to be modules and switch dynamically
Date: Mon, 29 Oct 2012 15:01:41 -0500
Message-ID: <1351540908-12195-1-git-send-email-nm@ti.com>
X-Mailer: git-send-email 1.7.9.5
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The following series is based on:
linux-next                e083feb Merge branch 'acpi-next' into linux-next
from git://git.kernel.org/pub/scm/linux/kernel/git/rafael/linux-pm.git
In addition, this series depends on the following to apply cleanly:
https://patchwork.kernel.org/patch/1649621/
https://patchwork.kernel.org/patch/1663331/

This series allows the devfreq governors to be built as modules and switched
on the fly using sysfs controls (inspired by cpufreq's ability to do the same).

Tested on BeagleBoard XM(3730) with dummy driver[1]:

/sys/devices/platform/iva.0/devfreq/iva.0 # ls
available_frequencies  governor               power
available_governors    max_freq               subsystem
cur_freq               min_freq               target_freq
device                 polling_interval       uevent
/sys/devices/platform/iva.0/devfreq/iva.0 # cat available_governors 
simple_ondemand
/sys/devices/platform/iva.0/devfreq/iva.0 # modprobe governor_userspace
/sys/devices/platform/iva.0/devfreq/iva.0 # cat available_governors 
userspace simple_ondemand
/sys/devices/platform/iva.0/devfreq/iva.0 # 
/sys/devices/platform/iva.0/devfreq/iva.0 # echo -n "userspace">governor 
/sys/devices/platform/iva.0/devfreq/iva.0 # ls
available_frequencies  max_freq               target_freq
available_governors    min_freq               uevent
cur_freq               polling_interval       userspace
device                 power
governor               subsystem
/sys/devices/platform/iva.0/devfreq/iva.0 # cat governor
userspace
/sys/devices/platform/iva.0/devfreq/iva.0 # echo -n "simple_ondemand">governor 
/sys/devices/platform/iva.0/devfreq/iva.0 # cat governor
simple_ondemand
/sys/devices/platform/iva.0/devfreq/iva.0 # ls
available_frequencies  governor               power
available_governors    max_freq               subsystem
cur_freq               min_freq               target_freq
device                 polling_interval       uevent

Nishanth Menon (7):
  PM / devfreq: export update_devfreq
  PM / devfreq: provide hooks for governors to be registered
  PM / devfreq: register governors with devfreq framework
  PM / devfreq: map devfreq drivers to governor using name
  PM / devfreq: governors: add GPL module license and allow module
    build
  PM / devfreq: allow sysfs governor node to switch governor
  PM / devfreq: Add sysfs node to expose available governors

 Documentation/ABI/testing/sysfs-class-devfreq |    9 +-
 drivers/devfreq/Kconfig                       |    8 +-
 drivers/devfreq/devfreq.c                     |  249 ++++++++++++++++++++++++-
 drivers/devfreq/exynos4_bus.c                 |    2 +-
 drivers/devfreq/governor.h                    |    4 +
 drivers/devfreq/governor_performance.c        |   22 ++-
 drivers/devfreq/governor_powersave.c          |   22 ++-
 drivers/devfreq/governor_simpleondemand.c     |   22 ++-
 drivers/devfreq/governor_userspace.c          |   22 ++-
 include/linux/devfreq.h                       |   24 +--
 10 files changed, 348 insertions(+), 36 deletions(-)

Cc: Rajagopal Venkat <rajagopal.venkat@linaro.org>
Cc: MyungJoo Ham <myungjoo.ham@samsung.com>
Cc: Kyungmin Park <kyungmin.park@samsung.com>
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: Kevin Hilman <khilman@ti.com>
Cc: linux-pm@vger.kernel.org
Cc: linux-kernel@vger.kernel.org

[1] http://pastebin.pandaboard.org/index.php/view/85100576

Regards,
Nishanth Menon
-- 
1.7.9.5

