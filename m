Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757840Ab0FKJSA (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Jun 2010 05:18:00 -0400
Received: from fgwmail5.fujitsu.co.jp ([192.51.44.35]:37047 "EHLO
	fgwmail5.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757723Ab0FKJR6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Jun 2010 05:17:58 -0400
X-SecurityPolicyCheck-FJ: OK by FujitsuOutboundMailChecker v1.3.1
Message-ID: <4C11FF10.4060203@jp.fujitsu.com>
Date: Fri, 11 Jun 2010 18:17:04 +0900
From: Kenji Kaneshige <kaneshige.kenji@jp.fujitsu.com>
User-Agent: Mozilla/5.0 (Windows; U; Windows NT 5.1; ja; rv:1.9.1.9) Gecko/20100317 Thunderbird/3.0.4
MIME-Version: 1.0
To: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
       "H. Peter Anvin" <hpa@zytor.com>, linux-kernel@vger.kernel.org
CC: linux-pci@vger.kernel.org, jbarnes@virtuousgeek.org
Subject: [RFC][PATCH 0/4] x86: ioremap() problem in X86_32 PAE
Content-Type: text/plain; charset=ISO-2022-JP
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

I encountered the problem that loading ioatdma driver causes kernel
hangup or kernel panic in X86_32 PAE environment. I found that this
was caused by NOT ioatdma driver but x86's ioremap() behavior in
X86_32 PAE environment. On my environment, 64-bit MMIO region is
assigned to ioatdma PCI devices, and those high physical address are
passed to ioremap() when ioatdma driver calls pcim_iomap_regions().
Current x86's ioremap() seems to not handle those high physical
addresses properly. The major problems are

- When the physical address higher than 32-bit is passed to ioremap(),
  ioremap() maps wrong address. The ioremap() uses PAGE_MASK to align
  the specified address. This makes higher 32-bit of the physical
  address cleared unexpectedly. I think ioremap() must use
  PHYSICAL_PAGE_MASK instead.

- When too high physical address for X86_32 PAE (higher than 36-bit)
  is specified, ioremap() needs to return error (NULL). The ioremap()
  seems to check it by using phys_addr_valid(), but it doesn't work
  actually. The phys_addr_valid() checks the physical address by using
  boot_cpu_data.x86_phys_bits. The boot_cpu_data.x86_phys_bits holds
  maximum physical address range of the CPU including 64-bit mode. As
  a result, the phys_addr_valid() returns true even if the physical
  address higher than 36-bit is specified.

The following patch fixes the problem.

- [PATCH 1/4] x86: ioremap: fix wrong address masking
- [PATCH 2/4] x86: ioremap: fix physical address check
- [PATCH 3/4] x86: ioremap: remove physical address warning message
- [PATCH 4/4] x86: ioremap: fix normal ram range check

  Note: the last one (PATCH 4/4) is not related to this problem. I
        found it when I was making PATCH 1, 2, 3.

I made and tested those patches against 2.6.34, and confirmed it can
also be applied to 2.6.35-rc2.

By the way, I'm wondering some change might be needed also in PCI side.
For example, current PCI subsystem disables 64-bit BAR with address
higher than 32-bit assigned if sizeof(resource_size_t) is less than 8.
But it doesn't care the case sizeof(resource_size_t) is equal to 8 on
the system that cannot handle whole 64-bit physical address, like
X86_32 PAE. In relation to this, my system is doing the following
interesting behavior.

- On x86_32 without PAE, ioatdma works because 64-bit BAR is once
  cleared and then lower address is assigned again.

- On x86_32 with PAE, ioatdma doesn' work even with my patch set.
  Without my patch, kernel hangup or panic happens. With my patch,
  ioatdma driver fails to initialize the device because ioremap()
  returns NULL.

Anyway, I think ioremap() problem needs to be fixed first.

Thanks,
Kenji Kaneshige

