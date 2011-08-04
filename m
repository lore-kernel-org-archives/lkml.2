Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751903Ab1HDFzf (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Aug 2011 01:55:35 -0400
Received: from mga09.intel.com ([134.134.136.24]:44747 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750891Ab1HDFzS convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Aug 2011 01:55:18 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.67,315,1309762800"; 
   d="scan'208";a="35251341"
From: "Zhang, Yanmin" <yanmin.zhang@intel.com>
To: Dave Jones <davej@redhat.com>, Linux Kernel <linux-kernel@vger.kernel.org>
CC: "Nguyen, Tom L" <tom.l.nguyen@intel.com>,
        "Huang, Ying" <ying.huang@intel.com>
Date: Thu, 4 Aug 2011 13:54:19 +0800
Subject: RE: [rfc] suppress excessive AER output
Thread-Topic: [rfc] suppress excessive AER output
Thread-Index: AcxSLXixeN47dUE9Rvq0X5g1AfiqHAAPWeeg
Message-ID: <33AB447FBD802F4E932063B962385B3512D9615780@shsmsx501.ccr.corp.intel.com>
References: <20110803223407.GA20646@redhat.com>
In-Reply-To: <20110803223407.GA20646@redhat.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
acceptlanguage: en-US
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Dave,

How about adding a new module parameter aer_printk_limit, so user space could reset it any time?

Yanmin

-----Original Message-----
From: Dave Jones [mailto:davej@redhat.com] 
Sent: Thursday, August 04, 2011 6:34 AM
To: Linux Kernel
Cc: Nguyen, Tom L; Zhang, Yanmin
Subject: [rfc] suppress excessive AER output

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
