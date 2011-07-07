Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755737Ab1GGSTr (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Jul 2011 14:19:47 -0400
Received: from e36.co.us.ibm.com ([32.97.110.154]:32943 "EHLO
	e36.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754241Ab1GGSTm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Jul 2011 14:19:42 -0400
Date: Thu, 7 Jul 2011 11:19:10 -0700
From: Ram Pai <linuxram@us.ibm.com>
To: Jesse Barnes <jbarnes@virtuousgeek.org>
Cc: Stephen Rothwell <sfr@canb.auug.org.au>, linux-next@vger.kernel.org,
        linux-kernel@vger.kernel.org, Ram Pai <linuxram@us.ibm.com>
Subject: Re: linux-next: build failure after merge of the pci-current tree
Message-ID: <20110707181910.GD3543@ram-ThinkPad-T61>
Reply-To: Ram Pai <linuxram@us.ibm.com>
References: <20110707105823.43343d2f9446f994f97cfd65@canb.auug.org.au>
 <20110707085205.7524a5a7@jbarnes-desktop>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110707085205.7524a5a7@jbarnes-desktop>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jul 07, 2011 at 08:52:05AM -0700, Jesse Barnes wrote:
> On Thu, 7 Jul 2011 10:58:23 +1000
> Stephen Rothwell <sfr@canb.auug.org.au> wrote:
> 
> > Hi Jesse,
> > 
> > After merging the pci-current tree, today's linux-next build (powerpc
> > ppc64_defconfig) failed like this:
> > 
> > drivers/built-in.o:(.toc1+0xb98): undefined reference to `pci_realloc'
> > 
> > Caused by commit 72007d2b4797 ("PCI: conditional resource-reallocation
> > through kernel parameter pci=realloc").
> > 
> > I have used the pci-current tree from next-20110706 for today.
> 
> Oops, x86 bits used in common code.  I've pushed a fix that just moves
> the variable into setup-bus.c rather than x86/pci/common.c.

Jesse,

	I have fixed the problem and have a better patch. See if it is acceptable for you.



> 
> Ram, did you see the microblaze patch I forwarded you?  It moves some
> re-alloc control flags into common code; for -next it might be cleaner
> to use them in a few places.  Any comments?


	Yes I have seen that forwarded mail. I will look through it.


Here is the patch.


commit 213e491e64a6c77f2e52abcb563a592964dd1074
Author: Ram Pai <linuxram@us.ibm.com>
Date:   Thu Jun 30 00:45:39 2011 -0700

    PCI: conditional resource-reallocation through kernel parameter pci=realloc
    
    Multiple attempts to dynamically reallocate pci resources have unfortunately
    lead to regressions. Though we continue to fix the regressions and fine tune the
    dynamic-reallocation behavior, we have not reached a acceptable state yet.
    
    This patch provides a interim solution. It disables dynamic-reallocation; by
    default, with the ability to enable it through pci=realloc kernel command line
    parameter.
    
    Signed-off-by: Ram Pai <linuxram@us.ibm.com>

Documentation/kernel-parameters.txt |    2 ++
drivers/pci/pci.c                   |    2 ++
drivers/pci/pci.h                   |    2 ++
drivers/pci/setup-bus.c             |   15 +++++++++++++++

diff --git a/Documentation/kernel-parameters.txt b/Documentation/kernel-parameters.txt
index fd248a31..aa47be7 100644
--- a/Documentation/kernel-parameters.txt
+++ b/Documentation/kernel-parameters.txt
@@ -2015,6 +2015,8 @@ bytes respectively. Such letter suffixes can also be entirely omitted.
 				the default.
 				off: Turn ECRC off
 				on: Turn ECRC on.
+		realloc		reallocate PCI resources if allocations done by BIOS
+				are erroneous.
 
 	pcie_aspm=	[PCIE] Forcibly enable or disable PCIe Active State Power
 			Management.
diff --git a/drivers/pci/pci.c b/drivers/pci/pci.c
index 5f10c23..7df8e3c 100644
--- a/drivers/pci/pci.c
+++ b/drivers/pci/pci.c
@@ -3483,6 +3483,8 @@ static int __init pci_setup(char *str)
 				pci_no_msi();
 			} else if (!strcmp(str, "noaer")) {
 				pci_no_aer();
+			} else if (!strncmp(str, "realloc", 7)) {
+				pci_realloc();
 			} else if (!strcmp(str, "nodomains")) {
 				pci_no_domains();
 			} else if (!strncmp(str, "cbiosize=", 9)) {
diff --git a/drivers/pci/pci.h b/drivers/pci/pci.h
index ebaf0ed..2b3f60b 100644
--- a/drivers/pci/pci.h
+++ b/drivers/pci/pci.h
@@ -146,6 +146,8 @@ static inline void pci_no_msi(void) { }
 static inline void pci_msi_init_pci_dev(struct pci_dev *dev) { }
 #endif
 
+extern void pci_realloc(void);
+
 static inline int pci_no_d1d2(struct pci_dev *dev)
 {
 	unsigned int parent_dstates = 0;
diff --git a/drivers/pci/setup-bus.c b/drivers/pci/setup-bus.c
index 68b4fce..f6616cb 100644
--- a/drivers/pci/setup-bus.c
+++ b/drivers/pci/setup-bus.c
@@ -48,6 +48,13 @@ struct resource_list_x {
 	(head)->next = NULL;				\
 } while (0)
 
+int pci_realloc_enable = 0;
+#define pci_realloc_enabled() pci_realloc_enable
+void pci_realloc(void)
+{
+	pci_realloc_enable = 1;
+}
+
 /**
  * add_to_list() - add a new resource tracker to the list
  * @head:	Head of the list
@@ -1091,6 +1098,7 @@ static int __init pci_get_max_depth(void)
 	return depth;
 }
 
+
 /*
  * first try will not touch pci bridge res
  * second  and later try will clear small leaf bridge res
@@ -1134,6 +1142,13 @@ again:
 	/* any device complain? */
 	if (!head.next)
 		goto enable_and_dump;
+
+	/* don't realloc if asked to do so */
+	if (!pci_realloc_enabled()) {
+		free_list(resource_list_x, &head);
+		goto enable_and_dump;
+	}
+
 	failed_type = 0;
 	for (list = head.next; list;) {
 		failed_type |= list->flags;
