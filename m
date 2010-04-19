Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752029Ab0DSG4O (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Apr 2010 02:56:14 -0400
Received: from smtprelay01.ispgateway.de ([80.67.18.13]:44633 "EHLO
	smtprelay01.ispgateway.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751066Ab0DSG4N (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Apr 2010 02:56:13 -0400
Message-ID: <4BCBFE89.9070401@ladisch.de>
Date: Mon, 19 Apr 2010 08:56:09 +0200
From: Clemens Ladisch <clemens@ladisch.de>
User-Agent: Thunderbird 2.0.0.24 (Windows/20100228)
MIME-Version: 1.0
To: Yinghai Lu <yinghai@kernel.org>, Jesse Barnes <jbarnes@virtuousgeek.org>
CC: linux-pci@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [regression, bisected] Xonar DX invalid PCI I/O range since 977d17bb174
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Df-Sender: linux-kernel@cl.domainfactory-kunde.de
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I got the following bug report:
| After upgrading kernel from 2.6.32 to 2.6.34-rc4 my Xonar DX stopped
| working. Kernel log has:
| 
| [kernel] AV200 0000:09:04.0: PCI INT A -> GSI 17 (level, low) -> IRQ 17
| [kernel] invalid PCI I/O range
| [kernel] AV200 0000:09:04.0: PCI INT A disabled
| [kernel] ALSA device list:
| [kernel]   No soundcards found.
| 
| According to git bisect the culprit is:
| 
| commit 977d17bb1749517b353874ccdc9b85abc7a58c2a
| Author: Yinghai Lu <yinghai@kernel.org>
| Date:   Fri Jan 22 01:02:24 2010 -0800
| PCI: update bridge resources to get more big ranges in PCI assign unssigned

Unfortunately, the bug tracker is dead, so I cannot ask for further
information.  (If somebody renews the domain, this report will be at
<https://bugtrack.alsa-project.org/alsa-bug/view.php?id=4982>.)

The Xonar DX is a PCI chip with a 256-byte I/O range behind a PCI-E/PCI
bridge.  The driver code that caught this looks as follows:

	err = pci_enable_device(pci);
	...
	err = pci_request_regions(pci, DRIVER);
	...
	if (!(pci_resource_flags(pci, 0) & IORESOURCE_IO) ||
	    pci_resource_len(pci, 0) < OXYGEN_IO_SIZE) {
		snd_printk(KERN_ERR "invalid PCI I/O range\n");


Regards,
Clemens
