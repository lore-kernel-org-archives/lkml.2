Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1162820Ab1FAIY3 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Jun 2011 04:24:29 -0400
Received: from cantor.suse.de ([195.135.220.2]:44832 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1162791Ab1FAIYY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Jun 2011 04:24:24 -0400
X-Mailbox-Line: From linux@blue.kroah.org Wed Jun  1 17:11:53 2011
Message-Id: <20110601081152.968613379@blue.kroah.org>
User-Agent: quilt/0.48-16.4
Date: Wed, 01 Jun 2011 17:11:15 +0900
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Rakesh Iyer <riyer@nvidia.com>, Stephen Warren <swarren@nvidia.com>,
        Greg Kroah-Hartman <gregkh@suse.de>
Subject: [105/165] i2c: tegra: Enable new slave mode.
In-Reply-To: <20110601081349.GA10017@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.39-stable review patch.  If anyone has any objections, please let us know.

------------------
Content-Length: 1595
Lines: 46

From: Kenneth Waters <kwaters@chromium.org>

commit 65a1a0ace554d61ea5a90377a54df1505275c1b1 upstream.

For Tegra i2c controller to function properly new slave mode must be
enabled.

swarren notes:

In particular, I found this was needed when working on enabling the
Tegra audio driver on the Seaboard board. There are two different PCB
layouts for this board; a "clamshell" version, which works just fine
without this change, and the original non-clamshell version, which needs
this change in order for I2C to operate correctly. Without it, I2C
probing fails for some devices, e.g. with:

wm8903 0-001a: Device with ID register 0 is not a WM8903
wm8903 0-001a: asoc: failed to probe CODEC wm8903.0-001a: -19
asoc: failed to instantiate card tegra-wm8903: -19
ALSA device list:
  No soundcards found.

Signed-off-by: Rakesh Iyer <riyer@nvidia.com>
Signed-off-by: Stephen Warren <swarren@nvidia.com>
Signed-off-by: Ben Dooks <ben-linux@fluff.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/i2c/busses/i2c-tegra.c |    5 +++++
 1 file changed, 5 insertions(+)

--- a/drivers/i2c/busses/i2c-tegra.c
+++ b/drivers/i2c/busses/i2c-tegra.c
@@ -330,6 +330,11 @@ static int tegra_i2c_init(struct tegra_i
 	i2c_writel(i2c_dev, 0, I2C_INT_MASK);
 	clk_set_rate(i2c_dev->clk, i2c_dev->bus_clk_rate * 8);
 
+	if (!i2c_dev->is_dvc) {
+		u32 sl_cfg = i2c_readl(i2c_dev, I2C_SL_CNFG);
+		i2c_writel(i2c_dev, sl_cfg | I2C_SL_CNFG_NEWSL, I2C_SL_CNFG);
+	}
+
 	val = 7 << I2C_FIFO_CONTROL_TX_TRIG_SHIFT |
 		0 << I2C_FIFO_CONTROL_RX_TRIG_SHIFT;
 	i2c_writel(i2c_dev, val, I2C_FIFO_CONTROL);


