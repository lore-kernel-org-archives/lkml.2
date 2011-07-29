Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754823Ab1G2HAd (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Jul 2011 03:00:33 -0400
Received: from mail-wy0-f174.google.com ([74.125.82.174]:60901 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752532Ab1G2HAb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Jul 2011 03:00:31 -0400
Subject: [PATCH] fcoe: use kthread_create_on_node
From: Eric Dumazet <eric.dumazet@gmail.com>
To: Robert Love <robert.w.love@intel.com>
Cc: devel@open-fcoe.org, linux-kernel <linux-kernel@vger.kernel.org>,
        "James E.J. Bottomley" <JBottomley@parallels.com>,
        linux-scsi@vger.kernel.org, Neerav Parikh <Neerav.Parikh@intel.com>,
        Kiran Patil <kiran.patil@intel.com>
Content-Type: text/plain; charset="UTF-8"
Date: Fri, 29 Jul 2011 09:00:25 +0200
Message-ID: <1311922825.7845.18.camel@edumazet-laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Since fcoe_percpu_thread_create() creates percpu kthread, it makes sense
to use kthread_create_on_node() to get proper NUMA affinity for kthread
stack.

Signed-off-by: Eric Dumazet <eric.dumazet@gmail.com>
CC: Neerav Parikh <Neerav.Parikh@intel.com>
CC: Kiran Patil <kiran.patil@intel.com>
CC: "James E.J. Bottomley" <JBottomley@parallels.com>
---
 drivers/scsi/fcoe/fcoe.c |    5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/drivers/scsi/fcoe/fcoe.c b/drivers/scsi/fcoe/fcoe.c
index 204fa8d..a9dab1f 100644
--- a/drivers/scsi/fcoe/fcoe.c
+++ b/drivers/scsi/fcoe/fcoe.c
@@ -1118,8 +1118,9 @@ static void fcoe_percpu_thread_create(unsigned int cpu)
 
 	p = &per_cpu(fcoe_percpu, cpu);
 
-	thread = kthread_create(fcoe_percpu_receive_thread,
-				(void *)p, "fcoethread/%d", cpu);
+	thread = kthread_create_on_node(fcoe_percpu_receive_thread,
+					(void *)p, cpu_to_node(cpu),
+					"fcoethread/%d", cpu);
 
 	if (likely(!IS_ERR(thread))) {
 		kthread_bind(thread, cpu);


