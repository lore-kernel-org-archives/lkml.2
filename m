Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756516Ab0LATXR (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Dec 2010 14:23:17 -0500
Received: from e1.ny.us.ibm.com ([32.97.182.141]:52930 "EHLO e1.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752672Ab0LATXQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Dec 2010 14:23:16 -0500
Message-ID: <4CF6A064.9030807@linux.vnet.ibm.com>
Date: Wed, 01 Dec 2010 11:22:12 -0800
From: Corey Ashford <cjashfor@linux.vnet.ibm.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.12) Gecko/20101103 Fedora/1.0-0.33.b2pre.fc14 Thunderbird/3.1.6
MIME-Version: 1.0
To: Peter Zijlstra <a.p.zijlstra@chello.nl>
CC: Ingo Molnar <mingo@elte.hu>, Frederic Weisbecker <fweisbec@gmail.com>,
        LKML <linux-kernel@vger.kernel.org>,
        Stephane Eranian <eranian@google.com>,
        Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [BUG(?)] perf_events: combining multiple tracepoint events into
 a group produces no counts on member events
References: <4CF59E20.1040301@linux.vnet.ibm.com> <1291203990.4023.16.camel@twins>
In-Reply-To: <1291203990.4023.16.camel@twins>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Content-Scanned: Fidelis XPS MAILER
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Thanks for your reply, Peter.

On 12/01/2010 03:46 AM, Peter Zijlstra wrote:
> On Tue, 2010-11-30 at 17:00 -0800, Corey Ashford wrote:
>> Hi,
>>
>> I'm not sure that what I'm seeing is a bug, or was something intentional.
>>
>> If I place multiple tracepoint events into a group and measure counts of
>> these events on a process, I get no counts for the tracepoint events
>> other than the group leader.
>>
>> Is this expected behavior?
>>
>> It's not clear to me why this should be the case; grouping shouldn't
>> have any ill effects on tracepoint events, from my understanding.
>>
>> I noticed this because my private version of the perf tool has the event
>> group patch https://lkml.org/lkml/2010/11/24/584 as well as the patch
>> which fixes the parsing of multiple tracepoint events in the same -e
>> switch: https://lkml.org/lkml/2010/11/30/460
>>
>> When I dig into the code a bit, I find that each event opens
>> successfully, so that's not the problem.  If I disable the grouping,
>> then I get counts for all of the tracepoint events.
>
> Hrm,.. definitely not expected. I'll try and look into it, but I'm a bit
> over-committed atm.
>
> Also, I've started a rewrite of the whole tracepoint<->  perf
> interaction:
>
>    http://lkml.org/lkml/2010/11/23/147
>
> Could you see if that cures your problem?

I've had some trouble getting recent kernels to boot on my Power5 
machine, but I might be able to try it on my laptop.

>
> Another thing to test, does the same hold true for regular software
> events? tracepoints and software events share a lot of infrastructure.

I just tried "perf stat -e context-switches,faults ..." on both my 
laptop (running 2.6.35), and on my Power5 machine (running 2.6.33) and I 
get the same behavior when software events are grouped, e.g.:
% ./perf stat -e context-switches,faults ~/load 1000

  Performance counter stats for '/home/corey/load 1000':

                 240  context-switches
       <not counted>  page-faults

         2.382022393  seconds time elapsed

So I suppose that points to a common flaw in the tracepoint and software 
event logic.

With that in mind, would it still make sense to try out your tracepoint 
patch?

- Corey
