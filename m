Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755268Ab1KWVAH (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Nov 2011 16:00:07 -0500
Received: from zougloub.eu ([188.165.233.99]:41060 "EHLO zougloub.eu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752535Ab1KWVAG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Nov 2011 16:00:06 -0500
X-Greylist: delayed 434 seconds by postgrey-1.27 at vger.kernel.org; Wed, 23 Nov 2011 16:00:06 EST
Date: Wed, 23 Nov 2011 15:52:43 -0500
From: =?UTF-8?B?SsOpcsO0bWU=?= Carretero <cJ-ko@zougloub.eu>
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Cc: tglx@linutronix.de
Subject: Q: Process creation and soft hot CPU affinity
Message-ID: <20111123155243.46421a6d@Bidule>
Organization: CS Communications & =?UTF-8?B?U3lzdMOobWVz?= Canada Inc.
X-Mailer: Claws Mail 3.7.10 (GTK+ 2.24.3; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

I noticed something this night.
The process executions during a ./configure get spread among all the machine CPUs.
When launching processes sequentially, why aren't they put to run on the same CPU ?
I naively assume that the CPU has just finished its work and it's "hot".
The others could continue resting in their C-states/P-states, or whatever.

To measure the performance impact of the current scheduling choices, I ran a little benchmark.
I ran a time ./configure with/without cgroup CPU affinity and got significant difference.

benchmark_setup() {
  cgrp=1cpu
  ncpus=8
  cgroup_mnt=/sys/fs/cgroup
  coreutils_tar=/var/paludis/distfiles/coreutils-8.13.tar.xz

  mkdir -p $cgroup_mnt/$cgrp
  echo 0 > $cgroup_mnt/$cgrp/cpuset.mems
  echo $$ > $cgroup_mnt/$cgrp/tasks

  cd /dev/shm
}

benchmark() {
  tar xf $coreutils_tar

  pushd coreutils* > /dev/null
  echo $* > $cgroup_mnt/$cgrp/cpuset.cpus
  echo 3 > /proc/sys/vm/drop_caches
  time sh ./configure > /dev/null
  popd > /dev/null

  rm -rf coreutils*
}

benchmark 0
benchmark $(cat $cgroup_mnt/cpuset.cpus)

Results:

with affinity to 1CPU:
real    0m40.229s
user    0m15.222s
sys     0m9.409s

with affinity to all CPUs:
real    1m20.832s
user    0m31.089s
sys     0m37.582s

Is there something that can be done ?
I just want to start a discussion on this matter, perhaps I'll play with the scheduler if I get a few hints.

Regards,

-- 
cJ
3.2.0-rc2-Bidule-00400-g866d43c #1 SMP PREEMPT Tue Nov 22 13:51:00 EST 2011 x86_64
