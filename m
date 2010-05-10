Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932941Ab0EJXON (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 May 2010 19:14:13 -0400
Received: from e35.co.us.ibm.com ([32.97.110.153]:44404 "EHLO
	e35.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757786Ab0EJXNn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 May 2010 19:13:43 -0400
Message-ID: <4BE8931C.9070106@linux.vnet.ibm.com>
Date: Mon, 10 May 2010 16:13:32 -0700
From: Corey Ashford <cjashfor@linux.vnet.ibm.com>
User-Agent: Mozilla/5.0 (Windows; U; Windows NT 5.1; en-US; rv:1.9.1.9) Gecko/20100317 Thunderbird/3.0.4
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>, Peter Zijlstra <peterz@infradead.org>
CC: Lin Ming <ming.m.lin@intel.com>, Frederic Weisbecker <fweisbec@gmail.com>,
       "eranian@gmail.com" <eranian@gmail.com>,
       "Gary.Mohr@Bull.com" <Gary.Mohr@bull.com>,
       "arjan@linux.intel.com" <arjan@linux.intel.com>,
       "Zhang, Yanmin" <yanmin_zhang@linux.intel.com>,
       Paul Mackerras <paulus@samba.org>,
       "David S. Miller" <davem@davemloft.net>,
       Russell King <rmk+kernel@arm.linux.org.uk>,
       Paul Mundt <lethal@linux-sh.org>, lkml <linux-kernel@vger.kernel.org>,
       Arnaldo Carvalho de Melo <acme@redhat.com>,
       Will Deacon <will.deacon@arm.com>, Maynard Johnson <mpjohn@us.ibm.com>,
       Carl Love <carll@us.ibm.com>, Paul Mackerras <paulus@samba.org>
Subject: Re: [RFC][PATCH 3/9] perf: export registerred pmus via sysfs
References: <1273483623.15998.57.camel@minggr.sh.intel.com> <1273484401.5605.3333.camel@twins> <1273486313.15998.76.camel@minggr.sh.intel.com> <1273486708.5605.3342.camel@twins> <1273487195.15998.85.camel@minggr.sh.intel.com> <1273490824.5605.3379.camel@twins> <20100510114311.GA6449@elte.hu> <1273492164.5605.3397.camel@twins> <20100510115344.GA11238@elte.hu>
In-Reply-To: <20100510115344.GA11238@elte.hu>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 5/10/2010 4:53 AM, Ingo Molnar wrote:
> 
> * Peter Zijlstra <peterz@infradead.org> wrote:
> 
>> On Mon, 2010-05-10 at 13:43 +0200, Ingo Molnar wrote:
>>>
>>> Yeah, we really want a mechanism like this in place instead of continuing with 
>>> the somewhat ad-hoc extensions to the event enumeration space.
>>>
>>> One detail: i think we want one more level. Instead of:
>>>
>>>  /sys/devices/system/node/nodeN/node_events
>>>                                 node_events/event_source_id
>>>                                 node_events/local_misses
>>>                                            /local_hits
>>>                                            /remote_misses
>>>                                            /remote_hits
>>>                                            /...
>>>
>>> We want the individual events to be a directory, containing the event_id:
>>>
>>>  /sys/devices/system/node/nodeN/node_events
>>>                                 node_events/event_source_id
>>>                                 node_events/local_misses/event_id
>>>                                            /local_hits/event_id
>>>                                            /remote_misses/event_id
>>>                                            /remote_hits/event_id
>>>                                            /...
>>>
>>> The reason is that we want to keep our options open to add more attributes to 
>>> individual events. (In fact extended attributes already exist for certain 
>>> event classes - such as the 'format' info for tracepoints.)

Having extra fields for each event would allow us to describe hardware-specific event attributes.  For example:
/sys/devices/system/node/nodeN/node_events
                               node_events/event_source_id
                               node_events/local_misses/event_id
                                          /local_hits/event_id
                                          /crypto_datamover  <- specific node PMU
                                              /marked_crb_rcv_des
                                                  /event_id
                                                  /attrib
                                                         /lpid <- attribute name
                                                         /lpid/type <- type of attribute (boolean, integer, etc.)
                                                         /lpid/min  <- min value of int attribute
                                                         /lpid/max  <- max value of int attribute
                                                         /lpid/bit_offset <- amount to shift attribute value before OR'ing into the raw event code
                                                         /marking_mode <- attribute name
                                                         /marking_mode/type
                                                         /...

Of course, these nodes would need to be replicated for each event that needs them or other attributes.


>>
>> Sure, sounds like a sensible suggestion.
>>
>> One thing I'd also like to clarify is that !raw events should not be 
>> exhaustive hardware event lists, those are best left for userspace, but 
>> instead are generally useful events that can be expected to be implemented 
>> by any hardware of that particular class.

Why exactly is this?  I got the impression this was something you and Ingo wanted earlier.  As big of an impact as it will be, it would be nice to unify the two event spaces (generic and raw) into one space that can be explored by a user space tool (or even crudely by /bin/ls).

>>
>> So a GPU might have things like 'vsync' and 'cmd_pipeline_stall' or whatever 
>> is a generic GPU feature, but not very implementation specific things that 
>> the next generation of hardware won't ever have.
> 
> Definitely so.
> 
> 	Ingo

Hi Ingo,

In the past, you said that you didn't want to have user space anything enumerate raw hardware events that are supported by the kernel.  So does the above represent a re-thinking of that position?

We'd like to have the capability of hardware-specific symbolic event names in the perf tool by some mechanism, unified or otherwise.  Right now, for the IBM Wire-Speed processor, we are currently not able to use the perf tool because of its lack of symbolic raw event name support.

In the mean time, we are using a pair of demo programs from Stephane Eranian's libpfm4 source tree called "task" and "syst".  These tools use the symbolic event names provided by libpfm4, and use the kernel support from perf_events.

Regards,

- Corey

