Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752896Ab2HPDKL (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Aug 2012 23:10:11 -0400
Received: from mga11.intel.com ([192.55.52.93]:63506 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751369Ab2HPDKJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Aug 2012 23:10:09 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.77,776,1336374000"; 
   d="scan'208";a="209109214"
Message-ID: <502C6486.6020201@intel.com>
Date: Thu, 16 Aug 2012 11:09:58 +0800
From: Alex Shi <alex.shi@intel.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:9.0) Gecko/20111229 Thunderbird/9.0
MIME-Version: 1.0
To: Borislav Petkov <bp@alien8.de>, Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Suresh Siddha <suresh.b.siddha@intel.com>,
        Arjan van de Ven <arjan@linux.intel.com>, vincent.guittot@linaro.org,
        svaidy@linux.vnet.ibm.com, Ingo Molnar <mingo@kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>, Paul Turner <pjt@google.com>
Subject: Re: [discussion]sched: a rough proposal to enable power saving in
 scheduler
References: <5028F12C.7080405@intel.com> <1345028738.31459.82.camel@twins> <20120815131514.GC4409@x1.osrc.amd.com>
In-Reply-To: <20120815131514.GC4409@x1.osrc.amd.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/15/2012 09:15 PM, Borislav Petkov wrote:

> On Wed, Aug 15, 2012 at 01:05:38PM +0200, Peter Zijlstra wrote:
>> On Mon, 2012-08-13 at 20:21 +0800, Alex Shi wrote:
>>> Since there is no power saving consideration in scheduler CFS, I has a
>>> very rough idea for enabling a new power saving schema in CFS.
>>
>> Adding Thomas, he always delights poking holes in power schemes.
>>
>>> It bases on the following assumption:
>>> 1, If there are many task crowd in system, just let few domain cpus
>>> running and let other cpus idle can not save power. Let all cpu take the
>>> load, finish tasks early, and then get into idle. will save more power
>>> and have better user experience.
>>
>> I'm not sure this is a valid assumption. I've had it explained to me by
>> various people that race-to-idle isn't always the best thing. It has to
>> do with the cost of switching power states and the duration of execution
>> and other such things.
> 
> I think what he means here is that we might want to let all cores on
> the node (i.e., domain) finish and then power down the whole node which
> should bring much more power savings than letting a subset of the cores
> idle. Alex?


Yes, that is my assumption. If my memory service me well. The idea get
from Suresh when introducing the old power saving schema.

> 
> [ … ]
> 
>> So I'd leave the currently implemented scheme as performance, and I
>> don't think the above describes the current state.
>>
>>> 			} else if (schedule policy == power)
>>> 				move tasks from busiest group to
>>> 				idlest group until busiest is just full
>>> 				of capacity.
>>> 				//the busiest group can balance
>>> 				//internally after next time LB,
>>
>> There's another thing we need to do, and that is collect tasks in a
>> minimal amount of power domains.
> 
> Yep.
> 
> Btw, what heuristic would tell here when a domain overflows and another
> needs to get woken? Combined load of the whole domain?
> 
> And if I absolutely positively don't want a node to wake up, do I
> hotplug its cores off or are we going to have a way to tell the
> scheduler to overcommit the non-idle domains and spread the tasks only
> among them.


You are right. here using the least load non-idle group is better than
idlest.

> 
> I'm thinking of short bursts here where it would be probably beneficial
> to let the tasks rather wait runnable for a while then wake up the next
> node and waste power...


True. Maybe that is Peter mentioned '2*capacity' reason?

> 
> Thanks.
> 


