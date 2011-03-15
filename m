Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754675Ab1COG7Q (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Mar 2011 02:59:16 -0400
Received: from smtp-out.google.com ([74.125.121.67]:21207 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753932Ab1COG7I (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Mar 2011 02:59:08 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=subject:to:from:cc:date:message-id:user-agent:
	mime-version:content-type:content-transfer-encoding:x-system-of-record;
	b=kyPSQdWUhnfxnI0OU98YbMS9cWkpUjYGDzv8DRTqYJ8oUG3l6rPkA/mBkMQQ4QT/A
	AwgNfRrGXDH4hF3fmtSMA==
Subject: [PATCH v3 0/5] google firmware support
To: Greg KH <greg@kroah.com>, Matt Domsch <Matt_Domsch@dell.com>,
        Alan Cox <alan@lxorguk.ukuu.org.uk>
From: Mike Waychison <mikew@google.com>
Cc: Duncan Laurie <dlaurie@google.com>, Aaron Durbin <adurbin@google.com>,
        x86@kernel.org, linux-kernel@vger.kernel.org,
        Tim Hockin <thockin@google.com>, San Mehat <san@google.com>
Date: Mon, 14 Mar 2011 23:58:39 -0700
Message-ID: <20110315065839.12047.70666.stgit@mike.mtv.corp.google.com>
User-Agent: StGit/0.15
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patchset applies to v2.6.38-rc8 with the efivars patches (1-7) from
v2 of this series already applied.  It also applies cleanly to gregkh's
driver-core-next branch.

The following series implements some support for interfaces exposed by
google's servers' firmware.  As in the previous send-out, only the gsmi
and memconsole driver are present.  I've dropped the efivars changes as
Greg has already queued them.

In order to address various concerns had with the previous patchset,
I've re-worked the drivers to declare (an admittedly simple)
dmi_device_id structure that only matches "Google, Inc." board vendor id
strings.

As well, I've fixed the gsmi driver up to be able to be built as a
module.  Both drivers also now are disabled by default in the Kconfigs.

I'd like to have these small drivers included as they are required for
proper use of the kernel in our infrastructure.  They may not seem like
much, but a lot of our health automation as well as our human debugging
efforts are dependent on the functionality herein.  Getting these in the
public Linux tree would bring us closer to being able to easily test
kernels as they are released.

Thanks,

Patchset summary
================

Patches [1] and [2] add sanity checking for accessing the EBDA.

Patch [3] introduces CONFIG_GOOGLE_FIRMWARE that is disabled by
default and which gates Google-specific drivers.

Patch [4] adds the "gsmi" driver that we use to make calls into our
firmware.

Patch [5] adds the "memconsole" driver that finds the firmware's logs
and exposes them on /sys/firmware/log.

Diffstat
========
 Documentation/ABI/testing/sysfs-firmware-gsmi |   58 +
 Documentation/ABI/testing/sysfs-firmware-log  |    7 
 arch/x86/include/asm/bios_ebda.h              |   28 
 drivers/firmware/Kconfig                      |    2 
 drivers/firmware/Makefile                     |    2 
 drivers/firmware/google/Kconfig               |   31 
 drivers/firmware/google/Makefile              |    3 
 drivers/firmware/google/gsmi.c                |  941 ++++++++++++++++++++++++++
 drivers/firmware/google/memconsole.c          |  166 ++++
 9 files changed, 1236 insertions(+), 2 deletions(-)

ChangeLog:
==========
- v3
   - Drivers now use dmi_system_id structures to identify matching DMI
     strings, and export these tables via MODULE_DEVICE_TABLE to aid
     autoloading.
   - gsmi can now be compiled as a module.
   - memconsole fixed to require matching DMI strings.
   - efivars patchset dropped from this series as it is now an assumed
     pre-requisite.
- v2
   - Efivars can now be used by other drivers.
   - Documentation added for /sys/firmware/efi/vars
   - Memory console no longer touches log_buf ring buffer.
   - The firmware log is exported to userland as /sys/firmware/log
   - Ioctls for accessing nvram variables in gsmi driver replaced with
     efivars at /sys/firmware/gsmi/vars.
   - die_notifier is used instead of adding new notifer_lists.
   - EBDA scrubbing for memconsole now checks that we aren't walking
     into 0xA0000.
   - Documentation added for /sys/firmware/log
   - Documentation added for /sys/firmware/gsmi
   - Use kernel fixed width types instead of C99 types.
- v1
   - Initial public send-out.
