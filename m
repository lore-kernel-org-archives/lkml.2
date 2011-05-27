Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754805Ab1E0P2o (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 May 2011 11:28:44 -0400
Received: from service87.mimecast.com ([94.185.240.25]:57309 "HELO
	service87.mimecast.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1753931Ab1E0P2n convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 May 2011 11:28:43 -0400
Subject: Re: [BUG] "sched: Remove rq->lock from the first half of ttwu()"
 locks up on ARM
From: Marc Zyngier <Marc.Zyngier@arm.com>
To: Santosh Shilimkar <santosh.shilimkar@ti.com>
Cc: Peter Zijlstra <peterz@infradead.org>, Oleg Nesterov <oleg@redhat.com>,
        Frank Rowand <frank.rowand@am.sony.com>, linux-kernel@vger.kernel.org,
        Yong Zhang <yong.zhang0@gmail.com>, Ingo Molnar <mingo@elte.hu>,
        linux-arm-kernel@lists.infradead.org
In-Reply-To: <4DDFC1D6.4010303@ti.com>
References: <1306343335.21578.65.camel@twins>
	 <1306358128.21578.107.camel@twins>
	 <BANLkTi=XbTXQsu3jUEvQyCfBy6-aRnqSpw@mail.gmail.com>
	 <1306405979.1200.63.camel@twins>
	 <1306407759.27474.207.camel@e102391-lin.cambridge.arm.com>
	 <1306409575.1200.71.camel@twins> <1306412511.1200.90.camel@twins>
	 <20110526154508.GA13788@redhat.com> <1306425584.2497.81.camel@laptop>
	 <1306426148.2497.83.camel@laptop> <20110526170422.GA18413@redhat.com>
	 <1306430264.2497.88.camel@laptop> <1306430633.2497.91.camel@laptop>
	 <4DDFC1D6.4010303@ti.com>
Organization: ARM Ltd
Date: Fri, 27 May 2011 16:29:25 +0100
Message-ID: <1306510165.27474.272.camel@e102391-lin.cambridge.arm.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3
X-OriginalArrivalTime: 27 May 2011 15:28:51.0641 (UTC) FILETIME=[C829CA90:01CC1C82]
X-MC-Unique: 111052716283908601
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2011-05-27 at 20:53 +0530, Santosh Shilimkar wrote:
> Peter,
> 
> On 5/26/2011 10:53 PM, Peter Zijlstra wrote:
> > On Thu, 2011-05-26 at 19:17 +0200, Peter Zijlstra wrote:
> >> On Thu, 2011-05-26 at 19:04 +0200, Oleg Nesterov wrote:
> >>> On 05/26, Peter Zijlstra wrote:
> >>>>
> >>>> @@ -2636,7 +2636,8 @@ try_to_wake_up(struct task_struct *p, unsigned int state, int wake_flags)
> >>>>   		 * to spin on ->on_cpu if p is current, since that would
> >>>>   		 * deadlock.
> >>>>   		 */
> >>>> -		if (p == current) {
> >>>> +		if (cpu == smp_processor_id()) {
> >>>> +			p->sched_contributes_to_load = 0;
> >>>>   			ttwu_queue(p, cpu);
> >>>
> >>> Btw. I do not pretend I really understand se->vruntime, but in this
> >>> case we are doing enqueue_task() without ->task_waking(), however we
> >>> pass ENQUEUE_WAKING. Is it correct?
> >>
> >> No its not, that's the thing that I got wrong the first time and caused
> >> these pauses.
> >
> > We'd end up with something like the below, which isn't too different
> > from what I've now got queued.
> >
> > It has the extra cpu == smp_processor_id() check, but I'm not sure this
> > whole case is worth the trouble. I could go stick some counters in to
> > verify how often all this happens I guess.
> >
> Are you planning send version of this patch for stable .39
> too ?

.39 is fine, as the ttwu() changes only appeared in mainline during the
current merge window.

Cheers,

	M.
-- 
Reality is an implementation detail.


