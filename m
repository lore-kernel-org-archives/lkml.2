Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753235Ab2KSFaA (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Nov 2012 00:30:00 -0500
Received: from relay4-d.mail.gandi.net ([217.70.183.196]:56286 "EHLO
	relay4-d.mail.gandi.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752160Ab2KSF37 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Nov 2012 00:29:59 -0500
X-Originating-IP: 217.70.178.138
X-Originating-IP: 50.43.39.152
From: Josh Triplett <josh@joshtriplett.org>
To: Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        David Rientjes <rientjes@google.com>, Minchan Kim <minchan@kernel.org>,
        Kautuk Consul <consul.kautuk@gmail.com>, Cong Wang <amwang@redhat.com>,
        linux-mm@kvack.org, linux-kernel@vger.kernel.org
Cc: Josh Triplett <josh@joshtriplett.org>
Subject: [PATCH 23/58] mm: Avoid defining set_iounmap_nonlazy on non-x86
Date: Sun, 18 Nov 2012 21:28:02 -0800
Message-Id: <1353302917-13995-24-git-send-email-josh@joshtriplett.org>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1353302917-13995-1-git-send-email-josh@joshtriplett.org>
References: <1353302917-13995-1-git-send-email-josh@joshtriplett.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit 3ee48b6af49cf534ca2f481ecc484b156a41451d added the
set_iounmap_nonlazy function for use on x86, but actually defined it on
all architectures.  Only x86 prototypes this function (in asm/io.h), and
only x86 uses it (in arch/x86/kernel/crash_dump_64.c), so avoid defining
it on non-x86.

Meanwhile, include the appropriate header with the prototype, to
eliminate a warning from gcc (-Wmissing-prototypes) and from Sparse
(-Wdecl).

mm/vmalloc.c:563:6: warning: no previous prototype for ‘set_iounmap_nonlazy’ [-Wmissing-prototypes]

Signed-off-by: Josh Triplett <josh@joshtriplett.org>
---
 mm/vmalloc.c |    3 +++
 1 file changed, 3 insertions(+)

diff --git a/mm/vmalloc.c b/mm/vmalloc.c
index 78e0830..fc32a0a 100644
--- a/mm/vmalloc.c
+++ b/mm/vmalloc.c
@@ -27,6 +27,7 @@
 #include <linux/pfn.h>
 #include <linux/kmemleak.h>
 #include <linux/atomic.h>
+#include <linux/io.h>
 #include <asm/uaccess.h>
 #include <asm/tlbflush.h>
 #include <asm/shmparam.h>
@@ -556,6 +557,7 @@ static atomic_t vmap_lazy_nr = ATOMIC_INIT(0);
 /* for per-CPU blocks */
 static void purge_fragmented_blocks_allcpus(void);
 
+#ifdef CONFIG_X86
 /*
  * called before a call to iounmap() if the caller wants vm_area_struct's
  * immediately freed.
@@ -564,6 +566,7 @@ void set_iounmap_nonlazy(void)
 {
 	atomic_set(&vmap_lazy_nr, lazy_max_pages()+1);
 }
+#endif
 
 /*
  * Purges all lazily-freed vmap areas.
-- 
1.7.10.4

