Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756666Ab1HXKnw (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Aug 2011 06:43:52 -0400
Received: from thoth.sbs.de ([192.35.17.2]:34550 "EHLO thoth.sbs.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752324Ab1HXKnu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Aug 2011 06:43:50 -0400
Message-ID: <4E54D5D7.8050807@siemens.com>
Date: Wed, 24 Aug 2011 12:43:35 +0200
From: Jan Kiszka <jan.kiszka@siemens.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686 (x86_64); de; rv:1.8.1.12) Gecko/20080226 SUSE/2.0.0.12-1.1 Thunderbird/2.0.0.12 Mnenhy/0.7.5.666
MIME-Version: 1.0
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        "linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>
CC: Alex Williamson <alex.williamson@redhat.com>,
        "Michael S. Tsirkin" <mst@redhat.com>,
        Jesse Barnes <jbarnes@virtuousgeek.org>,
        Matthew Wilcox <matthew@wil.cx>,
        Brian King <brking@linux.vnet.ibm.com>
Subject: Broken pci_block_user_cfg_access interface
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

trying to port the generic device interrupt masking pattern of
uio_pci_generic to KVM's device assignment code, I stumbled over some
fundamental problem with the current pci_block/unblock_user_cfg_access
interface: it does not provide any synchronization between blocking
sides. This allows user space to trigger a kernel BUG, just run two

while true; do echo 1 > /sys/bus/pci/devices/<some-device>/reset; done

loops in parallel and watch the kernel oops.

Instead of some funky open-coded locking mechanism, we would rather need
a plain mutex across both the user space access (via sysfs) and the
sections guarded by pci_block/unblock_user_cfg_access so far. But I'm
not sure which of them already allow sleeping, specifically if the IPR
driver would be fine with such a change. Can someone in the CC list
comment on this?

uio_pci_generic would definitely not be able to sleep as it takes the
lock from (potentially hard) IRQ context. This particular use case, RMW
of command/status word, requires a separate mechanism. I'm considering
to introduce a dedicated raw spinlock with IRQ protection for that
words, maybe also a PCI core service to abstract INTx testing and masking.

Any further thoughts on how to resolve this issue?

Thanks,
Jan

-- 
Siemens AG, Corporate Technology, CT T DE IT 1
Corporate Competence Center Embedded Linux
