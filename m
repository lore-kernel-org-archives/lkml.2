Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753777Ab0DMUmO (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Apr 2010 16:42:14 -0400
Received: from [69.28.251.93] ([69.28.251.93]:56361 "EHLO b32.net"
	rhost-flags-FAIL-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1753601Ab0DMUmI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Apr 2010 16:42:08 -0400
From: Kevin Cernekee <cernekee@gmail.com>
Date: Tue, 13 Apr 2010 13:30:08 -0700
Subject: [PATCH 0/2] MTD: Move reboot notifier from UBI to cfi_cmdset_0002
Message-Id: <4ccec90e21edfa387822b2cb71c886217c48b4e3@localhost.localdomain>
To: <dwmw2@infradead.org>, <dedekind1@gmail.com>
Cc: <saeed.bishara@gmail.com>, <linux-mtd@lists.infradead.org>,
       <linux-kernel@vger.kernel.org>
User-Agent: vim 7.1
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

During the last filesystem sync prior to rebooting, UBI/UBIFS typically
schedules a flash erase operation.  It is important to ensure that this
operation completes before restarting the system, for the following
reasons:

1) Some systems do not toggle the flash reset pin upon rebooting, so if
the flash is stuck in erase/program mode the bootloader will not come
back up.  This is especially likely on NOR flash devices since the erase
time can be 1-2 seconds.

2) While UBI is able to recover gracefully from partial erasures, that
doesn't mean it is a good idea to intentionally allow them to happen on
a regular basis.  At the minimum it will cause another unnecessary
erasure when the system comes back up.

3) It's not very polite to leave the hardware in an unclean state.

A reboot notifier was previously added to UBI to handle this condition,
but it caused problems with hibernation and does not handle the general
case of "flash operation in progress during reboot."  Some background
information can be found here:

http://lists.infradead.org/pipermail/linux-mtd/2010-March/029477.html

http://lkml.org/lkml/2009/6/9/16

http://lkml.org/lkml/2010/2/12/114

http://lkml.org/lkml/2010/2/12/144

Note that the bootloader cannot even begin execution if the NOR flash is
not in read array mode.  There is only one NOR flash chip on this system
and it contains both the bootloader and the Linux filesystems.  This is
not a bug in the bootloader.  Similar problems have been seen on other
boards:

http://www.mail-archive.com/davinci-linux-open-source@linux.davincidsp.com/msg14071.html

http://www.mail-archive.com/bk-commits-head@vger.kernel.org/msg06294.html

This set of patches adds a new reboot notifier to the AMD flash driver,
then removes the UBI reboot notifier.  I have verified that the new
scheme is equally effective in solving the original problem.

