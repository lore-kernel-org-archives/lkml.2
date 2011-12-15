Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759486Ab1LOTnt (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Dec 2011 14:43:49 -0500
Received: from mail-iy0-f174.google.com ([209.85.210.174]:61471 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751400Ab1LOTnq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Dec 2011 14:43:46 -0500
Date: Thu, 15 Dec 2011 11:43:41 -0800
From: Tejun Heo <tj@kernel.org>
To: Eugene Surovegin <ebs@ebshome.net>
Cc: ptesarik@suse.cz, xiyou.wangcong@gmail.com, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org, vgoyal@redhat.com
Subject: [PATCH] percpu: fix per_cpu_ptr_to_phys() handling of
 non-page-aligned addresses
Message-ID: <20111215194341.GG32002@google.com>
References: <20111215192559.GA28283@gate.ebshome.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20111215192559.GA28283@gate.ebshome.net>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>From 9f57bd4d6dc69a4e3bf43044fa00fcd24dd363e3 Mon Sep 17 00:00:00 2001
From: Eugene Surovegin <ebs@ebshome.net>
Date: Thu, 15 Dec 2011 11:25:59 -0800

per_cpu_ptr_to_phys() incorrectly rounds up its result for non-kmalloc
case to the page boundary, which is bogus for any non-page-aligned
address.

This affects the only in-tree user of this function - sysfs handler
for per-cpu 'crash_notes' physical address.  The trouble is that the
crash_notes per-cpu variable is not page-aligned:

crash_notes = 0xc08e8ed4
PER-CPU OFFSET VALUES:
 CPU 0: 3711f000
 CPU 1: 37129000
 CPU 2: 37133000
 CPU 3: 3713d000

So, the per-cpu addresses are:
 crash_notes on CPU 0: f7a07ed4 => phys 36b57ed4
 crash_notes on CPU 1: f7a11ed4 => phys 36b4ded4
 crash_notes on CPU 2: f7a1bed4 => phys 36b43ed4
 crash_notes on CPU 3: f7a25ed4 => phys 36b39ed4

However, /sys/devices/system/cpu/cpu*/crash_notes says:
 /sys/devices/system/cpu/cpu0/crash_notes: 36b57000
 /sys/devices/system/cpu/cpu1/crash_notes: 36b4d000
 /sys/devices/system/cpu/cpu2/crash_notes: 36b43000
 /sys/devices/system/cpu/cpu3/crash_notes: 36b39000

As you can see, all values are rounded down to a page
boundary. Consequently, this is where kexec sets up the NOTE segments,
and thus where the secondary kernel is looking for them. However, when
the first kernel crashes, it saves the notes to the unaligned
addresses, where they are not found.

Fix it by adding offset_in_page() to the translated page address.

-tj: Combined Eugene's and Petr's commit messages.

Signed-off-by: Eugene Surovegin <ebs@ebshome.net>
Signed-off-by: Tejun Heo <tj@kernel.org>
Reported-by: Petr Tesarik <ptesarik@suse.cz>
Cc: stable@kernel.org
---
I combined Petr's explanation into patch description and committed it
into percpu/for-3.2-fixes.  Will push it to Linus in a few days.

Thank you.

 mm/percpu.c |    6 ++++--
 1 files changed, 4 insertions(+), 2 deletions(-)

diff --git a/mm/percpu.c b/mm/percpu.c
index 3bb810a..716eb4a 100644
--- a/mm/percpu.c
+++ b/mm/percpu.c
@@ -1023,9 +1023,11 @@ phys_addr_t per_cpu_ptr_to_phys(void *addr)
 		if (!is_vmalloc_addr(addr))
 			return __pa(addr);
 		else
-			return page_to_phys(vmalloc_to_page(addr));
+			return page_to_phys(vmalloc_to_page(addr)) +
+			       offset_in_page(addr);
 	} else
-		return page_to_phys(pcpu_addr_to_page(addr));
+		return page_to_phys(pcpu_addr_to_page(addr)) +
+		       offset_in_page(addr);
 }
 
 /**
-- 
1.7.3.1

