Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932159Ab0KRQNq (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Nov 2010 11:13:46 -0500
Received: from gate.lvk.cs.msu.su ([158.250.17.1]:36034 "EHLO
	mail.lvk.cs.msu.su" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759451Ab0KRQMf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Nov 2010 11:12:35 -0500
From: Alexander Gordeev <lasaine@lvk.cs.msu.su>
To: linux-kernel@vger.kernel.org
Cc: "Nikita V\. Youshchenko" <yoush@cs.msu.su>, linuxpps@ml.enneenne.com,
        Rodolfo Giometti <giometti@enneenne.com>,
        Alexander Gordeev <lasaine@lvk.cs.msu.su>,
        Randy Dunlap <rdunlap@xenotime.net>,
        Andrew Morton <akpm@linux-foundation.org>,
        Thomas Weber <weber@corscience.de>,
        Mike Frysinger <vapier.adi@gmail.com>,
        Stefan Richter <stefanr@s5r6.in-berlin.de>,
        Jiri Kosina <jkosina@suse.cz>, John Stultz <johnstul@us.ibm.com>,
        Tejun Heo <tj@kernel.org>, linux-doc@vger.kernel.org
Subject: [PATCHv4 15/17] pps: add kernel consumer support
Date: Thu, 18 Nov 2010 19:01:08 +0300
Message-Id: <21889ed6073f8e22eabc729e21540db13761dd92.1290087480.git.lasaine@lvk.cs.msu.su>
X-Mailer: git-send-email 1.7.2.3
In-Reply-To: <cover.1290087473.git.lasaine@lvk.cs.msu.su>
References: <cover.1290087473.git.lasaine@lvk.cs.msu.su>
X-AV-Checked: ClamAV using ClamSMTP
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add an optional feature of PPSAPI, kernel consumer support, which uses
the added hardpps() function.

Signed-off-by: Alexander Gordeev <lasaine@lvk.cs.msu.su>
---
 Documentation/ioctl/ioctl-number.txt |    2 +-
 drivers/pps/Kconfig                  |    1 +
 drivers/pps/kapi.c                   |   23 ++++++++++++
 drivers/pps/pps.c                    |   62 +++++++++++++++++++++++++++++++++-
 include/linux/pps.h                  |    7 ++++
 include/linux/pps_kernel.h           |    6 +++
 6 files changed, 99 insertions(+), 2 deletions(-)

diff --git a/Documentation/ioctl/ioctl-number.txt b/Documentation/ioctl/ioctl-number.txt
index 33223ff..de2b113 100644
--- a/Documentation/ioctl/ioctl-number.txt
+++ b/Documentation/ioctl/ioctl-number.txt
@@ -249,7 +249,7 @@ Code  Seq#(hex)	Include File		Comments
 'p'	40-7F	linux/nvram.h
 'p'	80-9F	linux/ppdev.h		user-space parport
 					<mailto:tim@cyberelk.net>
-'p'	A1-A4	linux/pps.h		LinuxPPS
+'p'	A1-A5	linux/pps.h		LinuxPPS
 					<mailto:giometti@linux.it>
 'q'	00-1F	linux/serio.h
 'q'	80-FF	linux/telephony.h	Internet PhoneJACK, Internet LineJACK
diff --git a/drivers/pps/Kconfig b/drivers/pps/Kconfig
index 33c9126..4823e47 100644
--- a/drivers/pps/Kconfig
+++ b/drivers/pps/Kconfig
@@ -7,6 +7,7 @@ menu "PPS support"
 config PPS
 	tristate "PPS support"
 	depends on EXPERIMENTAL
+	select NTP_PPS
 	---help---
 	  PPS (Pulse Per Second) is a special pulse provided by some GPS
 	  antennae. Userland can use it to get a high-precision time
diff --git a/drivers/pps/kapi.c b/drivers/pps/kapi.c
index 2bdfbed..0026c99 100644
--- a/drivers/pps/kapi.c
+++ b/drivers/pps/kapi.c
@@ -26,6 +26,7 @@
 #include <linux/init.h>
 #include <linux/sched.h>
 #include <linux/time.h>
+#include <linux/timex.h>
 #include <linux/spinlock.h>
 #include <linux/fs.h>
 #include <linux/pps_kernel.h>
@@ -38,6 +39,12 @@
 /* PPS event workqueue */
 struct workqueue_struct *pps_event_workqueue;
 
+/* state variables to bind kernel consumer */
+/* PPS API (RFC 2783): current source and mode for ``kernel consumer'' */
+DEFINE_SPINLOCK(pps_kc_hardpps_lock);
+void	*pps_kc_hardpps_dev;	/* some unique pointer to device */
+int	pps_kc_hardpps_mode;	/* mode bits for kernel consumer */
+
 /*
  * Local functions
  */
@@ -141,6 +148,16 @@ EXPORT_SYMBOL(pps_register_source);
 
 void pps_unregister_source(struct pps_device *pps)
 {
+	spin_lock(&pps_kc_hardpps_lock);
+	if (pps == pps_kc_hardpps_dev) {
+		pps_kc_hardpps_mode = 0;
+		pps_kc_hardpps_dev = NULL;
+		spin_unlock(&pps_kc_hardpps_lock);
+		dev_info(pps->dev, "unbound kernel consumer"
+				" on device removal\n");
+	} else
+		spin_unlock(&pps_kc_hardpps_lock);
+
 	pps_unregister_cdev(pps);
 
 	/* don't have to kfree(pps) here because it will be done on
@@ -213,6 +230,12 @@ void pps_event(struct pps_device *pps, struct pps_event_time *ts, int event,
 		captured = ~0;
 	}
 
+	/* Pass some events to kernel consumer if activated */
+	spin_lock(&pps_kc_hardpps_lock);
+	if (pps == pps_kc_hardpps_dev && event & pps_kc_hardpps_mode)
+		hardpps(&ts->ts_real, &ts->ts_raw);
+	spin_unlock(&pps_kc_hardpps_lock);
+
 	/* Wake up if captured something */
 	if (captured) {
 		pps->last_ev++;
diff --git a/drivers/pps/pps.c b/drivers/pps/pps.c
index d3267f3..6cedb8b 100644
--- a/drivers/pps/pps.c
+++ b/drivers/pps/pps.c
@@ -197,9 +197,69 @@ static long pps_cdev_ioctl(struct file *file,
 
 		break;
 	}
+	case PPS_KC_BIND: {
+		struct pps_bind_args bind_args;
+
+		dev_dbg(pps->dev, "PPS_KC_BIND\n");
+
+		/* Check the capabilities */
+		if (!capable(CAP_SYS_TIME))
+			return -EPERM;
+
+		if (copy_from_user(&bind_args, uarg,
+					sizeof(struct pps_bind_args)))
+			return -EFAULT;
+
+		/* Check for supported capabilities */
+		if ((bind_args.edge & ~pps->info.mode) != 0) {
+			dev_err(pps->dev, "unsupported capabilities (%x)\n",
+					bind_args.edge);
+			return -EINVAL;
+		}
+
+		/* Validate parameters roughly */
+		if (bind_args.tsformat != PPS_TSFMT_TSPEC ||
+				(bind_args.edge & ~PPS_CAPTUREBOTH) != 0 ||
+				bind_args.consumer != PPS_KC_HARDPPS) {
+			dev_err(pps->dev, "invalid kernel consumer bind"
+					" parameters (%x)\n", bind_args.edge);
+			return -EINVAL;
+		}
+
+		/* Check if another consumer is already bound */
+		spin_lock(&pps_kc_hardpps_lock);
+
+		if (bind_args.edge == 0)
+			if (pps_kc_hardpps_dev == pps) {
+				pps_kc_hardpps_mode = 0;
+				pps_kc_hardpps_dev = NULL;
+				spin_unlock(&pps_kc_hardpps_lock);
+				dev_info(pps->dev, "unbound kernel"
+						" consumer\n");
+			} else {
+				spin_unlock(&pps_kc_hardpps_lock);
+				dev_err(pps->dev, "selected kernel consumer"
+						" is not bound\n");
+				return -EINVAL;
+			}
+		else
+			if (pps_kc_hardpps_dev == NULL ||
+					pps_kc_hardpps_dev == pps) {
+				pps_kc_hardpps_mode = bind_args.edge;
+				pps_kc_hardpps_dev = pps;
+				spin_unlock(&pps_kc_hardpps_lock);
+				dev_info(pps->dev, "bound kernel consumer: "
+					"edge=0x%x\n", bind_args.edge);
+			} else {
+				spin_unlock(&pps_kc_hardpps_lock);
+				dev_err(pps->dev, "another kernel consumer"
+						" is already bound\n");
+				return -EINVAL;
+			}
+		break;
+	}
 	default:
 		return -ENOTTY;
-		break;
 	}
 
 	return 0;
diff --git a/include/linux/pps.h b/include/linux/pps.h
index 0194ab0..a9bb1d9 100644
--- a/include/linux/pps.h
+++ b/include/linux/pps.h
@@ -114,11 +114,18 @@ struct pps_fdata {
 	struct pps_ktime timeout;
 };
 
+struct pps_bind_args {
+	int tsformat;	/* format of time stamps */
+	int edge;	/* selected event type */
+	int consumer;	/* selected kernel consumer */
+};
+
 #include <linux/ioctl.h>
 
 #define PPS_GETPARAMS		_IOR('p', 0xa1, struct pps_kparams *)
 #define PPS_SETPARAMS		_IOW('p', 0xa2, struct pps_kparams *)
 #define PPS_GETCAP		_IOR('p', 0xa3, int *)
 #define PPS_FETCH		_IOWR('p', 0xa4, struct pps_fdata *)
+#define PPS_KC_BIND		_IOW('p', 0xa5, struct pps_bind_args *)
 
 #endif /* _PPS_H_ */
diff --git a/include/linux/pps_kernel.h b/include/linux/pps_kernel.h
index 39fc7125..10e10c8 100644
--- a/include/linux/pps_kernel.h
+++ b/include/linux/pps_kernel.h
@@ -87,6 +87,12 @@ struct pps_device {
 
 extern struct device_attribute pps_attrs[];
 
+/* state variables to bind kernel consumer */
+/* PPS API (RFC 2783): current source and mode for ``kernel consumer'' */
+extern spinlock_t pps_kc_hardpps_lock;
+extern void *pps_kc_hardpps_dev;	/* some unique pointer to device */
+extern int pps_kc_hardpps_mode;		/* mode bits for kernel consumer */
+
 extern struct workqueue_struct *pps_event_workqueue;
 
 /*
-- 
1.7.2.3

