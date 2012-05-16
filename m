Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S966139Ab2EPInI (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 May 2012 04:43:08 -0400
Received: from e28smtp04.in.ibm.com ([122.248.162.4]:50519 "EHLO
	e28smtp04.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759845Ab2EPIm6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 May 2012 04:42:58 -0400
Message-ID: <4FB36867.7030500@linux.vnet.ibm.com>
Date: Wed, 16 May 2012 14:12:15 +0530
From: "Srivatsa S. Bhat" <srivatsa.bhat@linux.vnet.ibm.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:12.0) Gecko/20120424 Thunderbird/12.0
MIME-Version: 1.0
To: David Rientjes <rientjes@google.com>
CC: Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Nishanth Aravamudan <nacc@linux.vnet.ibm.com>, mingo@kernel.org,
        pjt@google.com, paul@paulmenage.org, akpm@linux-foundation.org,
        rjw@sisk.pl, nacc@us.ibm.com, paulmck@linux.vnet.ibm.com,
        tglx@linutronix.de, seto.hidetoshi@jp.fujitsu.com, tj@kernel.org,
        mschmidt@redhat.com, berrange@redhat.com, nikunj@linux.vnet.ibm.com,
        vatsa@linux.vnet.ibm.com, liuj97@gmail.com,
        linux-kernel@vger.kernel.org, linux-pm@vger.kernel.org
Subject: Re: [PATCH v3 5/5] cpusets, suspend: Save and restore cpusets during
 suspend/resume
References: <20120513231325.3566.37740.stgit@srivatsabhat> <20120513231710.3566.45349.stgit@srivatsabhat> <alpine.DEB.2.00.1205141735050.25235@chino.kir.corp.google.com> <20120515014042.GA9774@linux.vnet.ibm.com> <alpine.DEB.2.00.1205142055160.10906@chino.kir.corp.google.com> <20120515044539.GA25256@linux.vnet.ibm.com> <alpine.DEB.2.00.1205151106490.24304@chino.kir.corp.google.com> <1337112653.27694.110.camel@twins> <alpine.DEB.2.00.1205151346570.1656@chino.kir.corp.google.com> <1337116107.27694.114.camel@twins> <alpine.DEB.2.00.1205151414210.1656@chino.kir.corp.google.com> <4FB2CDAD.4020306@linux.vnet.ibm.com> <alpine.DEB.2.00.1205151444260.1656@chino.kir.corp.google.com> <4FB2D5CB.6090209@linux.vnet.ibm.com> <alpine.DEB.2.00.1205151527220.25449@chino.kir.corp.google.com> <4FB36365.4000802@linux.vnet.ibm.com>
In-Reply-To: <4FB36365.4000802@linux.vnet.ibm.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
x-cbid: 12051608-5564-0000-0000-000002BD9164
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/16/2012 01:50 PM, Srivatsa S. Bhat wrote:

> On 05/16/2012 04:02 AM, David Rientjes wrote:
> 
>> On Wed, 16 May 2012, Srivatsa S. Bhat wrote:
>>
>>>>  I know root is special 
>>>> cased all over the cpuset code, but I think the real fix here is to figure 
>>>> out why it can't be left as a superset and then we end up doing nothing 
>>>> for s/r.
>>>>
>>>> I don't have a preference for cpu hotplug and whether cpuset.cpus = 1-3 
>>>> remains 1-3 when cpu 2 is offlined or not, I think it could be argued both 
>>>> ways, but I disagree with saving the cpumask, removing all suspended cpus, 
>>>> and then reinstating it for no reason.
>>>>
>>>
>>> I think there is a valid reason behind doing that.
>>>
>>> Cpusets translates to sched domains in scheduler terms. So whenever you update
>>> cpusets, the sched domains are updated. IOW, if you don't touch cpusets during
>>> hotplug (suspend/resume case), you allow them to have offline cpus, meaning,
>>> you allow sched domains to have offline cpus. Hence sched domains are rendered
>>> stale.
>>>
>>
>> It's not possible to update the sched domains for s/r to be a subset of 
>> cpuset.cpus?
> 
> 
> (Btw, the above statement reminds me of a different idea I had long back
> which I will write about in a separate mail.)
> 


You suggested keeping sched domains updated during s/r without altering cpuset.cpus.
That is a very good point!

Because, we will then be distinguishing between 2 things:
sched domains can be "stale" because of 2 distinct reasons, one of which is troublesome
but the other is harmless:

1. offline cpus are included in some sched domains, and some offline cpus have
   a non-NULL sched domain pointer. This is the problematic situation.

2. sched domains don't reflect the cpuset configurations set up in cpuset.cpus of
   different cpusets. This is not really harmful, because if this happens only during
   s/r, the userspace wouldn't really notice it, as long as we reinstate the
   cpuset<->sched domain dependency properly at the end of resume.

So you are suggesting implementing point #2, where we keep the sched domains updated
(partially, at least in a way that is not harmful), so that we avoid the problem in
#1.

I had written a patch for this long ago:
http://thread.gmane.org/gmane.linux.kernel/1250097/focus=1254715

The idea there was to create a single sched domain at the beginning of suspend,
temporarily ignoring cpuset configurations, and reinstating the proper sched domain
tree taking cpusets into consideration, at the end of resume. That way we need not
touch cpusets during s/r, we need not explicitly save/restore cpusets, and we still
manage to keep the scheduler sane and happy. And the frozen userspace cannot observe
the temporary mismatch between cpusets<->sched domains. So no problems there too.

IMHO, the only reason we didn't finalize on that patch earlier was because the version
in commit 8f2f748b06562 looked much simpler (and at that point, we had no clue that
the latter would lead to suspend hangs).

So, now, we can either go with the design in this v3 (explicit save/restore) or the
one in the link shown above (temporary cpuset<->sched domain mismatch during s/r).

Not sure what Peter has to say about the latter though... He might have reservations
about it, I don't know ;-)
 
Regards,
Srivatsa S. Bhat

