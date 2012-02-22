Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752121Ab2BVM6O (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Feb 2012 07:58:14 -0500
Received: from multi.imgtec.com ([194.200.65.239]:34176 "EHLO multi.imgtec.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751186Ab2BVM6M (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Feb 2012 07:58:12 -0500
Message-ID: <4F44E65E.8010604@imgtec.com>
Date: Wed, 22 Feb 2012 12:58:06 +0000
From: James Hogan <james.hogan@imgtec.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.15) Gecko/20101027 Fedora/3.0.10-1.fc12 Lightning/1.0b2pre Thunderbird/3.0.10
MIME-Version: 1.0
To: linux-kernel <linux-kernel@vger.kernel.org>, <linux-media@vger.kernel.org>,
        Pekka Enberg <penberg@kernel.org>, Jarod Wilson <jarod@redhat.com>,
        Mauro Carvalho Chehab <mchehab@infradead.org>,
        Stephen Rothwell <sfr@canb.auug.org.au>,
        Lucas De Marchi <lucas.demarchi@profusion.mobi>,
        Paul Gortmaker <paul.gortmaker@windriver.com>
Subject: [PATCH RESEND] rc/ir-raw: fix BUG_ON, using kfifo_rec_ptr_1 instead
 of kfifo
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 22 Feb 2012 12:58:06.0734 (UTC) FILETIME=[9EECC2E0:01CCF161]
X-SEF-Processed: 7_3_0_01181__2012_02_22_12_58_07
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Raw IR events are passed to the raw event thread through a kfifo. The
size of the event struct is 12 bytes, and space for 512 events is
reserved in the kfifo (6144 bytes), however this is rounded down to 4096
bytes (the next power of 2) by __kfifo_alloc().

4096 bytes is not divisible by 12 therefore if the fifo fills up, a
third of a record will be written in the end of the kfifo by
ir_raw_event_store() because the recsize of the fifo is 0 (it doesn't
have records). When this is read by ir_raw_event_thread() a corrupted or
partial record will be read, and in the case of a partial record the
BUG_ON(retval != sizeof(ev)) gets hit too.

According to samples/kfifo/record-example.c struct kfifo_rec_ptr_1 can
handle records of a length between 0 and 255 bytes, so change struct
ir_raw_event_ctrl to use that instead of struct kfifo.

Signed-off-by: James Hogan <james.hogan@imgtec.com>
---
 drivers/media/rc/rc-core-priv.h |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/media/rc/rc-core-priv.h b/drivers/media/rc/rc-core-priv.h
index c6ca870..989ea08 100644
--- a/drivers/media/rc/rc-core-priv.h
+++ b/drivers/media/rc/rc-core-priv.h
@@ -35,7 +35,7 @@ struct ir_raw_event_ctrl {
 	struct list_head		list;		/* to keep track of raw clients */
 	struct task_struct		*thread;
 	spinlock_t			lock;
-	struct kfifo			kfifo;		/* fifo for the pulse/space durations */
+	struct kfifo_rec_ptr_1		kfifo;		/* fifo for the pulse/space durations */
 	ktime_t				last_event;	/* when last event occurred */
 	enum raw_event_type		last_type;	/* last event type */
 	struct rc_dev			*dev;		/* pointer to the parent rc_dev */
-- 
1.7.2.3


