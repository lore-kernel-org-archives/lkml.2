Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751765Ab2BTRwS (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Feb 2012 12:52:18 -0500
Received: from e28smtp01.in.ibm.com ([122.248.162.1]:38944 "EHLO
	e28smtp01.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751395Ab2BTRwQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Feb 2012 12:52:16 -0500
Message-ID: <4F428814.1060801@linux.vnet.ibm.com>
Date: Mon, 20 Feb 2012 23:21:16 +0530
From: Raghavendra K T <raghavendra.kt@linux.vnet.ibm.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.2.24) Gecko/20111108 Fedora/3.1.16-1.fc14 Thunderbird/3.1.16
MIME-Version: 1.0
To: Andrew Jones <drjones@redhat.com>
CC: Jeremy Fitzhardinge <jeremy@goop.org>, Tejun Heo <tj@kernel.org>,
        John Stultz <johnstul@us.ibm.com>, LKML <linux-kernel@vger.kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Srivatsa Vaddagiri <vatsa@linux.vnet.ibm.com>,
        Peter Zijlstra <peterz@infradead.org>,
        David Howells <dhowells@redhat.com>, Gleb Natapov <gleb@redhat.com>,
        Raghavendra <raghavendra.kt@linux.vnet.ibm.com>
Subject: Re: [PATCH 1/1] linux headers: header file(s) changes to enable spinlock
 use jumplabel
References: <ac7058ed-4080-4490-a45b-6b2d4de692ab@zmail17.collab.prod.int.phx2.redhat.com>
In-Reply-To: <ac7058ed-4080-4490-a45b-6b2d4de692ab@zmail17.collab.prod.int.phx2.redhat.com>
Content-Type: multipart/mixed;
 boundary="------------090702020702090609050600"
x-cbid: 12022017-4790-0000-0000-000001693381
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a multi-part message in MIME format.
--------------090702020702090609050600
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 02/20/2012 08:30 PM, Andrew Jones wrote:
>
>
> ----- Original Message -----
>> On Mon, Feb 20, 2012 at 11:44:25AM +0530, Raghavendra K T wrote:
>>> On 02/20/2012 10:46 AM, Jeremy Fitzhardinge wrote:
>>> [...]

Hi Drew,
Thanks for the reply

> Hi Raghavendra,

> sorry I didn't get around to starting this discussion myself when
> I first touched the issue. I also bumped into it when attempting
> to rebase pvticketlocks, so I pinged Gleb with the idea to split
> the header. As he's said again now though, he wasn't sure if jump
> labels were necessary in the pvticketlock implementation. In the
> meantime I got busy with other stuff, and didn't get a chance to
> continue/expand the discussion.
>
> I actually think we could consider both of the issues separately
> though.

Right.

  Should we split jump_label.h to make sure we can include
> it where it could otherwise get the cyclic dependencies due to
> workqueue.h? The only argument I can see against that is that
> jumplabels may change again, and then we may hit another issue,
> then again, etc., but handling them like this case by case isn't
> very clean.

Hmm..Handling the way it is handled by me sometime looks ugly to me.
The patch I have posted is only important set of changes. But for
complete yesconfig to work, it still would require change something like
below I am attaching, which (needs 24 file changes) makes it more ugly.
Only point is I can continue testing paravirt spinlock on tip.

Perhaps we need jump_label.h to define a "minimal
> jump label", and then we can create an "extended jump label",
> which has rate limiting and other capabilities.
>

I completely agree. seeing that, you have not started that, it seems
it's good idea for me to take a look at that option, (but may be at
slower pace considering some changes I require (TODO) for kvm paravirt
spinlock).

> Drew
>
>
--->8---
---

--------------090702020702090609050600
Content-Type: text/x-patch;
 name="header_recursion_minor.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
 filename="header_recursion_minor.patch"

diff --git a/crypto/crypto_wq.c b/crypto/crypto_wq.c
index adad92a..e372359 100644
--- a/crypto/crypto_wq.c
+++ b/crypto/crypto_wq.c
@@ -11,6 +11,7 @@
  *
  */
 
