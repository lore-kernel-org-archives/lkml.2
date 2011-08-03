Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755768Ab1HCWeR (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Aug 2011 18:34:17 -0400
Received: from mx1.redhat.com ([209.132.183.28]:7019 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755624Ab1HCWeL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Aug 2011 18:34:11 -0400
Date: Wed, 3 Aug 2011 18:34:07 -0400
From: Dave Jones <davej@redhat.com>
To: Linux Kernel <linux-kernel@vger.kernel.org>
Cc: tom.l.nguyen@intel.com, yanmin.zhang@intel.com
Subject: [rfc] suppress excessive AER output
Message-ID: <20110803223407.GA20646@redhat.com>
Mail-Followup-To: Dave Jones <davej@redhat.com>,
	Linux Kernel <linux-kernel@vger.kernel.org>, tom.l.nguyen@intel.com,
	yanmin.zhang@intel.com
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I have a machine that has developed some kind of problem with
its onboard ethernet.  It still boots, but spewed almost 1.5G of text
(2381585 instances of the warning below) before we realised what
was going on, and blacklisted the igb driver.

Is it worth logging every single error when we're flooding like this ?
It seems unlikely that we'll find useful information in amongst that much data
that wasn't already in the first 100 instances.

I picked 100 in the (untested) example patch below arbitarily, but the exact
value could be smaller, or slightly bigger..

could we do something like this maybe ?

	Dave

diff --git a/drivers/pci/pcie/aer/aerdrv_errprint.c b/drivers/pci/pcie/aer/aerdrv_errprint.c
index 3ea5173..4ec88c6 100644
--- a/drivers/pci/pcie/aer/aerdrv_errprint.c
+++ b/drivers/pci/pcie/aer/aerdrv_errprint.c
@@ -153,6 +153,17 @@ void aer_print_error(struct pci_dev *dev, struct aer_err_info *info)
 {
 	int id = ((dev->bus->number << 8) | dev->devfn);
 	char prefix[44];
+	static unsigned long aer_printk_limit = 0;
+
+	aer_printk_limit++;
+
+	if (aer_printk_limit > 100)
+		return;
+
+	if (aer_printk_limit == 100) {
+		printk(KERN_ERR "Reached limit of 100 AER errors. Further AER output suppressed.\n");
+		return;
+	}
 
 	snprintf(prefix, sizeof(prefix), "%s%s %s: ",
 		 (info->severity == AER_CORRECTABLE) ? KERN_WARNING : KERN_ERR,
