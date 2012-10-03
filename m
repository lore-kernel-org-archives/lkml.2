Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932620Ab2JCXHU (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Oct 2012 19:07:20 -0400
Received: from mail.betterlinux.com ([199.58.199.50]:47086 "EHLO
	mail.betterlinux.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932391Ab2JCXHQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Oct 2012 19:07:16 -0400
X-DKIM: OpenDKIM Filter v2.4.1 mail.betterlinux.com 7586182077
From: Andrea Righi <andrea@betterlinux.com>
To: Paul Menage <paul@paulmenage.org>, Ingo Molnar <mingo@redhat.com>,
        Peter Zijlstra <peterz@infradead.org>
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH RFC 0/3] per cpuset load average
Date: Thu,  4 Oct 2012 01:05:09 +0200
Message-Id: <1349305512-3428-1-git-send-email-andrea@betterlinux.com>
X-Mailer: git-send-email 1.7.9.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

[ Premise: I'm not considering this patch suitable for inclusion, mostly
because I'm not convinced at all of the interface and I don't even know if
cpuset is the right place for this feature. However, I just wrote it for a
project and I would like to improve it, better integrate it in the kernel and
share the code in general, in case someone else is also interested to use this
feature. ]

Overview
~~~~~~~~
The cpusets subsystem allows to assign a different set of CPUs to a cgroup. A
typical use case is to split large systems in small CPU/memory partitions and
isolate certain users/applications in these subsets of the system.

Sometimes, to have a quick overview of each partition's state, we may be
interested to get the load average of the CPUs assigned to a particular cpuset,
rather than the global load average of the system.

Proposed solution
~~~~~~~~~~~~~~~~~
The proposal is to add a new file in the cpuset subsystem to report the load
average of the CPUs assinged to a particular cpuset cgroup.

Example:

 # echo 0-1 > /sys/fs/cgroup/cpuset/foo/cpuset.cpus
 # echo 2-3 > /sys/fs/cgroup/cpuset/bar/cpuset.cpus

 # echo $$ > /sys/fs/cgroup/cpuset/foo/tasks
 # for i in `seq 4`; do yes > /dev/null & done

 ... after ~5mins ...

 # cat /proc/loadavg /sys/fs/cgroup/cpuset/{foo,bar}/cpuset.loadavg
 3.99 2.66 1.24 6/377 2855
 3.98 2.64 1.20
 0.01 0.02 0.04

In this case we can easily find that the cpuset "foo" is the most busy in the
system.

[PATCH RFC 1/3] sched: introduce distinct per-cpu load average
[PATCH RFC 2/3] cpusets: add load avgerage interface
[PATCH RFC 3/3] cpusets: add documentation of the loadavg file

 include/linux/sched.h |    7 +++++
 kernel/cpuset.c       |   58 ++++++++++++++++++++++++++++++++++++
 kernel/sched/core.c   |   78 ++++++++++++++++++++++++++++++++++++++++++++++---
 3 files changed, 139 insertions(+), 4 deletions(-)
