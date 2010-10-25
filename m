Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757662Ab0JYWmF (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Oct 2010 18:42:05 -0400
Received: from mx1.redhat.com ([209.132.183.28]:10253 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751994Ab0JYWmD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Oct 2010 18:42:03 -0400
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
	Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
	Kingdom.
	Registered in England and Wales under Company Registration No. 3798903
Subject: [PATCH] MN10300: Fix the PERCPU() alignment to allow for workqueues
To: torvalds@osdl.org, akpm@linux-foundation.org
From: David Howells <dhowells@redhat.com>
Cc: Tejun Heo <tj@kernel.org>, linux-am33-list@redhat.com,
        linux-kernel@vger.kernel.org,
        Akira Takeuchi <takeuchi.akr@jp.panasonic.com>,
        Mark Salter <msalter@redhat.com>
Date: Mon, 25 Oct 2010 23:41:11 +0100
Message-ID: <20101025224111.7798.38960.stgit@warthog.procyon.org.uk>
User-Agent: StGit/0.15-97-g9680-dirty
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

In the MN10300 arch, we occasionally see an assertion being tripped in
alloc_cwqs() at the following line:

        /* just in case, make sure it's actually aligned */
  --->  BUG_ON(!IS_ALIGNED(wq->cpu_wq.v, align));
        return wq->cpu_wq.v ? 0 : -ENOMEM;

The values are:

        wa->cpu_wq.v => 0x902776e0
        align => 0x100

and align is calculated by the following:

        const size_t align = max_t(size_t, 1 << WORK_STRUCT_FLAG_BITS,
                                   __alignof__(unsigned long long));

This is because the pointer in question (wq->cpu_wq.v) loses some of its lower
bits to control flags, and so the object it points to must be sufficiently
aligned to avoid the need to use those bits for pointing to things.

Currently, 4 control bits and 4 colour bits are used in normal circumstances,
plus a debugging bit if debugging is set.  This requires the
cpu_workqueue_struct struct to be at least 256 bytes aligned (or 512 bytes
aligned with debugging).

PERCPU() alignment on MN13000, however, is only 32 bytes as set in
vmlinux.lds.S.  So we set this to PAGE_SIZE (4096) to match most other arches
and stick a comment in alloc_cwqs() for anyone else who triggers the assertion.

Reported-by: Akira Takeuchi <takeuchi.akr@jp.panasonic.com>
Signed-off-by: David Howells <dhowells@redhat.com>
Acked-by: Mark Salter <msalter@redhat.com>
cc: Tejun Heo <tj@kernel.org>
---

 arch/mn10300/kernel/vmlinux.lds.S |    2 +-
 kernel/workqueue.c                |    4 +++-
 2 files changed, 4 insertions(+), 2 deletions(-)


diff --git a/arch/mn10300/kernel/vmlinux.lds.S b/arch/mn10300/kernel/vmlinux.lds.S
index 10549dc..febbeee 100644
--- a/arch/mn10300/kernel/vmlinux.lds.S
+++ b/arch/mn10300/kernel/vmlinux.lds.S
@@ -70,7 +70,7 @@ SECTIONS
 	.exit.text : { EXIT_TEXT; }
 	.exit.data : { EXIT_DATA; }
 
-  PERCPU(32)
+  PERCPU(PAGE_SIZE)
   . = ALIGN(PAGE_SIZE);
   __init_end = .;
   /* freed after init ends here */
diff --git a/kernel/workqueue.c b/kernel/workqueue.c
index 30acdb7..e5ff2cb 100644
--- a/kernel/workqueue.c
+++ b/kernel/workqueue.c
@@ -2791,7 +2791,9 @@ static int alloc_cwqs(struct workqueue_struct *wq)
 		}
 	}
 
-	/* just in case, make sure it's actually aligned */
+	/* just in case, make sure it's actually aligned
+	 * - this is affected by PERCPU() alignment in vmlinux.lds.S
+	 */
 	BUG_ON(!IS_ALIGNED(wq->cpu_wq.v, align));
 	return wq->cpu_wq.v ? 0 : -ENOMEM;
 }

