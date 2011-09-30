Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751120Ab1I3EFc (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Sep 2011 00:05:32 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:46165 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750754Ab1I3EFb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Sep 2011 00:05:31 -0400
X-Authority-Analysis: v=1.1 cv=XWD5/VRj2HUJOhsR8cgmvPBlhMACpZXxseY1Kn/ehQI= c=1 sm=0 a=YzuRFytPCtMA:10 a=5SG0PmZfjMsA:10 a=Q9fys5e9bTEA:10 a=17wjrS5wAhQaEczCPkpxpQ==:17 a=IjN6da1xbnEKbA7UFYoA:9 a=syVMcpvTYSZxFIfrLqgA:7 a=PUjeQqilurYA:10 a=17wjrS5wAhQaEczCPkpxpQ==:117
X-Cloudmark-Score: 0
X-Originating-IP: 74.67.83.30
Subject: Re: [PATCH] sched/kthread: Complain loudly when others violate our
 flags
From: Steven Rostedt <rostedt@goodmis.org>
To: Tejun Heo <htejun@gmail.com>
Cc: LKML <linux-kernel@vger.kernel.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Thomas Gleixner <tglx@linutronix.de>
Date: Fri, 30 Sep 2011 00:05:29 -0400
In-Reply-To: <20110930034815.GF10425@mtj.dyndns.org>
References: <1317158254.26514.55.camel@gandalf.stny.rr.com>
	 <20110930034815.GF10425@mtj.dyndns.org>
Content-Type: text/plain; charset="ISO-8859-15"
X-Mailer: Evolution 3.0.3- 
Content-Transfer-Encoding: 7bit
Message-ID: <1317355529.4588.45.camel@gandalf.stny.rr.com>
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2011-09-29 at 20:48 -0700, Tejun Heo wrote:
>  
> > WTF is the workqueue code setting the PF_THREAD_BOUND flag manually?
> > Talk about fragile coupling! You just made this flag meaningless. Don't
> > do that.
> 
> IIRC, this was because there was no way to set PF_THREAD_BOUND once a
> kthread starts to run and workers can stay active across CPU bring
> down/up cycle.  Per-cpu kthreads need PF_THREAD_BOUND to prevent cpu
> affinity manipulation by third party for correctness.

That third party also includes workqueue. It shouldn't mess with that
flag.


> 
> > Sorry but I just wasted two whole days because of this nonsense and I'm
> > not particularly happy about it.
> 
> Sorry that it wasted your time and made you unhappy but wouldn't
> grepping for its usage a logical thing if you wanted to add to what it
> meant?  PF_THREAD_BOUND meaning the task's affinity or cpuset can't be
> manipulated by third party seems like a valid interpretation.

But you set PF_THREAD_BOUND to tasks that ARE NOT BOUNDED! That's just
wrong. It's not about "don't touch this affinity" it's about, this
thread has been pinned to a CPU and will not change for the life of the
thread.

> 
> Simply removing it would allow breaking workqueue from userland by
> manipulating affinity.  How about testing PF_WQ_WORKER in
> set_cpus_allowed_ptr() (and maybe cpuset, I'm not sure)?

Do you realize that these threads migrate? If you didn't, it just proves
that you shouldn't touch it.

-- Steve


