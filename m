Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753472Ab0INKLQ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Sep 2010 06:11:16 -0400
Received: from mx4.orcon.net.nz ([219.88.242.54]:37840 "EHLO mx4.orcon.net.nz"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752250Ab0INKLO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Sep 2010 06:11:14 -0400
Message-ID: <4C8F4A3E.5070603@orcon.net.nz>
Date: Tue, 14 Sep 2010 22:11:10 +1200
From: Michael Cree <mcree@orcon.net.nz>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.11) Gecko/20100805 Icedove/3.0.6
MIME-Version: 1.0
To: Peter Zijlstra <peterz@infradead.org>
CC: mingo@redhat.com, dengcheng.zhu@gmail.com, yanmin_zhang@linux.intel.com,
        gorcunov@gmail.com, fweisbec@gmail.com, robert.richter@amd.com,
        ming.m.lin@intel.com, tglx@linutronix.de, hpa@zytor.com,
        paulus@samba.org, linux-kernel@vger.kernel.org, eranian@googlemail.com,
        will.deacon@arm.com, lethal@linux-sh.org, davem@davemloft.net,
        mingo@elte.hu, linux-alpha@vger.kernel.org
Subject: Re: [tip:perf/core] perf: Rework the PMU methods
References: <new-submission>	 <tip-a4eaf7f14675cb512d69f0c928055e73d0c6d252@git.kernel.org>	 <4C8B3AD3.5050309@orcon.net.nz> <1284198035.2251.29.camel@laptop>	 <4C8C6611.20206@orcon.net.nz>  <1284380153.2275.261.camel@laptop> <1284383927.2275.284.camel@laptop>
In-Reply-To: <1284383927.2275.284.camel@laptop>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-DSPAM-Check: by mx4.orcon.net.nz on Tue, 14 Sep 2010 22:11:11 +1200
X-DSPAM-Result: Innocent
X-DSPAM-Processed: Tue Sep 14 22:11:12 2010
X-DSPAM-Confidence: 0.8517
X-DSPAM-Probability: 0.0000
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 14/09/10 01:18, Peter Zijlstra wrote:
> On Mon, 2010-09-13 at 14:15 +0200, Peter Zijlstra wrote:
>> On Sun, 2010-09-12 at 17:33 +1200, Michael Cree wrote:
>>
>>> I've also tested it on a UP alpha.  It worked well for a little while
>>> but after running 'perf top' for a number of seconds I got the following
>>> warning:

>> Ahh, the alpha throttle call should be using the fancy new stop function
>> too (will fold into your earlier patch if it indeed works):
>>
>> As to the point you raised above, yes, I think it would be prudent to
>> call perf_event_do_pending() before update_process_times().
>>
>>
>> Signed-off-by: Peter Zijlstra<a.p.zijlstra@chello.nl>
>
> Damn I suck.. Please try this one.
>
> ---
> Index: linux-2.6/arch/alpha/kernel/perf_event.c
> ===================================================================
> --- linux-2.6.orig/arch/alpha/kernel/perf_event.c
> +++ linux-2.6/arch/alpha/kernel/perf_event.c
> @@ -850,7 +850,7 @@ static void alpha_perf_event_irq_handler
>   			/* Interrupts coming too quickly; "throttle" the
>   			 * counter, i.e., disable it for a little while.
>   			 */
> -			cpuc->idx_mask&= ~(1UL<<idx);
> +			alpha_pmu_stop(event, 0);
>   		}
>   	}
>   	wrperfmon(PERFMON_CMD_ENABLE, cpuc->idx_mask);

Thanks, that does the trick.  I have had it running for a while without 
any problems... Well, except for a new problem which I describe below. 
Anyway the above patch has fixed the original problem so can be rolled 
into my earlier one as you suggest.

I haven't shifted perf_event_do_pending() before update_process_times() 
in the timer interrupt yet.  When I get around to it I'll send a patch 
through the Alpha maintainer as this is independent of the work on the 
core perf event code.

Now to the new problem I saw:  I accidently reran 'perf top' while it 
was already running, and the second instance of 'perf top' seg-faulted 
and the kernel OOPSed with the following:

[  818.575752] Unable to handle kernel paging request at virtual address 
0000000000000060
[  818.575752] perf(4935): Oops 0
[  818.575752] pc = [<fffffc000036b8b8>]  ra = [<fffffc000036ba3c>]  ps 
= 0000    Not tainted
[  818.575752] pc is at put_ctx+0x18/0xb0
[  818.575752] ra is at free_event+0xec/0x220
[  818.575752] v0 = 0000000000000000  t0 = 0000000000000000  t1 = 
0000000000000002
[  818.575752] t2 = 0000000000000000  t3 = 0000000000000000  t4 = 
fffffc000063e4b0
[  818.575752] t5 = fffffc0034837000  t6 = fffffc0034837000  t7 = 
fffffc003abe0000
[  818.575752] s0 = 0000000000000000  s1 = 0000000000000000  s2 = 
0000000000000000
[  818.575752] s3 = ffffffffffffffff  s4 = 0000000000000000  s5 = 
0000000000000053
[  818.575752] s6 = fffffc0034836c00
[  818.575752] a0 = 0000000000000000  a1 = fffffc00311a6980  a2 = 
0000000000000000
[  818.575752] a3 = 0000000000000001  a4 = fffffc0000797110  a5 = 
00000001200055f8
[  818.575752] t8 = 0000000000000001  t9 = 00000001200396f4  t10= 
0000000000000000
[  818.575752] t11= 000000000000000a  pv = fffffc000031d650  at = 
fffffc000036f8bc
[  818.575752] gp = fffffc00007d6e40  sp = fffffc003abe3e18
[  818.575752] Disabling lock debugging due to kernel taint
[  818.575752] Trace:
[  818.575752] [<fffffc000036ba3c>] free_event+0xec/0x220
[  818.575752] [<fffffc000036fa24>] SyS_perf_event_open+0x2a4/0x6f0
[  818.575752] [<fffffc0000310c24>] entSys+0xa4/0xc0
[  818.575752]
[  818.575752] Code: 27bb0047  23bdb5a0  23defff0  b53e0008  b75e0000 
47f00409 <a8500060> 40403121

The first instance of 'perf top' kept running happily.

Cheers
Michael.
