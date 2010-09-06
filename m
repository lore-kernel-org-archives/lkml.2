Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754555Ab0IFLfB (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Sep 2010 07:35:01 -0400
Received: from mx1.redhat.com ([209.132.183.28]:54314 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753568Ab0IFLfA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Sep 2010 07:35:00 -0400
Message-ID: <4C84D1CE.3070205@redhat.com>
Date: Mon, 06 Sep 2010 14:34:38 +0300
From: Avi Kivity <avi@redhat.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.8) Gecko/20100806 Fedora/3.1.2-1.fc13 Lightning/1.0b2pre Thunderbird/3.1.2
MIME-Version: 1.0
To: Peter Zijlstra <peterz@infradead.org>
CC: linux-perf-users@vger.kernel.org,
        linux-kernel <linux-kernel@vger.kernel.org>,
        Ingo Molnar <mingo@elte.hu>
Subject: Re: disabling group leader perf_event
References: <4C84B088.5050003@redhat.com> <1283772256.1930.303.camel@laptop>
In-Reply-To: <1283772256.1930.303.camel@laptop>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

  On 09/06/2010 02:24 PM, Peter Zijlstra wrote:
> On Mon, 2010-09-06 at 12:12 +0300, Avi Kivity wrote:
>> If I read the code correctly, disabling a group leader perf_event will
>> disable the entire group.
>>
>> Is this correct?
> Yeah, pretty much.

Well, I never liked group_leader style APIs.  I like different types for 
the container and the contained.  But such is not unix.

>> If so, how can I disable just the event itself?  Can I allocate a dummy
>> invent for the group leader so I can enable and disable each perf_event
>> in the group individually?
> Which makes me wonder why you use groups in the first place.

Basically, to read() all events in one go.  I have many of them.

My current problem is that I have an event (kvm_exit) which I want to 
drill down by looking at a field (exit_reason).  So I create lots of 
separate perf_events with a filter for each reason: 
kvm_exit(exit_reason==0), kvm_exit(exit_reason==1), etc.  But filters 
are fairly slow (can have ~60 such events on AMD), so I want to make 
this drill-down optional.

Current plan is to have a group for the basic events and another group 
for the drilldown events (each per-cpu), and activate the drilldown 
group on user request.  perf will be able to schedule both groups 
concurrently since they only contain tracepoints, yes?

-- 
error compiling committee.c: too many arguments to function

