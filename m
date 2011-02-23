Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752526Ab1BWGUs (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Feb 2011 01:20:48 -0500
Received: from cn.fujitsu.com ([222.73.24.84]:60439 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1751907Ab1BWGUq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Feb 2011 01:20:46 -0500
Message-ID: <4D64A75D.1010404@cn.fujitsu.com>
Date: Wed, 23 Feb 2011 14:21:17 +0800
From: Lai Jiangshan <laijs@cn.fujitsu.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.9) Gecko/20100921 Fedora/3.1.4-1.fc14 Thunderbird/3.1.4
MIME-Version: 1.0
To: Steven Rostedt <rostedt@goodmis.org>
CC: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        linux-kernel@vger.kernel.org, mingo@elte.hu, dipankar@in.ibm.com,
        akpm@linux-foundation.org, mathieu.desnoyers@polymtl.ca,
        josh@joshtriplett.org, niv@us.ibm.com, tglx@linutronix.de,
        peterz@infradead.org, Valdis.Kletnieks@vt.edu, dhowells@redhat.com,
        eric.dumazet@gmail.com, darren@dvhart.com
Subject: Re: [PATCH RFC tip/core/rcu 06/11] smp: Document transitivity for
 memory barriers.
References: <20110223013917.GA20996@linux.vnet.ibm.com>	 <1298425183-21265-6-git-send-email-paulmck@linux.vnet.ibm.com> <1298431742.7666.77.camel@gandalf.stny.rr.com>
In-Reply-To: <1298431742.7666.77.camel@gandalf.stny.rr.com>
X-MIMETrack: Itemize by SMTP Server on mailserver/fnst(Release 8.5.1FP4|July 25, 2010) at
 2011-02-23 14:19:39,
	Serialize by Router on mailserver/fnst(Release 8.5.1FP4|July 25, 2010) at
 2011-02-23 14:19:39,
	Serialize complete at 2011-02-23 14:19:39
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/23/2011 11:29 AM, Steven Rostedt wrote:
> On Tue, 2011-02-22 at 17:39 -0800, Paul E. McKenney wrote:
>> Transitivity is guaranteed only for full memory barriers (smp_mb()).
>>
>> Signed-off-by: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
>> ---
>>  Documentation/memory-barriers.txt |   58 +++++++++++++++++++++++++++++++++++++
>>  1 files changed, 58 insertions(+), 0 deletions(-)
>>
>> diff --git a/Documentation/memory-barriers.txt b/Documentation/memory-barriers.txt
>> index 631ad2f..f0d3a80 100644
>> --- a/Documentation/memory-barriers.txt
>> +++ b/Documentation/memory-barriers.txt
>> @@ -21,6 +21,7 @@ Contents:
>>       - SMP barrier pairing.
>>       - Examples of memory barrier sequences.
>>       - Read memory barriers vs load speculation.
>> +     - Transitivity
>>  
>>   (*) Explicit kernel barriers.
>>  
>> @@ -959,6 +960,63 @@ the speculation will be cancelled and the value reloaded:
>>  	retrieved                               :       :       +-------+
>>  
>>
>> +TRANSITIVITY
>> +------------
>> +
>> +Transitivity is a deeply intuitive notion about ordering that is not
>> +always provided by real computer systems.  The following example
>> +demonstrates transitivity (also called "cumulativity"):
>> +
>> +	CPU 1			CPU 2			CPU 3
>> +	=======================	=======================	=======================
>> +		{ X = 0, Y = 0 }
>> +	STORE X=1		LOAD X			STORE Y=1
>> +				<general barrier>	<general barrier>
>> +				LOAD Y			LOAD X
>> +
>> +Suppose that CPU 2's load from X returns 1 and its load from Y returns 0.
>> +This indicates that CPU 2's load from X in some sense follows CPU 1's
>> +store to X and that CPU 2's load from Y in some sense preceded CPU 3's
>> +store to Y.  The question is then "Can CPU 3's load from X return 0?"
>> +
>> +Because CPU 2's load from X in some sense came after CPU 1's store, it
>> +is natural to expect that CPU 3's load from X must therefore return 1.
>> +This expectation is an example of transitivity: if a load executing on
>> +CPU A follows a load from the same variable executing on CPU B, then
>> +CPU A's load must either return the same value that CPU B's load did,
>> +or must return some later value.
>> +
>> +In the Linux kernel, use of general memory barriers guarantees
>> +transitivity.  Therefore, in the above example, if CPU 2's load from X
>> +returns 1 and its load from Y returns 0, then CPU 3's load from X must
>> +also return 1.
>> +
>> +However, transitivity is -not- guaranteed for read or write barriers.
>> +For example, suppose that CPU 2's general barrier in the above example
>> +is changed to a read barrier as shown below:
>> +
>> +	CPU 1			CPU 2			CPU 3
>> +	=======================	=======================	=======================
>> +		{ X = 0, Y = 0 }
>> +	STORE X=1		LOAD X			STORE Y=1
>> +				<read barrier>		<general barrier>
>> +				LOAD Y			LOAD X
>> +
>> +This substitution destroys transitivity: in this example, it is perfectly
>> +legal for CPU 2's load from X to return 1, its load from Y to return 0,
>> +and CPU 3's load from X to return 0.
>> +
>> +The key point is that although CPU 2's read barrier orders its pair
>> +of loads, it does not guarantee to order CPU 1's store.  Therefore, if
>> +this example runs on a system where CPUs 1 and 2 share a store buffer
>> +or a level of cache, CPU 2 might have early access to CPU 1's writes.
>> +General barriers are therefore required to ensure that all CPUs agree
>> +on the combined order of CPU 1's and CPU 2's accesses.
> 
> Sounds like someone had a fun time debugging their code.
> 
>> +
>> +To reiterate, if your code requires transitivity, use general barriers
>> +throughout.
> 
> I expect that your code is the only code in the kernel that actually
> requires transitivity ;-)
> 

Maybe, but my RCURING also requires transitivity, I had asked Paul for advice
one years ago when I was writing the patch. Good document for it!

Thanks,
Lai
