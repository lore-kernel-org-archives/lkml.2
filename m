Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751638Ab0LOJeo (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Dec 2010 04:34:44 -0500
Received: from cn.fujitsu.com ([222.73.24.84]:62619 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1751113Ab0LOJem (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Dec 2010 04:34:42 -0500
Message-ID: <4D088BB5.30903@cn.fujitsu.com>
Date: Wed, 15 Dec 2010 17:34:45 +0800
From: Li Zefan <lizf@cn.fujitsu.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.1b3pre) Gecko/20090513 Fedora/3.0-2.3.beta2.fc11 Thunderbird/3.0b2
MIME-Version: 1.0
To: Andrew Morton <akpm@linux-foundation.org>
CC: Paul Menage <menage@google.com>, Peter Zijlstra <peterz@infradead.org>,
        Hiroyuki KAMEZAWA <kamezawa.hiroyu@jp.fujitsu.com>,
        Matt Helsley <matthltc@us.ibm.com>,
        Stephane Eranian <eranian@google.com>,
        LKML <linux-kernel@vger.kernel.org>,
        containers@lists.linux-foundation.org
Subject: [PATCH v2 0/6] cgroups: Bindable cgroup subsystems
X-MIMETrack: Itemize by SMTP Server on mailserver/fnst(Release 8.5.1FP4|July 25, 2010) at
 2010-12-15 17:34:38,
	Serialize by Router on mailserver/fnst(Release 8.5.1FP4|July 25, 2010) at
 2010-12-15 17:34:39,
	Serialize complete at 2010-12-15 17:34:39
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset=UTF-8
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
and cpuset for example.

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

Changelog v2:

- Fix some bugs.
- Spit can_bind flag to bindable and unbindable flags
- Provide a __css_tryget() so a bindable subsystem can pin a cgroup
  via it.
- ...

---
 Documentation/cgroups/cgroups.txt |   37 +++-
 include/linux/cgroup.h            |   39 +++-
 kernel/cgroup.c                   |  391 +++++++++++++++++++++++++++++++------
 kernel/cgroup_freezer.c           |    1 +
 kernel/sched.c                    |    2 +
 security/device_cgroup.c          |    2 +
 6 files changed, 398 insertions(+), 74 deletions(-)