+#include <linux/spinlock.h>
 #include <linux/workqueue.h>
 #include <linux/module.h>
 #include <crypto/algapi.h>
diff --git a/include/linux/pm.h b/include/linux/pm.h
index e4982ac..64bf90b 100644
--- a/include/linux/pm.h
+++ b/include/linux/pm.h
@@ -22,8 +22,8 @@
 #define _LINUX_PM_H
 
 #include <linux/list.h>
-#include <linux/workqueue.h>
 #include <linux/spinlock.h>
+#include <linux/workqueue.h>
 #include <linux/wait.h>
 #include <linux/timer.h>
 #include <linux/completion.h>
diff --git a/include/net/net_namespace.h b/include/net/net_namespace.h
index ee547c1..5872748 100644
--- a/include/net/net_namespace.h
+++ b/include/net/net_namespace.h
@@ -5,6 +5,7 @@
 #define __NET_NET_NAMESPACE_H
 
 #include <linux/atomic.h>
+#include <linux/spinlock.h>
 #include <linux/workqueue.h>
 #include <linux/list.h>
 #include <linux/sysctl.h>
diff --git a/kernel/trace/power-traces.c b/kernel/trace/power-traces.c
index f55fcf6..66b4cb2 100644
--- a/kernel/trace/power-traces.c
+++ b/kernel/trace/power-traces.c
@@ -6,6 +6,7 @@
 
 #include <linux/string.h>
 #include <linux/types.h>
+#include <linux/spinlock.h>
 #include <linux/workqueue.h>
 #include <linux/sched.h>
 #include <linux/module.h>
diff --git a/kernel/trace/rpm-traces.c b/kernel/trace/rpm-traces.c
index 4b3b5ea..8fa92f4 100644
--- a/kernel/trace/rpm-traces.c
+++ b/kernel/trace/rpm-traces.c
@@ -6,6 +6,7 @@
 
 #include <linux/string.h>
 #include <linux/types.h>
+#include <linux/spinlock.h>
 #include <linux/workqueue.h>
 #include <linux/sched.h>
 #include <linux/module.h>
diff --git a/kernel/trace/trace_events.c b/kernel/trace/trace_events.c
index c212a7f..b34d241 100644
--- a/kernel/trace/trace_events.c
+++ b/kernel/trace/trace_events.c
@@ -8,8 +8,8 @@
  *
  */
 
-#include <linux/workqueue.h>
 #include <linux/spinlock.h>
+#include <linux/workqueue.h>
 #include <linux/kthread.h>
 #include <linux/debugfs.h>
 #include <linux/uaccess.h>
diff --git a/net/core/dst.c b/net/core/dst.c
index 43d94ce..f3a3c24 100644
--- a/net/core/dst.c
+++ b/net/core/dst.c
@@ -9,6 +9,7 @@
 #include <linux/errno.h>
 #include <linux/init.h>
 #include <linux/kernel.h>
+#include <linux/spinlock.h>
 #include <linux/workqueue.h>
 #include <linux/mm.h>
 #include <linux/module.h>
diff --git a/net/core/net_namespace.c b/net/core/net_namespace.c
index 0e950fd..bb284b5 100644
--- a/net/core/net_namespace.c
+++ b/net/core/net_namespace.c
@@ -1,3 +1,4 @@
+#include <linux/spinlock.h>
 #include <linux/workqueue.h>
 #include <linux/rtnetlink.h>
 #include <linux/cache.h>
diff --git a/net/xfrm/xfrm_state.c b/net/xfrm/xfrm_state.c
index 5b228f9..a390277 100644
--- a/net/xfrm/xfrm_state.c
+++ b/net/xfrm/xfrm_state.c
@@ -13,6 +13,7 @@
  *
  */
 
+#include <linux/spinlock.h>
 #include <linux/workqueue.h>
 #include <net/xfrm.h>
 #include <linux/pfkeyv2.h>
