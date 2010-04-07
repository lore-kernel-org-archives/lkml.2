Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754980Ab0DGLN0 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Apr 2010 07:13:26 -0400
Received: from mx1.gb1.humyo.com ([62.44.71.171]:60176 "EHLO mx1.gb1.humyo.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751617Ab0DGLNZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Apr 2010 07:13:25 -0400
X-Greylist: delayed 576 seconds by postgrey-1.27 at vger.kernel.org; Wed, 07 Apr 2010 07:13:25 EDT
Message-ID: <4BBC6719.7080304@humyo.com>
Date: Wed, 07 Apr 2010 12:06:01 +0100
From: John Berthels <john@humyo.com>
User-Agent: Thunderbird 2.0.0.24 (X11/20100317)
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org
CC: Nick Gregory <nick@humyo.com>, Rob Sanderson <rob@humyo.com>
Subject: PROBLEM + POSS FIX: kernel stack overflow, xfs, many disks, heavy
 write load, 8k stack, x86-64
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi folks,

[I'm afraid that I'm not subscribed to the list, please cc: me on any 
reply].

Problem: kernel.org 2.6.33.2 x86_64 kernel locks up under write-heavy 
I/O load. It is "fixed" by changing THREAD_ORDER to 2.

Is this an OK long-term solution/should this be needed? As far as I can 
see from searching, there is an expectation that xfs would generally 
work with 8k stacks (THREAD_ORDER 1). We don't have xfs stacked over LVM 
or anything else.

If anyone can offer any advice on this, that would be great. I 
understand larger kernel stacks may introduce problems in getting an 
allocation of the appropriate size. So am I right in thinking the 
symptom we need to look out for would be an error on fork() or clone()? 
Or will the box panic in that case?

Details below.

regards,

jb


Background: We have a cluster of systems with roughly the following 
specs (2GB RAM, 24 (twenty-four) 1TB+ disks, Intel Core2 Duo @ 2.2GHz).

Following a the addition of three new servers to the cluster, we started 
seeing a high incidence of intermittent lockups (up to several times per 
day for some servers) across both the old and new servers. Prior to 
that, we saw this problem only rarely (perhaps once per 3 months).

Adding the new servers will have changed the I/O patterns to all 
servers. The servers receive a heavy write load, often with many slow 
writers (as well as a read load).

Servers would become unresponsive, with nothing written to 
/var/log/messages. Setting sysctl kernel.panic=300 caused a restart 
(which showed the kernel was panicing and unable to write at the time). 
netconsole showed a variety of stack traces, mostly related to xfs_write 
activity (but then, that's what the box spends it's time doing).

22/24 of the disks have 1 partition, formatted with xfs (over the 
partition, not over LVM). The other 2 disks have 3 partitions: xfs data, 
swap and a RAID1 partition contributing to an ext3 root filesystem 
mounted on /dev/md0.

We have tried various solutions (different kernels from ubuntu server 
2.6.28->2.6.32).

Vanilla 2.6.33.2 from kernel.org + stack tracing still has the problem, 
and logged:

kernel: [58552.740032] flush-8:112 used greatest stack depth: 184 bytes left

a short while before dying.

Vanilla 2.6.33.2 + stack tracing + THREAD_ORDER 2 is much more stable 
(no lockups so far, we would have expected 5-6 by now) and has logged:

kernel: [44798.183507] apache2 used greatest stack depth: 7208 bytes left

which I understand (possibly wrongly) as concrete evidence that we have 
exceeded 8k of stack space.

