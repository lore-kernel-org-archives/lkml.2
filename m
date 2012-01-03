Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755994Ab2ACWjX (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Jan 2012 17:39:23 -0500
Received: from cantor2.suse.de ([195.135.220.15]:40018 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755976Ab2ACWjR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Jan 2012 17:39:17 -0500
X-Mailbox-Line: From gregkh@clark.kroah.org Tue Jan  3 14:33:22 2012
Message-Id: <20120103223322.688508257@clark.kroah.org>
User-Agent: quilt/0.50-25.1
Date: Tue, 03 Jan 2012 14:32:53 -0800
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org,
        alan@lxorguk.ukuu.org.uk, Eugene Surovegin <ebs@ebshome.net>,
        Tejun Heo <tj@kernel.org>
Subject: [20/75] percpu: fix per_cpu_ptr_to_phys() handling of non-page-aligned addresses
In-Reply-To: <20120103223332.GA4112@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Eugene Surovegin <ebs@ebshome.net>

commit 9f57bd4d6dc69a4e3bf43044fa00fcd24dd363e3 upstream.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 mm/percpu.c |    6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

--- a/mm/percpu.c
+++ b/mm/percpu.c
@@ -1011,9 +1011,11 @@ phys_addr_t per_cpu_ptr_to_phys(void *ad
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


