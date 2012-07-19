Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752814Ab2GSOoZ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Jul 2012 10:44:25 -0400
Received: from e35.co.us.ibm.com ([32.97.110.153]:52245 "EHLO
	e35.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752639Ab2GSOnh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Jul 2012 10:43:37 -0400
From: Seth Jennings <sjenning@linux.vnet.ibm.com>
To: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Cc: Seth Jennings <sjenning@linux.vnet.ibm.com>,
        Paul Mackerras <paulus@samba.org>,
        Herbert Xu <herbert@gondor.hengli.com.au>,
        "David S. Miller" <davem@davemloft.net>,
        Robert Jennings <rcj@linux.vnet.ibm.com>,
        Jeff Kirsher <jeffrey.t.kirsher@intel.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Kent Yoder <key@linux.vnet.ibm.com>, linux-kernel@vger.kernel.org,
        linuxppc-dev@lists.ozlabs.org, linux-crypto@vger.kernel.org
Subject: [PATCH 1/4] powerpc/crypto: rework Kconfig
Date: Thu, 19 Jul 2012 09:42:38 -0500
Message-Id: <1342708961-28587-2-git-send-email-sjenning@linux.vnet.ibm.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1342708961-28587-1-git-send-email-sjenning@linux.vnet.ibm.com>
References: <1342708961-28587-1-git-send-email-sjenning@linux.vnet.ibm.com>
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 12071914-6148-0000-0000-000007CBEDBE
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch creates a new submenu for the NX cryptographic
hardware accelerator and breaks the NX options into their own
Kconfig file under drivers/crypto/nx/Kconfig.

This will permit additional NX functionality to be easily
and more cleanly added in the future without touching
drivers/crypto/Makefile|Kconfig.

Signed-off-by: Seth Jennings <sjenning@linux.vnet.ibm.com>
---
 drivers/crypto/Kconfig     |   20 +++++++-------------
 drivers/crypto/nx/Kconfig  |   17 +++++++++++++++++
 drivers/crypto/nx/Makefile |    2 +-
 3 files changed, 25 insertions(+), 14 deletions(-)
 create mode 100644 drivers/crypto/nx/Kconfig

diff --git a/drivers/crypto/Kconfig b/drivers/crypto/Kconfig
index 7d74d09..662588a 100644
--- a/drivers/crypto/Kconfig
+++ b/drivers/crypto/Kconfig
@@ -298,21 +298,15 @@ config CRYPTO_DEV_TEGRA_AES
 	  will be called tegra-aes.
 
 config CRYPTO_DEV_NX
-	tristate "Support for Power7+ in-Nest cryptographic acceleration"
+	bool "Support for IBM Power7+ in-Nest cryptographic acceleration"
 	depends on PPC64 && IBMVIO
-	select CRYPTO_AES
-	select CRYPTO_CBC
-	select CRYPTO_ECB
-	select CRYPTO_CCM
-	select CRYPTO_GCM
-	select CRYPTO_AUTHENC
-	select CRYPTO_XCBC
-	select CRYPTO_SHA256
-	select CRYPTO_SHA512
+	default n
 	help
-	  Support for Power7+ in-Nest cryptographic acceleration. This
-	  module supports acceleration for AES and SHA2 algorithms. If you
-	  choose 'M' here, this module will be called nx_crypto.
+	  Support for Power7+ in-Nest cryptographic acceleration.
+
+if CRYPTO_DEV_NX
+	source "drivers/crypto/nx/Kconfig"
+endif
 
 config CRYPTO_DEV_UX500
 	tristate "Driver for ST-Ericsson UX500 crypto hardware acceleration"
diff --git a/drivers/crypto/nx/Kconfig b/drivers/crypto/nx/Kconfig
new file mode 100644
index 0000000..dedde53
--- /dev/null
+++ b/drivers/crypto/nx/Kconfig
@@ -0,0 +1,17 @@
+config CRYPTO_DEV_NX_ENCRYPT
+	tristate "Encryption acceleration support"
+	depends on PPC64 && IBMVIO
+	default y
+	select CRYPTO_AES
+	select CRYPTO_CBC
+	select CRYPTO_ECB
+	select CRYPTO_CCM
+	select CRYPTO_GCM
+	select CRYPTO_AUTHENC
+	select CRYPTO_XCBC
+	select CRYPTO_SHA256
+	select CRYPTO_SHA512
+	help
+	  Support for Power7+ in-Nest encryption acceleration. This
+	  module supports acceleration for AES and SHA2 algorithms. If you
+	  choose 'M' here, this module will be called nx_crypto.
diff --git a/drivers/crypto/nx/Makefile b/drivers/crypto/nx/Makefile
index 411ce59..7f110e4 100644
--- a/drivers/crypto/nx/Makefile
+++ b/drivers/crypto/nx/Makefile
@@ -1,4 +1,4 @@
-obj-$(CONFIG_CRYPTO_DEV_NX) += nx-crypto.o
+obj-$(CONFIG_CRYPTO_DEV_NX_ENCRYPT) += nx-crypto.o
 nx-crypto-objs := nx.o \
 		  nx_debugfs.o \
 		  nx-aes-cbc.o \
-- 
1.7.9.5

