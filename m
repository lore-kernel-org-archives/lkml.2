Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756497Ab1GRBO3 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 17 Jul 2011 21:14:29 -0400
Received: from mail-pv0-f174.google.com ([74.125.83.174]:63398 "EHLO
	mail-pv0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755717Ab1GRBO1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 17 Jul 2011 21:14:27 -0400
From: Akinobu Mita <akinobu.mita@gmail.com>
To: linux-kernel@vger.kernel.org, akpm@linux-foundation.org
Cc: Akinobu Mita <akinobu.mita@gmail.com>
Subject: [PATCH v2 0/5] notifier error injection
Date: Mon, 18 Jul 2011 10:16:01 +0900
Message-Id: <1310951766-3840-1-git-send-email-akinobu.mita@gmail.com>
X-Mailer: git-send-email 1.7.4.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This provides the ability to inject artifical errors to the following
notifier chain callbacks. It is useful to test the error handling of
notifier call chain failures.

 * CPU notifier
 * PM notifier
 * memory hotplug notifier
 * powerpc pSeries reconfig notifier

We already have cpu-notifier-error-inject.ko module providing such
functionality for the CPU notifier.  However, this patch set adds
common basic functions and consistent debugfs interface for them.

Each of the files in the directory represents an event which can be
failed and contains the error code.  If the notifier call chain should
be failed with some events notified, write the error code to the files.

Example: Inject CPU offline error (-1 == -EPERM)

	# cd /sys/kernel/debug/cpu-notifier-error-inject
	# echo -1 > CPU_UP_PREPARE
	# echo 0 > /sys/devices/system/cpu/cpu1/online
	bash: echo: write error: Operation not permitted

Changelog:

* v2
- "PM: Improve error code of pm_notifier_call_chain()" is now in -next
- "debugfs: add debugfs_create_int" is dropped
- put a comment in err_inject_notifier_block_init()
- only allow valid errno to be injected (-MAX_ERRNO <= errno <= 0)
- improve Kconfig help text
- make CONFIG_PM_NOTIFIER_ERROR_INJECTION visible even if PM_DEBUG is disabled
- make CONFIG_PM_NOTIFIER_ERROR_INJECTION default if PM_DEBUG is enabled

Akinobu Mita (5):
  fault-injection: notifier error injection
  cpu: CPU notifier error injection
  PM: PM notifier error injection
  memory: memory notifier error injection
  powerpc: pSeries reconfig notifier error injection

 Documentation/feature-removal-schedule.txt |    8 +++
 arch/powerpc/platforms/pseries/reconfig.c  |   31 +++++++++++
 drivers/base/memory.c                      |   29 ++++++++++
 include/linux/notifier.h                   |   25 +++++++++
 kernel/cpu.c                               |   31 +++++++++++
 kernel/notifier.c                          |   81 ++++++++++++++++++++++++++++
 kernel/power/main.c                        |   30 ++++++++++
 lib/Kconfig.debug                          |   71 ++++++++++++++++++++++++
 8 files changed, 306 insertions(+), 0 deletions(-)

-- 
1.7.4.4

