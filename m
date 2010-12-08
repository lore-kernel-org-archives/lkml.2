Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755370Ab0LHOtL (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Dec 2010 09:49:11 -0500
Received: from charlotte.tuxdriver.com ([70.61.120.58]:35895 "EHLO
	smtp.tuxdriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755312Ab0LHOtJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Dec 2010 09:49:09 -0500
From: Neil Horman <nhorman@tuxdriver.com>
To: linux-kernel@vger.kernel.org
Cc: Neil Horman <nhorman@tuxdriver.com>, linux-pci@vger.kernel.org,
        kexec@lists.infradead.org, Vivek Goyal <vgoyal@redhat.com>,
        Jesse Barnes <jbarnes@virtuousgeek.org>
Subject: [PATCH] Update MCP55 quirk to not affect non HyperTransport variants
Date: Wed,  8 Dec 2010 09:47:48 -0500
Message-Id: <1291819668-15624-1-git-send-email-nhorman@tuxdriver.com>
X-Mailer: git-send-email 1.7.2.3
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Score: -4.0 (----)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I wrote this quirk awhile ago to properly setup MCP55 chips on hypertransport
busses so that interrupts reached whatever cpu happend to boot the kdump kernel.
while that works well, it was recently shown to me that a a non-hypertransport
variant of the MCP55 exists, and on those system the register that this quirk
manipulates causes hangs if you write to it.  Since the quirk was only meant to
handle errors found on MCP55 chips that have a HT interface, this patch adds a
filter to make sure the chip is an HT capable before making the needed register
adjustment.  This lets the broken MCP55s work with kdump while not breaking the
non-HT variants.

Resolves https://bugzilla.kernel.org/show_bug.cgi?id=23952

Tested successfully by the reporter and myself.

Reported-by: Mathieu Bérard <mathieu@mberard.eu>
CC: linux-pci@vger.kernel.org
CC: kexec@lists.infradead.org
CC: Vivek Goyal <vgoyal@redhat.com>
CC: Jesse Barnes <jbarnes@virtuousgeek.org>
Signed-off-by: Neil Horman <nhorman@tuxdriver.com>
---
 drivers/pci/quirks.c |    3 +++
 1 files changed, 3 insertions(+), 0 deletions(-)

diff --git a/drivers/pci/quirks.c b/drivers/pci/quirks.c
index 6f9350c..313c0bd 100644
--- a/drivers/pci/quirks.c
+++ b/drivers/pci/quirks.c
@@ -2329,6 +2329,9 @@ static void __devinit nvbridge_check_legacy_irq_routing(struct pci_dev *dev)
 {
 	u32 cfg;
 
+	if (!pci_find_capability(dev, PCI_CAP_ID_HT))
+		return;
+
 	pci_read_config_dword(dev, 0x74, &cfg);
 
 	if (cfg & ((1 << 2) | (1 << 15))) {
-- 
1.7.2.3

