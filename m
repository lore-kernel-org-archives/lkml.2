Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756773Ab1JMXoV (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Oct 2011 19:44:21 -0400
Received: from g1t0028.austin.hp.com ([15.216.28.35]:10367 "EHLO
	g1t0028.austin.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752717Ab1JMXoU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Oct 2011 19:44:20 -0400
From: "Oberman, Laurence (HAS GSE)" <Laurence.Oberman@hp.com>
To: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
CC: "Seger, Mark" <mark.seger@hp.com>,
        "Cabaniols, Sebastien" <Sebastien.Cabaniols@hp.com>
Date: Fri, 14 Oct 2011 00:40:14 +0100
Subject: Regression in reading /proc/stat in the newer kernels with large
 SMP and NUMA configurations
Thread-Topic: Regression in reading /proc/stat in the newer kernels with
 large SMP and NUMA configurations
Thread-Index: AcyKAXT+sErt2/ntSnqTH9JKaA+OWw==
Message-ID: <8DC664164FA4D1449479E7B36CDCFB1F221E724322@GVW0676EXC.americas.hpqcorp.net>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
acceptlanguage: en-US
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by nfs id p9DNiVpv015503

Hello,

The HP developed collectl utility depends heavily on abstractions in /proc and /sys provided by the kernel for kernel statistics capture.
During testing on newer NUMA platforms with large numbers of CPUâ€™S HP has observed a significant increase in the time taken to parse this data with the newer 2.6.32.x and higher kernels.

In summary:

To read the data for a DL785 8-node NUMA with 4 CPUâ€™S per node takes around 80 microseconds per read on the 2.6.18.x kernels, but when testing on the same platform with the newer 2.6.32.x and higher kernels each read takes more than 5 ms. This is significant when considering that collectl typically collects the data abstraction in the kernel every 10 seconds (default) for certain statistics.

Given that the kernel has significantly more data structure space to parse and that there has to be some locking interaction to get this data, it is not unusual for the parsing to take longer. However we were alarmed with the significant increase in overhead and wanted to make people aware of this.

Supporting Data
---------------

Mimicking a day of capture at 10 second intervals gives us 8640 reads of /proc/stat

I wanted to first validate if this was architecture or kernel behavior and it is actually kernel overhead on the 2.6.3x and higher kernels. I tested with 2.6.38 but the same applies for the RHEL 6 and SLES 11 2.6.32.x kernels.

Same architecture, just different kernels for my testing.

The newer kernel is around 100 times slower so it shows up in collectl behavior.

DL785 8-node NUMA with 128GB memory and 32 CPU'S.

l785sles:/sys/devices/system/node # ls
node0  node1  node2  node3  node4  node5  node6  node7 dl785sles:/sys/devices/system/node # pwd
/sys/devices/system/node   

On the 2.6.16.x series sles or 2.6.18.x RHEL kernels each read takes 84 us.

dl785sles:~/wrk # cat 2.6.16.60-0.87.1-smp.log Opened, read and closed 8640 times and read total of 13996800 bytes
% time     seconds  usecs/call     calls    errors syscall
------ ----------- ----------- --------- --------- ----------------
 99.41    0.725717          84      8641           read
  0.38    0.002768           0      8642           open
  0.21    0.001539           0      8642           close
  0.00    0.000000           0         1           write
  0.00    0.000000           0         3           fstat
  0.00    0.000000           0         8           mmap
  0.00    0.000000           0         2           mprotect
  0.00    0.000000           0         1           munmap
  0.00    0.000000           0         1           brk
  0.00    0.000000           0         1         1 access
  0.00    0.000000           0         1           madvise
  0.00    0.000000           0         1           execve
  0.00    0.000000           0         1           arch_prctl
------ ----------- ----------- --------- --------- ----------------
100.00    0.730024                 25945         1 total    

On the 2.6.38.4 kernel each read takes > 6ms

dl785sles:~/wrk # cat 2.6.38.4-smp.log
Opened, read and closed 8640 times and read total of 86235840 bytes
% time     seconds  usecs/call     calls    errors syscall
------ ----------- ----------- --------- --------- ----------------
100.00   59.021650        6830      8641           read
  0.00    0.000520           0      8642           open
  0.00    0.000425           0      8642           close
  0.00    0.000000           0         1           write
  0.00    0.000000           0         3           fstat
  0.00    0.000000           0         9           mmap
  0.00    0.000000           0         2           mprotect
  0.00    0.000000           0         1           munmap
  0.00    0.000000           0         1           brk
  0.00    0.000000           0         1         1 access
  0.00    0.000000           0         1           madvise
  0.00    0.000000           0         1           execve
  0.00    0.000000           0         1           arch_prctl
------ ----------- ----------- --------- --------- ----------------
100.00   59.022595                 25946         1 total        

Test program 
#include <stdio.h>
#include <stdlib.h>
#include <sys/types.h>
#include <sys/stat.h>
#include <asm-generic/fcntl.h>
#include <sys/errno.h>

extern int errno;

int fid,i,count,total;
char buffer[16384];

int main(int argc, char *argv[])
{
for (count=0;count<8640;count++) {
        fid=open("/proc/stat",O_RDONLY,660);
        if(fid <= 0) {
         perror("error with file open\n");
        }
        i=read(fid,buffer,16384);
        /* printf("Read %d characters \n",i); */
        total+=i;
        close(fid);
}
printf("Opened, read and closed %d times and read total of %d bytes\n",count,total);
exit(0);
}

Thanks
Laurence Oberman
ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éÝ¶¥Šwÿº{.nÇ+‰·¥Š{±þG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŽŠÝ¢j"ú¶m§ÿÿ¾«þG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
