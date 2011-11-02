Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932253Ab1KBORK (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Nov 2011 10:17:10 -0400
Received: from mailout06.t-online.de ([194.25.134.19]:36308 "EHLO
	mailout06.t-online.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932097Ab1KBORG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Nov 2011 10:17:06 -0400
Message-ID: <4EB150D3.8040009@t-online.de>
Date: Wed, 02 Nov 2011 15:16:51 +0100
From: Knut Petersen <Knut_Petersen@t-online.de>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; de; rv:1.9.2.23) Gecko/20110920 SUSE/3.1.15 Thunderbird/3.1.15
MIME-Version: 1.0
To: shemminger@linux-foundation.org
CC: linux-kernel@vger.kernel.org, "David S. Miller" <davem@davemloft.net>
Subject: [BUG] sky2 wol broken for Marvell 88E8053 rev 19
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
X-ID: TnjgRqZEYhQxSiG7Z3cH6I5db0BnBGhcc5+YxGtkC-wRQe6QXv+GEdau3TzE1jUQVS
X-TOI-MSGID: c34b6957-496f-460d-ad92-f70fdaa8ae0d
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

WOL is broken on an AOpen i915GMm-hfs mobo with kernel 3.1.

lspci
===
02:00.0 Ethernet controller: Marvell Technology Group Ltd. 88E8053 PCI-E Gigabit Ethernet Controller (rev 19)
         Subsystem: AOPEN Inc. Marvell 88E8053 Gigabit Ethernet Controller (Aopen)
         Flags: bus master, fast devsel, latency 0, IRQ 44
         Memory at d0020000 (64-bit, non-prefetchable) [size=16K]
         I/O ports at c000 [size=256]
         [virtual] Expansion ROM at 80900000 [disabled] [size=128K]
         Capabilities: [48] Power Management version 2
         Capabilities: [50] Vital Product Data
         Capabilities: [5c] MSI: Enable+ Count=1/2 Maskable- 64bit+
         Capabilities: [e0] Express Legacy Endpoint, MSI 00
         Capabilities: [100] Advanced Error Reporting
         Kernel driver in use: sky2

03:00.0 Ethernet controller: Marvell Technology Group Ltd. 88E8053 PCI-E Gigabit Ethernet Controller (rev 19)
         Subsystem: AOPEN Inc. Marvell 88E8053 Gigabit Ethernet Controller (Aopen)
         Flags: bus master, fast devsel, latency 0, IRQ 45
         Memory at d0120000 (64-bit, non-prefetchable) [size=16K]
         I/O ports at d000 [size=256]
         [virtual] Expansion ROM at 80600000 [disabled] [size=128K]
         Capabilities: [48] Power Management version 2
         Capabilities: [50] Vital Product Data
         Capabilities: [5c] MSI: Enable+ Count=1/2 Maskable- 64bit+
         Capabilities: [e0] Express Legacy Endpoint, MSI 00
         Capabilities: [100] Advanced Error Reporting
         Kernel driver in use: sky2

  fix:
==

WOL does work with the following two changes:

diff original/drivers/net/sky2.c new/drivers/net/sky2.c
826a827
 >       u32 reg1;
878a880,884
 >
 >       /* Turn on legacy PCI-Express PME mode */
 >       reg1 = sky2_pci_read32(hw, PCI_DEV_REG1);
 >       reg1 |= PCI_Y2_PME_LEGACY;
 >       sky2_pci_write32(hw, PCI_DEV_REG1, reg1);

diff original/drivers/net/sky2.h new/drivers/net/sky2.h
374,375c374,375
<       Y2_HW_WOL_ON    = 1<<15,/* HW WOL On  (Yukon-EC Ultra A1 only) */
<       Y2_HW_WOL_OFF   = 1<<14,/* HW WOL On  (Yukon-EC Ultra A1 only) */
---
 >       Y2_HW_WOL_OFF   = 1<<15,/* HW WOL On  (Yukon-EC Ultra A1 only) */
 >       Y2_HW_WOL_ON    = 1<<14,/* HW WOL On  (Yukon-EC Ultra A1 only) */

The first change reverts commit 87b09f1f25cd1e01d7c50bf423c7fe33027d7511,
both changes are based on suggestions found in the www.

WOL only works here if I apply both of them.

Some authors suggest fix 1, some suggested fix 2, I found no msg requesting to
apply both. Several bugzilla references are still unreachable ;-(


So the big question is:
=================

Do those changes fix one system but break other systems?

cu,
  Knut
