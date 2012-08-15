Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756439Ab2HOTts (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Aug 2012 15:49:48 -0400
Received: from mail1.windriver.com ([147.11.146.13]:62798 "EHLO
	mail1.windriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756320Ab2HOTtm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Aug 2012 15:49:42 -0400
From: Paul Gortmaker <paul.gortmaker@windriver.com>
To: <stable@vger.kernel.org>, <linux-kernel@vger.kernel.org>
CC: Sonny Rao <sonnyrao@us.ibm.com>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Paul Gortmaker <paul.gortmaker@windriver.com>
Subject: [v2.6.34-stable 031/165] powerpc/pci: Check devices status property when scanning OF tree
Date: Wed, 15 Aug 2012 15:46:15 -0400
Message-ID: <1345060109-9187-32-git-send-email-paul.gortmaker@windriver.com>
X-Mailer: git-send-email 1.7.12.rc2
In-Reply-To: <1345060109-9187-1-git-send-email-paul.gortmaker@windriver.com>
References: <1345060109-9187-1-git-send-email-paul.gortmaker@windriver.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Sonny Rao <sonnyrao@us.ibm.com>

                   -------------------
    This is a commit scheduled for the next v2.6.34 longterm release.
    http://git.kernel.org/?p=linux/kernel/git/paulg/longterm-queue-2.6.34.git
    If you see a problem with using this for longterm, please comment.
                   -------------------

commit 5b339bdf164d8aee394609768f7e2e4415b0252a upstream.

We ran into an issue where it looks like we're not properly ignoring a
pci device with a non-good status property when we walk the device tree
and instanciate the Linux side PCI devices.

However, the EEH init code does look for the property and disables EEH
on these devices. This leaves us in an inconsistent where we are poking
at a supposedly bad piece of hardware and RTAS will block our config
cycles because EEH isn't enabled anyway.

Signed-of-by: Sonny Rao <sonnyrao@linux.vnet.ibm.com>

Signed-off-by: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Signed-off-by: Paul Gortmaker <paul.gortmaker@windriver.com>
---
 arch/powerpc/kernel/pci_of_scan.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/arch/powerpc/kernel/pci_of_scan.c b/arch/powerpc/kernel/pci_of_scan.c
index cd11d5c..6ddb795f 100644
--- a/arch/powerpc/kernel/pci_of_scan.c
+++ b/arch/powerpc/kernel/pci_of_scan.c
@@ -310,6 +310,8 @@ static void __devinit __of_scan_bus(struct device_node *node,
 	/* Scan direct children */
 	for_each_child_of_node(node, child) {
 		pr_debug("  * %s\n", child->full_name);
+		if (!of_device_is_available(child))
+			continue;
 		reg = of_get_property(child, "reg", &reglen);
 		if (reg == NULL || reglen < 20)
 			continue;
-- 
1.7.12.rc2

