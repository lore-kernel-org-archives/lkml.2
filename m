Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760757Ab2EWSZE (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 May 2012 14:25:04 -0400
Received: from mail-pz0-f46.google.com ([209.85.210.46]:59226 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760655Ab2EWSZC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 May 2012 14:25:02 -0400
Date: Wed, 23 May 2012 11:24:57 -0700
From: Tejun Heo <tj@kernel.org>
To: =?iso-8859-1?Q?J=F6rg-Volker?= Peetz <jvpeetz@web.de>
Cc: linux-kernel@vger.kernel.org
Subject: Re: Linux 3.4 released
Message-ID: <20120523182457.GD18143@google.com>
References: <CA+55aFwaobhbBZkE1LTyQJYhk8w8zk-cyOXXuXfPyE=BXzT3PA@mail.gmail.com>
 <4FBBB11D.7020904@web.de>
 <20120522155345.GC14339@google.com>
 <4FBBC461.4060008@web.de>
 <20120522170320.GD14339@google.com>
 <jpglns$1uj$1@dough.gmane.org>
 <CAOS58YPMh_hbJ4a49j4p9H68n8U1LzMUuaxmHx57gVTkmfxF6A@mail.gmail.com>
 <4FBBEDF2.8060803@web.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <4FBBEDF2.8060803@web.de>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello, Jörg-Volker.

Please always use reply-to-all.

On Tue, May 22, 2012 at 09:50:10PM +0200, Jörg-Volker Peetz wrote:
> no, changing to  printk(KERN_CRIT "XXX: ...", ...)  in kernel/workqueue.c didn't
> print anything I could read. Would it appear before the "panic screen"? But I'm
> not able to scroll back.
> The Panic screen starts with

It should appear right above BUG:.  Can you please try the following
instead?

Thanks.

diff --git a/kernel/workqueue.c b/kernel/workqueue.c
index 5abf42f..57c33ef 100644
--- a/kernel/workqueue.c
+++ b/kernel/workqueue.c
@@ -1096,10 +1096,18 @@ queue_work_on(int cpu, struct workqueue_struct *wq, struct work_struct *work)
 }
 EXPORT_SYMBOL_GPL(queue_work_on);
 
+#include <linux/uaccess.h>
 static void delayed_work_timer_fn(unsigned long __data)
 {
 	struct delayed_work *dwork = (struct delayed_work *)__data;
 	struct cpu_workqueue_struct *cwq = get_work_cwq(&dwork->work);
+	unsigned long v;
+
+	if (probe_kernel_read(&v, &cwq->wq, sizeof(v))) {
+		printk(KERN_CRIT "XXX delayed_work_timer_fn: cwq %p, fn=%pf\n",
+		       cwq, dwork->work.func);
+		return;
+	}
 
 	__queue_work(smp_processor_id(), cwq->wq, &dwork->work);
 }
