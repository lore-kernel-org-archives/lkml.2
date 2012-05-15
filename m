Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965381Ab2EOCj2 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 May 2012 22:39:28 -0400
Received: from mail.windriver.com ([147.11.1.11]:49788 "EHLO
	mail.windriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S964881Ab2EOCRr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 May 2012 22:17:47 -0400
From: Paul Gortmaker <paul.gortmaker@windriver.com>
To: <stable@kernel.org>, <linux-kernel@vger.kernel.org>
Subject: [34-longterm 132/179] PCI: ARI is a PCIe v2 feature
Date: Mon, 14 May 2012 22:13:48 -0400
Message-ID: <1337048075-6132-133-git-send-email-paul.gortmaker@windriver.com>
X-Mailer: git-send-email 1.7.9.6
In-Reply-To: <1337048075-6132-1-git-send-email-paul.gortmaker@windriver.com>
References: <1337048075-6132-1-git-send-email-paul.gortmaker@windriver.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Chris Wright <chrisw@sous-sol.org>

                   -------------------
    This is a commit scheduled for the next v2.6.34 longterm release.
    http://git.kernel.org/?p=linux/kernel/git/paulg/longterm-queue-2.6.34.git
    If you see a problem with using this for longterm, please comment.
                   -------------------

commit 864d296cf948aef0fa32b81407541572583f7572 upstream.

The function pci_enable_ari() may mistakenly set the downstream port
of a v1 PCIe switch in ARI Forwarding mode.  This is a PCIe v2 feature,
and with an SR-IOV device on that switch port believing the switch above
is ARI capable it may attempt to use functions 8-255, translating into
invalid (non-zero) device numbers for that bus.  This has been seen
to cause Completion Timeouts and general misbehaviour including hangs
and panics.

Acked-by: Don Dutile <ddutile@redhat.com>
Tested-by: Don Dutile <ddutile@redhat.com>
Signed-off-by: Chris Wright <chrisw@sous-sol.org>
Signed-off-by: Jesse Barnes <jbarnes@virtuousgeek.org>
Signed-off-by: Paul Gortmaker <paul.gortmaker@windriver.com>
---
 drivers/pci/pci.c |    7 ++++++-
 1 file changed, 6 insertions(+), 1 deletion(-)

diff --git a/drivers/pci/pci.c b/drivers/pci/pci.c
index 8abe983..2326637 100644
--- a/drivers/pci/pci.c
+++ b/drivers/pci/pci.c
@@ -1713,7 +1713,7 @@ void pci_enable_ari(struct pci_dev *dev)
 {
 	int pos;
 	u32 cap;
-	u16 ctrl;
+	u16 flags, ctrl;
 	struct pci_dev *bridge;
 
 	if (!pci_is_pcie(dev) || dev->devfn)
@@ -1731,6 +1731,11 @@ void pci_enable_ari(struct pci_dev *dev)
 	if (!pos)
 		return;
 
+	/* ARI is a PCIe v2 feature */
+	pci_read_config_word(bridge, pos + PCI_EXP_FLAGS, &flags);
+	if ((flags & PCI_EXP_FLAGS_VERS) < 2)
+		return;
+
 	pci_read_config_dword(bridge, pos + PCI_EXP_DEVCAP2, &cap);
 	if (!(cap & PCI_EXP_DEVCAP2_ARI))
 		return;
-- 
1.7.9.6

