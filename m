Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756704Ab0EaPpp (ORCPT <rfc822;w@1wt.eu>);
	Mon, 31 May 2010 11:45:45 -0400
Received: from hera.kernel.org ([140.211.167.34]:40463 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756454Ab0EaPpn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 31 May 2010 11:45:43 -0400
Message-ID: <4C03D983.9010905@kernel.org>
Date: Mon, 31 May 2010 17:45:07 +0200
From: Tejun Heo <tj@kernel.org>
User-Agent: Mozilla/5.0 (X11; U; Linux i686 (x86_64); en-US; rv:1.9.1.9) Gecko/20100317 Thunderbird/3.0.4
MIME-Version: 1.0
To: "Michael S. Tsirkin" <mst@redhat.com>
CC: Oleg Nesterov <oleg@redhat.com>, Sridhar Samudrala <sri@us.ibm.com>,
       netdev <netdev@vger.kernel.org>, lkml <linux-kernel@vger.kernel.org>,
       "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Dmitri Vorobiev <dmitri.vorobiev@movial.com>,
       Jiri Kosina <jkosina@suse.cz>, Thomas Gleixner <tglx@linutronix.de>,
       Ingo Molnar <mingo@elte.hu>, Andi Kleen <ak@linux.intel.com>
Subject: Re: [PATCH 1/3] vhost: replace vhost_workqueue with per-vhost	kthread
References: <20100527131254.GB7974@redhat.com> <4BFE9ABA.6030907@kernel.org> <20100527163954.GA21710@redhat.com> <4BFEA434.6080405@kernel.org> <20100527173207.GA21880@redhat.com> <4BFEE216.2070807@kernel.org> <20100528150830.GB21880@redhat.com> <4BFFE742.2060205@kernel.org> <20100530112925.GB27611@redhat.com> <4C02C961.9050606@kernel.org> <20100531152221.GB2987@redhat.com>
In-Reply-To: <20100531152221.GB2987@redhat.com>
X-Enigmail-Version: 1.0.1
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Mon, 31 May 2010 15:45:09 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

On 05/31/2010 05:22 PM, Michael S. Tsirkin wrote:
> On Sun, May 30, 2010 at 10:24:01PM +0200, Tejun Heo wrote:
>> Replace vhost_workqueue with per-vhost kthread.  Other than callback
>> argument change from struct work_struct * to struct vhost_poll *,
>> there's no visible change to vhost_poll_*() interface.
> 
> I would prefer a substructure vhost_work, even just to make
> the code easier to review and compare to workqueue.c.

Yeap, sure.

>> The problem is that I have no idea how to test this.
> 
> It's a 3 step process:
...
> You should now be able to ping guest to host and back.
> Use something like netperf to stress the connection.
> Close qemu with kill -9 and unload module to test flushing code.

Thanks for the instruction.  I'll see if there's a way to do it
without building qemu myself on opensuse.  But please feel free to go
ahead and test it.  It might just work!  :-)

>> +	if (poll) {
>> +		__set_current_state(TASK_RUNNING);
>> +		poll->fn(poll);
>> +		smp_wmb();	/* paired with rmb in vhost_poll_flush() */
>> +		poll->done_seq = poll->queue_seq;
>> +		wake_up_all(&poll->done);
> 

> This seems to add wakeups on data path, which uses spinlocks etc.
> OTOH workqueue.c adds a special barrier entry which only does a
> wakeup when needed.  Right?

Yeah, well, if it's a really hot path sure we can avoid wake_up_all()
in most cases.  Do you think that would be necessary?

>> -void vhost_cleanup(void)
>> -{
>> -	destroy_workqueue(vhost_workqueue);
> 
> I note that destroy_workqueue does a flush, kthread_stop
> doesn't. Right? Sure we don't need to check nothing is in one of
> the lists? Maybe add a BUG_ON?

There were a bunch of flushes before kthread_stop() and they seemed to
stop and flush everything.  Aren't they enough?  We can definitely add
BUG_ON() after kthread_should_stop() check succeeds either way tho.

Thanks.

-- 
tejun
