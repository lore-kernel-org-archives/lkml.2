Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965338Ab2EQAPj (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 May 2012 20:15:39 -0400
Received: from LGEMRELSE7Q.lge.com ([156.147.1.151]:64183 "EHLO
	LGEMRELSE7Q.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S964789Ab2EQAPQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 May 2012 20:15:16 -0400
X-AuditID: 9c930197-b7be2ae000000ebb-f2-4fb4430a48e0
From: Namhyung Kim <namhyung.kim@lge.com>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Ingo Molnar <mingo@kernel.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Arnaldo Carvalho de Melo <acme@infradead.org>,
        linux-kernel@vger.kernel.org, Arjan van de Ven <arjan@infradead.org>,
        David Ahern <dsahern@gmail.com>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Mike Galbraith <efault@gmx.de>, Paul Mackerras <paulus@samba.org>,
        Stephane Eranian <eranian@google.com>, arnaldo.melo@gmail.com,
        Arnaldo Carvalho de Melo <acme@redhat.com>
Subject: Re: [GIT PULL 0/8] Annotation weekly ponies delivery
References: <1336852387-16322-1-git-send-email-acme@infradead.org>
	<CA+55aFxeqrCj71fSe2r9kwzyO9q2BT9A89f7nLUgbrTG_uPP2g@mail.gmail.com>
	<1336994000.2443.24.camel@twins> <20120514115551.GA6479@gmail.com>
	<1337007985.1552.5.camel@leonhard> <1337077973.27694.24.camel@twins>
	<1337093080.1493.22.camel@leonhard> <1337101633.27694.92.camel@twins>
	<87liksd5wi.fsf@sejong.aot.lge.com>
Date: Thu, 17 May 2012 09:13:18 +0900
In-Reply-To: <87liksd5wi.fsf@sejong.aot.lge.com> (Namhyung Kim's message of
	"Wed, 16 May 2012 14:57:49 +0900")
Message-ID: <87y5or1x7l.fsf@sejong.aot.lge.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.0.95 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On Wed, 16 May 2012 14:57:49 +0900, Namhyung Kim wrote:
> In fact, my perf stat -g was already broken - it cannot count at
> all on my SNB box. I'll investigate it more.
>

It's like a matter of the number of the hw counters. The perf stat -g
uses 6 hw events, but I can use up to 5 hw events on my SNB machine:

$ ./perf stat -g -e cycles,cache-references,cache-misses,instructions,branches sleep 1

 Performance counter stats for 'sleep 1':

           999,008 cycles                    #    0.000 GHz                    
            10,963 cache-references                                            
             2,630 cache-misses              #   23.990 % of all cache refs    
           635,225 instructions              #    0.64  insns per cycle        
           128,014 branches                                                    

       1.001466421 seconds time elapsed


But I adding branch-misses event outputs:

 Performance counter stats for 'sleep 1':

     <not counted> cycles                  
     <not counted> cache-references        
     <not counted> cache-misses            
     <not counted> instructions            
     <not counted> branches                
     <not counted> branch-misses           

       1.000742533 seconds time elapsed


However adding ref-cycles is fine (Is it related to fixed counters?):

 Performance counter stats for 'sleep 1':

         1,027,263 cycles                    #    0.000 GHz                    
            12,435 cache-references                                            
             2,747 cache-misses              #   22.091 % of all cache refs    
           650,100 instructions              #    0.63  insns per cycle        
           130,765 branches                                                    
         2,367,488 ref-cycles                                                  

       1.001557088 seconds time elapsed


BTW, dmesg says I have 7, but a counter was taken by NMI watchdog:

$ dmesg | grep -A32 Performance
[    0.137227] Performance Events: PEBS fmt1+, 16-deep LBR, SandyBridge events, Intel PMU driver.
[    0.137232] ... version:                3
[    0.137233] ... bit width:              48
[    0.137234] ... generic registers:      4
[    0.137235] ... value mask:             0000ffffffffffff
[    0.137236] ... max period:             000000007fffffff
[    0.137237] ... fixed-purpose events:   3
[    0.137238] ... event mask:             000000070000000f
[    0.143371] NMI watchdog: enabled, takes one hw-pmu counter.
[    0.149251] Booting Node   0, Processors  #1
[    0.162396] NMI watchdog: enabled, takes one hw-pmu counter.
[    0.166265]  #2
[    0.179401] NMI watchdog: enabled, takes one hw-pmu counter.
[    0.183263]  #3
[    0.196399] NMI watchdog: enabled, takes one hw-pmu counter.
[    0.200263]  #4
[    0.213398] NMI watchdog: enabled, takes one hw-pmu counter.
[    0.217268]  #5
[    0.230404] NMI watchdog: enabled, takes one hw-pmu counter.
[    0.234263]  #6
[    0.247402] NMI watchdog: enabled, takes one hw-pmu counter.
[    0.251268]  #7
[    0.264405] NMI watchdog: enabled, takes one hw-pmu counter.
[    0.268266]  #8
[    0.281403] NMI watchdog: enabled, takes one hw-pmu counter.
[    0.285268]  #9
[    0.298405] NMI watchdog: enabled, takes one hw-pmu counter.
[    0.302264]  #10
[    0.315401] NMI watchdog: enabled, takes one hw-pmu counter.
[    0.319266]  #11 Ok.
[    0.332404] NMI watchdog: enabled, takes one hw-pmu counter.
[    0.332435] Brought up 12 CPUs
[    0.332437] Total of 12 processors activated (76799.44 BogoMIPS).


Thanks,
Namhyung
