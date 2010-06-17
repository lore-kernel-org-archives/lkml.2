Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756709Ab0FQQTK (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Jun 2010 12:19:10 -0400
Received: from relay1.sgi.com ([192.48.179.29]:52279 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760293Ab0FQQTI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Jun 2010 12:19:08 -0400
To: linux-kernel@vger.kernel.org
Subject: per_cpu_ptr_to_phys() failure on UV x86_64
Cc: tj@kernel.org
Message-Id: <E1OPHpK-0007cw-S5@eag09.americas.sgi.com>
From: Cliff Wickman <cpw@sgi.com>
Date: Thu, 17 Jun 2010 11:20:26 -0500
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


kdump is failing on an SGI UV system because it depends on
/sys/devices/system/cpu/cpuN/crash_notes.
And these files contain bad addresses for cpus beyond cpu 0.

This occurs using 2.6.35-rc3 code.  But the same problem looks
present in 2.6.33.

The problem traces to per_cpu_ptr_to_phys() -> pcpu_addr_to_page() ->
vmalloc_to_page() for per-cpu addresses not in the first per-cpu 'chunk',
but not in the VMALLOC_START/VMALLOC_END range.

I wonder why this shows up on UV but not other x86_64's?
I've included a patch that solves this for me.  But I defer to the
authors for a proper solution.

This is where per_cpu_ptr_to_phys() is called for this /sys file:
static ssize_t show_crash_notes(struct sys_device *dev, struct ...
...
        addr = per_cpu_ptr_to_phys(per_cpu_ptr(crash_notes, cpunum));
        rc = sprintf(buf, "%Lx\n", addr);
        return rc;
}

The problem, without the below patch: (but a couple of printk's)

uv3-sys:/tmp/cpw # cat /sys/devices/system/cpu/cpu0/crash_notes
1c1b040
uv3-sys:/tmp/cpw # cat /sys/devices/system/cpu/cpu1/crash_notes
db74000000000000
uv3-sys:/tmp/cpw # cat /sys/devices/system/cpu/cpu2/crash_notes
db74000000000000
uv3-sys:/tmp/cpw # dmesg | tail -n 6
[  133.883009] cpw: per_cpu_ptr_to_phys addr ffff880001c1b040
[  133.883012] cpw: per_cpu_ptr_to_phys returning 0x1c1b040
[  136.910178] cpw: per_cpu_ptr_to_phys addr ffff880001c3b040
[  136.910181] cpw: per_cpu_ptr_to_phys returning 0xdb74000000000000
[  140.304825] cpw: per_cpu_ptr_to_phys addr ffff880001c5b040
[  140.304828] cpw: per_cpu_ptr_to_phys returning 0xdb74000000000000


With the below patch: (plus a couple of printk's)

uv3-sys: # cat /sys/devices/system/cpu/cpu0/crash_notes
1c1b040
uv3-sys: # cat /sys/devices/system/cpu/cpu1/crash_notes
1c3b040
uv3-sys: # cat /sys/devices/system/cpu/cpu2/crash_notes
1c5b040
uv3-sys: # dmesg | tail -n 6
[  130.411358] cpw: per_cpu_ptr_to_phys addr ffff880001c1b040
[  130.411361] cpw: per_cpu_ptr_to_phys returning 0x1c1b040
[  135.420702] cpw: per_cpu_ptr_to_phys addr ffff880001c3b040
[  135.420705] cpw: per_cpu_ptr_to_phys returning 0x1c3b040
[  139.514014] cpw: per_cpu_ptr_to_phys addr ffff880001c5b040
[  139.514016] cpw: per_cpu_ptr_to_phys returning 0x1c5b040

Diffed against 2.6.35-rc5

Signed-off-by: Cliff Wickman <cpw@sgi.com>
---
 mm/percpu.c |    9 ++++-----
 1 file changed, 4 insertions(+), 5 deletions(-)

Index: linux-2.6.35-rc3/mm/percpu.c
===================================================================
--- linux-2.6.35-rc3.orig/mm/percpu.c
+++ linux-2.6.35-rc3/mm/percpu.c
@@ -978,12 +978,11 @@ bool is_kernel_percpu_address(unsigned l
  */
 phys_addr_t per_cpu_ptr_to_phys(void *addr)
 {
+	if ((unsigned long)addr < VMALLOC_START ||
+	    (unsigned long)addr >= VMALLOC_END)
+		return __pa(addr);
 	if (pcpu_addr_in_first_chunk(addr)) {
-		if ((unsigned long)addr < VMALLOC_START ||
-		    (unsigned long)addr >= VMALLOC_END)
-			return __pa(addr);
-		else
-			return page_to_phys(vmalloc_to_page(addr));
+		return page_to_phys(vmalloc_to_page(addr));
 	} else
 		return page_to_phys(pcpu_addr_to_page(addr));
 }
