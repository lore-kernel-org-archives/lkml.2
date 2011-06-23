Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759267Ab1FWLuS (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Jun 2011 07:50:18 -0400
Received: from casper.infradead.org ([85.118.1.10]:46973 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759034Ab1FWLuR convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Jun 2011 07:50:17 -0400
Subject: Re: [patch 12/16] sched: prevent interactions with throttled
 entities
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: Paul Turner <pjt@google.com>
Cc: linux-kernel@vger.kernel.org, Bharata B Rao <bharata@linux.vnet.ibm.com>,
        Dhaval Giani <dhaval.giani@gmail.com>,
        Balbir Singh <balbir@linux.vnet.ibm.com>,
        Vaidyanathan Srinivasan <svaidy@linux.vnet.ibm.com>,
        Srivatsa Vaddagiri <vatsa@in.ibm.com>,
        Kamalesh Babulal <kamalesh@linux.vnet.ibm.com>,
        Hidetoshi Seto <seto.hidetoshi@jp.fujitsu.com>,
        Ingo Molnar <mingo@elte.hu>, Pavel Emelyanov <xemul@openvz.org>
In-Reply-To: <20110621071700.879990875@google.com>
References: <20110621071649.862846205@google.com>
	 <20110621071700.879990875@google.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
Date: Thu, 23 Jun 2011 13:49:19 +0200
Message-ID: <1308829759.1022.109.camel@twins>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2011-06-21 at 00:17 -0700, Paul Turner wrote:
> @@ -2635,8 +2704,10 @@ static int update_shares_cpu(struct task
>  
>         raw_spin_lock_irqsave(&rq->lock, flags);
>  
> -       update_rq_clock(rq);
> -       update_cfs_load(cfs_rq, 1);
> +       if (!throttled_hierarchy(cfs_rq)) {
> +               update_rq_clock(rq);
> +               update_cfs_load(cfs_rq, 1);
> +       }
>  
>         /* 

OK, so we can't contribute to load since we're throttled, but
tg->load_weight might have changed meanwhile?

Also, update_cfs_shares()->reweight_entity() can dequeue/enqueue the
entity, doesn't that require an up-to-date rq->clock?


