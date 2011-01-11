Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932391Ab1AKQ1y (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Jan 2011 11:27:54 -0500
Received: from ns.dcl.info.waseda.ac.jp ([133.9.216.194]:65001 "EHLO
	ns.dcl.info.waseda.ac.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932267Ab1AKQ1v (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Jan 2011 11:27:51 -0500
Message-ID: <4D2C8503.9050006@dcl.info.waseda.ac.jp>
Date: Wed, 12 Jan 2011 01:27:47 +0900
From: Hitoshi Mitake <mitake@dcl.info.waseda.ac.jp>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:2.0b8pre) Gecko/20101116 Thunderbird/3.3a1
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>
CC: linux-kernel@vger.kernel.org, h.mitake@gmail.com,
        Ma Ling <ling.ma@intel.com>, Zhao Yakui <yakui.zhao@intel.com>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Arnaldo Carvalho de Melo <acme@redhat.com>,
        Paul Mackerras <paulus@samba.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Steven Rostedt <rostedt@goodmis.org>,
        Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>
Subject: Re: [PATCH 2/2] perf bench: add x86-64 specific benchmarks to perf
 bench mem memcpy
References: <1288368098-26121-1-git-send-email-mitake@dcl.info.waseda.ac.jp> <1288368098-26121-2-git-send-email-mitake@dcl.info.waseda.ac.jp> <20101030192357.GC26503@elte.hu> <4CCE51E6.7060908@dcl.info.waseda.ac.jp> <20101101090251.GA28039@elte.hu>
In-Reply-To: <20101101090251.GA28039@elte.hu>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2010年11月01日 18:02, Ingo Molnar wrote:
>
> * Hitoshi Mitake<mitake@dcl.info.waseda.ac.jp>  wrote:
>
>> On 2010年10月31日 04:23, Ingo Molnar wrote:
>>>
>>> * Hitoshi Mitake<mitake@dcl.info.waseda.ac.jp>   wrote:
>>>
>>>> This patch adds new file: mem-memcpy-x86-64-asm.S
>>>> for x86-64 specific memcpy() benchmarking.
>>>> Added new benchmarks are,
>>>>   x86-64-rep:      memcpy() implemented with rep instruction
>>>>   x86-64-unrolled: unrolled memcpy()
>>>>
>>>> Original idea of including the source files of kernel
>>>> for benchmarking is suggested by Ingo Molnar.
>>>> This is more effective than write-once programs for quantitative
>>>> evaluation of in-kernel, little and leaf functions called high frequently.
>>>> Because perf bench is in kernel source tree and executing it
>>>> on various hardwares, especially new model CPUs, is easy.
>>>>
>>>> This way can also be used for other functions of kernel e.g. checksum functions.
>>>>
>>>> Example of usage on Core i3 M330:
>>>>
>>>> | % ./perf bench mem memcpy -l 500MB
>>>> | # Running mem/memcpy benchmark...
>>>> | # Copying 500MB Bytes from 0x7f911f94c010 to 0x7f913ed4d010 ...
>>>> |
>>>> |      578.732506 MB/Sec
>>>> | % ./perf bench mem memcpy -l 500MB -r x86-64-rep
>>>> | # Running mem/memcpy benchmark...
>>>> | # Copying 500MB Bytes from 0x7fb4b6fe4010 to 0x7fb4d63e5010 ...
>>>> |
>>>> |      738.184980 MB/Sec
>>>> | % ./perf bench mem memcpy -l 500MB -r x86-64-unrolled
>>>> | # Running mem/memcpy benchmark...
>>>> | # Copying 500MB Bytes from 0x7f6f2e668010 to 0x7f6f4da69010 ...
>>>> |
>>>> |      767.483269 MB/Sec
>>>>
>>>> This shows clearly that unrolled memcpy() is efficient
>>>> than rep version and glibc's one :)
>>>
>>> Hey, really cool output :-)
>>>
>>> Might also make sense to measure Ma Ling's patched version?
>>
>> Does Ma Ling's patched version mean,
>>
>> http://marc.info/?l=linux-kernel&m=128652296500989&w=2
>>
>> the memcpy applied the patch of the URL?
>> (It seems that this patch was written by Miao Xie.)
>>
>> I'll include the result of patched version in the next post.
>
> (Indeed it is Miao Xie - sorry!)
>
>>>> # checkpatch.pl warns about two externs in bench/mem-memcpy.c
>>>> # added by this patch. But I think it is no problem.
>>>
>>> You should put these:
>>>
>>>   +#ifdef ARCH_X86_64
>>>   +extern void *memcpy_x86_64_unrolled(void *to, const void *from, size_t len);
>>>   +extern void *memcpy_x86_64_rep(void *to, const void *from, size_t len);
>>>   +#endif
>>>
>>> into a .h file - a new one if needed.
>>>
>>> That will make both checkpatch and me happier ;-)
>>>
>>
>> OK, I'll separate these files.
>>
>> BTW, I found really interesting evaluation result.
>> Current results of "perf bench mem memcpy" include
>> the overhead of page faults because the measured memcpy()
>> is the first access to allocated memory area.
>>
>> I tested the another version of perf bench mem memcpy,
>> which does memcpy() before measured memcpy() for removing
>> the overhead come from page faults.
>>
>> And this is the result:
>>
>> % ./perf bench mem memcpy -l 500MB -r x86-64-unrolled
>> # Running mem/memcpy benchmark...
>> # Copying 500MB Bytes from 0x7f19d488f010 to 0x7f19f3c90010 ...
>>
>>         4.608340 GB/Sec
>>
>> % ./perf bench mem memcpy -l 500MB
>> # Running mem/memcpy benchmark...
>> # Copying 500MB Bytes from 0x7f696c3cc010 to 0x7f698b7cd010 ...
>>
>>         4.856442 GB/Sec
>>
>> % ./perf bench mem memcpy -l 500MB -r x86-64-rep
>> # Running mem/memcpy benchmark...
>> # Copying 500MB Bytes from 0x7f45d6cff010 to 0x7f45f6100010 ...
>>
>>         6.024445 GB/Sec
>>
>> The relation of scores reversed!
>> I cannot explain the cause of this result, and
>> this is really interesting phenomenon.
>
> Interesting indeed, and it would be nice to analyse that! (It should be possible,
> using various PMU metrics in a clever way, to figure out what's happening inside the
> CPU, right?)
>

