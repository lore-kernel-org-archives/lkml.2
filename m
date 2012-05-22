Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932189Ab2EVPxw (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 May 2012 11:53:52 -0400
Received: from mail-pz0-f46.google.com ([209.85.210.46]:44993 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759775Ab2EVPxu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 May 2012 11:53:50 -0400
Date: Tue, 22 May 2012 08:53:45 -0700
From: Tejun Heo <tj@kernel.org>
To: =?iso-8859-1?Q?J=F6rg-Volker?= Peetz <jvpeetz@web.de>
Cc: linux-kernel@vger.kernel.org
Subject: Re: Linux 3.4 released
Message-ID: <20120522155345.GC14339@google.com>
References: <CA+55aFwaobhbBZkE1LTyQJYhk8w8zk-cyOXXuXfPyE=BXzT3PA@mail.gmail.com>
 <4FBBB11D.7020904@web.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <4FBBB11D.7020904@web.de>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

On Tue, May 22, 2012 at 05:30:37PM +0200, Jörg-Volker Peetz wrote:
> Switching from self-compiled kernel 3.2 17 to a self compiled kernel 3.4.0,
> a notebook HP Pavilion dv7 gets hard locked with a kernel panic, when trying to
> start a web-cam video viewer (guvcview) for the built-in USB web-cam.
> 
> Please find attached a (hand-typed) screen-shot of the text-console and the
> kernel config.
> 
> By the way, thank you for all the great work on Linux.
> -- 
> Best regards,
> Jörg-Volker.

> BUG: Unable to handle kernel NULL pointer dereference at 0000000000000008
...
> Code: 8b 7c 24 50 48 83 c4 58 c3 66 66 66 2e 0f 1f 84 00 00 00 00 00 48 8b 0f 31 c0 48 89 fa 48 89 ce 40 80 e6 00 83 e1 04 48 0f 45 c6 <48> 8b 70 08 65 8b 3c 25 60 cc 00 00 e9 b9 fc ff ff 66 0f 1f 84
> RIP  [<ffffffff8103ed46>] delayed_work_timer_fn+0x16/0x30

So, that looks like get_work_cwq() returning NULL and then
delayed_work_timer_fn() trying to dereference it.  Either work item is
being corrupted (e.g. freed early) or somebody is mucking with the
work item embedded in a delayed work item.

Something like the following may reveal the offending work function.

Thanks.

diff --git a/kernel/workqueue.c b/kernel/workqueue.c
index 5abf42f..adc1057 100644
--- a/kernel/workqueue.c
+++ b/kernel/workqueue.c
@@ -1101,6 +1101,10 @@ static void delayed_work_timer_fn(unsigned long __data)
 	struct delayed_work *dwork = (struct delayed_work *)__data;
 	struct cpu_workqueue_struct *cwq = get_work_cwq(&dwork->work);
 
+	if (!cwq)
+		printk("XXX delayed_work_timer_fn: NULL cwq, fn=%pf\n",
+		       dwork->work.func);
+
 	__queue_work(smp_processor_id(), cwq->wq, &dwork->work);
 }
 
