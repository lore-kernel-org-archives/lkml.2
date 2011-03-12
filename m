Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753565Ab1CLBnN (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Mar 2011 20:43:13 -0500
Received: from smtp-out.google.com ([216.239.44.51]:59282 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752851Ab1CLBnL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Mar 2011 20:43:11 -0500
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=subject:to:from:cc:date:message-id:user-agent:
	mime-version:content-type:content-transfer-encoding:x-system-of-record;
	b=HzzrZQhtZA1YnAMH/v365N8rb3XUWsHDfvDozZE/6kpy+IWOsnq4bnKiv0+XhXSCK
	HM09E9caNGliepQIuajNg==
Subject: [PATCH v2 00/12] google firmware support
To: Greg KH <greg@kroah.com>, Matt Domsch <Matt_Domsch@dell.com>,
        Alan Cox <alan@lxorguk.ukuu.org.uk>
From: Mike Waychison <mikew@google.com>
Cc: Duncan Laurie <dlaurie@google.com>, Aaron Durbin <adurbin@google.com>,
        x86@kernel.org, linux-kernel@vger.kernel.org,
        Tim Hockin <thockin@google.com>, San Mehat <san@google.com>
Date: Fri, 11 Mar 2011 17:42:55 -0800
Message-ID: <20110312014254.6133.43079.stgit@mike.mtv.corp.google.com>
User-Agent: StGit/0.15
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patchset applies to v2.6.38-rc8.

The following series implements some support for interfaces exposed by
google's servers' firmware.  Unlike the previous send-out, it only
includes two of the three drivers as I'm not yet finished fixing the
"bootlog" driver from the last send-out (and I've discovered more
"undocumented" firmware functionality that I'd rather unravel before
sending out again).

In order to address various concerns had with the previous patchset,
I've changed the user ABI significantly:

Instead of messing with the dmesg log_buf ring-buffer, we now expose
firmware logs via /sys/firmware/log.

As well, instead of using a ioctl interface the gsmi driver, I've
changed it completely to use sysfs instead (rooted at
/sys/firmware/gsmi).  gsmi provides access to EFI variables through a
means other than through the EFI runtime services page, so I've reused
the bulk of the code exposed by the efivars driver.  To make this work,
I had to refactor a bit of the efivars driver.  The only user-visible
change here is that the module will successfully load now even if you
aren't on an EFI system (which is much more consistent with other
drivers anyway).

I'd like to have these small drivers included as they are required for
proper use of the kernel in our infrastructure.  They may not seem like
much, but a lot of our health automation as well as our human debugging
efforts are dependent on the functionality herein.  Getting these in the
public Linux tree would bring us closer to being able to easily test
kernels as they are released.

Thanks,

Patchset summary
================

Patches [1 through 6] refactor the 'efivars' module to let the "gsmi"
driver in patch [11] re-use the variable functionality.

Patch [7] documents existing 'efivars' functionality that has been
present in the tree since 2004.

Patches [8] and [9] add sanity checking for accessing the EBDA.

Patch [10] introduces CONFIG_GOOGLE_FIRMWARE that is disabled by
default and which gates Google-specific drivers.

Patch [11] adds the "gsmi" driver that we use to make calls into our
firmware.

Patch [12] adds the "memconsole" driver that finds the firmware's logs
and exposes them on /sys/firmware/log.

Diffstat
========
 Documentation/ABI/stable/sysfs-firmware-efi-vars |   75 +
 Documentation/ABI/testing/sysfs-firmware-gsmi    |   58 +
 Documentation/ABI/testing/sysfs-firmware-log     |    7 
 arch/x86/include/asm/bios_ebda.h                 |   28 
 drivers/firmware/Kconfig                         |    2 
 drivers/firmware/Makefile                        |    2 
 drivers/firmware/efivars.c                       |  343 +++++---
 drivers/firmware/google/Kconfig                  |   33 
 drivers/firmware/google/Makefile                 |    3 
 drivers/firmware/google/gsmi.c                   |  927 +++++++++++++++++++++++
 drivers/firmware/google/memconsole.c             |  151 +++
 include/linux/efi.h                              |   37 
 12 files changed, 1526 insertions(+), 140 deletions(-)

ChangeLog:
==========
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
