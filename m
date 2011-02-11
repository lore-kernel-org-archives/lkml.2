Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757724Ab1BKQff (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Feb 2011 11:35:35 -0500
Received: from mail-pw0-f46.google.com ([209.85.160.46]:36779 "EHLO
	mail-pw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751095Ab1BKQfd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Feb 2011 11:35:33 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:content-type:content-transfer-encoding;
        b=QdTcscs1K5w1FNbMqWVD1V/10E29WQ9PZvjyWG9nutBFPUp1jW7z1bC6ibEsdS/KW1
         49oVoVpDXedx1XJ5wmUskDOC2Zd0FmPGF17r5ZAOuEXGov5EPrW6C4stWmNAcpv4ByaA
         CecVz2AUbPthQnMXkGqBfjENzlUnpeiaNJInY=
Message-ID: <4D55654F.6090408@gmail.com>
Date: Fri, 11 Feb 2011 09:35:27 -0700
From: David Ahern <dsahern@gmail.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.13) Gecko/20101209 Fedora/3.1.7-0.35.b3pre.fc13 Thunderbird/3.1.7
MIME-Version: 1.0
To: Peter Zijlstra <a.p.zijlstra@chello.nl>, Jeff Moyer <jmoyer@redhat.com>
CC: linux-kernel@vger.kernel.org, Ingo Molnar <mingo@elte.hu>,
        Paul Mackerras <paulus@samba.org>,
        Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
Subject: Re: perf on 2.6.38-rc4 wedges my box
References: <x49k4h9az25.fsf@segfault.boston.devel.redhat.com> <1297373905.5226.31.camel@laptop>
In-Reply-To: <1297373905.5226.31.camel@laptop>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On 02/10/11 14:38, Peter Zijlstra wrote:
> On Wed, 2011-02-09 at 12:38 -0500, Jeff Moyer wrote:
>> Hi,
>>
>> I'm trying out willy's ata_ram driver[1], and in so doing have managed to
>> wedge my box while using perf record on an aio-stress run:
>>
>> [root@metallica ~]# modprobe ata_ram capacity=2097152 preallocate=1
>> [root@metallica ~]# ./aio-stress -O -o 0 -r 4 -d 32 -b 16 /dev/sds
>> adding stage write
>> starting with write
>> file size 1024MB, record size 4KB, depth 32, ios per iteration 8
>> max io_submit 16, buffer alignment set to 4KB
>> threads 1 files 1 contexts 1 context offset 2MB verification off
>> adding file /dev/sds thread 0
>> write on /dev/sds (621.30 MB/s) 1024.00 MB in 1.65s
>> thread 0 write totals (621.27 MB/s) 1024.00 MB in 1.65s
>> [root@metallica ~]# perf record -- ./aio-stress -O -o 0 -r 4 -d 32 -b 16
>> /dev/sds
>> adding stage write
>> starting with write
>> file size 1024MB, record size 4KB, depth 32, ios per iteration 8
>> max io_submit 16, buffer alignment set to 4KB
>> threads 1 files 1 contexts 1 context offset 2MB verification off
>> adding file /dev/sds thread 0
>>
>> and there it sits.  On the console, I see:
>>
>> NOHZ: local_softirq_pending 100
>> NOHZ: local_softirq_pending 100
>> NOHZ: local_softirq_pending 100
>> NOHZ: local_softirq_pending 100
>> NOHZ: local_softirq_pending 100
>>
>> The number of messages varies, but this is the most I've seen (it
>> doesn't keep repeating).  At this point, the machine does not respond to
>> pings.  As I don't have physical access at the moment, I can't try
>> alt-sysrq, but might be able to do that tomorrow.  It's probably worth
>> noting that I've witnessed similar behavior with real devices, so it's
>> not just the ata_ram driver.
>>
>> Any ideas on how to track this down?
> 
> So I took linus' tree of about half an hour ago, added
> git://git.kernel.org/pub/scm/linux/kernel/git/willy/misc.git ata-ram
> (fixed up some Kconfig/Makefile rejects), google'd aio-stress
> (http://fsbench.filesystems.org/bench/aio-stress.c) and set out to
> reproduce the above..
> 
> Sadly it all seems to work here, its spending ~15% in
> _raw_spin_lock_irq, which when I use -g looks to break down like:
> 
> -     14.13%  aio-stress  [kernel.kallsyms]  [k] _raw_spin_lock_irq 
>    - _raw_spin_lock_irq                                             
>       + 44.14% __make_request                                       
>       + 20.91% __aio_get_req                                        
>       + 10.15% aio_run_iocb                                         
>       + 7.37% do_io_submit                                          
>       + 6.55% scsi_request_fn                                       
>       + 5.48% generic_unplug_device                                 
>       + 3.58% aio_put_req                                           
>       + 0.92% generic_make_request                                  
>       + 0.91% __generic_unplug_device

I'm guessing in your case perf is using hardware cycles for profiling.

I was able to reproduce the lockup in a VM which uses cpu-clock for
profiling - like Jeff's case. The VM is running Fedora 14 with 2.6.38-rc4.

In the host one of qemu-kvm's threads is pegging the cpu. Backtrace of
the vcpus is given below. stop-bt-cont at various intervals is showing
similar traces, and xtime is not advancing. Final function changes
(e.g., from __rb_rotate_left to __rb_rotate_right)

David



[Switching to Thread 1]
(gdb) bt
#0  native_safe_halt () at
/opt/kernel/src/arch/x86/include/asm/irqflags.h:50
#1  0xffffffff81009d76 in arch_safe_halt () at
/opt/kernel/src/arch/x86/include/asm/paravirt.h:110
#2  default_idle () at /opt/kernel/src/arch/x86/kernel/process.c:381
#3  0xffffffff8100132a in cpu_idle () at
/opt/kernel/src/arch/x86/kernel/process_64.c:139
#4  0xffffffff81392c89 in rest_init () at /opt/kernel/src/init/main.c:463
#5  0xffffffff81697c23 in start_kernel () at /opt/kernel/src/init/main.c:713
#6  0xffffffff816972af in x86_64_start_reservations
(real_mode_data=<value optimized out>) at
/opt/kernel/src/arch/x86/kernel/head64.c:127
#7  0xffffffff816973b9 in x86_64_start_kernel (real_mode_data=0x93950
<Address 0x93950 out of bounds>) at
/opt/kernel/src/arch/x86/kernel/head64.c:97
#8  0x0000000000000000 in ?? ()

(gdb) thread 2
[Switching to thread 2 (Thread 2)]#0  __rb_rotate_left
(node=0xffff8800782dd8f0, root=0xffff88007fd0e358) at
/opt/kernel/src/lib/rbtree.c:37

(gdb) bt
#0  __rb_rotate_left (node=0xffff8800782dd8f0, root=0xffff88007fd0e358)
at /opt/kernel/src/lib/rbtree.c:37
#1  0xffffffff81206bcc in rb_insert_color (node=0xffff8800782dd8f0,
root=0xffff88007fd0e358) at /opt/kernel/src/lib/rbtree.c:130
#2  0xffffffff81207cb5 in timerqueue_add (head=0xffff88007fd0e358,
node=0xffff8800782dd8f0) at /opt/kernel/src/lib/timerqueue.c:56
#3  0xffffffff8105f595 in enqueue_hrtimer (timer=0xffff8800782dd8f0,
base=0xffff88007fd0e348) at /opt/kernel/src/kernel/hrtimer.c:848
#4  0xffffffff8105fc75 in __hrtimer_start_range_ns
(timer=0xffff8800782dd8f0, tim=..., delta_ns=0, mode=<value optimized
out>, wakeup=0)
    at /opt/kernel/src/kernel/hrtimer.c:961
