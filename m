Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752888Ab1ANXHy (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Jan 2011 18:07:54 -0500
Received: from ogre.sisk.pl ([217.79.144.158]:37751 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752474Ab1ANXHw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Jan 2011 18:07:52 -0500
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Jesse Barnes <jbarnes@virtuousgeek.org>
Subject: Re: [git pull] PCI changes (link error)
Date: Sat, 15 Jan 2011 00:07:22 +0100
User-Agent: KMail/1.13.5 (Linux/2.6.37+; KDE/4.4.4; x86_64; ; )
Cc: Markus Trippelsdorf <markus@trippelsdorf.de>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        linux-pci@vger.kernel.org, linux-kernel@vger.kernel.org
References: <20110114090150.0a212030@jbarnes-desktop> <20110114221300.GA2366@gentoo.trippels.de> <20110114141526.10546dd5@jbarnes-desktop>
In-Reply-To: <20110114141526.10546dd5@jbarnes-desktop>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201101150007.23017.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday, January 14, 2011, Jesse Barnes wrote:
> On Fri, 14 Jan 2011 23:13:00 +0100
> Markus Trippelsdorf <markus@trippelsdorf.de> wrote:
> 
> > On 2011.01.14 at 23:01 +0100, Rafael J. Wysocki wrote:
> > > On Friday, January 14, 2011, Markus Trippelsdorf wrote:
> > > > On 2011.01.14 at 09:01 -0800, Jesse Barnes wrote:
> > > > > ...
> > > > > 
> > > > > Rafael J. Wysocki (5):
> > > > >       PCI hotplug: Fix unexpected driver unregister in pciehp_acpi.c
> > > > >       PCI/PCIe: Clear Root PME Status bits early during system resume
> > > > >       PCI/ACPI: Request _OSC control once for each root bridge (v3)
> > > > 
> > > > This breaks the build if CONFIG_PCIEPORTBUS is not set:
> > > > 
> > > > ld: drivers/built-in.o: in function acpi_pci_root_add:pci_root.c(.devinit.text+0x2633): error: undefined reference to 'pcie_ports_disabled'
> > > 
> > > Does the appended patch help?
> > 
> > > +#ifdef CONFIG_PCIEPORTBUS
> > >  extern bool pcie_ports_disabled;
> > >  extern bool pcie_ports_auto;
> > > +#else
> > > +#define pcie_ports_disabled	true
> > > +#define bool pcie_ports_auto	false
> > > +#endif
> > 
> > No, but this one does ;-):
> > 
> > 
> > diff --git a/include/linux/pci.h b/include/linux/pci.h
> > index 9e67dcd..0f4ca55 100644
> > --- a/include/linux/pci.h
> > +++ b/include/linux/pci.h
> > @@ -993,8 +993,13 @@ extern void pci_restore_msi_state(struct pci_dev *dev);
> >  extern int pci_msi_enabled(void);
> >  #endif
> >  
> > +#ifdef CONFIG_PCIEPORTBUS
> >  extern bool pcie_ports_disabled;
> >  extern bool pcie_ports_auto;
> > +#else
> > +#define pcie_ports_disabled true
> > +#define pcie_ports_auto false
> > +#endif
> >  
> >  #ifndef CONFIG_PCIEASPM
> >  static inline int pcie_aspm_enabled(void)
> > 
> 
> Linus, can you just take this directly so the link error isn't in your
> tree any longer than necessary?

Below is a changelogged version, just in case. :-)

Thanks,
Rafael

---
From: Markus Trippelsdorf <markus@trippelsdorf.de>
Subject: PCI / ACPI: Fix build issue in pci_root.c for !CONFIG_PCIEPORTBUS

The compilation of drivers/acpi/pci_root.c fails if
CONFIG_PCIEPORTBUS is unset.  Fix the problem.

Signed-off-by: Rafael J. Wysocki <rjw@sisk.pl>
---
 include/linux/pci.h |    5 +++++
 1 file changed, 5 insertions(+)

Index: linux-2.6/include/linux/pci.h
===================================================================
--- linux-2.6.orig/include/linux/pci.h
+++ linux-2.6/include/linux/pci.h
@@ -993,8 +993,13 @@ extern void pci_restore_msi_state(struct
 extern int pci_msi_enabled(void);
 #endif
 
+#ifdef CONFIG_PCIEPORTBUS
 extern bool pcie_ports_disabled;
 extern bool pcie_ports_auto;
+#else
+#define pcie_ports_disabled	true
+#define pcie_ports_auto		false
+#endif
 
 #ifndef CONFIG_PCIEASPM
 static inline int pcie_aspm_enabled(void)
