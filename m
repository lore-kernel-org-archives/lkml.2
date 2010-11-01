Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752815Ab0KAFgo (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Nov 2010 01:36:44 -0400
Received: from ns.dcl.info.waseda.ac.jp ([133.9.216.194]:55318 "EHLO
	ns.dcl.info.waseda.ac.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752496Ab0KAFgl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Nov 2010 01:36:41 -0400
Message-ID: <4CCE51E6.7060908@dcl.info.waseda.ac.jp>
Date: Mon, 01 Nov 2010 14:36:38 +0900
From: Hitoshi Mitake <mitake@dcl.info.waseda.ac.jp>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.7) Gecko/20100724 Lanikai/3.1.1
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
References: <1288368098-26121-1-git-send-email-mitake@dcl.info.waseda.ac.jp> <1288368098-26121-2-git-send-email-mitake@dcl.info.waseda.ac.jp> <20101030192357.GC26503@elte.hu>
In-Reply-To: <20101030192357.GC26503@elte.hu>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2010年10月31日 04:23, Ingo Molnar wrote:
>
> * Hitoshi Mitake<mitake@dcl.info.waseda.ac.jp>  wrote:
>
>> This patch adds new file: mem-memcpy-x86-64-asm.S
>> for x86-64 specific memcpy() benchmarking.
>> Added new benchmarks are,
>>   x86-64-rep:      memcpy() implemented with rep instruction
>>   x86-64-unrolled: unrolled memcpy()
>>
>> Original idea of including the source files of kernel
>> for benchmarking is suggested by Ingo Molnar.
>> This is more effective than write-once programs for quantitative
>> evaluation of in-kernel, little and leaf functions called high frequently.
>> Because perf bench is in kernel source tree and executing it
>> on various hardwares, especially new model CPUs, is easy.
>>
>> This way can also be used for other functions of kernel e.g. checksum functions.
>>
>> Example of usage on Core i3 M330:
>>
>> | % ./perf bench mem memcpy -l 500MB
>> | # Running mem/memcpy benchmark...
>> | # Copying 500MB Bytes from 0x7f911f94c010 to 0x7f913ed4d010 ...
>> |
>> |      578.732506 MB/Sec
>> | % ./perf bench mem memcpy -l 500MB -r x86-64-rep
>> | # Running mem/memcpy benchmark...
>> | # Copying 500MB Bytes from 0x7fb4b6fe4010 to 0x7fb4d63e5010 ...
>> |
>> |      738.184980 MB/Sec
>> | % ./perf bench mem memcpy -l 500MB -r x86-64-unrolled
>> | # Running mem/memcpy benchmark...
>> | # Copying 500MB Bytes from 0x7f6f2e668010 to 0x7f6f4da69010 ...
>> |
>> |      767.483269 MB/Sec
>>
>> This shows clearly that unrolled memcpy() is efficient
>> than rep version and glibc's one :)
>
> Hey, really cool output :-)
>
> Might also make sense to measure Ma Ling's patched version?

Does Ma Ling's patched version mean,

http://marc.info/?l=linux-kernel&m=128652296500989&w=2

the memcpy applied the patch of the URL?
(It seems that this patch was written by Miao Xie.)

I'll include the result of patched version in the next post.

>
>> # checkpatch.pl warns about two externs in bench/mem-memcpy.c
>> # added by this patch. But I think it is no problem.
>
> You should put these:
>
>   +#ifdef ARCH_X86_64
>   +extern void *memcpy_x86_64_unrolled(void *to, const void *from, size_t len);
>   +extern void *memcpy_x86_64_rep(void *to, const void *from, size_t len);
>   +#endif
>
> into a .h file - a new one if needed.
>
> That will make both checkpatch and me happier ;-)
>

OK, I'll separate these files.

BTW, I found really interesting evaluation result.
Current results of "perf bench mem memcpy" include
the overhead of page faults because the measured memcpy()
is the first access to allocated memory area.

I tested the another version of perf bench mem memcpy,
which does memcpy() before measured memcpy() for removing
the overhead come from page faults.

And this is the result:

% ./perf bench mem memcpy -l 500MB -r x86-64-unrolled
# Running mem/memcpy benchmark...
# Copying 500MB Bytes from 0x7f19d488f010 to 0x7f19f3c90010 ...

        4.608340 GB/Sec

% ./perf bench mem memcpy -l 500MB
# Running mem/memcpy benchmark...
# Copying 500MB Bytes from 0x7f696c3cc010 to 0x7f698b7cd010 ...

        4.856442 GB/Sec

% ./perf bench mem memcpy -l 500MB -r x86-64-rep
# Running mem/memcpy benchmark...
# Copying 500MB Bytes from 0x7f45d6cff010 to 0x7f45f6100010 ...

        6.024445 GB/Sec

The relation of scores reversed!
I cannot explain the cause of this result, and
this is really interesting phenomenon.

So I'd like to add new command line option,
like "--pre-page-faults" to perf bench mem memcpy,
for doing memcpy() before measured memcpy().

How do you think about this idea?

Thanks,
