Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759770Ab2EDV3e (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 May 2012 17:29:34 -0400
Received: from e8.ny.us.ibm.com ([32.97.182.138]:60288 "EHLO e8.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759669Ab2EDV3b (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 May 2012 17:29:31 -0400
Date: Fri, 4 May 2012 14:27:58 -0700
From: Nishanth Aravamudan <nacc@linux.vnet.ibm.com>
To: Peter Zijlstra <peterz@infradead.org>
Cc: "Srivatsa S. Bhat" <srivatsa.bhat@linux.vnet.ibm.com>, mingo@kernel.org,
        pjt@google.com, paul@paulmenage.org, akpm@linux-foundation.org,
        rjw@sisk.pl, nacc@us.ibm.com, paulmck@linux.vnet.ibm.com,
        tglx@linutronix.de, seto.hidetoshi@jp.fujitsu.com, rob@landley.net,
        tj@kernel.org, mschmidt@redhat.com, berrange@redhat.com,
        nikunj@linux.vnet.ibm.com, vatsa@linux.vnet.ibm.com,
        linux-kernel@vger.kernel.org, linux-doc@vger.kernel.org,
        linux-pm@vger.kernel.org
Subject: Re: [PATCH v2 0/7] CPU hotplug, cpusets: Fix issues with cpusets
 handling upon CPU hotplug
Message-ID: <20120504212758.GC3054@linux.vnet.ibm.com>
References: <20120504191535.4603.83236.stgit@srivatsabhat>
 <1336159496.6509.51.camel@twins>
 <4FA434E9.6000305@linux.vnet.ibm.com>
 <1336162456.6509.63.camel@twins>
 <1336163281.6509.69.camel@twins>
 <20120504204908.GC18177@linux.vnet.ibm.com>
 <1336165294.6509.76.camel@twins>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1336165294.6509.76.camel@twins>
X-Operating-System: Linux 3.2.0-24-generic (x86_64)
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 12050421-9360-0000-0000-0000060AC77E
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04.05.2012 [23:01:34 +0200], Peter Zijlstra wrote:
> On Fri, 2012-05-04 at 13:49 -0700, Nishanth Aravamudan wrote:
> > I think it's ok for hotplug to be destructive. But I guess I'm not
> > entirely sure why cpusets can't retain user-inputted
> > configuration/policy information even while destroying things currently?
> > And re-instating that policy if possible in the future? 
> 
> Two issues here:
>  - if you retain it for cpuset but not others that's confusing (too);

That's a good point.

Related, possibly counter-example, and perhaps I'm wrong about it.  When
we hot-unplug a CPU, and a task's scheduler affinity (via
sched_setaffinity) refers to that CPU only, do we kill that task? Can
you sched_setaffinity a task to a CPU that is offline (alone or in a
group of possible CPUs)? Or is it allowed to run anywhere? Do we destroy
its affinity policy when that situation is run across? Or do we restore
the task to the CPU again when we re-plug it? I'm just curious about
what the kernel does here and you probably know off the top of your head
:) It feels like a similar situation.

>  - we never retain anything, if you unload a module you loose all state
> that was associated with it too. What makes this special?

Another good point. I would think if we were talking about unmounting
cpusetfs altogether then what you say would correspond. But I feel like
there is some distinction between module unloading (and remembering
information about the module in question, I assume you mean things like
module parameters) and cpu hotplug (and remembering information about
cpuset configuration, which isn't necessarily directly related).

I don't have good answers to either of your points off the top of my
head -- but even if we say that "hey, userspace, you're dumb, get over
it", it feels like there could be more that we could do here. It seems
wrong to make every cpuset user (presuming there are more than just
libvirt & SGI) scan regularly for empty cpusets (I'm operating under the
assumption that the person setting up the cpuset configuration may not
be the same person that does the CPU hotplug operation).

Thanks,
Nish

-- 
Nishanth Aravamudan <nacc@us.ibm.com>
IBM Linux Technology Center

