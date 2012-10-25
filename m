Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759778Ab2JYOSB (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Oct 2012 10:18:01 -0400
Received: from mail.x86-64.org ([217.9.48.20]:40933 "EHLO mail.x86-64.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759696Ab2JYORz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Oct 2012 10:17:55 -0400
From: Borislav Petkov <bp@amd64.org>
To: Tony Luck <tony.luck@intel.com>
Cc: Greg Kroah-Hartman <greg@kroah.com>,
        "Naveen N. Rao" <naveen.n.rao@linux.vnet.ibm.com>,
        LKML <linux-kernel@vger.kernel.org>, Borislav Petkov <bp@alien8.de>
Subject: [PATCH 0/5] Rework MCA configuration handling code, v2
Date: Thu, 25 Oct 2012 16:17:42 +0200
Message-Id: <1351174667-5098-1-git-send-email-bp@amd64.org>
X-Mailer: git-send-email 1.8.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Borislav Petkov <bp@alien8.de>

Third round, incorporating feedback from the last time.

Changelog:
==========

v1:
---

this is the first complete series implementing what we discussed
previously. It now uses simple bools and collects everything in a struct
mca_config which is nicely abstracted and collected in one place.

Please take a look and complain :)

v0:
---

Right,

so I did give that a try and it turned out to be a bit more involved
than I thought. Basically, I'm relying on the assumption that if I use a
u64 bitfield and pass a pointer to it, accessing it through that pointer
as a u64 value works. Actually, I have the u64 bitfield as the first
member of a struct and if I cast a pointer to that struct to u64 *, I'm
expecting to have the 64 bits of the same bitfield.

Therefore, I can toggle the bits in the mce code with mca_cfg.<bitname>.
When defining accessing them through the device attributes in sysfs, I
use a new macro DEVICE_BIT_ATTR which gets the corresponding bit number
of that same bit in the bitfield. This gives only one function which
operates on a bitfield instead of a single function per bit in the
bitfield.

For example,

mca_cfg {
	u64 dont_log_ce : 1,

is the first bit in the bitfield and I also have a MCA_CFG_DONT_LOG_CE
define which is 0, i.e. the first bit, which I use to toggle the
corresponding bit in the u64 in device_{show,store}_bit.

So I converted mce_dont_log_ce and mce_disabled (renaming it into the
more correct mca_disabled) and it seems to work.

The asm looks sane too. One other advantage is that it makes the code
much more cleaner and compact by collecting all those bool config values
in a single struct, which was my original incentive to do that.

So please take a look and let me know whether this is sane, especially
the above assumption that I can access a u64 bitfield through a u64 *
and the bits are where they're expected to be. gcc seems to do that...
and I don't see anything in the C99 standard that would object to it but
I could be overlooking something.

Thanks.

Borislav Petkov (5):
  drivers/base: Add a DEVICE_BOOL_ATTR macro
  x86, MCA: Convert dont_log_ce, banks and tolerant
  x86, MCA: Convert rip_msr, mce_bootlog, monarch_timeout
  x86, MCA: Convert the next three variables batch
  x86, MCA: Finish mca_config conversion

 arch/x86/include/asm/mce.h                |  21 ++-
 arch/x86/kernel/cpu/mcheck/mce-internal.h |   2 -
 arch/x86/kernel/cpu/mcheck/mce-severity.c |   4 +-
 arch/x86/kernel/cpu/mcheck/mce.c          | 209 +++++++++++++++---------------
 arch/x86/kernel/cpu/mcheck/mce_intel.c    |   8 +-
 arch/x86/lguest/boot.c                    |   2 +-
 drivers/base/core.c                       |  21 +++
 include/linux/device.h                    |   7 +
 8 files changed, 159 insertions(+), 115 deletions(-)

-- 
1.8.0

