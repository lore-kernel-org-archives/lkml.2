Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752367Ab1FOUCe (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Jun 2011 16:02:34 -0400
Received: from rcsinet10.oracle.com ([148.87.113.121]:52489 "EHLO
	rcsinet10.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752131Ab1FOUCb convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Jun 2011 16:02:31 -0400
Date: Wed, 15 Jun 2011 12:59:45 -0700
From: Randy Dunlap <randy.dunlap@oracle.com>
To: lkml <linux-kernel@vger.kernel.org>
Cc: torvalds <torvalds@linux-foundation.org>, joerg@alea.gnuu.de,
        Paul Menage <menage@google.com>
Subject: [PATCH 3/4] Documentation: update cgroupfs mount point
Message-Id: <20110615125945.220da7cc.randy.dunlap@oracle.com>
In-Reply-To: <20110615125709.ffc06d02.randy.dunlap@oracle.com>
References: <20110615125709.ffc06d02.randy.dunlap@oracle.com>
Organization: Oracle Linux Eng.
X-Mailer: Sylpheed 2.7.1 (GTK+ 2.16.6; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
X-Source-IP: acsinet22.oracle.com [141.146.126.238]
X-Auth-Type: Internal IP
X-CT-RefId: str=0001.0A090206.4DF90FD0.0020:SCFMA922111,ss=1,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Jörg Sommer <joerg@alea.gnuu.de>

According to 676db4af043014e852f67ba0349dae0071bd11f3 the canonical
mountpoint for the cgroup filesystem is /sys/fs/cgroup. Hence, this
should be used in the documentation.

Signed-off-by: Jörg Sommer <joerg@alea.gnuu.de>
Acked-by: Paul Menage <menage@google.com>
Signed-off-by: Randy Dunlap <randy.dunlap@oracle.com>
---
 Documentation/accounting/cgroupstats.txt     |    4 -
 Documentation/cgroups/blkio-controller.txt   |   29 ++++----
 Documentation/cgroups/cgroups.txt            |   58 ++++++++++-------
 Documentation/cgroups/cpuacct.txt            |   19 ++---
 Documentation/cgroups/cpusets.txt            |   28 ++++----
 Documentation/cgroups/devices.txt            |    6 -
 Documentation/cgroups/freezer-subsystem.txt  |   20 ++---
 Documentation/cgroups/memory.txt             |   17 ++--
 Documentation/scheduler/sched-design-CFS.txt |    7 +-
 Documentation/scheduler/sched-rt-group.txt   |    7 --
 Documentation/vm/hwpoison.txt                |    6 -
 11 files changed, 108 insertions(+), 93 deletions(-)

--- lnx-30-rc2.orig/Documentation/accounting/cgroupstats.txt
+++ lnx-30-rc2/Documentation/accounting/cgroupstats.txt
@@ -21,7 +21,7 @@ information will not be available.
 To extract cgroup statistics a utility very similar to getdelays.c
 has been developed, the sample output of the utility is shown below
 
-~/balbir/cgroupstats # ./getdelays  -C "/cgroup/a"
+~/balbir/cgroupstats # ./getdelays  -C "/sys/fs/cgroup/a"
 sleeping 1, blocked 0, running 1, stopped 0, uninterruptible 0
-~/balbir/cgroupstats # ./getdelays  -C "/cgroup"
+~/balbir/cgroupstats # ./getdelays  -C "/sys/fs/cgroup"
 sleeping 155, blocked 0, running 1, stopped 0, uninterruptible 2
--- lnx-30-rc2.orig/Documentation/cgroups/blkio-controller.txt
+++ lnx-30-rc2/Documentation/cgroups/blkio-controller.txt
@@ -28,16 +28,19 @@ cgroups. Here is what you can do.
 - Enable group scheduling in CFQ
 	CONFIG_CFQ_GROUP_IOSCHED=y
 
-- Compile and boot into kernel and mount IO controller (blkio).
+- Compile and boot into kernel and mount IO controller (blkio); see
+  cgroups.txt, Why are cgroups needed?.
 
-	mount -t cgroup -o blkio none /cgroup
+	mount -t tmpfs cgroup_root /sys/fs/cgroup
+	mkdir /sys/fs/cgroup/blkio
+	mount -t cgroup -o blkio none /sys/fs/cgroup/blkio
 
 - Create two cgroups
-	mkdir -p /cgroup/test1/ /cgroup/test2
+	mkdir -p /sys/fs/cgroup/blkio/test1/ /sys/fs/cgroup/blkio/test2
 
 - Set weights of group test1 and test2
-	echo 1000 > /cgroup/test1/blkio.weight
-	echo 500 > /cgroup/test2/blkio.weight
+	echo 1000 > /sys/fs/cgroup/blkio/test1/blkio.weight
+	echo 500 > /sys/fs/cgroup/blkio/test2/blkio.weight
 
 - Create two same size files (say 512MB each) on same disk (file1, file2) and
   launch two dd threads in different cgroup to read those files.
@@ -46,12 +49,12 @@ cgroups. Here is what you can do.
 	echo 3 > /proc/sys/vm/drop_caches
 
 	dd if=/mnt/sdb/zerofile1 of=/dev/null &
-	echo $! > /cgroup/test1/tasks
-	cat /cgroup/test1/tasks
+	echo $! > /sys/fs/cgroup/blkio/test1/tasks
+	cat /sys/fs/cgroup/blkio/test1/tasks
 
 	dd if=/mnt/sdb/zerofile2 of=/dev/null &
-	echo $! > /cgroup/test2/tasks
-	cat /cgroup/test2/tasks
+	echo $! > /sys/fs/cgroup/blkio/test2/tasks
+	cat /sys/fs/cgroup/blkio/test2/tasks
 
 - At macro level, first dd should finish first. To get more precise data, keep
   on looking at (with the help of script), at blkio.disk_time and
@@ -68,13 +71,13 @@ Throttling/Upper Limit policy
 - Enable throttling in block layer
 	CONFIG_BLK_DEV_THROTTLING=y
 
-- Mount blkio controller
-        mount -t cgroup -o blkio none /cgroup/blkio
+- Mount blkio controller (see cgroups.txt, Why are cgroups needed?)
+        mount -t cgroup -o blkio none /sys/fs/cgroup/blkio
 
 - Specify a bandwidth rate on particular device for root group. The format
   for policy is "<major>:<minor>  <byes_per_second>".
 
-        echo "8:16  1048576" > /cgroup/blkio/blkio.read_bps_device
+        echo "8:16  1048576" > /sys/fs/cgroup/blkio/blkio.read_bps_device
 
   Above will put a limit of 1MB/second on reads happening for root group
   on device having major/minor number 8:16.
@@ -149,7 +152,7 @@ Proportional weight policy files
 
 	  Following is the format.
 
-	  #echo dev_maj:dev_minor weight > /path/to/cgroup/blkio.weight_device
+	  # echo dev_maj:dev_minor weight > blkio.weight_device
 	  Configure weight=300 on /dev/sdb (8:16) in this cgroup
 	  # echo 8:16 300 > blkio.weight_device
 	  # cat blkio.weight_device
--- lnx-30-rc2.orig/Documentation/cgroups/cgroups.txt
+++ lnx-30-rc2/Documentation/cgroups/cgroups.txt
@@ -138,7 +138,7 @@ With the ability to classify tasks diffe
 the admin can easily set up a script which receives exec notifications
 and depending on who is launching the browser he can
 
-       # echo browser_pid > /mnt/<restype>/<userclass>/tasks
+    # echo browser_pid > /sys/fs/cgroup/<restype>/<userclass>/tasks
 
 With only a single hierarchy, he now would potentially have to create
 a separate cgroup for every browser launched and associate it with
@@ -153,9 +153,9 @@ apps enhanced CPU power,
 With ability to write pids directly to resource classes, it's just a
 matter of :
 
-       # echo pid > /mnt/network/<new_class>/tasks
+       # echo pid > /sys/fs/cgroup/network/<new_class>/tasks
        (after some time)
-       # echo pid > /mnt/network/<orig_class>/tasks
+       # echo pid > /sys/fs/cgroup/network/<orig_class>/tasks
 
 Without this ability, he would have to split the cgroup into
 multiple separate ones and then associate the new cgroups with the
@@ -310,21 +310,24 @@ subsystem, this is the case for the cpus
 To start a new job that is to be contained within a cgroup, using
 the "cpuset" cgroup subsystem, the steps are something like:
 
- 1) mkdir /dev/cgroup
- 2) mount -t cgroup -ocpuset cpuset /dev/cgroup
- 3) Create the new cgroup by doing mkdir's and write's (or echo's) in
-    the /dev/cgroup virtual file system.
- 4) Start a task that will be the "founding father" of the new job.
- 5) Attach that task to the new cgroup by writing its pid to the
-    /dev/cgroup tasks file for that cgroup.
- 6) fork, exec or clone the job tasks from this founding father task.
+ 1) mount -t tmpfs cgroup_root /sys/fs/cgroup
+ 2) mkdir /sys/fs/cgroup/cpuset
+ 3) mount -t cgroup -ocpuset cpuset /sys/fs/cgroup/cpuset
+ 4) Create the new cgroup by doing mkdir's and write's (or echo's) in
+    the /sys/fs/cgroup virtual file system.
+ 5) Start a task that will be the "founding father" of the new job.
+ 6) Attach that task to the new cgroup by writing its pid to the
+    /sys/fs/cgroup/cpuset/tasks file for that cgroup.
+ 7) fork, exec or clone the job tasks from this founding father task.
 
 For example, the following sequence of commands will setup a cgroup
 named "Charlie", containing just CPUs 2 and 3, and Memory Node 1,
 and then start a subshell 'sh' in that cgroup:
 
