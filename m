Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758366Ab1CaPcK (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 Mar 2011 11:32:10 -0400
Received: from mx1.redhat.com ([209.132.183.28]:32059 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758277Ab1CaPcI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 Mar 2011 11:32:08 -0400
Message-ID: <4D949E75.90701@redhat.com>
Date: Thu, 31 Mar 2011 11:32:05 -0400
From: Prarit Bhargava <prarit@redhat.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.1.9) Gecko/20100505 Fedora/3.0.4-2.el6 Thunderbird/3.0.4
MIME-Version: 1.0
To: Steven Rostedt <rostedt@goodmis.org>
CC: linux-kernel@vger.kernel.org, dzickus@redhat.com
Subject: Re: [PATCH]: Use cmpxchg() in WARN_*_ONCE() functions
References: <20110331124607.13219.33332.sendpatchset@prarit.bos.redhat.com> <20110331152319.GC14441@home.goodmis.org>
In-Reply-To: <20110331152319.GC14441@home.goodmis.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hey Steve,

On 03/31/2011 11:23 AM, Steven Rostedt wrote:
> On Thu, Mar 31, 2011 at 08:46:07AM -0400, Prarit Bhargava wrote:
>   
>> An issue popped up where WARN_ON_ONCE() was used in a callback function
>> in smp_call_function().  This resulted in the WARN_ON executing multiple times
>> when it should have only executed once.
>>     
> But that is just once per cpu, correct?
>   

Not always.  Sometimes I see a subset of CPUs ... maybe a cacheflush or
something hits that finally causes the remaining cpus to see __warned? 
I dunno...

But I have had 24/24 cpus output the message.

>   
>> I then did
>>
>>         for (i = 0; i < 1000000; i++)
>>                 on_each_cpu(prarit_callback, NULL, 0);
>>
>> The current code, of course, explodes :).  That's the bug I'm trying to fix.
>>     
> How exactly does it explode? How many CPUs do you have, and does this
> still just print once per CPU?
>
>   

It explodes because each cpu spits out a warning (which is the issue I'm
trying to resolve).

24 physical cores is what I tested on, but this has been seen in the
field on a system with 6 on RHEL6 (2.6.32/33/34/35/36/37/38-ish).

>> What is interesting in this test, however, is the impact that checking the
>> !__warned flag has [Aside: Checking the !__warned flag is an enhancement
>> and is not explicitly required for this code].
>>
>> A run with just (!cmpxchg(&__warned, 0, 1)) results in an average of 21.323s,
>> and a run with  (!__warned && !cmpxchg(&__warned, 0, 1)) results in an
>> average of 20.233s.  Of course, the !__warned is not necessary for the code
>> to work properly but it seems to be a significant impact to the time to run
>> this code.
>>     
> Yes adding the check for !__warned first should have obvious benefits.
>
> I really do not see anything wrong with this patch, but personally, I
> would rather fix what caused the WARN_ON_ONCE() than fix the warning
> itself, as long as the warning itself does not really break anything
> else.
>   


The WARN_ON_ONCE was triggering due to bad HW setup.  The system in
question had the APERFMPERF flag only set on the boot cpu and no other
cpus.  This caused the system to generate warnings in the acpi cpufreq code.

The HW issue was resolved by modifying a BIOS setting which was found to
clear the APERFMPERF cpu flag setting on the !boot cpus.  Yes, this
means the HW is busted.

But ... that still leaves the possibility that WARN_ON_ONCE spits out
many warnings instead of just one.  Hence, the patch.

P.

