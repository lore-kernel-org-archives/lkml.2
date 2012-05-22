Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758309Ab2EVRD2 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 May 2012 13:03:28 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:62433 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754657Ab2EVRD0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 May 2012 13:03:26 -0400
Date: Tue, 22 May 2012 10:03:20 -0700
From: Tejun Heo <tj@kernel.org>
To: =?iso-8859-1?Q?J=F6rg-Volker?= Peetz <jvpeetz@web.de>
Cc: linux-kernel@vger.kernel.org
Subject: Re: Linux 3.4 released
Message-ID: <20120522170320.GD14339@google.com>
References: <CA+55aFwaobhbBZkE1LTyQJYhk8w8zk-cyOXXuXfPyE=BXzT3PA@mail.gmail.com>
 <4FBBB11D.7020904@web.de>
 <20120522155345.GC14339@google.com>
 <4FBBC461.4060008@web.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <4FBBC461.4060008@web.de>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, May 22, 2012 at 06:52:49PM +0200, Jörg-Volker Peetz wrote:
> I tried the above patch but was not able to see a line beginning with "XXX", not
> on the text-console nor in any log-file. After the hard-lock, I can see only the
> console-screen which now changed slightly:
> 
> BUG: Unable to handle kernel NULL pointer dereference at 0000000000000008
> IP: [<ffffffff8103ed60>] delayed_work_timer_fn+0x30/0x60

Oh, &cwq->wq is at offset 8 so cwq should have been -8.  Maybe I'm
just confused.  Can you please try the following instead?

diff --git a/kernel/workqueue.c b/kernel/workqueue.c
index 5abf42f..14babfe 100644
--- a/kernel/workqueue.c
+++ b/kernel/workqueue.c
@@ -1096,10 +1096,16 @@ queue_work_on(int cpu, struct workqueue_struct *wq, struct work_struct *work)
 }
 EXPORT_SYMBOL_GPL(queue_work_on);
 
+#include <linux/uaccess.h>
 static void delayed_work_timer_fn(unsigned long __data)
 {
 	struct delayed_work *dwork = (struct delayed_work *)__data;
 	struct cpu_workqueue_struct *cwq = get_work_cwq(&dwork->work);
+	unsigned long v;
+
+	if (probe_kernel_read(&v, &cwq->wq, sizeof(v)))
+		printk("XXX delayed_work_timer_fn: cwq %p, fn=%pf\n",
+		       cwq, dwork->work.func);
 
 	__queue_work(smp_processor_id(), cwq->wq, &dwork->work);
 }
