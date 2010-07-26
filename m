Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754892Ab0GZP4w (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Jul 2010 11:56:52 -0400
Received: from mx1.redhat.com ([209.132.183.28]:49821 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754287Ab0GZP4u (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Jul 2010 11:56:50 -0400
Date: Mon, 26 Jul 2010 18:50:15 +0300
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
Message-ID: <20100726155014.GA26412@redhat.com>
References: <4C03D983.9010905@kernel.org>
 <20100531160020.GC3067@redhat.com>
 <4C04D41B.4050704@kernel.org>
 <4C06A580.9060300@kernel.org>
 <20100722155840.GA1743@redhat.com>
 <4C48B664.9000109@kernel.org>
 <20100724191447.GA4972@redhat.com>
 <4C4BEAA2.6040301@kernel.org>
 <20100726152510.GA26223@redhat.com>
 <4C4DAB14.5050809@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4C4DAB14.5050809@kernel.org>
User-Agent: Mutt/1.5.20 (2009-12-10)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jul 26, 2010 at 05:34:44PM +0200, Tejun Heo wrote:
> Hello,
> 
> On 07/26/2010 05:25 PM, Michael S. Tsirkin wrote:
> > BTW, kthread_worker would benefit from the optimization I implemented
> > here as well.
> 
> Hmmm... I'm not quite sure whether it's an optimization.  I thought
> the patch was due to feeling uncomfortable about using barriers?

Oh yes. But getting rid of barriers is what motivated me originally.

>  Is it an optimization?
> 
> Thanks.

Yes, sure. This removes atomic read and 2 barrier operations on data path.  And
it does not add any new synchronization: instead, we reuse the lock that we
take anyway.  The relevant part is:


+               if (work) {
+                       __set_current_state(TASK_RUNNING);
+                       work->fn(work);
+               } else
+                       schedule();

-       if (work) {
-               __set_current_state(TASK_RUNNING);
-               work->fn(work);
-               smp_wmb();      /* wmb worker-b0 paired with flush-b1 */
-               work->done_seq = work->queue_seq;
-               smp_mb();       /* mb worker-b1 paired with flush-b0 */
-               if (atomic_read(&work->flushing))
-                       wake_up_all(&work->done);
-       } else
-               schedule();
-
-       goto repeat;

Is there a git tree with kthread_worker applied?
I might do this just for fun ...


> -- 
> tejun
