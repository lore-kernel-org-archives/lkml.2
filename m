Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755596Ab1DSVJI (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Apr 2011 17:09:08 -0400
Received: from kroah.org ([198.145.64.141]:39352 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753231Ab1DSVET (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Apr 2011 17:04:19 -0400
X-Mailbox-Line: From gregkh@clark.kroah.org Tue Apr 19 14:03:23 2011
Message-Id: <20110419210323.007678566@clark.kroah.org>
User-Agent: quilt/0.48-16.4
Date: Tue, 19 Apr 2011 14:02:23 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Jeff Mahoney <jeffm@suse.com>, Tony Luck <tony.luck@intel.com>
Subject: [07/26] [IA64] mca.c: Fix cast from integer to pointer warning
In-Reply-To: <20110419210333.GA17417@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.33-longterm review patch.  If anyone has any objections, please let us know.

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

---
 arch/ia64/kernel/mca.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

--- a/arch/ia64/kernel/mca.c
+++ b/arch/ia64/kernel/mca.c
@@ -1858,7 +1858,8 @@ ia64_mca_cpu_init(void *cpu_data)
 			data = mca_bootmem();
 			first_time = 0;
 		} else
-			data = __get_free_pages(GFP_KERNEL, get_order(sz));
+			data = (void *)__get_free_pages(GFP_KERNEL,
+							get_order(sz));
 		if (!data)
 			panic("Could not allocate MCA memory for cpu %d\n",
 					cpu);


