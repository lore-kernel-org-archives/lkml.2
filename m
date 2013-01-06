Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756104Ab3AFRfK (ORCPT <rfc822;w@1wt.eu>);
	Sun, 6 Jan 2013 12:35:10 -0500
Received: from mail.free-electrons.com ([94.23.32.191]:38253 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753067Ab3AFRfI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 6 Jan 2013 12:35:08 -0500
From: Gregory CLEMENT <gregory.clement@free-electrons.com>
To: Linus Walleij <linus.walleij@linaro.org>,
        Grant Likely <grant.likely@secretlab.ca>
Cc: Maxime Ripard <maxime.ripard@free-electrons.com>,
        Andreas Schallenberg <Andreas.Schallenberg@3alitytechnica.com>,
        Roland Stigge <stigge@antcom.de>, Jason Cooper <jason@lakedaemon.net>,
        Andrew Lunn <andrew@lunn.ch>,
        Thomas Petazzoni <thomas.petazzoni@free-electrons.com>,
        Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        Gregory CLEMENT <gregory.clement@free-electrons.com>
Subject: [PATCH 0/3] Add support for gpio expander pca9505 used on Mirabox
Date: Sun,  6 Jan 2013 18:34:45 +0100
Message-Id: <1357493688-25061-1-git-send-email-gregory.clement@free-electrons.com>
X-Mailer: git-send-email 1.7.9.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

This patch set adds the support for the i2c gpio expander pca9505 used
on the JTAG/GPIO box which can be connected to the Mirabox.

To be able to use the pca9505 I had to do several changes in the
driver. Indeed, until now the pca953x driver accessed all the bank of
a given register in a single command using only a 32 bits
variable. This expander comes with 40 GPIOs which no more fits in a 32
variable. This patch set makes the accesses to the registers more
generic by relying on an array of u8 variables. This fits exactly the
way the registers are represented in the hardware.

Once the per-bank representation was added, it was easier to introduce
helpers to access to a single register of a bank instead of reading or
writing all the banks for a given register. As the GPIO API allows
only the accesses to a single GPIO at a time there was no point to read
and write all the other banks. Hence it should help to decrease the
latency especially for the pca9505.

However as the block GPIO API from Roland Stigge is incoming I kept
the helpers used to access all the banks in the same time. I had to
make some modifications in the arguments that these functions
received, so it will have a conflict here. Currently my patch set is
based on v3.8-rc2, but I am willing to rebase onto gpio-for-next once
the GPIO block will be merged into it.

I also expected some tested-by as I was only able to test the pca9505
and I didn't test the IRQ part.

Thanks!

Gregory CLEMENT (3):
  gpio: pca953x: make the register access by GPIO bank
  gpio: pca953x: add support for pca9505
  arm: mvebu: enable gpio expander over i2c on Mirabox platform

 arch/arm/boot/dts/armada-370-mirabox.dts |   10 ++
 drivers/gpio/gpio-pca953x.c              |  235 +++++++++++++++++++-----------
 2 files changed, 160 insertions(+), 85 deletions(-)

-- 
1.7.9.5

