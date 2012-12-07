Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965020Ab2LGSjp (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Dec 2012 13:39:45 -0500
Received: from e23smtp07.au.ibm.com ([202.81.31.140]:33245 "EHLO
	e23smtp07.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S964944Ab2LGSjn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Dec 2012 13:39:43 -0500
Message-ID: <50C23789.9000705@linux.vnet.ibm.com>
Date: Sat, 08 Dec 2012 00:08:01 +0530
From: "Srivatsa S. Bhat" <srivatsa.bhat@linux.vnet.ibm.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:15.0) Gecko/20120828 Thunderbird/15.0
MIME-Version: 1.0
To: Tejun Heo <tj@kernel.org>
CC: tglx@linutronix.de, peterz@infradead.org, paulmck@linux.vnet.ibm.com,
        rusty@rustcorp.com.au, mingo@kernel.org, akpm@linux-foundation.org,
        namhyung@kernel.org, vincent.guittot@linaro.org, oleg@redhat.com,
        sbw@mit.edu, amit.kucheria@linaro.org, rostedt@goodmis.org,
        rjw@sisk.pl, wangyun@linux.vnet.ibm.com,
        xiaoguangrong@linux.vnet.ibm.com, nikunj@linux.vnet.ibm.com,
        linux-pm@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [RFC PATCH v3 1/9] CPU hotplug: Provide APIs to prevent CPU offline
 from atomic context
References: <20121207173702.27305.1486.stgit@srivatsabhat.in.ibm.com> <20121207173759.27305.84316.stgit@srivatsabhat.in.ibm.com> <20121207175724.GA2821@htj.dyndns.org> <50C23441.7020309@linux.vnet.ibm.com> <20121207183141.GC2821@htj.dyndns.org>
In-Reply-To: <20121207183141.GC2821@htj.dyndns.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 12120718-0260-0000-0000-000002443608
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/08/2012 12:01 AM, Tejun Heo wrote:
> Hello, Srivatsa.
> 
> On Fri, Dec 07, 2012 at 11:54:01PM +0530, Srivatsa S. Bhat wrote:
>>> lg_lock doesn't do local nesting and I'm not sure how big a deal that
>>> is as I don't know how many should be converted.  But if nesting is an
>>> absolute necessity, it would be much better to implement generic
>>> rwlock variant (say, lg_rwlock) rather than implementing unusual
>>> cpuhotplug-specific percpu synchronization construct.
>>
>> To be honest, at a certain point in time while designing this, I did
>> realize that this was getting kinda overly complicated ;-) ... but I
>> wanted to see how this would actually work out when finished and get
>> some feedback on the same, hence I posted it out. But this also proves
>> that we _can_ actually compete with the flexibility of preempt_disable()
>> and still be safe with respect to locking, if we really want to ;-)
> 
> I got confused by comparison to preempt_disable() but you're right
> that percpu rwlock shouldn't be able to introduce locking dependency
> which doesn't exist with non-percpu rwlock.  ie. write locking should
> be atomic w.r.t. to all readers.

Yep!

>  At the simplest, this can be
> implemented by writer backing out all the way if try-locking any CPU
> fails and retrying the whole thing.  That should be correct but has
> the potential of starving the writer.
> 

Exactly! This is what I mentioned yesterday in the link below, and said
that its not good because of writer starvation ("too wasteful"):
https://lkml.org/lkml/2012/12/6/290

> What we need here is a generic percpu-rwlock.  I don't know which
> exact implementation strategy we should choose.  Maybe your switching
> to global rwlock is the right solution.  But, at any rate, I think it
> would be best to implement proper percpu-rwlock and then apply it to
> CPU hotplug.  It's actually gonna be pretty fitting as
> get_online_cpus() is being converted to percpu-rwsem.  IIUC, Oleg has
> been working on this for a while now.  Oleg, what do you think?
> 

Hmm, that sounds good.

Regards,
Srivatsa S. Bhat

