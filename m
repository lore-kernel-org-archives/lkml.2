Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757393Ab1EZLoO (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 May 2011 07:44:14 -0400
Received: from mail-bw0-f46.google.com ([209.85.214.46]:33367 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754909Ab1EZLoM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 May 2011 07:44:12 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=LVjeZ0z8ZEn/+eU+DtcgQefjCAKb0ZnfA+UZE5wrSpa+/PlECJuj2I27fmsQurJVoi
         /0bww8zRI4LCIBfEPNUD+fRdmK+8iZHVeGx6lPgJVEkZRm4cuisHY2drxD73v1KnzjJ5
         6P9eJt+3Kc/kUOsfIAwYH0E66hpQts2PwA42g=
Date: Thu, 26 May 2011 13:44:06 +0200
From: Tejun Heo <tj@kernel.org>
To: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Cc: "linux-mm@kvack.org" <linux-mm@kvack.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "akpm@linux-foundation.org" <akpm@linux-foundation.org>,
        Ying Han <yinghan@google.com>,
        "nishimura@mxp.nes.nec.co.jp" <nishimura@mxp.nes.nec.co.jp>,
        "balbir@linux.vnet.ibm.com" <balbir@linux.vnet.ibm.com>
Subject: Re: [RFC][PATCH v3 7/10] workqueue: add WQ_IDLEPRI
Message-ID: <20110526114406.GG9715@htj.dyndns.org>
References: <20110526141047.dc828124.kamezawa.hiroyu@jp.fujitsu.com>
 <20110526143024.7f66e797.kamezawa.hiroyu@jp.fujitsu.com>
 <20110526093808.GE9715@htj.dyndns.org>
 <20110526193018.12b3ddea.kamezawa.hiroyu@jp.fujitsu.com>
 <20110526195019.8af6d882.kamezawa.hiroyu@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110526195019.8af6d882.kamezawa.hiroyu@jp.fujitsu.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

On Thu, May 26, 2011 at 07:50:19PM +0900, KAMEZAWA Hiroyuki wrote:
> On Thu, 26 May 2011 19:30:18 +0900
> KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com> wrote:
> > In the next version, I'll try some like..
> > ==
> > 	process_one_work(...) {
> > 		.....
> > 		spin_unlock_irq(&gcwq->lock);
> > 		.....
> > 		if (cwq->wq->flags & WQ_IDLEPRI) {
> > 			set_scheduler(...SCHED_IDLE...)
> > 			cond_resched();
> > 			scheduler_switched = true;
> > 		}
> > 		f(work) 
> > 		if (scheduler_switched)
> > 			set_scheduler(...SCHED_OTHER...)
> > 		spin_lock_irq(&gcwq->lock);
> > 	}
> > ==
> > Patch size will be much smaller. (Should I do this in memcg's code ??)
> > 
> 
> BTW, my concern is that if f(work) is enough short,effect of SCHED_IDLE will never
> be found because SCHED_OTHER -> SCHED_IDLE -> SCHED_OTHER switch is very fast.
> Changed "weight" of CFQ never affects the next calculation of vruntime..of the
> thread and the work will show the same behavior with SCHED_OTHER.
> 
> I'm sorry if I misunderstand CFQ and setscheduler().

Hmm... I'm not too familiar there either but,

* If prio is lowered (you're gonna lower it too, right?),
  prio_changed_fair() is called which in turn does resched_task() as
  necessary.

* More importantly, for short work items, it's likely to not matter at
  all.  If you can determine beforehand that it's not gonna take very
  long time, queueing on system_wq would be more efficient.

Thanks.

-- 
tejun
