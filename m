Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755402Ab0JYMG7 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Oct 2010 08:06:59 -0400
Received: from mx1.redhat.com ([209.132.183.28]:63965 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751574Ab0JYMG4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Oct 2010 08:06:56 -0400
Message-ID: <4CC5726B.1020207@redhat.com>
Date: Mon, 25 Oct 2010 10:04:59 -0200
From: Mauro Carvalho Chehab <mchehab@redhat.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.9) Gecko/20100827 Red Hat/3.1.3-1.el6 Lightning/1.0b2 Thunderbird/3.1.3
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>
CC: Andi Kleen <andi@firstfloor.org>, Huang Ying <ying.huang@intel.com>,
        Len Brown <lenb@kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-acpi@vger.kernel.org" <linux-acpi@vger.kernel.org>,
        Borislav Petkov <petkovbb@googlemail.com>,
        Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>,
        Don Zickus <dzickus@redhat.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Arjan van de Ven <arjan@infradead.org>,
        Tony Luck <tony.luck@intel.com>, Borislav Petkov <bp@amd64.org>
Subject: Re: [NAK] Re: [PATCH -v2 9/9] ACPI, APEI, Generic Hardware Error
 Source POLL/IRQ/NMI notification type support
References: <1287992610-14996-1-git-send-email-ying.huang@intel.com> <1287992610-14996-10-git-send-email-ying.huang@intel.com> <20101025084553.GA27119@elte.hu> <1287997112.2862.322.camel@yhuang-dev> <20101025091913.GA17622@basil.fritz.box> <20101025111530.GA27659@elte.hu>
In-Reply-To: <20101025111530.GA27659@elte.hu>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Em 25-10-2010 09:15, Ingo Molnar escreveu:
> 
> * Andi Kleen <andi@firstfloor.org> wrote:
> 
>>>> Sigh, please integrate all this into EDAC (drivers/edac/) properly, instead of 
>>>> turning it into YET ANOTHER hardware vendor special hw-errors thing. We can do 
>>>> better than this. EDAC is almost there: it has support for Nehalem, AMD, a 
>>>> couple of older chips.
>>>
>>> I think APEI (ACPI Platform Error Interface) is another driver. Why integrate 
>>> two drivers?
>>
>> Yes they're solving quite different problems from EDAC with different interfaces 
>> and for different devices in the ACPI space.
> 
> That's my whole point, _why_ do they have different interfaces?
> 
> EDAC is the upstream mechanism to organize hardware error reporting and to get 
> hardware errors to user-space. It is already successful in handling a wide range of 
> hardware in a similar fashion.
> 
> Furthermore, there is work ongoing to do the reporting via perf event channels, some 
> of that work is upstream already. Boris is working on persistent events, on RAS 
> tooling (tools/ras/) and on event injection. Here's a past submission of his work:
> 
>   http://lwn.net/Articles/394522/
> 
> You are now doing a completely separate thing here, detaching a big CPU vendor from 
> the main body of Linux code that deals with this stuff.
> 
> IMHO that's not helpful _at all_.

I agree with Ingo NAK. 

Having vendor-dependent API's for errors is not the way to solve those issues. We should 
focus on an unique hardware error report facility that will provide a clean, consistent, 
vendor-independent interface to userspace. EDAC successfully achieved this target for the
current designs, and it is evolving to cover newer hardware needs.

We had some discussions with Intel during the Collaboration summit about that, trying to 
integrate Nehalem EX on such environment, with, unfortunately, didn't happen, as Intel 
didn't release any (public) datasheet describing Nehalem EX memory controller, nor wrote 
such driver.

As most of us will be in Boston next week, I've reserved a BoF at Plumbers for us to discuss
about this subject:

http://www.linuxplumbersconf.org/2010/ocw/proposals/921


> 
>>>> einj.c: it's about the 3rd separate 'error injection' concept that got 
>>>> introduced ...
>>>
>>> EINJ is a true platform feature, not just software feature. We need to support 
>>> it to debug various hardware error features.
>>
>> Also having multiple error injecting interfaces is a good thing.
> 
> It's never a good thing to have separate, vendor dependent interfaces for what to 
> the user is basically the same conceptual thing!
> 
>> Error injection is hard and one size definitely doesn't fit all. You need quite 
>> different ones depending on what you want to test, in which context etc.
> 
> And that kind of variance is in your opinion a good reason to introduce separate 
> user ABIs for it?
> 
> ( And i dont care that there might be no 'end user' for hardware error injection per 
>   se right now. There is certainly an 'end user' for hardware error events and even 
>   _there_ you are introducing and pushing for separate, incompatible interfaces. )
> 
> We have really good historic data here: we got the _biggest_ practical advantage 
> from event enumeration (/debug/tracing/events/) when we extended it in a generic, 
> unified way to the rich topology that the hardware and the kernel gives us.
> 
> That way we got new, useful tools like powertop, timechart or pytimechart or the 
> edac tool, which can concentrate on a single, well-defined event topology and event 
> ABI.
> 
> Why do these tools like this kind of unified event enumeration and reporting 
> facilities, which you are fighting against so hard? Because of the big technological 
> advantage of having to deal with one enumeration and reporting facility alone. They 
> can get power events, scheduling events, timer events, kmalloc events all from the 
> same source - even though these subsystems have barely anything in common! Tools can 
> then combine these seemingly unrelated events into something new and useful.
> 
> It's a very extensible model, and with every new event type added, the tool space 
> gets richer _together_.
> 
> Error event injection to simulate/trigger various error conditions in those events 
> is a natural extension to the whole events framework - not something that should be 
> in a randomly different way.
> 
> What you are doing here is to fragment the whole landscape into small, incompatible, 
> vendor specific bits. Some of it is in /dev, some of it is in debugfs, some things 
> report via signals, etc. etc.
> 
> It's inconsistent, messy and doesnt integrate well with the events framework we are 
> building.
> 
> That was the main basis of my prior NAK, and you have said _nothing_ in the past 
> that invalidates the fundamental points of that NAK.
> 
> Instead you started, by stealth and by duplicity, looking for ways to get around 
> that conceptual NAK.
> 
>> For hwpoison we currently have three different injectors at least and I expect 
>> that to even grow more in the future as different features get added.
> 
> That's insane!
> 
> 	Ingo

