Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933980Ab1ETCKq (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 May 2011 22:10:46 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:62251 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S932074Ab1ETCKp convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 May 2011 22:10:45 -0400
Message-ID: <4DD5CE05.3030500@cn.fujitsu.com>
Date: Fri, 20 May 2011 10:12:21 +0800
From: Xiao Guangrong <xiaoguangrong@cn.fujitsu.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.15) Gecko/20110307 Fedora/3.1.9-0.39.b3pre.fc14 Thunderbird/3.1.9
MIME-Version: 1.0
To: Paul Turner <pjt@google.com>
CC: linux-kernel@vger.kernel.org, Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Bharata B Rao <bharata@linux.vnet.ibm.com>,
        Dhaval Giani <dhaval.giani@gmail.com>,
        Balbir Singh <balbir@linux.vnet.ibm.com>,
        Vaidyanathan Srinivasan <svaidy@linux.vnet.ibm.com>,
        Srivatsa Vaddagiri <vatsa@in.ibm.com>,
        Kamalesh Babulal <kamalesh@linux.vnet.ibm.com>,
        Ingo Molnar <mingo@elte.hu>, Pavel Emelyanov <xemul@openvz.org>
Subject: Test for CFS Bandwidth Control V6
References: <20110323030326.789836913@google.com>
In-Reply-To: <20110323030326.789836913@google.com>
X-MIMETrack: Itemize by SMTP Server on mailserver/fnst(Release 8.5.1FP4|July 25, 2010) at
 2011-05-20 10:10:44,
	Serialize by Router on mailserver/fnst(Release 8.5.1FP4|July 25, 2010) at
 2011-05-20 10:10:48
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Paul,

I'm so sorry for sending this mail in the new thread, since i didn't
receive your V6 patchset from LKML.

It seams the patchset can not be applied, since it's conflict between
patch 3 and patch 5:

========Quote========
[patch 03/15] sched: introduce primitives to account for CFS bandwidth tracking
 
+#ifdef CONFIG_CFS_BANDWIDTH
+       int runtime_enabled;
+       s64 runtime_remaining;
+#endif
 #endif
 };

+#ifdef CONFIG_CFS_BANDWIDTH
+static inline struct cfs_bandwidth *tg_cfs_bandwidth(struct task_group *tg)
+{
+       return &tg->cfs_bandwidth;
+}
+
+static inline u64 default_cfs_period(void);
+

[patch 05/15] sched: add a timer to handle CFS bandwidth refresh

@@ -394,12 +400,38 @@ static inline struct cfs_bandwidth *tg_c

 #ifdef CONFIG_CFS_BANDWIDTH
 static inline u64 default_cfs_period(void);
+static int do_sched_cfs_period_timer(struct cfs_bandwidth *cfs_b, int overrun);
+
+static enum hrtimer_restart sched_cfs_period_timer(struct hrtimer *timer)
+{
+       struct cfs_bandwidth *cfs_b =
+               container_of(timer, struct cfs_bandwidth, period_timer);
+       ktime_t now;
+       int overrun;

========End quote========

I downloaded the patchset from Internet, i missed the newer version?

I have done some test after fixed the conflict by handle, below test can cause
box crash:

========Quote　cpu_hotlpug.sh ========
#!/bin/sh

ROOT_PATH="/mnt"

def_quota=30000
def_period=100000

pid=
creat_process()
{

	nice -n $1 cat /dev/zero > /dev/null &
	pid=$!

	if [ $2 -ne -1 ]; then
		taskset -pc $2 $pid &> /dev/null
	fi
}

HOTPLUG_PATH=$ROOT_PATH/cpu-hotplug

mount -t cgroup -o cpu none $ROOT_PATH

mkdir $HOTPLUG_PATH

echo $def_quota > $HOTPLUG_PATH/cpu.cfs_quota_us
echo $def_period > $HOTPLUG_PATH/cpu.cfs_period_us

# create 3 tasks for every cpu

for((i=0;i<3;i++))
{
	creat_process -6 1
	echo $pid > $HOTPLUG_PATH/tasks
}

for((i=0;i<3;i++))
{
	creat_process -6 2
	echo $pid > $HOTPLUG_PATH/tasks
}

for((i=0;i<3;i++))
{
	creat_process -6 3
	echo $pid > $HOTPLUG_PATH/tasks
}

echo 0 > /sys/devices/system/cpu/cpu1/online
echo 1 > /sys/devices/system/cpu/cpu1/online

echo 0 > /sys/devices/system/cpu/cpu2/online
echo 1 > /sys/devices/system/cpu/cpu2/online

echo 0 > /sys/devices/system/cpu/cpu3/online
echo 1 > /sys/devices/system/cpu/cpu3/online

killall -9 cat

rmdir $HOTPLUG_PATH
umount $ROOT_PATH
======== End quote　cpu_hotlpug.sh ========

Sorry to disturb you if the bug is know.

Thanks!



