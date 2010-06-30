Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757438Ab0F3XDK (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Jun 2010 19:03:10 -0400
Received: from rcsinet10.oracle.com ([148.87.113.121]:51264 "EHLO
	rcsinet10.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754477Ab0F3XDH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Jun 2010 19:03:07 -0400
Message-ID: <4C2BCC5D.3080402@kernel.org>
Date: Wed, 30 Jun 2010 15:59:41 -0700
From: Yinghai Lu <yinghai@kernel.org>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.9) Gecko/20100317 SUSE/3.0.4-1.1.1 Thunderbird/3.0.4
MIME-Version: 1.0
To: Ram Pai <linuxram@us.ibm.com>, Jesse Barnes <jbarnes@virtuousgeek.org>,
       Linus Torvalds <torvalds@linux-foundation.org>
CC: linux-pci@vger.kernel.org, linux-kernel@vger.kernel.org,
       clemens@ladisch.de
Subject: Re: [RFC PATCH 1/1] PCI: skip release and reallocation of io port
 resources
References: <20100630211516.GA25991@us.ibm.com>
In-Reply-To: <20100630211516.GA25991@us.ibm.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Source-IP: acsmt355.oracle.com [141.146.40.155]
X-Auth-Type: Internal IP
X-CT-RefId: str=0001.0A090207.4C2BCD1C.0298,ss=1,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/30/2010 02:15 PM, Ram Pai wrote:
>        PCI: skip release and reallocation of io port resources
>     
>        git commit 977d17bb1749517b353874ccdc9b85abc7a58c2a
>        released  and   reallocated  all resources, ioport and memory, when 
>        allocation  of   any  resource   of  any  type failed. This  caused
>        failure to reallocate fragile  io  port  resources, as reported in
>     	https://bugzilla.kernel.org/show_bug.cgi?id=15960
>     
>        The problem was solved by reverting the commit, through
>        git commit 	769d9968e42c995eaaf61ac5583d998f32e0769a.
>     
>        However reverting the original patch fails MMIO resource allocation
>        for SRIOV PCI-Bars on some platforms. Especially on  platforms
>        where the BIOS is unaware of SRIOV resource BARs.
>     
>        The following code, an  idea  proposed by Yinghai Lu, skips release
>        and  re-allocation  of  io port  resources   if its  allocation has
>        not failed in the first place.
>     
>        This patch applies on top of patch corresponding to
>        git commit 977d17bb1749517b353874ccdc9b85abc7a58c2a
>     

for safe all, i would suggest

1. put back 
977d17bb1749517b353874ccdc9b85abc7a58c2a
2. and apply following patch.

[PATCH] pci: disable pci trying to reallocate pci bridge by default.

it broken Linus's Nouveau

bisected:to commit 977d17bb17
| PCI: update bridge resources to get more big ranges in PCI assign unssigned

so try disable it by default.

Signed-off-by: Yinghai Lu <yinghai@kernel.org>

---
 Documentation/kernel-parameters.txt |    6 ++++++
 drivers/pci/pci.c                   |    4 ++++
 drivers/pci/pci.h                   |    2 ++
 drivers/pci/setup-bus.c             |   14 +++++++++-----
 4 files changed, 21 insertions(+), 5 deletions(-)

Index: linux-2.6/Documentation/kernel-parameters.txt
===================================================================
--- linux-2.6.orig/Documentation/kernel-parameters.txt
+++ linux-2.6/Documentation/kernel-parameters.txt
@@ -2009,6 +2009,12 @@ and is between 256 and 4096 characters.
 				for broken drivers that don't call it.
 		skip_isa_align	[X86] do not align io start addr, so can
 				handle more pci cards
+		try=n		set the pci_try_num to reallocate the pci bridge resource
+				1: default
+				2: will set the num to max_depth, and try to reallocate res
+				   to get big range for the bridge. assume the pci peer root
+				   resource is right from _CRS or from hostbridge pci reg
+				   reading out.
 		firmware	[ARM] Do not re-enumerate the bus but instead
 				just use the configuration from the
 				bootloader. This is currently used on
Index: linux-2.6/drivers/pci/pci.c
===================================================================
--- linux-2.6.orig/drivers/pci/pci.c
+++ linux-2.6/drivers/pci/pci.c
@@ -2983,6 +2983,10 @@ static int __init pci_setup(char *str)
 				pci_no_aer();
 			} else if (!strcmp(str, "nodomains")) {
 				pci_no_domains();
+			} else if (!strncmp(str, "try=", 4)) {
+				int try_num = memparse(str + 4, &str);
+				if (try_num > 0)
+					pci_try_num = try_num;
 			} else if (!strncmp(str, "cbiosize=", 9)) {
 				pci_cardbus_io_size = memparse(str + 9, &str);
 			} else if (!strncmp(str, "cbmemsize=", 10)) {
Index: linux-2.6/drivers/pci/pci.h
===================================================================
--- linux-2.6.orig/drivers/pci/pci.h
+++ linux-2.6/drivers/pci/pci.h
@@ -212,6 +212,8 @@ static inline int pci_ari_enabled(struct
 	return bus->self && bus->self->ari_enabled;
 }
 
+extern int pci_try_num;
+
 #ifdef CONFIG_PCI_QUIRKS
 extern int pci_is_reassigndev(struct pci_dev *dev);
 resource_size_t pci_specified_resource_alignment(struct pci_dev *dev);
Index: linux-2.6/drivers/pci/setup-bus.c
===================================================================
--- linux-2.6.orig/drivers/pci/setup-bus.c
+++ linux-2.6/drivers/pci/setup-bus.c
@@ -869,6 +869,7 @@ static int __init pci_get_max_depth(void
  * second  and later try will clear small leaf bridge res
  * will stop till to the max  deepth if can not find good one
  */
+int pci_try_num = 1;
 void __init
 pci_assign_unassigned_resources(void)
 {
@@ -879,14 +880,17 @@ pci_assign_unassigned_resources(void)
 	unsigned long type_mask = IORESOURCE_IO | IORESOURCE_MEM |
 				  IORESOURCE_PREFETCH;
 	unsigned long failed_type;
-	int max_depth = pci_get_max_depth();
-	int pci_try_num;
 
 	head.next = NULL;
 
-	pci_try_num = max_depth + 1;
-	printk(KERN_DEBUG "PCI: max bus depth: %d pci_try_num: %d\n",
-		 max_depth, pci_try_num);
+	if (pci_try_num > 1) {
+		int max_depth = pci_get_max_depth();
+
+		if (max_depth + 1 > pci_try_num)
+			pci_try_num = max_depth + 1;
+		printk(KERN_DEBUG "PCI: max bus depth: %d pci_try_num: %d\n",
+			 max_depth, pci_try_num);
+	}
 
 again:
 	/* Depth first, calculate sizes and alignments of all
