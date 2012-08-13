Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753865Ab2HMUV2 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Aug 2012 16:21:28 -0400
Received: from mail-ob0-f174.google.com ([209.85.214.174]:55329 "EHLO
	mail-ob0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753764Ab2HMUVY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Aug 2012 16:21:24 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Greg KH <gregkh@linuxfoundation.org>, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Marek Vasut <marex@denx.de>, Shawn Guo <shawn.guo@linaro.org>,
        Russell King <rmk+kernel@arm.linux.org.uk>
Subject: [ 19/82] ARM: 7466/1: disable interrupt before spinning endlessly
Date: Mon, 13 Aug 2012 13:18:55 -0700
Message-Id: <20120813201748.120836533@linuxfoundation.org>
X-Mailer: git-send-email 1.7.10.1.362.g242cab3
In-Reply-To: <20120813201746.448504360@linuxfoundation.org>
References: <20120813201746.448504360@linuxfoundation.org>
User-Agent: quilt/0.60-20.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Greg KH <gregkh@linuxfoundation.org>

3.5-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Shawn Guo <shawn.guo@linaro.org>

commit 98bd8b96b26db3399a48202318dca4aaa2515355 upstream.

The CPU will endlessly spin at the end of machine_halt and
machine_restart calls.  However, this will lead to a soft lockup
warning after about 20 seconds, if CONFIG_LOCKUP_DETECTOR is enabled,
as system timer is still alive.

Disable interrupt before going to spin endlessly, so that the lockup
warning will never be seen.

Reported-by: Marek Vasut <marex@denx.de>
Signed-off-by: Shawn Guo <shawn.guo@linaro.org>
Signed-off-by: Russell King <rmk+kernel@arm.linux.org.uk>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 arch/arm/kernel/process.c |    2 ++
 1 file changed, 2 insertions(+)

--- a/arch/arm/kernel/process.c
+++ b/arch/arm/kernel/process.c
@@ -247,6 +247,7 @@ void machine_shutdown(void)
 void machine_halt(void)
 {
 	machine_shutdown();
+	local_irq_disable();
 	while (1);
 }
 
@@ -268,6 +269,7 @@ void machine_restart(char *cmd)
 
 	/* Whoops - the platform was unable to reboot. Tell the user! */
 	printk("Reboot failed -- System halted\n");
+	local_irq_disable();
 	while (1);
 }
 


