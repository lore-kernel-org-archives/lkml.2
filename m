Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757446Ab2JZIuf (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Oct 2012 04:50:35 -0400
Received: from casper.infradead.org ([85.118.1.10]:39242 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755492Ab2JZIuc convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Oct 2012 04:50:32 -0400
Message-ID: <1351241389.12171.45.camel@twins>
Subject: Re: [PATCH 01/16] math128: Introduce various 128bit primitives
From: Peter Zijlstra <peterz@infradead.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Juri Lelli <juri.lelli@gmail.com>, tglx@linutronix.de, mingo@redhat.com,
        rostedt@goodmis.org, oleg@redhat.com, fweisbec@gmail.com,
        darren@dvhart.com, johan.eker@ericsson.com, p.faure@akatech.ch,
        linux-kernel@vger.kernel.org, claudio@evidence.eu.com,
        michael@amarulasolutions.com, fchecconi@gmail.com,
        tommaso.cucinotta@sssup.it, nicola.manica@disi.unitn.it,
        luca.abeni@unitn.it, dhaval.giani@gmail.com, hgu1972@gmail.com,
        paulmck@linux.vnet.ibm.com, raistlin@linux.it, insop.song@ericsson.com,
        liming.wang@windriver.com, jkacur@redhat.com,
        harald.gustafsson@ericsson.com, vincent.guittot@linaro.org,
        Ingo Molnar <mingo@kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>
Date: Fri, 26 Oct 2012 10:49:49 +0200
In-Reply-To: <CA+55aFx5jCKtEbEY9iuv0J2TFipkwJP=tBH-F2x_bzJG1RBzTQ@mail.gmail.com>
References: <1351115634-8420-1-git-send-email-juri.lelli@gmail.com>
	 <1351115634-8420-2-git-send-email-juri.lelli@gmail.com>
	 <CA+55aFwLnz4ZNgKxJ6ANn7usppJC_OKHy0uVuh2+EhYTuiL5yw@mail.gmail.com>
	 <1351172849.12171.10.camel@twins>
	 <CA+55aFx5jCKtEbEY9iuv0J2TFipkwJP=tBH-F2x_bzJG1RBzTQ@mail.gmail.com>
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
X-Mailer: Evolution 3.2.2- 
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2012-10-25 at 15:26 -0700, Linus Torvalds wrote:
> it's the *rest* of the "u128" math I really object to. I also wonder
> about the u64xu64 math case for SCHED_DEADLINE, because I assume that
> it doesn't actually end up using the 128-bit result in that form, but
> scales it down again some way? 

No, it does a compare on two u128, so it doesn't loose any precision.
If it were to scale down again and loose precision I'd agree with you
that introducing the u128 stuff is pointless.

The point is (as mentioned in the comments below) overflowing an actual
u64 is rare, however since some of this (specifically the
dl_{runtime,deadline} parameters) is user specified, we have to assume
we will overflow.

---

+/*
+ * Here we check if --at time t-- an entity (which is probably being
+ * [re]activated or, in general, enqueued) can use its remaining runtime
+ * and its current deadline _without_ exceeding the bandwidth it is
+ * assigned (function returns true if it can't). We are in fact applying
+ * one of the CBS rules: when a task wakes up, if the residual runtime
+ * over residual deadline fits within the allocated bandwidth, then we
+ * can keep the current (absolute) deadline and residual budget without
+ * disrupting the schedulability of the system. Otherwise, we should
+ * refill the runtime and set the deadline a period in the future,
+ * because keeping the current (absolute) deadline of the task would
+ * result in breaking guarantees promised to other tasks.
+ *
+ * This function returns true if:
+ *
+ *   runtime / (deadline - t) > dl_runtime / dl_deadline ,
+ *
+ * IOW we can't recycle current parameters.
+ */
+static bool dl_entity_overflow(struct sched_dl_entity *dl_se, u64 t)
+{
+       u128 left, right;
+
+       /*
+        * left and right are the two sides of the equation above,
+        * after a bit of shuffling to use multiplications instead
+        * of divisions.
+        *
+        * Note that none of the time values involved in the two
+        * multiplications are absolute: dl_deadline and dl_runtime
+        * are the relative deadline and the maximum runtime of each
+        * instance, runtime is the runtime left for the last instance
+        * and (deadline - t), since t is rq->clock, is the time left
+        * to the (absolute) deadline. Therefore, overflowing the u64
+        * type is very unlikely to occur in both cases.
+        */
+       left = mul_u64_u64(dl_se->dl_deadline, dl_se->runtime);
+       right = mul_u64_u64((dl_se->deadline - t), dl_se->dl_runtime);
+
+       if (cmp_u128(left, right) > 0)
+               return true;
+
+       return false;
+}
