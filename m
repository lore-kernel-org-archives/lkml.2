Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757215Ab2FYVS6 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Jun 2012 17:18:58 -0400
Received: from mx1.redhat.com ([209.132.183.28]:9633 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756095Ab2FYVS4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Jun 2012 17:18:56 -0400
Date: Mon, 25 Jun 2012 17:18:50 -0400
From: Vivek Goyal <vgoyal@redhat.com>
To: Josh Hunt <joshhunt00@gmail.com>
Cc: Jens Axboe <axboe@kernel.dk>, linux-kernel@vger.kernel.org, tj@kernel.org
Subject: Re: multi-second application stall in open()
Message-ID: <20120625211850.GC10916@redhat.com>
References: <CAKA=qzYmh8DD7J__WWDyX_2fFQbSx+M=k4ttqRTD3M8nao-WVg@mail.gmail.com>
 <20120622141211.GB18409@redhat.com>
 <CAKA=qzYYK5KUNsZ1C7Z7BEkqo-7uvn=HYr0N9KLPaLt9ut+MDQ@mail.gmail.com>
 <CAKA=qzY+u64vVZmbiH4zp_Fij2zejQBFUSNENKF=PZBT0G7xrQ@mail.gmail.com>
 <20120622204207.GA22063@redhat.com>
 <CAKA=qzbycm0cjLyiuKaKkD8sxDm5DvX9WVqSxN2QVT2WZOzU0Q@mail.gmail.com>
 <CAKA=qza_s6zr+wZzfFTVPSzgPQAov=K63jf-SJOTDcrnDELY5w@mail.gmail.com>
 <CAKA=qzYea71A5VQOQgrqzaZtVFadjhcghgH+Z9n4ivS7vUgW0g@mail.gmail.com>
 <20120625133047.GA9394@redhat.com>
 <CAKA=qzbXm7LaDziH=cms1W5X+cwNNRkG0LNFfWKEppr2oht6_w@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CAKA=qzbXm7LaDziH=cms1W5X+cwNNRkG0LNFfWKEppr2oht6_w@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jun 25, 2012 at 11:22:32AM -0500, Josh Hunt wrote:
> On Mon, Jun 25, 2012 at 8:30 AM, Vivek Goyal <vgoyal@redhat.com> wrote:
> > On Fri, Jun 22, 2012 at 04:34:07PM -0500, Josh Hunt wrote:
> >
> > [..]
> >> Shouldn't the queue stay on the RR list until it is empty?
> >
> > This does look odd. cfqq should stay on service tree as long as it has
> > requests.
> >
> > Can you attach the full log again. Also make sure that blktrace is not
> > dropping any trace events.
> >
> > In slice_expire() we check following.
> >
> >        if (cfq_cfqq_on_rr(cfqq) && RB_EMPTY_ROOT(&cfqq->sort_list))
> >                cfq_del_cfqq_rr(cfqd, cfqq);
> >
> > So for some reason RB_EMPTY_ROOT() is returning true. But we must have
> > added the request and it should not have been empty.
> >
> > cfq_insert_request()
> >  cfq_add_rq_rb()
> >    elv_rb_add()
> >
> > So may be little more tracing after request addition will help. Just check
> > that RB_EMPTY_ROOT() is not true after addition of request and also print
> > number of requests queued.
> >
> > In slice_expired() we can probably put a BUG_ON() which checks following.
> >
> > BUG_ON(RB_EMPTY_ROOT(&cfqq->sort_list) && (cfqq->queued[0] || cfqq->queued[1]));
> >
> > Thanks
> > Vivek
> 
> Vivek
> 
> First off thanks for all the time you've spent helping me on this :)
> 
> I'm attaching the log. I will add more instrumentation based on your
> mail and let you know the results.

I suspect that cfq5917 are actually two queues. One sync and other async.
In latest kernels, trace messages append "A" or "S" in queue name to
represent async/sync queue. Why do I think so.

- I see that cfq5917 has dispatched both "W" and "R" requests. "R" don't
  get queued in sync queues and vice a versa.

- Once cfq5917 has preempted cfq5917. A queue can't preempt itself. 

  8,0    1   296615  4847.030318652  5917  I   R 1572951 + 8 (    2793)
[syslogd]
  8,0    1        0  4847.030321446     0  m   N cfq5917 insert_request
  8,0    1        0  4847.030323122     0  m   N cfq5917 add_to_rr
  8,0    1        0  4847.030325636     0  m   N cfq5917 preempt
  8,0    1        0  4847.030327033     0  m   N cfq5917 slice expired t=1
  8,0    1        0  4847.030328710     0  m   N cfq5917 resid=39
  8,0    1        0  4847.030331783     0  m   N cfq5917 sl_used=1 disp=7
charge=1 iops=0 sect=96

Hence I think that it is just a chance that both sync and async queues
have got same cfqq->pid. If you just append anohter character to represent
sync and async property of queue, that can cofirm it.

Thanks
Vivek
