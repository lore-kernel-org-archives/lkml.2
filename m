Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755940Ab2EVNpz (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 May 2012 09:45:55 -0400
Received: from mx1.redhat.com ([209.132.183.28]:25968 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752606Ab2EVNpy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 May 2012 09:45:54 -0400
Message-ID: <4FBB986F.5030306@redhat.com>
Date: Tue, 22 May 2012 16:45:19 +0300
From: Avi Kivity <avi@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:12.0) Gecko/20120430 Thunderbird/12.0.1
MIME-Version: 1.0
To: Steven Rostedt <rostedt@goodmis.org>
CC: linux-kernel <linux-kernel@vger.kernel.org>, Ingo Molnar <mingo@elte.hu>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        "H. Peter Anvin" <hpa@zytor.com>, Thomas Gleixner <tglx@linutronix.de>,
        Paul Turner <pjt@google.com>, Peter Zijlstra <peterz@infradead.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
Subject: Re: NMI vs #PF clash
References: <4FBB8C40.6080304@redhat.com> <1337693441.13348.36.camel@gandalf.stny.rr.com>
In-Reply-To: <1337693441.13348.36.camel@gandalf.stny.rr.com>
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/22/2012 04:30 PM, Steven Rostedt wrote:
> On Tue, 2012-05-22 at 15:53 +0300, Avi Kivity wrote:
>> The recent changes to NMI allow exceptions to take place in NMI
>> handlers, but I think that a #PF (say, due to access to vmalloc space)
>> is still problematic.  Consider the sequence
>> 
>>   #PF  (cr2 set by processor)
>>     NMI
>>       ...
>>       #PF (cr2 clobbered)
>>         do_page_fault()
>>         IRET
>>       ...
>>       IRET
>>     do_page_fault()
>>       address = read_cr2()
> 
> This is still problematic. But the "allow faults in NMI" wasn't written
> for page faults, although they wont totally crash the system like they
> use to. If a NMI triggers during a page fault routine before the reading
> of the cr2, and it takes a page fault, then yes, this will corrupt the
> cr2 and cause unpredictable results (not good)
> 
> That said, we still should not be having page faults in NMI. The fault
> handling was to allow breakpoints in the NMI code, which should not be a
> problem here. There is code to handle nested breakpoints because of
> NMIs.

I thought the whole thing was started by someone adding a
vmalloc_sync_all() to prevent this scenario, and Linus wanting to
fix NMI instead.  But maybe I'm confusing two threads.

> Now if we want to handle page faults from NMI context, we could do some
> tricks to have the NMI detect that it interrupted a page fault before it
> read the cr2 and in that case, save off the cr2 register, and restore it
> before returning.
> 
> Or we could just have the NMI always restore the cr2 register.

IMO that's best.


-- 
error compiling committee.c: too many arguments to function
