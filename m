Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755144Ab3ADBAn (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Jan 2013 20:00:43 -0500
Received: from mail-ye0-f202.google.com ([209.85.213.202]:48022 "EHLO
	mail-ye0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754480Ab3ADBAj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Jan 2013 20:00:39 -0500
Date: Thu, 3 Jan 2013 18:00:38 -0700
From: Bjorn Helgaas <bhelgaas@google.com>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: "linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>,
        ACPI Devel Maling List <linux-acpi@vger.kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        LKML <linux-kernel@vger.kernel.org>, Tony Luck <tony.luck@intel.com>,
        "H. Peter Anvin" <hpa@zytor.com>, Yinghai Lu <yinghai@kernel.org>,
        Jiang Liu <liuj97@gmail.com>, Myron Stowe <myron.stowe@redhat.com>
Subject: Re: [Alternative 2][PATCH] ACPI / PCI: Set root bridge ACPI handle
 in advance
Message-ID: <20130104010038.GA11155@google.com>
References: <1558789.gX8cmBgyDV@vostro.rjw.lan>
 <1635295.TkbrarASZn@vostro.rjw.lan>
 <CAErSpo7QFKm=teLDBqCUueZwVHZKbA+pfNhrVc-_hK8PmwK2JQ@mail.gmail.com>
 <113112384.JZ1gZKlJRa@vostro.rjw.lan>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <113112384.JZ1gZKlJRa@vostro.rjw.lan>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jan 03, 2013 at 11:56:55PM +0100, Rafael J. Wysocki wrote:

> OK, I now have sent no less than three working version of the patch that fixes
> the current code which _is_ insane.  You haven't even responded to the last
> one, but for the first two the reason why you didn't like them was something
> similar to "it may conflict with some future changes I'm planning".  Well,
> that might be used to reject prety much any change and I'm not considering it
> as a good enough reason for blocking a fix.  Sorry about that.

I think your memory is faulty.  My response to the first
(https://lkml.org/lkml/2012/12/20/407) was "Thanks for cleaning this up, I
have an interface concern, here's an outline of a possible alternative."

My response to the second (https://lkml.org/lkml/2012/12/26/72) was "I like
this much better, Acked-by: Bjorn Helgaas."  Then Yinghai noticed the issue
with non-ACPI host bridges, and you abandoned that approach.

I took a few days of vacation, then spent the better part of yesterday
exploring the reasons why x86 and ia64 don't use the "parent" argument when
several other arches do, and worked up a patch
(https://lkml.org/lkml/2013/1/2/285).  It turned out to have a fatal flaw,
but was done in good faith.

It's true I haven't responded to the third one, posted about 12 hours ago.

I still like the approach of the second patch.  What would you think
of the following incremental change to it?  I did reproduce Yinghai's
issue with non-ACPI host bridges, and this change resolves it for me.

diff -u b/arch/x86/pci/acpi.c b/arch/x86/pci/acpi.c
--- b/arch/x86/pci/acpi.c
+++ b/arch/x86/pci/acpi.c
@@ -522,6 +522,7 @@
 	sd = &info->sd;
 	sd->domain = domain;
 	sd->node = node;
+	sd->acpi_handle = device->handle;
 	/*
 	 * Maybe the desired pci bus has been already scanned. In such case
 	 * it is unnecessary to scan the pci bus with the given domain,busnum.
@@ -596,9 +597,8 @@
 int pcibios_root_bridge_prepare(struct pci_host_bridge *bridge)
 {
 	struct pci_sysdata *sd = bridge->bus->sysdata;
-	struct pci_root_info *info = container_of(sd, struct pci_root_info, sd);
 
-	ACPI_HANDLE_SET(&bridge->dev, info->bridge->handle);
+	ACPI_HANDLE_SET(&bridge->dev, sd->acpi_handle);
 	return 0;
 }
 
--- a/arch/x86/include/asm/pci.h
+++ b/arch/x86/include/asm/pci.h
@@ -14,6 +14,7 @@
 struct pci_sysdata {
 	int		domain;		/* PCI domain */
 	int		node;		/* NUMA node */
+	void		*acpi_handle;
 #ifdef CONFIG_X86_64
 	void		*iommu;		/* IOMMU private data */
 #endif

