Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932646Ab0KLQfj (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Nov 2010 11:35:39 -0500
Received: from mail.windriver.com ([147.11.1.11]:65404 "EHLO
	mail.windriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932557Ab0KLQfi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Nov 2010 11:35:38 -0500
Message-ID: <4CDD6CAD.30303@windriver.com>
Date: Fri, 12 Nov 2010 10:34:53 -0600
From: Jason Wessel <jason.wessel@windriver.com>
User-Agent: Thunderbird 2.0.0.24 (X11/20101027)
MIME-Version: 1.0
To: Don Zickus <dzickus@redhat.com>
CC: Ingo Molnar <mingo@elte.hu>, Peter Zijlstra <peterz@infradead.org>,
        Robert Richter <robert.richter@amd.com>, ying.huang@intel.com,
        Andi Kleen <andi@firstfloor.org>, LKML <linux-kernel@vger.kernel.org>,
        Frederic Weisbecker <fweisbec@gmail.com>
Subject: Re: [V2 PATCH 0/6] x86, NMI: give NMI handler a face-lift
References: <1289573033-2889-1-git-send-email-dzickus@redhat.com> <4CDD579F.80009@windriver.com> <20101112154231.GN4823@redhat.com> <4CDD6389.2080206@windriver.com> <20101112161144.GP4823@redhat.com>
In-Reply-To: <20101112161144.GP4823@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 12 Nov 2010 16:34:55.0392 (UTC) FILETIME=[89C73200:01CB8287]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/12/2010 10:11 AM, Don Zickus wrote:
> On Fri, Nov 12, 2010 at 09:55:53AM -0600, Jason Wessel wrote:
>   
>>> To answer your question, I doubt this patch series will change that
>>> outcome if it is still broken.
>>>
>>>   
>>>       
>> It was most definitely broken in 2.6.36->2.6.37-rc1.  Randy Dunlap had
>> pointed this out in a separate exchange that was not on LKML.
>>     
>
> Can you clarify by what you mean by broken above?  Was 2.6.36 good or bad?
>
>   

It was absolutely broken in 2.6.36 which I believe is where the new
LOCKUP_DETECTOR changes were introduced.

I tested 2.6.35 and it does not hard hang, but suffered from a different
problem with a perf API change.   The kgdb tests appear to loop and loop
emitting endless streams of output in 2.6.35 and I already have that
problem patched.

At this point we have to get back to a working base line.  At this point
if you use 2.6.37-rc1 the last remaining problem is the perf + lockup
detector callback eating the injected DIE_NMI event which is meant to
enter the debugger.


>> The symptom you would see looks like:
>>
>> ...kernel boot...
>> Serial: 8250/16550 driver, 4 ports, IRQ sharing disabled
>> serial8250: ttyS0 at I/O 0x3f8 (irq = 4) is a 16550A
>> 00:06: ttyS0 at I/O 0x3f8 (irq = 4) is a 16550A
>> brd: module loaded
>> kgdb: Registered I/O driver kgdbts.
>> kgdbts:RUN plant and detach test
>> [...HARD HANG STARTS HERE...]
>>
>> The kernel is looping at that point waiting for the master kgdb cpu to
>> have all the slaves join the debugger but it never happens because the
>> perf callback chain which is used by the lockup detector eats the NMI
>> IPI event.  After the perf callback is processed perf returns
>> NOTIFY_STOP so the notifier which brings the slave CPU into the debugger
>> never fires.
>>     
>
> Ok.  We have code to handle extra spurious NMIs that is hard to accurately
> determine if the NMI was for perf or someone else.  This logic may still
> need tweaking.  What cpu are you running on?  AMD/Intel?  If Intel, then
> core/core2/nehalem?
>
>   

In this case I just built a 32 bit kernel and ran it under kvm on a 64
bit host.  I can send you the .config separately.

kvm  -nographic -k en-us -kernel arch/x86/boot/bzImage -net user -net
nic,macaddr=52:54:00:12:34:56,model=i82557b -append
"console=ttyS0,115200 ip=dhcp root=/dev/nfs
nfsroot=10.0.2.2:/space/exp/x86 rw acpi=force UMA=1" -smp 2


Thanks,
Jason.
