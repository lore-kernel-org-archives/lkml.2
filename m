Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753439Ab1ICRf0 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 3 Sep 2011 13:35:26 -0400
Received: from mail.openrapids.net ([64.15.138.104]:48090 "EHLO
	blackscsi.openrapids.net" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1753297Ab1ICRfZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 3 Sep 2011 13:35:25 -0400
Date: Sat, 3 Sep 2011 13:35:22 -0400
From: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
To: Huang Ying <ying.huang@intel.com>
Cc: Peter Zijlstra <peterz@infradead.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH -mm 1/2] irq_work, Use llist in irq_work
Message-ID: <20110903173522.GB10744@Krystal>
References: <1314681384-20881-1-git-send-email-ying.huang@intel.com> <1314681384-20881-2-git-send-email-ying.huang@intel.com> <1314785405.23993.21.camel@twins> <4E5EE409.3060102@intel.com> <4E5EFA08.30205@intel.com> <1314863927.7945.11.camel@twins> <4E5F48D1.801@intel.com> <1314871035.7945.14.camel@twins> <4E602DF2.809@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4E602DF2.809@intel.com>
X-Editor: vi
X-Info: http://www.efficios.com
X-Operating-System: Linux/2.6.26-2-686 (i686)
X-Uptime: 12:33:37 up 283 days, 21:36,  1 user,  load average: 0.08, 0.04,
	0.01
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Huang Ying (ying.huang@intel.com) wrote:
> On 09/01/2011 05:57 PM, Peter Zijlstra wrote:
> > On Thu, 2011-09-01 at 16:56 +0800, Huang Ying wrote:
> >> Something as follow with llist_empty() seems not work.
> >>
> >>   empty = llist_empty(irq_work_list);
> >>   llist_add(&work->llnode, irq_work_list);
> >>   if (empty)
> >>           arch_irq_work_raise();
> >>
> >> Because irq_work IRQ handler or timer IRQ handler may be executed just
> >> before "llist_add(&work->llnode, irq_work_list)", so that, although
> >> "empty == false", arch_irq_work_raise() still should be executed.
> > 
> > Right, I was thinking:
> > 
> > 	llist_add(&work->llist, irq_work_list);
> > 	if (llist_empty(&work->llist))
> > 		arch_irq_work_raise();
> > 
> > And then ran into the difference between llist_node and llist_head. Now
> > we could sort that by introducing llist_next() and write it like:
> > 
> > 	if (!llist_next(&work->list))
> > 		arch_irq_work_raise();
> > 
> 
> This reveals some implementation details of llist.  But it will reveal
> some implementation details to make llist_add() return whether list is
> empty before adding as Mathieu pointed out.  So I think something like
> this or just to check work->list->next should be acceptable.

No. These solutions all appear to have some relatively high level of
ugliness and expose too much of the structure internals.

I'll submit a patch to change the API from llist to llstack shortly for
comments.

Thanks,

Mathieu

-- 
Mathieu Desnoyers
Operating System Efficiency R&D Consultant
EfficiOS Inc.
http://www.efficios.com
