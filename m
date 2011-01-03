Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755584Ab1ACTzn (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Jan 2011 14:55:43 -0500
Received: from terminus.zytor.com ([198.137.202.10]:49226 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753621Ab1ACTzm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Jan 2011 14:55:42 -0500
Message-ID: <4D222926.9010206@zytor.com>
Date: Mon, 03 Jan 2011 11:53:10 -0800
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.13) Gecko/20101209 Fedora/3.1.7-0.35.b3pre.fc13 Thunderbird/3.1.7
MIME-Version: 1.0
To: Peter Zijlstra <a.p.zijlstra@chello.nl>
CC: Lin Ming <ming.m.lin@intel.com>, Ingo Molnar <mingo@elte.hu>,
        Andi Kleen <andi@firstfloor.org>,
        Stephane Eranian <eranian@google.com>,
        lkml <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 4/7] perf: Check if HT is supported and enabled
References: <1293464211.2695.104.camel@localhost>	 <AANLkTimp9VgD4qhOVmq-k1Ckzti9eeV8pf6Jvt5YB6nx@mail.gmail.com>	 <1293526288.2457.4.camel@minggr.sh.intel.com> <1294052312.2016.50.camel@laptop>
In-Reply-To: <1294052312.2016.50.camel@laptop>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/03/2011 02:58 AM, Peter Zijlstra wrote:
>>
>> This function can be simplified as below,
>>
>> static bool ht_enabled()
>> {
>>         if (!cpu_has(&boot_cpu_data, X86_FEATURE_HT))
>>                 return false;
>>
>>         return smp_num_siblings > 1;
>> }
>>
>> But this still can't detect if HT is on or off.
>> smp_num_siblings is always 2 even if HT is disabled in BIOS.
>>
>> Any idea how to detect if HT is on or not?
> 
> Not quite sure, the intel docs aren't really clear on how the HW
> supports HT, has 2 siblings but BIOS disabled it thing works. I just
> tried reading the arch/x86 code but that only got me more confused.
> 
> hpa, could you comment?
> 

Zeroeth of all: anyone who writes () in a function prototype in C needs
to get severely napalmed, maimed, hung and then really hurt.  It is
(void) in C, () means (...) which is literally NEVER what you want.

Now, *first* of all: smp_num_siblings as it sits is obviously broken;
the whole notion of a global variable for what is inherently a per-cpu
property is just braindead.  At least theoretically there could be cores
with and without HT or with different thread count in the same system.

Second, perf should get this from /proc/cpuinfo, not by grotting around
cpuid by itself.

Third, the code in the kernel is indeed pretty confusing, and it also
has the global variable braindamage... but either it works (in which
case getting the data from /proc/cpuinfo works) or it needs fixing in
addition to the global variable issue.

	-hpa
