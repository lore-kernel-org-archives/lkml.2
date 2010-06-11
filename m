Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760127Ab0FKK1F (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Jun 2010 06:27:05 -0400
Received: from mailout1.zih.tu-dresden.de ([141.30.67.72]:44892 "EHLO
	mailout1.zih.tu-dresden.de" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756133Ab0FKK1B convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Jun 2010 06:27:01 -0400
Message-ID: <4C120F67.3050400@tu-dresden.de>
Date: Fri, 11 Jun 2010 12:26:47 +0200
From: =?UTF-8?B?Um9ubnkgVHNjaMO8dGVy?= <Ronny.Tschueter@tu-dresden.de>
User-Agent: Mozilla/5.0 (X11; U; Linux i686 (x86_64); de; rv:1.9.1.9) Gecko/20100317 Lightning/1.0b1 Thunderbird/3.0.4
MIME-Version: 1.0
To: =?UTF-8?B?Um9iZXJ0IFNjaMO2bmU=?= <robert.schoene@tu-dresden.de>
CC: Arjan van de Ven <arjan@linux.intel.com>, rostedt@goodmis.org,
       Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: Tracing of power:power_start events doesn't work
References: <4BDECD66.2010906@tu-dresden.de>	 <1273019517.22438.10.camel@gandalf.stny.rr.com>	 <4BE17C90.2020205@tu-dresden.de>	 <1273069881.22438.17.camel@gandalf.stny.rr.com>	 <4BE181BD.8010804@linux.intel.com> <1273654646.3598.227.camel@localhost>
In-Reply-To: <1273654646.3598.227.camel@localhost>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8BIT
X-TUD-Virus-Scanned: mailout1.zih.tu-dresden.de
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/05/2010 10:57, Robert Schöne wrote:
> On Wed, den 05.05.2010-05-05, 07:33 -0700 schrieb Arjan van de Ven:
>    
>> On 5/5/2010 7:31, Steven Rostedt wrote:
>>      
>>> On Wed, 2010-05-05 at 16:11 +0200, Ronny Tsch�ter wrote:
>>>
>>>        
>>>>     /*
>>>>      * Include the apic definitions for x86 to have the APIC timer related
>>>> defines
>>>> @@ -796,6 +797,18 @@ static int acpi_idle_bm_check(void)
>>>>      */
>>>>     static inline void acpi_idle_do_entry(struct acpi_processor_cx *cx)
>>>>     {
>>>> +    switch (cx->type) {
>>>> +    case ACPI_STATE_C1:
>>>> +        trace_power_start(POWER_CSTATE, 1);
>>>> +        break;
>>>> +    case ACPI_STATE_C2:
>>>> +        trace_power_start(POWER_CSTATE, 2);
>>>> +        break;
>>>> +    case ACPI_STATE_C3:
>>>> +        trace_power_start(POWER_CSTATE, 3);
>>>> +        break;
>>>> +    }
>>>> +
>>>>          
>>> Depending on gcc, the above can bloat the code since each call to
>>> trace_power_start() is a macro expanded. Try to call it just once.
>>> Perhaps one of the following:
>>>        
>> the code is also incorrect fundamentally.
>> You need to pass in the mwait value or equivalent; the ACPI STATE type is
>> pretty much useless random garbage and should completely be ignored.
>>      
> You're correct for your case (switching to c-state via monitor/mwait).
> But the current implementation is broken too. It works only if your
> kernel uses processor_idle AND monitor/mwait. For all other cases it
> fails - may it be on Ronnys system, that uses IO port based C-states or
> my system, that uses cpu_idle (not processor_idle).
>
> I'd suggest, that it should work for IO port based switches and could be
> included in the syntactic block of that case.
> Afaik, halt means that the processor goes to C1. So in this block, there
> could be a power_start event too with 1 as new state. (Maybe there are
> problems with AMDs C1E which would be reported as C1.)
>
> Robert
>    
Unfortunately the bug still exists in kernel 2.6.34. On my system I'm 
not able to trace power:power_start events, because they are not 
reported. Regarding to the preceding comments I moved my code snippet 
into the IO port based C-state part of acpi_idle_do_entry(). Therefore 
it should not interfere with the other two C-state calls in this function.
Furthermore a lot of other code sequences in processor_idle.c use the 
ACPI STATE type in if- or switch-statements. So I don't think that ACPI 
STATE type is useless garbage.

Finally here is my new patch:


diff --git a/old/processor_idle.c b/new/processor_idle.c
index 5939e7f..5818522 100644
--- a/old/processor_idle.c
+++ b/new/processor_idle.c
@@ -43,6 +43,7 @@
  #include <linux/clockchips.h>
  #include <linux/cpuidle.h>
  #include <linux/irqflags.h>
+#include <trace/events/power.h>

  /*
   * Include the apic definitions for x86 to have the APIC timer related 
defines
@@ -807,6 +808,10 @@ static inline void acpi_idle_do_entry(struct 
acpi_processor_cx *cx)
      } else {
          int unused;
          /* IO port based C-state */
+        trace_power_start(POWER_CSTATE,
+        cx->type == ACPI_STATE_C1 ? 1 :
+        cx->type == ACPI_STATE_C2 ? 2 :
+        3);
          inb(cx->address);
          /* Dummy wait op - must do something useless after P_LVL2 read
             because chipsets cannot guarantee that STPCLK# signal
