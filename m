Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756526Ab1JNMiU (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Oct 2011 08:38:20 -0400
Received: from mail-ey0-f174.google.com ([209.85.215.174]:57541 "EHLO
	mail-ey0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752439Ab1JNMiT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Oct 2011 08:38:19 -0400
Message-ID: <1318595915.2223.7.camel@edumazet-HP-Compaq-6005-Pro-SFF-PC>
Subject: Re: Regression in reading /proc/stat in the newer kernels with
 large SMP and NUMA configurations
From: Eric Dumazet <eric.dumazet@gmail.com>
To: "Oberman, Laurence (HAS GSE)" <Laurence.Oberman@hp.com>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "Seger, Mark" <mark.seger@hp.com>,
        "Cabaniols, Sebastien" <Sebastien.Cabaniols@hp.com>
Date: Fri, 14 Oct 2011 14:38:35 +0200
In-Reply-To: <8DC664164FA4D1449479E7B36CDCFB1F221E724322@GVW0676EXC.americas.hpqcorp.net>
References: <8DC664164FA4D1449479E7B36CDCFB1F221E724322@GVW0676EXC.americas.hpqcorp.net>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.0- 
Content-Transfer-Encoding: 8bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Le vendredi 14 octobre 2011 à 00:40 +0100, Oberman, Laurence (HAS GSE) a
écrit :
> Hello,
> 
> The HP developed collectl utility depends heavily on abstractions in /proc and /sys provided by the kernel for kernel statistics capture.
> During testing on newer NUMA platforms with large numbers of CPU’S HP has observed a significant increase in the time taken to parse this data with the newer 2.6.32.x and higher kernels.
> 
> In summary:
> 
> To read the data for a DL785 8-node NUMA with 4 CPU’S per node takes around 80 microseconds per read on the 2.6.18.x kernels, but when testing on the same platform with the newer 2.6.32.x and higher kernels each read takes more than 5 ms. This is significant when considering that collectl typically collects the data abstraction in the kernel every 10 seconds (default) for certain statistics.
> 
> Given that the kernel has significantly more data structure space to parse and that there has to be some locking interaction to get this data, it is not unusual for the parsing to take longer. However we were alarmed with the significant increase in overhead and wanted to make people aware of this.
> 
> Supporting Data
> ---------------
> 
> Mimicking a day of capture at 10 second intervals gives us 8640 reads of /proc/stat
> 
> I wanted to first validate if this was architecture or kernel behavior and it is actually kernel overhead on the 2.6.3x and higher kernels. I tested with 2.6.38 but the same applies for the RHEL 6 and SLES 11 2.6.32.x kernels.
> 
> Same architecture, just different kernels for my testing.
> 
> The newer kernel is around 100 times slower so it shows up in collectl behavior.
> 
> DL785 8-node NUMA with 128GB memory and 32 CPU'S.
> 
> l785sles:/sys/devices/system/node # ls
> node0  node1  node2  node3  node4  node5  node6  node7 dl785sles:/sys/devices/system/node # pwd
> /sys/devices/system/node   
> 
> On the 2.6.16.x series sles or 2.6.18.x RHEL kernels each read takes 84 us.
> 
> dl785sles:~/wrk # cat 2.6.16.60-0.87.1-smp.log Opened, read and closed 8640 times and read total of 13996800 bytes
> % time     seconds  usecs/call     calls    errors syscall
> ------ ----------- ----------- --------- --------- ----------------
>  99.41    0.725717          84      8641           read
>   0.38    0.002768           0      8642           open
>   0.21    0.001539           0      8642           close
>   0.00    0.000000           0         1           write
>   0.00    0.000000           0         3           fstat
>   0.00    0.000000           0         8           mmap
>   0.00    0.000000           0         2           mprotect
>   0.00    0.000000           0         1           munmap
>   0.00    0.000000           0         1           brk
>   0.00    0.000000           0         1         1 access
>   0.00    0.000000           0         1           madvise
>   0.00    0.000000           0         1           execve
>   0.00    0.000000           0         1           arch_prctl
> ------ ----------- ----------- --------- --------- ----------------
> 100.00    0.730024                 25945         1 total    
> 
> On the 2.6.38.4 kernel each read takes > 6ms
> 
> dl785sles:~/wrk # cat 2.6.38.4-smp.log
> Opened, read and closed 8640 times and read total of 86235840 bytes
> % time     seconds  usecs/call     calls    errors syscall
> ------ ----------- ----------- --------- --------- ----------------
> 100.00   59.021650        6830      8641           read
>   0.00    0.000520           0      8642           open
>   0.00    0.000425           0      8642           close
>   0.00    0.000000           0         1           write
>   0.00    0.000000           0         3           fstat
>   0.00    0.000000           0         9           mmap
>   0.00    0.000000           0         2           mprotect
>   0.00    0.000000           0         1           munmap
>   0.00    0.000000           0         1           brk
>   0.00    0.000000           0         1         1 access
>   0.00    0.000000           0         1           madvise
>   0.00    0.000000           0         1           execve
>   0.00    0.000000           0         1           arch_prctl
> ------ ----------- ----------- --------- --------- ----------------
> 100.00   59.022595                 25946         1 total        
> 
> Test program 
> #include <stdio.h>
> #include <stdlib.h>
> #include <sys/types.h>
> #include <sys/stat.h>
> #include <asm-generic/fcntl.h>
> #include <sys/errno.h>
> 
> extern int errno;
> 
> int fid,i,count,total;
> char buffer[16384];
> 
> int main(int argc, char *argv[])
> {
> for (count=0;count<8640;count++) {
>         fid=open("/proc/stat",O_RDONLY,660);
>         if(fid <= 0) {
>          perror("error with file open\n");
>         }
>         i=read(fid,buffer,16384);
>         /* printf("Read %d characters \n",i); */
>         total+=i;
>         close(fid);
> }
> printf("Opened, read and closed %d times and read total of %d bytes\n",count,total);
> exit(0);
> }

Strange, here is what I have on my 2x4x2 machine.

Could you try following actions please ?

# perf record ./prog
Opened, read and closed 8640 times and read total of 29595948 bytes
[ perf record: Woken up 1 times to write data ]
[ perf record: Captured and wrote 0.057 MB perf.data (~2482 samples) ]

# perf report --stdio
# Events: 1K cycles
#
# Overhead  Command      Shared Object                        Symbol
# ........  .......  .................  ............................
#
    22.82%     prog  [kernel.kallsyms]  [k] format_decode
    21.15%     prog  [kernel.kallsyms]  [k] vsnprintf
    13.46%     prog  [kernel.kallsyms]  [k] number.isra.4
    11.33%     prog  [kernel.kallsyms]  [k] memcpy
     8.87%     prog  [kernel.kallsyms]  [k] kstat_irqs
     3.80%     prog  [kernel.kallsyms]  [k] radix_tree_lookup_element
     3.69%     prog  [kernel.kallsyms]  [k] seq_printf
     3.63%     prog  [kernel.kallsyms]  [k] find_next_bit
     2.81%     prog  [kernel.kallsyms]  [k] show_stat
     1.18%     prog  [kernel.kallsyms]  [k] put_dec_trunc
     0.96%     prog  [kernel.kallsyms]  [k] radix_tree_lookup
     0.96%     prog  [kernel.kallsyms]  [k] irq_to_desc
     0.66%     prog  [kernel.kallsyms]  [k] getname_flags
     0.37%     prog  [kernel.kallsyms]  [k] selinux_inode_alloc_security
     0.22%     prog  [kernel.kallsyms]  [k] jiffies_64_to_clock_t
     0.22%     prog  [kernel.kallsyms]  [k] copy_user_generic_string
     0.22%     prog  [kernel.kallsyms]  [k] __call_rcu
     0.15%     prog  [kernel.kallsyms]  [k] add_preempt_count
     0.15%     prog  [kernel.kallsyms]  [k] put_dec_full
     0.15%     prog  [kernel.kallsyms]  [k] nr_context_switches
     0.15%     prog  [kernel.kallsyms]  [k] kfree



