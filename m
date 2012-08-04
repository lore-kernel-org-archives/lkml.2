Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1750937Ab2HDEBo (ORCPT <rfc822;w@1wt.eu>);
	Sat, 4 Aug 2012 00:01:44 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:45263 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750695Ab2HDEBn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 4 Aug 2012 00:01:43 -0400
From: Ming Lei <ming.lei@canonical.com>
To: Linus Torvalds <torvalds@linux-foundation.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>,
        Borislav Petkov <borislav.petkov@amd.com>,
        linux-kernel@vger.kernel.org
Subject: [RFC PATCH v1 00/15] firmware loader: introduce cache/uncache firmware
Date: Sat,  4 Aug 2012 12:01:15 +0800
Message-Id: <1344052890-31935-1-git-send-email-ming.lei@canonical.com>
X-Mailer: git-send-email 1.7.9.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

In [1][2], the problem below has been discussed for some time:

        device's firmware may be lost during suspend/resume
        cycle because device might be unplugged and plugged again
        or device experiences system power loss during the period.
        But in resume path, system is still not ready(process
        frozen, rootfs not usable, ...) to complete loading firmware
        from user space for devices.

The conclusion is that caching firmware during suspend/resume cycle
is capable of solving the problem.

This patchset implements cache/uncache firmware mechanism,
and apply the mechnism to cache device's firmware in kernel memory
space automatically during suspend/resume cyclye, so device can
load its firmware easily in its resume path. When resume is completed
and system is ready, the cached firmware will be removed from
kernel memory later.

The patch 15/15 is one example to apply the firmware cache mechanism on
ath9k-htc driver.

Even there are some corener cases[3] which can't be solved by the
cache approach, but as discussed in[4], the problem can be easily
fixed by a simple patch written by Linus.

This patch set is against 3.6.0-rc1-next-20120803.

[1]. http://marc.info/?t=134278790800004&r=1&w=2
[2]. http://marc.info/?t=132528956000002&r=10&w=2
[3]. http://marc.info/?l=linux-usb&m=132554118928398&w=2
[4]. http://marc.info/?l=linux-kernel&m=134323730805443&w=2  

--
V1:
	-handle vmap failure case(1/15)
	-fix a memory leak of 'firmware_buf'(5/15)
	-fix oops during failure path of requesting firmware(6/15)
	-fix vmap more than one time(6/15)
	-introduce __fw_lookup_buf to avoid code duplication(7/15)
	-fix comment of request_firmware_nowait(9/15)
	-avoid releasing lock in devres_for_each_res(11/15)
	-use new devres iterator API to create fw cache entry(12/15)
	-rename some functions and data structures(12/15)
	-some code style fixes

	Thanks for Borislav's review!

--
 drivers/base/devres.c                    |   42 ++
 drivers/base/firmware_class.c            |  764 ++++++++++++++++++++++++++----
 drivers/net/wireless/ath/ath9k/hif_usb.c |   34 +-
 drivers/net/wireless/ath/ath9k/hif_usb.h |    4 +-
 include/linux/device.h                   |    4 +
 include/linux/firmware.h                 |   15 +
 6 files changed, 747 insertions(+), 116 deletions(-)


Thanks,
--
Ming Lei


