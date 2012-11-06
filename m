Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753223Ab2KFWBT (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Nov 2012 17:01:19 -0500
Received: from mail-gg0-f202.google.com ([209.85.161.202]:64848 "EHLO
	mail-gg0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753141Ab2KFWBR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Nov 2012 17:01:17 -0500
Date: Tue, 6 Nov 2012 15:01:15 -0700
From: Bjorn Helgaas <bhelgaas@google.com>
To: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Joe Perches <joe@perches.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        devel@driverdev.osuosl.org, Achim Leubner <achim_leubner@adaptec.com>,
        "James E.J. Bottomley" <JBottomley@parallels.com>,
        linux-scsi@vger.kernel.org
Subject: Re: linux-next: build failure after merge of the pci tree
Message-ID: <20121106220115.GA18812@google.com>
References: <20121106112729.994c25ccce521ab5aaf1f060@canb.auug.org.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20121106112729.994c25ccce521ab5aaf1f060@canb.auug.org.au>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Nov 06, 2012 at 11:27:29AM +1100, Stephen Rothwell wrote:
> Hi Bjorn,
> 
> After merging the pci tree, today's linux-next build (x86_64 allmodconfig)
> failed like this:
> ...

> drivers/scsi/gdth.c: In function 'gdth_init_pci':
> drivers/scsi/gdth.c:1111:34: error: lvalue required as left operand of assignment

Here's what I think we should do about the GDT issue.  I'll send this
via the usual channels.

commit c6156dd31228e608e0a820d2eed7403fd1fd620b
Author: Bjorn Helgaas <bhelgaas@google.com>
Date:   Tue Nov 6 14:19:03 2012 -0700

    [SCSI] gdth: Remove buggy ROM handling
    
    The ROM address handling in gdth_init_pci() is useless and possibly
    dangerous.  This patch removes it.
    
    "pci_resource_start(pdev, 8)" is not well-defined.  PCI resources 0-5 are
    standard PCI BARs and 6 is the expansion ROM.  Resource 8 is either an
    SR-IOV BAR (if CONFIG_PCI_IOV=y, resources 7-12 are SR-IOV BARs) or a
    bridge window (resources 7-10).
    
    The GDT device is neither an SR-IOV device nor a bridge, so in either case
    resource 8 should be zero since struct pci_dev is allocated with kzalloc().
    
    It is illegal for a driver to write an arbitrary address to the ROM BAR
    because it has no way of knowing whether the ROM will conflict with another
    device.
    
    I think the only effect of the code being removed was to:
    
      1) Enable the ROM at 0xFEFF0000 (possibly causing a conflict with
         another device)
      2) Delay one millisecond
      3) Write zero to the ROM BAR, disabling it
    
    I doubt the delay is needed, but I left it since it seems innocuous.
    
    Signed-off-by: Bjorn Helgaas <bhelgaas@google.com>

diff --git a/drivers/scsi/gdth.c b/drivers/scsi/gdth.c
index 5d72274..3efe4ef 100644
--- a/drivers/scsi/gdth.c
+++ b/drivers/scsi/gdth.c
@@ -1107,14 +1107,8 @@ static int __devinit gdth_init_pci(struct pci_dev *pdev, gdth_pci_str *pcistr,
 	pci_read_config_word(pdev, PCI_COMMAND, &command);
         command |= 6;
 	pci_write_config_word(pdev, PCI_COMMAND, command);
-	if (pci_resource_start(pdev, 8) == 1UL)
-	    pci_resource_start(pdev, 8) = 0UL;
-        i = 0xFEFF0001UL;
-	pci_write_config_dword(pdev, PCI_ROM_ADDRESS, i);
-        gdth_delay(1);
-	pci_write_config_dword(pdev, PCI_ROM_ADDRESS,
-			       pci_resource_start(pdev, 8));
-        
+	gdth_delay(1);
+
         dp6m_ptr = ha->brd;
 
         /* Ensure that it is safe to access the non HW portions of DPMEM.

