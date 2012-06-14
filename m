Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756005Ab2FNNQJ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Jun 2012 09:16:09 -0400
Received: from mx1.redhat.com ([209.132.183.28]:2643 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755905Ab2FNNQG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Jun 2012 09:16:06 -0400
Message-ID: <4FD9E3FF.4050906@redhat.com>
Date: Thu, 14 Jun 2012 16:15:43 +0300
From: Avi Kivity <avi@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:13.0) Gecko/20120605 Thunderbird/13.0
MIME-Version: 1.0
To: Yanfei Zhang <zhangyanfei@cn.fujitsu.com>
CC: mtosatti@redhat.com, ebiederm@xmission.com, luto@mit.edu,
        Joerg Roedel <joerg.roedel@amd.com>, dzickus@redhat.com,
        paul.gortmaker@windriver.com, ludwig.nussel@suse.de,
        linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        kexec@lists.infradead.org, Greg KH <gregkh@linuxfoundation.org>,
        masanori.yoshida.tv@hitachi.com
Subject: Re: [PATCH v2 0/5] Export offsets of VMCS fields as note information
 for kdump
References: <4FB35C48.30708@cn.fujitsu.com> <4FB92D5A.3060507@redhat.com> <4FB9A92D.7050108@cn.fujitsu.com> <4FB9FE08.4050905@redhat.com> <4FBA05F6.8070804@cn.fujitsu.com> <4FBA0C8A.2050003@redhat.com> <4FBB0ACA.2040907@cn.fujitsu.com> <4FC30C40.80500@cn.fujitsu.com> <4FC37D94.3080404@redhat.com> <4FC47579.2040504@cn.fujitsu.com> <4FD58399.4050700@cn.fujitsu.com>
In-Reply-To: <4FD58399.4050700@cn.fujitsu.com>
Content-Type: text/plain; charset=GB2312
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/11/2012 08:35 AM, Yanfei Zhang wrote:
> Hello Avi,


Sorry about the delay...

> 
> 于 2012年05月29日 15:06, Yanfei Zhang 写道:
>> 于 2012年05月28日 21:28, Avi Kivity 写道:
>>> On 05/28/2012 08:25 AM, Yanfei Zhang wrote:
>>>>
>>>> Dou you have any comments about this patch set?
>>>
>>> I still have a hard time understanding why it is needed.  If the host
>>> crashes, there is no reason to look at guest state; the host should
>>> survive no matter what the guest does.
>>>
>>>
>> 
>> OK. Let me summarize it.
>> 
>> 1. Why is this patch needed? (Our requirement)
>>    
>> We once came to a buggy situation: a host scheduler bug caused guest machine's
>> vcpu stopped for a long time and then led to heartbeat stop (host is still running).
>>    
>> we want to have an efficient way to make the bug analysis when we come to the similar
>> situation where guest machine doesn't work well due to something of host machine's, 
>> 
>> Because we should debug both host machine's and guest machine's sides to look for
>> the reasons, so we want to get both host machine's crash dump and guest machine's
>> crash dump at the same time when the buggy situation remains.

I would argue that there are two separate bugs here: (1) a host bug
which caused the scheduling delay (2) putting a heartbeat service on a
virtualized guests with no real time guarantees.

But I understand your situation.

>> 
>> 2. What will we do?
>>    
>> If this bug was found on customer's environment, we have two ways to avoid
>> affecting other guest machines running on the same host. First, we could do bug
>> analysis on another environment to reproduce the buggy situation; Second, we
>> could migrate other guest machines to other hosts. 

You could also use tracing (there's the latency tracer and the scheduler
tracepoints) to debug this on a live system.

>> 
>> After the buggy situation is reproduced, we panic the host *manually*.
>> Then we could use userland tools to get guest machine's crash dump from host machine's
>> with the feature provided by this patch set. Finally we could analyse them separately
>> to find which side causes the problem.
>> 
> 
> Could you please tell me your attitude towards this patch? 

I still dislike it conceptually.  But let me do a technical review of
the latest version.

> And here is a new case from the LinuxCon Japan:
> 
> Developers from Hitach are now developing a new livedump mechanism for the
> same reason as ours. They have come to the situation *many times* that guest
> machines crashed due to host's failures, in particular, under development.

This has happened to me as well, possible even more times :).  I don't
use crash dumps for debugging but different people may use different
techniques.

> So they develop this mechanism to get crash dump while retaining the buggy
> situation between host and guest machine. The difference between theirs and
> ours is whether or not to use the feature on _customer's running machine_.


-- 
error compiling committee.c: too many arguments to function


