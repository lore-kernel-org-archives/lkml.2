Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753246Ab0JYV1f (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Oct 2010 17:27:35 -0400
Received: from mx1.redhat.com ([209.132.183.28]:24976 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751053Ab0JYV1e (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Oct 2010 17:27:34 -0400
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
	Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
	Kingdom.
	Registered in England and Wales under Company Registration No. 3798903
Subject: [PATCH] workqueue: Fix alignment calculation in alloc_cwqs()
To: torvalds@osdl.org, akpm@linux-foundation.org
From: David Howells <dhowells@redhat.com>
Cc: Tejun Heo <tj@kernel.org>, linux-am33-list@redhat.com,
        linux-kernel@vger.kernel.org,
        Akira Takeuchi <takeuchi.akr@jp.panasonic.com>,
        Mark Salter <msalter@redhat.com>
Date: Mon, 25 Oct 2010 22:27:06 +0100
Message-ID: <20101025212706.27798.23957.stgit@warthog.procyon.org.uk>
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
  --->	BUG_ON(!IS_ALIGNED(wq->cpu_wq.v, align));
	return wq->cpu_wq.v ? 0 : -ENOMEM;

The values are:

	wa->cpu_wq.v => 0x902776e0
	align => 0x100

and align is calculated by the following:

	const size_t align = max_t(size_t, 1 << WORK_STRUCT_FLAG_BITS,
				   __alignof__(unsigned long long));

which is wrong.  __alignof__() returns its value in bytes, but:

	1 << WORK_STRUCT_FLAG_BITS

returns the value in bits.  It needs dividing by the number of bits in a byte.

Reported-by: Akira Takeuchi <takeuchi.akr@jp.panasonic.com>
Signed-off-by: David Howells <dhowells@redhat.com>
Acked-by: Mark Salter <msalter@redhat.com>
cc: Tejun Heo <tj@kernel.org>
---

 kernel/workqueue.c |    5 +++--
 1 files changed, 3 insertions(+), 2 deletions(-)


diff --git a/kernel/workqueue.c b/kernel/workqueue.c
index 30acdb7..e29ebd4 100644
--- a/kernel/workqueue.c
+++ b/kernel/workqueue.c
@@ -2766,8 +2766,9 @@ static int alloc_cwqs(struct workqueue_struct *wq)
 	 * unsigned long long.
 	 */
 	const size_t size = sizeof(struct cpu_workqueue_struct);
-	const size_t align = max_t(size_t, 1 << WORK_STRUCT_FLAG_BITS,
-				   __alignof__(unsigned long long));
+	const size_t align =
+		max_t(size_t, 1 << (WORK_STRUCT_FLAG_BITS - BITS_PER_BYTE),
+		      __alignof__(unsigned long long));
 #ifdef CONFIG_SMP
 	bool percpu = !(wq->flags & WQ_UNBOUND);
 #else

