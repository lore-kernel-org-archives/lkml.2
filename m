Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752203Ab0LOJgi (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Dec 2010 04:36:38 -0500
Received: from cn.fujitsu.com ([222.73.24.84]:51981 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1751402Ab0LOJgd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Dec 2010 04:36:33 -0500
Message-ID: <4D088C26.5090205@cn.fujitsu.com>
Date: Wed, 15 Dec 2010 17:36:38 +0800
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
Subject: [PATCH v2 6/6] cgroups: Update documentation for bindable subsystems
References: <4D088BB5.30903@cn.fujitsu.com>
In-Reply-To: <4D088BB5.30903@cn.fujitsu.com>
X-MIMETrack: Itemize by SMTP Server on mailserver/fnst(Release 8.5.1FP4|July 25, 2010) at
 2010-12-15 17:36:31,
	Serialize by Router on mailserver/fnst(Release 8.5.1FP4|July 25, 2010) at
 2010-12-15 17:36:32,
	Serialize complete at 2010-12-15 17:36:32
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Provide a usage example, update the bind() callback API, etc.

Signed-off-by: Li Zefan <lizf@cn.fujitsu.com>
---
 Documentation/cgroups/cgroups.txt |   37 +++++++++++++++++++++++++++++--------
 1 files changed, 29 insertions(+), 8 deletions(-)

diff --git a/Documentation/cgroups/cgroups.txt b/Documentation/cgroups/cgroups.txt
index 190018b..4e772cc 100644
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
@@ -523,6 +529,15 @@ module initcall a call to cgroup_load_subsys(), and in its exitcall a
 call to cgroup_unload_subsys(). It should also set its_subsys.module =
 THIS_MODULE in its .c file.
 
+If a subsystem has bindable flag set, normally it has to be able to
+support side-effect free movement of a task into any just-created
+cgroups. i.e. it's probably not suitable for any subsystem where
+can_attach() might return false for the newly-created cgroup, or
+attach() might have side-effects for those same cases.
+
+If a subsystem has unbindable flag set, normally it has to be able to
+support side-effect free movement of a task into the roog cgroup.
+
 Each subsystem may export the following methods. The only mandatory
 methods are create/destroy. Any others that are null are presumed to
 be successful no-ops.
@@ -627,9 +642,15 @@ void bind(struct cgroup_subsys *ss, struct cgroup *root)
 (cgroup_mutex and ss->hierarchy_mutex held by caller)
 
 Called when a cgroup subsystem is rebound to a different hierarchy
-and root cgroup. Currently this will only involve movement between
-the default hierarchy (which never has sub-cgroups) and a hierarchy
-that is being created/destroyed (and hence has no sub-cgroups).
+and root cgroup.
+
+For non-bindable subsystems, this will only involve movement
+between the default hierarchy (which never has sub-cgroups) and a
+hierarchy that is being created/destroyed (and hence has no sub-cgroups).
+
+For binadable subsystems, this may also involve movement between the
+default hierarchy and a mounted hierarchy that's populated with
+sub-cgroups.
 
 4. Questions
 ============
-- 
1.6.3