diff --git a/drivers/media/video/gspca/jl2005bcd.c b/drivers/media/video/gspca/jl2005bcd.c
index 53f58ef..86ae21c 100644
--- a/drivers/media/video/gspca/jl2005bcd.c
+++ b/drivers/media/video/gspca/jl2005bcd.c
@@ -20,6 +20,7 @@
 
 #define MODULE_NAME "jl2005bcd"
 
+#include <linux/spinlock.h>
 #include <linux/workqueue.h>
 #include <linux/slab.h>
 #include "gspca.h"
diff --git a/drivers/media/video/gspca/sq905.c b/drivers/media/video/gspca/sq905.c
index 2fe3c29..b3916d3 100644
--- a/drivers/media/video/gspca/sq905.c
+++ b/drivers/media/video/gspca/sq905.c
@@ -37,6 +37,7 @@
 
 #define MODULE_NAME "sq905"
 
+#include <linux/spinlock.h>
 #include <linux/workqueue.h>
 #include <linux/slab.h>
 #include "gspca.h"
diff --git a/drivers/media/video/gspca/sq905c.c b/drivers/media/video/gspca/sq905c.c
index ae78363..b7026f8 100644
--- a/drivers/media/video/gspca/sq905c.c
+++ b/drivers/media/video/gspca/sq905c.c
@@ -31,6 +31,7 @@
 
 #define MODULE_NAME "sq905c"
 
+#include <linux/spinlock.h>
 #include <linux/workqueue.h>
 #include <linux/slab.h>
 #include "gspca.h"
diff --git a/drivers/media/video/gspca/vicam.c b/drivers/media/video/gspca/vicam.c
index 911152e..fd5db41 100644
--- a/drivers/media/video/gspca/vicam.c
+++ b/drivers/media/video/gspca/vicam.c
@@ -31,6 +31,7 @@
 #define MODULE_NAME "vicam"
 #define HEADER_SIZE 64
 
+#include <linux/spinlock.h>
 #include <linux/workqueue.h>
 #include <linux/slab.h>
 #include <linux/firmware.h>
diff --git a/drivers/net/ethernet/mellanox/mlx4/catas.c b/drivers/net/ethernet/mellanox/mlx4/catas.c
index 915e947..83d03ef 100644
--- a/drivers/net/ethernet/mellanox/mlx4/catas.c
+++ b/drivers/net/ethernet/mellanox/mlx4/catas.c
@@ -31,6 +31,7 @@
  * SOFTWARE.
  */
 
+#include <linux/spinlock.h>
 #include <linux/workqueue.h>
 #include <linux/module.h>
 
diff --git a/drivers/net/wimax/i2400m/sdio-rx.c b/drivers/net/wimax/i2400m/sdio-rx.c
index fb6396d..df520c0 100644
--- a/drivers/net/wimax/i2400m/sdio-rx.c
+++ b/drivers/net/wimax/i2400m/sdio-rx.c
@@ -60,6 +60,7 @@
  *
  * i2400ms_rx_release()
  */
+#include <linux/spinlock.h>
 #include <linux/workqueue.h>
 #include <linux/wait.h>
 #include <linux/skbuff.h>
diff --git a/drivers/net/wimax/i2400m/usb-rx.c b/drivers/net/wimax/i2400m/usb-rx.c
index e325768..3df7308 100644
--- a/drivers/net/wimax/i2400m/usb-rx.c
+++ b/drivers/net/wimax/i2400m/usb-rx.c
@@ -82,6 +82,7 @@
  *
  * i2400mu_rx_release()            called from i2400mu_bus_dev_stop()
  */
+#include <linux/spinlock.h>
 #include <linux/workqueue.h>
 #include <linux/slab.h>
 #include <linux/usb.h>
