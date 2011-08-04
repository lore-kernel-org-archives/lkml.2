Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755319Ab1HDXAh (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Aug 2011 19:00:37 -0400
Received: from avon.wwwdotorg.org ([70.85.31.133]:53712 "EHLO
	avon.wwwdotorg.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752077Ab1HDXAa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Aug 2011 19:00:30 -0400
From: Stephen Warren <swarren@nvidia.com>
To: Thomas Gleixner <tglx@linutronix.de>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>,
        Liam Girdwood <lrg@ti.com>, Chris Ball <cjb@laptop.org>,
        ccross@android.com, olof@lixom.net
Cc: linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        alsa-devel@alsa-project.org, linux-mmc@vger.kernel.org,
        linux-tegra@vger.kernel.org, Stephen Warren <swarren@nvidia.com>
Subject: [RFC PATCH 0/3] If an IRQ is a GPIO, request and configure it
Date: Thu,  4 Aug 2011 17:00:17 -0600
Message-Id: <1312498820-2275-1-git-send-email-swarren@nvidia.com>
X-Mailer: git-send-email 1.7.0.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

In http://www.spinics.net/lists/linux-tegra/msg01731.html, Mark Brown
pointed out that it was a little silly forcing every board or driver
to gpio_request() a GPIO that is later converted to an IRQ, and passed
to request_irq. The first patch in this series instead makes the core
IRQ code perform these calls when appropriate, to avoid duplicating it
everywhere.

However, this change has the potential for significant regressions; at
least some drivers are already calling gpio_request for GPIOs that are
also used as IRQs. This then causes the gpio_request inside the core IRQ
code to fail, which causes functional regressions. I'm not sure how wide-
spread this issue is, but in testing on NVIDIA Tegra, I found two
instances that needed to be fixed. Perhaps  a failure of gpio_request
in the core IRQ code should trigger a WARN rather than returning an
error, to give a grace period for conversion of other code?

Stephen Warren (3):
  irq: If an IRQ is a GPIO, request and configure it
  mmc: tegra: Don't gpio_request GPIOs used as IRQs.
  ASoC: jack_add_gpios: Don't gpio_request GPIOs used as IRQs.

 drivers/mmc/host/sdhci-tegra.c |    8 --------
 kernel/irq/manage.c            |   25 +++++++++++++++++++++++--
 sound/soc/soc-jack.c           |   13 +------------
 3 files changed, 24 insertions(+), 22 deletions(-)

