Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933082Ab2EOVmz (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 May 2012 17:42:55 -0400
Received: from e23smtp09.au.ibm.com ([202.81.31.142]:56515 "EHLO
	e23smtp09.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932895Ab2EOVmw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 May 2012 17:42:52 -0400
Message-ID: <4FB2CDAD.4020306@linux.vnet.ibm.com>
Date: Wed, 16 May 2012 03:12:05 +0530
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
References: <20120513231325.3566.37740.stgit@srivatsabhat> <20120513231710.3566.45349.stgit@srivatsabhat> <alpine.DEB.2.00.1205141735050.25235@chino.kir.corp.google.com> <20120515014042.GA9774@linux.vnet.ibm.com> <alpine.DEB.2.00.1205142055160.10906@chino.kir.corp.google.com> <20120515044539.GA25256@linux.vnet.ibm.com> <alpine.DEB.2.00.1205151106490.24304@chino.kir.corp.google.com> <1337112653.27694.110.camel@twins> <alpine.DEB.2.00.1205151346570.1656@chino.kir.corp.google.com> <1337116107.27694.114.camel@twins> <alpine.DEB.2.00.1205151414210.1656@chino.kir.corp.google.com>
In-Reply-To: <alpine.DEB.2.00.1205151414210.1656@chino.kir.corp.google.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
x-cbid: 12051512-3568-0000-0000-000001C5DF6D
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/16/2012 02:54 AM, David Rientjes wrote:

> On Tue, 15 May 2012, Peter Zijlstra wrote:
> 
>>> Why can't we leave cpuset.cpus unaltered for all cpusets during suspend?  
>>
>> We can, that's what Srivatsa is going to make. The only thing I object
>> to is the !suspend hotplug case.
>>
> 
> Srivatsa is going to do that in another patchset in addition to this one?


Nope. This v3 itself is the full implementation.

> We shouldn't need to store any old cpumask at all, just allow cpuset.cpus 
> to be a superset of online cpus during s/r and don't touch cpusets at all 
> since the cpus, as you said, are guaranteed to come back.
> 


Oh, I am really sorry to say this, but this method has got 'history' ;-)
(Argh, I really should have put pointers to v1 and v2 in patch 0/5...)

What you are suggesting was precisely the v1 of this patchset, which went
upstream as commit 8f2f748b06562 (CPU hotplug, cpusets, suspend: Don't touch
cpusets during suspend/resume).

It got reverted due to a nasty suspend hang in some corner case, where the
sched domains not being up-to-date got the scheduler confused.
Here is the thread with that discussion:
http://thread.gmane.org/gmane.linux.kernel/1262802/focus=1286289

As Peter suggested, I'll try to fix the issues at the 2 places that I found
where the scheduler gets confused despite the cpu_active mask being up-to-date.

But, I really want to avoid that scheduler fix and this cpuset fix from
being tied together, for the fear that until we root-cause and fix all
scheduler bugs related to cpu_active mask, we can never get cpusets fixed
once and for all for suspend/resume. So, this patchset does an explicit
save and restore to be sure, and so that we don't depend on some other/unknown
factors to make this work reliably.

Regards,
Srivatsa S. Bhat

