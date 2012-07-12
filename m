Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1162897Ab2GLXGS (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Jul 2012 19:06:18 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:60424 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1162849Ab2GLXGM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Jul 2012 19:06:12 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Greg KH <gregkh@linuxfoundation.org>, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Nadav HarEl <nyh@il.ibm.com>, "Michael S. Tsirkin" <mst@redhat.com>,
        Jean Delvare <jdelvare@suse.de>
Subject: [ 55/68] vhost: dont forget to schedule()
Date: Thu, 12 Jul 2012 16:02:29 -0700
Message-Id: <20120712175040.306342694@linuxfoundation.org>
X-Mailer: git-send-email 1.7.10.1.362.g242cab3
In-Reply-To: <20120712175035.530652872@linuxfoundation.org>
References: <20120712175057.GA9917@kroah.com>
 <20120712175035.530652872@linuxfoundation.org>
User-Agent: quilt/0.60-20.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Greg KH <gregkh@linuxfoundation.org>

3.0-stable review patch.  If anyone has any objections, please let me know.

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
Cc: Jean Delvare <jdelvare@suse.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/vhost/vhost.c |    2 ++
 1 file changed, 2 insertions(+)

--- a/drivers/vhost/vhost.c
+++ b/drivers/vhost/vhost.c
@@ -217,6 +217,8 @@ static int vhost_worker(void *data)
 		if (work) {
 			__set_current_state(TASK_RUNNING);
 			work->fn(work);
+			if (need_resched())
+				schedule();
 		} else
 			schedule();
 


