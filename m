Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932723Ab0EJX0H (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 May 2010 19:26:07 -0400
Received: from kroah.org ([198.145.64.141]:33471 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932576Ab0EJWxJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 May 2010 18:53:09 -0400
X-Mailbox-Line: From gregkh@kvm.kroah.org Mon May 10 15:33:28 2010
Message-Id: <20100510223327.940053372@kvm.kroah.org>
User-Agent: quilt/0.48-4.4
Date: Mon, 10 May 2010 15:33:28 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org, Greg KH <greg@kroah.com>
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
       Ralf Baechle <ralf@linux-mips.org>,
       Sebastian Andrzej Siewior <sebastian@breakpoint.cc>
Subject: [117/117] MIPS: Sibyte: Apply M3 workaround only on affected chip types and versions.
In-Reply-To: <20100510223700.GA18404@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.33-stable review patch.  If anyone has any objections, please let us know.

------------------

(cherry picked from commit e65c7f33d75e977350ca350573d93c517ec02776)

Previously it was unconditionally used on all Sibyte family SOCs.  The
M3 bug has to be handled in the TLB exception handler which is extremly
performance sensitive, so this modification is expected to deliver around
2-3% performance improvment.  This is important as required changes to the
M3 workaround will make it more costly.

Signed-off-by: Ralf Baechle <ralf@linux-mips.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 arch/mips/include/asm/mach-sibyte/war.h |    6 +++++-
 arch/mips/sibyte/sb1250/setup.c         |   15 +++++++++++++++
 2 files changed, 20 insertions(+), 1 deletion(-)

--- a/arch/mips/include/asm/mach-sibyte/war.h
+++ b/arch/mips/include/asm/mach-sibyte/war.h
@@ -16,7 +16,11 @@
 #if defined(CONFIG_SB1_PASS_1_WORKAROUNDS) || \
     defined(CONFIG_SB1_PASS_2_WORKAROUNDS)
 
-#define BCM1250_M3_WAR	1
+#ifndef __ASSEMBLY__
+extern int sb1250_m3_workaround_needed(void);
+#endif
+
+#define BCM1250_M3_WAR	sb1250_m3_workaround_needed()
 #define SIBYTE_1956_WAR	1
 
 #else
--- a/arch/mips/sibyte/sb1250/setup.c
+++ b/arch/mips/sibyte/sb1250/setup.c
@@ -87,6 +87,21 @@ static int __init setup_bcm1250(void)
 	return ret;
 }
 
+int sb1250_m3_workaround_needed(void)
+{
+	switch (soc_type) {
+	case K_SYS_SOC_TYPE_BCM1250:
+	case K_SYS_SOC_TYPE_BCM1250_ALT:
+	case K_SYS_SOC_TYPE_BCM1250_ALT2:
+	case K_SYS_SOC_TYPE_BCM1125:
+	case K_SYS_SOC_TYPE_BCM1125H:
+		return soc_pass < K_SYS_REVISION_BCM1250_C0;
+
+	default:
+		return 0;
+	}
+}
+
 static int __init setup_bcm112x(void)
 {
 	int ret = 0;


