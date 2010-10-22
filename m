Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755345Ab0JVIIX (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Oct 2010 04:08:23 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:54101 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1752952Ab0JVIIS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Oct 2010 04:08:18 -0400
Message-ID: <4CC146A4.9090505@cn.fujitsu.com>
Date: Fri, 22 Oct 2010 16:09:08 +0800
From: Li Zefan <lizf@cn.fujitsu.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.1b3pre) Gecko/20090513 Fedora/3.0-2.3.beta2.fc11 Thunderbird/3.0b2
MIME-Version: 1.0
To: "akpm >> Andrew Morton" <akpm@linux-foundation.org>
CC: Paul Menage <menage@google.com>, Stephane Eranian <eranian@google.com>,
        LKML <linux-kernel@vger.kernel.org>,
        containers@lists.linux-foundation.org
Subject: [PATCH 0/7] cgroups: Allow to bind/unbind subsystems to/from non-trival
 hierarchy
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Stephane posted a patchset to add perf_cgroup subsystem, so perf can
be used to monitor all threads belonging to a cgroup.

But if you already mounted a cgroup hierarchy but without perf_cgroup
and the hierarchy has sub-cgroups, you can't bind perf_cgroup to it,
and thus you're not able to use per-cgroup perf feature.

This patchset alleviates the pain, and then a subsytem can be
bound/unbound to/from a hierarchy which has sub-cgroups in it.

Some subsystems still can't take advantage of this patchset, memcgroup
and cpuset in specific.

For cpuset, if a hierarchy has a sub-cgroup and the cgroup has tasks,
we can't decide sub-cgroup's cpuset.mems and cpuset.cpus automatically
if we try to bind cpuset to this hierarchy.

For memcgroup, memcgroup uses css_get/put(), and due to some complexity,
for now bindable subsystems should not use css_get/put().

Usage:

# mount -t cgroup -o cpuset xxx /mnt
# mkdir /mnt/tmp
# echo $$ > /mnt/tmp/tasks

(add cpuacct to the hierarchy)
# mount -o remount,cpuset,cpuacct xxx /mnt

(remove it from the hierarchy)
# mount -o remount,cpuset xxx /mnt

There's another limitation, cpuacct should not be bound to any mounted
hierarchy before the above operation. But that's not a problem, as you
can remove it from a hierarchy and bind it to another one.

---
 Documentation/cgroups/cgroups.txt |   26 ++-
 include/linux/cgroup.h            |   25 +++-
 kernel/cgroup.c                   |  305 +++++++++++++++++++++++++++++++------
 kernel/cgroup_freezer.c           |   19 ++-
 kernel/sched.c                    |    1 +
 net/sched/cls_cgroup.c            |    1 +
 security/device_cgroup.c          |    1 +
 7 files changed, 311 insertions(+), 67 deletions(-)