diff --git a/drivers/usb/wusbcore/wa-nep.c b/drivers/usb/wusbcore/wa-nep.c
index f67f7f1..9352e3f 100644
--- a/drivers/usb/wusbcore/wa-nep.c
+++ b/drivers/usb/wusbcore/wa-nep.c
@@ -49,6 +49,7 @@
  *                                endpoint; when data is ready, this
  *                                does the dispatching.
  */
+#include <linux/spinlock.h>
 #include <linux/workqueue.h>
 #include <linux/ctype.h>
 #include <linux/slab.h>
diff --git a/drivers/uwb/umc-bus.c b/drivers/uwb/umc-bus.c
index 82a84d5..287ed00 100644
--- a/drivers/uwb/umc-bus.c
+++ b/drivers/uwb/umc-bus.c
@@ -7,6 +7,7 @@
  */
 #include <linux/kernel.h>
 #include <linux/sysfs.h>
+#include <linux/spinlock.h>
 #include <linux/workqueue.h>
 #include <linux/module.h>
 #include <linux/uwb/umc.h>
diff --git a/fs/ocfs2/cluster/quorum.c b/fs/ocfs2/cluster/quorum.c
index 8f9cea1..663eaa5 100644
--- a/fs/ocfs2/cluster/quorum.c
+++ b/fs/ocfs2/cluster/quorum.c
@@ -44,6 +44,7 @@
  * and if they're the last, they fire off the decision.
  */
 #include <linux/kernel.h>
+#include <linux/spinlock.h>
 #include <linux/workqueue.h>
 #include <linux/reboot.h>
 
diff --git a/include/drm/ttm/ttm_memory.h b/include/drm/ttm/ttm_memory.h
index 26c1f78..253daaf 100644
--- a/include/drm/ttm/ttm_memory.h
+++ b/include/drm/ttm/ttm_memory.h
@@ -28,8 +28,8 @@
 #ifndef TTM_MEMORY_H
 #define TTM_MEMORY_H
 
-#include <linux/workqueue.h>
 #include <linux/spinlock.h>
+#include <linux/workqueue.h>
 #include <linux/wait.h>
 #include <linux/errno.h>
 #include <linux/kobject.h>
diff --git a/include/linux/connector.h b/include/linux/connector.h
index 3c9c54f..5140306 100644
--- a/include/linux/connector.h
+++ b/include/linux/connector.h
@@ -78,6 +78,7 @@ struct cn_msg {
 #include <linux/atomic.h>
 
 #include <linux/list.h>
+#include <linux/spinlock.h>
 #include <linux/workqueue.h>
 
 #include <net/sock.h>
diff --git a/include/linux/memstick.h b/include/linux/memstick.h
index 690c35a..df1fe98 100644
--- a/include/linux/memstick.h
+++ b/include/linux/memstick.h
@@ -12,6 +12,7 @@
 #ifndef _MEMSTICK_H
 #define _MEMSTICK_H
 
+#include <linux/spinlock.h>
 #include <linux/workqueue.h>
 #include <linux/scatterlist.h>
 #include <linux/device.h>
diff --git a/include/linux/timer.h b/include/linux/timer.h
index 25bd863..d05e5ae 100644
--- a/include/linux/timer.h
+++ b/include/linux/timer.h
@@ -1,6 +1,7 @@
 #ifndef _LINUX_TIMER_H
 #define _LINUX_TIMER_H
 
+#include <linux/lockdep.h>
 #include <linux/list.h>
 #include <linux/stddef.h>
 #include <linux/stringify.h>
diff --git a/net/nfc/nci/core.c b/net/nfc/nci/core.c
index 7650139..e7fd391 100644
--- a/net/nfc/nci/core.c
+++ b/net/nfc/nci/core.c
@@ -28,6 +28,7 @@
 #define pr_fmt(fmt) KBUILD_MODNAME ": %s: " fmt, __func__
 
 #include <linux/types.h>
+#include <linux/spinlock.h>
 #include <linux/workqueue.h>
 #include <linux/completion.h>
 #include <linux/export.h>

--------------090702020702090609050600--

