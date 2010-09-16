Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755344Ab0IPSZw (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Sep 2010 14:25:52 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:35120 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754164Ab0IPSZv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Sep 2010 14:25:51 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Tejun Heo <tj@kernel.org>
Subject: Re: [RFC][PATCH] PM / Runtime: Use alloc_workqueue() for creating PM workqueue
Date: Thu, 16 Sep 2010 20:24:51 +0200
User-Agent: KMail/1.13.5 (Linux/2.6.36-rc4-rjw+; KDE/4.4.4; x86_64; ; )
Cc: "Linux-pm mailing list" <linux-pm@lists.linux-foundation.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Alan Stern <stern@rowland.harvard.edu>,
        Arjan van de Ven <arjan@infradead.org>
References: <201009152156.30749.rjw@sisk.pl> <4C91D132.6090607@kernel.org>
In-Reply-To: <4C91D132.6090607@kernel.org>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <201009162024.51520.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday, September 16, 2010, Tejun Heo wrote:
> Hello, Rafael.
> 
> On 09/15/2010 09:56 PM, Rafael J. Wysocki wrote:
> > I'm not sure about that WQ_RESCUER thing.  Can you please tell me what
> > exactly it is for?
> 
> It's to guarantee forward progress for workqueues which process work
> items which may be used to reclaim memory.  It reserves a rescue
> worker thread to be used under memory pressure.  I finished workqueue
> documentation a few days ago and sent pull request to Linus.
> 
>   http://git.kernel.org/?p=linux/kernel/git/tj/wq.git;a=blob;f=Documentation/workqueue.txt;h=e4498a2872c37a0b3b156ddc7ad7135d030d224d;hb=c54fce6eff197d9c57c97afbf6c9722ce434fc8f
> 
> So, for pm_wq, there's no reason to use WQ_RESUER.
> alloc_workqueue("pm", WQ_FREEZEABLE, 0) should do it.

Great, thanks!

> Thanks for doing it.

No big deal.  Actually I should thank you for making it possible to use
freezable workqueues that are not singlethread. :-)

Updated patch follows.

Thanks,
Rafael

---
From: Rafael J. Wysocki <rjw@sisk.pl>
Subject: PM / Runtime: Use alloc_workqueue() for creating the PM workqueue

Although we need the PM workqueue to be freezable, we don't need it
to be singlethread.  Also, the number of concurrent work items
running on a single CPU need not be constrained.  For these reasons
use alloc_workqueue() directly, with suitable arguments, instead of
create_freezeable_workqueue(), to create the runtime PM workqueue.

Signed-off-by: Rafael J. Wysocki <rjw@sisk.pl>
---
 kernel/power/main.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

Index: linux-2.6/kernel/power/main.c
===================================================================
--- linux-2.6.orig/kernel/power/main.c
+++ linux-2.6/kernel/power/main.c
@@ -308,7 +308,7 @@ EXPORT_SYMBOL_GPL(pm_wq);
 
 static int __init pm_start_workqueue(void)
 {
-	pm_wq = create_freezeable_workqueue("pm");
+	pm_wq = alloc_workqueue("pm", WQ_FREEZEABLE, 0);
 
 	return pm_wq ? 0 : -ENOMEM;
 }
