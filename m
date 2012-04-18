Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753552Ab2DRNWH (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Apr 2012 09:22:07 -0400
Received: from mail-gy0-f202.google.com ([209.85.160.202]:49005 "EHLO
	mail-gy0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753079Ab2DRNWD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Apr 2012 09:22:03 -0400
From: Daniel Kurtz <djkurtz@chromium.org>
To: Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        Henrik Rydberg <rydberg@euromail.se>,
        Joonyoung Shim <jy0922.shim@samsung.com>,
        Nick Dyer <nick.dyer@itdev.co.uk>, linux-input@vger.kernel.org,
        linux-kernel@vger.kernel.org
Cc: Benson Leung <bleung@chromium.org>, Yufeng Shen <miletus@chromium.org>,
        Daniel Kurtz <djkurtz@chromium.org>
Subject: [PATCH 00/14 v3] cleanup atmel_mxt_ts
Date: Wed, 18 Apr 2012 21:21:45 +0800
Message-Id: <1334755319-21365-1-git-send-email-djkurtz@chromium.org>
X-Mailer: git-send-email 1.7.7.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patchset cleans up the atmel_mxt_ts touchscreen driver.
In particular, v3 implements the following:

1) sysfs
   a) fw_update only by root
   b) use sncprintf()
2) faster initialization
   a) read/write sets of registers using i2c block transactions
   b) fetch object descriptor table as a single i2c transaction
   c) fetch objects  as a set of i2c reads, one per object
   d) write config data as a set of i2c writes, one per object
3) faster interrupt processing & initialization times
   a) cache important values at init instead of computing in isr
   b) don't read message checksum byte (which isn't even enabled in fw)
4) more correct MT-B support
   a) send all (changed) contacts in a single EV_SYN/SYN_REPORT

v3:
  * Address Henrik's feedback:
    1) removed some more stack allocations
    2) use sncprintf() in sysfs handler

The patches were tested using an MXT224E.
They should apply cleanly to input/next.

Daniel Kurtz (14):
  Input: atmel_mxt_ts - use CONFIG_PM_SLEEP
  Input: atmel_mxt_ts - only allow root to update firmware
  Input: atmel_mxt_ts - refactor mxt_read/write_reg to take a length
  Input: atmel_mxt_ts - verify object size in mxt_write_object
  Input: atmel_mxt_ts - do not read extra (checksum) byte
  Input: atmel_mxt_ts - dump each message on just 1 line
  Input: atmel_mxt_ts - refactor mxt_object_show
  Input: atmel_mxt_ts - optimize writing of object table entries
  Input: atmel_mxt_ts - refactor get info
  Input: atmel_mxt_ts - simplify event reporting
  Input: atmel_mxt_ts - cache T9 reportid range when reading object
    table
  Input: atmel_mxt_ts - parse vector field of data packets
  Input: atmel_mxt_ts - send all MT-B slots in one input report
  Input: atmel_mxt_ts - parse T6 reports

 drivers/input/touchscreen/atmel_mxt_ts.c |  530 ++++++++++++------------------
 1 files changed, 218 insertions(+), 312 deletions(-)

-- 
1.7.7.3

