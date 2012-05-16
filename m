Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755063Ab2EPPYO (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 May 2012 11:24:14 -0400
Received: from mx1.redhat.com ([209.132.183.28]:3322 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753950Ab2EPPYM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 May 2012 11:24:12 -0400
Message-ID: <4FB3C690.4000006@redhat.com>
Date: Wed, 16 May 2012 12:24:00 -0300
From: Mauro Carvalho Chehab <mchehab@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:12.0) Gecko/20120430 Thunderbird/12.0.1
MIME-Version: 1.0
To: Steven Rostedt <rostedt@goodmis.org>
CC: Borislav Petkov <bp@amd64.org>, "Luck, Tony" <tony.luck@intel.com>,
        Linux Edac Mailing List <linux-edac@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Doug Thompson <norsk5@yahoo.com>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Ingo Molnar <mingo@redhat.com>
Subject: Re: [PATCH v22] edac, ras/hw_event.h: use events to handle hw issues
References: <3908561D78D1C84285E8C5FCA982C28F192EC247@ORSMSX104.amr.corp.intel.com>  <4FAC6FF8.3050608@redhat.com> <20120511102527.GI8913@aftab.osrc.amd.com>  <4FAD081C.5000704@redhat.com> <20120511172430.GB17299@aftab.osrc.amd.com>  <4FAD5CAD.90508@redhat.com> <20120514133404.GE4231@aftab.osrc.amd.com>  <4FB1163D.3010302@redhat.com> <20120515150957.GC27806@aftab.osrc.amd.com>  <4FB27EDC.8040001@redhat.com> <20120515163855.GE27806@aftab.osrc.amd.com> <1337172492.6724.36.camel@gandalf.stny.rr.com>
In-Reply-To: <1337172492.6724.36.camel@gandalf.stny.rr.com>
X-Enigmail-Version: 1.4.1
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Em 16-05-2012 09:48, Steven Rostedt escreveu:
> On Tue, 2012-05-15 at 18:38 +0200, Borislav Petkov wrote:
>> On Tue, May 15, 2012 at 01:05:48PM -0300, Mauro Carvalho Chehab wrote:
>>>> Here's what an error looks like on my system here:
>>>>
>>>>        mcegen.py-2868  [007] .N..   178.261607: mc_event: Corrected error:amd64_edac on memory stick "unknown memory" (mc:0 csrow:3 channel:1  page:0x5bac7 offset:0x388 grain:0 syndrome:0x34ed )
>>>>
>>>> There's still this trailing " " at the end of the error line which
>>>> shouldn't be there and also two spaces between "channel" and "page".
>>>
>>> If you take a look at the trace printk:
>>>
>>> + TP_printk("%s error:%s on memory stick \"%s\" (mc:%d %s %s %s)",
>>> +           (__entry->err_type == HW_EVENT_ERR_CORRECTED) ? "Corrected" :
>>> +                 ((__entry->err_type == HW_EVENT_ERR_FATAL) ?
>>> +
>>> +           __get_str(msg),
>>> +           __get_str(label),
>>> +           __entry->mc_index,
>>> +           __get_str(location),
>>> +           __get_str(detail),
>>> +           __get_str(driver_detail))
>>>
>>> There are not extra spaces there. The first extra space is probably because
>>> there is an extra space at the label string. This should be easy to fix.
>>>
>>> The other extra space at the end is because amd64 currently doesn't provide
>>> driver_detail information.
>>
>> Remind me again why do we need two strings: detail and driver_detail?
>>
>> Because they could very well be lumped together with a single "%s"
>> format - "(mc:%d %s)" - and be printed.
>>
>> And detail will always contain something which is not the empty string,
>> so problem solved.
> 
> Here's another trick if you want to get rid of the space and keep both
> fields:
> 
> TP_printk("%s error:%s on memory stick \"%s\" (mc:%d %s %s%s%s)",
>            (__entry->err_type == HW_EVENT_ERR_CORRECTED) ? "Corrected" :
>                  ((__entry->err_type == HW_EVENT_ERR_FATAL) ?
>                  "Fatal" : "Uncorrected"),
> 
>            __get_str(msg),
>            __get_str(label),
>            __entry->mc_index,
>            __get_str(location),
>            __get_str(detail),
> 	   strlen(__get_str(detail)) &&
> 	    strlen(__get_str(driver_detail) ? " ": "",
>            __get_str(driver_detail))

Great! I'll use that trick, thanks!
> 
> -- Steve
> 
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-edac" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

