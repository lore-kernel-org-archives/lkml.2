Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756655Ab2DTXPF (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Apr 2012 19:15:05 -0400
Received: from wolverine02.qualcomm.com ([199.106.114.251]:37458 "EHLO
	wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756574Ab2DTXPC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Apr 2012 19:15:02 -0400
X-IronPort-AV: E=McAfee;i="5400,1158,6687"; a="181387050"
Message-ID: <4F91EDF5.6020003@codeaurora.org>
Date: Fri, 20 Apr 2012 16:15:01 -0700
From: Stephen Boyd <sboyd@codeaurora.org>
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:11.0) Gecko/20120327 Thunderbird/11.0.1
MIME-Version: 1.0
To: Tejun Heo <tj@kernel.org>
CC: linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        Ben Dooks <ben-linux@fluff.org>
Subject: Re: [PATCH 1/2] workqueue: Catch more locking problems with flush_work()
References: <1334805958-29119-1-git-send-email-sboyd@codeaurora.org> <20120419152841.GA10553@google.com> <4F905521.9020901@codeaurora.org> <20120420173529.GD32324@google.com>
In-Reply-To: <20120420173529.GD32324@google.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 4/20/2012 10:35 AM, Tejun Heo wrote:
>
> All that's necessary is acquiring and releasing work->lockdep_map.
> There's no need to nest start_flush_work() inside it.  Without
> nesting, there's nothing to worry about ABBA lockdeps.

Yes I see. This patch should work then?

diff --git a/kernel/workqueue.c b/kernel/workqueue.c
index 5abf42f..038cf64 100644
--- a/kernel/workqueue.c
+++ b/kernel/workqueue.c
@@ -2506,6 +2506,9 @@ bool flush_work(struct work_struct *work)
 {
        struct wq_barrier barr;

+       lock_map_acquire(&work->lockdep_map);
+       lock_map_release(&work->lockdep_map);
+
        if (start_flush_work(work, &barr, true)) {
                wait_for_completion(&barr.done);
                destroy_work_on_stack(&barr.work);


-- 
Sent by an employee of the Qualcomm Innovation Center, Inc.
The Qualcomm Innovation Center, Inc. is a member of the Code Aurora Forum.

