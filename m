Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754691Ab1FDI3c (ORCPT <rfc822;w@1wt.eu>);
	Sat, 4 Jun 2011 04:29:32 -0400
Received: from smtprelay06.ispgateway.de ([80.67.31.104]:49678 "EHLO
	smtprelay06.ispgateway.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754436Ab1FDI3a (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 4 Jun 2011 04:29:30 -0400
X-Greylist: delayed 344 seconds by postgrey-1.27 at vger.kernel.org; Sat, 04 Jun 2011 04:29:30 EDT
Message-ID: <20110604102343.113667vdxn02i4ws@webmail.df.eu>
Date: Sat, 04 Jun 2011 10:23:43 +0200
From: Martin Baum <pop3@flachtaucher.de>
To: linux-kernel@vger.kernel.org
Subject: cgroups: Assigning tasks to a cgroup slow and does not scale
MIME-Version: 1.0
Content-Type: text/plain;
 charset=UTF-8;
 DelSp="Yes";
 format="flowed"
Content-Disposition: inline
Content-Transfer-Encoding: 7bit
User-Agent: domainFACTORY
X-Originating-IP: 80.67.16.214
X-Df-Sender: 536411
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

assigning a task to new cgroup takes an unexpected high amount of time  
on my system - about 0.05s. Strangely it does it does not scale with  
more processes: When I run 10 processes that do nothing but change  
their cgroups each cgroup change takes about 0.5 seconds while CPU  
usage remains very low. So my system maxes out at 20 cgroup changes  
per second while cpu and disk usage remain minimal (according to top).  
Is this expected behaviour?

It is a problem for me: I run a daemon that forks and calls suid for  
each request. I want to assign each of these forks to a different  
cgroup. However this currently kills performance going down from >100  
req/sec to about 20 req/sec.


Here is my test case:

cat > test_cgroup.sh <<EOF
#!/bin/bash
mkdir /tmp/cg
mount -t cgroup none -o cpuacct /tmp/cg
mkdir /tmp/cg/test
while /bin/true; do
   time (/bin/echo \$\$ > /tmp/cg/test/tasks)
   time (/bin/echo \$\$ > /tmp/cg/tasks)
done;
EOF


Start test:

bash ./test_cgroup.sh &  <--- execute this 10 times and watch the time  
reports go up to 0.5sec

I already tested this with a different controller (cpuset): Same  
result. I tried different kernel configurations relating to cgroup -  
no success. I also tried 2.6.32.40 - same result.

What is confusing me most is that disk and cpu usage remains low  
during the test. Maybe this is related to locking?


My system:

Linux testserver 2.6.39.1 #1 SMP Sat Jun 4 09:21:40 CEST 2011 i686  
Intel(R) Core(TM)2 Duo CPU E7500 @ 2.93GHz GenuineIntel GNU/Linux


Kernel is vanilla source. Relevant part of .config:

$ grep -i cgroup .config
CONFIG_CGROUPS=y
# CONFIG_CGROUP_DEBUG is not set
# CONFIG_CGROUP_NS is not set
CONFIG_CGROUP_FREEZER=y
# CONFIG_CGROUP_DEVICE is not set
CONFIG_CGROUP_CPUACCT=y
# CONFIG_CGROUP_MEM_RES_CTLR is not set
# CONFIG_CGROUP_PERF is not set
# CONFIG_CGROUP_SCHED is not set
# CONFIG_BLK_CGROUP is not set



best regards,
Martin


