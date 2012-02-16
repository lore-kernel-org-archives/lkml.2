Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753493Ab2BPQ6p (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Feb 2012 11:58:45 -0500
Received: from casper.infradead.org ([85.118.1.10]:33763 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751791Ab2BPQ6m convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Feb 2012 11:58:42 -0500
Message-ID: <1329411510.2293.254.camel@twins>
Subject: Re: [RFC PATCH 14/14] sched: implement usage tracking
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: Paul Turner <pjt@google.com>
Cc: linux-kernel@vger.kernel.org, Venki Pallipadi <venki@google.com>,
        Srivatsa Vaddagiri <vatsa@in.ibm.com>, Mike Galbraith <efault@gmx.de>,
        Kamalesh Babulal <kamalesh@linux.vnet.ibm.com>,
        Ben Segall <bsegall@google.com>, Ingo Molnar <mingo@elte.hu>,
        Vaidyanathan Srinivasan <svaidy@linux.vnet.ibm.com>
Date: Thu, 16 Feb 2012 17:58:30 +0100
In-Reply-To: <20120202013827.20844.49057.stgit@kitami.mtv.corp.google.com>
References: <20120202013825.20844.26081.stgit@kitami.mtv.corp.google.com>
	 <20120202013827.20844.49057.stgit@kitami.mtv.corp.google.com>
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
X-Mailer: Evolution 3.2.2- 
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2012-02-01 at 17:38 -0800, Paul Turner wrote:
>  struct sched_avg {
>         u64 runnable_avg_sum, runnable_avg_period;
>         u64 last_runnable_update, decay_count;
> +       u32 usage_avg_sum;

4 byte hole

>         unsigned long load_avg_contrib;
>  
>         int contributes_blocked_load; 
>};


A) Running/Runnable
    - uses last_runnable_update to track
        runnable_avg_sum, usage_avg_sum and runnable_avg_period

B) Blocked
    - uses decay_count to keep track of sleeptime

C) 'Migrate'
    - uses contributes_blocked_load to check if we actually did migrate?

So there's a number of things I don't get, why have
remove_task_load_avg_async() in set_task_rq()? enqueue_entity_load_avg()
can do the __synchronize_entity_decay() thing (and actually does) just
fine, right?

Similarly, why not use last_runnable_update (as last_update) to track
both A and B since a task cannot be in both states at the same time
anyway. If you always update the timestamp you can use it to either
track runnable/usage or decay for sleep.

That would get rid of decay_count and contributes_blocked_load, no?
