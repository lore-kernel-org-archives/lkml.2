Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752886Ab1LLDHP (ORCPT <rfc822;w@1wt.eu>);
	Sun, 11 Dec 2011 22:07:15 -0500
Received: from mx1.redhat.com ([209.132.183.28]:55061 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752817Ab1LLDHK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 11 Dec 2011 22:07:10 -0500
Message-ID: <4EE56FCD.9030609@redhat.com>
Date: Mon, 12 Dec 2011 11:06:53 +0800
From: Amos Kong <akong@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:7.0.1) Gecko/20110930 Thunderbird/7.0.1
MIME-Version: 1.0
To: Benjamin Herrenschmidt <benh@kernel.crashing.org>
CC: "Michael S. Tsirkin" <mst@redhat.com>,
        Rusty Russell <rusty@rustcorp.com.au>,
        Ohad Ben-Cohen <ohad@wizery.com>,
        virtualization@lists.linux-foundation.org, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org
Subject: Re: [RFC] virtio: use mandatory barriers for remote processor vdevs
References: <1322569886-13055-1-git-send-email-ohad@wizery.com>  <1322867384.11728.20.camel@pasglop> <87hb1iqls3.fsf@rustcorp.com.au>  <20111211122544.GC11504@redhat.com> <1323642447.19891.8.camel@pasglop>
In-Reply-To: <1323642447.19891.8.camel@pasglop>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/12/11 06:27, Benjamin Herrenschmidt wrote:
> On Sun, 2011-12-11 at 14:25 +0200, Michael S. Tsirkin wrote:
>
>> Forwarding some results by Amos, who run multiple netperf streams in
>> parallel, from an external box to the guest.  TCP_STREAM results were
>> noisy.  This could be due to buffering done by TCP, where packet size
>> varies even as message size is constant.
>>
>> TCP_RR results were consistent. In this benchmark, after switching
>> to mandatory barriers, CPU utilization increased by up to 35% while
>> throughput went down by up to 14%. the normalized throughput/cpu
>> regressed consistently, between 7 and 35%
>>
>> The "fix" applied was simply this:
>
> What machine&  processor was this  ?

pined guest memory to numa node 1
# numactl -m 1 qemu-kvm ...
pined guest vcpu threads and vhost thread to single cpu of numa node 1
# taskset -p 0x10 8348 (vhost_net_thread)
# taskset -p 0x20 8353 (vcpu 1 thread)
# taskset -p 0x40 8357 (vcpu 2 thread)
pined cpu/memory of netperf client process to node 1
# numactl --cpunodebind=1 --membind=1 netperf ...

8 cores
-------
processor	: 7
vendor_id	: GenuineIntel
cpu family	: 6
model		: 44
model name	: Intel(R) Xeon(R) CPU           E5620  @ 2.40GHz
stepping	: 2
microcode	: 0xc
cpu MHz		: 1596.000
cache size	: 12288 KB
physical id	: 1
siblings	: 4
core id		: 10
cpu cores	: 4
apicid		: 52
initial apicid	: 52
fpu		: yes
fpu_exception	: yes
cpuid level	: 11
wp		: yes
flags		: fpu vme de pse tsc msr pae mce cx8 apic sep mtrr pge mca cmov 
pat pse36 clflush dts acpi mmx fxsr sse sse2 ss ht tm pbe syscall nx 
pdpe1gb rdtscp lm constant_tsc arch_perfmon pebs bts rep_good nopl 
xtopology nonstop_tsc aperfmperf pni pclmulqdq dtes64 monitor ds_cpl vmx 
smx est tm2 ssse3 cx16 xtpr pdcm pcid dca sse4_1 sse4_2 popcnt aes 
lahf_lm ida arat epb dts tpr_shadow vnmi flexpriority ept vpid
bogomips	: 4787.76
clflush size	: 64
cache_alignment	: 64
address sizes	: 40 bits physical, 48 bits virtual
power management:

# cat /proc/meminfo
MemTotal:       16446616 kB
MemFree:        15874092 kB
Buffers:           30404 kB
Cached:           238640 kB
SwapCached:            0 kB
Active:           100204 kB
Inactive:         184312 kB
Active(anon):      15724 kB
Inactive(anon):        4 kB
Active(file):      84480 kB
Inactive(file):   184308 kB
Unevictable:           0 kB
Mlocked:               0 kB
SwapTotal:       8388604 kB
SwapFree:        8388604 kB
Dirty:                56 kB
Writeback:             0 kB
AnonPages:         15548 kB
Mapped:            11540 kB
Shmem:               256 kB
Slab:              82444 kB
SReclaimable:      19220 kB
SUnreclaim:        63224 kB
KernelStack:        1224 kB
PageTables:         2256 kB
NFS_Unstable:          0 kB
Bounce:                0 kB
WritebackTmp:          0 kB
CommitLimit:    16611912 kB
Committed_AS:     209068 kB
VmallocTotal:   34359738367 kB
VmallocUsed:      224244 kB
VmallocChunk:   34351073668 kB
HardwareCorrupted:     0 kB
AnonHugePages:         0 kB
HugePages_Total:       0
HugePages_Free:        0
HugePages_Rsvd:        0
HugePages_Surp:        0
Hugepagesize:       2048 kB
DirectMap4k:        9876 kB
DirectMap2M:     2070528 kB
DirectMap1G:    14680064 kB

# numactl --hardware
available: 2 nodes (0-1)
node 0 cpus: 0 1 2 3
node 0 size: 8175 MB
node 0 free: 7706 MB
node 1 cpus: 4 5 6 7
node 1 size: 8192 MB
node 1 free: 7796 MB
node distances:
node   0   1
   0:  10  20
   1:  20  10
# numactl --show
policy: default
preferred node: current
physcpubind: 0 1 2 3 4 5 6 7
cpubind: 0 1
nodebind: 0 1
membind: 0 1


> Cheers,
> Ben.
>
>> diff --git a/drivers/virtio/virtio_ring.c b/drivers/virtio/virtio_ring.c
>> index 3198f2e..fdccb77 100644
>> --- a/drivers/virtio/virtio_ring.c
>> +++ b/drivers/virtio/virtio_ring.c
>> @@ -23,7 +23,7 @@
>>
>>   /* virtio guest is communicating with a virtual "device" that actually runs on
>>    * a host processor.  Memory barriers are used to control SMP effects. */
>> -#ifdef CONFIG_SMP
>> +#if 0
>>   /* Where possible, use SMP barriers which are more lightweight than mandatory
>>    * barriers, because mandatory barriers control MMIO effects on accesses
>>    * through relaxed memory I/O windows (which virtio does not use). */
>>
>>
>>
>
>
> --
> To unsubscribe from this list: send the line "unsubscribe kvm" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
