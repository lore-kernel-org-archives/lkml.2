Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757926Ab2F0U3O (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Jun 2012 16:29:14 -0400
Received: from e28smtp07.in.ibm.com ([122.248.162.7]:58528 "EHLO
	e28smtp07.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754651Ab2F0U3J (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Jun 2012 16:29:09 -0400
Message-ID: <4FEB6CAC.1020406@linux.vnet.ibm.com>
Date: Thu, 28 Jun 2012 01:57:24 +0530
From: Raghavendra K T <raghavendra.kt@linux.vnet.ibm.com>
Organization: IBM
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:10.0.1) Gecko/20120216 Thunderbird/10.0.1
MIME-Version: 1.0
To: Andrew Jones <drjones@redhat.com>, Avi Kivity <avi@redhat.com>,
        Ingo Molnar <mingo@redhat.com>
CC: Rik van Riel <riel@redhat.com>, Marcelo Tosatti <mtosatti@redhat.com>,
        Srikar <srikar@linux.vnet.ibm.com>,
        Srivatsa Vaddagiri <vatsa@linux.vnet.ibm.com>,
        Peter Zijlstra <peterz@infradead.org>,
        "Nikunj A. Dadhania" <nikunj@linux.vnet.ibm.com>,
        KVM <kvm@vger.kernel.org>, LKML <linux-kernel@vger.kernel.org>,
        Gleb Natapov <gleb@redhat.com>, chegu_vinod@hp.com,
        Jeremy Fitzhardinge <jeremy@goop.org>
Subject: Re: [PATCH] kvm: handle last_boosted_vcpu = 0 case
References: <20120619202047.26191.40429.sendpatchset@codeblue> <20120619165104.2a4574f8@annuminas.surriel.com> <4FE22E9E.7070206@linux.vnet.ibm.com> <4FE304D0.5000202@linux.vnet.ibm.com> <20120622151149.GA9077@turtle.usersys.redhat.com> <4FE4DCEA.1050701@linux.vnet.ibm.com> <4FE60C41.5020907@linux.vnet.ibm.com>
In-Reply-To: <4FE60C41.5020907@linux.vnet.ibm.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
x-cbid: 12062720-8878-0000-0000-0000030D1D37
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/24/2012 12:04 AM, Raghavendra K T wrote:
> On 06/23/2012 02:30 AM, Raghavendra K T wrote:
>> On 06/22/2012 08:41 PM, Andrew Jones wrote:
[...]
> My run for other benchmarks did not have Rik's patches, so re-spinning
> everything with that now.
>
> Here is the detailed info on env and benchmark I am currently trying.
> Let me know if you have any comments
>
> =======
> kernel 3.5.0-rc1 with Rik's Ple handler fix as base
>
> Machine : Intel(R) Xeon(R) CPU X7560 @ 2.27GHz, 4 numa node, 256GB RAM,
> 32 core machine
>
> Host: enterprise linux gcc version 4.4.6 20120305 (Red Hat 4.4.6-4)
> (GCC) with test kernels
> Guest: fedora 16 with different built-in kernel from same source tree.
> 32 vcpus 8GB memory. (configs not changed with patches except for
> CONFIG_PARAVIRT_SPINLOCK)
>
> Note: for Pv patches, SPIN_THRESHOLD is set to 4k
>
> Benchmarks:
> 1) kernbench: kernbench-0.50
>
> cmd:
> echo "3" > /proc/sys/vm/drop_caches
> ccache -C
> kernbench -f -H -M -o 2*vcpu
>
> Very first run in kernbench is omitted.
>
> 2) dbench: dbench version 4.00
> cmd: dbench --warmup=30 -t 120 2*vcpu
>
> 3) hackbench:
>https://build.opensuse.org/package/files?package=hackbench&project=benchmark
>
> hackbench.c modified with loops=10000
> used hackbench with num-threads = 2* vcpu
>
> 4) Specjbb: specjbb2000-1.02
> Input Properties:
> ramp_up_seconds = 30
> measurement_seconds = 120
> forcegc = true
> starting_number_warehouses = 1
> increment_number_warehouses = 1
> ending_number_warehouses = 8
>
>
> 5) sysbench: 0.4.12
> sysbench --test=oltp --db-driver=pgsql prepare
> sysbench --num-threads=2*vcpu --max-requests=100000 --test=oltp
> --oltp-table-size=500000 --db-driver=pgsql --oltp-read-only run
> Note that driver for this pgsql.
>
>
> 6) ebizzy: release 0.3
> cmd: ebizzy -S 120
>
> - specjbb ran for 1x and 2x others mostly for 1x, 2x, 3x overcommit.
> - overcommit of 2x means same benchmark running on 2 guests.
> - sample for each overcommit is mostly 8
>
> Note: I ran kernbench with old kernbench0.50, may be I can try kcbench
> with ramfs if necessary
>
> will soon come with detailed results

