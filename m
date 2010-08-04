Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759083Ab0HDVTe (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Aug 2010 17:19:34 -0400
Received: from gate.lvk.cs.msu.su ([158.250.17.1]:57594 "EHLO
	mail.lvk.cs.msu.su" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759075Ab0HDVS4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Aug 2010 17:18:56 -0400
X-Greylist: delayed 627 seconds by postgrey-1.27 at vger.kernel.org; Wed, 04 Aug 2010 17:18:56 EDT
X-Spam-ASN: 
From: Alexander Gordeev <lasaine@lvk.cs.msu.su>
To: linux-kernel@vger.kernel.org
Cc: "Nikita V\. Youshchenko" <yoush@cs.msu.su>, linuxpps@ml.enneenne.com,
        Rodolfo Giometti <giometti@enneenne.com>,
        john stultz <johnstul@us.ibm.com>,
        Alexander Gordeev <lasaine@lvk.cs.msu.su>,
        Randy Dunlap <rdunlap@xenotime.net>,
        Andrew Morton <akpm@linux-foundation.org>,
        Ryusuke Konishi <konishi.ryusuke@lab.ntt.co.jp>,
        Jim Collar <jim.collar@eqware.net>,
        Greg Kroah-Hartman <gregkh@suse.de>, Tejun Heo <tj@kernel.org>,
        Joonwoo Park <joonwpark81@gmail.com>, linux-doc@vger.kernel.org
Subject: [PATCHv3 14/16] pps: add kernel consumer support
Date: Thu,  5 Aug 2010 01:06:51 +0400
Message-Id: <211661b492e65ec720a6106b947ecbecf1f66f3c.1280952801.git.lasaine@lvk.cs.msu.su>
X-Mailer: git-send-email 1.7.1
In-Reply-To: <cover.1280952801.git.lasaine@lvk.cs.msu.su>
References: <cover.1280952801.git.lasaine@lvk.cs.msu.su>
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
index dd5806f..e507f84 100644
--- a/Documentation/ioctl/ioctl-number.txt
+++ b/Documentation/ioctl/ioctl-number.txt
@@ -248,7 +248,7 @@ Code  Seq#(hex)	Include File		Comments
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
index 0335b2c..02f4dd1 100644
--- a/drivers/pps/kapi.c
+++ b/drivers/pps/kapi.c
@@ -25,6 +25,7 @@
 #include <linux/init.h>
 #include <linux/sched.h>
 #include <linux/time.h>
+#include <linux/timex.h>
 #include <linux/spinlock.h>
 #include <linux/fs.h>
 #include <linux/pps_kernel.h>
@@ -37,6 +38,12 @@
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
@@ -140,6 +147,16 @@ EXPORT_SYMBOL(pps_register_source);
 
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
 }
 EXPORT_SYMBOL(pps_unregister_source);
@@ -209,6 +226,12 @@ void pps_event(struct pps_device *pps, struct pps_event_time *ts, int event,
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
index 4f02718..c288b72 100644
--- a/drivers/pps/pps.c
+++ b/drivers/pps/pps.c
@@ -196,9 +196,69 @@ static long pps_cdev_ioctl(struct file *file,
 
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
index 39fc712..10e10c8 100644
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
1.7.1

