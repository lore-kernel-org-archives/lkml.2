Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752371Ab1FYAS2 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Jun 2011 20:18:28 -0400
Received: from rcsinet10.oracle.com ([148.87.113.121]:26980 "EHLO
	rcsinet10.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751713Ab1FYAS0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Jun 2011 20:18:26 -0400
Message-ID: <4E052931.4010806@kernel.org>
Date: Fri, 24 Jun 2011 17:17:53 -0700
From: Yinghai Lu <yinghai@kernel.org>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.17) Gecko/20110414 SUSE/3.1.10 Thunderbird/3.1.10
MIME-Version: 1.0
To: Jesse Barnes <jbarnes@virtuousgeek.org>
CC: Linus Torvalds <torvalds@linux-foundation.org>, linux-pci@vger.kernel.org,
        linux-kernel@vger.kernel.org, Ram Pai <linuxram@us.ibm.com>
Subject: Re: [git pull] PCI fixes
References: <20110623133740.0cdaf204@jbarnes-desktop>	<BANLkTime_w_RLqU2dZV4zx9SEZaNTQoMNQ@mail.gmail.com>	<20110624085318.70bde05c@jbarnes-desktop>	<BANLkTinimDSWQaDcQj9nJj11juK2OCfLXg@mail.gmail.com>	<20110624091148.18f8959d@jbarnes-desktop>	<204d042e-86c0-41a5-80f0-e04d6b7adf25@email.android.com> <20110624170056.6056425e@jbarnes-desktop>
In-Reply-To: <20110624170056.6056425e@jbarnes-desktop>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Source-IP: acsinet22.oracle.com [141.146.126.238]
X-Auth-Type: Internal IP
X-CT-RefId: str=0001.0A090208.4E052934.0026,ss=1,re=0.000,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/24/2011 05:00 PM, Jesse Barnes wrote:
> On Fri, 24 Jun 2011 15:56:42 -0700
> Linus Torvalds <torvalds@linux-foundation.org> wrote:
> 
>>
>>
>>
>> Jesse Barnes <jbarnes@virtuousgeek.org> wrote:
>>>
>>> How about a boot param?  We've done similar things for _CRS, and it
>>> might give Yinghai and Ram some more flexibility in improving our
>>> dynamic resource allocation before enabling it again (if ever).
>>
>> I'm OK with that, but then I'd suggest against the currently not yet merged series that doesn't seem to work anyway...
>>
>> IOW, just a simple patch that disables the resource re-allocation, and enables it with some command line option.
> 
> Ok sounds good, thanks.

please check the draft one,  not sure if you like
pci=try=2
or
pci=reallocate_bridge


[PATCH] pci: disable pci trying to reallocate pci bridge by default.

| PCI: update bridge resources to get more big ranges when allocating space (again)
|	da7822e5ad71ec9b745b412639f1e5e0ba795a20

still too risky and cause some systems have problem.

Disable reallocating feature, So other user could use command line enable it
to enable it with "pci=try=2"

Signed-off-by: Yinghai Lu <yinghai@kernel.org>

---
 Documentation/kernel-parameters.txt |    6 ++++++
 drivers/pci/pci.c                   |    4 ++++
 drivers/pci/pci.h                   |    2 ++
 drivers/pci/setup-bus.c             |   15 +++++++++------
 4 files changed, 21 insertions(+), 6 deletions(-)

Index: linux-2.6/Documentation/kernel-parameters.txt
===================================================================
--- linux-2.6.orig/Documentation/kernel-parameters.txt
+++ linux-2.6/Documentation/kernel-parameters.txt
@@ -1980,6 +1980,12 @@ bytes respectively. Such letter suffixes
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
@@ -3485,6 +3485,10 @@ static int __init pci_setup(char *str)
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
@@ -223,6 +223,8 @@ static inline int pci_ari_enabled(struct
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
@@ -1030,6 +1030,7 @@ static int __init pci_get_max_depth(void
  * second  and later try will clear small leaf bridge res
  * will stop till to the max  deepth if can not find good one
  */
+int pci_try_num = 1;
 void __init
 pci_assign_unassigned_resources(void)
 {
@@ -1042,16 +1043,18 @@ pci_assign_unassigned_resources(void)
 	unsigned long type_mask = IORESOURCE_IO | IORESOURCE_MEM |
 				  IORESOURCE_PREFETCH;
 	unsigned long failed_type;
-	int max_depth = pci_get_max_depth();
-	int pci_try_num;
-
 
 	head.next = NULL;
 	add_list.next = NULL;
 
-	pci_try_num = max_depth + 1;
-	printk(KERN_DEBUG "PCI: max bus depth: %d pci_try_num: %d\n",
-		 max_depth, pci_try_num);
+	if (pci_try_num > 1) {
+		int max_depth = pci_get_max_depth();
+
+		if (max_depth + 1 > pci_try_num)
+			pci_try_num = max_depth + 1;
+		printk(KERN_DEBUG "PCI: max bus depth: %d pci_try_num: %d\n",
+			max_depth, pci_try_num);
+	}
 
 again:
 	/* Depth first, calculate sizes and alignments of all
