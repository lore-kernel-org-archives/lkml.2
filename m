Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755130Ab2JENOz (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Oct 2012 09:14:55 -0400
Received: from arkanian.console-pimps.org ([212.110.184.194]:38254 "EHLO
	arkanian.console-pimps.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750847Ab2JENOx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Oct 2012 09:14:53 -0400
From: Matt Fleming <matt@console-pimps.org>
To: linux-kernel@vger.kernel.org
Cc: linux-efi@vger.kernel.org, "H. Peter Anvin" <hpa@zytor.com>,
        Matthew Garrett <mjg@redhat.com>, Jan Beulich <jbeulich@suse.com>,
        x86@kernel.org, Ingo Molnar <mingo@kernel.org>,
        Matt Fleming <matt.fleming@intel.com>
Subject: [PATCH v2 0/3] x86/efi: Identity mapping pagetable
Date: Fri,  5 Oct 2012 14:14:29 +0100
Message-Id: <1349442872-5266-1-git-send-email-matt@console-pimps.org>
X-Mailer: git-send-email 1.7.11.4
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Matt Fleming <matt.fleming@intel.com>

This series upgrades real_mode_header->trampoline_pgd to a proper
kernel pagetable instead of just mapping the kernel text and module
space. It also inserts the physical mappings for anything we
ioremap(), so I/O regions are always accessible via their physical
addresses whenever this pagetable is loaded, making it a true identity
mapping.

These changes make it suitable for loading when calling virtual EFI
runtime functions on x86-64. The main benefit of this change is to fix
the ASUS firmware bug documented here,

	 https://lkml.org/lkml/2012/8/7/108

but having our own EFI pagetable makes sense anyway. The memory map
code is easily the most complicatd part of the EFI infrastructure, and
it's likely that there will be other funky stuff we have to do with
our memory map as more and more machines ship with various
implementations of EFI firmware.

Note that we only switch to the identity pagetable for x86-64. I'm
unaware of any bugs like the above on 32-bit EFI platforms, but we can
easily adopt the 64-bit scheme if one is discovered.

v2: Based on feedback from Jan Beulich delete the 32-bit changes in
[PATCH 1/3], they were likely to create more problems than they would
solve and the identity I/O mappings are unused on 32-bit anyway.

Matt Fleming (2):
  x86, mm: Include the entire kernel memory map in trampoline_pgd
  x86, efi: 1:1 pagetable mapping for virtual EFI calls

Xiaoyan Zhang (1):
  x86/kernel: remove tboot 1:1 page table creation code

 arch/x86/include/asm/efi.h     |  28 ++++++++---
 arch/x86/kernel/tboot.c        |  78 ++----------------------------
 arch/x86/mm/init_64.c          |   9 +++-
 arch/x86/mm/ioremap.c          | 105 +++++++++++++++++++++++++++++++++++++++++
 arch/x86/platform/efi/efi_64.c |  15 ++++++
 arch/x86/realmode/init.c       |  17 ++++++-
 6 files changed, 169 insertions(+), 83 deletions(-)

-- 
1.7.11.4

