Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756531Ab1BXWXR (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Feb 2011 17:23:17 -0500
Received: from cantor.suse.de ([195.135.220.2]:35043 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754399Ab1BXWXN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Feb 2011 17:23:13 -0500
Message-ID: <4D66DA4D.4020609@suse.com>
Date: Thu, 24 Feb 2011 17:23:09 -0500
From: Jeff Mahoney <jeffm@suse.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.13) Gecko/20101206 SUSE/3.1.7 Thunderbird/3.1.7
MIME-Version: 1.0
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Cc: linux-ia64@vger.kernel.org, Tony Luck <tony.luck@intel.com>
Subject: [PATCH] ia64/mca: Fix cast from integer to pointer warning
X-Enigmail-Version: 1.1.2
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

 ia64_mca_cpu_init has a void *data local variable that is assigned
 the value from either __get_free_pages() or mca_bootmem(). The problem
 is that __get_free_pages returns an unsigned long and mca_bootmem, via
 alloc_bootmem(), returns a void *. format_mca_init_stack takes the void *,
 and it's also used with __pa(), but that casts it to long anyway.

 This results in the following build warning:

 arch/ia64/kernel/mca.c:1898: warning: assignment makes pointer from
 integer without a cast

 This patch casts the return of __get_free_pages to a void * to avoid
 the warning.

Signed-off-by: Jeff Mahoney <jeffm@suse.com>
---
 arch/ia64/kernel/mca.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

--- a/arch/ia64/kernel/mca.c
+++ b/arch/ia64/kernel/mca.c
@@ -1859,7 +1859,8 @@ ia64_mca_cpu_init(void *cpu_data)
 			data = mca_bootmem();
 			first_time = 0;
 		} else
-			data = __get_free_pages(GFP_KERNEL, get_order(sz));
+			data = (void *)__get_free_pages(GFP_KERNEL,
+							get_order(sz));
 		if (!data)
 			panic("Could not allocate MCA memory for cpu %d\n",
 					cpu);
-- 
Jeff Mahoney
SUSE Labs
