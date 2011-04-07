Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752243Ab1DGHFE (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Apr 2011 03:05:04 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:55383 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1750979Ab1DGHFC (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Apr 2011 03:05:02 -0400
Message-ID: <4D9D629A.60605@cn.fujitsu.com>
Date: Thu, 07 Apr 2011 15:07:06 +0800
From: Lai Jiangshan <laijs@cn.fujitsu.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.9) Gecko/20100921 Fedora/3.1.4-1.fc14 Thunderbird/3.1.4
MIME-Version: 1.0
To: paulmck@linux.vnet.ibm.com
CC: "H. Peter Anvin" <hpa@linux.intel.com>,
        Peter Zijlstra <peterz@infradead.org>, Michal Marek <mmarek@suse.cz>,
        Jan Beulich <JBeulich@novell.com>, Ingo Molnar <mingo@elte.hu>,
        Alexander van Heukelum <heukelum@fastmail.fm>,
        Dipankar Sarma <dipankar@in.ibm.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Sam Ravnborg <sam@ravnborg.org>, David Howells <dhowells@redhat.com>,
        Oleg Nesterov <oleg@redhat.com>, Roland McGrath <roland@redhat.com>,
        linux-kernel@vger.kernel.org, Thomas Gleixner <tglx@linutronix.de>,
        Steven Rostedt <rostedt@goodmis.org>
Subject: [PATCH 2/4] rcu: make rcudpate.h can use struct task_struct.
References: <1301570320.4859.242.camel@twins> <4D953121.6090901@cn.fujitsu.com> <1301657749.4859.531.camel@twins> <20110405215450.GK2247@linux.vnet.ibm.com> <20110405230745.GA5972@linux.vnet.ibm.com> <1302077428.2225.1365.camel@twins> <20110406192119.GB2265@linux.vnet.ibm.com> <20110406201350.GA9378@linux.vnet.ibm.com> <1302123970.2207.4.camel@laptop> <4D9CDACB.9050705@linux.intel.com> <20110407003041.GD2265@linux.vnet.ibm.com>
In-Reply-To: <20110407003041.GD2265@linux.vnet.ibm.com>
X-MIMETrack: Itemize by SMTP Server on mailserver/fnst(Release 8.5.1FP4|July 25, 2010) at
 2011-04-07 15:05:43,
	Serialize by Router on mailserver/fnst(Release 8.5.1FP4|July 25, 2010) at
 2011-04-07 15:05:45,
	Serialize complete at 2011-04-07 15:05:45
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Step1: Ensure sched.h that it does not include rcudpate.h.

rcupdate.h is so generic that it is included in many headers.
sched.h is so complex that it includes many headers.
So we have to find out all header files which directly include
rcupdate.h and are directly/indirectly included by sched.h.

I found out these files by a script(No False Positive, No False Negetive):
2 include/linux/aio.h ---> include/linux/rcupdate.h
2 include/linux/key.h ---> include/linux/rcupdate.h
2 include/linux/pid.h ---> include/linux/rcupdate.h
2 include/linux/rculist.h ---> include/linux/rcupdate.h
2 include/linux/sched.h ---> include/linux/rcupdate.h
2 include/linux/sem.h ---> include/linux/rcupdate.h
2 include/linux/sysctl.h ---> include/linux/rcupdate.h

So the step 1 changes these files just includes rcupdate_defs.h

Step2: Ensure rcupdate.h included in the files which use rcu_read_lock*()

When the step 1 is done, the kernel build will fail, because some
files just include the above files and use rcu_read_lock*() without
rcupdate.h included.

# vi ~/is_include.py     ########### command1

import re
import sys

include_re = re.compile(r'#\s*include\s*<([_\-\w]*/)([/\._\-\w]*)>')
searched = {}

def is_include(f, depth):
  if f == ('include/linux/', 'rcupdate.h'):
    sys.exit(0)
  if depth <= 0:
    return
  if searched.has_key(f):
    if searched[f] > depth:
      return
  searched[f] = depth
  try:
    ff = file(f[0]+f[1])
  except:
    return ()
  for ch in include_re.findall(ff.read()):
    if ch[0] != 'asm/':
      is_include(('include/' + ch[0], ch[1]), depth - 1)

"""usage: is_include.py file_name depth """
is_include(('', sys.argv[1]), int(sys.argv[2]))
sys.exit(1)

# vi ~/is_include.sh ############## command2
#!/bin/bash

depth="$1"

find -name "*.c" | xargs grep -l rcu_read_lock | while read file
do
	python ~/is_include.py "$file" "$depth" || echo "$file"
done

# ~/is_include.sh 3   ################# command3(after step1 is done)
./drivers/base/power/wakeup.c
./drivers/misc/sgi-gru/grutlbpurge.c
./drivers/char/tpm/tpm.c
./drivers/net/wireless/iwlwifi/iwl-agn-rxon.c
./drivers/net/wireless/ath/ath9k/xmit.c
./drivers/net/wireless/ath/ath9k/htc_drv_main.c
./drivers/net/wireless/ath/ath9k/htc_drv_txrx.c
./drivers/net/wireless/ath/carl9170/mac.c
./drivers/net/wireless/ath/ar9170/mac.c
./drivers/staging/tidspbridge/pmgr/dspapi.c
./drivers/s390/cio/qdio_thinint.c
./lib/is_single_threaded.c
./fs/autofs4/waitq.c
./fs/ecryptfs/messaging.c
./fs/xfs/xfs_mount.c
./fs/xfs/linux-2.6/xfs_sync.c
./fs/xfs/xfs_iget.c
./fs/xfs/xfs_inode.c
./arch/ia64/sn/kernel/irq.c
./security/tomoyo/common.c
./security/apparmor/audit.c
./kernel/sched_fair.c
./kernel/tsacct.c
./kernel/sched_debug.c
./kernel/pid_namespace.c
./kernel/futex_compat.c
./kernel/sched_rt.c
./net/rds/ib_rdma.c
./net/rds/connection.c
./net/mac80211/debugfs_sta.c
./net/mac80211/mesh.c
./net/mac80211/mesh_hwmp.c
./net/mac80211/debugfs_key.c
./net/mac80211/mesh_plink.c
./net/batman-adv/send.c
./net/batman-adv/routing.c
./net/batman-adv/main.c
./net/batman-adv/originator.c

(The simple scripts allow False Positive, disallow False Negetive)
After manual check, only
	drivers/staging/tidspbridge/pmgr/dspapi.c
	kernel/futex_compat.c
	kernel/tsacct.c
	lib/is_single_threaded.c
are required to add  "#include <linux/rcupdate.h>"

Signed-off-by: Lai Jiangshan <laijs@cn.fujitsu.com>
---
 drivers/staging/tidspbridge/pmgr/dspapi.c |    1 +
 include/linux/aio.h                       |    2 +-
 include/linux/key.h                       |    2 +-
 include/linux/pid.h                       |    2 +-
 include/linux/rculist.h                   |    2 +-
 include/linux/sched.h                     |    2 +-
 include/linux/sem.h                       |    2 +-
 include/linux/sysctl.h                    |    2 +-
 kernel/futex_compat.c                     |    1 +
 kernel/tsacct.c                           |    1 +
 lib/is_single_threaded.c                  |    1 +
 11 files changed, 11 insertions(+), 7 deletions(-)

diff --git a/drivers/staging/tidspbridge/pmgr/dspapi.c b/drivers/staging/tidspbridge/pmgr/dspapi.c
index 86ca785..558654e 100644
--- a/drivers/staging/tidspbridge/pmgr/dspapi.c
+++ b/drivers/staging/tidspbridge/pmgr/dspapi.c
@@ -17,6 +17,7 @@
  * WARRANTIES OF MERCHANTIBILITY AND FITNESS FOR A PARTICULAR PURPOSE.
  */
 #include <linux/types.h>
+#include <linux/rcupdate.h>
 
 /*  ----------------------------------- Host OS */
 #include <dspbridge/host_os.h>
diff --git a/include/linux/aio.h b/include/linux/aio.h
index 7a8db41..1033572 100644
--- a/include/linux/aio.h
+++ b/include/linux/aio.h
@@ -5,7 +5,7 @@
 #include <linux/workqueue.h>
 #include <linux/aio_abi.h>
 #include <linux/uio.h>
-#include <linux/rcupdate.h>
+#include <linux/rcupdate_defs.h>
 
 #include <asm/atomic.h>
 
diff --git a/include/linux/key.h b/include/linux/key.h
index 3db0adc..8f18036 100644
--- a/include/linux/key.h
+++ b/include/linux/key.h
@@ -18,7 +18,7 @@
 #include <linux/types.h>
 #include <linux/list.h>
 #include <linux/rbtree.h>
-#include <linux/rcupdate.h>
+#include <linux/rcupdate_defs.h>
 #include <linux/sysctl.h>
 #include <linux/rwsem.h>
 #include <asm/atomic.h>
diff --git a/include/linux/pid.h b/include/linux/pid.h
index 49f1c2f..12d652c 100644
--- a/include/linux/pid.h
+++ b/include/linux/pid.h
@@ -1,7 +1,7 @@
 #ifndef _LINUX_PID_H
 #define _LINUX_PID_H
 
-#include <linux/rcupdate.h>
+#include <linux/rcupdate_defs.h>
 
 enum pid_type
 {
diff --git a/include/linux/rculist.h b/include/linux/rculist.h
index 2dea94f..265e22d 100644
--- a/include/linux/rculist.h
+++ b/include/linux/rculist.h
@@ -7,7 +7,7 @@
  * RCU-protected list version
  */
 #include <linux/list.h>
-#include <linux/rcupdate.h>
+#include <linux/rcupdate_defs.h>
 
 /*
  * Why is there no list_empty_rcu()?  Because list_empty() serves this
diff --git a/include/linux/sched.h b/include/linux/sched.h
index 777d8a5..69db9e7 100644
--- a/include/linux/sched.h
+++ b/include/linux/sched.h
@@ -78,7 +78,7 @@ struct sched_param {
 #include <linux/topology.h>
 #include <linux/proportions.h>
 #include <linux/seccomp.h>
-#include <linux/rcupdate.h>
+#include <linux/rcupdate_defs.h>
 #include <linux/rculist.h>
 #include <linux/rtmutex.h>
 
diff --git a/include/linux/sem.h b/include/linux/sem.h
index f2961af..98d96e8 100644
--- a/include/linux/sem.h
+++ b/include/linux/sem.h
@@ -78,7 +78,7 @@ struct  seminfo {
 
 #ifdef __KERNEL__
 #include <asm/atomic.h>
-#include <linux/rcupdate.h>
+#include <linux/rcupdate_defs.h>
 #include <linux/cache.h>
 
 struct task_struct;
diff --git a/include/linux/sysctl.h b/include/linux/sysctl.h
index 11684d9..553f127 100644
--- a/include/linux/sysctl.h
+++ b/include/linux/sysctl.h
@@ -930,7 +930,7 @@ enum
 
 #ifdef __KERNEL__
 #include <linux/list.h>
-#include <linux/rcupdate.h>
+#include <linux/rcupdate_defs.h>
 
 /* For the /proc/sys support */
 struct ctl_table;
diff --git a/kernel/futex_compat.c b/kernel/futex_compat.c
index a7934ac..4485705 100644
--- a/kernel/futex_compat.c
+++ b/kernel/futex_compat.c
@@ -10,6 +10,7 @@
 #include <linux/compat.h>
 #include <linux/nsproxy.h>
 #include <linux/futex.h>
+#include <linux/rcupdate.h>
 
 #include <asm/uaccess.h>
 
diff --git a/kernel/tsacct.c b/kernel/tsacct.c
index 24dc60d..2617467 100644
--- a/kernel/tsacct.c
+++ b/kernel/tsacct.c
@@ -21,6 +21,7 @@
 #include <linux/tsacct_kern.h>
 #include <linux/acct.h>
 #include <linux/jiffies.h>
+#include <linux/rcupdate.h>
 #include <linux/mm.h>
 
 /*
diff --git a/lib/is_single_threaded.c b/lib/is_single_threaded.c
index bd2bea9..efcb711 100644
--- a/lib/is_single_threaded.c
+++ b/lib/is_single_threaded.c
@@ -11,6 +11,7 @@
  */
 
 #include <linux/sched.h>
+#include <linux/rcupdate.h>
 
 /*
  * Returns true if the task does not share ->mm with another thread/process.
-- 
1.7.4

