Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753437Ab2JSIXr (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Oct 2012 04:23:47 -0400
Received: from e28smtp05.in.ibm.com ([122.248.162.5]:53696 "EHLO
	e28smtp05.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751133Ab2JSIXp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Oct 2012 04:23:45 -0400
Message-ID: <50810D0E.9090700@linux.vnet.ibm.com>
Date: Fri, 19 Oct 2012 13:49:26 +0530
From: Raghavendra K T <raghavendra.kt@linux.vnet.ibm.com>
Organization: IBM
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:15.0) Gecko/20120911 Thunderbird/15.0.1
MIME-Version: 1.0
To: Avi Kivity <avi@redhat.com>
CC: "Andrew M. Theurer" <habanero@linux.vnet.ibm.com>,
        Peter Zijlstra <peterz@infradead.org>, Rik van Riel <riel@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>, Ingo Molnar <mingo@redhat.com>,
        Marcelo Tosatti <mtosatti@redhat.com>,
        Srikar <srikar@linux.vnet.ibm.com>,
        "Nikunj A. Dadhania" <nikunj@linux.vnet.ibm.com>,
        KVM <kvm@vger.kernel.org>, Jiannan Ouyang <ouyang@cs.pitt.edu>,
        chegu vinod <chegu_vinod@hp.com>, LKML <linux-kernel@vger.kernel.org>,
        Srivatsa Vaddagiri <srivatsa.vaddagiri@gmail.com>,
        Gleb Natapov <gleb@redhat.com>, Andrew Jones <drjones@redhat.com>
Subject: Re: [PATCH RFC 1/2] kvm: Handle undercommitted guest case in PLE
 handler
References: <20120921120000.27611.71321.sendpatchset@codeblue> <505C654B.2050106@redhat.com> <505CA2EB.7050403@linux.vnet.ibm.com> <50607F1F.2040704@redhat.com> <20121003122209.GA9076@linux.vnet.ibm.com> <506C7057.6000102@redhat.com> <506D69AB.7020400@linux.vnet.ibm.com> <506D83EE.2020303@redhat.com> <1349356038.14388.3.camel@twins> <506DA48C.8050200@redhat.com> <20121009185108.GA2549@linux.vnet.ibm.com> <507FF87C.2060708@redhat.com>
In-Reply-To: <507FF87C.2060708@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
x-cbid: 12101908-8256-0000-0000-000004A59DDE
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/18/2012 06:09 PM, Avi Kivity wrote:
> On 10/09/2012 08:51 PM, Raghavendra K T wrote:
>> Here is the summary:
>> We do get good benefit by increasing ple window. Though we don't
>> see good benefit for kernbench and sysbench, for ebizzy, we get huge
>> improvement for 1x scenario. (almost 2/3rd of ple disabled case).
>>
>> Let me know if you think we can increase the default ple_window
>> itself to 16k.
>>
>
> I think so, there is no point running with untuned defaults.
>

Oaky.

>>
>> I can respin the whole series including this default ple_window change.
>
> It can come as a separate patch.

Yes. Will spin it separately.

>
>>
>> I also have the perf kvm top result for both ebizzy and kernbench.
>> I think they are in expected lines now.
>>
>> Improvements
>> ================
>>
>> 16 core PLE machine with 16 vcpu guest
>>
>> base = 3.6.0-rc5 + ple handler optimization patches
>> base_pleopt_16k = base + ple_window = 16k
>> base_pleopt_32k = base + ple_window = 32k
>> base_pleopt_nople = base + ple_gap = 0
>> kernbench, hackbench, sysbench (time in sec lower is better)
>> ebizzy (rec/sec higher is better)
>>
>> % improvements w.r.t base (ple_window = 4k)
>> ---------------+---------------+-----------------+-------------------+
>>                 |base_pleopt_16k| base_pleopt_32k | base_pleopt_nople |
>> ---------------+---------------+-----------------+-------------------+
>> kernbench_1x   |  0.42371      |  1.15164        |   0.09320         |
>> kernbench_2x   | -1.40981      | -17.48282       |  -570.77053       |
>> ---------------+---------------+-----------------+-------------------+
>> sysbench_1x    | -0.92367      | 0.24241         | -0.27027          |
>> sysbench_2x    | -2.22706      |-0.30896         | -1.27573          |
>> sysbench_3x    | -0.75509      | 0.09444         | -2.97756          |
>> ---------------+---------------+-----------------+-------------------+
>> ebizzy_1x      | 54.99976      | 67.29460        |  74.14076         |
>> ebizzy_2x      | -8.83386      |-27.38403        | -96.22066         |
>> ---------------+---------------+-----------------+-------------------+
>
> So it seems we want dynamic PLE windows.  As soon as we enter overcommit
> we need to decrease the window.
>

Okay.
I have some rough idea on the implementation. I 'll try that after this
V2 experiments are over.
So in brief, I have this in my queue priority wise

1) V2 version of this patch series( in progress)
2) default PLE window
3) preemption notifiers
4) Pv spinlock

