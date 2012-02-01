Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757730Ab2BAWuJ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Feb 2012 17:50:09 -0500
Received: from acsinet15.oracle.com ([141.146.126.227]:33220 "EHLO
	acsinet15.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757561Ab2BAWnS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Feb 2012 17:43:18 -0500
From: Yinghai Lu <yinghai@kernel.org>
To: Jesse Barnes <jbarnes@virtuousgeek.org>
Cc: Ram Pai <linuxram@us.ibm.com>,
        "Cc: Dominik Brodowski" <linux@dominikbrodowski.net>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        linux-pci@vger.kernel.org, linux-kernel@vger.kernel.org,
        Yinghai Lu <yinghai@kernel.org>
Subject: [PATCH 5/7] PCI: Make pci bridge reallocating enabled/disabled
Date: Wed,  1 Feb 2012 14:42:48 -0800
Message-Id: <1328136170-17613-6-git-send-email-yinghai@kernel.org>
X-Mailer: git-send-email 1.7.7
In-Reply-To: <1328136170-17613-1-git-send-email-yinghai@kernel.org>
References: <1328136170-17613-1-git-send-email-yinghai@kernel.org>
X-Source-IP: ucsinet21.oracle.com [156.151.31.93]
X-CT-RefId: str=0001.0A090208.4F29BFFA.011B,ss=1,re=0.000,fgs=0
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

Signed-off-by: Yinghai Lu <yinghai@kernel.org>
---
 Documentation/kernel-parameters.txt |    8 ++++++--
 drivers/pci/pci.c                   |    4 +++-
 drivers/pci/pci.h                   |    2 +-
 drivers/pci/setup-bus.c             |   33 ++++++++++++++++++++++++++-------
 4 files changed, 36 insertions(+), 11 deletions(-)

diff --git a/Documentation/kernel-parameters.txt b/Documentation/kernel-parameters.txt
index 033d4e6..e11e5dd 100644
--- a/Documentation/kernel-parameters.txt
+++ b/Documentation/kernel-parameters.txt
@@ -2109,8 +2109,12 @@ bytes respectively. Such letter suffixes can also be entirely omitted.
 				the default.
 				off: Turn ECRC off
 				on: Turn ECRC on.
-		realloc		reallocate PCI resources if allocations done by BIOS
-				are erroneous.
+		realloc=	Enable/disable reallocating PCI bridge resources
+				if allocations done by BIOS are too small to fit
+				resources required by children devices.
+				off: Turn realloc off
+				on: Turn realloc on
+		realloc		same as realloc=on
 
 	pcie_aspm=	[PCIE] Forcibly enable or disable PCIe Active State Power
 			Management.
diff --git a/drivers/pci/pci.c b/drivers/pci/pci.c
index 9c89447..09cb1f2 100644
--- a/drivers/pci/pci.c
+++ b/drivers/pci/pci.c
@@ -3744,8 +3744,10 @@ static int __init pci_setup(char *str)
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
index aaf7ff8..f862a5a 100644
--- a/drivers/pci/pci.h
+++ b/drivers/pci/pci.h
@@ -148,7 +148,7 @@ static inline void pci_no_msi(void) { }
 static inline void pci_msi_init_pci_dev(struct pci_dev *dev) { }
 #endif
 
-extern void pci_realloc(void);
+void pci_realloc_get_opt(char *);
 
 static inline int pci_no_d1d2(struct pci_dev *dev)
 {
diff --git a/drivers/pci/setup-bus.c b/drivers/pci/setup-bus.c
index 162edfb..22454c5 100644
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
@@ -1273,6 +1266,32 @@ static int __init pci_get_max_depth(void)
 	return depth;
 }
 
+/*
+ * -1: undefined, will auto detect later
+ *  0: disabled by user
+ *  1: enabled by user
+ *  2: enabled by auto detect
+ */
+enum enable_type {
+	enable_not_set = -1,
+	enable_no_user,
+	enable_no_detected,
+	enable_yes_user,
+	enable_yes_detected,
+};
+
+static enum enable_type pci_realloc_enable __initdata = enable_not_set;
+void __init pci_realloc_get_opt(char *str)
+{
+	if (!strncmp(str, "off", 3))
+		pci_realloc_enable = enable_no_user;
+	else if (!strncmp(str, "on", 2))
+		pci_realloc_enable = enable_yes_user;
+}
+static bool __init pci_realloc_enabled(void)
+{
+	return pci_realloc_enable >= enable_yes_user;
+}
 
 /*
  * first try will not touch pci bridge res
-- 
1.7.7

