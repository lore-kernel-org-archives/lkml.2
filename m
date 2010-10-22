Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755554Ab0JVILc (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Oct 2010 04:11:32 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:49932 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1751838Ab0JVILa (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Oct 2010 04:11:30 -0400
Message-ID: <4CC14769.2000406@cn.fujitsu.com>
Date: Fri, 22 Oct 2010 16:12:25 +0800
From: Li Zefan <lizf@cn.fujitsu.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.1b3pre) Gecko/20090513 Fedora/3.0-2.3.beta2.fc11 Thunderbird/3.0b2
MIME-Version: 1.0
To: "akpm >> Andrew Morton" <akpm@linux-foundation.org>
CC: Paul Menage <menage@google.com>, Stephane Eranian <eranian@google.com>,
        LKML <linux-kernel@vger.kernel.org>,
        containers@lists.linux-foundation.org
Subject: [PATCH 7/7] cgroups: Update documentation for bindable subsystems
References: <4CC146A4.9090505@cn.fujitsu.com>
In-Reply-To: <4CC146A4.9090505@cn.fujitsu.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Provide a usage example, and update the bind() callback API.

Signed-off-by: Li Zefan <lizf@cn.fujitsu.com>
---
 Documentation/cgroups/cgroups.txt |   26 +++++++++++++++++---------
 1 files changed, 17 insertions(+), 9 deletions(-)

diff --git a/Documentation/cgroups/cgroups.txt b/Documentation/cgroups/cgroups.txt
index 190018b..5b5382a 100644
--- a/Documentation/cgroups/cgroups.txt
+++ b/Documentation/cgroups/cgroups.txt
@@ -363,17 +363,23 @@ Note this will add ns to the hierarchy but won't remove memory or
 cpuset, because the new options are appended to the old ones:
 # mount -o remount,ns /dev/cgroup
 
+For some subsystems you can bind them to a mounted hierarchy or
+remove them from it, even if there're sub-cgroups in it:
+# mount -t cgroup -o freezer hier1 /dev/cgroup
+# echo $$ > /dev/cgroup/my_cgroup
+# mount -o freezer,cpuset hier1 /dev/cgroup
+(failed)
+# mount -o freezer,cpuacct hier1 /dev/cgroup
+# mount -o cpuacct hier1 /dev/cgroup
+
+Note cpuacct should be sit in the default hierarchy before remount.
+
 To Specify a hierarchy's release_agent:
 # mount -t cgroup -o cpuset,release_agent="/sbin/cpuset_release_agent" \
   xxx /dev/cgroup
 
 Note that specifying 'release_agent' more than once will return failure.
 
-Note that changing the set of subsystems is currently only supported
-when the hierarchy consists of a single (root) cgroup. Supporting
-the ability to arbitrarily bind/unbind subsystems from an existing
-cgroup hierarchy is intended to be implemented in the future.
-
 Then under /dev/cgroup you can find a tree that corresponds to the
 tree of the cgroups in the system. For instance, /dev/cgroup
 is the cgroup that holds the whole system.
@@ -623,13 +629,15 @@ initialization which might be required before a task could attach.  For
 example in cpusets, no task may attach before 'cpus' and 'mems' are set
 up.
 
-void bind(struct cgroup_subsys *ss, struct cgroup *root)
+void bind(struct cgroup_subsys *ss, struct cgroup *cgrp, bool unbind)
 (cgroup_mutex and ss->hierarchy_mutex held by caller)
 
 Called when a cgroup subsystem is rebound to a different hierarchy
-and root cgroup. Currently this will only involve movement between
-the default hierarchy (which never has sub-cgroups) and a hierarchy
-that is being created/destroyed (and hence has no sub-cgroups).
+and root cgroup. For some subsystems this will only involve movement
+between the default hierarchy (which never has sub-cgroups) and a
+hierarchy that is being created/destroyed (and hence has no sub-cgroups).
+For some other subsystems this can involve movement between the default
+hierarchy and a mounted hierarchy which may have sub-cgroups in it.
 
 4. Questions
 ============
-- 
1.7.0.1

