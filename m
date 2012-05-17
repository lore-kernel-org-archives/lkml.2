Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761491Ab2EQJ5u (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 May 2012 05:57:50 -0400
Received: from e28smtp05.in.ibm.com ([122.248.162.5]:35044 "EHLO
	e28smtp05.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756049Ab2EQJ5r (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 May 2012 05:57:47 -0400
Message-ID: <4FB4CB71.5040408@linux.vnet.ibm.com>
Date: Thu, 17 May 2012 15:27:05 +0530
From: "Srivatsa S. Bhat" <srivatsa.bhat@linux.vnet.ibm.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:12.0) Gecko/20120424 Thunderbird/12.0
MIME-Version: 1.0
To: Peter Zijlstra <a.p.zijlstra@chello.nl>
CC: David Rientjes <rientjes@google.com>,
        Nishanth Aravamudan <nacc@linux.vnet.ibm.com>, mingo@kernel.org,
        pjt@google.com, paul@paulmenage.org, akpm@linux-foundation.org,
        rjw@sisk.pl, nacc@us.ibm.com, paulmck@linux.vnet.ibm.com,
        tglx@linutronix.de, seto.hidetoshi@jp.fujitsu.com, tj@kernel.org,
        mschmidt@redhat.com, berrange@redhat.com, nikunj@linux.vnet.ibm.com,
        vatsa@linux.vnet.ibm.com, liuj97@gmail.com,
        linux-kernel@vger.kernel.org, linux-pm@vger.kernel.org
Subject: Re: [PATCH v3 5/5] cpusets, suspend: Save and restore cpusets during
 suspend/resume
References: <20120513231325.3566.37740.stgit@srivatsabhat> <20120513231710.3566.45349.stgit@srivatsabhat> <alpine.DEB.2.00.1205141735050.25235@chino.kir.corp.google.com> <20120515014042.GA9774@linux.vnet.ibm.com> <alpine.DEB.2.00.1205142055160.10906@chino.kir.corp.google.com> <20120515044539.GA25256@linux.vnet.ibm.com> <alpine.DEB.2.00.1205151106490.24304@chino.kir.corp.google.com> <1337112653.27694.110.camel@twins> <alpine.DEB.2.00.1205151346570.1656@chino.kir.corp.google.com> <1337116107.27694.114.camel@twins> <alpine.DEB.2.00.1205151414210.1656@chino.kir.corp.google.com> <4FB2CDAD.4020306@linux.vnet.ibm.com> <alpine.DEB.2.00.1205151444260.1656@chino.kir.corp.google.com> <4FB2D5CB.6090209@linux.vnet.ibm.com> <1337203449.4281.15.camel@twins>
In-Reply-To: <1337203449.4281.15.camel@twins>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
x-cbid: 12051709-8256-0000-0000-00000279FABE
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/17/2012 02:54 AM, Peter Zijlstra wrote:

> On Wed, 2012-05-16 at 03:46 +0530, Srivatsa S. Bhat wrote:
>>
>> However, the cpu_active_mask was introduced to handle situations where hotplug
>> transition is still in progress, and the scheduler needs to take appropriate
>> decisions even with some of its data-structures in an inconsistent/stale state.
>> But once the hotplug operation is completed, the scheduler doesn't need to
>> depend on cpu_active_mask.
> 
>> (And on those lines, making the scheduler work correctly even in such cases
>> is only a good-to-have as a robustness measure and not a "bugfix".) 
> 
> I think those 2(?) cases you found not covered by active mask could
> actually happen during a hotplug. So far they simply haven't.
> 


Yes, it could happen during a hotplug too. And its on my todo list to fix.

(But the point I was trying to make was that keeping the sched domains outdated
across multiple hotplug operations isn't really correct.)

Anyway, I think this is the state where the discussion stands atm:

1. We are not going to alter how cpusets are handled during regular cpu hotplug.
   We will do a suspend/resume-only fix for cpusets.
   David Rientjes said that this can probably be argued about endlessly, but he
   has no objections against doing it this way.

2. David Rientjes pointed out that explicit save and restore for suspend/resume
   needs a new per-cpuset cpu mask and he would prefer a design where we wouldn't
   need a new per-cpuset mask.
   Such a design is possible, by building a single sched domain (ignoring cpuset
   configurations, by using partition_sched_domains(1, NULL, NULL)) throughout
   suspend/resume cpu hotplug operations, and then restoring the original sched
   domain tree by looking up the cpusets, towards end of resume (last online
   operation).
   
   The frozen userspace won't notice any of this.

3. David had some comments/suggestions about some patches in this series.

So, I'll go with the design mentioned in 2, and address 3 and spin out a new
version.

Regards,
Srivatsa S. Bhat

