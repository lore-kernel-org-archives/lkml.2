Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932424Ab1HFAR5 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Aug 2011 20:17:57 -0400
Received: from cantor2.suse.de ([195.135.220.15]:39622 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932374Ab1HFALn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Aug 2011 20:11:43 -0400
X-Mailbox-Line: From gregkh@clark.kroah.org Fri Aug  5 17:04:14 2011
Message-Id: <20110806000414.736692274@clark.kroah.org>
User-Agent: quilt/0.48-16.4
Date: Fri, 05 Aug 2011 17:03:49 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Don Dutile <ddutile@redhat.com>, Chris Wright <chrisw@sous-sol.org>,
        Jesse Barnes <jbarnes@virtuousgeek.org>
Subject: [31/50] PCI: ARI is a PCIe v2 feature
In-Reply-To: <20110806000419.GA28392@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.33-longterm review patch.  If anyone has any objections, please let us know.

------------------

From: Chris Wright <chrisw@sous-sol.org>

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
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/pci/pci.c |    7 ++++++-
 1 file changed, 6 insertions(+), 1 deletion(-)

--- a/drivers/pci/pci.c
+++ b/drivers/pci/pci.c
@@ -1528,7 +1528,7 @@ void pci_enable_ari(struct pci_dev *dev)
 {
 	int pos;
 	u32 cap;
-	u16 ctrl;
+	u16 flags, ctrl;
 	struct pci_dev *bridge;
 
 	if (!pci_is_pcie(dev) || dev->devfn)
@@ -1546,6 +1546,11 @@ void pci_enable_ari(struct pci_dev *dev)
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


