Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752266Ab0LFKKz (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Dec 2010 05:10:55 -0500
Received: from mailx.hitachi.co.jp ([133.145.228.49]:35799 "EHLO
	mailx.hitachi.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751784Ab0LFKKw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Dec 2010 05:10:52 -0500
X-AuditID: b753bd60-a58fdba000000f8d-d5-4cfcb6261527
Message-ID: <4CFCB618.8080004@hitachi.com>
Date: Mon, 06 Dec 2010 19:08:24 +0900
From: Akihiro Nagai <akihiro.nagai.hw@hitachi.com>
User-Agent: Mozilla/5.0 (Windows; U; Windows NT 5.1; ja; rv:1.9.2.12) Gecko/20101027 Thunderbird/3.1.6
MIME-Version: 1.0
To: Peter Zijlstra <peterz@infradead.org>
Cc: linux-kernel@vger.kernel.org,
        Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>,
        Paul Mackerras <paulus@samba.org>, Ingo Molnar <mingo@elte.hu>,
        Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
Subject: Re: [PATCH -tip  6/7] perf bts trace: print function+offset
References: <20101203035832.7827.16528.stgit@localhost6.localdomain6>	 <20101203040015.7827.38870.stgit@localhost6.localdomain6> <1291381258.32004.2083.camel@laptop>
In-Reply-To: <1291381258.32004.2083.camel@laptop>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Brightmail-Tracker: AAAAAA==
X-FMFTCR: RANGEC
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

(2010/12/03 22:00), Peter Zijlstra wrote:
> On Fri, 2010-12-03 at 13:00 +0900, Akihiro Nagai wrote:
>> Provide the function to print function+offset.
>> And, set it as the default behavior of 'perf bts trace'.
>> To use this function, users can also specify the option '-s' or '--symbol'.
>>
>> Example: 'perf bts -as trace'
>> This command prints address and function+offset.
>>
>> Output sample:
>> address            function+offset
>> 0xffffffff8146fe0e irq_return+0x0         =>  0x00007fd4038e3b20 _start+0x0
>> ...
>> 0x000000380661ee79 __libc_start_main+0xf9 =>  0x00000000004035c3 main+0x0
>> 0xffffffff8146ef4e irq_return+0x0         =>  0x00000000004035c3 main+0x0
>> 0x00000000004035e8 main+0x25              =>  0x000000000040bca0 set_program_name+0x0
>> 0xffffffff8146ef4e irq_return+0x0         =>  0x000000000040bca0 set_program_name+0x0
>> 0x000000000040bcae set_program_name+0xe   =>  0x00000000004023d0 strrchr@plt+0x0
>> 0x00000000004023d0 strrchr@plt+0x0        =>  0x00000000004023d6 strrchr@plt+0x6
>> ...
>> 0x0000000000403e0c main+0x849             =>  0x00000000004021f0 exit@plt+0x0
>> 0x00000000004021f0 exit@plt+0x0           =>  0x00000000004021f6 exit@plt+0x6
>> 0x00000000004021fb exit@plt+0xb           =>  0x00000000004020d0 _init+0x18
>> 0x00000000004020d6 _init+0x1e             =>  0x00000038062149d0 _dl_runtime_resolve+0x0
>
>
> What would be very nice output is something like a source-code browser
> (tig might have something worth borrowing) and annotating the output
> using the bts output.
>
> You could for example darken the code that didn't get any coverage, and
> print a percentage for each conditional statement.
>
> That way you can easily see how your code is traversed.
We have developed the coverage test tool and execution path analyzer using BTS
called "Btrax". It can show the executed/unexecuted source codes with color.
Please refer this slide about details of Btrax.
   http://lca2009.linux.org.au/slides/52.pdf

The purpose of 'perf bts' is to implement similar functions to Btrax.

And also, I'll try to reduce memory copies from kernel space to user,
because perf copies 3 times. But btrax does just one copy.
Please see the following benchmark results.

Test program: compile with -O0 option this source code
int main(void)
{
     int i;
     while(i++ < 100000000);
     return 0;
}

Execution Results:
Native:
# time ./a.out

real    0m0.349s
user    0m0.346s
sys     0m0.002s

Btrax:
(enabling BTS_OFF_OS flag for this benchmark)
(kernel 2.6.30 on RHEL 5.4)
# bt_collect_log -d log -c ./a.out
real    1m19.950s
user    0m14.783s
sys     0m40.655s

(trace data size: 1,537,307,064 bytes)

perf:
# time perf bts record ./a.out
Processed 0 events and LOST 5002!

Check IO/CPU overload!

  #  perf record: Captured and wrote 2704.231 MB perf.data (~118149662 samples)

real    2m1.885s
user    0m7.184s
sys     0m19.194s


Bench Mark Enviroment:
Native and perf: latest -tip kernel on Fedora14
Btrax: vanilla 2.6.30 on RHEL5.4

Core2Duo E6550  @2.33GHz
Mem DDR2 4GB


best regards,
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
>