I corrected the PMU information of the each case of memcpy,
below is the result:

(I used partial monitoring patch I posted before: 
https://patchwork.kernel.org/patch/408801/,
and my local modification for testing rep based memcpy)

                  no prefault benchmarking

unrolled

Score:      685.812729 MB/Sec
Stat:
  Performance counter stats for process id '4139':

         725.939831 task-clock-msecs         #      0.995 CPUs
                 74 context-switches         #      0.000 M/sec
                  2 CPU-migrations           #      0.000 M/sec
            256,002 page-faults              #      0.353 M/sec
      1,535,468,702 cycles                   #   2115.146 M/sec
      1,691,516,817 instructions             #      1.102 IPC
        291,260,006 branches                 #    401.218 M/sec
          1,487,762 branch-misses            #      0.511 %
          8,470,560 cache-references         #     11.668 M/sec
          8,364,176 cache-misses             #     11.522 M/sec

         0.729488573  seconds time elapsed

rep based

Score:     670.172114 MB/Sec
Stat:
  Performance counter stats for process id '5539':

         742.943772 task-clock-msecs         #      0.995 CPUs
                 77 context-switches         #      0.000 M/sec
                  2 CPU-migrations           #      0.000 M/sec
            256,002 page-faults              #      0.345 M/sec
      1,578,787,149 cycles                   #   2125.043 M/sec
      1,499,144,628 instructions             #      0.950 IPC
        275,684,806 branches                 #    371.071 M/sec
          1,522,326 branch-misses            #      0.552 %
          8,503,747 cache-references         #     11.446 M/sec
          8,386,673 cache-misses             #     11.288 M/sec

         0.746320411  seconds time elapsed

                  prefaulted benchmarking

unrolled

Score:       4.485941 GB/Sec
Stat:
  Performance counter stats for process id '4279':

         108.466761 task-clock-msecs         #      0.994 CPUs
                 11 context-switches         #      0.000 M/sec
                  2 CPU-migrations           #      0.000 M/sec
                  2 page-faults              #      0.000 M/sec
        218,260,432 cycles                   #   2012.233 M/sec
        199,520,023 instructions             #      0.914 IPC
         16,963,327 branches                 #    156.392 M/sec
              8,169 branch-misses            #      0.048 %
          2,955,221 cache-references         #     27.245 M/sec
          2,916,018 cache-misses             #     26.884 M/sec

         0.109115820  seconds time elapsed

rep based

Score:       5.972859 GB/Sec
Stat:
  Performance counter stats for process id '5535':

          81.609445 task-clock-msecs         #      0.995 CPUs
                  8 context-switches         #      0.000 M/sec
                  0 CPU-migrations           #      0.000 M/sec
                  2 page-faults              #      0.000 M/sec
        173,888,853 cycles                   #   2130.744 M/sec
          3,034,096 instructions             #      0.017 IPC
            607,897 branches                 #      7.449 M/sec
              5,874 branch-misses            #      0.966 %
          8,276,533 cache-references         #    101.416 M/sec
          8,274,865 cache-misses             #    101.396 M/sec

         0.082030877  seconds time

Again, the surprising point is the reverse of the score relation.
I cannot find the direct reason of this reverse,
but it seems that the count of branch-miss is refrecting it.

I have to look into this more deeply...
