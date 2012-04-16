Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753992Ab2DPOKr (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Apr 2012 10:10:47 -0400
Received: from am1ehsobe006.messaging.microsoft.com ([213.199.154.209]:55543
	"EHLO am1outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753498Ab2DPOKp convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Apr 2012 10:10:45 -0400
X-SpamScore: -21
X-BigFish: VPS-21(zz9371I154dM1432N98dK4015I1447Mzz1202hzz8275bh8275dhz2dh668h839h944hd25h)
X-Forefront-Antispam-Report: CIP:163.181.249.109;KIP:(null);UIP:(null);IPV:NLI;H:ausb3twp02.amd.com;RD:none;EFVD:NLI
X-WSS-ID: 0M2KSPK-02-436-02
X-M-MSG: 
From: "Chen, Dennis (SRDC SW)" <Dennis1.Chen@amd.com>
To: Ingo Molnar <mingo@kernel.org>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "paulmck@linux.vnet.ibm.com" <paulmck@linux.vnet.ibm.com>,
        "peterz@infradead.org" <peterz@infradead.org>,
        Paul Mackerras <paulus@samba.org>,
        Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
Subject: RE: [PATCH 0/2] tools perf: Add a new benchmark tool for
 semaphore/mutex
Thread-Topic: [PATCH 0/2] tools perf: Add a new benchmark tool for
 semaphore/mutex
Thread-Index: AQHNG7LZ41+NXeNpuE+GPnaR09FoI5adfIgQ
Date: Mon, 16 Apr 2012 14:10:30 +0000
Message-ID: <491D6B4EAD0A714894D8AD22F4BDE043B15911@SCYBEXDAG03.amd.com>
References: <4F7EC111.4010608@ladisch.de>
 <491D6B4EAD0A714894D8AD22F4BDE0439F9ED2@SCYBEXDAG02.amd.com>
 <20120409184538.GE2430@linux.vnet.ibm.com>
 <491D6B4EAD0A714894D8AD22F4BDE043A33A9E@SCYBEXDAG02.amd.com>
 <20120411173006.GB2473@linux.vnet.ibm.com>
 <491D6B4EAD0A714894D8AD22F4BDE043A33D37@SCYBEXDAG02.amd.com>
 <20120412151854.GB2394@linux.vnet.ibm.com>
 <491D6B4EAD0A714894D8AD22F4BDE043A33FD3@SCYBEXDAG02.amd.com>
 <20120413184350.GD2402@linux.vnet.ibm.com>
 <491D6B4EAD0A714894D8AD22F4BDE043B158BE@SCYBEXDAG03.amd.com>
 <20120416092437.GB27526@gmail.com>
In-Reply-To: <20120416092437.GB27526@gmail.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.237.74.102]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
X-OriginatorOrg: amd.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Apr 16, 2012 at 5:24 PM, Ingo Molnar <mingo@kernel.org> wrote:
>
> * Chen, Dennis (SRDC SW) <Dennis1.Chen@amd.com> wrote:
>
>> <PATCH PREFACE>
>> -------------------
>> This patch series are used to add a new performance benchmark tool for semaphore or mutex:
>> The new tool will fork NR tasks specified through the command line and bind each of them
>> to every CPUs in the system equally. The command to launch the tool looks like:
>> '# perf bench locking mutex -p 8 -t 400 -c'
>>
>> The above command will create 400 tasks in a system with 8-CPU, each CPU will have 50 tasks.
>> After the task be created, it will read all the files and directories in '/sys/module'.
>> sysfs is RAM based and its read operation for both dir and file is very sensitive for mutex
>> lock, also '/sys/module' has almost no dependencies on external devices.
>>
>> We can use this tool with 'perf record' command to get the hot-spot of the codes or
>> 'perf top -g' to get live info, for example, below is a test case run in a intel i7-2600 box
>> (-c option is to get the cpu cycles, I don't use it in this test case):
>>
>> # perf record -a perf bench locking mutex -p 8 -t 4000
>> # Running locking/mutex benchmark...
>>  ...
>>  [13894 ]/6  duration        23 s   609392 us
>>  [13996 ]/4  duration        23 s   599418 us
>>  [14056 ]/0  duration        23 s   595710 us
>>  [13715 ]/3  duration        23 s   621719 us
>>  [13390 ]/6  duration        23 s   644020 us
>>  [13696 ]/0  duration        23 s   623101 us
>>  [14334 ]/6  duration        23 s   580262 us
>>  [14343 ]/7  duration        23 s   578702 us
>>  [14283 ]/3  duration        23 s   583007 us
>>  -----------------------------------
>>  Total duration     79353 s   943945 us
>>
>>  real: 23.84   s
>>  user: 0.00
>>  sys:  0.45
>>
>> # perf report
>> ===================================================================================
>> ...
>> # perf version : 3.3.2
>> # arch : x86_64
>> # nrcpus online : 8
>> # nrcpus avail : 8
>> # cpudesc : Intel(R) Core(TM) i7-2600 CPU @ 3.40GHz
>> # total memory : 3966460 kB
>> # cmdline : /usr/bin/perf record -a perf bench locking mutex -p 8 -t 4000
>>
>> # Events: 131K cycles
>> #
>> # Overhead          Command                      Shared Object                                 Symbol
>> # ........  ...............  .................................  .....................................
>> #
>>     22.12%           perf  [kernel.kallsyms]                  [k] __mutex_lock_slowpath
>>      8.27%           perf  [kernel.kallsyms]                  [k] _raw_spin_lock
>>      6.16%           perf  [kernel.kallsyms]                  [k] mutex_unlock
>>      5.22%           perf  [kernel.kallsyms]                  [k] mutex_spin_on_owner
>>      4.94%           perf  [kernel.kallsyms]                  [k] sysfs_refresh_inode
>>      4.82%           perf  [kernel.kallsyms]                  [k] mutex_lock
>>      2.67%           perf  [kernel.kallsyms]                  [k] __mutex_unlock_slowpath
>>      2.61%           perf  [kernel.kallsyms]                  [k] link_path_walk
>>      2.42%           perf  [kernel.kallsyms]                  [k] _raw_spin_lock_irqsave
>>      1.61%           perf  [kernel.kallsyms]                  [k] __d_lookup
>>      1.18%           perf  [kernel.kallsyms]                  [k] clear_page_c
>>      1.16%           perf  [kernel.kallsyms]                  [k] dput
>>      0.97%           perf  [kernel.kallsyms]                  [k] do_lookup
>>      0.93%        swapper  [kernel.kallsyms]                  [k] intel_idle
>>      0.87%           perf  [kernel.kallsyms]                  [k] get_page_from_freelist
>>      0.85%           perf  [kernel.kallsyms]                  [k] __strncpy_from_user
>>      0.81%           perf  [kernel.kallsyms]                  [k] system_call
>>      0.78%           perf  libc-2.13.so                       [.] 0x84ef0
>>      0.71%           perf  [kernel.kallsyms]                  [k] vfsmount_lock_local_lock
>>      0.68%           perf  [kernel.kallsyms]                  [k] sysfs_dentry_revalidate
>>      0.62%           perf  [kernel.kallsyms]                  [k] try_to_wake_up
>>      0.62%           perf  [kernel.kallsyms]                  [k] kfree
>>      0.60%           perf  [kernel.kallsyms]                  [k] kmem_cache_alloc
>> ............................................................................................
>>
>
> Nice! Would be nice to lift some of this information over into
> the changelogs, to address my complaints in the previous mail.

Thanks for the suggestion! I will resubmit the patches into a single patch and include the above info
to address the changelog issue...

>> We can see that for 4000 tasks running in 8 CPUs simultaneously, it will create a very heavy
>> contention for the mutex lock, so lot's of tasks enter into the slow path of the mutex lock...
>> I am very curious if we switch the mutex to the semaphore in this case, how's thing going?
>> My next plan
>
> Seems like an unfinished sentence.

Oh, I mean my next plan is to do some performance analysis of the 2 primitives with this tool...

> Thanks,
>
>        Ingo

