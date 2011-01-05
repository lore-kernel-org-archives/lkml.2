Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751400Ab1AEEyz (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Jan 2011 23:54:55 -0500
Received: from mail-qy0-f174.google.com ([209.85.216.174]:42538 "EHLO
	mail-qy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751150Ab1AEEyy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Jan 2011 23:54:54 -0500
Date: Tue, 4 Jan 2011 23:54:47 -0500
From: Nelson Elhage <nelhage@ksplice.com>
To: Paul Menage <menage@google.com>, Li Zefan <lizf@cn.fujitsu.com>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>, linux-kernel@vger.kernel.org
Subject: cgroup scheduling: Adding kthreadd to a non-RT cgroup can deadlock
 the kernel
Message-ID: <20110105045447.GN23414@ksplice.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

I've found a bug where, on CONFIG_RT_GROUP_SCHED systems, adding the kthreadd
task to a cgroup with cpu.rt_runtime_us = 0 (as some cgroup configuration
scripts do, when they move all processes into a default cgroup), can result in
deadlocks in the kernel.

On 2.6.37, the problem can be triggered via CPU hotplug. The following sequence
of events will deadlock on an SMP system:

1. Add kthreadd to a cpu cgroup with rt_runtime_us = 0
2. echo 0 > /sys/devices/system/cpu/cpu1/online
3. echo 1 > /sys/devices/system/cpu/cpu1/online
4. echo 0 > /sys/devices/system/cpu/cpu1/online
5. echo 1 > /sys/devices/system/cpu/cpu1/online

In line (3), the CPU hotplug will cause us to create a new ksoftirqd/1
thread. Since that thread is forked from kthreadd, it will end up in the same
cgroup, also without any realtime access.

In step (4), cpu_callback in softirq.c will attempt to kill ksoftirqd by setting
it to SCHED_FIFO and using kthread_stop(). It does this with
'sched_setscheduler_nocheck', which bypasses the usual checks that prevent
setting a process to an SCHED_FIFO if it is in a cgroup that would prevent it
from running.

Thus, ksoftirqd ends up at SCHED_FIFO but with a zero rt_runtime_us, and is
never scheduled again, and kthread_stop blocks waiting on it.

In (5), we try to call the CPU notifier chain again, but it is still locked from
(4), and we deadlock.

For reasons I don't fully understand, just adding ksoftirqd/1 to a cgroup and
then taking CPU 1 offline doesn't result in a hang, so I think there may be some
detail of this situation I don't fully understand, but I'm pretty confident in
the general analysis.

Before 2.6.34, we can trigger a similar problem just by adding kthreadd to a
cgroup and then calling stop_machine (e.g. by removing a module), since
stop_machine created a new RT workqueue on each invocation. This is how I first
found this problem: https://bugs.launchpad.net/ubuntu/+source/linux/+bug/693594

- Nelson
