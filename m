Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753796Ab1LTBP1 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Dec 2011 20:15:27 -0500
Received: from mail-lpp01m010-f46.google.com ([209.85.215.46]:36781 "EHLO
	mail-lpp01m010-f46.google.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753309Ab1LTBPZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Dec 2011 20:15:25 -0500
From: Felipe Contreras <felipe.contreras@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: =?UTF-8?q?Uwe=20Kleine-K=C3=B6nig?= 
	<u.kleine-koenig@pengutronix.de>,
        Felipe Balbi <balbi@ti.com>, Vladimir Zapolskiy <vz@mleia.com>,
        Felipe Contreras <felipe.contreras@gmail.com>
Subject: [PATCH v4 0/4] Simplifications on Kconfigs
Date: Tue, 20 Dec 2011 03:15:13 +0200
Message-Id: <1324343717-7292-1-git-send-email-felipe.contreras@gmail.com>
X-Mailer: git-send-email 1.7.8.rc1.14.g248db
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

These have been discussed quite extensively before, but I never took the time
to split them:

http://article.gmane.org/gmane.linux.kernel/1050608
http://article.gmane.org/gmane.linux.usb.general/38230

Some are simple, and people OK'ed them, some others are a bit controversial.
However, something needs to be done.

At some point in time Linus complained about the huge amount of changes in the
ARM configs, which were huge at the time, and he even threated to remove them
all. The switch to simplified defconfigs (using 'make savedefconfig') greatly
alleviated the situation, however, the idea was that kconfig files should
continue to be improved until the defconfigs are so small, that they are not
needed at all any more. We are pretty far from that point.

So... the following patches remove the need to manually specify some
configurations in some platforms, like TWL4030_CORE, REGULATOR_TWL4030, and
TWL4030_USB. Note however that these are only *defaults*; the user can always
disable them for whatever reason, and they are not *dependencies*; the user can
still enable them in other architectures (like x86).

The final patch although it looks like it's adding a dependency, it's not; the
dependency is already there, except in the form selects. Well, almost, because
right now you can build USB_MUSB_HDRC if TWL4030_USB=n and NOP_USB_XCEIV=n in
some architectures (like MACH_OMAP_RX51), and that's actually bad, because that
has no possibility of working. Fortunately the dependencies can be built in x86
(or any other architecture), so USB_MUSB_HDRC can be built as well. IOW; this
is just shuffling the code so that at least OMAP2+ machines have sensible
defaults when USB_MUSB_HDRC is on.

One of the results is that this simple defconfig works (or at least selects the
right USB stuff):

---
CONFIG_ARCH_OMAP=y
CONFIG_ARCH_OMAP2PLUS_TYPICAL=n

CONFIG_USB=y
CONFIG_USB_GADGET=y
CONFIG_USB_MUSB_OTG=y
CONFIG_USB_MUSB_HDRC=y
CONFIG_USB_ETH=y
CONFIG_USB_ETH_EEM=y

# Should be selected automatically
# CONFIG_TWL4030_USB=y

# TODO USB_MUSB_OTG should select this
CONFIG_USB_GADGET_MUSB_HDRC=y
---

Cheers.

Felipe Contreras (4):
  mfd: simplify twl4030_power config
  mfd: simplify twl4030_core config
  regulator: simplify twl4030 config
  usb: simplify hdrc configuration

 drivers/mfd/Kconfig       |    3 ++-
 drivers/regulator/Kconfig |    1 +
 drivers/usb/musb/Kconfig  |    4 +---
 drivers/usb/otg/Kconfig   |    3 +++
 4 files changed, 7 insertions(+), 4 deletions(-)

-- 
1.7.8.rc1.14.g248db

