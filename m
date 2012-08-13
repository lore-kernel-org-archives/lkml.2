Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752018Ab2HMRnb (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Aug 2012 13:43:31 -0400
Received: from mail-yx0-f174.google.com ([209.85.213.174]:36866 "EHLO
	mail-yx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751762Ab2HMRn3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Aug 2012 13:43:29 -0400
MIME-Version: 1.0
In-Reply-To: <20120813170303.GF9180@google.com>
References: <1344874672-6257-1-git-send-email-js1304@gmail.com>
	<1344874672-6257-2-git-send-email-js1304@gmail.com>
	<20120813163219.GA9180@google.com>
	<CAAmzW4NfPAVQnmD0vG71Ahz_=gmV7CQBNABpnEHFU7YBsYJOyQ@mail.gmail.com>
	<20120813170303.GF9180@google.com>
Date: Tue, 14 Aug 2012 02:43:28 +0900
Message-ID: <CAAmzW4Nfzq6i-KHky2qb1Qzgg1psVVEAME_mkzLfUWYGBXjH_Q@mail.gmail.com>
Subject: Re: [PATCH 2/5] workqueue: change value of lcpu in queue_delayed_work_on()
From: JoonSoo Kim <js1304@gmail.com>
To: Tejun Heo <tj@kernel.org>
Cc: linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>> And, do u mean  @cpu is WORK_CPU_UNBOUND?
>
> @cpu could be WORK_CPU_UNBOUND at that point.  The timer will be added
> to local CPU but @work->data would be pointing to WORK_CPU_UNBOUND,
> again triggering the condition.  Given that @cpu being
> WORK_CPU_UNBOUND is far more common than an actual CPU number, the
> patch would actually increase spurious nrt lookups.  The right thing
> to do is probably setting cpu to raw_smp_processor_id() beforehand.

I got your point.
Thanks for kind illustration.

Following is a alternative implementation for this.
I thinks this is too rare case, so it doesn't help in any real workload.
But how do you thinks?

@@ -1156,7 +1156,9 @@ int queue_delayed_work_on(int cpu, struct
workqueue_struct *wq,
                if (!(wq->flags & WQ_UNBOUND)) {
                        struct global_cwq *gcwq = get_work_gcwq(work);

-                       if (gcwq && gcwq->cpu != WORK_CPU_UNBOUND)
+                       if (!gcwq)
+                               lcpu = cpu;
+                       else if (gcwq->cpu != WORK_CPU_UNBOUND)
                                lcpu = gcwq->cpu;
                        else
                                lcpu = raw_smp_processor_id();
