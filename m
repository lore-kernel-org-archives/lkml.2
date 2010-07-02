Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757967Ab0GBIf5 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Jul 2010 04:35:57 -0400
Received: from mail-bw0-f46.google.com ([209.85.214.46]:40739 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757952Ab0GBIfw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Jul 2010 04:35:52 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:subject:references
         :in-reply-to:content-type:content-transfer-encoding;
        b=AwshnOX0BwmYci/BRwNqGIn840CptvFCqtYug4Dw5nYewnOyNkZYYTHXmL7MRxXTt9
         J2g59HCBRutO/nlOCKNOztA/uKT/M4oTnKvWYsSL1CB69/BcoEl8t9Y3k+OdPsgnm1cu
         G5HnFwvz+kcEIo2EVtqjc6ydl0qvdkD9T7HVo=
Message-ID: <4C2DA4E2.8030502@gmail.com>
Date: Fri, 02 Jul 2010 10:35:46 +0200
From: Tejun Heo <htejun@gmail.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686 (x86_64); en-US; rv:1.9.1.10) Gecko/20100512 Thunderbird/3.0.5
MIME-Version: 1.0
To: torvalds@linux-foundation.org, mingo@elte.hu, linux-kernel@vger.kernel.org,
       jeff@garzik.org, akpm@linux-foundation.org, rusty@rustcorp.com.au,
       cl@linux-foundation.org, dhowells@redhat.com, arjan@linux.intel.com,
       oleg@redhat.com, axboe@kernel.dk, fweisbec@gmail.com,
       dwalker@codeaurora.org, stefanr@s5r6.in-berlin.de, florian@mickler.org,
       andi@firstfloor.org, mst@redhat.com, randy.dunlap@oracle.com
Subject: [PATCH 4/4] workqueue: fix worker management invocation without pending
 works
References: <1277759063-24607-1-git-send-email-tj@kernel.org> <4C2DA42C.7090804@gmail.com>
In-Reply-To: <4C2DA42C.7090804@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

When there's no pending work to do, worker_thread() goes back to sleep
after waking up without checking whether worker management is
necessary.  This means that idle worker exit requests can be ignored
if the gcwq stays empty.

Fix it by making worker_thread() always check whether worker
management is necessary before going to sleep.

Signed-off-by: Tejun Heo <tj@kernel.org>
---
 kernel/workqueue.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/kernel/workqueue.c b/kernel/workqueue.c
index 0c485a5..2eb9fbd 100644
--- a/kernel/workqueue.c
+++ b/kernel/workqueue.c
@@ -1832,10 +1832,10 @@ recheck:
 	} while (keep_working(gcwq));

 	worker_set_flags(worker, WORKER_PREP, false);
-
+sleep:
 	if (unlikely(need_to_manage_workers(gcwq)) && manage_workers(worker))
 		goto recheck;
-sleep:
+
 	/*
 	 * gcwq->lock is held and there's no work to process and no
 	 * need to manage, sleep.  Workers are woken up only while
-- 
1.6.4.2

