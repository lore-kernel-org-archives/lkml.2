Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751769Ab0G0TZT (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Jul 2010 15:25:19 -0400
Received: from mx1.redhat.com ([209.132.183.28]:56352 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750996Ab0G0TZQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Jul 2010 15:25:16 -0400
Date: Tue, 27 Jul 2010 22:19:11 +0300
From: "Michael S. Tsirkin" <mst@redhat.com>
To: Tejun Heo <tj@kernel.org>
Cc: Oleg Nesterov <oleg@redhat.com>, Sridhar Samudrala <sri@us.ibm.com>,
        netdev <netdev@vger.kernel.org>, lkml <linux-kernel@vger.kernel.org>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Dmitri Vorobiev <dmitri.vorobiev@movial.com>,
        Jiri Kosina <jkosina@suse.cz>, Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@elte.hu>, Andi Kleen <ak@linux.intel.com>
Subject: Re: [PATCH UPDATED 1/3] vhost: replace vhost_workqueue with
 per-vhost kthread
Message-ID: <20100727191911.GA16350@redhat.com>
References: <20100724191447.GA4972@redhat.com>
 <4C4BEAA2.6040301@kernel.org>
 <20100726152510.GA26223@redhat.com>
 <4C4DAB14.5050809@kernel.org>
 <20100726155014.GA26412@redhat.com>
 <4C4DB247.9060709@kernel.org>
 <4C4DB466.6000409@kernel.org>
 <20100726165114.GA27353@redhat.com>
 <4C4DDE7E.8030406@kernel.org>
 <4C4DE2AE.40302@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4C4DE2AE.40302@kernel.org>
User-Agent: Mutt/1.5.20 (2009-12-10)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jul 26, 2010 at 09:31:58PM +0200, Tejun Heo wrote:
> Hello,
> 
> On 07/26/2010 09:14 PM, Tejun Heo wrote:
> > On 07/26/2010 06:51 PM, Michael S. Tsirkin wrote:
> >> I noticed that with vhost, flush_work was getting the worker
> >> pointer as well. Can we live with this API change?
> > 
> > Yeah, the flushing mechanism wouldn't work reliably if the work is
> > queued to a different worker without flushing, so yeah passing in
> > @worker might actually be better.
> 
> Thinking a bit more about it, it kind of sucks that queueing to
> another worker from worker->func() breaks flush.  Maybe the right
> thing to do there is using atomic_t for done_seq?

I don't believe it will help: we might have:

worker1 runs work
work requeues itself queued index = 1
worker1 reads queued index = 1
worker2 runs work
work requeues itself queued index = 2
worker2 runs work
worker2 reads queued index = 2
worker2 writes done index = 2
worker1 writes done index = 1

As you see, done index got moved back.



>  It pays a bit more
> overhead but maybe that's justifiable to keep the API saner?  It would
> be great if it can be fixed somehow even if it means that the work has
> to be separately flushed for each worker it has been on before being
> destroyed.
> 
> Or, if flushing has to be associated with a specific worker anyway,
> maybe it would be better to move the sequence counter to
> kthread_worker and do it similarly with the original workqueue so that
> work can be destroyed once execution starts?  Then, it can at least
> remain semantically identical to the original workqueue.
> 
> Thanks.
> 
> -- 
> tejun
