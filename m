Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932650Ab2BBRlk (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Feb 2012 12:41:40 -0500
Received: from e28smtp02.in.ibm.com ([122.248.162.2]:35774 "EHLO
	e28smtp02.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932602Ab2BBRlh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Feb 2012 12:41:37 -0500
Date: Thu, 2 Feb 2012 23:11:20 +0530
From: Vaidyanathan Srinivasan <svaidy@linux.vnet.ibm.com>
To: Ram Pai <linuxram@us.ibm.com>, Jesse Barnes <jbarnes@virtuousgeek.org>,
        Yinghai Lu <yinghai.lu@oracle.com>
Cc: linux-pci@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [BUGFIX][PATCH] pci: set pci sriov page size before reading SRIOV BAR
Message-ID: <20120202174120.GA3753@dirshya.in.ibm.com>
Reply-To: svaidy@linux.vnet.ibm.com
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
x-cbid: 12020217-5816-0000-0000-00000121F028
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Jesse,

The following patch fixes a regression introduced when an SRIOV card
is used as a PF in a 64k base page size configuration.

Reference: https://lkml.org/lkml/2012/2/1/165

Please queue this bugfix patch for the current release cycle.

Thanks,
Vaidy
---

    pci: set pci sriov page size before reading SRIOV BAR
    
    For an SRIOV device, PCI_SRIOV_SYS_PGSIZE should be set before
    the PCI_SRIOV_BAR are queried.  The sys pagesize defaults to 4k,
    so this change is required on powerpc box with 64k base page size.
    
    This is a regression caused due to moving SRIOV init to sriov_enable().
    
    | commit afd24ece5c76af87f6fc477f2747b83a764f161c
    | Author: Ram Pai <linuxram@us.ibm.com>
    
    | PCI: delay configuration of SRIOV capability
    | The SRIOV capability, namely page size and total_vfs of a device are
    | configured during enumeration phase of the device.  This can potentially
    | interfere with the PCI operations of the platform, if the IOV capability
    | of the device is not enabled.
    
    Signed-off-by: Vaidyanathan Srinivasan <svaidy@linux.vnet.ibm.com>
    Acked-by: Ram Pai <linuxram@us.ibm.com>

diff --git a/drivers/pci/iov.c b/drivers/pci/iov.c
index 0321fa3..0dab5ec 100644
--- a/drivers/pci/iov.c
+++ b/drivers/pci/iov.c
@@ -347,8 +347,6 @@ static int sriov_enable(struct pci_dev *dev, int nr_virtfn)
 			return rc;
 	}
 
-	pci_write_config_dword(dev, iov->pos + PCI_SRIOV_SYS_PGSIZE, iov->pgsz);
-
 	iov->ctrl |= PCI_SRIOV_CTRL_VFE | PCI_SRIOV_CTRL_MSE;
 	pci_cfg_access_lock(dev);
 	pci_write_config_word(dev, iov->pos + PCI_SRIOV_CTRL, iov->ctrl);
@@ -466,6 +464,7 @@ found:
 		return -EIO;
 
 	pgsz &= ~(pgsz - 1);
+	pci_write_config_dword(dev, pos + PCI_SRIOV_SYS_PGSIZE, pgsz);
 
 	nres = 0;
 	for (i = 0; i < PCI_SRIOV_NUM_BARS; i++) {

