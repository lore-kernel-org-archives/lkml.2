Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758608Ab2DXXCD (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Apr 2012 19:02:03 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:49279 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932297Ab2DXWeY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Apr 2012 18:34:24 -0400
Message-Id: <20120424223242.855843657@linuxfoundation.org>
User-Agent: quilt/0.60-19.1
Date: Tue, 24 Apr 2012 15:32:51 -0700
From: Greg KH <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org,
        alan@lxorguk.ukuu.org.uk, Santosh Shilimkar <santosh.shilimkar@ti.com>,
        Kevin Hilman <khilman@ti.com>, "Govindraj.R" <govindraj.raja@ti.com>,
        Paul Walmsley <paul@pwsan.com>, Tony Lindgren <tony@atomide.com>
Subject: [ 10/62] ARM: OMAP: serial: Fix the ocp smart idlemode handling bug
In-Reply-To: <20120424223305.GA7748@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.3-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Santosh Shilimkar <santosh.shilimkar@ti.com>

commit 5ae256dcd91bf308826a4ac19598b27ebb86a536 upstream.

The current serial UART code, while fidling with ocp idlemode bits,
forget about the smart idle wakeup bit even if it is supported by
UART IP block. This will lead to missing the module wakeup on OMAP's
where the smart idle wakeup is supported.

This was the root cause of the console sluggishness issue, I have been
observing on OMAP4 devices and also can be potential reason for some
other UART wakeup issues.

Signed-off-by: Santosh Shilimkar <santosh.shilimkar@ti.com>
Acked-by: Kevin Hilman <khilman@ti.com>
Acked-by: Govindraj.R <govindraj.raja@ti.com>
Reviewed-by: Paul Walmsley <paul@pwsan.com>
Signed-off-by: Tony Lindgren <tony@atomide.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 arch/arm/mach-omap2/serial.c |    8 +++++++-
 1 file changed, 7 insertions(+), 1 deletion(-)

--- a/arch/arm/mach-omap2/serial.c
+++ b/arch/arm/mach-omap2/serial.c
@@ -110,8 +110,14 @@ static void omap_uart_set_noidle(struct
 static void omap_uart_set_smartidle(struct platform_device *pdev)
 {
 	struct omap_device *od = to_omap_device(pdev);
+	u8 idlemode;
 
-	omap_hwmod_set_slave_idlemode(od->hwmods[0], HWMOD_IDLEMODE_SMART);
+	if (od->hwmods[0]->class->sysc->idlemodes & SIDLE_SMART_WKUP)
+		idlemode = HWMOD_IDLEMODE_SMART_WKUP;
+	else
+		idlemode = HWMOD_IDLEMODE_SMART;
+
+	omap_hwmod_set_slave_idlemode(od->hwmods[0], idlemode);
 }
 
 #else


