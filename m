Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758598Ab2CMBBU (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Mar 2012 21:01:20 -0400
Received: from mail.windriver.com ([147.11.1.11]:47636 "EHLO
	mail.windriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758559Ab2CMAWV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Mar 2012 20:22:21 -0400
From: Paul Gortmaker <paul.gortmaker@windriver.com>
To: stable@kernel.org, linux-kernel@vger.kernel.org
Cc: stable-review@kernel.org, Jeff Mahoney <jeffm@suse.com>,
        Tony Luck <tony.luck@intel.com>,
        Paul Gortmaker <paul.gortmaker@windriver.com>
Subject: [34-longterm 061/196] mca.c: Fix cast from integer to pointer warning
Date: Mon, 12 Mar 2012 20:19:34 -0400
Message-Id: <1331598109-31424-16-git-send-email-paul.gortmaker@windriver.com>
X-Mailer: git-send-email 1.7.9.3
In-Reply-To: <1331598109-31424-1-git-send-email-paul.gortmaker@windriver.com>
References: <1331597724-31358-1-git-send-email-paul.gortmaker@windriver.com>
 <1331598109-31424-1-git-send-email-paul.gortmaker@windriver.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Jeff Mahoney <jeffm@suse.com>

                   -------------------
    This is a commit scheduled for the next v2.6.34 longterm release.
    If you see a problem with using this for longterm, please comment.
                   -------------------

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
Signed-off-by: Paul Gortmaker <paul.gortmaker@windriver.com>
---
 arch/ia64/kernel/mca.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/arch/ia64/kernel/mca.c b/arch/ia64/kernel/mca.c
index a0220dc..6871c1b 100644
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
1.7.9.3

