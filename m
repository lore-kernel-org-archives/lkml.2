Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759315Ab0G3S7q (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Jul 2010 14:59:46 -0400
Received: from smtp-out.google.com ([74.125.121.35]:20220 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933545Ab0G3S7l convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Jul 2010 14:59:41 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=mime-version:in-reply-to:references:from:date:message-id:
	subject:to:cc:content-type:content-transfer-encoding:x-system-of-record;
	b=snTT6QVpHRgajXDF+qn/XxnI78PpOSsi1WlxWYkpkNRcGwbMiauAKjfnZJvcoYfXn
	Fy3vqZQoD4utRkME5vZJA==
MIME-Version: 1.0
In-Reply-To: <1280496739.10435.10.camel@marge.simson.net>
References: <1280467146-32218-1-git-send-email-ncrao@google.com> 
	<1280496739.10435.10.camel@marge.simson.net>
From: Nikhil Rao <ncrao@google.com>
Date: Fri, 30 Jul 2010 11:59:13 -0700
Message-ID: <AANLkTimZyEyNfx-Y=-qunrw7JdkVPGiYHyYmRrOU4qnX@mail.gmail.com>
Subject: Re: [PATCH 0/6] [RFC] Large weight differential leads to inefficient 
	load balancing
To: Mike Galbraith <efault@gmx.de>
Cc: Ingo Molnar <mingo@elte.hu>, Peter Zijlstra <peterz@infradead.org>,
        linux-kernel@vger.kernel.org, Venkatesh Pallipadi <venki@google.com>,
        Ken Chen <kenchen@google.com>, Paul Turner <pjt@google.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jul 30, 2010 at 6:32 AM, Mike Galbraith <efault@gmx.de> wrote:
> On Thu, 2010-07-29 at 22:19 -0700, Nikhil Rao wrote:
>> Hi all,
>>
>> We have observed that a large weight differential between tasks on a runqueue
>> leads to sub-optimal machine utilization and poor load balancing. For example,
>> if you have lots of SCHED_IDLE tasks (sufficient number to keep the machine 100%
>> busy) and a few SCHED_NORMAL soaker tasks, we see that the machine has
>> significant idle time.
>>
>> The data below highlights this problem. The test machine is a 4 socket quad-core
>> box (16 cpus). These experiemnts were done with v2.6.25-rc6. We spawn 16
>> SCHED_IDLE soaker threads (one per-cpu) to completely fill up the machine. CPU
>> utilization numbers gathered from mpstat for 10s are:
>>
>> 03:30:24 PM  CPU   %user   %nice    %sys %iowait    %irq   %soft  %steal   %idle    intr/s
>> 03:30:25 PM  all   99.94    0.00    0.06    0.00    0.00    0.00    0.00    0.00  16234.65
>> 03:30:26 PM  all   99.88    0.06    0.06    0.00    0.00    0.00    0.00    0.00  16374.00
>> 03:30:27 PM  all   99.94    0.00    0.06    0.00    0.00    0.00    0.00    0.00  16392.00
>> 03:30:28 PM  all   99.94    0.00    0.06    0.00    0.00    0.00    0.00    0.00  16612.12
>> 03:30:29 PM  all   99.88    0.00    0.12    0.00    0.00    0.00    0.00    0.00  16375.00
>> 03:30:30 PM  all   99.94    0.06    0.00    0.00    0.00    0.00    0.00    0.00  16440.00
>> 03:30:31 PM  all   99.81    0.00    0.19    0.00    0.00    0.00    0.00    0.00  16237.62
>> 03:30:32 PM  all   99.94    0.00    0.06    0.00    0.00    0.00    0.00    0.00  16360.00
>> 03:30:33 PM  all   99.94    0.00    0.06    0.00    0.00    0.00    0.00    0.00  16405.00
>> 03:30:34 PM  all   99.38    0.06    0.50    0.00    0.00    0.00    0.00    0.06  18881.82
>> Average:     all   99.86    0.02    0.12    0.00    0.00    0.00    0.00    0.01  16628.20
>>
>> We then spawn one SCHED_NORMAL while-1 task (the absolute number does not matter
>> so long as we introduce some large weight differential).
>>
>> 03:40:57 PM  CPU   %user   %nice    %sys %iowait    %irq   %soft  %steal   %idle    intr/s
>> 03:40:58 PM  all   83.06    0.00    0.06    0.00    0.00    0.00    0.00   16.88  14555.00
>> 03:40:59 PM  all   78.25    0.00    0.06    0.00    0.00    0.00    0.00   21.69  14527.00
>> 03:41:00 PM  all   82.71    0.06    0.06    0.00    0.00    0.00    0.00   17.17  14879.00
>> 03:41:01 PM  all   87.34    0.00    0.06    0.00    0.00    0.00    0.00   12.59  15466.00
>> 03:41:02 PM  all   80.80    0.06    0.19    0.00    0.00    0.00    0.00   18.95  14584.00
>> 03:41:03 PM  all   82.90    0.00    0.06    0.00    0.00    0.00    0.00   17.04  14570.00
>> 03:41:04 PM  all   79.45    0.00    0.06    0.00    0.00    0.00    0.00   20.49  14536.00
>> 03:41:05 PM  all   86.48    0.00    0.07    0.00    0.00    0.00    0.00   13.46  14577.00
>> 03:41:06 PM  all   76.73    0.06    0.06    0.00    0.00    0.06    0.00   23.10  14594.00
>> 03:41:07 PM  all   86.48    0.00    0.07    0.00    0.00    0.00    0.00   13.45  14703.03
>> Average:     all   82.31    0.02    0.08    0.00    0.00    0.01    0.00   17.59  14699.10
>
> What happens with s/SCHED_IDLE/nice 19?
>
>        -Mike

We see the same result with nice 19 as well.

w/ 16 nice-19 soakers:

10:15:16 AM  CPU   %user   %nice    %sys %iowait    %irq   %soft
%steal   %idle    intr/s
10:15:17 AM  all    0.06   99.94    0.00    0.00    0.00    0.00
0.00    0.00  16296.04
10:15:18 AM  all    0.00   99.94    0.06    0.00    0.00    0.00
0.00    0.00  16379.00
10:15:19 AM  all    0.00   99.94    0.06    0.00    0.00    0.00
0.00    0.00  16414.00
10:15:20 AM  all    0.00   99.94    0.06    0.00    0.00    0.00
0.00    0.00  16413.00
10:15:21 AM  all    0.00  100.00    0.00    0.00    0.00    0.00
0.00    0.00  16402.00
10:15:22 AM  all    0.00   99.88    0.06    0.00    0.00    0.06
0.00    0.00  16419.00
10:15:23 AM  all    0.00   99.94    0.06    0.00    0.00    0.00
0.00    0.00  16406.00
10:15:24 AM  all    0.19   99.69    0.12    0.00    0.00    0.00
0.00    0.00  16613.13
10:15:25 AM  all    0.38   99.31    0.31    0.00    0.00    0.00
0.00    0.00  16313.86
10:15:26 AM  all    0.50   99.31    0.19    0.00    0.00    0.00
0.00    0.00  16623.23
Average:     all    0.11   99.79    0.09    0.00    0.00    0.01
0.00    0.00  16427.30

w/ adding a SCHED_NORMAL soaker to the mix:

10:17:44 AM  CPU   %user   %nice    %sys %iowait    %irq   %soft
%steal   %idle    intr/s
10:17:45 AM  all    6.20   74.38    0.06    0.00    0.00    0.00
0.00   19.35  14419.80
10:17:46 AM  all    6.25   74.89    0.06    0.00    0.00    0.00
0.00   18.80  14619.00
10:17:47 AM  all    6.30   74.84    0.06    0.00    0.00    0.00
0.00   18.79  14590.00
10:17:48 AM  all    6.25   80.57    0.06    0.00    0.00    0.00
0.00   13.12  15511.00
10:17:49 AM  all    6.51   80.33    0.07    0.00    0.00    0.00
0.00   13.09  14904.00
10:17:50 AM  all    6.06   72.62    0.06    0.00    0.00    0.00
0.00   21.26  14564.00
10:17:51 AM  all    6.21   74.47    0.06    0.00    0.00    0.00
0.00   19.25  14584.00
10:17:52 AM  all    6.47   77.67    0.12    0.00    0.00    0.00
0.00   15.73  15295.96
10:17:53 AM  all    6.27   79.39    0.06    0.00    0.00    0.00
0.00   14.29  15251.00
10:17:54 AM  all    6.32   75.85    0.00    0.00    0.00    0.00
0.00   17.83  14537.00
Average:     all    6.28   76.47    0.06    0.00    0.00    0.00
0.00   17.18  14826.70

The problem is the large weight differential between nice
19/SCHED_IDLE and SCHED_NORMAL. I ran a quick experiment with the
soaker tasks at different nice levels. Data is in the table below.
First column is nice level, second is idle% on the machine (mpstat 10s
average) and third is ratio of nice weight/1024.

0          0.00          1
1          0.00          0.800781
2          0.00          0.639648
3          0.00          0.513672
4          0.00          0.413086
5          0.17          0.327148
6          1.06          0.265625
7          7.62          0.209961
8          4.47          0.167969
9          11.78          0.133789
10          13.52          0.107422
11          14.92          0.0849609
12          14.33          0.0683594
13          17.47          0.0546875
14          15.89          0.0439453
15          18.69          0.0351562
16          16.63          0.0283203
17          17.04          0.0224609
18          17.86          0.0175781
19          18.13          0.0146484

It looks like we start seeing seeing sub-optimal performance when the
weight ratio is >0.3.

-Thanks,
Nikhil
