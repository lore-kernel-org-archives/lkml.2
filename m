Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754353Ab2EPPQx (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 May 2012 11:16:53 -0400
Received: from mx1.redhat.com ([209.132.183.28]:22035 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754041Ab2EPPQv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 May 2012 11:16:51 -0400
Message-ID: <4FB3C4D3.7000802@redhat.com>
Date: Wed, 16 May 2012 12:16:35 -0300
From: Mauro Carvalho Chehab <mchehab@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:12.0) Gecko/20120430 Thunderbird/12.0.1
MIME-Version: 1.0
To: Borislav Petkov <bp@amd64.org>
CC: "Luck, Tony" <tony.luck@intel.com>,
        Linux Edac Mailing List <linux-edac@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Doug Thompson <norsk5@yahoo.com>, Steven Rostedt <rostedt@goodmis.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Ingo Molnar <mingo@redhat.com>
Subject: Re: [PATCH v22] edac, ras/hw_event.h: use events to handle hw issues
References: <20120511102527.GI8913@aftab.osrc.amd.com> <4FAD081C.5000704@redhat.com> <20120511172430.GB17299@aftab.osrc.amd.com> <4FAD5CAD.90508@redhat.com> <20120514133404.GE4231@aftab.osrc.amd.com> <4FB1163D.3010302@redhat.com> <20120515150957.GC27806@aftab.osrc.amd.com> <4FB27EDC.8040001@redhat.com> <20120515163855.GE27806@aftab.osrc.amd.com> <4FB38DDF.7030009@redhat.com> <20120516131656.GA2202@aftab.osrc.amd.com>
In-Reply-To: <20120516131656.GA2202@aftab.osrc.amd.com>
X-Enigmail-Version: 1.4.1
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Em 16-05-2012 10:16, Borislav Petkov escreveu:
> On Wed, May 16, 2012 at 08:22:07AM -0300, Mauro Carvalho Chehab wrote:
>>>> If you take a look at the trace printk:
>>>>
>>>> + TP_printk("%s error:%s on memory stick \"%s\" (mc:%d %s %s %s)",
>>>> +           (__entry->err_type == HW_EVENT_ERR_CORRECTED) ? "Corrected" :
>>>> +                 ((__entry->err_type == HW_EVENT_ERR_FATAL) ?
>>>> +                 "Fatal" : "Uncorrected"),
>>>> +           __get_str(msg),
>>>> +           __get_str(label),
>>>> +           __entry->mc_index,
>>>> +           __get_str(location),
>>>> +           __get_str(detail),
>>>> +           __get_str(driver_detail))
>>>>
>>>> There are not extra spaces there. The first extra space is probably because
>>>> there is an extra space at the label string. This should be easy to fix.
>>>>
>>>> The other extra space at the end is because amd64 currently doesn't provide
>>>> driver_detail information.
>>>
>>> Remind me again why do we need two strings: detail and driver_detail?
>>>
>>> Because they could very well be lumped together with a single "%s"
>>> format - "(mc:%d %s)" - and be printed.
>>
>> As already explained, after merging two different fields, they can't be easily
>> unmerged.
>>
>> The main reason for moving from printk to tracepoint is to allow userspace
>> programs to get data in binary format, avoiding them to parse a printk message.
>>
>> So, it is more important to provide the right information at the trace fields
>> than the niceness of the printk data.
> 
> This doesn't answer my question. My question was: "why can't 'detail'
> and 'driver_detail' be a single parameter, i.e. 'detail' and this way
> solve both pretty printing and getting binary data problems?

This is the 24th version of this very same patch... We started reviewing this patch
in January... All arguments about why this is a separate data were already said and
discussed.

In summary: all edac messages provide "detail" as this contains the error location
in terms of channel/slot. So, any MIB for EDAC could handle those parameters properly.
With regards to driver_detail, this have per-driver details. So, per-driver MIB is
required for them, if some userspace program wants to properly store that information.

Merging those two separate fields together only makes harder for userspace to store
the error detail information on their MIB.

> 
>>> And detail will always contain something which is not the empty string,
>>> so problem solved.
>>>
>>>>> Also, according to the output above "amd64_edac" is supposed to be
>>>>> [error msg] which is strange.
>>>>>
>>>>> I believe this comes from this call in f1x_map_sysaddr_to_csrow():
>>>>>
>>>>> 	        edac_mc_handle_error(HW_EVENT_ERR_CORRECTED, mci,
>>>>>                              page, offset, syndrome,
>>>>>                              csrow, chan, -1,
>>>>>                              EDAC_MOD_STR, "", NULL);
>>>>>
>>>>> I guess you want to do the following instead:
>>>>>
>>>>>        mcegen.py-2868  [007] .N..   178.261607: mc_event: amd64_edac: corrected error on memory stick "unknown memory" (mc:0 csrow:3 channel:1  page:0x5bac7 offset:0x388 grain:0 syndrome:0x34ed)
>>>>>
>>>>> maybe concatenate EDAC_MOD_STR with the proper string it reports, i.e.
>>>>> corrected/uncorrected error?
>>>>
>>>> The issue here is because amd64_edac (just like a few other drivers) use
>>>> its driver name (EDAC_MOD_STR) as the error message, instead of using 
>>>> something meaningful, like "read error" or "ECC error".
>>>
>>> No, the issue is here that edac_mc_handle_ce() used to say "CE..."
>>> and edac_mc_handle_ue() used to say "UE.. " and yours don't say that
>>> anymore. In other words, you need to add the "CE/UE" thing to the string
>>> based on the HW_EVENT_ERR_* flag or something to that effect.
>>
>>
>> Huh? 
>>
>>>>>        mcegen.py-2868  [007] .N..   178.261607: mc_event: Corrected error:amd64_edac on memory stick "unknown memory" (mc:0 csrow:3 channel:1  page:0x5bac7 offset:0x388 grain:0 syndrome:0x34ed )
>>
>> CE/UE is there. The only change is that, instead of using acronyms, it is now
>> saying "Corrected error"/"Uncorrected error", as the idea is to provide something
>> that the user will better understand.
> 
> Ok, so let's change the string output from the above version to:
> 
>  "mcegen.py-2868  [007] .N..   178.261607: mc_event: amd64_edac: Corrected error on memory stick "unknown memory" (mc:0 csrow:3 channel:1  page:0x5bac7 offset:0x388 grain:0 syndrome:0x34ed)"
> 
> I.e., "mc_event" [DRIVER] [ERROR TYPE] [DETAIL].

As I've explained, there is a consistency issue with the [ERROR MSG]. On the ones
that properly implement it, [ERROR MSG] is "read error", "spare copy", "bus error", ...

If you think we need to add an extra field for the driver name, then let's add a
"driver_name" field there, but a driver's name shouldn't be merged with an
error type message, as it is abusing the syntax, and the syntax of each field
should be clear enough to allow it to be stored on a MIB.

In any case, those drivers that fill the error msg with something else should
be changes to write there something like "ECC error" instead of "amd64_edac:".

Btw, I'm almost convinced that we should break the "detail" into its components,
e. g., instead of one string, it should be:
	int layer0, layer1, layer2;		/* Location */
	unsigned long memory_address; 		/* or maybe page/offset */
	u32 grain;
	unsigned syndrome;

That would be better from MIB point of view.

> 
>>>>>>     Of course, any userspace tools meant to handle errors should not parse
>>>>>>     the above data. They should, instead, use the binary fields provided by
>>>>>>     the tracepoint, mapping them directly into their MIBs.
>>>>>
>>>>> What is a MIB?
>>>>
>>>> Management Information Base. This is how anyone that works with Element
>>>> Management calls the model of information that represents each management
>>>> property. It is generally written using ITU-T ASN.1 syntax. Almost all
>>>> management software use that.
>>>>
>>>> [1] http://en.wikipedia.org/wiki/Management_information_base
>>>
>>> That looks like an ACPI or some other idiotic spec speak, pls remove it.
>>
>> No, MIB is not an idiotic speak. It is a widely-used term, older than TCP/IP, 
>> and defined by ITU-T (M.3000 series) and by ISO.
>>
>> It is used by everybody that knows a little bit about error management,
>> as all management systems and protocols (like SNMP) are based on MIB
>> concepts. This concept is also used by other international forums, like
>> IETF, to define the Information Model to be used to manage the machine
>> and/or network resources. For example, the TCP/IP stack management base
>> is defined at IETF RFC1213.
> 
> More idiotic drivel.
> 
> Oh, well, you won't let go of this crap, so at least add the wikipedia
> URL to the "MIB" reference so that mere mortals like me who don't know
> jack of error management can understand what you're talking about.

Ok, I'll add it.

Regards,
Mauro
