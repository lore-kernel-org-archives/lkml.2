Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S967439Ab2EPLW1 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 May 2012 07:22:27 -0400
Received: from mx1.redhat.com ([209.132.183.28]:43544 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S966952Ab2EPLWZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 May 2012 07:22:25 -0400
Message-ID: <4FB38DDF.7030009@redhat.com>
Date: Wed, 16 May 2012 08:22:07 -0300
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
References: <3908561D78D1C84285E8C5FCA982C28F192EC247@ORSMSX104.amr.corp.intel.com> <4FAC6FF8.3050608@redhat.com> <20120511102527.GI8913@aftab.osrc.amd.com> <4FAD081C.5000704@redhat.com> <20120511172430.GB17299@aftab.osrc.amd.com> <4FAD5CAD.90508@redhat.com> <20120514133404.GE4231@aftab.osrc.amd.com> <4FB1163D.3010302@redhat.com> <20120515150957.GC27806@aftab.osrc.amd.com> <4FB27EDC.8040001@redhat.com> <20120515163855.GE27806@aftab.osrc.amd.com>
In-Reply-To: <20120515163855.GE27806@aftab.osrc.amd.com>
X-Enigmail-Version: 1.4.1
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Em 15-05-2012 13:38, Borislav Petkov escreveu:
> On Tue, May 15, 2012 at 01:05:48PM -0300, Mauro Carvalho Chehab wrote:
>>> Here's what an error looks like on my system here:
>>>
>>>        mcegen.py-2868  [007] .N..   178.261607: mc_event: Corrected error:amd64_edac on memory stick "unknown memory" (mc:0 csrow:3 channel:1  page:0x5bac7 offset:0x388 grain:0 syndrome:0x34ed )
>>>
>>> There's still this trailing " " at the end of the error line which
>>> shouldn't be there and also two spaces between "channel" and "page".
>>
>> If you take a look at the trace printk:
>>
>> + TP_printk("%s error:%s on memory stick \"%s\" (mc:%d %s %s %s)",
>> +           (__entry->err_type == HW_EVENT_ERR_CORRECTED) ? "Corrected" :
>> +                 ((__entry->err_type == HW_EVENT_ERR_FATAL) ?
>> +                 "Fatal" : "Uncorrected"),
>> +           __get_str(msg),
>> +           __get_str(label),
>> +           __entry->mc_index,
>> +           __get_str(location),
>> +           __get_str(detail),
>> +           __get_str(driver_detail))
>>
>> There are not extra spaces there. The first extra space is probably because
>> there is an extra space at the label string. This should be easy to fix.
>>
>> The other extra space at the end is because amd64 currently doesn't provide
>> driver_detail information.
> 
> Remind me again why do we need two strings: detail and driver_detail?
> 
> Because they could very well be lumped together with a single "%s"
> format - "(mc:%d %s)" - and be printed.

As already explained, after merging two different fields, they can't be easily
unmerged.

The main reason for moving from printk to tracepoint is to allow userspace
programs to get data in binary format, avoiding them to parse a printk message.

So, it is more important to provide the right information at the trace fields
than the niceness of the printk data.

> 
> And detail will always contain something which is not the empty string,
> so problem solved.
> 
>>> Also, according to the output above "amd64_edac" is supposed to be
>>> [error msg] which is strange.
>>>
>>> I believe this comes from this call in f1x_map_sysaddr_to_csrow():
>>>
>>> 	        edac_mc_handle_error(HW_EVENT_ERR_CORRECTED, mci,
>>>                              page, offset, syndrome,
>>>                              csrow, chan, -1,
>>>                              EDAC_MOD_STR, "", NULL);
>>>
>>> I guess you want to do the following instead:
>>>
>>>        mcegen.py-2868  [007] .N..   178.261607: mc_event: amd64_edac: corrected error on memory stick "unknown memory" (mc:0 csrow:3 channel:1  page:0x5bac7 offset:0x388 grain:0 syndrome:0x34ed)
>>>
>>> maybe concatenate EDAC_MOD_STR with the proper string it reports, i.e.
>>> corrected/uncorrected error?
>>
>> The issue here is because amd64_edac (just like a few other drivers) use
>> its driver name (EDAC_MOD_STR) as the error message, instead of using 
>> something meaningful, like "read error" or "ECC error".
> 
> No, the issue is here that edac_mc_handle_ce() used to say "CE..."
> and edac_mc_handle_ue() used to say "UE.. " and yours don't say that
> anymore. In other words, you need to add the "CE/UE" thing to the string
> based on the HW_EVENT_ERR_* flag or something to that effect.


Huh? 

>>>        mcegen.py-2868  [007] .N..   178.261607: mc_event: Corrected error:amd64_edac on memory stick "unknown memory" (mc:0 csrow:3 channel:1  page:0x5bac7 offset:0x388 grain:0 syndrome:0x34ed )

CE/UE is there. The only change is that, instead of using acronyms, it is now
saying "Corrected error"/"Uncorrected error", as the idea is to provide something
that the user will better understand.

> [ … ]
> 
>>>>     Of course, any userspace tools meant to handle errors should not parse
>>>>     the above data. They should, instead, use the binary fields provided by
>>>>     the tracepoint, mapping them directly into their MIBs.
>>>
>>> What is a MIB?
>>
>> Management Information Base. This is how anyone that works with Element
>> Management calls the model of information that represents each management
>> property. It is generally written using ITU-T ASN.1 syntax. Almost all
>> management software use that.
>>
>> [1] http://en.wikipedia.org/wiki/Management_information_base
> 
> That looks like an ACPI or some other idiotic spec speak, pls remove it.

No, MIB is not an idiotic speak. It is a widely-used term, older than TCP/IP, 
and defined by ITU-T (M.3000 series) and by ISO.

It is used by everybody that knows a little bit about error management,
as all management systems and protocols (like SNMP) are based on MIB
concepts. This concept is also used by other international forums, like
IETF, to define the Information Model to be used to manage the machine
and/or network resources. For example, the TCP/IP stack management base
is defined at IETF RFC1213.

> 
> [ … ]
> 
>>>> + * edac_mc_handle_error - reports a memory event to userspace
>>>> + *
>>>> + * @type:		severity of the error (CE/UE/Fatal)
>>>> + * @mci:		a struct mem_ctl_info pointer
>>>> + * @page_frame_number:	mem page where the error occurred
>>>> + * @offset_in_page:	offset of the error inside the page
>>>> + * @syndrome:		ECC syndrome
>>>> + * @layer0:		Memory layer0 position
>>>> + * @layer1:		Memory layer2 position
>>>> + * @layer2:		Memory layer3 position
>>>> + * @msg:		Message meaningful to the end users that
>>>> + *			explains the event
>>>> + * @other_detail:	Technical details about the event that
>>>> + *			may help hardware manufacturers and
>>>> + *			EDAC developers to analyse the event
>>>
>>> 					analyze it.
>>
>> Analyse is the same as analyze [2].
> 
> I know that. What I meant is
> 
> s/EDAC developers to analyse the event/EDAC developers to analyse it/
> 

Ah, OK, I'll fix that.

Regards,
Mauro