-  mount -t cgroup cpuset -ocpuset /dev/cgroup
-  cd /dev/cgroup
+  mount -t tmpfs cgroup_root /sys/fs/cgroup
+  mkdir /sys/fs/cgroup/cpuset
+  mount -t cgroup cpuset -ocpuset /sys/fs/cgroup/cpuset
+  cd /sys/fs/cgroup/cpuset
   mkdir Charlie
   cd Charlie
   /bin/echo 2-3 > cpuset.cpus
@@ -345,7 +348,7 @@ Creating, modifying, using the cgroups c
 virtual filesystem.
 
 To mount a cgroup hierarchy with all available subsystems, type:
-# mount -t cgroup xxx /dev/cgroup
+# mount -t cgroup xxx /sys/fs/cgroup
 
 The "xxx" is not interpreted by the cgroup code, but will appear in
 /proc/mounts so may be any useful identifying string that you like.
@@ -354,23 +357,32 @@ Note: Some subsystems do not work withou
 if cpusets are enabled the user will have to populate the cpus and mems files
 for each new cgroup created before that group can be used.
 
+As explained in section `1.2 Why are cgroups needed?' you should create
+different hierarchies of cgroups for each single resource or group of
+resources you want to control. Therefore, you should mount a tmpfs on
+/sys/fs/cgroup and create directories for each cgroup resource or resource
+group.
+
+# mount -t tmpfs cgroup_root /sys/fs/cgroup
+# mkdir /sys/fs/cgroup/rg1
+
 To mount a cgroup hierarchy with just the cpuset and memory
 subsystems, type:
-# mount -t cgroup -o cpuset,memory hier1 /dev/cgroup
+# mount -t cgroup -o cpuset,memory hier1 /sys/fs/cgroup/rg1
 
 To change the set of subsystems bound to a mounted hierarchy, just
 remount with different options:
-# mount -o remount,cpuset,blkio hier1 /dev/cgroup
+# mount -o remount,cpuset,blkio hier1 /sys/fs/cgroup/rg1
 
 Now memory is removed from the hierarchy and blkio is added.
 
 Note this will add blkio to the hierarchy but won't remove memory or
 cpuset, because the new options are appended to the old ones:
-# mount -o remount,blkio /dev/cgroup
+# mount -o remount,blkio /sys/fs/cgroup/rg1
 
 To Specify a hierarchy's release_agent:
 # mount -t cgroup -o cpuset,release_agent="/sbin/cpuset_release_agent" \
-  xxx /dev/cgroup
+  xxx /sys/fs/cgroup/rg1
 
 Note that specifying 'release_agent' more than once will return failure.
 
@@ -379,17 +391,17 @@ when the hierarchy consists of a single 
 the ability to arbitrarily bind/unbind subsystems from an existing
 cgroup hierarchy is intended to be implemented in the future.
 
-Then under /dev/cgroup you can find a tree that corresponds to the
-tree of the cgroups in the system. For instance, /dev/cgroup
+Then under /sys/fs/cgroup/rg1 you can find a tree that corresponds to the
+tree of the cgroups in the system. For instance, /sys/fs/cgroup/rg1
 is the cgroup that holds the whole system.
 
 If you want to change the value of release_agent:
-# echo "/sbin/new_release_agent" > /dev/cgroup/release_agent
+# echo "/sbin/new_release_agent" > /sys/fs/cgroup/rg1/release_agent
 
 It can also be changed via remount.
 
-If you want to create a new cgroup under /dev/cgroup:
-# cd /dev/cgroup
+If you want to create a new cgroup under /sys/fs/cgroup/rg1:
+# cd /sys/fs/cgroup/rg1
 # mkdir my_cgroup
 
 Now you want to do something with this cgroup.
--- lnx-30-rc2.orig/Documentation/cgroups/cpuacct.txt
+++ lnx-30-rc2/Documentation/cgroups/cpuacct.txt
@@ -10,26 +10,25 @@ directly present in its group.
 
 Accounting groups can be created by first mounting the cgroup filesystem.
 
-# mkdir /cgroups
-# mount -t cgroup -ocpuacct none /cgroups
+# mount -t cgroup -ocpuacct none /sys/fs/cgroup
 
-With the above step, the initial or the parent accounting group
-becomes visible at /cgroups. At bootup, this group includes all the
-tasks in the system. /cgroups/tasks lists the tasks in this cgroup.
-/cgroups/cpuacct.usage gives the CPU time (in nanoseconds) obtained by
-this group which is essentially the CPU time obtained by all the tasks
+With the above step, the initial or the parent accounting group becomes
+visible at /sys/fs/cgroup. At bootup, this group includes all the tasks in
+the system. /sys/fs/cgroup/tasks lists the tasks in this cgroup.
+/sys/fs/cgroup/cpuacct.usage gives the CPU time (in nanoseconds) obtained
+by this group which is essentially the CPU time obtained by all the tasks
 in the system.
 
-New accounting groups can be created under the parent group /cgroups.
+New accounting groups can be created under the parent group /sys/fs/cgroup.
 
-# cd /cgroups
+# cd /sys/fs/cgroup
 # mkdir g1
 # echo $$ > g1
 
 The above steps create a new group g1 and move the current shell
 process (bash) into it. CPU time consumed by this bash and its children
 can be obtained from g1/cpuacct.usage and the same is accumulated in
-/cgroups/cpuacct.usage also.
+/sys/fs/cgroup/cpuacct.usage also.
 
 cpuacct.stat file lists a few statistics which further divide the
 CPU time obtained by the cgroup into user and system times. Currently
--- lnx-30-rc2.orig/Documentation/cgroups/cpusets.txt
+++ lnx-30-rc2/Documentation/cgroups/cpusets.txt
@@ -661,21 +661,21 @@ than stress the kernel.
 
 To start a new job that is to be contained within a cpuset, the steps are:
 
- 1) mkdir /dev/cpuset
- 2) mount -t cgroup -ocpuset cpuset /dev/cpuset
+ 1) mkdir /sys/fs/cgroup/cpuset
+ 2) mount -t cgroup -ocpuset cpuset /sys/fs/cgroup/cpuset
  3) Create the new cpuset by doing mkdir's and write's (or echo's) in
-    the /dev/cpuset virtual file system.
+    the /sys/fs/cgroup/cpuset virtual file system.
  4) Start a task that will be the "founding father" of the new job.
  5) Attach that task to the new cpuset by writing its pid to the
-    /dev/cpuset tasks file for that cpuset.
+    /sys/fs/cgroup/cpuset tasks file for that cpuset.
  6) fork, exec or clone the job tasks from this founding father task.
 
 For example, the following sequence of commands will setup a cpuset
 named "Charlie", containing just CPUs 2 and 3, and Memory Node 1,
 and then start a subshell 'sh' in that cpuset:
 
-  mount -t cgroup -ocpuset cpuset /dev/cpuset
-  cd /dev/cpuset
+  mount -t cgroup -ocpuset cpuset /sys/fs/cgroup/cpuset
+  cd /sys/fs/cgroup/cpuset
   mkdir Charlie
   cd Charlie
   /bin/echo 2-3 > cpuset.cpus
@@ -710,14 +710,14 @@ Creating, modifying, using the cpusets c
 virtual filesystem.
 
 To mount it, type:
-# mount -t cgroup -o cpuset cpuset /dev/cpuset
+# mount -t cgroup -o cpuset cpuset /sys/fs/cgroup/cpuset
 
-Then under /dev/cpuset you can find a tree that corresponds to the
-tree of the cpusets in the system. For instance, /dev/cpuset
+Then under /sys/fs/cgroup/cpuset you can find a tree that corresponds to the
+tree of the cpusets in the system. For instance, /sys/fs/cgroup/cpuset
 is the cpuset that holds the whole system.
 
-If you want to create a new cpuset under /dev/cpuset:
-# cd /dev/cpuset
+If you want to create a new cpuset under /sys/fs/cgroup/cpuset:
+# cd /sys/fs/cgroup/cpuset
 # mkdir my_cpuset
 
 Now you want to do something with this cpuset.
@@ -765,12 +765,12 @@ wrapper around the cgroup filesystem.
 
 The command
 
-mount -t cpuset X /dev/cpuset
+mount -t cpuset X /sys/fs/cgroup/cpuset
 
 is equivalent to
 
-mount -t cgroup -ocpuset,noprefix X /dev/cpuset
-echo "/sbin/cpuset_release_agent" > /dev/cpuset/release_agent
+mount -t cgroup -ocpuset,noprefix X /sys/fs/cgroup/cpuset
+echo "/sbin/cpuset_release_agent" > /sys/fs/cgroup/cpuset/release_agent
 
 2.2 Adding/removing cpus
 ------------------------
--- lnx-30-rc2.orig/Documentation/cgroups/devices.txt
+++ lnx-30-rc2/Documentation/cgroups/devices.txt
@@ -22,16 +22,16 @@ removed from the child(ren).
 An entry is added using devices.allow, and removed using
 devices.deny.  For instance
 
-	echo 'c 1:3 mr' > /cgroups/1/devices.allow
+	echo 'c 1:3 mr' > /sys/fs/cgroup/1/devices.allow
 
 allows cgroup 1 to read and mknod the device usually known as
 /dev/null.  Doing
 
-	echo a > /cgroups/1/devices.deny
+	echo a > /sys/fs/cgroup/1/devices.deny
 
 will remove the default 'a *:* rwm' entry. Doing
 
-	echo a > /cgroups/1/devices.allow
+	echo a > /sys/fs/cgroup/1/devices.allow
 
 will add the 'a *:* rwm' entry to the whitelist.
 
--- lnx-30-rc2.orig/Documentation/cgroups/freezer-subsystem.txt
+++ lnx-30-rc2/Documentation/cgroups/freezer-subsystem.txt
@@ -59,28 +59,28 @@ is non-freezable.
 
 * Examples of usage :
 
-   # mkdir /containers
-   # mount -t cgroup -ofreezer freezer  /containers
-   # mkdir /containers/0
-   # echo $some_pid > /containers/0/tasks
+   # mkdir /sys/fs/cgroup/freezer
+   # mount -t cgroup -ofreezer freezer /sys/fs/cgroup/freezer
+   # mkdir /sys/fs/cgroup/freezer/0
+   # echo $some_pid > /sys/fs/cgroup/freezer/0/tasks
 
 to get status of the freezer subsystem :
 
-   # cat /containers/0/freezer.state
+   # cat /sys/fs/cgroup/freezer/0/freezer.state
    THAWED
 
 to freeze all tasks in the container :
 
-   # echo FROZEN > /containers/0/freezer.state
-   # cat /containers/0/freezer.state
+   # echo FROZEN > /sys/fs/cgroup/freezer/0/freezer.state
+   # cat /sys/fs/cgroup/freezer/0/freezer.state
    FREEZING
-   # cat /containers/0/freezer.state
+   # cat /sys/fs/cgroup/freezer/0/freezer.state
    FROZEN
 
 to unfreeze all tasks in the container :
 
-   # echo THAWED > /containers/0/freezer.state
-   # cat /containers/0/freezer.state
+   # echo THAWED > /sys/fs/cgroup/freezer/0/freezer.state
+   # cat /sys/fs/cgroup/freezer/0/freezer.state
    THAWED
 
 This is the basic mechanism which should do the right thing for user space task
--- lnx-30-rc2.orig/Documentation/cgroups/memory.txt
+++ lnx-30-rc2/Documentation/cgroups/memory.txt
@@ -263,16 +263,17 @@ b. Enable CONFIG_RESOURCE_COUNTERS
 c. Enable CONFIG_CGROUP_MEM_RES_CTLR
 d. Enable CONFIG_CGROUP_MEM_RES_CTLR_SWAP (to use swap extension)
 
-1. Prepare the cgroups
-# mkdir -p /cgroups
-# mount -t cgroup none /cgroups -o memory
+1. Prepare the cgroups (see cgroups.txt, Why are cgroups needed?)
+# mount -t tmpfs none /sys/fs/cgroup
+# mkdir /sys/fs/cgroup/memory
+# mount -t cgroup none /sys/fs/cgroup/memory -o memory
 
 2. Make the new group and move bash into it
-# mkdir /cgroups/0
-# echo $$ > /cgroups/0/tasks
+# mkdir /sys/fs/cgroup/memory/0
+# echo $$ > /sys/fs/cgroup/memory/0/tasks
 
 Since now we're in the 0 cgroup, we can alter the memory limit:
-# echo 4M > /cgroups/0/memory.limit_in_bytes
+# echo 4M > /sys/fs/cgroup/memory/0/memory.limit_in_bytes
 
 NOTE: We can use a suffix (k, K, m, M, g or G) to indicate values in kilo,
 mega or gigabytes. (Here, Kilo, Mega, Giga are Kibibytes, Mebibytes, Gibibytes.)
@@ -280,11 +281,11 @@ mega or gigabytes. (Here, Kilo, Mega, Gi
 NOTE: We can write "-1" to reset the *.limit_in_bytes(unlimited).
 NOTE: We cannot set limits on the root cgroup any more.
 
-# cat /cgroups/0/memory.limit_in_bytes
+# cat /sys/fs/cgroup/memory/0/memory.limit_in_bytes
 4194304
 
 We can check the usage:
-# cat /cgroups/0/memory.usage_in_bytes
+# cat /sys/fs/cgroup/memory/0/memory.usage_in_bytes
 1216512
 
 A successful write to this file does not guarantee a successful set of
--- lnx-30-rc2.orig/Documentation/scheduler/sched-design-CFS.txt
+++ lnx-30-rc2/Documentation/scheduler/sched-design-CFS.txt
@@ -223,9 +223,10 @@ When CONFIG_FAIR_GROUP_SCHED is defined,
 group created using the pseudo filesystem.  See example steps below to create
 task groups and modify their CPU share using the "cgroups" pseudo filesystem.
 
-	# mkdir /dev/cpuctl
-	# mount -t cgroup -ocpu none /dev/cpuctl
-	# cd /dev/cpuctl
+	# mount -t tmpfs cgroup_root /sys/fs/cgroup
+	# mkdir /sys/fs/cgroup/cpu
+	# mount -t cgroup -ocpu none /sys/fs/cgroup/cpu
+	# cd /sys/fs/cgroup/cpu
 
 	# mkdir multimedia	# create "multimedia" group of tasks
 	# mkdir browser		# create "browser" group of tasks
--- lnx-30-rc2.orig/Documentation/scheduler/sched-rt-group.txt
+++ lnx-30-rc2/Documentation/scheduler/sched-rt-group.txt
@@ -129,9 +129,8 @@ priority!
 Enabling CONFIG_RT_GROUP_SCHED lets you explicitly allocate real
 CPU bandwidth to task groups.
 
-This uses the /cgroup virtual file system and
-"/cgroup/<cgroup>/cpu.rt_runtime_us" to control the CPU time reserved for each
-control group.
+This uses the cgroup virtual file system and "<cgroup>/cpu.rt_runtime_us"
+to control the CPU time reserved for each control group.
 
 For more information on working with control groups, you should read
 Documentation/cgroups/cgroups.txt as well.
@@ -150,7 +149,7 @@ For now, this can be simplified to just 
 ===============
 
 There is work in progress to make the scheduling period for each group
-("/cgroup/<cgroup>/cpu.rt_period_us") configurable as well.
+("<cgroup>/cpu.rt_period_us") configurable as well.
 
 The constraint on the period is that a subgroup must have a smaller or
 equal period to its parent. But realistically its not very useful _yet_
--- lnx-30-rc2.orig/Documentation/vm/hwpoison.txt
+++ lnx-30-rc2/Documentation/vm/hwpoison.txt
@@ -129,12 +129,12 @@ Limit injection to pages owned by memgro
 of the memcg.
 
 Example:
-        mkdir /cgroup/hwpoison
+        mkdir /sys/fs/cgroup/mem/hwpoison
 
         usemem -m 100 -s 1000 &
-        echo `jobs -p` > /cgroup/hwpoison/tasks
+        echo `jobs -p` > /sys/fs/cgroup/mem/hwpoison/tasks
 
-        memcg_ino=$(ls -id /cgroup/hwpoison | cut -f1 -d' ')
+        memcg_ino=$(ls -id /sys/fs/cgroup/mem/hwpoison | cut -f1 -d' ')
         echo $memcg_ino > /debug/hwpoison/corrupt-filter-memcg
 
         page-types -p `pidof init`   --hwpoison  # shall do nothing