With the above env, Here is the result I have for 4k SPIN_THRESHOLD.

Lower is better for following benchmarks:
kernbench: (time in sec)
hackbench: (time in sec)
sysbench : (time in sec)

Higher is better for following benchmarks:
specjbb: score (Throughput)
dbench : Throughput in MB/sec
ebizzy : records/sec

In summary, current PV has huge benefit on non-PLE machine.

On PLE machine, the results become very sensitive to load, type of
workload and SPIN_THRESHOLD. Also PLE interference has significant
effect on them. But still it has slight edge over non PV.

Overall, specjbb, sysbench, kernbench seem to do well with PV.

dbench has been little unreliable (same reason I have not published
2x, 3x result but experimental values are included in tarball) but
seem to be on par with PV

hackbench non-overcommit case is better and ebizzy overcommit case is 
better.
[ebizzy seems to very sensitive w.r.t SPIN_THRESHOLD].

I have still not experimented with SPIN_THRESHOLD of 2k/8k and w/, w/o PLE
after having Rik's fix.

+-----------+-----------+-----------+------------+---------+
                               specjbb
+-----------+-----------+-----------+------------+---------+
|   value   |   stdev   |   value   |    stdev   | %improve|
+-----------+-----------+-----------+------------+---------+
|114232.2500|21774.0660	|122591.0000| 18239.0900 | 7.31733 |
|112154.5000|19696.6860	|113386.2500| 22262.5890 | 1.09826 |
+-----------+-----------+-----------+------------+---------+

+-----------+-----------+-----------+------------+---------+
                               kernbench
+-----------+-----------+-----------+------------+---------+
|   value   |   stdev   |   value   |    stdev   | %improve|
+-----------+-----------+-----------+------------+---------+
|   48.9150 |   0.8608  |   48.5550 |   0.7372   | 0.74143 |
|   96.3691 |   7.9724  |   96.6367 |   1.6938   |-0.27691 |
|  192.6972 |   9.1881  |  188.3195 |   8.1267   | 2.32461 |
|  320.6500 |  29.6892  |  302.1225 |  16.0515   | 6.13245 |
++-----------+-----------+-----------+------------+---------+

+-----------+-----------+-----------+------------+---------+
                               sysbench
+-----------+-----------+-----------+------------+---------+
|   value   |   stdev   |   value   |    stdev   | %improve|
+-----------+-----------+-----------+------------+---------+
|   12.4082 |   0.2370  |   12.2797 |   0.1037   | 1.04644 |
|   14.1705 |   0.4272  |   14.0300 |   1.1478   | 1.00143 |
|   19.3769 |   1.0833  |   18.9745 |   0.0560   | 2.12074 |
|   24.5373 |   1.3237  |   22.3078 |   0.8999   | 9.99426 |
+-----------+-----------+-----------+------------+---------+

+-----------+-----------+-----------+------------+---------+
                               hackbench
+-----------+-----------+-----------+------------+---------+
|   value   |   stdev   |   value   |    stdev   | %improve|
+-----------+-----------+-----------+------------+---------+
|   73.2627 |  11.2413  |   67.5125 |   2.5722   |  8.51724|
|  134.4294 |   1.9688  |  153.6160 |   5.2033   |-12.48998|
|  215.4521 |   3.8672  |  238.8965 |   3.0035   | -9.81362|
|  303.8553 |   5.0427  |  310.3569 |   6.1463   | -2.09488|
++-----------+-----------+-----------+------------+--------+

+-----------+-----------+-----------+------------+---------+
                               ebizzy
+-----------+-----------+-----------+------------+---------+
|   value   |   stdev   |   value   |    stdev   | %improve|
+-----------+-----------+-----------+------------+---------+
| 1108.6250 |  19.3090  | 1088.2500 |   11.0809	 |-1.83786 |
| 1662.6250 | 150.5466  | 1064.0000 |    2.8284	 |-36.00481|
| 1394.0000 |  85.0867  | 1073.2857 |   10.3877	 |-23.00676|
| 1172.1250 |  20.3501  | 1245.8750 |   25.3852	 | 6.29199 |
+-----------+-----------+-----------+------------+---------+

+-----------+-----------+-----------+------------+---------+
                               dbench
+-----------+-----------+-----------+------------+---------+
|   value   |   stdev   |   value   |    stdev   | %improve|
+-----------+-----------+-----------+------------+---------+
|   29.0378 | 1.1625    | 28.8466   |    1.1132  |-0.65845 |
+-----------+-----------+-----------+------------+---------+

(benchmark values will be attached in reply to this mail)

Planning to post patches rebased to 3.5-rc. Avi, Ingo.. Please let me know.

