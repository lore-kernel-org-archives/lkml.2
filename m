Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753913Ab0G3SRl (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Jul 2010 14:17:41 -0400
Received: from kroah.org ([198.145.64.141]:58882 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760049Ab0G3R4r (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Jul 2010 13:56:47 -0400
X-Mailbox-Line: From gregkh@clark.site Fri Jul 30 10:51:45 2010
Message-Id: <20100730175145.887990462@clark.site>
User-Agent: quilt/0.48-11.2
Date: Fri, 30 Jul 2010 10:52:28 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Sergei Shtylyov <sshtylyov@ru.mvista.com>,
        Ajay Kumar Gupta <ajay.gupta@ti.com>,
        Felipe Balbi <felipe.balbi@nokia.com>
Subject: [131/205] USB: MUSB: make non-OMAP platforms build with CONFIG_PM=y
In-Reply-To: <20100730175238.GA3924@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.34-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Sergei Shtylyov <sshtylyov@ru.mvista.com>

commit 9297688a9257d73956d4bba484d9dd331ca72c25 upstream.

Attempt to build MUSB driver with CONFIG_PM=y (e.g. in the OTG mode) on DaVinci
results in these link errors:

drivers/built-in.o: In function `musb_restore_context':
led-triggers.c:(.text+0x714d8): undefined reference to
`musb_platform_restore_context'
drivers/built-in.o: In function `musb_save_context':
led-triggers.c:(.text+0x71788): undefined reference to
`musb_platform_save_context'

This turned out to be caused by commit 9957dd97ec5e98dd334f87ade1d9a0b24d1f86eb
(usb: musb: Fix compile error for omaps for musb_hdrc). Revert it, taking into
account the rename of CONFIG_ARCH_OMAP34XX into CONFIG_ARCH_OMAP3 (which that
commit fixed in a completely inappropriate way) and the recent addition of
OMAP4 support.

Signed-off-by: Sergei Shtylyov <sshtylyov@ru.mvista.com>
Signed-off-by: Ajay Kumar Gupta <ajay.gupta@ti.com>
Acked-by: Felipe Balbi <felipe.balbi@nokia.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/usb/musb/musb_core.h |    6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

--- a/drivers/usb/musb/musb_core.h
+++ b/drivers/usb/musb/musb_core.h
@@ -469,7 +469,8 @@ struct musb_csr_regs {
 
 struct musb_context_registers {
 
-#ifdef CONFIG_PM
+#if defined(CONFIG_ARCH_OMAP2430) || defined(CONFIG_ARCH_OMAP3) || \
+    defined(CONFIG_ARCH_OMAP4)
 	u32 otg_sysconfig, otg_forcestandby;
 #endif
 	u8 power;
@@ -483,7 +484,8 @@ struct musb_context_registers {
 	struct musb_csr_regs index_regs[MUSB_C_NUM_EPS];
 };
 
-#ifdef CONFIG_PM
+#if defined(CONFIG_ARCH_OMAP2430) || defined(CONFIG_ARCH_OMAP3) || \
+    defined(CONFIG_ARCH_OMAP4)
 extern void musb_platform_save_context(struct musb *musb,
 		struct musb_context_registers *musb_context);
 extern void musb_platform_restore_context(struct musb *musb,


