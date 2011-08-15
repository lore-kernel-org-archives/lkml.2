Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751819Ab1HOEYi (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Aug 2011 00:24:38 -0400
Received: from mail-gx0-f174.google.com ([209.85.161.174]:63138 "EHLO
	mail-gx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750782Ab1HOEYg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Aug 2011 00:24:36 -0400
Message-ID: <4E489F81.7060007@gmail.com>
Date: Sun, 14 Aug 2011 22:24:33 -0600
From: David Ahern <dsahern@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:5.0) Gecko/20110707 Thunderbird/5.0
MIME-Version: 1.0
To: Frederic Weisbecker <fweisbec@gmail.com>, acme@ghostprotocols.net
CC: linux-perf-users@vger.kernel.org, linux-kernel@vger.kernel.org,
        mingo@elte.hu, peterz@infradead.org, paulus@samba.org,
        tglx@linutronix.de
Subject: Re: [PATCH 4/6] perf record: add time-of-day option
References: <1307490806-24548-1-git-send-email-dsahern@gmail.com> <1307490964-24714-1-git-send-email-dsahern@gmail.com> <20110617141425.GD25197@somewhere.redhat.com> <4DFB6345.3080007@gmail.com> <20110617151510.GG25197@somewhere.redhat.com>
In-Reply-To: <20110617151510.GG25197@somewhere.redhat.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/17/2011 09:15 AM, Frederic Weisbecker wrote:
> On Fri, Jun 17, 2011 at 08:23:01AM -0600, David Ahern wrote:
>> On 06/17/2011 08:14 AM, Frederic Weisbecker wrote:
>>>
>>> So I feel uncomfortable with this tod_sample_type hack. I think we can't really continue
>>> with this fixed sample_type per session given the kind of hacks that involves.
>>>
>>> One thing we could do is to split session->sample_type into an array with one sample
>>> type per event type (hardware, breakpoint, software, tracepoint).
>>>
>>> And then each builtin tool can provide their constraints on top of these values:
>>>
>>> - builtin-report wants sample_type[HARDWARE] == sample_type[SOFTWARE] == sample_type[TRACEPOINT] == sample_type[BREAKPOINT]
>>>   although that may be tunable by the time but we can start with that.
>>> - builtin-script has no specific constraints, except that sample_type[i] meets what the user passed as a parameter
>>> - etc..
>>>
>>> Constraints can probably default to sample_type[i] == sample_type[i+1] to mimic the current behaviour. Then tools
>>> can override that.
>>>
>>> What do you think?
>>
>> I started working on sample_type refactoring right after sending this
>> patchset (though I got sidetracked). Each evsel in the list has a
>> perf_attr struct which has a sample_type. Why not use that which allows
>> events to have their own sample type - versus a type per event type?
> 
> This can make sense, I can figure out some cases where such granularity can be
> useful. Branch recording doesn't care about recording period for example I think.
> 
>>
>> I'll see if I can get back to it in the next few days and get a better
>> idea of the pain involved with the refactoring.
> 
> Thanks a lot :)

Coming back to this one ....

>From what I can see sample_type has to be a global per perf session and
all samples have to use the same sample_type or a change is needed to
the API/ABI.

The perf_event_header does not have any information that uniquely
associates it with a specific event type. Right now
perf_evlist__id2evsel() is used to associate a sample with a specific
event (evsel) in the list, but that function requires a parsed sample.
To parse a sample we need the sample_type. So, the sample_type has to be
a global and the same for all samples.

David
