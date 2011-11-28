Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753259Ab1K1Ln4 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Nov 2011 06:43:56 -0500
Received: from mo-p05-ob.rzone.de ([81.169.146.182]:12069 "EHLO
	mo-p05-ob.rzone.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752756Ab1K1Lny (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Nov 2011 06:43:54 -0500
X-RZG-AUTH: :KXokZlStbvrPCC8w2n2KADUjx90tFpDbrwvi3rISAmCHBWiKTAoKIqY5gZEywA==
X-RZG-CLASS-ID: mo05
Message-Id: <cover.1322479017.git.n.voss@weinmann.de>
From: Nikolaus Voss <n.voss@weinmann.de>
Date: Mon, 28 Nov 2011 12:16:57 +0100
Subject: [PATCH v8 0/7] AT91: replace broken TWI driver i2c-at91.c
To: linux-i2c@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org
Cc: ben-linux@fluff.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The old driver has two main deficencies:
i)  No repeated start (Sr) condiction is possible, this makes it unusable
    e.g. for most SMBus transfers.
ii) I/O was done with polling/busy waiting what caused over-/underruns
    even at light system loads and clock speeds.

The new driver overcomes these deficencies and in addition allows for
more than one TWI interface.

A remaining limitation is the fact, that only one repeated start is
possible (two concatenated messages). This limitation is imposed by
the hardware. However, this should not be a problem as all common
i2c-client communication does not rely on more than one repeated start.

v8: Patch 6/7: remove local include
    Patch 7/7: remove cpu_is_rm9200() and put twi hw bug info
               in platform_device
    Patch 3/7: use readl/writel_relaxed instead of __raw_readl/writel
v7: Patch 4/5: i)  fix bug if internal address > 1 byte
               ii) send stop when len == 1
                   (both reported by Carsten Behling)
v6: Patch 5/5: support for I2C_SMBUS_BLOCK_DATA transfers.
    Better use of clk_(un)prepare().
    More sensible transfer timeout.
v5: Another round of review comments from Ryan Mallon, Felipe Balbi
    and Russell King: convert twi clk to use .dev_id, cleanups
v4: Integrated more review comments from Ryan Mallon and Felipe Balbi:
    Moved register include file to local include, code cleanups
v3: Integrated review comments from Ryan Mallon and Felipe Balbi
v2: Fixed whitespace issue

Nikolaus Voss (7):
  drivers/i2c/busses/i2c-at91.c: remove broken driver
  Replace clk_lookup.con_id with clk_lookup.dev_id entries for twi clk
  drivers/i2c/busses/i2c-at91.c: add new driver
  G45 TWI: remove open drain setting for twi function gpios
  i2c-at91.c: add SMBUS_READ_BLOCK_DATA functionality
  i2c-at91: removed local include
  i2c-at91: make ckdiv bug a property of the platform_device

 arch/arm/mach-at91/at91cap9.c              |    1 +
 arch/arm/mach-at91/at91cap9_devices.c      |    9 +
 arch/arm/mach-at91/at91rm9200.c            |    1 +
 arch/arm/mach-at91/at91rm9200_devices.c    |    9 +
 arch/arm/mach-at91/at91sam9260.c           |    1 +
 arch/arm/mach-at91/at91sam9260_devices.c   |    9 +
 arch/arm/mach-at91/at91sam9261.c           |    1 +
 arch/arm/mach-at91/at91sam9261_devices.c   |    9 +
 arch/arm/mach-at91/at91sam9263.c           |    1 +
 arch/arm/mach-at91/at91sam9263_devices.c   |    9 +
 arch/arm/mach-at91/at91sam9g45.c           |    2 +
 arch/arm/mach-at91/at91sam9g45_devices.c   |   16 +-
 arch/arm/mach-at91/at91sam9rl.c            |    2 +
 arch/arm/mach-at91/at91sam9rl_devices.c    |    9 +
 arch/arm/mach-at91/include/mach/at91_twi.h |   68 ----
 drivers/i2c/busses/Kconfig                 |   11 +-
 drivers/i2c/busses/i2c-at91.c              |  563 +++++++++++++++++-----------
 17 files changed, 424 insertions(+), 297 deletions(-)
 delete mode 100644 arch/arm/mach-at91/include/mach/at91_twi.h

-- 
1.7.5.4

