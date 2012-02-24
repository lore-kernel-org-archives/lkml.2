Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755398Ab2BXDYe (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Feb 2012 22:24:34 -0500
Received: from acsinet15.oracle.com ([141.146.126.227]:49518 "EHLO
	acsinet15.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755133Ab2BXDYD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Feb 2012 22:24:03 -0500
From: Yinghai Lu <yinghai@kernel.org>
To: Jesse Barnes <jbarnes@virtuousgeek.org>
Cc: Ram Pai <linuxram@us.ibm.com>,
        Dominik Brodowski <linux@dominikbrodowski.net>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        linux-pci@vger.kernel.org, linux-kernel@vger.kernel.org,
        Yinghai Lu <yinghai@kernel.org>
Subject: [PATCH 2/4] PCI: Make pci bridge reallocating enabled/disabled
Date: Thu, 23 Feb 2012 19:23:30 -0800
Message-Id: <1330053812-10316-3-git-send-email-yinghai@kernel.org>
X-Mailer: git-send-email 1.7.7
In-Reply-To: <1330053812-10316-1-git-send-email-yinghai@kernel.org>
References: <1330053812-10316-1-git-send-email-yinghai@kernel.org>
X-Source-IP: ucsinet21.oracle.com [156.151.31.93]
X-CT-RefId: str=0001.0A090203.4F4702CB.009B,ss=1,re=0.000,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Let the user could enable and disable with pci=realloc=on or pci=realloc=off

Also
1. move variable and functions near the place they are used.
2. change macro to function
3. change related functions and variable to static and _init
4. update parameter description accordingly.

-v2: still honor pci=realloc, and treat it as pci=realloc=on
     also use enum instead of ...
-v3: update kernel-paramenters.txt according to Jesse.

Signed-off-by: Yinghai Lu <yinghai@kernel.org>
Acked-by: Jesse Barnes <jbarnes@virtuousgeek.org>
---
 Documentation/kernel-parameters.txt |    9 +++++++--
 drivers/pci/pci.c                   |    4 +++-
 drivers/pci/pci.h                   |    2 +-
 drivers/pci/setup-bus.c             |   34 +++++++++++++++++++++++++++-------
 4 files changed, 38 insertions(+), 11 deletions(-)

diff --git a/Documentation/kernel-parameters.txt b/Documentation/kernel-parameters.txt
index 7fb7a4b..7dc523e 100644
--- a/Documentation/kernel-parameters.txt
+++ b/Documentation/kernel-parameters.txt
@@ -2109,8 +2109,13 @@ bytes respectively. Such letter suffixes can also be entirely omitted.
 				the default.
 				off: Turn ECRC off
 				on: Turn ECRC on.
-		realloc		reallocate PCI resources if allocations done by BIOS
-				are erroneous.
+		realloc=	Enable/disable reallocating PCI bridge resources
+				if allocations done by BIOS are too small to
+				accommodate resources required by all child
+				devices.
+				off: Turn realloc off
+				on: Turn realloc on
+		realloc		same as realloc=on
 
 	pcie_aspm=	[PCIE] Forcibly enable or disable PCIe Active State Power
 			Management.
diff --git a/drivers/pci/pci.c b/drivers/pci/pci.c
index 8f30736..e9f9dc1 100644
--- a/drivers/pci/pci.c
+++ b/drivers/pci/pci.c
@@ -3772,8 +3772,10 @@ static int __init pci_setup(char *str)
 				pci_no_msi();
 			} else if (!strcmp(str, "noaer")) {
 				pci_no_aer();
+			} else if (!strncmp(str, "realloc=", 8)) {
+				pci_realloc_get_opt(str + 8);
 			} else if (!strncmp(str, "realloc", 7)) {
-				pci_realloc();
+				pci_realloc_get_opt("on");
 			} else if (!strcmp(str, "nodomains")) {
 				pci_no_domains();
 			} else if (!strncmp(str, "cbiosize=", 9)) {
diff --git a/drivers/pci/pci.h b/drivers/pci/pci.h
index 586ac9b..1fc63b3 100644
--- a/drivers/pci/pci.h
+++ b/drivers/pci/pci.h
@@ -149,7 +149,7 @@ static inline void pci_no_msi(void) { }
 static inline void pci_msi_init_pci_dev(struct pci_dev *dev) { }
 #endif
 
-extern void pci_realloc(void);
+void pci_realloc_get_opt(char *);
 
 static inline int pci_no_d1d2(struct pci_dev *dev)
 {
diff --git a/drivers/pci/setup-bus.c b/drivers/pci/setup-bus.c
index 162edfb..219722d 100644
--- a/drivers/pci/setup-bus.c
+++ b/drivers/pci/setup-bus.c
@@ -48,13 +48,6 @@ static void free_list(struct list_head *head)
 	}
 }
 
-int pci_realloc_enable = 0;
-#define pci_realloc_enabled() pci_realloc_enable
-void pci_realloc(void)
-{
-	pci_realloc_enable = 1;
-}
-
 /**
  * add_to_list() - add a new resource tracker to the list
  * @head:	Head of the list
@@ -1273,6 +1266,33 @@ static int __init pci_get_max_depth(void)
 	return depth;
 }
 
+/*
+ * -1: undefined, will auto detect later
+ *  0: disabled by user
+ *  1: disabled by auto detect
+ *  2: enabled by user
+ *  3: enabled by auto detect
+ */
+enum enable_type {
+	undefined = -1,
+	user_disabled,
+	auto_disabled,
+	user_enabled,
+	auto_enabled,
+};
+
+static enum enable_type pci_realloc_enable __initdata = undefined;
+void __init pci_realloc_get_opt(char *str)
+{
+	if (!strncmp(str, "off", 3))
+		pci_realloc_enable = user_disabled;
+	else if (!strncmp(str, "on", 2))
+		pci_realloc_enable = user_enabled;
+}
+static bool __init pci_realloc_enabled(void)
+{
+	return pci_realloc_enable >= user_enabled;
+}
 
 /*
  * first try will not touch pci bridge res
-- 
1.7.7

