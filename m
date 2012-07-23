Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753829Ab2GWCEW (ORCPT <rfc822;w@1wt.eu>);
	Sun, 22 Jul 2012 22:04:22 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:54094 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753131Ab2GWBmj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 22 Jul 2012 21:42:39 -0400
Message-Id: <20120723010704.519968474@decadent.org.uk>
User-Agent: quilt/0.60-1
Date: Mon, 23 Jul 2012 02:08:17 +0100
From: Ben Hutchings <ben@decadent.org.uk>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org,
        alan@lxorguk.ukuu.org.uk, Nadav HarEl <nyh@math.technion.ac.il>,
        Nadav HarEl <nyh@il.ibm.com>, "Michael S. Tsirkin" <mst@redhat.com>
Subject: [ 086/108] vhost: dont forget to schedule()
In-Reply-To: <20120723010651.408577075@decadent.org.uk>
X-SA-Exim-Connect-IP: 2001:470:1f08:1539:21c:bfff:fe03:f805
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Nadav Har'El <nyh@math.technion.ac.il>

commit d550dda192c1bd039afb774b99485e88b70d7cb8 upstream.

This is a tiny, but important, patch to vhost.

Vhost's worker thread only called schedule() when it had no work to do, and
it wanted to go to sleep. But if there's always work to do, e.g., the guest
is running a network-intensive program like netperf with small message sizes,
schedule() was *never* called. This had several negative implications (on
non-preemptive kernels):

 1. Passing time was not properly accounted to the "vhost" process (ps and
    top would wrongly show it using zero CPU time).

 2. Sometimes error messages about RCU timeouts would be printed, if the
    core running the vhost thread didn't schedule() for a very long time.

 3. Worst of all, a vhost thread would "hog" the core. If several vhost
    threads need to share the same core, typically one would get most of the
    CPU time (and its associated guest most of the performance), while the
    others hardly get any work done.

The trivial solution is to add

	if (need_resched())
		schedule();

After doing every piece of work. This will not do the heavy schedule() all
the time, just when the timer interrupt decided a reschedule is warranted
(so need_resched returns true).

Thanks to Abel Gordon for this patch.

Signed-off-by: Nadav Har'El <nyh@il.ibm.com>
Signed-off-by: Michael S. Tsirkin <mst@redhat.com>
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 drivers/vhost/vhost.c |    2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/vhost/vhost.c b/drivers/vhost/vhost.c
index c14c42b..ae66278 100644
--- a/drivers/vhost/vhost.c
+++ b/drivers/vhost/vhost.c
@@ -222,6 +222,8 @@ static int vhost_worker(void *data)
 		if (work) {
 			__set_current_state(TASK_RUNNING);
 			work->fn(work);
+			if (need_resched())
+				schedule();
 		} else
 			schedule();
 


