Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932779Ab1DZV2v (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Apr 2011 17:28:51 -0400
Received: from mail-pv0-f174.google.com ([74.125.83.174]:41034 "EHLO
	mail-pv0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932757Ab1DZV2t (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Apr 2011 17:28:49 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:content-type:content-transfer-encoding;
        b=LTOzHncUlJLzbZJV/Wuof55C3z94y/qhDvjSz+YDI1pdKS5jynbUGFHpfWhzmI1ujn
         PM3IGZrx9GXFjRRP/7j8GSvqYqNcUe1OxoQ+bP09/eXhzs5Z041LdgOCOiZVQ36Rn4im
         MAOh8cGMUBUg58HGZ14Mfer4QO8/ZssLddDyY=
Message-ID: <4DB7390D.2080807@gmail.com>
Date: Tue, 26 Apr 2011 15:28:45 -0600
From: David Ahern <dsahern@gmail.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.15) Gecko/20110307 Fedora/3.1.9-0.39.b3pre.fc14 Thunderbird/3.1.9
MIME-Version: 1.0
To: Arnaldo Carvalho de Melo <acme@infradead.org>
CC: Lin Ming <ming.m.lin@intel.com>, Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Ingo Molnar <mingo@elte.hu>, Tim Blechmann <tim@klingt.org>,
        linux-kernel <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH RFC] Fix per-task profiling Re: [PATCH] perf: Allow set
 output buffer for tasks in the same thread group
References: <1303657064.2239.25.camel@localhost> <1303664726.20212.1.camel@twins> <1303738838.2578.1.camel@localhost> <20110425152833.GB32069@ghostprotocols.net> <20110426204401.GB1746@ghostprotocols.net>
In-Reply-To: <20110426204401.GB1746@ghostprotocols.net>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On 04/26/11 14:44, Arnaldo Carvalho de Melo wrote:
> Em Mon, Apr 25, 2011 at 12:28:33PM -0300, Arnaldo Carvalho de Melo escreveu:
>> Em Mon, Apr 25, 2011 at 09:40:38PM +0800, Lin Ming escreveu:
>>> On Mon, 2011-04-25 at 01:05 +0800, Peter Zijlstra wrote:
>>>> On Sun, 2011-04-24 at 22:57 +0800, Lin Ming wrote:
>>>>> Currently, kernel only allows an event to redirect its output to other
>>>>> events of the same task.
> 
>>>>> This causes PERF_EVENT_IOC_SET_OUTPUT ioctl fails when an event is
>>>>> trying to redirect its output to other events in the same thread group.
> 
>>>> Which is exactly what it should do, you should never be allowed to
>>>> redirect your events to that of another task, since that other task
>>>> might be running on another CPU.
> 
>>>> The buffer code strictly assumes no concurrency, therefore its either
>>>> one task or one CPU.
> 
>>> Well, this is not the right fix, then the perf tool code need to be
>>> fixed.
>  
>> Yes, I'm working on it.
> 
> Lin, David, Tim, can you please try the two patches attached?
> 
> Tested with:
> 
> [root@felicio ~]# tuna -t 26131 -CP | nl
>   1                      thread       ctxt_switches
>   2    pid SCHED_ rtpri affinity voluntary nonvoluntary             cmd
>   3 26131   OTHER     0      0,1  10814276      2397830 chromium-browse 
>   4  642    OTHER     0      0,1     14688            0 chromium-browse 
>   5  26148  OTHER     0      0,1    713602       115479 chromium-browse 
>   6  26149  OTHER     0      0,1    801958         2262 chromium-browse 
>   7  26150  OTHER     0      0,1   1271128          248 chromium-browse 
>   8  26151  OTHER     0      0,1         3            0 chromium-browse 
>   9  27049  OTHER     0      0,1     36796            9 chromium-browse 
>  10  618    OTHER     0      0,1     14711            0 chromium-browse 
>  11  661    OTHER     0      0,1     14593            0 chromium-browse 
>  12  29048  OTHER     0      0,1     28125            0 chromium-browse 
>  13  26143  OTHER     0      0,1   2202789          781 chromium-browse 
> [root@felicio ~]#
> 
> So 11 threads under pid 26131, then:
> 
> [root@felicio ~]# perf record -F 50000 --pid 26131 
> 
> [root@felicio ~]# grep perf_event /proc/`pidof perf`/maps | nl
>   1 7fa4a2538000-7fa4a25b9000 rwxs 00000000 00:09 4064 anon_inode:[perf_event]
>   2 7fa4a25b9000-7fa4a263a000 rwxs 00000000 00:09 4064 anon_inode:[perf_event]
>   3 7fa4a263a000-7fa4a26bb000 rwxs 00000000 00:09 4064 anon_inode:[perf_event]
>   4 7fa4a26bb000-7fa4a273c000 rwxs 00000000 00:09 4064 anon_inode:[perf_event]
>   5 7fa4a273c000-7fa4a27bd000 rwxs 00000000 00:09 4064 anon_inode:[perf_event]
>   6 7fa4a27bd000-7fa4a283e000 rwxs 00000000 00:09 4064 anon_inode:[perf_event]
>   7 7fa4a283e000-7fa4a28bf000 rwxs 00000000 00:09 4064 anon_inode:[perf_event]
>   8 7fa4a28bf000-7fa4a2940000 rwxs 00000000 00:09 4064 anon_inode:[perf_event]
>   9 7fa4a2940000-7fa4a29c1000 rwxs 00000000 00:09 4064 anon_inode:[perf_event]
>  10 7fa4a29c1000-7fa4a2a42000 rwxs 00000000 00:09 4064 anon_inode:[perf_event]
>  11 7fa4a2a42000-7fa4a2ac3000 rwxs 00000000 00:09 4064 anon_inode:[perf_event]
> [root@felicio ~]#
> 
> 11 mmaps, one per thread since we didn't specify any CPU list, so we need one
> mmap per thread and:
> 
> [root@felicio ~]# perf record -F 50000 --pid 26131 
> ^M
> ^C[ perf record: Woken up 79 times to write data ]
> [ perf record: Captured and wrote 20.614 MB perf.data (~900639 samples) ]
> 
> [root@felicio ~]# perf report -D | grep PERF_RECORD_SAMPLE | cut -d/ -f2 | cut -d: -f1 | sort -n | uniq -c | sort -nr | nl
>      1	 371310 26131
>      2	  96516 26148
>      3	  95694 26149
>      4	  95203 26150
>      5	   7291 26143
>      6	     87 27049
>      7	     76 661
>      8	     60 29048
>      9	     47 618
>     10	     43 642
> [root@felicio ~]#
> 
> Ok, one of the threads, 26151 was quiescent, so no samples there, but all the
> others are there.
> 
> Then, if I specify one CPU:
> 
> [root@felicio ~]# perf record -F 50000 --pid 26131 --cpu 1
> ^C[ perf record: Woken up 1 times to write data ]
> [ perf record: Captured and wrote 0.680 MB perf.data (~29730 samples) ]
> 
> [root@felicio ~]# perf report -D | grep PERF_RECORD_SAMPLE | cut -d/ -f2 | cut -d: -f1 | sort -n | uniq -c | sort -nr | nl
>      1	   8444 26131
>      2	   2584 26149
>      3	   2518 26148
>      4	   2324 26150
>      5	    123 26143
>      6	      9 661
>      7	      9 29048
> [root@felicio ~]#
> 
> This machine has two cores, so fewer threads appeared on the radar, and:
> 
> [root@felicio ~]# grep perf_event /proc/`pidof perf`/maps | nl
>  1 7f484b922000-7f484b9a3000 rwxs 00000000 00:09 4064 anon_inode:[perf_event]
> [root@felicio ~]# 
> 
> Just one mmap, as now we can use just one per-cpu buffer instead of the
> per-thread needed in the previous case.
> 
> For global profiling:
> 
> [root@felicio ~]# perf record -F 50000 -a
> ^C[ perf record: Woken up 26 times to write data ]
> [ perf record: Captured and wrote 7.128 MB perf.data (~311412 samples) ]
> 
> [root@felicio ~]# grep perf_event /proc/`pidof perf`/maps | nl
>      1	7fb49b435000-7fb49b4b6000 rwxs 00000000 00:09 4064                       anon_inode:[perf_event]
>      2	7fb49b4b6000-7fb49b537000 rwxs 00000000 00:09 4064                       anon_inode:[perf_event]
> [root@felicio ~]#
> 
> It uses per-cpu buffers.
> 
> For just one thread:
> 
> [root@felicio ~]# perf record -F 50000 --tid 26148
> ^C[ perf record: Woken up 2 times to write data ]
> [ perf record: Captured and wrote 0.330 MB perf.data (~14426 samples) ]
> 
> [root@felicio ~]# perf report -D | grep PERF_RECORD_SAMPLE | cut -d/ -f2 | cut -d: -f1 | sort -n | uniq -c | sort -nr | nl
>      1	   9969 26148
> [root@felicio ~]#
> 
> [root@felicio ~]# grep perf_event /proc/`pidof perf`/maps | nl
>      1	7f286a51b000-7f286a59c000 rwxs 00000000 00:09 4064                       anon_inode:[perf_event]
> [root@felicio ~]# 
> 
> Can you guys please test it and provide Tested-by and/or Acked-by?
> 
> Thanks,
> 
> - Arnaldo

Worked for me (KVM process).

Tested-by: David Ahern dsahern@gmail.com
