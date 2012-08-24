Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760025Ab2HXSyP (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Aug 2012 14:54:15 -0400
Received: from co1ehsobe005.messaging.microsoft.com ([216.32.180.188]:56673
	"EHLO co1outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1760008Ab2HXSyI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Aug 2012 14:54:08 -0400
X-Forefront-Antispam-Report: CIP:163.181.249.109;KIP:(null);UIP:(null);IPV:NLI;H:ausb3twp02.amd.com;RD:none;EFVD:NLI
X-SpamScore: 0
X-BigFish: VPS0(zzzz1202hzz8275bh8275dhz2dh668h839hd24he5bhf0ah11b5h1155h)
X-WSS-ID: 0M99WI2-02-15E-02
X-M-MSG: 
From: Robert Richter <robert.richter@amd.com>
To: Ingo Molnar <mingo@kernel.org>
CC: LKML <linux-kernel@vger.kernel.org>,
        oprofile-list <oprofile-list@lists.sourceforge.net>,
        Robert Richter <robert.richter@amd.com>,
        Andi Kleen <andi@firstfloor.org>
Subject: [PATCH 2/2] oprofile: Remove 'WQ on CPUx, prefer CPUy' warning
Date: Fri, 24 Aug 2012 20:53:31 +0200
Message-ID: <1345834411-24940-3-git-send-email-robert.richter@amd.com>
X-Mailer: git-send-email 1.7.8.6
In-Reply-To: <1345834411-24940-1-git-send-email-robert.richter@amd.com>
References: <1345834411-24940-1-git-send-email-robert.richter@amd.com>
MIME-Version: 1.0
Content-Type: text/plain
X-OriginatorOrg: amd.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Under certain workloads we see the following warnings:

 WQ on CPU0, prefer CPU1
 WQ on CPU0, prefer CPU2
 WQ on CPU0, prefer CPU3

It warns the user that the wq to access a per-cpu buffers runs not on
the same cpu. This happens if the wq is rescheduled on a different cpu
than where the buffer is located. This was probably implemented to
detect performance issues. Not sure if there actually is one as the
buffers are copied to a single buffer anyway which should be the
actual bottleneck.

We wont change WQ implementation. Since a user can do nothing the
warning is pointless. Removing it.

Cc: Andi Kleen <andi@firstfloor.org>
Signed-off-by: Robert Richter <robert.richter@amd.com>
---
 drivers/oprofile/cpu_buffer.c |   11 +++--------
 1 files changed, 3 insertions(+), 8 deletions(-)

diff --git a/drivers/oprofile/cpu_buffer.c b/drivers/oprofile/cpu_buffer.c
index b8ef8dd..8aa73fa 100644
--- a/drivers/oprofile/cpu_buffer.c
+++ b/drivers/oprofile/cpu_buffer.c
@@ -451,14 +451,9 @@ static void wq_sync_buffer(struct work_struct *work)
 {
 	struct oprofile_cpu_buffer *b =
 		container_of(work, struct oprofile_cpu_buffer, work.work);
-	if (b->cpu != smp_processor_id()) {
-		printk(KERN_DEBUG "WQ on CPU%d, prefer CPU%d\n",
-		       smp_processor_id(), b->cpu);
-
-		if (!cpu_online(b->cpu)) {
-			cancel_delayed_work(&b->work);
-			return;
-		}
+	if (b->cpu != smp_processor_id() && !cpu_online(b->cpu)) {
+		cancel_delayed_work(&b->work);
+		return;
 	}
 	sync_buffer(b->cpu);
 
-- 
1.7.8.6


