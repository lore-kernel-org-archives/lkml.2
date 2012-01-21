Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757126Ab2AUKKl (ORCPT <rfc822;w@1wt.eu>);
	Sat, 21 Jan 2012 05:10:41 -0500
Received: from rcsinet15.oracle.com ([148.87.113.117]:16607 "EHLO
	rcsinet15.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755168Ab2AUKJQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 21 Jan 2012 05:09:16 -0500
From: Yinghai Lu <yinghai@kernel.org>
To: Jesse Barnes <jbarnes@virtuousgeek.org>
Cc: Ram Pai <linuxram@us.ibm.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        linux-pci@vger.kernel.org, linux-kernel@vger.kernel.org,
        Yinghai Lu <yinghai@kernel.org>
Subject: [PATCH 20/21] PCI: Make pci bridge reallocating enabled/disabled
Date: Sat, 21 Jan 2012 02:08:36 -0800
Message-Id: <1327140517-14811-21-git-send-email-yinghai@kernel.org>
X-Mailer: git-send-email 1.7.7
In-Reply-To: <1327140517-14811-1-git-send-email-yinghai@kernel.org>
References: <1327140517-14811-1-git-send-email-yinghai@kernel.org>
X-Source-IP: acsinet21.oracle.com [141.146.126.237]
X-Auth-Type: Internal IP
X-CT-RefId: str=0001.0A090208.4F1A8EC8.00C3,ss=1,re=0.000,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Let the user could enable and disable with pci=realloc=on or pci=realloc=off

Also
1. move variable and functions near the place they are used.
2. change macro to function
3. change related functions and variable to static and _init
4. update parameter description accordingly.

Signed-off-by: Yinghai Lu <yinghai@kernel.org>
---
 Documentation/kernel-parameters.txt |    7 +++++--
 drivers/pci/pci.c                   |    4 ++--
 drivers/pci/pci.h                   |    2 +-
 drivers/pci/setup-bus.c             |   25 ++++++++++++++++++-------
 4 files changed, 26 insertions(+), 12 deletions(-)

diff --git a/Documentation/kernel-parameters.txt b/Documentation/kernel-parameters.txt
index 81c287f..cd48b76 100644
--- a/Documentation/kernel-parameters.txt
+++ b/Documentation/kernel-parameters.txt
@@ -2067,8 +2067,11 @@ bytes respectively. Such letter suffixes can also be entirely omitted.
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
 
 	pcie_aspm=	[PCIE] Forcibly enable or disable PCIe Active State Power
 			Management.
diff --git a/drivers/pci/pci.c b/drivers/pci/pci.c
index 6f45a73..2576940 100644
--- a/drivers/pci/pci.c
+++ b/drivers/pci/pci.c
@@ -3564,8 +3564,8 @@ static int __init pci_setup(char *str)
 				pci_no_msi();
 			} else if (!strcmp(str, "noaer")) {
 				pci_no_aer();
-			} else if (!strncmp(str, "realloc", 7)) {
-				pci_realloc();
+			} else if (!strncmp(str, "realloc=", 8)) {
+				pci_realloc_get_opt(str + 8);
 			} else if (!strcmp(str, "nodomains")) {
 				pci_no_domains();
 			} else if (!strncmp(str, "cbiosize=", 9)) {
diff --git a/drivers/pci/pci.h b/drivers/pci/pci.h
index b74084e..2f87579 100644
--- a/drivers/pci/pci.h
+++ b/drivers/pci/pci.h
@@ -146,7 +146,7 @@ static inline void pci_no_msi(void) { }
 static inline void pci_msi_init_pci_dev(struct pci_dev *dev) { }
 #endif
 
-extern void pci_realloc(void);
+void pci_realloc_get_opt(char *);
 
 static inline int pci_no_d1d2(struct pci_dev *dev)
 {
diff --git a/drivers/pci/setup-bus.c b/drivers/pci/setup-bus.c
index c22be02..1c97e14 100644
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
@@ -1259,6 +1252,24 @@ static int __init pci_get_max_depth(void)
 	return depth;
 }
 
+/*
+ * -1: undefined, will auto detect later
+ *  0: disabled by user
+ *  1: enabled by user
+ *  2: enabled by auto detect
+ */
+static int pci_realloc_enable __initdata = -1;
+void __init pci_realloc_get_opt(char *str)
+{
+	if (!strncmp(str, "off", 3))
+		pci_realloc_enable = 0;
+	else if (!strncmp(str, "on", 2))
+		pci_realloc_enable = 1;
+}
+static bool __init pci_realloc_enabled(void)
+{
+	return pci_realloc_enable > 0;
+}
 
 /*
  * first try will not touch pci bridge res
-- 
1.7.7

