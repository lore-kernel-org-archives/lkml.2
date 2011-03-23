Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752387Ab1CWQ2Q (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Mar 2011 12:28:16 -0400
Received: from smtp-out.google.com ([74.125.121.67]:9789 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750835Ab1CWQ2O convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Mar 2011 12:28:14 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=google.com; s=beta;
        h=mime-version:in-reply-to:references:from:date:message-id:subject:to
         :cc:content-type:content-transfer-encoding;
        b=fPendkV2uMPW77JPyBk1ZGwHmGKMTCRlu4zNwAFXutjSERVcv+FZQqQfXsbaMbxVos
         kXt9ALNQt5H5WLp/FF9A==
MIME-Version: 1.0
In-Reply-To: <20110323012755.GA10325@redhat.com>
References: <1300835335-2777-1-git-send-email-teravest@google.com> <20110323012755.GA10325@redhat.com>
From: Justin TerAvest <teravest@google.com>
Date: Wed, 23 Mar 2011 09:27:47 -0700
Message-ID: <AANLkTi=YyY0dCVP+JAJsyiYYqWMwf1XBROf_h_eG0yEL@mail.gmail.com>
Subject: Re: [RFC] [PATCH v2 0/8] Provide cgroup isolation for buffered writes.
To: Vivek Goyal <vgoyal@redhat.com>
Cc: jaxboe@fusionio.com, m-ikeda@ds.jp.nec.com, ryov@valinux.co.jp,
        taka@valinux.co.jp, kamezawa.hiroyu@jp.fujitsu.com,
        righi.andrea@gmail.com, guijianfeng@cn.fujitsu.com,
        balbir@linux.vnet.ibm.com, ctalbott@google.com,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Mar 22, 2011 at 6:27 PM, Vivek Goyal <vgoyal@redhat.com> wrote:
> On Tue, Mar 22, 2011 at 04:08:47PM -0700, Justin TerAvest wrote:
>
> [..]
>> ===================================== Isolation experiment results
>>
>> For isolation testing, we run a test that's available at:
>>   git://google3-2.osuosl.org/tests/blkcgroup.git
>>
>> It creates containers, runs workloads, and checks to see how well we meet
>> isolation targets. For the purposes of this patchset, I only ran
>> tests among buffered writers.
>>
>> Before patches
>> ==============
>> 10:32:06 INFO experiment 0 achieved DTFs: 666, 333
>> 10:32:06 INFO experiment 0 FAILED: max observed error is 167, allowed is 150
>> 10:32:51 INFO experiment 1 achieved DTFs: 647, 352
>> 10:32:51 INFO experiment 1 FAILED: max observed error is 253, allowed is 150
>> 10:33:35 INFO experiment 2 achieved DTFs: 298, 701
>> 10:33:35 INFO experiment 2 FAILED: max observed error is 199, allowed is 150
>> 10:34:19 INFO experiment 3 achieved DTFs: 445, 277, 277
>> 10:34:19 INFO experiment 3 FAILED: max observed error is 155, allowed is 150
>> 10:35:05 INFO experiment 4 achieved DTFs: 418, 104, 261, 215
>> 10:35:05 INFO experiment 4 FAILED: max observed error is 232, allowed is 150
>> 10:35:53 INFO experiment 5 achieved DTFs: 213, 136, 68, 102, 170, 136, 170
>> 10:35:53 INFO experiment 5 PASSED: max observed error is 73, allowed is 150
>> 10:36:04 INFO -----ran 6 experiments, 1 passed, 5 failed
>>
>> After patches
>> =============
>> 11:05:22 INFO experiment 0 achieved DTFs: 501, 498
>> 11:05:22 INFO experiment 0 PASSED: max observed error is 2, allowed is 150
>> 11:06:07 INFO experiment 1 achieved DTFs: 874, 125
>> 11:06:07 INFO experiment 1 PASSED: max observed error is 26, allowed is 150
>> 11:06:53 INFO experiment 2 achieved DTFs: 121, 878
>> 11:06:53 INFO experiment 2 PASSED: max observed error is 22, allowed is 150
>> 11:07:46 INFO experiment 3 achieved DTFs: 589, 205, 204
>> 11:07:46 INFO experiment 3 PASSED: max observed error is 11, allowed is 150
>> 11:08:34 INFO experiment 4 achieved DTFs: 616, 109, 109, 163
>> 11:08:34 INFO experiment 4 PASSED: max observed error is 34, allowed is 150
>> 11:09:29 INFO experiment 5 achieved DTFs: 139, 139, 139, 139, 140, 141, 160
>> 11:09:29 INFO experiment 5 PASSED: max observed error is 1, allowed is 150
>> 11:09:46 INFO -----ran 6 experiments, 6 passed, 0 failed
>>
>> Summary
>> =======
>> Isolation between buffered writers is clearly better with this patch.
>
> Can you pleae explain what is this test doing. All I am seeing is passed
> and failed and really don't understand what the test is doing.

I should have brought in more context; I was trying to keep the email
from becoming so long that nobody would read it.

We create cgroups, and set blkio.weight_device in the cgroups so that
they are assigned different weights for a given device. To give a
concrete example, in this case:
11:05:23 INFO ----- Running experiment 1: 900 wrseq.buf*2, 100 wrseq.buf*2
11:06:07 INFO experiment 1 achieved DTFs: 874, 125
11:06:07 INFO experiment 1 PASSED: max observed error is 26, allowed is 150

We create two cgroups, one with weight 900 for device, the other with
weight 100.
Then in each cgroup we run "/bin/dd if=/dev/zero of=$outputfile bs=64K ...".

After those complete, we measure blkio.time, and compare their ratios
to all of to all of the time taken, to see how closely the time
reported in the cgroup matches the requested weight for the device.

For simplicity, we only did dd WRITER tasks in the testing, though
isolation is also improved when we have a writer and a reader in
separate containers.

>
> Can you run say simple 4 dd buffered writers in 4 cgroups with weights
> 100, 200, 300 and 400 and see if you get better isolation.

Absolutely. :) This is pretty close to what I ran above, I should have
just provided a better description.

Baseline (Jens' tree):
08:43:02 INFO ----- Running experiment 0: 100 wrseq.buf, 200
wrseq.buf, 300 wrseq.buf, 400 wrseq.buf
08:43:46 INFO experiment 0 achieved DTFs: 144, 192, 463, 198
08:43:46 INFO experiment 0 FAILED: max observed error is 202, allowed is 150
08:43:50 INFO -----ran 1 experiments, 0 passed, 1 failed


With patches:
08:36:08 INFO ----- Running experiment 0: 100 wrseq.buf, 200
wrseq.buf, 300 wrseq.buf, 400 wrseq.buf
08:36:55 INFO experiment 0 achieved DTFs: 113, 211, 289, 385
08:36:55 INFO experiment 0 PASSED: max observed error is 15, allowed is 150
08:36:56 INFO -----ran 1 experiments, 1 passed, 0 failed

>
> Secondly can you also please explain that how does it work. Without
> making writeback cgroup aware, there are no gurantees that higher
> weight cgroup will get more IO done.

It is dependent on writeback sending enough requests to the I/O
scheduler that touch multiple groups so that they can be scheduled
properly. We are not guaranteed that writeback will appropriately
choose pages from different cgroups, you are correct.

However, from experiments, we can see that writeback can send enough
I/O to the scheduler (and from enough cgroups) to allow us to get
isolation between cgroups for writes. As writeback more predictably
can pick I/Os from multiple cgroups to issue, I would expect this to
improve.


>
>>
>>
>> =============================== Read latency results
>> To test read latency, I created two containers:
>>   - One called "readers", with weight 900
>>   - One called "writers", with weight 100
>>
>> I ran this fio workload in "readers":
>> [global]
>> directory=/mnt/iostestmnt/fio
>> runtime=30
>> time_based=1
>> group_reporting=1
>> exec_prerun='echo 3 > /proc/sys/vm/drop_caches'
>> cgroup_nodelete=1
>> bs=4K
>> size=512M
>>
>> [iostest-read]
>> description="reader"
>> numjobs=16
>> rw=randread
>> new_group=1
>>
>>
>> ....and this fio workload in "writers"
>> [global]
>> directory=/mnt/iostestmnt/fio
>> runtime=30
>> time_based=1
>> group_reporting=1
>> exec_prerun='echo 3 > /proc/sys/vm/drop_caches'
>> cgroup_nodelete=1
>> bs=4K
>> size=512M
>>
>> [iostest-write]
>> description="writer"
>> cgroup=writers
>> numjobs=3
>> rw=write
>> new_group=1
>>
>>
>>
>> I've pasted the results from the "read" workload inline.
>>
>> Before patches
>> ==============
>> Starting 16 processes
>>
>> Jobs: 14 (f=14): [_rrrrrr_rrrrrrrr] [36.2% done] [352K/0K /s] [86 /0  iops] [eta 01m:00s]·············
>> iostest-read: (groupid=0, jobs=16): err= 0: pid=20606
>>   Description  : ["reader"]
>>   read : io=13532KB, bw=455814 B/s, iops=111 , runt= 30400msec
>>     clat (usec): min=2190 , max=30399K, avg=30395175.13, stdev= 0.20
>>      lat (usec): min=2190 , max=30399K, avg=30395177.07, stdev= 0.20
>>     bw (KB/s) : min=    0, max=  260, per=0.00%, avg= 0.00, stdev= 0.00
>>   cpu          : usr=0.00%, sys=0.03%, ctx=3691, majf=2, minf=468
>>   IO depths    : 1=100.0%, 2=0.0%, 4=0.0%, 8=0.0%, 16=0.0%, 32=0.0%, >=64=0.0%
>>      submit    : 0=0.0%, 4=100.0%, 8=0.0%, 16=0.0%, 32=0.0%, 64=0.0%, >=64=0.0%
>>      complete  : 0=0.0%, 4=100.0%, 8=0.0%, 16=0.0%, 32=0.0%, 64=0.0%, >=64=0.0%
>>      issued r/w/d: total=3383/0/0, short=0/0/0
>>
>>      lat (msec): 4=0.03%, 10=2.66%, 20=74.84%, 50=21.90%, 100=0.09%
>>      lat (msec): 250=0.06%, >=2000=0.41%
>>
>> Run status group 0 (all jobs):
>>    READ: io=13532KB, aggrb=445KB/s, minb=455KB/s, maxb=455KB/s, mint=30400msec, maxt=30400msec
>>
>> Disk stats (read/write):
>>   sdb: ios=3744/18, merge=0/16, ticks=542713/1675, in_queue=550714, util=99.15%
>>
>>
>>
>> After patches
>> =============
>> tarting 16 processes
>> Jobs: 16 (f=16): [rrrrrrrrrrrrrrrr] [100.0% done] [557K/0K /s] [136 /0  iops] [eta 00m:00s]
>> iostest-read: (groupid=0, jobs=16): err= 0: pid=14183
>>   Description  : ["reader"]
>>   read : io=14940KB, bw=506105 B/s, iops=123 , runt= 30228msec
>>     clat (msec): min=2 , max=29866 , avg=463.42, stdev=101.84
>>      lat (msec): min=2 , max=29866 , avg=463.42, stdev=101.84
>>     bw (KB/s) : min=    0, max=  198, per=31.69%, avg=156.52, stdev=17.83
>>   cpu          : usr=0.01%, sys=0.03%, ctx=4274, majf=2, minf=464
>>   IO depths    : 1=100.0%, 2=0.0%, 4=0.0%, 8=0.0%, 16=0.0%, 32=0.0%, >=64=0.0%
>>      submit    : 0=0.0%, 4=100.0%, 8=0.0%, 16=0.0%, 32=0.0%, 64=0.0%, >=64=0.0%
>>      complete  : 0=0.0%, 4=100.0%, 8=0.0%, 16=0.0%, 32=0.0%, 64=0.0%, >=64=0.0%
>>      issued r/w/d: total=3735/0/0, short=0/0/0
>>
>>      lat (msec): 4=0.05%, 10=0.32%, 20=32.99%, 50=64.61%, 100=1.26%
>>      lat (msec): 250=0.11%, 500=0.11%, 750=0.16%, 1000=0.05%, >=2000=0.35%
>>
>> Run status group 0 (all jobs):
>>    READ: io=14940KB, aggrb=494KB/s, minb=506KB/s, maxb=506KB/s, mint=30228msec, maxt=30228msec
>>
>> Disk stats (read/write):
>>   sdb: ios=4189/0, merge=0/0, ticks=96428/0, in_queue=478798, util=100.00%
>>
>>
>>
>> Summary
>> =======
>> Read latencies are a bit worse, but this overhead is only imposed when users
>> ask for this feature by turning on CONFIG_BLKIOTRACK. We expect there to be =
>> a something of a latency vs isolation tradeoff.
>
> - What number you are looking at to say READ latencies are worse.

I am looking at the "lat (msec)" values below IO depths in the fio output.

Specifically, before this patch:
      lat (msec): 4=0.03%, 10=2.66%, 20=74.84%, 50=21.90%, 100=0.09%
      lat (msec): 250=0.06%, >=2000=0.41%

...and after:
      lat (msec): 4=0.05%, 10=0.32%, 20=32.99%, 50=64.61%, 100=1.26%
      lat (msec): 250=0.11%, 500=0.11%, 750=0.16%, 1000=0.05%, >=2000=0.35%

We can see that a lot of IOs moved from the 20ms group to 50ms.


It might be more clear if I made a table of percentage that finished
by a specific time.
       Baseline        W/Patches
4      0.03             0.05
10     2.69             0.37
20     77.53            33.36
50     99.43            97.97
100    99.52            99.23
250    99.58            99.34
inf    99.99            100.01



> - Who got isolated here? If READS latencies are worse and you are saying
>  that's the cost of isolation, that means you are looking for isolation
>  for WRITES? This is the first time time I am hearing that READS starved
>  WRITES and I want better isolation for WRITES.

Yes, we are trying to get isolation between writes. I think a lot of
the effect that causes read latencies to be hurt is that we no longer
allow sync queues to preempt all async work. Part of the focus here is
also to stop writers from becoming starved.


>
> Also CONFIG_BLKIOTRACK=n is not the solution. This will most likely be
> set and we need to figure out which makes sense.

I would be open to this being a cgroup property or something similar
as well. My point is that this should probably be configurable, as
we're making a tradeoff between latency and isolation, and though I
know that many users care about isolation between groups, maybe not
everyone does.

>
> To me WRITE isolation comes handy only if we want to create speed
> difference between multiple WRITE streams. And that can not reliably be
> done till we make writeback logic cgroup aware.
>
> If we try to put WRITES in a separate group, most likely WRITES will end
> up getting bigger share of disk then what they are getting by default and
> I seriously doubt that who is looking for that. So far all the complaints
> I have heard is that in presence of WRITES, my READ latencies suffer and
> not vice a versa.

READ latencies are an excellent thing to focus on, but so is isolation
(and fairness) between cgroups.

We run many varying workloads in our deployments, and we don't want a
job coming in doing a lot of read traffic to starve out another job
(in a different cgroup) that's writing to the disk. I'm not sure what
the concerns and goals are for other users of CFQ, but from my
perspective, the most important thing is to get isolation between the
tasks so that their traffic to the disk is more predictable.


Thanks,
Justin



>
> Thanks
> Vivek
>
