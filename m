Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754671Ab2DTKTO (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Apr 2012 06:19:14 -0400
Received: from mo-p05-ob.rzone.de ([81.169.146.182]:43085 "EHLO
	mo-p05-ob.rzone.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752226Ab2DTKSy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Apr 2012 06:18:54 -0400
X-RZG-AUTH: :KXokZlStbvrPCC8w2n2KADUjx90tFpDbrwvi3rISAmCHBWiKTAoKIqY5gZEywA==
X-RZG-CLASS-ID: mo05
Message-Id: <cover.1334916810.git.n.voss@weinmann.de>
From: Nikolaus Voss <n.voss@weinmann.de>
Date: Fri, 20 Apr 2012 12:13:30 +0200
Subject: [PATCH v10 0/4] AT91: replace broken TWI driver i2c-at91.c
To: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        linux-i2c@vger.kernel.org
Cc: nicolas.ferre@atmel.com, ben-linux@fluff.org, balbi@ti.com,
        h.feurstein@gmail.com, rmallon@gmail.com, adrian.yanes@aalto.fi
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

Signed-off-by: Nikolaus Voss <n.voss@weinmann.de>
Reviewed-by: Felipe Balbi <balbi@ti.com>
Tested-by: Hubert Feurstein <h.feurstein@gmail.com>

v10: - applied fix for RXRDY overrun bug submitted by Hubert Feurstein
     - applied fix for calculating twi_clk
v9: - merge i2c-at91.c patches to single patch
    - rewrite cwgr reg after timeout
v8: - remove local include
    - remove cpu_is_rm9200() and put twi hw bug info in platform_device
    - use readl/writel_relaxed instead of __raw_readl/writel
v7: i)  fix bug if internal address > 1 byte
    ii) send stop when len == 1 (both reported by Carsten Behling)
v6: support for I2C_SMBUS_BLOCK_DATA transfers.
    Better use of clk_(un)prepare().
    More sensible transfer timeout.
v5: Another round of review comments from Ryan Mallon, Felipe Balbi
    and Russell King: convert twi clk to use .dev_id, cleanups
v4: Integrated more review comments from Ryan Mallon and Felipe Balbi:
    Moved register include file to local include, code cleanups
v3: Integrated review comments from Ryan Mallon and Felipe Balbi
v2: Fixed whitespace issue

Nikolaus Voss (4):
  drivers/i2c/busses/i2c-at91.c: remove broken driver
  Replace clk_lookup.con_id with clk_lookup.dev_id entries for twi clk
  drivers/i2c/busses/i2c-at91.c: add new driver
  G45 TWI: remove open drain setting for twi function gpios

 arch/arm/mach-at91/at91cap9.c              |    1 +
 arch/arm/mach-at91/at91rm9200.c            |    1 +
 arch/arm/mach-at91/at91rm9200_devices.c    |    9 +
 arch/arm/mach-at91/at91sam9260.c           |    1 +
 arch/arm/mach-at91/at91sam9261.c           |    1 +
 arch/arm/mach-at91/at91sam9263.c           |    1 +
 arch/arm/mach-at91/at91sam9g45.c           |    2 +
 arch/arm/mach-at91/at91sam9g45_devices.c   |    6 -
 arch/arm/mach-at91/at91sam9rl.c            |    2 +
 arch/arm/mach-at91/include/mach/at91_twi.h |   68 ----
 drivers/i2c/busses/Kconfig                 |   11 +-
 drivers/i2c/busses/i2c-at91.c              |  579 ++++++++++++++++++----------
 12 files changed, 393 insertions(+), 289 deletions(-)
 delete mode 100644 arch/arm/mach-at91/include/mach/at91_twi.h

-- 
1.7.5.4

