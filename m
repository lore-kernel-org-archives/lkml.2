Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753818Ab2E2Lzb (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 May 2012 07:55:31 -0400
Received: from e28smtp07.in.ibm.com ([122.248.162.7]:57561 "EHLO
	e28smtp07.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752768Ab2E2Lz3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 May 2012 07:55:29 -0400
Message-ID: <4FC4B902.7030702@linux.vnet.ibm.com>
Date: Tue, 29 May 2012 17:24:42 +0530
From: "Srivatsa S. Bhat" <srivatsa.bhat@linux.vnet.ibm.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:12.0) Gecko/20120424 Thunderbird/12.0
MIME-Version: 1.0
To: Steven Rostedt <rostedt@goodmis.org>
CC: "Rafael J. Wysocki" <rjw@sisk.pl>, mingo@kernel.org, lenb@kernel.org,
        pavel@ucw.cz, linux-pm@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] ftrace: Disable function tracing during suspend/resume
 and hibernation, again
References: <20120521065651.4142.36898.stgit@srivatsabhat.in.ibm.com> <201205212355.45929.rjw@sisk.pl> <1337638586.13348.7.camel@gandalf.stny.rr.com> <4FBB2E38.60804@linux.vnet.ibm.com>
In-Reply-To: <4FBB2E38.60804@linux.vnet.ibm.com>
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
x-cbid: 12052911-8878-0000-0000-000002B446C2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/22/2012 11:42 AM, Srivatsa S. Bhat wrote:

> On 05/22/2012 03:46 AM, Steven Rostedt wrote:
> 
>> On Mon, 2012-05-21 at 23:55 +0200, Rafael J. Wysocki wrote:
>>> On Monday, May 21, 2012, Srivatsa S. Bhat wrote:
>>>> If function tracing is enabled for some of the low-level suspend/resume
>>>> functions, it leads to triple fault during resume from suspend, ultimately
>>>> ending up in a reboot instead of a resume (or a total refusal to come out
>>>> of suspended state, on some machines).
>>>>
>>>> This issue was explained in more detail in commit f42ac38c59e0a03d (ftrace:
>>>> disable tracing for suspend to ram). However, the changes made by that commit
>>>> got reverted by commit cbe2f5a6e84eebb (tracing: allow tracing of
>>>> suspend/resume & hibernation code again). So, unfortunately since things are
>>>> not yet robust enough to allow tracing of low-level suspend/resume functions,
>>>> suspend/resume is still broken when ftrace is enabled.
>>>>
>>>> So fix this by disabling function tracing during suspend/resume & hibernation.
>>>
>>> Steve, any comments?
>>
>> I was actually the one to recommend this solution ;-)
>>
> 
> 
> And I am grateful to you for that :-)
> 
>> But that said, I actually do have some.
>>
>>>
>>>> Signed-off-by: Srivatsa S. Bhat <srivatsa.bhat@linux.vnet.ibm.com>
>>>> Cc: stable@vger.kernel.org
>>>> ---
>>>>
>>>>  kernel/power/hibernate.c |    6 ++++++
>>>>  kernel/power/suspend.c   |    3 +++
>>>>  2 files changed, 9 insertions(+), 0 deletions(-)
>>>>
>>>> diff --git a/kernel/power/hibernate.c b/kernel/power/hibernate.c
>>>> index e09dfbf..52a1817 100644
>>>> --- a/kernel/power/hibernate.c
>>>> +++ b/kernel/power/hibernate.c
>>>> @@ -352,6 +352,7 @@ int hibernation_snapshot(int platform_mode)
>>>>  	}
>>>>  
>>>>  	suspend_console();
>>>> +	ftrace_stop();
>>
>>
>> Is this a point of no return?
>>
> 
> Yes, especially as far as userspace is concerned.
> 
>> This probably isn't a problem, but I'm being a little paranoid. As
>> ftrace_stop/start() is just an on off switch, anyplace that calls
>> ftrace_start() will enable function tracing again. Ftrace_start() is
>> called by tracing_start() which is called when
>> the /sys/kernel/debug/tracing/trace file is opened and then closed. If
>> the close happens while the suspend is starting, it possibly can start
>> function tracing again.
>>
>> But this race would have to be done by the user, which should have full
>> control as they are in the process of suspending the machine. But they
>> may do it by accident.
>>
> 
> 
> Luckily, at all these places, all the userspace processes (and the freezable
> kernel threads) are already frozen. So nobody will be running at this point
> to open/close the trace file.
> 
> So there is no problem right?
> 
> (Of course, the non-freezable kernel threads might be running at this point,
> but IIUC, they can't trigger ftrace_start() from some other internal path..)
> 


Steve, do you have any other concerns about this patch or is it fine?

(I addressed your concern about some other event leading to ftrace_start() above).

Regards,
Srivatsa S. Bhat

