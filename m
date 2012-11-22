Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756461Ab2KVTII (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Nov 2012 14:08:08 -0500
Received: from dupo.coraid.com ([208.71.232.133]:49183 "EHLO coraid.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1755663Ab2KVTIF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Nov 2012 14:08:05 -0500
Message-Id: <c6f755789c41f2ad86366683ab373ee358a22643.1353518444.git.ecashin@coraid.com>
In-Reply-To: <cover.1353518444.git.ecashin@coraid.com>
References: <cover.1353518444.git.ecashin@coraid.com>
From: Ed Cashin <ecashin@coraid.com>
Subject: [PATCH 1/8] aoe: copy fallback timing information on destination failover
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, ecashin@coraid.com
From: Ed Cashin <ecashin@coraid.com>
X-Mailer: nedmail
Date: Wed, 21 Nov 2012 19:54:14 -0500
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The commit f3b8e07af7744cbb, "aoe: commands in retransmit queue
use new destination on failure", omits the copying of the
coarse-grained time when an AoE command was sent during the
failover from one destination MAC address on the AoE target to
another.

The coarse-grained timing is only used when the system time
changes or an unlikely length of time has passed since the
sending of the AoE command.  Users will not be impacted unless
their system clock is very inaccurate or something unusual (e.g.,
10 GbE link reset) happens during the period when the aoe driver
is handling the failure of a port on the AoE target.  Being
effected will mean that an AoE target could be considered "down"
too eagerly.

Signed-off-by: Ed Cashin <ecashin@coraid.com>
---
 drivers/block/aoe/aoecmd.c |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/drivers/block/aoe/aoecmd.c b/drivers/block/aoe/aoecmd.c
index d9bc6ff..d609c47 100644
--- a/drivers/block/aoe/aoecmd.c
+++ b/drivers/block/aoe/aoecmd.c
@@ -581,6 +581,7 @@ reassign_frame(struct list_head *pos)
 	nf->waited = 0;
 	nf->waited_total = f->waited_total;
 	nf->sent = f->sent;
+	nf->sent_jiffs = f->sent_jiffs;
 	f->skb = skb;
 	aoe_freetframe(f);
 	f->t->nout--;
-- 
1.7.1

