Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932293Ab0DBMIs (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Apr 2010 08:08:48 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:42503 "EHLO
	opensource2.wolfsonmicro.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1756783Ab0DBMIm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Apr 2010 08:08:42 -0400
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Samuel Ortiz <sameo@linux.intel.com>
Cc: linux-kernel@vger.kernel.org,
       Mark Brown <broonie@opensource.wolfsonmicro.com>
Subject: [PATCH 2.6.34] mfd: Clean up after WM83xx AUXADC interrupt if it arrives late
Date: Fri,  2 Apr 2010 13:08:39 +0100
Message-Id: <1270210119-16746-1-git-send-email-broonie@opensource.wolfsonmicro.com>
X-Mailer: git-send-email 1.7.0.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

In certain circumstances, especially under heavy load, the AUXADC
completion interrupt may be detected after we've timed out waiting for
it.  That conversion would still succeed but the next conversion will
see the completion that was signalled by the interrupt for the previous
conversion and therefore not wait for the AUXADC conversion to run,
causing it to report failure.

Provide a simple, non-invasive cleanup by using try_wait_for_completion()
to ensure that the completion is not signalled before we wait.  Since
the AUXADC is run within a mutex we know there can only have been at
most one AUXADC interrupt outstanding.  A more involved change should
follow for the next merge window.

Signed-off-by: Mark Brown <broonie@opensource.wolfsonmicro.com>
---
 drivers/mfd/wm831x-core.c |    3 +++
 drivers/mfd/wm8350-core.c |    4 ++++
 2 files changed, 7 insertions(+), 0 deletions(-)

diff --git a/drivers/mfd/wm831x-core.c b/drivers/mfd/wm831x-core.c
index a3d5728..f2ab025 100644
--- a/drivers/mfd/wm831x-core.c
+++ b/drivers/mfd/wm831x-core.c
@@ -349,6 +349,9 @@ int wm831x_auxadc_read(struct wm831x *wm831x, enum wm831x_auxadc input)
 		goto disable;
 	}
 
+	/* If an interrupt arrived late clean up after it */
+	try_wait_for_completion(&wm831x->auxadc_done);
+
 	/* Ignore the result to allow us to soldier on without IRQ hookup */
 	wait_for_completion_timeout(&wm831x->auxadc_done, msecs_to_jiffies(5));
 
diff --git a/drivers/mfd/wm8350-core.c b/drivers/mfd/wm8350-core.c
index e400a3b..b580748 100644
--- a/drivers/mfd/wm8350-core.c
+++ b/drivers/mfd/wm8350-core.c
@@ -363,6 +363,10 @@ int wm8350_read_auxadc(struct wm8350 *wm8350, int channel, int scale, int vref)
 	reg |= 1 << channel | WM8350_AUXADC_POLL;
 	wm8350_reg_write(wm8350, WM8350_DIGITISER_CONTROL_1, reg);
 
+	/* If a late IRQ left the completion signalled then consume
+	 * the completion. */
+	try_wait_for_completion(&wm8350->auxadc_done);
+
 	/* We ignore the result of the completion and just check for a
 	 * conversion result, allowing us to soldier on if the IRQ
 	 * infrastructure is not set up for the chip. */
-- 
1.7.0.3

