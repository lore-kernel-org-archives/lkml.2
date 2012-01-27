Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753678Ab2A0TK6 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Jan 2012 14:10:58 -0500
Received: from e28smtp02.in.ibm.com ([122.248.162.2]:39293 "EHLO
	e28smtp02.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753332Ab2A0TK5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Jan 2012 14:10:57 -0500
Date: Sat, 28 Jan 2012 00:40:32 +0530
From: Vaidyanathan Srinivasan <svaidy@linux.vnet.ibm.com>
To: Ram Pai <linuxram@us.ibm.com>, Jesse Barnes <jbarnes@virtuousgeek.org>,
        Yinghai Lu <yinghai.lu@oracle.com>
Cc: linux-pci@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [BUGFIX][PATCH] pci: check for 4k resource_size alignment in
 sriov_init
Message-ID: <20120127191032.GA22999@dirshya.in.ibm.com>
Reply-To: svaidy@linux.vnet.ibm.com
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
x-cbid: 12012719-5816-0000-0000-0000010D5FE2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Ram and Jesse,

I found a trivial issue with page size alignment check on IBM POWER
box with 64k base page size.  In sriov_init(), changing the check from
PAGE_SIZE (arch and config dependent) to HW_PAGE_SIZE (always 4k) was
required to use one of the sriov adapter as PF since the
resource_size() comes up as 0x8000 and PAGE_SIZE would be 0x10000 for
pseries boxes.

I think resource_size() could be less than SystemPageSize, but I would
like your comments/ack/nack on any consequences of checking for only
4k alignment here in a system with larger base page size.

Thanks,
Vaidy

---

    pci: check for 4k resource_size alignment in sriov_init
    
    pci sriov_init should check for 4k page size alignment of resource_size
    even if base page size is larger -- like 64k in powerpc.
    
    Signed-off-by: Vaidyanathan Srinivasan <svaidy@linux.vnet.ibm.com>

diff --git a/drivers/pci/iov.c b/drivers/pci/iov.c
index 0321fa3..5816fa0 100644
--- a/drivers/pci/iov.c
+++ b/drivers/pci/iov.c
@@ -474,7 +474,7 @@ found:
 				     pos + PCI_SRIOV_BAR + i * 4);
 		if (!res->flags)
 			continue;
-		if (resource_size(res) & (PAGE_SIZE - 1)) {
+		if (resource_size(res) & (HW_PAGE_SIZE - 1)) {
 			rc = -EIO;
 			goto failed;
 		}

