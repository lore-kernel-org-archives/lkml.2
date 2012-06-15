Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757057Ab2FOO0F (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Jun 2012 10:26:05 -0400
Received: from dgate20.ts.fujitsu.com ([80.70.172.51]:64539 "EHLO
	dgate20.ts.fujitsu.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754780Ab2FOO0D (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Jun 2012 10:26:03 -0400
X-Greylist: delayed 599 seconds by postgrey-1.27 at vger.kernel.org; Fri, 15 Jun 2012 10:26:02 EDT
DomainKey-Signature: s=s1536a; d=ts.fujitsu.com; c=nofws; q=dns;
  h=X-SBRSScore:X-IronPort-AV:Received:X-IronPort-AV:
   Received:Message-ID:Date:From:Organization:User-Agent:
   MIME-Version:To:CC:Subject:X-Enigmail-Version:
   Content-Type:Content-Transfer-Encoding;
  b=Y1HrIhxP+2psw7B6BVLd4fu+AL0fCC2Nb9cVFreoD/KR7lycSpgQcfyV
   EOEwsuBiYN30xNchZh1vVHHODBcmoGk0y4Bw6DclpeueNeiFIfoGzvxdc
   P3oKvx2SnKrU7qc1TjAbMn+ywhoHCRFaOkb5vo46FDeaySDaLdvdO3+QK
   7iCYJU0C/Q08rAQ4/bqBZa9h3qcULakGU7NJE5xZXu93XT5kPAxSm8GH7
   AgkvbjlFVjZrXgzwFEjebLkw5jxug;
X-SBRSScore: None
X-IronPort-AV: E=Sophos;i="4.75,778,1330902000"; 
   d="scan'208";a="96101970"
X-IronPort-AV: E=Sophos;i="4.75,778,1330902000"; 
   d="scan'208";a="136241575"
Message-ID: <4FDB4253.90102@ts.fujitsu.com>
Date: Fri, 15 Jun 2012 16:10:27 +0200
From: Martin Wilck <martin.wilck@ts.fujitsu.com>
Organization: Fujitsu Technology Solutions
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:12.0) Gecko/20120430 Thunderbird/12.0.1
MIME-Version: 1.0
To: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
CC: mhocko@suse.cz
Subject: linux 3.4.2: Strange readings in /proc/stat with NO_HZ and softirq
 activity
X-Enigmail-Version: 1.4.1
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

I am seeing the following weird behavior of /proc/stat with 3.4.2 and NO_HZ.

I expect that the sum of all counters for each cpu advances by 100 every
second in /proc/stat (please forgive my ignorance if that expectation is
incorrect).

I am running the fio benchmark (http://freecode.com/projects/fio) with a
load that is trying to generate a lot of IOP/s (job file below), and I
look at /proc/stat before and after the test. I am running on a 4-socket
10-core machine (80 CPUs total with HT). The problem is best
demonstrated in the case with 160 threads running on CPUs 0-39, 40-79
being idle. (I might as well choose any other 40 CPUs).

For the idle CPUs, the stats look like this, as expected (30s run):

cpu40: 1 0 3 3030 0 0 0 0 0 total=3034
cpu41: 0 0 0 3040 0 0 0 0 0 total=3040

(these lines show the changes in the CPU stats before/after the run; the
"total" number is the sum of all columns)

But I am seeing strange things going on for the busy CPUs:

cpu10: 0 0 27 38 0 0 2978 0 0 total=3043
cpu18: 14 0 2075 39 913 0 0 0 0 total=3041
cpu19: 14 0 2077 39 914 0 0 0 0 total=3044
cpu20: 9 0 1014 56 826 0 153 0 0 total=2058   <==
cpu21: 8 0 1011 56 826 0 148 0 0 total=2049   <==

CPUs that show some activity in the "softirq" column (7th number) have a
"total" that is low by ~1000 ticks (3000 are expected). The notable
exception is CPU 10 which seems to be running ksoftirqd all the time
during the test.

This doesn't happen with nohz=off, suggesting that there's some problem
accounting for softirq time in nohz mode.

Any ideas?
Martin


PS: Here is my fio job file:
[global]
directory=/mnt/fio1
group_reporting
size=16M
runtime=30
time_based
direct=1
cpus_allowed=0-39
[file1]
rw=randread
bs=4k
numjobs=160


Here is the full output of changes in /proc/stat:

cpu: 493 0 49319 123193 32506 0 7598 0 0 total=213109
cpu0: 5 0 978 50 705 0 174 0 0 total=1912
cpu1: 7 0 996 54 799 0 170 0 0 total=2026
cpu2: 10 0 975 58 791 0 172 0 0 total=2006
cpu3: 10 0 997 41 806 0 150 0 0 total=2004
cpu4: 7 0 987 49 799 0 142 0 0 total=1984
cpu5: 7 0 993 58 801 0 174 0 0 total=2033
cpu6: 6 0 1010 56 804 0 143 0 0 total=2019
cpu7: 8 0 1000 53 805 0 138 0 0 total=2004
cpu8: 8 0 973 53 801 0 166 0 0 total=2001
cpu9: 9 0 987 59 799 0 166 0 0 total=2020
cpu10: 0 0 27 38 0 0 2978 0 0 total=3043
cpu11: 15 0 2072 39 907 0 0 0 0 total=3033
cpu12: 19 0 2087 38 902 0 0 0 0 total=3046
cpu13: 19 0 2084 38 922 0 0 0 0 total=3063
cpu14: 23 0 2089 39 901 0 0 0 0 total=3052
cpu15: 19 0 2076 39 911 0 0 0 0 total=3045
cpu16: 17 0 2088 39 912 0 0 0 0 total=3056
cpu17: 17 0 2084 38 907 0 0 0 0 total=3046
cpu18: 14 0 2075 39 913 0 0 0 0 total=3041
cpu19: 14 0 2077 39 914 0 0 0 0 total=3044
cpu20: 9 0 1014 56 826 0 153 0 0 total=2058
cpu21: 8 0 1011 56 826 0 148 0 0 total=2049
cpu22: 8 0 1015 58 819 0 169 0 0 total=2069
cpu23: 9 0 1035 53 832 0 148 0 0 total=2077
cpu24: 8 0 1026 57 825 0 170 0 0 total=2086
cpu25: 10 0 1014 55 827 0 148 0 0 total=2054
cpu26: 12 0 1008 56 824 0 165 0 0 total=2065
cpu27: 8 0 1032 52 828 0 139 0 0 total=2059
cpu28: 10 0 1037 52 830 0 136 0 0 total=2065
cpu29: 10 0 1029 52 831 0 136 0 0 total=2058
cpu30: 10 0 1012 63 812 0 142 0 0 total=2039
cpu31: 8 0 1013 70 811 0 142 0 0 total=2044
cpu32: 10 0 1001 69 804 0 186 0 0 total=2070
cpu33: 12 0 999 68 812 0 160 0 0 total=2051
cpu34: 10 0 1008 69 809 0 167 0 0 total=2063
cpu35: 12 0 1020 64 815 0 127 0 0 total=2038
cpu36: 13 0 1004 69 809 0 151 0 0 total=2046
cpu37: 10 0 1011 66 816 0 148 0 0 total=2051
cpu38: 14 0 1003 65 815 0 137 0 0 total=2034
cpu39: 8 0 1012 67 814 0 147 0 0 total=2048
cpu40: 1 0 3 3030 0 0 0 0 0 total=3034
cpu41: 0 0 0 3040 0 0 0 0 0 total=3040
cpu42: 0 0 2 3037 1 0 1 0 0 total=3041
cpu43: 1 0 10 3029 0 0 1 0 0 total=3041
cpu44: 0 0 0 3044 0 0 0 0 0 total=3044
cpu45: 0 0 6 3036 0 0 0 0 0 total=3042
cpu46: 6 0 1 3037 0 0 0 0 0 total=3044

[...] boring below here


-- 
Dr. Martin Wilck
PRIMERGY System Software Engineer
x86 Server Engineering

FUJITSU
Fujitsu Technology Solutions GmbH
Heinz-Nixdorf-Ring 1
33106 Paderborn, Germany
Phone:			++49 5251 525 2796
Fax:			++49 5251 525 2820
Email:			martin.wilck@ts.fujitsu.com
Internet:		http://ts.fujitsu.com
Company Details:	http://ts.fujitsu.com/imprint
