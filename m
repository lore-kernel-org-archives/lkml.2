Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754606Ab1G2HGZ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Jul 2011 03:06:25 -0400
Received: from mail-wy0-f174.google.com ([74.125.82.174]:40244 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753005Ab1G2HGY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Jul 2011 03:06:24 -0400
Subject: [PATCH] bnx2fc: use kthread_create_on_node
From: Eric Dumazet <eric.dumazet@gmail.com>
To: Bhanu Prakash Gollapudi <bprakash@broadcom.com>
Cc: "James E.J. Bottomley" <JBottomley@parallels.com>,
        linux-scsi@vger.kernel.org,
        linux-kernel <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Date: Fri, 29 Jul 2011 09:06:18 +0200
Message-ID: <1311923178.7845.21.camel@edumazet-laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Since bnx2fc_percpu_thread_create() creates percpu kthread, it makes
sense to use kthread_create_on_node() to get proper NUMA affinity for
kthread stack.

Signed-off-by: Eric Dumazet <eric.dumazet@gmail.com>
CC: "James E.J. Bottomley" <JBottomley@parallels.com>
---
 drivers/scsi/bnx2fc/bnx2fc_fcoe.c |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/scsi/bnx2fc/bnx2fc_fcoe.c b/drivers/scsi/bnx2fc/bnx2fc_fcoe.c
index a97aff3..9843434 100644
--- a/drivers/scsi/bnx2fc/bnx2fc_fcoe.c
+++ b/drivers/scsi/bnx2fc/bnx2fc_fcoe.c
@@ -2161,9 +2161,9 @@ static void bnx2fc_percpu_thread_create(unsigned int cpu)
 
 	p = &per_cpu(bnx2fc_percpu, cpu);
 
-	thread = kthread_create(bnx2fc_percpu_io_thread,
-				(void *)p,
-				"bnx2fc_thread/%d", cpu);
+	thread = kthread_create_on_node(bnx2fc_percpu_io_thread,
+					(void *)p, cpu_to_node(cpu),
+					"bnx2fc_thread/%d", cpu);
 	/* bind thread to the cpu */
 	if (likely(!IS_ERR(p->iothread))) {
 		kthread_bind(thread, cpu);


