Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965000Ab2CTN6F (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Mar 2012 09:58:05 -0400
Received: from e23smtp02.au.ibm.com ([202.81.31.144]:39947 "EHLO
	e23smtp02.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760021Ab2CTN6B (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Mar 2012 09:58:01 -0400
Message-ID: <4F688CE1.5080703@linux.vnet.ibm.com>
Date: Tue, 20 Mar 2012 19:27:53 +0530
From: "Srivatsa S. Bhat" <srivatsa.bhat@linux.vnet.ibm.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:10.0.1) Gecko/20120209 Thunderbird/10.0.1
MIME-Version: 1.0
To: Steven Rostedt <rostedt@goodmis.org>
CC: "Rafael J. Wysocki" <rjw@sisk.pl>, "mingo@elte.hu" <mingo@elte.hu>,
        "pavel@ucw.cz" <pavel@ucw.cz>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Linux PM mailing list <linux-pm@vger.kernel.org>,
        linux-kernel <linux-kernel@vger.kernel.org>
Subject: Re: Suspend-to-ram not working when ftrace is enabled, again!
References: <4F6754DA.6090401@linux.vnet.ibm.com> <1332250970.23924.10.camel@gandalf.stny.rr.com>
In-Reply-To: <1332250970.23924.10.camel@gandalf.stny.rr.com>
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
x-cbid: 12032003-5490-0000-0000-000000FAA0A9
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/20/2012 07:12 PM, Steven Rostedt wrote:

> On Mon, 2012-03-19 at 21:16 +0530, Srivatsa S. Bhat wrote:
>> Hi,
>>
>> If tracing is enabled and we are tracing low-level suspend-to-ram related
>> functions like restore_processor_state() etc (which are included by default
>> in the list of traced functions), and we try suspending the machine, the
>> machine doesn't resume. It reboots instead.
>> (If we trace some unrelated functions like kzalloc() for example, there is
>> no problem with suspend/resume).
> 
> Yeah, this is a know issue. I need to look at the suspend code and add
> notrace annotations, or keep entire files from being traced.
> 
> The problem is that on resume, there's functions that are called that do
> not have all kernel setup initialized. For example, smp_processor_id()
> uses the %gs register to access the per_cpu data which also contains the
> cpu id. On resume, the %gs register is not yet set up, and calling the
> function tracer, which uses smp_processor_id() to find out what buffer
> to write to causes a page fault. Then the page fault handling also calls
> the function tracer which it too will page fault, and we end up with a
> triple fault and the machine reboots.
> 
> 


In that case, I wonder why your patch to disable tracing during suspend
was reverted at all ?! (commit cbe2f5a6e84)

>>
>> Looking at https://lkml.org/lkml/2008/8/27/177, it appears that this
>> is an old problem and also had a workaround (disabling tracing around
>> suspend). The above patch corresponds to commit id: f42ac38c59 (ftrace:
>> disable tracing for suspend to ram), which went in around 2.6.27 I think.
>> But then commit cbe2f5a6e84 (tracing: allow tracing of suspend/resume &
>> hibernation code again) reverted that commit.
>>
>> And from https://lkml.org/lkml/2008/8/21/349, it looks like 2.6.28 and
>> further was supposed to be problem-free. But unfortunately this problem has
>> resurfaced.
>>
>> I tested kernel 2.6.32.54 and I observed that the machine reboots during
>> resume, which looks exactly like the problem discussed in the link above.
>>
>> In another machine, I tested 3.3-rc6 and it doesn't seem to respond to
>> resume events (like button press, lid open) at all. It just seems to remain
>> suspended forever.
>>
>> Should we resort to disabling ftrace around suspend again? Or do we have a
>> better solution this time around?
>>
> 
> No the real solution is to find the functions that break and fix them.
> Probably requires more notrace annotations.
> 

 
Regards,
Srivatsa S. Bhat

