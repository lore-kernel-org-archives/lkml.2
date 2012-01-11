Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757435Ab2AKK2Q (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Jan 2012 05:28:16 -0500
Received: from dgate20.ts.fujitsu.com ([80.70.172.51]:34075 "EHLO
	dgate20.ts.fujitsu.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756622Ab2AKK2L convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Jan 2012 05:28:11 -0500
X-Greylist: delayed 603 seconds by postgrey-1.27 at vger.kernel.org; Wed, 11 Jan 2012 05:28:11 EST
DomainKey-Signature: s=s1536a; d=ts.fujitsu.com; c=nofws; q=dns;
  h=X-SBRSScore:X-IronPort-AV:Received:Received:From:To:Date:
   Subject:Thread-Topic:Thread-Index:Message-ID:
   Accept-Language:Content-Language:X-MS-Has-Attach:
   X-MS-TNEF-Correlator:acceptlanguage:Content-Type:
   Content-Transfer-Encoding:MIME-Version;
  b=t1wrmX0WXamlfWfDDbQSGoM1X6xq8ovGRvK5ub3OcxdG46xYDOEzl+8V
   o+G1bkn0De7c0ssTkzLLujgYKnfLS4tsI6pa4gEosN5pOa/ZP8RpSGBFd
   C8Fn4kPKOajGyl6aM7+vrGVv6HuPx3xshPjBT08qDFAvScNZeKl9eraDK
   KWPrRHAuPQuJvIICqiKeLb91+sOoRkLJ52CS/SPMcdjRILYg/L2RpVx2i
   esLSqfwJ+WU4B0tEXdoVQ5JJdo+xn;
X-SBRSScore: None
X-IronPort-AV: E=Sophos;i="4.71,492,1320620400"; 
   d="scan'208";a="83128020"
From: "Borzenkov, Andrey" <andrey.borzenkov@ts.fujitsu.com>
To: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Date: Wed, 11 Jan 2012 11:18:01 +0100
Subject: Extermeley large PageTables over 500G on kernel 2.6.32.49 (SLES11
 SP1)
Thread-Topic: Extermeley large PageTables over 500G on kernel 2.6.32.49
 (SLES11 SP1)
Thread-Index: AczQSkxBxFSP4MwhRqCBX9rNuHEgLA==
Message-ID: <CB1B361E45A85849902B25342E88900501CFDC3110D6@ABGEX70E.FSC.NET>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
acceptlanguage: en-US
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I try to understand whether what I see is a bug in kernel (may be in accounting) or some other problem.

Server with 1TB memory (slightly less due to 2 DIMMs disabled) running SLES11 SP1:

Linux rx900-01 2.6.32.49-0.3-default #1 SMP 2011-12-02 11:28:04 +0100 x86_64 x86_64 x86_64 GNU/Linux

Server runs Oracle database and SAP central instance. Oracle SGA is ~500GB; there are over 2000 oracle client processes (connection from dialog instances).

Second time server experienced slowdown. CPU goes near to 100% system; in SAR statistic from yesterday

00:00:01        CPU     %user     %nice   %system   %iowait    %steal     %idle
14:20:01        all      8.37      0.00      1.50      8.32      0.00     81.82
14:30:01        all      9.76      0.00     11.91      9.53      0.00     68.80
14:40:02        all      7.73      0.00     14.94      8.35      0.00     68.98
14:50:01        all      4.46      0.00     64.24      4.71      0.00     26.60
15:04:10        all      3.92      0.00     71.64      3.91      0.00     20.53
15:14:06        all      4.26      0.06     73.70      3.75      0.00     18.22
15:21:43        all      5.80      0.00     58.29      6.39      0.00     29.51
15:33:13        all      0.57      0.00     98.44      0.22      0.00      0.77
15:40:01        all      2.11      0.00     92.75      1.38      0.00      3.76
15:53:05        all      4.65      0.00     67.29      4.62      0.00     23.43
16:00:02        all      0.22      0.00     99.73      0.01      0.00      0.03
16:10:01        all      6.77      0.00     62.23      5.45      0.00     25.55
16:22:36        all      1.09      0.00     96.75      0.60      0.00      1.56
16:35:00        all      1.00      0.00     98.32      0.23      0.00      0.46


14:00:01     70890.08  32610.94 293683.34      0.66 302353.74   1511.70      0.00    553.15     36.59
14:10:01     62785.00  41756.85 248404.91      1.39 262783.25    526.27      0.00     13.80      2.62
14:20:01     45202.79  14421.25 247825.24      0.57 263555.49      0.00      0.00      0.00      0.00
14:30:01     55258.89  19961.76 320001.06      6.67 292015.15   4642.89    421.42   1939.95     38.31
14:40:02     39944.66  13820.21 265597.61     18.52 225282.13   3609.07    827.76    983.08     22.16
14:40:02     pgpgin/s pgpgout/s   fault/s  majflt/s  pgfree/s pgscank/s pgscand/s pgsteal/s    %vmeff
14:50:01     32186.97   6173.29 290924.86     18.14 159640.32    320.29   1047.12    357.74     26.16
15:04:10     21821.44   5088.61 204284.90      8.49 136538.28    167.06   1166.24    320.86     24.06
15:14:06     26446.08  10471.94 210644.97     13.09 134230.69    704.49   1810.80    790.93     31.44
15:21:43     39126.74   7556.64 342544.63     31.48 180565.12    285.73   1354.19    451.70     27.54
15:33:13      2796.56   2909.25  47558.06      8.24  22382.27     88.62   2052.66    531.01     24.80
15:40:01      6200.17   5969.42 161088.56     21.97  42077.69    120.03   1832.63    438.99     22.48
15:53:05     23803.80   9406.65 258179.22     60.35 118982.69    211.06   1679.50    512.08     27.09
16:00:02       728.41   3156.68  16022.08      3.30   6382.78     88.78   2142.13    653.90     29.31
16:10:01     27009.53   8949.01 330194.26    142.67 126540.73    209.47   1883.92    735.54     35.14
16:22:36      2546.53   4279.80  64544.54     14.25  17826.19    148.21   2405.98    840.27     32.90
16:35:00      2038.20   4231.65  61680.28     19.28  19653.35    114.72   2416.81    936.73     37.00


Just got info about the same situation; looking at /proc/meminfo:

MemTotal:       992606568 kB
MemFree:          209064 kB
Buffers:            8144 kB
Cached:         435401824 kB
SwapCached:      1098968 kB
Active:         440527496 kB
Inactive:       13550356 kB
Active(anon):   440436992 kB
Inactive(anon): 13467304 kB
Active(file):      90504 kB
Inactive(file):    83052 kB
Unevictable:         124 kB
Mlocked:               0 kB
SwapTotal:      292421588 kB
SwapFree:       290932124 kB
Dirty:                32 kB
Writeback:            32 kB
AnonPages:      17599492 kB
Mapped:         434635928 kB
Shmem:          435236256 kB
Slab:            2423828 kB
SReclaimable:    1957952 kB
SUnreclaim:       465876 kB
KernelStack:       39536 kB
PageTables:     519555856 kB
NFS_Unstable:          0 kB
Bounce:                0 kB
WritebackTmp:          0 kB
CommitLimit:    788724872 kB
Committed_AS:   514649400 kB
VmallocTotal:   34359738367 kB
VmallocUsed:     3662244 kB
VmallocChunk:   33484035568 kB
HardwareCorrupted:     0 kB
HugePages_Total:       0
HugePages_Free:        0
HugePages_Rsvd:        0
HugePages_Surp:        0
Hugepagesize:       2048 kB
DirectMap4k:       22528 kB
DirectMap2M:     2058240 kB
DirectMap1G:    1004535808 kB


What can be the reason for system consuming half of physical memory for page tables?


---
With best regards

Andrey Borzenkov

