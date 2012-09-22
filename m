Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753487Ab2IVFhJ (ORCPT <rfc822;w@1wt.eu>);
	Sat, 22 Sep 2012 01:37:09 -0400
Received: from wdmail01.wdc.com ([129.253.55.43]:26940 "EHLO wdmail01.wdc.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750884Ab2IVFhH convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 22 Sep 2012 01:37:07 -0400
X-Greylist: delayed 567 seconds by postgrey-1.27 at vger.kernel.org; Sat, 22 Sep 2012 01:37:07 EDT
X-IronPort-AV: E=Sophos;i="4.80,465,1344236400"; 
   d="scan'208";a="6630962"
From: Daniel Taylor <Daniel.Taylor@wdc.com>
To: "'anish singh'" <anish198519851985@gmail.com>,
        Deepawali Verma <dverma249@gmail.com>
CC: Tejun Heo <tj@kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: RE: Work queue questions
Thread-Topic: Work queue questions
Thread-Index: AQHNmB+2EvxSNhADc0u6rFkSYElUlpeViBoAgAALT4CAAAFfgIAADi+AgAAAXgCAAAI0gIAAk/2A//+ZcKA=
Date: Sat, 22 Sep 2012 05:27:38 +0000
Message-ID: <5A9BC72FD5CEC94EA024CED8E31D701A4C572F72@wdscexmb03.sc.wdc.com>
References: <CAHCeSFpar4ykz5cr9dLrO5J4r3ZXkwbNkU1O3q=QZs9rFEyB6w@mail.gmail.com>
	<20120921174952.GF7264@google.com>
	<CAHCeSFo0QtOc4GYfMqJy4R60G_Yy+1psidUbZ2=ym8XWraGvcw@mail.gmail.com>
	<20120921183515.GI7264@google.com>
	<CAHCeSFpa28d-7ruMKSw6z2EYKYN-5udVouUJOi4cnj4dPad-TA@mail.gmail.com>
	<20120921192720.GJ7264@google.com>
	<CAHCeSFrN6VketFq3vmA1S0O1GTOGNW41ZirZs5dGkiTXLbizkA@mail.gmail.com>
 <CAK7N6vpuJnnAp2xCUG_20aSVzT9aXhZRFrkVtfO3qOKE7gZ0Eg@mail.gmail.com>
In-Reply-To: <CAK7N6vpuJnnAp2xCUG_20aSVzT9aXhZRFrkVtfO3qOKE7gZ0Eg@mail.gmail.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.4.44.9]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

 

> -----Original Message-----
> From: linux-kernel-owner@vger.kernel.org 
> [mailto:linux-kernel-owner@vger.kernel.org] On Behalf Of anish singh
> Sent: Friday, September 21, 2012 9:25 PM
> To: Deepawali Verma
> Cc: Tejun Heo; linux-kernel@vger.kernel.org
> Subject: Re: Work queue questions
> 
> On Sat, Sep 22, 2012 at 1:05 AM, Deepawali Verma 
> <dverma249@gmail.com> wrote:
> > Hi Tajun,
> >
> > These three tasks are writing the three chunks of data in 
> parallel. I
> > am not getting improvement here otherwise what is difference between
> > writing these chunks one by one in single thread instead of 
> trying to
> > write the data by scheduling the work on three different workqueues
> > means 3 worker threads?
> You should have carefully read "If none of them blocks, there
> isn't much point in throwing more threads at them.  What are those
> thread doing?" what Tejun said.
> 
> I think what he means is that concurrency is the concept of 
> keeping the
> system busy.
> If you see the below logs:
> kworker/u:1-21    [000]   110.964895: task_event: 
> MYTASKJOB2381 XStarted
> kworker/u:1-21    [000]   110.964909: task_event: 
> MYTASKJOB2381 Xstopped
> Here your first worker thread blocked.
> 
> So the system will try to get other workqueue started which is:
> kworker/u:1-21    [000]   110.965137: task_event: 
> MYTASKJOB2382 XStarted
> kworker/u:1-21    [000]   110.965154: task_event: 
> MYTASKJOB2382 Xstopped
> Here again your second worker thread blocked.
> 
> So on so forth.
> Anyway how can you write chunks of data in parallel when 
> already some worker
> thread is writing i.e. the system is busy.
> Analogy: Suppose you are ambidextrous and you are eating.Can 
> you eat with
> both of your hands at a time?So worker thread are like your 
> hands and keeping
> you fed all the time is the concept of concurrency.
> 
> I am not an expert on this but from Tejun's reply I could 
> make out this.
> Please correct me If I have wrongly understood the concept 
> based on this mail

I don't know how many cores are in the CPU Deepawali's using, but if I have four,
for example, I could do something simplistic like copy pages A-G with one, pages
H-O with another, and pages Q-Z with a third.  There are memory and cache bottlenecks
(like the mouth, in your example), but all three copies could be running concurrently.

Copying, of course, is a silly, trivial example, and I hope there's a better reason
than that for the concurrency, but, if, for example, your needed to byte-swap, XOR,
or checksum, as core functionality of an embedded system, and the processing units were
available to do these things in parallel, then interleaving those operations with memory
accesses could provide higher throughput.

I think what he's asking is why there's no apparent concurrency, presuming that NONE
of his threads has a real reason to block.  With examining his code, I cannot tell,
but it looks like, from the messages, that the kernel did not attempt concurrency.
Perhaps he needs to pass additional state to the scheduler?


> chain.
> >
> > Regards,
> > Deepa
> >
> > On Fri, Sep 21, 2012 at 8:27 PM, Tejun Heo <tj@kernel.org> wrote:
> >> On Fri, Sep 21, 2012 at 08:26:01PM +0100, Deepawali Verma wrote:
> >>>      kworker/u:1-21    [000]   110.964895: task_event: 
> MYTASKJOB2381 XStarted
> >>>      kworker/u:1-21    [000]   110.964909: task_event: 
> MYTASKJOB2381 Xstopped
> >>>      kworker/u:1-21    [000]   110.965137: task_event: 
> MYTASKJOB2382 XStarted
> >>>      kworker/u:1-21    [000]   110.965154: task_event: 
> MYTASKJOB2382 Xstopped
> >>>      kworker/u:5-3724  [000]   110.965311: task_event: 
> MYTASKJOB2383 XStarted
> >>>      kworker/u:5-3724  [000]   110.965325: task_event: 
> MYTASKJOB2383 Xstopped
> >>>
> >>> I have this one big task to whom I divided into small sub 
> tasks. These
> >>> are numbered 2381, 2382 and 2383, what was I expecting 
> that task 2381,
> >>> 2382, 2383 run in parallel. I have put start and stop 
> markers here so
> >>> that I can see how this concurrency managed work queue is 
> distributing
> >>> the load.
> >>>
> >>> I found that task no 2381 is started first and exited 
> before starting
> >>> task 2382 and so on. What I expected that it should start 
> the three
> >>> sub tasks in parallel, not one by one.
> >>>
> >>> Where is concurrency here?
> >>
> >> If none of them blocks, there isn't much point in throwing more
> >> threads at them.  What are those thread doing?
> >>
> >> Thanks.
> >>
> >> --
> >> tejun
> > --
> > To unsubscribe from this list: send the line "unsubscribe 
> linux-kernel" in
> > the body of a message to majordomo@vger.kernel.org
> > More majordomo info at  http://vger.kernel.org/majordomo-info.html
> > Please read the FAQ at  http://www.tux.org/lkml/
> --
> To unsubscribe from this list: send the line "unsubscribe 
> linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
> 