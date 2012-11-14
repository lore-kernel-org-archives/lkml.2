Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964854Ab2KNQ62 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Nov 2012 11:58:28 -0500
Received: from mail-pa0-f46.google.com ([209.85.220.46]:44629 "EHLO
	mail-pa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S964820Ab2KNQ61 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Nov 2012 11:58:27 -0500
From: Joonsoo Kim <js1304@gmail.com>
To: Russell King <rmk+kernel@arm.linux.org.uk>
Cc: linux-kernel@vger.kernel.org, linux-mm@kvack.org,
        linux-arm-kernel@lists.infradead.org, Joonsoo Kim <js1304@gmail.com>
Subject: [RFC PATCH 0/3] introduce static_vm for ARM-specific static mapped area
Date: Thu, 15 Nov 2012 01:55:51 +0900
Message-Id: <1352912154-16210-1-git-send-email-js1304@gmail.com>
X-Mailer: git-send-email 1.7.9.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

In current implementation, we used ARM-specific flag, that is,
VM_ARM_STATIC_MAPPING, for distinguishing ARM specific static mapped area.
The purpose of static mapped area is to re-use static mapped area when
entire physical address range of the ioremap request can be covered
by this area.

This implementation causes needless overhead for some cases.
We unnecessarily iterate vmlist for finding matched area even if there
is no static mapped area. And if there are some static mapped areas,
iterating whole vmlist is not preferable.
In fact, it is not a critical problem, because ioremap is not frequently
used. But reducing overhead is better idea.

Another reason for doing this work is for removing architecture dependency
on vmalloc layer. I think that vmlist and vmlist_lock is internal data
structure for vmalloc layer. Some codes for debugging and stat inevitably
use vmlist and vmlist_lock. But it is preferable that they are used outside
of vmalloc.c as least as possible.

In the near future, I will try to remove other architecture dependency on
vmalloc layer.

This is just RFC patch and I did compile-test only.
If you have any good suggestion, please let me know.

These are based on v3.7-rc5.

Thanks.

Joonsoo Kim (3):
  ARM: vmregion: remove vmregion code entirely
  ARM: static_vm: introduce an infrastructure for static mapped area
  ARM: mm: use static_vm for managing static mapped areas

 arch/arm/include/asm/mach/static_vm.h |   51 ++++++++
 arch/arm/mm/Makefile                  |    2 +-
 arch/arm/mm/ioremap.c                 |   69 ++++-------
 arch/arm/mm/mm.h                      |   10 --
 arch/arm/mm/mmu.c                     |   55 +++++----
 arch/arm/mm/static_vm.c               |   97 ++++++++++++++++
 arch/arm/mm/vmregion.c                |  205 ---------------------------------
 arch/arm/mm/vmregion.h                |   31 -----
 8 files changed, 208 insertions(+), 312 deletions(-)
 create mode 100644 arch/arm/include/asm/mach/static_vm.h
 create mode 100644 arch/arm/mm/static_vm.c
 delete mode 100644 arch/arm/mm/vmregion.c
 delete mode 100644 arch/arm/mm/vmregion.h

-- 
1.7.9.5

