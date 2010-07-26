Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754988Ab0GZUYx (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Jul 2010 16:24:53 -0400
Received: from claw.goop.org ([74.207.240.146]:53894 "EHLO claw.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751847Ab0GZUYw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Jul 2010 16:24:52 -0400
Message-ID: <4C4DEF13.1030403@goop.org>
Date: Mon, 26 Jul 2010 13:24:51 -0700
From: Jeremy Fitzhardinge <jeremy@goop.org>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.7) Gecko/20100720 Fedora/3.1.1-1.fc13 Lightning/1.0b2pre Thunderbird/3.1.1
MIME-Version: 1.0
To: Nick Piggin <npiggin@suse.de>
CC: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
Subject: [PATCH] vmap: add flag to allow lazy unmap to be disabled at runtime
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



[ Nick, I forget if I sent this to you before.  Could you Ack it if it looks OK? Thanks, J ]

Add a flag to force lazy_max_pages() to zero to prevent any outstanding
mapped pages.  We'll need this for Xen.

Signed-off-by: Jeremy Fitzhardinge<jeremy.fitzhardinge@citrix.com>

diff --git a/include/linux/vmalloc.h b/include/linux/vmalloc.h
index 227c2a5..b840fda 100644
--- a/include/linux/vmalloc.h
+++ b/include/linux/vmalloc.h
@@ -7,6 +7,8 @@

  struct vm_area_struct;		/* vma defining user mapping in mm_types.h */

+extern bool vmap_lazy_unmap;
+
  /* bits in flags of vmalloc's vm_struct below */
  #define VM_IOREMAP	0x00000001	/* ioremap() and friends */
  #define VM_ALLOC	0x00000002	/* vmalloc() */
diff --git a/mm/vmalloc.c b/mm/vmalloc.c
index ae00746..7f35fe2 100644
--- a/mm/vmalloc.c
+++ b/mm/vmalloc.c
@@ -31,6 +31,7 @@
  #include<asm/tlbflush.h>
  #include<asm/shmparam.h>

+bool vmap_lazy_unmap __read_mostly = true;

  /*** Page table manipulation functions ***/

@@ -502,6 +503,9 @@ static unsigned long lazy_max_pages(void)
  {
  	unsigned int log;

+	if (!vmap_lazy_unmap)
+		return 0;
+
  	log = fls(num_online_cpus());

  	return log * (32UL * 1024 * 1024 / PAGE_SIZE);


