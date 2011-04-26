Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932766Ab1DZV1L (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Apr 2011 17:27:11 -0400
Received: from mga01.intel.com ([192.55.52.88]:1206 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932327Ab1DZVOd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Apr 2011 17:14:33 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.64,270,1301900400"; 
   d="scan'208";a="914748621"
From: Andi Kleen <andi@firstfloor.org>
References: <20110426212.641772347@firstfloor.org>
In-Reply-To: <20110426212.641772347@firstfloor.org>
To: jeffm@suse.com, tony.luck@intel.com, gregkh@suse.de, ak@linux.intel.com,
        linux-kernel@vger.kernel.org, stable@kernel.org, tim.bird@am.sony.com
Subject: [PATCH] [59/106] mca.c: Fix cast from integer to pointer warning
Message-Id: <20110426211339.CDB303E1886@tassilo.jf.intel.com>
Date: Tue, 26 Apr 2011 14:13:39 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.35-longterm review patch.  If anyone has any objections, please let me know.

------------------
From: Jeff Mahoney <jeffm@suse.com>

commit c1d036c4d1cb00b7e8473a2ad0a78f13e13a8183 upstream.

ia64_mca_cpu_init has a void *data local variable that is assigned
the value from either __get_free_pages() or mca_bootmem(). The problem
is that __get_free_pages returns an unsigned long and mca_bootmem, via
alloc_bootmem(), returns a void *. format_mca_init_stack takes the void *,
and it's also used with __pa(), but that casts it to long anyway.

This results in the following build warning:

arch/ia64/kernel/mca.c:1898: warning: assignment makes pointer from
integer without a cast

Cast the return of __get_free_pages to a void * to avoid
the warning.

Signed-off-by: Jeff Mahoney <jeffm@suse.com>
Signed-off-by: Tony Luck <tony.luck@intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
Signed-off-by: Andi Kleen <ak@linux.intel.com>

---
 arch/ia64/kernel/mca.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

Index: linux-2.6.35.y/arch/ia64/kernel/mca.c
===================================================================
--- linux-2.6.35.y.orig/arch/ia64/kernel/mca.c
+++ linux-2.6.35.y/arch/ia64/kernel/mca.c
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
