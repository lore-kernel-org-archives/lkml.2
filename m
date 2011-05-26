Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758601Ab1EZXsf (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 May 2011 19:48:35 -0400
Received: from fgwmail6.fujitsu.co.jp ([192.51.44.36]:48491 "EHLO
	fgwmail6.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756405Ab1EZXse (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 May 2011 19:48:34 -0400
X-SecurityPolicyCheck-FJ: OK by FujitsuOutboundMailChecker v1.3.1
Date: Fri, 27 May 2011 08:41:39 +0900
From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
To: Tejun Heo <tj@kernel.org>
Cc: "linux-mm@kvack.org" <linux-mm@kvack.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "akpm@linux-foundation.org" <akpm@linux-foundation.org>,
        Ying Han <yinghan@google.com>,
        "nishimura@mxp.nes.nec.co.jp" <nishimura@mxp.nes.nec.co.jp>,
        "balbir@linux.vnet.ibm.com" <balbir@linux.vnet.ibm.com>
Subject: Re: [RFC][PATCH v3 7/10] workqueue: add WQ_IDLEPRI
Message-Id: <20110527084139.d334819f.kamezawa.hiroyu@jp.fujitsu.com>
In-Reply-To: <20110526114406.GG9715@htj.dyndns.org>
References: <20110526141047.dc828124.kamezawa.hiroyu@jp.fujitsu.com>
	<20110526143024.7f66e797.kamezawa.hiroyu@jp.fujitsu.com>
	<20110526093808.GE9715@htj.dyndns.org>
	<20110526193018.12b3ddea.kamezawa.hiroyu@jp.fujitsu.com>
	<20110526195019.8af6d882.kamezawa.hiroyu@jp.fujitsu.com>
	<20110526114406.GG9715@htj.dyndns.org>
Organization: FUJITSU Co. LTD.
X-Mailer: Sylpheed 3.1.0 (GTK+ 2.10.14; i686-pc-mingw32)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 26 May 2011 13:44:06 +0200
Tejun Heo <tj@kernel.org> wrote:

> Hello,
> 
> On Thu, May 26, 2011 at 07:50:19PM +0900, KAMEZAWA Hiroyuki wrote:
> > On Thu, 26 May 2011 19:30:18 +0900
> > KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com> wrote:
> > > In the next version, I'll try some like..
> > > ==
> > > 	process_one_work(...) {
> > > 		.....
> > > 		spin_unlock_irq(&gcwq->lock);
> > > 		.....
> > > 		if (cwq->wq->flags & WQ_IDLEPRI) {
> > > 			set_scheduler(...SCHED_IDLE...)
> > > 			cond_resched();
> > > 			scheduler_switched = true;
> > > 		}
> > > 		f(work) 
> > > 		if (scheduler_switched)
> > > 			set_scheduler(...SCHED_OTHER...)
> > > 		spin_lock_irq(&gcwq->lock);
> > > 	}
> > > ==
> > > Patch size will be much smaller. (Should I do this in memcg's code ??)
> > > 
> > 
> > BTW, my concern is that if f(work) is enough short,effect of SCHED_IDLE will never
> > be found because SCHED_OTHER -> SCHED_IDLE -> SCHED_OTHER switch is very fast.
> > Changed "weight" of CFQ never affects the next calculation of vruntime..of the
> > thread and the work will show the same behavior with SCHED_OTHER.
> > 
> > I'm sorry if I misunderstand CFQ and setscheduler().
> 
> Hmm... I'm not too familiar there either but,
> 
> * If prio is lowered (you're gonna lower it too, right?),
>   prio_changed_fair() is called which in turn does resched_task() as
>   necessary.
> 
> * More importantly, for short work items, it's likely to not matter at
>   all.  If you can determine beforehand that it's not gonna take very
>   long time, queueing on system_wq would be more efficient.
> 
> Thanks.
> 

Ok, Now, I use following style.

	(short work)->requeue->(short work)->requeue
I'll change this as
	(set SCHED_IDLE)->long work (until the end)->(set SCHED_OTHER)

Then, I'll see what I want.

Thanks.
-Kame




