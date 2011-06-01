Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1163257Ab1FAI3S (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Jun 2011 04:29:18 -0400
Received: from cantor2.suse.de ([195.135.220.15]:44689 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1163211Ab1FAI3M (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Jun 2011 04:29:12 -0400
X-Mailbox-Line: From linux@blue.kroah.org Wed Jun  1 17:12:27 2011
Message-Id: <20110601081227.134330473@blue.kroah.org>
User-Agent: quilt/0.48-16.4
Date: Wed, 01 Jun 2011 17:12:09 +0900
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Daniel Kiper <dkiper@net-space.pl>,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        Greg Kroah-Hartman <gregkh@suse.de>
Subject: [159/165] xen/setup: Fix for incorrect xen_extra_mem_start
In-Reply-To: <20110601081349.GA10017@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.39-stable review patch.  If anyone has any objections, please let us know.

------------------
 initialization under 32-bit
Content-Length: 1270
Lines: 36

From: Daniel Kiper <dkiper@net-space.pl>

commit 0f16d0dfcdb5aab97d9e368f008b070b5b3ec6d3 upstream.

git commit 24bdb0b62cc82120924762ae6bc85afc8c3f2b26 (xen: do not create
the extra e820 region at an addr lower than 4G) does not take into
account that ifdef CONFIG_X86_32 instead of e820_end_of_low_ram_pfn()
find_low_pfn_range() is called (both calls are from arch/x86/kernel/setup.c).
find_low_pfn_range() behaves correctly and does not require change in
xen_extra_mem_start initialization. Additionally, if xen_extra_mem_start
is initialized in the same way as ifdef CONFIG_X86_64 then memory hotplug
support for Xen balloon driver (under development) is broken.

Signed-off-by: Daniel Kiper <dkiper@net-space.pl>
Signed-off-by: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 arch/x86/xen/setup.c |    4 ++++
 1 file changed, 4 insertions(+)

--- a/arch/x86/xen/setup.c
+++ b/arch/x86/xen/setup.c
@@ -227,7 +227,11 @@ char * __init xen_memory_setup(void)
 
 	memcpy(map_raw, map, sizeof(map));
 	e820.nr_map = 0;
+#ifdef CONFIG_X86_32
+	xen_extra_mem_start = mem_end;
+#else
 	xen_extra_mem_start = max((1ULL << 32), mem_end);
+#endif
 	for (i = 0; i < memmap.nr_entries; i++) {
 		unsigned long long end;
 


