Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752929Ab1IWXDp (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Sep 2011 19:03:45 -0400
Received: from smtp-out.google.com ([74.125.121.67]:30571 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752284Ab1IWXDo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Sep 2011 19:03:44 -0400
From: Simon Glass <sjg@chromium.org>
To: linux-kernel@vger.kernel.org
Cc: linux-arm-kernel@lists.infradead.org, Simon Glass <sjg@chromium.org>
Subject: [RFC PATCH 0/3] Add accurate boot timing to a Linux system
Date: Fri, 23 Sep 2011 16:03:15 -0700
Message-Id: <1316818998-30711-1-git-send-email-sjg@chromium.org>
X-Mailer: git-send-email 1.7.3.1
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This experimental patch set adds boot timing to a Linux system. The
timing starts with the boot loader and extends through the kernel into
user space to the completion of the boot process. The timing starts when
the system leaves reset, not later when the kernel starts.

The concept is:
- Boot loader records a timestamp for key events during its operation
- These timestamps are passed to Linux, which adds more as it boots
- These timestamps are made available to user space, where more
timestamps are added as init does its job
- Finally the whole record is collected by a user-space script run at
the end of init. This is fed back through some mechanism to monitor
boot time in the field.

The bootstage record aims to provide 20-30 timestamps ranging from reset
to login prompt (or some other definition of completion).

Current kernel timing architecture
----------------------------------
This is a note on what is currently in the kernel and what may justify
adding something new.

At present kernel support for boot timing does not extend to before
Linux was loaded. This means that boot-time regressions in the boot
loader are silently missed. Even it is possible to determine how long
the boot loader took to run without being told, this information will
lack any detail, such as how much time was taken initializing devices,
how much time to load the kernel, etc.

Within the kernel, timing information is typically written with each
printk() (for example dmesg has timing in brackets at the start of each
line). This log information can be analyzed later to look for particular
messages which are known to be printed at different stages of the
kernel boot. However, this approach is fragile, since the messages can
change or disappear altogether, and the code is in two places: kernel
creates the messages and user space tools look for them. Also there are
few such messages and the init order is not guaranteed and can change
from kernel release to release, and from one hardware platform to
another.

When the kernel boots it is difficult to obtain early boot timing.
Existing tracing tools are inited after the architecture code and not
early enough to provide full coverage of the kernel boot process.

Individual developers who are interested in boot time can instrument
their kernel with new messages, and write tools to look for them. But
these messages must be maintained in their local source tree and bloat
the logs. When a device goes into production such changes are generally
left out of the 'production build' with the result that accurate boot
timing is not done in the field even if a mechanism is made available to
report back other information.

Finally, in user space there is no kernel-blessed way to record
timestamps. One approach is to add lines to the init scripts like
'cat /proc/uptime >/tmp/login_starts'. This creates another place where
the boot timing tool must look for information.

This Patchset
-------------
This patchset aims to unify timing in one place: a simple driver which
collects pre-kernel boot timestamps, adds its own as it boots, with
calls to bootstage_mark(), then allows user space (init, etc.) to add
more with 'echo "message" >>/sys/kernel/debug/bootstage/mask'.

Finally it permits user space to access the full list of timestamps
with 'cat /sys/kernel/debug/bootstage/report', which has two columns:
the stage name and the timestamp:

	reset	0
	arch_cpu_init-AVP	258902
	arch_cpu_init-A9	263267
	arch_cpu_init-done	263312
	board_init_f-start	263314
	board_init_r-start	323671
	main_loop	573008
	usb_start	610771
	bootm_start	11685215
	start_kernel	11899970
	bootstage_start	12278316
	before_rest_init	12563688
	before_initcalls	12855611
	core_initcall	12856077
	postcore_initcall	12856742
	arch_initcall	12859536
	subsys_initcall	12927416
	fs_initcall	12944422
	device_initcall	16765564
	late_initcall	16858665
	after_basic_setup	16858673
	before_init_post	18368183
	pre-startup	21956927
	post-startup	23657468
	x-started	30091946
	chrome-exec	30511367
	login-prompt-ready	41864650
	login-prompt-visible	43850932
	boot-complete	44014786

Transfer of information from the boot loader to the kernel is just a
prototype at present. This patch set uses the device tree and works on
hardware which uses a device tree (e.g. ARM). Patches are in progress
for one boot loader (U-Boot, commonly used on ARM systems) to support
the other side of this.

An accurate timer is required to make the numbers meaningful. Many
modern platforms have a microsecond timer. This patch set uses a
function called timer_get_us() to read the timer. The implementation of
that is not included in this RFC patch set.

Also not included in this patch set is an ID number for each stage. We
have gone with a simple string since it is easier to extend and modify
across software boundaries. But the intention is that these strings (at
least within the kernel) remain unchanged over time, barring a
significant refactor of the code which emits them.

Comments
--------
At this early stage (and more spending too much time polishing) I am looking
for comments:

1. How does this approach compare with other (existing) ways of doing
this?

2. Does anyone have existing patches / ideas in this area?

3. What standard way is there of passing boot timing from a boot load to
the kernel (other than the fdt as used here)?


Da Zheng (3):
  bootstage: Add bootstages to record timing in the kernel.
  bootstage: Insert bootstage_mark to record timing for bootup.
  bootstage: Get u-boot timing from the device tree.

 arch/arm/kernel/time.c    |   29 ++++
 include/linux/bootstage.h |   19 +++
 include/linux/timer.h     |    3 +
 init/Kconfig              |    9 ++
 init/Makefile             |    1 +
 init/bootstage.c          |  313 +++++++++++++++++++++++++++++++++++++++++++++
 init/main.c               |    7 +
 kernel/timer.c            |    9 ++
 8 files changed, 390 insertions(+), 0 deletions(-)
 create mode 100644 include/linux/bootstage.h
 create mode 100644 init/bootstage.c

-- 
1.7.3.1

