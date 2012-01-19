Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752458Ab2ASXZb (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Jan 2012 18:25:31 -0500
Received: from nctlincom02.orcon.net.nz ([60.234.4.75]:55868 "EHLO
	nctlincom02.orcon.net.nz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751897Ab2ASXZa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Jan 2012 18:25:30 -0500
X-Greylist: delayed 598 seconds by postgrey-1.27 at vger.kernel.org; Thu, 19 Jan 2012 18:25:29 EST
Cc: linux-kernel@vger.kernel.org, linux-alpha@vger.kernel.org,
        Shaohua Li <shaohua.li@intel.com>, Richard Henderson <rth@twiddle.net>,
        Ivan Kokshaysky <ink@jurassic.park.msu.ru>,
        Matt Turner <mattst88@gmail.com>
Message-Id: <458655D9-91A7-4E1B-8E3A-5C86D87887F7@orcon.net.nz>
From: Michael Cree <mcree@orcon.net.nz>
To: paulmck@linux.vnet.ibm.com
In-Reply-To: <20111208011650.GH2367@linux.vnet.ibm.com>
Content-Type: text/plain; charset=US-ASCII; format=flowed; delsp=yes
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0 (Apple Message framework v936)
Subject: Re: rcu_sched_state detected stalls on Alpha with generic config
Date: Fri, 20 Jan 2012 12:15:18 +1300
References: <4EDF0CEB.80904@orcon.net.nz> <20111208011650.GH2367@linux.vnet.ibm.com>
X-Mailer: Apple Mail (2.936)
X-DSPAM-Check: by mx1.orcon.net.nz on Fri, 20 Jan 2012 12:15:43 +1300
X-DSPAM-Result: Innocent
X-DSPAM-Processed: Fri Jan 20 12:15:43 2012
X-DSPAM-Confidence: 0.7007
X-DSPAM-Probability: 0.0000
X-Bayes-Prob: 0.0001 (Score 0, tokens from: @@RPTN, default)
X-Spam-Score: 0.00 () [Hold at 5.00] 
X-CanIt-Geo: ip=130.217.188.11; country=NZ; region=G1; city=Hamilton; latitude=-37.7833; longitude=175.2833; http://maps.google.com/maps?q=-37.7833,175.2833&z=6
X-CanItPRO-Stream: base:default
X-Canit-Stats-ID: 05Gnzfy6c - e50acf6456aa - 20120120
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 8/12/2011, at 2:16 PM, Paul E. McKenney wrote:
> On Wed, Dec 07, 2011 at 07:51:23PM +1300, Michael Cree wrote:
>> I am seeing "rcu_sched_state detected stall on CPU" messages on Alpha
>> architecture with a generic SMP config.  Interactive tasks are seen  
>> to
>> lock up, with "INFO: task X blocked for more than 120 seconds" in the
>> kernel logs, and eventual kernel oops and panic, on latest 3.2-rc4  
>> and
>> traceable back to 3.0.  Bisection between 2.6.39 and 3.0 leads to  
>> commit:
>>
>> 09223371deac67d08ca0b70bd18787920284c967
>> rcu: Use softirq to address performance regression
>>
>> as the first bad commit.
>>
>> Tested on an Alpha ES45 (Titan) with three 1.25 GHz CPUs and 4 GByte
>> memory.  Testing procedure is to build git software and run its test
>> suite with -j4 in the make command argument.
>>
>> The CPU stall messages and eventually system lockup is only seen  
>> with a
>> generic Alpha config, never with a Titan machine specific config.
>>
>> An example of kernel logs is (this one probably produced when I  
>> tried to
>> shutdown the system when it is falling over):
>>
>> [45360.930876] INFO: rcu_sched_state detected stall on CPU 1  
>> (t=798848
>> jiffies)
>> [45360.931853] INFO: rcu_sched_state detected stalls on CPUs/tasks:  
>> { 1}
>> (detected by 0, t=798850 jiffies)
>> [45489.080225] INFO: task umount:17371 blocked for more than 120  
>> seconds.
>> [45489.158350] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs"
>> disables this message.
>> [45489.252100] umount          D fffffc00013461ac     0 17371  17368
>> 0x00000000
>> [45489.336084] fffffc00fdd53db8 fffffc00fdd97bb8 fffffc000108ca1c
>> fffffc00dcc9e800
>> [45489.422998]        fffffc00dcc9e810 fffffc00013b3a5d  
>> fffffc000106289c
>> fffffc00ff0dfda8
>> [45489.519678]        0000000000000000 fffffc000108c81c  
>> fffffc0001cd73f0
>> 0000000000000001
>> [45489.615381]        fffffc00010627f0 0000000000000000  
>> fffffc00dcc9e920
>> fffffc00ff0bf780
>> [45489.712060]        fffffc00010111b8 fffffc00ff0dfda8  
>> fffffc00ff0dfde8
>> fffffc0001cdaa58
>> [45489.808740]        0000000000000000 0000000000000000  
>> fffffc0000000000
>> fffffc0000000000
>> [45489.907373] Trace:
>> [45489.930810] [<fffffc000108ca1c>] watchdog+0x200/0x27c
>> [45489.991357] [<fffffc000106289c>] kthread+0xac/0xc4
>> [45490.048974] [<fffffc000108c81c>] watchdog+0x0/0x27c
>> [45490.107568] [<fffffc00010627f0>] kthread+0x0/0xc4
>> [45490.164209] [<fffffc00010111b8>] kernel_thread+0x28/0x90
>> [45490.227685]
>>
>> Let me know if any other information is needed to narrow down the  
>> problem.
>
> Are there any specific differences between the Titan config and the
> generic Alpha config that might help me work out what is going on?
> Odd -- it looks like the watchdog is complaining at the time of the  
> hang.
> Is it possible to use sysrq to get the state of the other tasks?

Been rather busy or on holiday in the meantime, but just got back to  
looking at this problem.

It looks like it is a faulty compiler, not a problem in the kernel  
source.

The problems described above are seen when compiling with gcc-4.4 and  
we now realise that gcc-4.4 has an optimisation problem on Alpha and  
is the cause of reported problems/crashes in software other than the  
kernel.  These problems are fixed when compiling with gcc-4.5.

I have now compiled a "bad" kernel with gcc-4.5 and I no longer can  
trigger the failure --- the kernel worked for a couple of hours (and a  
bad one compiled with gcc-4.4 has never lasted that long without  
crashing!).

Cheers
Michael.

