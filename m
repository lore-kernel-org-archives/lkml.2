Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752763Ab2LKHAj (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Dec 2012 02:00:39 -0500
Received: from mail-vb0-f46.google.com ([209.85.212.46]:50660 "EHLO
	mail-vb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751291Ab2LKHAh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Dec 2012 02:00:37 -0500
MIME-Version: 1.0
In-Reply-To: <CAFVn34SxqAJe_4P-WT8MOiG-kmKKD7ge96zoHXQuGqHWPgAt+A@mail.gmail.com>
References: <CAFVn34SxqAJe_4P-WT8MOiG-kmKKD7ge96zoHXQuGqHWPgAt+A@mail.gmail.com>
Date: Tue, 11 Dec 2012 15:00:36 +0800
X-Google-Sender-Auth: S2CjhuOLszIsHkkwBewFE8w1hxo
Message-ID: <CAFVn34Rq6=VjOvB8KHT-AMNo3WpyNFAKgXxWufQjDRDC0UCEDg@mail.gmail.com>
Subject: performance drop after using blkcg
From: Zhao Shuai <zhaoshuai@freebsd.org>
To: linux-kernel@vger.kernel.org, cgroups@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

I plan to use blkcg(proportional BW) in my system. But I encounter
great performance drop after enabling blkcg.

The testing tool is fio(version 2.0.7) and both the BW and IOPS fields
are recorded. Two instances of fio program are carried out simultaneously,
each opearting on a separate disk file (say /data/testfile1, /data/testfile2).

System environment:
kernel: 3.7.0-rc5
CFQ's slice_idle is disabled(slice_idle=0) while group_idle is
enabled(group_idle=8).

FIO configuration(e.g. "read") for the first fio program(say FIO1):

[global]
description=Emulation of Intel IOmeter File Server Access Pattern

[iometer]
bssplit=4k/30:8k/40:16k/30
rw=read
direct=1
time_based
runtime=180s
ioengine=sync
filename=/data/testfile1
numjobs=32
group_reporting


result before using blkcg: (the value of BW is KB/s)

           FIO1 BW/IOPS    FIO2 BW/IOPS
---------------------------------------
read       26799/2911      25861/2810
write      138618/15071    138578/15069
rw         72159/7838(r)   71851/7811(r)
           72171/7840(w)   71799/7805(w)
randread   4982/543        5370/585
randwrite  5192/566        6010/654
randrw     2369/258(r)     3027/330(r)
           2369/258(w)     3016/328(w)

result after using blkcg(create two blkio cgroups with
default blkio.weight(500) and put FIO1 and FIO2 into these
cgroups respectively)

           FIO1 BW/IOPS    FIO2 BW/IOPS
---------------------------------------
read       36651/3985      36470/3943
write      75738/8229      75641/8221
rw         49169/5342(r)   49168/5346(r)
           49200/5348(w)   49140/5341(w)
randread   4876/532        4905/534
randwrite  5535/603        5497/599
randrw     2521/274(r)     2527/275(r)
           2510/273(w)     2532/274(w)

Comparing with those results, we found greate performance drop
(30%-40%) in some test cases(especially for the "write", "rw" case).
Is it normal to see write/rw bandwidth decrease by 40% after using
blkio-cgroup? If not, any way to improve or tune the performace?

Thanks.

--
Regards,
Zhao Shuai
