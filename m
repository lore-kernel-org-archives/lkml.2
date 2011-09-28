Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756074Ab1I1XCg (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Sep 2011 19:02:36 -0400
Received: from cantor2.suse.de ([195.135.220.15]:54715 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933165Ab1I1Wrp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Sep 2011 18:47:45 -0400
X-Mailbox-Line: From gregkh@clark.kroah.org Wed Sep 28 15:01:42 2011
Message-Id: <20110928220142.379302679@clark.kroah.org>
User-Agent: quilt/0.48-16.4
Date: Wed, 28 Sep 2011 15:02:06 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Jan Glauber <jang@linux.vnet.ibm.com>,
        Martin Schwidefsky <schwidefsky@de.ibm.com>
Subject: [162/244] [S390] qdio: clear shared DSCI before scheduling the queue handler
In-Reply-To: <20110928220225.GA27128@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.0-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Jan Glauber <jang@linux.vnet.ibm.com>

commit b02f0c2ea25781e0f94b4fc8f6f85582057857b3 upstream.

The following race can occur with qdio devices that use the shared device
state change indicator:

Device (Shared DSCI)    CPU0                            CPU1
===============================================================================

1. DSCI 0 => 1,
   INT pending
                        2. Thinint handler
                        * si_used = 1
                        * Inbound tasklet_schedule
                        * DSCI 1 => 0

3. DSCI 0 => 1,
   INT pending

                                                        4. Thinint handler
                                                        * si_used = 1
                                                        * Inbound tasklet_schedu
le
                                                           => NOP

                        5. Inbound tasklet run

6. DSCI = 1,
   INT surpressed

                                                        7. DSCI 1 => 0

The race would lead to a stall where new data in the input queue is
not recognized so the device stops working in case of no further traffic.

Fix the race by resetting the DSCI before scheduling the inbound tasklet
so the device generates an interrupt if new data arrives in the above
scenario in step 6.

Reviewed-by: Ursula Braun <ursula.braun@de.ibm.com>
Signed-off-by: Jan Glauber <jang@linux.vnet.ibm.com>
Signed-off-by: Martin Schwidefsky <schwidefsky@de.ibm.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/s390/cio/qdio_thinint.c |   15 +++++----------
 1 file changed, 5 insertions(+), 10 deletions(-)

--- a/drivers/s390/cio/qdio_thinint.c
+++ b/drivers/s390/cio/qdio_thinint.c
@@ -95,9 +95,11 @@ void tiqdio_remove_input_queues(struct q
 	}
 }
 
-static inline u32 shared_ind_set(void)
+static inline u32 clear_shared_ind(void)
 {
-	return q_indicators[TIQDIO_SHARED_IND].ind;
+	if (!atomic_read(&q_indicators[TIQDIO_SHARED_IND].count))
+		return 0;
+	return xchg(&q_indicators[TIQDIO_SHARED_IND].ind, 0);
 }
 
 /**
@@ -107,7 +109,7 @@ static inline u32 shared_ind_set(void)
  */
 static void tiqdio_thinint_handler(void *alsi, void *data)
 {
-	u32 si_used = shared_ind_set();
+	u32 si_used = clear_shared_ind();
 	struct qdio_q *q;
 
 	last_ai_time = S390_lowcore.int_clock;
@@ -150,13 +152,6 @@ static void tiqdio_thinint_handler(void
 		qperf_inc(q, adapter_int);
 	}
 	rcu_read_unlock();
-
-	/*
-	 * If the shared indicator was used clear it now after all queues
-	 * were processed.
-	 */
-	if (si_used && shared_ind_set())
-		xchg(&q_indicators[TIQDIO_SHARED_IND].ind, 0);
 }
 
 static int set_subchannel_ind(struct qdio_irq *irq_ptr, int reset)


