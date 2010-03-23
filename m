Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754619Ab0CWVvU (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Mar 2010 17:51:20 -0400
Received: from ms01.sssup.it ([193.205.80.99]:42422 "EHLO sssup.it"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1754462Ab0CWVvS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Mar 2010 17:51:18 -0400
Message-ID: <4BA937CE.9060002@sssup.it>
Date: Tue, 23 Mar 2010 22:51:10 +0100
From: Tommaso Cucinotta <tommaso.cucinotta@sssup.it>
User-Agent: Thunderbird 2.0.0.24 (X11/20100317)
MIME-Version: 1.0
To: Dhaval Giani <dhaval@retis.sssup.it>
CC: Peter Zijlstra <peterz@infradead.org>,
       Fabio Checconi <fchecconi@gmail.com>, Ingo Molnar <mingo@elte.hu>,
       Thomas Gleixner <tglx@linutronix.de>, Paul Turner <pjt@google.com>,
       Dario Faggioli <faggioli@gandalf.sssup.it>,
       Michael Trimarchi <michael@evidence.eu.com>,
       Tommaso Cucinotta <t.cucinotta@sssup.it>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 0/3] sched: use EDF to throttle RT task groups v2
References: <cover.1266931410.git.fabio@helm.retis> <1267273991.22519.744.camel@laptop> <20100303170110.GS2490@gandalf.sssup.it> <1269376207.5283.5.camel@laptop> <20100323205623.GA9138@gondor.retis>
In-Reply-To: <20100323205623.GA9138@gondor.retis>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Dhaval Giani wrote:
> But I can also see why one would not want a multi-valued interface, esp
> when the idea is just to change the runtimes. (though there is a
> complicated interaction between task_runtime and runtime which I am not
> sure how to avoid).
>
> IOW, this interface sucks :-). We really need something better and
> easier to use. (Sorry for no constructive input)
>   
Hi,

is it really so bad to think of a well-engineered API for real-time 
scheduling services of the OS, to be made available to applications by 
means of a library, and to be implemented by whatever means fits best in 
the current kernel/user-space interaction model ? For example, variants 
on the sched_setscheduler() syscall (remember the 
sched_setscheduler_ex() for SCHED_SPORADIC ?), a completely new set of 
syscalls, a cgroupfs based interaction, a set of binary files within the 
cgroupfs, a set of ioctl()s over cgroupfs entries (somebody must have 
told me this is not possible), or a special device in /dev, /sys, /proc, 
/wherever, etc.

For example, on OS-X there seems to be this THREAD_TIME_CONSTRAINT_POLICY

 http://developer.apple.com/mac/library/documentation/Darwin/Conceptual/KernelProgramming/scheduler/scheduler.html#//apple_ref/doc/uid/TP30000905-CH211-BABCHEEB

which is claimed to be used by multimedia and system interactive 
services, even if at the kernel level I don't know how it is implemented 
and what it actually provides.

Also, in the context of some research projects, a few APIs have come out 
in the last few years for Linux as well. Now, I don't want to say that 
we must have something as ugly as:

  int frsh_contract_set_resource_and_label
  (frsh_contract_t *contract,
   const frsh_resource_type_t resource_type,
   const frsh_resource_id_t resource_id,
   const char *contract_label);

and as complex and multi-faceted as the entire FRESCOR API

  http://www.frescor.org/
  
http://www.frescor.org/index.php?mact=Uploads,cntnt01,getfile,0&cntnt01showtemplate=false&cntnt01upload_id=75&cntnt01returnid=54

pretending to merge into a single framework management of real-time 
computing, networking, storage, or even memory allocation. However, at 
least that experience may help in identifying the requirements for a 
well-engineered approach to a real-time interface. I also know it cannot 
be something as naive and simple as the AQuoSA API

  
http://aquosa.sourceforge.net/aquosa-docs/aquosa-qosres/html/group__QRES__LIB.html

designed around a single-processor embedded (and academic) context.

I'm really scared that this cgroupfs-based kind of interfaces fit well 
only within requirements of "static partitioning" of the system by 
sysadmins, whilst general real-time, interactive and multimedia 
applications cannot easily benefit of the potentially available 
real-time guarantees (in our research we used to dynamically change the 
reserved resources (runtime) for the application every 40ms or so, 
others from the same group desire some kind of "elastic scheduling" 
where the reservation period is changed dynamically for control tasks at 
an even higher rate . . . I know that those ones may represent 
pathologically and polarized scenarios of no general interest as well).

Another example: we can quickly find out that we may need more than 
atomically set 2 parameters, just as an example one may just have:
- runtime
- period
- a set of flags governing the exact scheduling behavior, for example:
  - whether or not it may take more than the assigned runtime
  - if yes, by what means (SCHED_OTHER when runtime exhausted a'la 
AQuoSA, or low priority a'la Sporadic Server, or deadline post-ponement 
a'la Constant Bandwidth Server, or what ?)
  - any weight for governing a weighted fair partitioning of the excess 
bandwidth ?
  - on Mac OS-X, they seem to have a flag driving preemtability of the 
process
  - whether we want partitioned scheduling or global scheduling ?
  - whether we want to allocate on an individual CPU, on all available 
CPUs a'la Fabio's scheduler, or on a cpuset ?
- low priority ?
- signal to be delivered in case of budget overrun ?
- something mad about synchronization, such as blocking times ? (ok, now 
I'm starting to talk real-time-ish, I'll stop).

and, we may need more complex operations than simply reading/writing 
runtimes and periods, such as:
- attaching/detaching threads
- monitoring the available instantaneous budget
- setting-up hierarchical scheduling (ok, for such things the cgroups 
seems just perfect)

My 2 cents (apologies for the length),

    Tommaso

-- 
Tommaso Cucinotta, Computer Engineering PhD, Researcher
ReTiS Lab, Scuola Superiore Sant'Anna, Pisa, Italy
Tel +39 050 882 024, Fax +39 050 882 003
http://retis.sssup.it/people/tommaso

