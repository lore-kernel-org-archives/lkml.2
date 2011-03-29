Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753970Ab1C2Qqn (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Mar 2011 12:46:43 -0400
Received: from rcsinet10.oracle.com ([148.87.113.121]:57115 "EHLO
	rcsinet10.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752460Ab1C2Qql (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Mar 2011 12:46:41 -0400
Date: Tue, 29 Mar 2011 09:45:57 -0700
From: Randy Dunlap <randy.dunlap@oracle.com>
To: OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>
Cc: Shyam_Iyer@Dell.com, jbarnes@virtuousgeek.org, mjg59@srcf.ucam.org,
        Narendra_K@Dell.com, viro@zeniv.linux.org.uk, sfr@canb.auug.org.au,
        linux-kernel@vger.kernel.org, linux-next@vger.kernel.org,
        Matt_Domsch@Dell.com, Charles_Rose@Dell.com, Jordan_Hargrave@Dell.com
Subject: [PATCH] pci-label: Fix build failure when CONFIG_NLS is set to 'm'
 by allmodconfig
Message-Id: <20110329094557.17cd57a1.randy.dunlap@oracle.com>
In-Reply-To: <8739m5519p.fsf@devron.myhome.or.jp>
References: <20110223131536.GA16707@fedora14-r610.blr.amer.dell.com>
	<20110223131734.GA6275@srcf.ucam.org>
	<20110304101509.7eef7475@jbarnes-desktop>
	<20110328080220.1390d28e.randy.dunlap@oracle.com>
	<DBFB1B45AF80394ABD1C807E9F28D15702659CFB3D@BLRX7MCDC203.AMER.DELL.COM>
	<4D90EDE8.9070306@oracle.com>
	<87oc4u4rn4.fsf@devron.myhome.or.jp>
	<4D92063C.8040202@oracle.com>
	<8739m5519p.fsf@devron.myhome.or.jp>
Organization: Oracle Linux Eng.
X-Mailer: Sylpheed 2.7.1 (GTK+ 2.16.6; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Source-IP: acsmt358.oracle.com [141.146.40.158]
X-Auth-Type: Internal IP
X-CT-RefId: str=0001.0A090205.4D920CCA.0145,ss=1,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 30 Mar 2011 01:39:46 +0900 OGAWA Hirofumi wrote:

> Randy Dunlap <randy.dunlap@oracle.com> writes:
> 
> >> config PCI_LABEL
> >> 	bool
> >>         select NLS
> >>         depends on (DMI || ACPI)
> >
> > What sets/enables it then?
> > or did you mean:
> > 	def_bool y
> > and in that case, should it be a user-visible & user-changeable kconfig option?
> 
> Whoops, last line was missed by copy&paste. It meant
> 
> config PCI_LABEL
> 	bool
> 	select NLS
> 	depends on (DMI || ACPI)
>         default y
> 
> And no, it shouldn't be user-changeable (it would be better to
> invisible in .config. At make *config, already invisible.). Because
> PCI_LABEL is not user config and not used in Makefile.
> 
> And yeah, if you like def_bool
> 
> config PCI_LABEL
> 	def_bool y if (DMI || ACPI)
> 	select NLS
> 
> I guess it would work (it should be just syntax sugar and equivalent).


This patch seems to work for me.  Thanks.

---
From: Randy Dunlap <randy.dunlap@oracle.com>

Create a kconfig option symbol for PCI_LABEL and enable it
when DMI || ACPI are enabled.

Signed-off-by: Randy Dunlap <randy.dunlap@oracle.com>
---
 drivers/pci/Kconfig  |    4 +++-
 drivers/pci/Makefile |    4 ++--
 2 files changed, 5 insertions(+), 3 deletions(-)

--- linux-next-20110328.orig/drivers/pci/Kconfig
+++ linux-next-20110328/drivers/pci/Kconfig
@@ -88,4 +88,6 @@ config PCI_IOAPIC
 	depends on HOTPLUG
 	default y
 
-select NLS if (DMI || ACPI)
+config PCI_LABEL
+	def_bool y if (DMI || ACPI)
+	select NLS
--- linux-next-20110328.orig/drivers/pci/Makefile
+++ linux-next-20110328/drivers/pci/Makefile
@@ -56,10 +56,10 @@ obj-$(CONFIG_TILE) += setup-bus.o setup-
 # ACPI Related PCI FW Functions
 # ACPI _DSM provided firmware instance and string name
 #
-obj-$(CONFIG_ACPI)    += pci-acpi.o pci-label.o
+obj-$(CONFIG_ACPI)    += pci-acpi.o
 
 # SMBIOS provided firmware instance and labels
-obj-$(CONFIG_DMI)    += pci-label.o
+obj-$(CONFIG_PCI_LABEL) += pci-label.o
 
 # Cardbus & CompactPCI use setup-bus
 obj-$(CONFIG_HOTPLUG) += setup-bus.o
