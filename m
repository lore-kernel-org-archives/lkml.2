Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932521Ab0KLP4a (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Nov 2010 10:56:30 -0500
Received: from mail.windriver.com ([147.11.1.11]:57728 "EHLO
	mail.windriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757402Ab0KLP43 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Nov 2010 10:56:29 -0500
Message-ID: <4CDD6389.2080206@windriver.com>
Date: Fri, 12 Nov 2010 09:55:53 -0600
From: Jason Wessel <jason.wessel@windriver.com>
User-Agent: Thunderbird 2.0.0.24 (X11/20101027)
MIME-Version: 1.0
To: Don Zickus <dzickus@redhat.com>
CC: Ingo Molnar <mingo@elte.hu>, Peter Zijlstra <peterz@infradead.org>,
        Robert Richter <robert.richter@amd.com>, ying.huang@intel.com,
        Andi Kleen <andi@firstfloor.org>, LKML <linux-kernel@vger.kernel.org>,
        Frederic Weisbecker <fweisbec@gmail.com>
Subject: Re: [V2 PATCH 0/6] x86, NMI: give NMI handler a face-lift
References: <1289573033-2889-1-git-send-email-dzickus@redhat.com> <4CDD579F.80009@windriver.com> <20101112154231.GN4823@redhat.com>
In-Reply-To: <20101112154231.GN4823@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 12 Nov 2010 15:55:54.0863 (UTC) FILETIME=[16B6CFF0:01CB8282]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/12/2010 09:42 AM, Don Zickus wrote:
> On Fri, Nov 12, 2010 at 09:05:03AM -0600, Jason Wessel wrote:
>   
>> On 11/12/2010 08:43 AM, Don Zickus wrote:
>>     
>>> Restructuring the nmi handler to be more readable and simpler.
>>>
>>> This is just laying the ground work for future improvements in this area.
>>>
>>> I also left out one of Huang's patch until we figure out how we are going
>>> to proceed with a new notifier.
>>>
>>> Tested 32-bit and 64-bit on AMD and Intel machines.
>>>
>>> V2:  add a patch to kill DIE_NMI_IPI and add in priorities
>>>
>>>   
>>>       
>> Had you tested this code with kgdb boot tests at all?
>>
>> CONFIG_LOCKUP_DETECTOR=y
>> CONFIG_HARDLOCKUP_DETECTOR=y
>> CONFIG_KGDB=y
>> CONFIG_KGDB_TESTS_ON_BOOT=y
>> CONFIG_KGDB_TESTS_BOOT_STRING="V1F100"
>>
>> There has been a regression in kgdb due to the use of perf/NMI in the
>> lockup detector ever since the new version has been introduced.   The
>> perf callbacks in the lockup detector were consuming NMI events not
>> related to the call back and causing the kernel debugger not to work at
>> all on SMP systems configured with the lockup detector.
>>     
>
> Well 2.6.36 should have fixed that.  Perf was blindly eating all NMI
> events if it had a user.  With the new lockup detector, that created a
> 'user' for perf and it happily ate everything.  But we spent a lot of time
> trying to fix that for 2.6.36.  If we missed something, we would like to
> know.
>
> To answer your question, I doubt this patch series will change that
> outcome if it is still broken.
>
>   

It was most definitely broken in 2.6.36->2.6.37-rc1.  Randy Dunlap had
pointed this out in a separate exchange that was not on LKML.

The symptom you would see looks like:

...kernel boot...
Serial: 8250/16550 driver, 4 ports, IRQ sharing disabled
serial8250: ttyS0 at I/O 0x3f8 (irq = 4) is a 16550A
00:06: ttyS0 at I/O 0x3f8 (irq = 4) is a 16550A
brd: module loaded
kgdb: Registered I/O driver kgdbts.
kgdbts:RUN plant and detach test
[...HARD HANG STARTS HERE...]

The kernel is looping at that point waiting for the master kgdb cpu to
have all the slaves join the debugger but it never happens because the
perf callback chain which is used by the lockup detector eats the NMI
IPI event.  After the perf callback is processed perf returns
NOTIFY_STOP so the notifier which brings the slave CPU into the debugger
never fires.

You can even see the behavior booting a kernel with the kgdb tests using
kvm with -smp 2.

I did build with your 6 part series, and the behavior is no different
(meaning it is still broken).

Jason.
