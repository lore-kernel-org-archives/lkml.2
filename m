Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754735Ab1BWMyn (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Feb 2011 07:54:43 -0500
Received: from ausc60ps301.us.dell.com ([143.166.148.206]:30845 "EHLO
	ausc60ps301.us.dell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754272Ab1BWMyl convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Feb 2011 07:54:41 -0500
X-Loopcount0: from 10.175.216.249
From: <Narendra_K@Dell.com>
To: <viro@zeniv.linux.org.uk>, <jbarnes@virtuousgeek.org>
CC: <mjg@redhat.com>, <sfr@canb.auug.org.au>, <linux-kernel@vger.kernel.org>,
        <linux-next@vger.kernel.org>, <Shyam_Iyer@Dell.com>,
        <Matt_Domsch@Dell.com>, <Charles_Rose@Dell.com>,
        <Jordan_Hargrave@Dell.com>
Date: Wed, 23 Feb 2011 18:24:31 +0530
Subject: [PATCH] Fix build failure when CONFIG_NLS is set to 'm' by
 allmodconfig
Thread-Topic: [PATCH] Fix build failure when CONFIG_NLS is set to 'm' by
 allmodconfig
Thread-Index: AcvTWNBOthfjgu8bQQuG7xwRWJn8lg==
Message-ID: <20110223131536.GA16707@fedora14-r610.blr.amer.dell.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
user-agent: Mutt/1.5.21 (2010-09-15)
acceptlanguage: en-US
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

This patch fixes the build breakage as described in the post
http://marc.info/?l=linux-next&m=129478755528194&w=2 while compiling the
patch - http://marc.info/?l=linux-netdev&m=129846468529049&w=2 ([PATCH
V3] Export ACPI _DSM provided firmware instance number and string name
to sysfs).

Hi Al,

If this patch is acceptable, please consider for inclusion.

From: Narendra K <narendra_k@dell.com>
Subject: [PATCH] Fix build failure when CONFIG_NLS is set to 'm' by allmodconfig

This patch fixes the following build breakage introduced by the patch
'[PATCH V3] Export ACPI _DSM provided firmware instance number and string to
sysfs'.

drivers/built-in.o: In function `T.647':
pci-label.c:(.text+0x28514): undefined reference to `utf16s_to_utf8s'

This happens because 'make allmodconfig' sets CONFIG_NLS=m and makes
'utf16s_to_utf8s` unavailable to drivers/pci/pci-label.o which is built
into vmlinux.

This is fixed by making fs/nls/nls_base.c compile conditionally into
vmlinux by introducing a new config option CONFIG_NLS_BASE which is
selected by (ACPI || DMI || NLS).

Signed-off-by: Narendra K <narendra_k@dell.com>
---
 fs/Makefile     |    2 +-
 fs/nls/Kconfig  |   14 ++++++++++++++
 fs/nls/Makefile |    2 +-
 3 files changed, 16 insertions(+), 2 deletions(-)

diff --git a/fs/Makefile b/fs/Makefile
index a7f7cef..1e78b9b 100644
--- a/fs/Makefile
+++ b/fs/Makefile
@@ -86,7 +86,7 @@ obj-$(CONFIG_NFS_FS)		+= nfs/
 obj-$(CONFIG_EXPORTFS)		+= exportfs/
 obj-$(CONFIG_NFSD)		+= nfsd/
 obj-$(CONFIG_LOCKD)		+= lockd/
-obj-$(CONFIG_NLS)		+= nls/
+obj-y				+= nls/
 obj-$(CONFIG_SYSV_FS)		+= sysv/
 obj-$(CONFIG_CIFS)		+= cifs/
 obj-$(CONFIG_NCP_FS)		+= ncpfs/
diff --git a/fs/nls/Kconfig b/fs/nls/Kconfig
index a39edc4..2fb92e5 100644
--- a/fs/nls/Kconfig
+++ b/fs/nls/Kconfig
@@ -4,6 +4,7 @@
 
 menuconfig NLS
 	tristate "Native language support"
+	select NLS_BASE
 	---help---
 	  The base Native Language Support. A number of filesystems
 	  depend on it (e.g. FAT, JOLIET, NT, BEOS filesystems), as well
@@ -17,6 +18,19 @@ menuconfig NLS
 
 if NLS
 
+config NLS_BASE
+	bool "Base NLS functions"
+	depends on ACPI || DMI
+	default y
+	---help---
+	  The base NLS support functions which handle unicode traslations.
+
+	  If unsure, say Y.
+
+	  This config option is selected by ACPI && DMI && NLS as the
+	  functions defined here are needed in vmlinux and if built as
+	  module cause build issues.
+
 config NLS_DEFAULT
 	string "Default NLS Option"
 	default "iso8859-1"
diff --git a/fs/nls/Makefile b/fs/nls/Makefile
index f499dd7..dde741f 100644
--- a/fs/nls/Makefile
+++ b/fs/nls/Makefile
@@ -2,7 +2,7 @@
 # Makefile for native language support
 #
 
-obj-$(CONFIG_NLS)		+= nls_base.o
+obj-$(CONFIG_NLS_BASE)		+= nls_base.o
 
 obj-$(CONFIG_NLS_CODEPAGE_437)	+= nls_cp437.o
 obj-$(CONFIG_NLS_CODEPAGE_737)	+= nls_cp737.o
-- 
1.7.3.1

With regards,
Narendra K