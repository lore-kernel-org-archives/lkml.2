Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755351Ab1IOH6z (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Sep 2011 03:58:55 -0400
Received: from nat28.tlf.novell.com ([130.57.49.28]:49705 "EHLO
	nat28.tlf.novell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755307Ab1IOH6y convert rfc822-to-8bit (ORCPT
	<rfc822;groupwise-JBeulich@suse.com:3:1>);
	Thu, 15 Sep 2011 03:58:54 -0400
Message-Id: <4E71CC5B020000780005636B@nat28.tlf.novell.com>
X-Mailer: Novell GroupWise Internet Agent 8.0.1 
Date: Thu, 15 Sep 2011 08:58:51 +0100
From: "Jan Beulich" <JBeulich@suse.com>
To: <mingo@elte.hu>, <tglx@linutronix.de>,
        "Jesse Barnes" <jbarnes@virtuousgeek.org>, <hpa@zytor.com>
Cc: <linux-kernel@vger.kernel.org>
Subject: [PATCH, resend] x86: constify PCI raw ops structures
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

As with any other such change, the goal is to prevent inadvertent
writes to these structures (assuming DEBUG_RODATA is enabled), and to
separate data (possibly frequently) written to from such never getting
modified.

Signed-off-by: Jan Beulich <jbeulich@novell.com>

---
 arch/x86/include/asm/pci_x86.h |    6 +++---
 arch/x86/pci/ce4100.c          |    2 +-
 arch/x86/pci/common.c          |    4 ++--
 arch/x86/pci/direct.c          |    6 +++---
 arch/x86/pci/mmconfig_32.c     |    2 +-
 arch/x86/pci/mmconfig_64.c     |    2 +-
 arch/x86/pci/numaq_32.c        |    2 +-
 arch/x86/pci/olpc.c            |    2 +-
 arch/x86/pci/pcbios.c          |    4 ++--
 9 files changed, 15 insertions(+), 15 deletions(-)

--- 3.1-rc6/arch/x86/include/asm/pci_x86.h
+++ 3.1-rc6-x86-pci-raw-ops-const/arch/x86/include/asm/pci_x86.h
@@ -99,10 +99,10 @@ struct pci_raw_ops {
 						int reg, int len, u32 val);
 };
 
-extern struct pci_raw_ops *raw_pci_ops;
-extern struct pci_raw_ops *raw_pci_ext_ops;
+extern const struct pci_raw_ops *raw_pci_ops;
+extern const struct pci_raw_ops *raw_pci_ext_ops;
 
-extern struct pci_raw_ops pci_direct_conf1;
+extern const struct pci_raw_ops pci_direct_conf1;
 extern bool port_cf9_safe;
 
 /* arch_initcall level */
--- 3.1-rc6/arch/x86/pci/ce4100.c
+++ 3.1-rc6-x86-pci-raw-ops-const/arch/x86/pci/ce4100.c
@@ -304,7 +304,7 @@ static int ce4100_conf_write(unsigned in
 	return pci_direct_conf1.write(seg, bus, devfn, reg, len, value);
 }
 
-struct pci_raw_ops ce4100_pci_conf = {
+static const struct pci_raw_ops ce4100_pci_conf = {
 	.read =	ce4100_conf_read,
 	.write = ce4100_conf_write,
 };
--- 3.1-rc6/arch/x86/pci/common.c
+++ 3.1-rc6-x86-pci-raw-ops-const/arch/x86/pci/common.c
@@ -33,8 +33,8 @@ int noioapicreroute = 1;
 int pcibios_last_bus = -1;
 unsigned long pirq_table_addr;
 struct pci_bus *pci_root_bus;
-struct pci_raw_ops *raw_pci_ops;
-struct pci_raw_ops *raw_pci_ext_ops;
+const struct pci_raw_ops *__read_mostly raw_pci_ops;
+const struct pci_raw_ops *__read_mostly raw_pci_ext_ops;
 
 int raw_pci_read(unsigned int domain, unsigned int bus, unsigned int devfn,
 						int reg, int len, u32 *val)
--- 3.1-rc6/arch/x86/pci/direct.c
+++ 3.1-rc6-x86-pci-raw-ops-const/arch/x86/pci/direct.c
@@ -79,7 +79,7 @@ static int pci_conf1_write(unsigned int
 
 #undef PCI_CONF1_ADDRESS
 
-struct pci_raw_ops pci_direct_conf1 = {
+const struct pci_raw_ops pci_direct_conf1 = {
 	.read =		pci_conf1_read,
 	.write =	pci_conf1_write,
 };
@@ -175,7 +175,7 @@ static int pci_conf2_write(unsigned int
 
 #undef PCI_CONF2_ADDRESS
 
-struct pci_raw_ops pci_direct_conf2 = {
+static const struct pci_raw_ops pci_direct_conf2 = {
 	.read =		pci_conf2_read,
 	.write =	pci_conf2_write,
 };
@@ -191,7 +191,7 @@ struct pci_raw_ops pci_direct_conf2 = {
  * This should be close to trivial, but it isn't, because there are buggy
  * chipsets (yes, you guessed it, by Intel and Compaq) that have no class ID.
  */
-static int __init pci_sanity_check(struct pci_raw_ops *o)
+static int __init pci_sanity_check(const struct pci_raw_ops *o)
 {
 	u32 x = 0;
 	int year, devfn;
--- 3.1-rc6/arch/x86/pci/mmconfig_32.c
+++ 3.1-rc6-x86-pci-raw-ops-const/arch/x86/pci/mmconfig_32.c
@@ -117,7 +117,7 @@ static int pci_mmcfg_write(unsigned int
 	return 0;
 }
 
-static struct pci_raw_ops pci_mmcfg = {
+static const struct pci_raw_ops pci_mmcfg = {
 	.read =		pci_mmcfg_read,
 	.write =	pci_mmcfg_write,
 };
--- 3.1-rc6/arch/x86/pci/mmconfig_64.c
+++ 3.1-rc6-x86-pci-raw-ops-const/arch/x86/pci/mmconfig_64.c
@@ -81,7 +81,7 @@ static int pci_mmcfg_write(unsigned int
 	return 0;
 }
 
-static struct pci_raw_ops pci_mmcfg = {
+static const struct pci_raw_ops pci_mmcfg = {
 	.read =		pci_mmcfg_read,
 	.write =	pci_mmcfg_write,
 };
--- 3.1-rc6/arch/x86/pci/numaq_32.c
+++ 3.1-rc6-x86-pci-raw-ops-const/arch/x86/pci/numaq_32.c
@@ -110,7 +110,7 @@ static int pci_conf1_mq_write(unsigned i
 
 #undef PCI_CONF1_MQ_ADDRESS
 
-static struct pci_raw_ops pci_direct_conf1_mq = {
+static const struct pci_raw_ops pci_direct_conf1_mq = {
 	.read	= pci_conf1_mq_read,
 	.write	= pci_conf1_mq_write
 };
--- 3.1-rc6/arch/x86/pci/olpc.c
+++ 3.1-rc6-x86-pci-raw-ops-const/arch/x86/pci/olpc.c
@@ -301,7 +301,7 @@ static int pci_olpc_write(unsigned int s
 	return 0;
 }
 
-static struct pci_raw_ops pci_olpc_conf = {
+static const struct pci_raw_ops pci_olpc_conf = {
 	.read =	pci_olpc_read,
 	.write = pci_olpc_write,
 };
--- 3.1-rc6/arch/x86/pci/pcbios.c
+++ 3.1-rc6-x86-pci-raw-ops-const/arch/x86/pci/pcbios.c
@@ -303,7 +303,7 @@ static int pci_bios_write(unsigned int s
  * Function table for BIOS32 access
  */
 
-static struct pci_raw_ops pci_bios_access = {
+static const struct pci_raw_ops pci_bios_access = {
 	.read =		pci_bios_read,
 	.write =	pci_bios_write
 };
@@ -312,7 +312,7 @@ static struct pci_raw_ops pci_bios_acces
  * Try to find PCI BIOS.
  */
 
-static struct pci_raw_ops * __devinit pci_find_bios(void)
+static const struct pci_raw_ops * __devinit pci_find_bios(void)
 {
 	union bios32 *check;
 	unsigned char sum;


