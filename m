Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932129Ab2LROtB (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Dec 2012 09:49:01 -0500
Received: from am1ehsobe005.messaging.microsoft.com ([213.199.154.208]:50207
	"EHLO am1outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932095Ab2LROs7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Dec 2012 09:48:59 -0500
X-Forefront-Antispam-Report: CIP:193.138.13.20;KIP:(null);UIP:(null);IPV:NLI;H:oce-exbhcs03a.oce.net;RD:smtp02.oce.com;EFVD:NLI
X-SpamScore: 17
X-BigFish: VS17(zzzz1ce5h1202h1e76h1d1ah1cabh1d2ahzz8275bh8275dhz2ei87h668h839hd24he5bhf0ah1288h12a5h12a9h12bdh12e5h137ah139eh13b6h1441h1504h1537h15a8h162dh1631h1758hff4m129fs1155h)
X-FB-DOMAIN-IP-MATCH: fail
From: Ivo Sieben <meltedpianoman@gmail.com>
To: <linux-serial@vger.kernel.org>, Alan Cox <alan@linux.intel.com>,
        Greg KH <gregkh@linuxfoundation.org>
CC: Oleg Nesterov <oleg@redhat.com>, <linux-kernel@vger.kernel.org>,
        Andi Kleen <andi@firstfloor.org>,
        Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@redhat.com>,
        Ivo Sieben <meltedpianoman@gmail.com>
Subject: [PATCH] tty: Only wakeup the line discipline idle queue when queue is active
Date: Tue, 18 Dec 2012 15:48:50 +0100
Message-ID: <1355842130-15482-1-git-send-email-meltedpianoman@gmail.com>
X-Mailer: git-send-email 1.7.9.5
X-OriginalArrivalTime: 18 Dec 2012 14:48:54.0834 (UTC) FILETIME=[CD6D5120:01CDDD2E]
MIME-Version: 1.0
Content-Type: text/plain
X-OriginatorOrg: oce.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Before waking up the tty line discipline idle queue first check if the queue is
active (non empty). This prevents unnecessary entering the critical section in
the wake_up() function and therefore avoid needless scheduling overhead on a
PREEMPT_RT system caused by two processes being in the same critical section.

Signed-off-by: Ivo Sieben <meltedpianoman@gmail.com>
---

 Remark:
 This patch has kind of a long history... I first tried to prevent the critical
 section in the wakeup() function itself by a change in the scheduler. But after
 review remarks from Oleg Nesterov it turned out that using the
 waitqueue_active() was a much nicer way to prevent it. See also
 https://lkml.org/lkml/2012/10/25/159

 drivers/tty/tty_ldisc.c |    4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/tty/tty_ldisc.c b/drivers/tty/tty_ldisc.c
index c578229..e96d187 100644
--- a/drivers/tty/tty_ldisc.c
+++ b/drivers/tty/tty_ldisc.c
@@ -64,7 +64,9 @@ static void put_ldisc(struct tty_ldisc *ld)
 		return;
 	}
 	raw_spin_unlock_irqrestore(&tty_ldisc_lock, flags);
-	wake_up(&ld->wq_idle);
+
+	if (waitqueue_active(&ld->wq_idle))
+		wake_up(&ld->wq_idle);
 }
 
 /**
-- 
1.7.9.5


