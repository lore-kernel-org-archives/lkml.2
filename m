Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752345Ab0LFJGT (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Dec 2010 04:06:19 -0500
Received: from lav-w.yar.ru ([193.233.48.101]:39242 "EHLO
	localhost.localdomain" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752261Ab0LFJGR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Dec 2010 04:06:17 -0500
Date: Mon, 6 Dec 2010 12:06:03 +0300
From: "Alexander V. Lukyanov" <lav@netis.ru>
To: linux-kernel@vger.kernel.org
Subject: strange cache reclaim and swap
Message-ID: <20101206090603.GA13779@lw.yar.ru>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello!

I have noticed that linux discards disk cache when it is not really needed.
Here is vmstat trace:

 r  b   swpd   free   buff  cache   si   so    bi    bo   in   cs us sy id wa st
 1  0 150368  56112  46728 358512    0    0   832  1416 17460 18229 14 26 53  6  0
 1  1 150360  54284  46940 359472   12    0   672  2760 17488 18465 15 27 53  6  0
 0  0 150356  53292  47032 360504    0    0   312  2060 16735 20288 14 27 55  5  0
 1  2 150356  51216  47240 362364    0    0  1104  2984 17482 20538 16 27 45 13  0
 1  0 150352  49436  47356 364152    4    0   816  1484 17427 18354 15 26 50  8  0
 1  1 150344  46252  47628 367136    0    0  1076  1890 17445 21731 15 27 42 16  0
 0  0 150344  44268  47752 368916   16    0   776  1772 16639 16545 15 26 51  7  0
 0  0 150336  42056  47864 370580    4    0   784  3348 16501 16426 13 23 58  6  0
 0  2 150344  66196  46236 347336    0    8   276  3908 16305 17032 13 22 58  7  0
 0  0 150420 221500  37140 199684    4   84   976  1592 16626 16129 14 27 50  9  0
 1  0 150416 218972  37328 201736    0    0   704  1096 17801 16720 16 28 46 11  0
 0  0 152932 251020  34572 171656    4 2528   284  3592 18838 15565 17 27 46 12  0
 3  1 153728 258724  33612 165096    4  812   540  5448 17270 17582 15 26 48 11  0
 0  0 154300 269484  32716 155428    0  596  1084  2372 17050 14742 15 25 40 22  0
 1  0 154300 267348  32860 157520    0    0  1388  1768 17192 13229 17 26 46 10  0
 0  4 154256 264840  33024 159896   40    0  1652  1704 17324 17067 18 27 40 16  0

The strange thing is that it had freed 150M of cache and *then* swapped out
another 18M. Why? This happens regularly.

Another vmstat output:
 r  b   swpd   free   buff  cache   si   so    bi    bo   in   cs us sy id wa st
 0  0 152740 198420  32820 217080   52    0   620   852 17606 18243 17 25 50  9  0
 0  0 152720 194740  32892 219672    8    0   412   728 18256 19845 17 27 52  4  0
 1  1 152712 193352  32964 220948    4    0   692   332 15686 19272 15 31 47  8  0
 1  1 168064 240668  27628 178640  508 15804  7036 24344 144163 139061 14 26 45 15  0
 2  5 170152 259460  26380 160896  244 2216  1316 11656 19073 16941 15 31 21 34  0
 1  6 170584 263084  26096 157132  148  528  1044 31464 17949 16048 14 30 38 18  0
 1  1 170996 269560  25312 151652  264  500   936  1280 17594 19059 14 26 23 37  0

It started to swap when there are 190M of free memory! No big processes were
started at the time.

kernel version 2.6.34.7-61.fc13.x86_64 (fedora13).
Here is my /proc/meminfo:
MemTotal:        4023864 kB
MemFree:          132140 kB
Buffers:           38952 kB
Cached:           284568 kB
SwapCached:        46620 kB
Active:          2360084 kB
Inactive:         997628 kB
Active(anon):    2217764 kB
Inactive(anon):   819796 kB
Active(file):     142320 kB
Inactive(file):   177832 kB
Unevictable:           0 kB
Mlocked:               0 kB
SwapTotal:       8388604 kB
SwapFree:        8224428 kB
Dirty:             20416 kB
Writeback:             0 kB
AnonPages:       3010196 kB
Mapped:             5156 kB
Shmem:              3340 kB
Slab:             413676 kB
SReclaimable:     240068 kB
SUnreclaim:       173608 kB
KernelStack:        1392 kB
PageTables:         8488 kB
NFS_Unstable:          0 kB
Bounce:                0 kB
WritebackTmp:          0 kB
CommitLimit:    10400536 kB
Committed_AS:    3166880 kB
VmallocTotal:   34359738367 kB
VmallocUsed:      561196 kB
VmallocChunk:   34359125752 kB
HardwareCorrupted:     0 kB
HugePages_Total:       0
HugePages_Free:        0
HugePages_Rsvd:        0
HugePages_Surp:        0
Hugepagesize:       2048 kB
DirectMap4k:        9088 kB
DirectMap2M:     4149248 kB

-- 
   Alexander.