#5  0xffffffff810b662e in perf_swevent_start_hrtimer
(event=0xffff8800782dd800) at /opt/kernel/src/kernel/perf_event.c:5092
#6  0xffffffff810b669c in cpu_clock_event_start (event=<value optimized
out>, flags=<value optimized out>) at
/opt/kernel/src/kernel/perf_event.c:5126
#7  0xffffffff810ba515 in perf_ctx_adjust_freq (ctx=0xffff880079930600,
period=999848) at /opt/kernel/src/kernel/perf_event.c:1726
#8  0xffffffff810ba690 in perf_rotate_context () at
/opt/kernel/src/kernel/perf_event.c:1787
#9  perf_event_task_tick () at /opt/kernel/src/kernel/perf_event.c:1821
#10 0xffffffff8103d8d8 in scheduler_tick () at
/opt/kernel/src/kernel/sched.c:3784
#11 0xffffffff8104effe in update_process_times (user_tick=0) at
/opt/kernel/src/kernel/timer.c:1274
#12 0xffffffff81069587 in tick_sched_timer (timer=0xffff88007fd0e3f0) at
/opt/kernel/src/kernel/time/tick-sched.c:760
#13 0xffffffff8105f75d in __run_hrtimer (timer=0xffff88007fd0e3f0,
now=0xffff88007fd03f48) at /opt/kernel/src/kernel/hrtimer.c:1197
#14 0xffffffff8105ff5e in hrtimer_interrupt (dev=<value optimized out>)
at /opt/kernel/src/kernel/hrtimer.c:1283
#15 0xffffffff813acb4e in local_apic_timer_interrupt (regs=<value
optimized out>) at /opt/kernel/src/arch/x86/kernel/apic/apic.c:844
#16 smp_apic_timer_interrupt (regs=<value optimized out>) at
/opt/kernel/src/arch/x86/kernel/apic/apic.c:871
#17 <signal handler called>


> 
> 
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
