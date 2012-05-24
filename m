Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933530Ab2EXQNi (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 May 2012 12:13:38 -0400
Received: from mx1.redhat.com ([209.132.183.28]:1028 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932304Ab2EXQNg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 May 2012 12:13:36 -0400
Message-ID: <4FBE5E1D.7070804@redhat.com>
Date: Thu, 24 May 2012 13:13:17 -0300
From: Mauro Carvalho Chehab <mchehab@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:12.0) Gecko/20120430 Thunderbird/12.0.1
MIME-Version: 1.0
To: Borislav Petkov <bp@amd64.org>
CC: Linux Edac Mailing List <linux-edac@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Aristeu Rozanski <arozansk@redhat.com>,
        Doug Thompson <norsk5@yahoo.com>, Steven Rostedt <rostedt@goodmis.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Ingo Molnar <mingo@redhat.com>
Subject: Re: [PATCH] RAS: Add a tracepoint for reporting memory controller
 events
References: <1337358773-6919-38-git-send-email-mchehab@redhat.com> <1337854460-25191-1-git-send-email-mchehab@redhat.com> <20120524105604.GC27063@aftab.osrc.amd.com>
In-Reply-To: <20120524105604.GC27063@aftab.osrc.amd.com>
X-Enigmail-Version: 1.4.1
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Em 24-05-2012 07:56, Borislav Petkov escreveu:
> On Thu, May 24, 2012 at 07:14:20AM -0300, Mauro Carvalho Chehab wrote:
>> + * Default error mechanisms for Memory Controller errors (CE and UE)
>> + */
>> +TRACE_EVENT(mc_event,
>> +
>> +	TP_PROTO(const unsigned int err_type,
>> +		 const unsigned int mc_index,
>> +		 const char *error_msg,
>> +		 const char *label,
>> +		 int layer0,
>> +		 int layer1,
>> +		 int layer2,
>> +		 unsigned long address,
>> +		 unsigned long grain,
>> +		 unsigned long syndrome,
>> +		 const char *driver_detail),
> 
> What about the comments I had about layer{0,1,2} and grain?
> 
> http://marc.info/?l=linux-edac&m=133769207124938&w=2

Sorry, I missed that email.


Em 22-05-2012 10:05, Borislav Petkov escreveu:
> On Tue, May 22, 2012 at 07:18:21AM -0300, Mauro Carvalho Chehab wrote:
>> Em 22-05-2012 06:28, Borislav Petkov escreveu:
>>> On Tue, May 22, 2012 at 12:04:48AM -0300, Mauro Carvalho Chehab wrote:
>>>> +TRACE_EVENT(mc_event,
>>>> +
>>>> +	TP_PROTO(const unsigned int err_type,
>>>> +		 const unsigned int mc_index,
>>>> +		 const char *error_msg,
>>>> +		 const char *label,
>>>> +		 int layer0,
>>>> +		 int layer1,
>>>> +		 int layer2,
>>>
>>> Those are EDAC-internal layer representation, why are they exported to
>>> userspace? Userspace needs only the location and label AFAICT.
>>
>> Those are not the EDAC internal layer representation. They're the physical
>> location of the DIMM or rank.
> 
> Ok, you've replaced the location char * with the layers.

Yes. 
> 
>>> If you export them to userspace, they need much more meaningful names -
>>> layer{0,1,2} mean nothing outside of the kernel.
>>
>> Ok. Do you have a better naming suggestion?
>>
>> What about layer0_pos, layer1_pos, layer2_pos?
> 
> Actually, I'd like them to be called channel/rank/row or something. Having them
> numbered I don't know which layer is the top layer (channel/branch/slot)
> and the lowest (rank/csrow/...)
> 
> Maybe top_layer, middle_layer, lowest_layer? Or something like that...

Works for me.

> 
>>>
>>>> +		 unsigned long pfn,
>>>> +		 unsigned long offset,
>>>> +		 unsigned long grain,
>>>
>>> Why aren't those a single 'unsigned long address' since they all are
>>> computed from it?
>>
>> We can merge pfn and offset into "unsigned long address".
> 
> Just have a single "unsigned long address" field and userspace can pick
> out the stuff it needs from it.

Ok.

>> With regards to the grain, it is an address mask, written with a "short" way.
>> So, grain 32, for example, means:
>> 	ffff:ffff:ffff:fffe0
>>
>> As the current EDAC API exports it as grain, IMO, it is better to keep it as-is,
>> but it won't be hard to do:
>> 	unsigned long mask = ((unsigned long) -1) && (1 - grain)
>>
>> What do you think?
> 
> Why are we even exporting grain actually with each tracepoint
> invocation? This is the granularity of reported error in bytes, and it,
> as such, is statically assigned to a value in each driver. Userspace can
> certainly figure out that value in a different way.

The API doesn't export the grain, except via the tracepoint/printk.

> But the more important question is: does the grain help us when handling
> the error info in userspace?
> 
> It tells us that at this physical address with "grain" granularity we
> had an error. So?

While a certain number of corrected errors that happened on different, sparsed,
addresses may not mean a damaged memory, the same number of corrected errors
happening at the same physical address/grain means that the DRAM chip that
contains such address is damaged, so the corresponding DIMM needs to be 
replaced.

So, the address/grain can be used by userspace algorithms to increase the
probability that a DIMM is damaged.

Regards,
Mauro.

I'm folding the following patch with this one:

diff --git a/include/ras/ras_event.h b/include/ras/ras_event.h
index 5b06c43..18dde46 100644
--- a/include/ras/ras_event.h
+++ b/include/ras/ras_event.h
@@ -49,9 +49,9 @@ TRACE_EVENT(mc_event,
 		__field(	unsigned int,	mc_index		)
 		__string(	msg,		error_msg		)
 		__string(	label,		label			)
-		__field(	int,		layer0			)
-		__field(	int,		layer1			)
-		__field(	int,		layer2			)
+		__field(	int,		top_layer		)
+		__field(	int,		middle_layer		)
+		__field(	int,		lower_layer		)
 		__field(	int,		address			)
 		__field(	int,		grain			)
 		__field(	int,		syndrome		)
@@ -63,9 +63,9 @@ TRACE_EVENT(mc_event,
 		__entry->mc_index		= mc_index;
 		__assign_str(msg, error_msg);
 		__assign_str(label, label);
-		__entry->layer0			= layer0;
-		__entry->layer1			= layer1;
-		__entry->layer2			= layer2;
+		__entry->top_layer		= layer0;
+		__entry->middle_layer		= layer1;
+		__entry->lower_layer		= layer2;
 		__entry->address		= address;
 		__entry->grain			= grain;
 		__entry->syndrome		= syndrome;
@@ -80,9 +80,9 @@ TRACE_EVENT(mc_event,
 		  __get_str(msg),
 		  __get_str(label),
 		  __entry->mc_index,
-		  __entry->layer0,
-		  __entry->layer1,
-		  __entry->layer2,
+		  __entry->top_layer,
+		  __entry->middle_layer,
+		  __entry->lower_layer,
 		  __entry->address,
 		  __entry->grain,
 		  __entry->syndrome,

