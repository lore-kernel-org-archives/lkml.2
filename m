Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756151Ab0GVJ4M (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Jul 2010 05:56:12 -0400
Received: from einhorn.in-berlin.de ([192.109.42.8]:37585 "EHLO
	einhorn.in-berlin.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753618Ab0GVJ4K convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Jul 2010 05:56:10 -0400
X-Envelope-From: stefanr@s5r6.in-berlin.de
Date: Thu, 22 Jul 2010 11:55:54 +0200 (CEST)
From: Stefan Richter <stefanr@s5r6.in-berlin.de>
Subject: [review patch 0/2] new driver: Nosy, a low-budget FireWire packet
 sniffer
To: linux-kernel@vger.kernel.org
cc: linux1394-devel@lists.sourceforge.net,
        Kristian Hoegsberg <krh@bitplanet.net>
Message-ID: <tkrat.72756f504d6c0055@s5r6.in-berlin.de>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; CHARSET=iso-8859-1
Content-Transfer-Encoding: 8BIT
Content-Disposition: INLINE
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Here is a (not so) new driver proposed for merge into the mainline:

    Nosy - turns a Texas Instruments PCILynx card into an IEEE 1394
           (FireWire) bus analyzer

This kernel driver is useful to reverse-engineer undocumented
vendor-specific protocols and as an aid in IEEE 1394 application/
driver/ firmware development or even hardware development.

The driver was written by Kristian Høgsberg several years ago and has
been maintained outside the mainline.  Perhaps because of its rather
limited user base, it took so long for a proposal to merge it into the
mainline.

The driver requires a TI PCILynx or PCILynx-2 based FireWire controller,
i.e. a TSB12LV21/ TSB12LV21A/ TSB12LV21B.  My guess is that the current
PCILynx-2 TSB12LV21B is better tested by Nosy users.  To my knowledge,
the following cards are based on PCILynx-2 or PCILynx:
  - IOI IOI-1394TT (PCI card, current)
  - Unibrain Fireboard 400 PCI Lynx-2 (PCI card, current)
  - Newer Technology FireWire 2 Go (CardBus card, discontinued product)
  - Apple Power Mac G3 blue & white (onboard controller, discontinued)
Regular OHCI-1394 FireWire controllers cannot be used for this purpose
since OHCI compliant cards do not receive peer-to-peer packets into
their link layers that are not addressed to them.

Along with the rather small kernel driver called nosy comes a simple
userspace frontend, called nosy-dump.  These two communicate via a
'misc' character device file with a simple ioctl() and read() based
protocol.  See the file nosy-user.h in patch 1/2 for a description of
the character device file ABI.

Since the frontend nosy-dump is rather small regarding code size and is
tightly bound to nosy regarding the kernel driver's usage scenario, it
is proposed to maintain nosy-dump in the kernel source tree too.  Patch
2/2 contains nosy-dump, placed into a new tools/firewire/ directory.

When I picked up nosy and nosy-dump from Kristian, I did a number of
modifications to prepare for mainline merge.  I have published the short
history of these modifications in linux1394-2.6.git now, in a branch
called 'nosy':

(git clone or pull)
    git://git.kernel.org/pub/scm/linux/kernel/git/ieee1394/linux1394-2.6.git nosy

(gitweb)
    http://git.kernel.org/?p=linux/kernel/git/ieee1394/linux1394-2.6.git;a=shortlog;h=refs/heads/nosy

I would prefer to merge this history instead of the two combined diffs
which I am going to post for review now.  Note, the 'nosy' git branch
may be rebased if there will be review comments that warrant rewriting
that branch.

Kristian's original sources are published at
    git://anongit.freedesktop.org/~krh/nosy

There used to be a web site about nosy:
    http://web.archive.org/web/20080225222139/http://bitplanet.net/nosy/

Current content of linux1394-2.6.git nosy:

Stefan Richter (21):
      firewire: new driver: nosy - IEEE 1394 traffic sniffer
      firewire: nosy: misc cleanups
      firewire: nosy: convert to unlocked ioctl
      firewire: nosy: fix list corruption by NOSY_IOC_STOP
      firewire: nosy: use flagless variants of spinlock accessors
      firewire: nosy: unroll some simple functions
      firewire: nosy: fix IRQ handler for card ejection
      firewire: nosy: handle errors in device probe
      firewire: nosy: fix device shutdown with active client
      firewire: nosy: annotate __user pointers and __iomem pointers
      firewire: nosy: endianess fixes and annotations
      firewire: nosy: use generic printk macros
      tools/firewire: add userspace front-end of nosy
      tools/firewire: nosy-dump: fix it on x86-64
      tools/firewire: nosy-dump: work around segfault in decode_fcp
      tools/firewire: nosy-dump: change to kernel coding style
      tools/firewire: nosy-dump: make some symbols static or const
      tools/firewire: nosy-dump: break up a deeply nested function
      tools/firewire: nosy-dump: use linux/firewire-constants.h
      tools/firewire: nosy-dump: remove unused code
      tools/firewire: nosy-dump: increment program version

 MAINTAINERS                  |    1 +
 drivers/firewire/Kconfig     |   24 +
 drivers/firewire/Makefile    |    1 +
 drivers/firewire/nosy-user.h |   25 +
 drivers/firewire/nosy.c      |  720 ++++++++++++++++++++++++
 drivers/firewire/nosy.h      |  237 ++++++++
 tools/firewire/Makefile      |   19 +
 tools/firewire/decode-fcp.c  |  213 +++++++
 tools/firewire/list.h        |   62 ++
 tools/firewire/nosy-dump.c   | 1031 ++++++++++++++++++++++++++++++++++
 tools/firewire/nosy-dump.h   |  173 ++++++
 11 files changed, 2506 insertions(+), 0 deletions(-)
 create mode 100644 drivers/firewire/nosy-user.h
 create mode 100644 drivers/firewire/nosy.c
 create mode 100644 drivers/firewire/nosy.h
 create mode 100644 tools/firewire/Makefile
 create mode 100644 tools/firewire/decode-fcp.c
 create mode 100644 tools/firewire/list.h
 create mode 100644 tools/firewire/nosy-dump.c
 create mode 100644 tools/firewire/nosy-dump.h
-- 
Stefan Richter
-=====-==-=- -=== =-==-
http://arcgraph.de/sr/

