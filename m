Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756194Ab2JIPX5 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Oct 2012 11:23:57 -0400
Received: from moutng.kundenserver.de ([212.227.17.8]:49927 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753480Ab2JIPXu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Oct 2012 11:23:50 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Russell King <rmk+kernel@arm.linux.org.uk>
Cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        Arnd Bergmann <arnd@arndb.de>,
        Stefano Stabellini <stefano.stabellini@eu.citrix.com>,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        Jeremy Fitzhardinge <jeremy@goop.org>, xen-devel@lists.xensource.com
Subject: [PATCH 5/9] ARM: Xen: fix initial build problems:
Date: Tue,  9 Oct 2012 17:22:59 +0200
Message-Id: <1349796183-30648-6-git-send-email-arnd@arndb.de>
X-Mailer: git-send-email 1.7.10
In-Reply-To: <1349796183-30648-1-git-send-email-arnd@arndb.de>
References: <1349796183-30648-1-git-send-email-arnd@arndb.de>
X-Provags-ID: V02:K0:wonDB4PQGnkIHpBIToFyQGOp1BxaQQhDbrVUFMu/jE5
 pNfF+A9qryJ8vA8tLb8bX050UC/Nh+SdwRV6rix6YT7TcQfjp0
 vytJUOciR4R3OiSpqvVHvxhrI1QM2wN7Hojj/IQOeHywzX45Tf
 43io2aZlRHPDxc+A0v92bGE+ID5aeMEr53kIhG+k3nxbnfqggN
 NOGuM03fOP7vq8mrmswr2QhoujxlnX/Hd7UkyPfda4Soo3lj8W
 xfpCu8rc69bNblqBoU95vGZuQeG5zlvgChMfaDbcL3ovOn/UxJ
 8g1uHTdOpWKPjrtFpbJvhxGgLrgceK6EkJ+TvazCc2jPj5LBPq
 9R+/wh2L7o1t2rPc4YVbHAyYUkfU5hlB11488mtebOsdG8iU6v
 hs7faw/ByjL17NguB8J83HtolqglKXg72s=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* The XEN_BALLOON code requires the balloon infrastructure that is not
  getting built on ARM.

* The tmem hypercall is not available on ARM

* ARMv6 does not support cmpxchg on 16-bit words that are used in the

* sys-hypervisor.c needs to include linux/err.h in order to use the
  IS_ERR/PTR_ERR/ERR_PTR family of functions.

Signed-off-by: Arnd Bergmann <arnd@arndb.de>
Cc: Stefano Stabellini <stefano.stabellini@eu.citrix.com>
Cc: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
Cc: Jeremy Fitzhardinge <jeremy@goop.org>
Cc: xen-devel@lists.xensource.com
---
 arch/arm/Kconfig             |    1 +
 drivers/xen/Kconfig          |    2 ++
 drivers/xen/sys-hypervisor.c |    1 +
 3 files changed, 4 insertions(+)

diff --git a/arch/arm/Kconfig b/arch/arm/Kconfig
index 6d2f7f5..85eaac3 100644
--- a/arch/arm/Kconfig
+++ b/arch/arm/Kconfig
@@ -1846,6 +1846,7 @@ config XEN_DOM0
 config XEN
 	bool "Xen guest support on ARM (EXPERIMENTAL)"
 	depends on EXPERIMENTAL && ARM && OF
+	depends on !CPU_V6
 	help
 	  Say Y if you want to run Linux in a Virtual Machine on Xen on ARM.
 
diff --git a/drivers/xen/Kconfig b/drivers/xen/Kconfig
index d4dffcd..126d8ce 100644
--- a/drivers/xen/Kconfig
+++ b/drivers/xen/Kconfig
@@ -3,6 +3,7 @@ menu "Xen driver support"
 
 config XEN_BALLOON
 	bool "Xen memory balloon driver"
+	depends on !ARM
 	default y
 	help
 	  The balloon driver allows the Xen domain to request more memory from
@@ -145,6 +146,7 @@ config SWIOTLB_XEN
 
 config XEN_TMEM
 	bool
+	depends on !ARM
 	default y if (CLEANCACHE || FRONTSWAP)
 	help
 	  Shim to interface in-kernel Transcendent Memory hooks
diff --git a/drivers/xen/sys-hypervisor.c b/drivers/xen/sys-hypervisor.c
index 5e5ad7e..66a0a14 100644
--- a/drivers/xen/sys-hypervisor.c
+++ b/drivers/xen/sys-hypervisor.c
@@ -11,6 +11,7 @@
 #include <linux/kernel.h>
 #include <linux/module.h>
 #include <linux/kobject.h>
+#include <linux/err.h>
 
 #include <asm/xen/hypervisor.h>
 #include <asm/xen/hypercall.h>
-- 
1.7.10

