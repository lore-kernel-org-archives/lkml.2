Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757182Ab1FQF6s (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Jun 2011 01:58:48 -0400
Received: from mail-iw0-f174.google.com ([209.85.214.174]:37538 "EHLO
	mail-iw0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751585Ab1FQF6p (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Jun 2011 01:58:45 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:subject:references
         :in-reply-to:content-type:content-transfer-encoding;
        b=D89Rcxm2cMhQb6CtlvlkthLq/ZGU2bmvoLdpoX6/Y/DVm7N2W6Rpql1V4RxaI01nNT
         0KuR0kQ5N5XDG7Lypi+zf0ZqId+HKayPYLMFQyp5ZO4T5V0UInl6LfYmryEwQWsRArlY
         GiS9Y/PW2bJ8wQMV8xzrWJy9NNgq5YvPHpQTU=
Message-ID: <4DFAED11.6060701@gmail.com>
Date: Thu, 16 Jun 2011 23:58:41 -0600
From: David Ahern <dsahern@gmail.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.17) Gecko/20110428 Fedora/3.1.10-1.fc15 Thunderbird/3.1.10
MIME-Version: 1.0
To: "Ted Ts'o" <tytso@mit.edu>, Frederic Weisbecker <fweisbec@gmail.com>,
        =?ISO-8859-1?Q?P=E1draig_Brady?= <P@draigBrady.com>,
        linux-kernel@vger.kernel.org
Subject: Re: scheduler / perf stat question about CPU-migrations
References: <E1QXDpy-0007Wr-5V@tytso-glaptop> <20110616150347.GB23624@somewhere.redhat.com> <4DFA1D07.1050705@draigBrady.com> <20110616151836.GC23624@somewhere.redhat.com> <20110617024425.GE29725@thunk.org>
In-Reply-To: <20110617024425.GE29725@thunk.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On 06/16/2011 08:44 PM, Ted Ts'o wrote:
> On Thu, Jun 16, 2011 at 05:18:39PM +0200, Frederic Weisbecker wrote:
>> The only solution is too set perf affinity itself:
>>
>> 	schedtool -a 1 -e perf stat -- e2fsck -ft /dev/funarg/kbuild

I don't have schedtool, but I was able to repeat it with taskset:

taskset -pc 2 $$
perf stat -- e2fsck -ft <device>

where <device> is a 400G ext4 partition. First time through perf-stat
showed a number of migrations over the 134 second window. e2fsck runs
much quicker after the initial one, and migrations aren't showing up as
easily.

Try this:

perf record -Tg -e migrations -fo /tmp/perf.data -- schedtool -a 1 -e
perf stat -- e2fsck -ft /dev/funarg/kbuild

The outer perf-record will capture when the migrations occur.  If you
don't mind recompiling perf, modify tools/perf/builtin-record.c and
force the capture of the cpu id on the samples. In config_attr() you want:

attr->sample_type       |= PERF_SAMPLE_CPU;

On the captured data file run:
perf script -i /tmp/perf.data

You'll see something like this (captured on a run where I was able to
get 2 migrations):
          e2fsck  2069 [002]   210.671401: CPU-migrations:
ffffffff81045a7b set_task_cpu ([kern
          e2fsck  2069 [002]   213.675785: CPU-migrations:
ffffffff81045a7b set_task_cpu ([kern

David


> 
> Nope, that doesn't solve the problem:
> 
> # schedtool -a 1 -e perf stat -- e2fsck -ft /dev/funarg/kbuild
> e2fsck 1.41.14 (22-Dec-2010)
> Pass 1: Checking inodes, blocks, and sizes
> Pass 2: Checking directory structure
> Pass 3: Checking directory connectivity
> Pass 4: Checking reference counts
> Pass 5: Checking group summary information
> /dev/funarg/kbuild: 223466/1638400 files (0.3% non-contiguous), 4915668/6553600 blocks
> Memory used: 2600k/0k (1069k/1532k), time:  6.72/ 1.18/ 0.36
> I/O read: 137MB, write: 1MB, rate: 20.38MB/s
> 
>  Performance counter stats for 'e2fsck -ft /dev/funarg/kbuild':
> 
>        1523.616797 task-clock                #    0.224 CPUs utilized          
>               7227 context-switches          #    0.005 M/sec                  
>                253 CPU-migrations            #    0.000 M/sec                  
>               1936 page-faults               #    0.001 M/sec                  
>         4176409631 cycles                    #    2.741 GHz                    
>      <not counted> stalled-cycles-frontend 
>      <not counted> stalled-cycles-backend  
>         4828485353 instructions              #    1.16  insns per cycle        
>          877742160 branches                  #  576.091 M/sec                  
>            8017490 branch-misses             #    0.91% of all branches        
> 
>        6.798746204 seconds time elapsed
> 
> Note the 253 CPU migration....
> 
> 							- Ted
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
