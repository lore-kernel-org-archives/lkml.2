Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757079Ab1IAJ5Y (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Sep 2011 05:57:24 -0400
Received: from merlin.infradead.org ([205.233.59.134]:37337 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756050Ab1IAJ5W convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Sep 2011 05:57:22 -0400
Subject: Re: [PATCH -mm 1/2] irq_work, Use llist in irq_work
From: Peter Zijlstra <peterz@infradead.org>
To: Huang Ying <ying.huang@intel.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
Date: Thu, 01 Sep 2011 11:57:15 +0200
In-Reply-To: <4E5F48D1.801@intel.com>
References: <1314681384-20881-1-git-send-email-ying.huang@intel.com>
			 <1314681384-20881-2-git-send-email-ying.huang@intel.com>
		 <1314785405.23993.21.camel@twins> <4E5EE409.3060102@intel.com>
		 <4E5EFA08.30205@intel.com> <1314863927.7945.11.camel@twins>
	 <4E5F48D1.801@intel.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
X-Mailer: Evolution 3.0.2- 
Message-ID: <1314871035.7945.14.camel@twins>
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2011-09-01 at 16:56 +0800, Huang Ying wrote:
> Something as follow with llist_empty() seems not work.
> 
>   empty = llist_empty(irq_work_list);
>   llist_add(&work->llnode, irq_work_list);
>   if (empty)
>           arch_irq_work_raise();
> 
> Because irq_work IRQ handler or timer IRQ handler may be executed just
> before "llist_add(&work->llnode, irq_work_list)", so that, although
> "empty == false", arch_irq_work_raise() still should be executed.

Right, I was thinking:

	llist_add(&work->llist, irq_work_list);
	if (llist_empty(&work->llist))
		arch_irq_work_raise();

And then ran into the difference between llist_node and llist_head. Now
we could sort that by introducing llist_next() and write it like:

	if (!llist_next(&work->list))
		arch_irq_work_raise();


