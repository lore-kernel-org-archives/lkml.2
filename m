Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751453Ab1AEGCK (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Jan 2011 01:02:10 -0500
Received: from mailout-de.gmx.net ([213.165.64.23]:54836 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with SMTP
	id S1751251Ab1AEGCH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Jan 2011 01:02:07 -0500
X-Authenticated: #14349625
X-Provags-ID: V01U2FsdGVkX1/IfgBioBLIup7BwC/IIyPzF6W1Q7bXHXQ5BvoSkr
	7AkB2mMBrRnj7l
Subject: Re: cgroup scheduling: Adding kthreadd to a non-RT cgroup can
 deadlock the kernel
From: Mike Galbraith <efault@gmx.de>
To: Nelson Elhage <nelhage@ksplice.com>
Cc: Paul Menage <menage@google.com>, Li Zefan <lizf@cn.fujitsu.com>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>, linux-kernel@vger.kernel.org
In-Reply-To: <20110105045447.GN23414@ksplice.com>
References: <20110105045447.GN23414@ksplice.com>
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 05 Jan 2011 07:01:57 +0100
Message-ID: <1294207317.9384.33.camel@marge.simson.net>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.1.2 
Content-Transfer-Encoding: 7bit
X-Y-GMX-Trusted: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2011-01-04 at 23:54 -0500, Nelson Elhage wrote:
> Hi,

Greetings,

> I've found a bug where, on CONFIG_RT_GROUP_SCHED systems, adding the kthreadd
> task to a cgroup with cpu.rt_runtime_us = 0 (as some cgroup configuration
> scripts do, when they move all processes into a default cgroup), can result in
> deadlocks in the kernel.
> 
> On 2.6.37, the problem can be triggered via CPU hotplug. The following sequence
> of events will deadlock on an SMP system:
> 
> 1. Add kthreadd to a cpu cgroup with rt_runtime_us = 0
> 2. echo 0 > /sys/devices/system/cpu/cpu1/online
> 3. echo 1 > /sys/devices/system/cpu/cpu1/online
> 4. echo 0 > /sys/devices/system/cpu/cpu1/online
> 5. echo 1 > /sys/devices/system/cpu/cpu1/online
> 
> In line (3), the CPU hotplug will cause us to create a new ksoftirqd/1
> thread. Since that thread is forked from kthreadd, it will end up in the same
> cgroup, also without any realtime access.
> 
> In step (4), cpu_callback in softirq.c will attempt to kill ksoftirqd by setting
> it to SCHED_FIFO and using kthread_stop(). It does this with
> 'sched_setscheduler_nocheck', which bypasses the usual checks that prevent
> setting a process to an SCHED_FIFO if it is in a cgroup that would prevent it
> from running.
> 
> Thus, ksoftirqd ends up at SCHED_FIFO but with a zero rt_runtime_us, and is
> never scheduled again, and kthread_stop blocks waiting on it.
> 
> In (5), we try to call the CPU notifier chain again, but it is still locked from
> (4), and we deadlock.

Hm.  Seems to me this is just another of the myriad ways a privileged
user can shoot himself in the foot.

	-Mike

