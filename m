Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756525Ab0EaPk4 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 31 May 2010 11:40:56 -0400
Received: from hera.kernel.org ([140.211.167.34]:40311 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751152Ab0EaPkz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 31 May 2010 11:40:55 -0400
Message-ID: <4C03D801.9090106@kernel.org>
Date: Mon, 31 May 2010 17:38:41 +0200
From: Tejun Heo <tj@kernel.org>
User-Agent: Mozilla/5.0 (X11; U; Linux i686 (x86_64); en-US; rv:1.9.1.9) Gecko/20100317 Thunderbird/3.0.4
MIME-Version: 1.0
To: Oleg Nesterov <oleg@redhat.com>
CC: "Michael S. Tsirkin" <mst@redhat.com>, Sridhar Samudrala <sri@us.ibm.com>,
       netdev <netdev@vger.kernel.org>, lkml <linux-kernel@vger.kernel.org>,
       "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Dmitri Vorobiev <dmitri.vorobiev@movial.com>,
       Jiri Kosina <jkosina@suse.cz>, Thomas Gleixner <tglx@linutronix.de>,
       Ingo Molnar <mingo@elte.hu>, Andi Kleen <ak@linux.intel.com>
Subject: Re: [PATCH 1/3] vhost: replace vhost_workqueue with per-vhost	kthread
References: <20100527163954.GA21710@redhat.com> <4BFEA434.6080405@kernel.org> <20100527173207.GA21880@redhat.com> <4BFEE216.2070807@kernel.org> <20100528150830.GB21880@redhat.com> <4BFFE742.2060205@kernel.org> <20100530112925.GB27611@redhat.com> <4C02C961.9050606@kernel.org> <20100531143945.GA6497@redhat.com> <4C03D0BE.1040601@kernel.org> <20100531153104.GA9452@redhat.com>
In-Reply-To: <20100531153104.GA9452@redhat.com>
X-Enigmail-Version: 1.0.1
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Mon, 31 May 2010 15:38:43 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

On 05/31/2010 05:31 PM, Oleg Nesterov wrote:
>> I might have slightly over engineered this part not knowing the
>> expected workload.  ->queue_seq/->done_seq pair is to guarantee that
>> flushers never get starved.
> 
> Ah, indeed.
> 
> Well, afaics we do not need 2 counters anyway, both vhost_poll_queue()
> and vhost_poller() could increment the single counter and the flusher
> can take bit 0 into account. But I agree 2 counters are much more clean.

Right, we can do that too.  Cool. :-)

>>>> +static int vhost_poller(void *data)
>>>> +{
>>>> +	struct vhost_dev *dev = data;
>>>> +	struct vhost_poll *poll;
>>>> +
>>>> +repeat:
>>>> +	set_current_state(TASK_INTERRUPTIBLE);	/* mb paired w/ kthread_stop */
>>>
>>> I don't understand the comment... why do we need this barrier?
>>
>> So that either kthread_stop()'s should_stop = 1 in kthread_stop() is
>> visible to kthread_should_stop() or task state is set to RUNNING.
> 
> Of course, you are right. I am really surprized I asked this question ;)

This part is always a bit tricky tho.  Maybe it would be a good idea
to make kthread_stop() do periodic wakeups.  It's already injecting
one rather unexpected wake up into the mix anyway so there isn't much
point in avoiding multiple and it would make designing kthread loops
easier.  Or maybe what we need is something like kthread_idle() which
encapsulates the check and sleep part.

Thanks.

-- 
tejun
