Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752033Ab1GWItc (ORCPT <rfc822;w@1wt.eu>);
	Sat, 23 Jul 2011 04:49:32 -0400
Received: from mail-pz0-f42.google.com ([209.85.210.42]:51893 "EHLO
	mail-pz0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751814Ab1GWIt2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 23 Jul 2011 04:49:28 -0400
From: Akinobu Mita <akinobu.mita@gmail.com>
To: linux-kernel@vger.kernel.org, akpm@linux-foundation.org
Cc: Akinobu Mita <akinobu.mita@gmail.com>
Subject: [PATCH v3 0/6] notifier error injection
Date: Sat, 23 Jul 2011 17:50:54 +0900
Message-Id: <1311411060-30124-1-git-send-email-akinobu.mita@gmail.com>
X-Mailer: git-send-email 1.7.4.4
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This provides kernel modules that can be used to test the error handling
of notifier call chain failures by injecting artifical errors to the
following notifier chain callbacks.

 * CPU notifier
 * PM notifier
 * memory hotplug notifier
 * powerpc pSeries reconfig notifier

These modules create their own directory on debugfs and each of the files
in the directory represents an event which can be failed and contains the
error code.  If the notifier call chain should be failed with some events
notified, write the error code to the files.

Example: Inject CPU offline error (-1 == -EPERM)

	# cd /sys/kernel/debug/cpu-notifier-error-inject
	# echo -1 > CPU_UP_PREPARE
	# echo 0 > /sys/devices/system/cpu/cpu1/online
	bash: echo: write error: Operation not permitted

Changelog:

* v3
- rewrite to be kernel modules instead of initializing at late_initcall()s
  (it makes the diffstat look different but most code remains unchanged)
- export err_inject_notifier_block_{init,cleanup} for modules
- export pSeries_reconfig_notifier_{,un}register symbols for a module
- notifier priority can be specified as a module parameter
- add testing scripts in tools/testing/fault-injection

* v2
- "PM: Improve error code of pm_notifier_call_chain()" is now in -next
- "debugfs: add debugfs_create_int" is dropped
- put a comment in err_inject_notifier_block_init()
- only allow valid errno to be injected (-MAX_ERRNO <= errno <= 0)
- improve Kconfig help text
- make CONFIG_PM_NOTIFIER_ERROR_INJECTION visible even if PM_DEBUG is disabled
- make CONFIG_PM_NOTIFIER_ERROR_INJECTION default if PM_DEBUG is enabled

Akinobu Mita (6):
  fault-injection: notifier error injection
  cpu: rewrite cpu-notifier-error-inject module
  PM: PM notifier error injection module
  memory: memory notifier error injection module
  powerpc: pSeries reconfig notifier error injection module
  fault-injection: add notifier error injection testing scripts

 arch/powerpc/platforms/pseries/reconfig.c        |    2 +
 include/linux/notifier.h                         |   25 ++++
 kernel/notifier.c                                |   83 +++++++++++
 lib/Kconfig.debug                                |   84 +++++++++++-
 lib/Makefile                                     |    4 +
 lib/cpu-notifier-error-inject.c                  |   56 +++-----
 lib/memory-notifier-error-inject.c               |   45 ++++++
 lib/pSeries-reconfig-notifier-error-inject.c     |   48 +++++++
 lib/pm-notifier-error-inject.c                   |   46 ++++++
 tools/testing/fault-injection/cpu-notifier.sh    |  162 +++++++++++++++++++++
 tools/testing/fault-injection/memory-notifier.sh |  163 ++++++++++++++++++++++
 11 files changed, 680 insertions(+), 38 deletions(-)
 create mode 100644 lib/memory-notifier-error-inject.c
 create mode 100644 lib/pSeries-reconfig-notifier-error-inject.c
 create mode 100644 lib/pm-notifier-error-inject.c
 create mode 100755 tools/testing/fault-injection/cpu-notifier.sh
 create mode 100755 tools/testing/fault-injection/memory-notifier.sh

-- 
1.7.4.4

