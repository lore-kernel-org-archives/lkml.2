Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753376Ab2KTWm3 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Nov 2012 17:42:29 -0500
Received: from aserp1040.oracle.com ([141.146.126.69]:51342 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753137Ab2KTWm2 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Nov 2012 17:42:28 -0500
MIME-Version: 1.0
Message-ID: <748aba10-531a-4ad5-bad3-7af0f86c0489@default>
Date: Tue, 20 Nov 2012 14:42:18 -0800 (PST)
From: Dan Magenheimer <dan.magenheimer@oracle.com>
To: Konrad Wilk <konrad.wilk@oracle.com>
Cc: linux-kernel@vger.kernel.org, xen-devel@lists.xen.org
Subject: [PATCH] xen: tmem: selfballooning should be enabled when xen tmem is
 enabled
X-Priority: 3
X-Mailer: Oracle Beehive Extensions for Outlook 2.0.1.7  (607090) [OL
 12.0.6665.5003 (x86)]
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 8BIT
X-Source-IP: ucsinet21.oracle.com [156.151.31.93]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Konrad: Any chance this can get in for the upcoming window?
(Or is it enough of a bug fix that it can go in at an -rcN?)

It was just pointed out to me that some kernels have
cleancache and frontswap and xen_tmem enabled but NOT
xen_selfballooning!  While this configuration should be
possible, nearly all kernels that have CONFIG_XEN_TMEM=y should
also have CONFIG_XEN_SELFBALLOONING=y, since Transcendent
Memory (tmem) for Xen has very limited value without
selfballooning.

This is probably a result of a Kconfig mistake fixed I think
by the patch below.  Note that the year-old Oracle UEK2 kernel
distro has both CONFIG_XEN_TMEM and CONFIG_XEN_SELFBALLOONING
enabled, as does a Fedora 17 kernel update (3.6.6-1.fc17), so
the combination should be well tested.  Also, Xen tmem (and thus
selfballooning) are currently only enabled when a kernel boot
parameter is supplied so there is no runtime impact without
that boot parameter.

Signed-off-by: Dan Magenheimer <dan.magenheimer@oracle.com>

diff --git a/drivers/xen/Kconfig b/drivers/xen/Kconfig
index d4dffcd..b5f02f3 100644
--- a/drivers/xen/Kconfig
+++ b/drivers/xen/Kconfig
@@ -10,9 +10,9 @@ config XEN_BALLOON
 	  return unneeded memory to the system.
 
 config XEN_SELFBALLOONING
-	bool "Dynamically self-balloon kernel memory to target"
-	depends on XEN && XEN_BALLOON && CLEANCACHE && SWAP && XEN_TMEM
-	default n
+	bool
+	depends on XEN_BALLOON && SWAP
+	default y if XEN_TMEM
 	help
 	  Self-ballooning dynamically balloons available kernel memory driven
 	  by the current usage of anonymous memory ("committed AS") and
