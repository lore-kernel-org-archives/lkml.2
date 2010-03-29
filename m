Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755551Ab0C2BHu (ORCPT <rfc822;w@1wt.eu>);
	Sun, 28 Mar 2010 21:07:50 -0400
Received: from one.firstfloor.org ([213.235.205.2]:36029 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755494Ab0C2BHt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 28 Mar 2010 21:07:49 -0400
To: Jiri Kosina <jkosina@suse.cz>
Cc: Arnd Bergmann <arnd@arndb.de>, Frederic Weisbecker <fweisbec@gmail.com>,
       linux-kernel@vger.kernel.org, Matthew Wilcox <matthew@wil.cx>,
       Thomas Gleixner <tglx@linutronix.de>, jblunck@suse.de,
       Alan Cox <alan@linux.intel.com>, Ingo Molnar <mingo@elte.hu>,
       gregkh@suse.de
Subject: Re: [GIT, RFC] Killing the Big Kernel Lock II
From: Andi Kleen <andi@firstfloor.org>
References: <201003242240.54907.arnd@arndb.de>
	<alpine.LRH.2.00.1003251354200.16443@twin.jikos.cz>
	<8739zk1529.fsf@basil.nowhere.org>
Date: Mon, 29 Mar 2010 03:07:44 +0200
In-Reply-To: <8739zk1529.fsf@basil.nowhere.org> (Andi Kleen's message of "Sun, 28 Mar 2010 23:58:54 +0200")
Message-ID: <87tys0yly7.fsf_-_@basil.nowhere.org>
User-Agent: Gnus/5.1008 (Gnus v5.10.8) Emacs/22.3 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Andi Kleen <andi@firstfloor.org> writes:

> Jiri Kosina <jkosina@suse.cz> writes:
>
>> On Wed, 24 Mar 2010, Arnd Bergmann wrote:
>>
>>> I've spent some time continuing the work of the people on Cc and many others
>>> to remove the big kernel lock from Linux and I now have bkl-removal branch
>>> in my git tree at git://git.kernel.org/pub/scm/linux/kernel/git/arnd/playground.git
>>> that lets me run a kernel on my quad-core machine with the only users of the BKL
>>> being mostly obscure device driver modules.
>>
>> 	config USB
>> 	        tristate "Support for Host-side USB"
>> 	        depends on USB_ARCH_HAS_HCD && BKL
>>
>> Well, that's very interesting definition of "obscure" :)
>
> From a quick grep at least EHCI doesn't seem to need it?

As a followup:

I killed some time by going through the various BKL uses in USB and
came up with this git tree to address them . Feel free to integrate
into your tree.

With this only some obscure USB low level drivers still need to 
depend on BKL, the majority is clean. Gadgetfs also still needs
it for now.

I ended up also fixing some minor races in usb serial registration/
unregistration.

Opens:
- The usb serial ioctl entry needs to become a unlocked_ioctl,
but I think that needs your tree first. The code below it doesn't
need it anymore.
- The seek function in uhci-debug.c probably is still racy.

Only lightly tested. Some more reviewing would be appreciated

-Andi

The following changes since commit b72c40949b0f04728f2993a1434598d3bad094ea:
  Linus Torvalds (1):
        Merge branch 'for-linus' of git://git.kernel.org/.../jbarnes/pci-2.6

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/ak/linux-misc-2.6.git usb-bkl

Andi Kleen (12):
      USB-BKL: Remove lock_kernel in usbfs update_sb()
      USB-BKL: Remove BKL from usb serial drivers ioctl handlers
      USB-BKL: Convert usb_driver ioctl to unlocked_ioctl
      USB-BKL: Remove BKL use for usb serial driver probing
      USB-BKL: Make usb monitor depend on BKL
      USB-BKL: Make usb lcd driver depend on BKL
      USB-BKL: Make usb sisvga driver depend on BKL
      USB-BKL: Make usb rio500 driver depend on BKL
      USB-BKL: Make usb iowarrior driver depend on BKL
      USB-BKL: Remove BKL use in uhci-debug
      USB-BKL: Make usb gadget fs depend on BKL
      USB-BKL: Make usb gadget printer depend on BKL

 drivers/usb/core/devio.c              |    7 +----
 drivers/usb/core/hub.c                |    3 +-
 drivers/usb/core/inode.c              |    4 ---
 drivers/usb/gadget/Kconfig            |    3 +-
 drivers/usb/host/uhci-debug.c         |   17 +++++----------
 drivers/usb/misc/Kconfig              |    6 ++--
 drivers/usb/misc/sisusbvga/Kconfig    |    2 +-
 drivers/usb/misc/usbtest.c            |    3 +-
 drivers/usb/mon/Kconfig               |    2 +-
 drivers/usb/serial/ark3116.c          |    3 +-
 drivers/usb/serial/ch341.c            |    3 +-
 drivers/usb/serial/cypress_m8.c       |    8 +++---
 drivers/usb/serial/ftdi_sio.c         |    4 +-
 drivers/usb/serial/io_tables.h        |    8 +++---
 drivers/usb/serial/io_ti.c            |    5 ++-
 drivers/usb/serial/kobil_sct.c        |    3 +-
 drivers/usb/serial/mos7720.c          |    3 +-
 drivers/usb/serial/mos7840.c          |    3 +-
 drivers/usb/serial/opticon.c          |    3 +-
 drivers/usb/serial/oti6858.c          |    3 +-
 drivers/usb/serial/pl2303.c           |    3 +-
 drivers/usb/serial/spcp8x5.c          |    2 +-
 drivers/usb/serial/ti_usb_3410_5052.c |    6 ++--
 drivers/usb/serial/usb-serial.c       |   36 ++++++++++++++++----------------
 drivers/usb/serial/whiteheat.c        |    4 +-
 include/linux/usb.h                   |    2 +-
 include/linux/usb/serial.h            |    2 +-
 27 files changed, 74 insertions(+), 74 deletions(-)

-- 
ak@linux.intel.com -- Speaking for myself only.
