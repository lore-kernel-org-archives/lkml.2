Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753553Ab0ERD60 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 May 2010 23:58:26 -0400
Received: from mga11.intel.com ([192.55.52.93]:21830 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752113Ab0ERD6Y (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 May 2010 23:58:24 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.53,252,1272870000"; 
   d="scan'208";a="799371830"
Date: Tue, 18 May 2010 11:58:03 +0800
From: Wu Fengguang <fengguang.wu@intel.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
       Andi Kleen <andi@firstfloor.org>,
       Linux Memory Management List <linux-mm@kvack.org>,
       LKML <linux-kernel@vger.kernel.org>
Subject: [PATCH] kcore: add _text to KCORE_TEXT
Message-ID: <20100518035803.GA11231@localhost>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Extend KCORE_TEXT to cover the pages between _text and _stext,
to allow examining some important page table pages.

`readelf -a` output on x86_64 before and after patch:
	  Type           Offset             VirtAddr           PhysAddr
before    LOAD           0x00007fff8100c000 0xffffffff81009000 0x0000000000000000
after     LOAD           0x00007fff81003000 0xffffffff81000000 0x0000000000000000

The newly covered pages are:

	0xffffffff81000000 <startup_64> etc.
	0xffffffff81001000 <init_level4_pgt>
	0xffffffff81002000 <level3_ident_pgt>
	0xffffffff81003000 <level3_kernel_pgt>
	0xffffffff81004000 <level2_fixmap_pgt>
	0xffffffff81005000 <level1_fixmap_pgt>
	0xffffffff81006000 <level2_ident_pgt>
	0xffffffff81007000 <level2_kernel_pgt>
	0xffffffff81008000 <level2_spare_pgt>

Before patch, /proc/kcore shows outdated contents for the above page
table pages, for example:

	(gdb) p level3_ident_pgt
	$1 = {<text variable, no debug info>} 0xffffffff81002000 <level3_ident_pgt>
	(gdb) p/x *((pud_t *)&level3_ident_pgt)@512
	$2 = {{pud = 0x1006063}, {pud = 0x0} <repeats 511 times>}

while the real content is:

	root@hp /home/wfg# hexdump -s 0x1002000 -n 4096 /dev/mem
	1002000 6063 0100 0000 0000 8067 0000 0000 0000
	1002010 0000 0000 0000 0000 0000 0000 0000 0000
	*
	1003000

That is, on a x86_64 box with 2GB memory, we can see first-1GB / full-2GB
identity mapping before/after patch:

	(gdb) p/x *((pud_t *)&level3_ident_pgt)@512
before  $1 = {{pud = 0x1006063}, {pud = 0x0} <repeats 511 times>}
after   $1 = {{pud = 0x1006063}, {pud = 0x8067}, {pud = 0x0} <repeats 510 times>}

Obviously the content before patch is wrong.

CC: Andi Kleen <andi@firstfloor.org>
CC: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Signed-off-by: Wu Fengguang <fengguang.wu@intel.com>
---
 fs/proc/kcore.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- linux-2.6.orig/fs/proc/kcore.c	2010-04-15 12:27:54.000000000 +0800
+++ linux-2.6/fs/proc/kcore.c	2010-04-15 12:44:05.000000000 +0800
@@ -587,7 +587,7 @@ static struct kcore_list kcore_text;
  */
 static void __init proc_kcore_text_init(void)
 {
-	kclist_add(&kcore_text, _stext, _end - _stext, KCORE_TEXT);
+	kclist_add(&kcore_text, _text, _end - _text, KCORE_TEXT);
 }
 #else
 static void __init proc_kcore_text_init(void)
