Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757384Ab2IYVim (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Sep 2012 17:38:42 -0400
Received: from rcsinet15.oracle.com ([148.87.113.117]:51772 "EHLO
	rcsinet15.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753683Ab2IYVil (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Sep 2012 17:38:41 -0400
From: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
To: linux-kernel@vger.kernel.org, xen-devel@lists.xensource.com
Subject: [PATCH] fixes to xen-pciback for v3.7 (v1)
Date: Tue, 25 Sep 2012 17:27:18 -0400
Message-Id: <1348608440-4018-1-git-send-email-konrad.wilk@oracle.com>
X-Mailer: git-send-email 1.7.7.6
X-Source-IP: ucsinet21.oracle.com [156.151.31.93]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

One fixes that I thought I had fixed but not so. This was discovered
when trying to passthrough an PCIe network card to an PVHVM guest
and finding that it can't use MSIs. I thought I had it fixed with 
git commit 80ba77dfbce85f2d1be54847de3c866de1b18a9a
"xen/pciback: Fix proper FLR steps." but that fixed only one use
case (bind the device to xen-pciback, then unbind it).
    
The underlaying reason was that after we do an FLR (if the card supports it),
we also do a D3 (so turn off the PCIe card), then followed by a D0
(power is back).  However we did not the follow the rest of the process
that pci_reset_function does - restore the device's PCI configuration state!

(Note: We cannot use pci_reset_function as it holds a mutex that we
hold as well - so we use the low-level reset functions that we can
invoke and hold a mutex - and we forgot to do the right calls that
pci_reset_function does).

With this patch:
 [PATCH 1/2] xen/pciback: Restore the PCI config space after an FLR.

I can pass through an PCIe e1000e card succesfully to my Win7 and Linux
guest.

This patch:
 [PATCH 2/2] xen/pciback: When resetting the device don't disable

is just a cleanup.
