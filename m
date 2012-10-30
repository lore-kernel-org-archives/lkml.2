Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754853Ab2J3GCe (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Oct 2012 02:02:34 -0400
Received: from e28smtp05.in.ibm.com ([122.248.162.5]:42612 "EHLO
	e28smtp05.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750720Ab2J3GCb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Oct 2012 02:02:31 -0400
Message-ID: <508F6C60.1050202@linux.vnet.ibm.com>
Date: Tue, 30 Oct 2012 11:27:52 +0530
From: Raghavendra K T <raghavendra.kt@linux.vnet.ibm.com>
Organization: IBM
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:16.0) Gecko/20121009 Thunderbird/16.0
MIME-Version: 1.0
To: Peter Zijlstra <peterz@infradead.org>
CC: "H. Peter Anvin" <hpa@zytor.com>, Avi Kivity <avi@redhat.com>,
        Ingo Molnar <mingo@redhat.com>, Marcelo Tosatti <mtosatti@redhat.com>,
        Rik van Riel <riel@redhat.com>, Srikar <srikar@linux.vnet.ibm.com>,
        "Nikunj A. Dadhania" <nikunj@linux.vnet.ibm.com>,
        KVM <kvm@vger.kernel.org>, Jiannan Ouyang <ouyang@cs.pitt.edu>,
        Chegu Vinod <chegu_vinod@hp.com>,
        "Andrew M. Theurer" <habanero@linux.vnet.ibm.com>,
        LKML <linux-kernel@vger.kernel.org>,
        Srivatsa Vaddagiri <srivatsa.vaddagiri@gmail.com>,
        Gleb Natapov <gleb@redhat.com>, Andrew Jones <drjones@redhat.com>
Subject: Re: [PATCH V2 RFC 3/3] kvm: Check system load and handle different
 commit cases accordingly
References: <20121029140621.15448.92083.sendpatchset@codeblue> <20121029140717.15448.83182.sendpatchset@codeblue> <1351533280.24721.46.camel@twins>
In-Reply-To: <1351533280.24721.46.camel@twins>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
x-cbid: 12103006-8256-0000-0000-000004C84E78
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/29/2012 11:24 PM, Peter Zijlstra wrote:
> On Mon, 2012-10-29 at 19:37 +0530, Raghavendra K T wrote:
>> +/*
>> + * A load of 2048 corresponds to 1:1 overcommit
>> + * undercommit threshold is half the 1:1 overcommit
>> + * overcommit threshold is 1.75 times of 1:1 overcommit threshold
>> + */
>> +#define COMMIT_THRESHOLD (FIXED_1)
>> +#define UNDERCOMMIT_THRESHOLD (COMMIT_THRESHOLD >> 1)
>> +#define OVERCOMMIT_THRESHOLD ((COMMIT_THRESHOLD << 1) -
>> (COMMIT_THRESHOLD >> 2))
>> +
>> +unsigned long kvm_system_load(void)
>> +{
>> +       unsigned long load;
>> +
>> +       load = avenrun[0] + FIXED_1/200;
>> +       load = load / num_online_cpus();
>> +
>> +       return load;
>> +}
>
> ARGH.. no that's wrong.. very wrong.
>
>   1) avenrun[] EXPORT_SYMBOL says it should be removed, that's not a
> joke.

Okay.

>   2) avenrun[] is a global load, do not ever use a global load measure

This makes sense. Using a local optimization that leads to near global
optimization is the way to go.

>
>   3) avenrun[] has nothing what so ever to do with runqueue lengths,
> someone with a gazillion tasks in D state will get a huge load but the
> cpu is very idle.
>

I used loadavg as an alternative measure. But the above condition
poses a concern for that.

Okay, now IIUC, usage of *any* global measure is bad?

Because I was also thinking to use nrrunning()/ num_online_cpus(), to
get an idea of global overcommit sense. (ofcourse since, this involves
iteration over per CPU nrrunning, I wanted to calculate this
periodically)

The overall logic, of having overcommit_threshold, 
undercommit_threshold, I wanted to use for even dynamic ple_window 
tuning purpose.

so logic was:
< undercommit_threshold => 16k ple_window
 > overcommit_threshold  => 4k window.
for in between case scale the ple_window accordingly.

The alternative was to decide depending on how ple handler succeeded in
yield_to. But I thought, that is too sensitive and more overhead.

This topic may deserve different thread, but thought I shall table it here.

So, Thinking about the alternatives to implement, logic such as

(a) if(undercommitted)
     just go back and spin rather than going for yield_to iteration.
(b) if (overcommitted)
    better to yield rather than  spinning logic

    of current patches..

[ ofcourse, (a) is already met to large extent by your patches..]

So I think everything boils down to

"how do we measure these two thresholds without much overhead in a
compliant way"

Ideas welcome..

