Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751822Ab1FMJzw (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Jun 2011 05:55:52 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:40899 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751764Ab1FMJzs (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Jun 2011 05:55:48 -0400
Date: Mon, 13 Jun 2011 11:55:38 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, Thomas Gleixner <tglx@linutronix.de>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: [GIT PULL] timer fixes
Message-ID: <20110613095538.GA24871@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.20 (2009-08-17)
X-ELTE-SpamScore: -2.0
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-2.0 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.3.1
	-2.0 BAYES_00               BODY: Bayes spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Linus,

Please pull the latest timers-urgent-for-linus git tree from:

   git://git.kernel.org/pub/scm/linux/kernel/git/tip/linux-2.6-tip.git timers-urgent-for-linus

 Thanks,

	Ingo

------------------>
Dan Carpenter (2):
      ptp: Return -EFAULT on copy_to_user() errors
      ptp: Fix some locking bugs in ptp_read()

John Stultz (1):
      rtc: Fix ioctl error path return

Mark Brown (1):
      rtc: Staticize non-exported __rtc_set_alarm()


 drivers/ptp/ptp_chardev.c |   11 ++++++-----
 drivers/rtc/interface.c   |    2 +-
 drivers/rtc/rtc-dev.c     |    3 ++-
 3 files changed, 9 insertions(+), 7 deletions(-)

diff --git a/drivers/ptp/ptp_chardev.c b/drivers/ptp/ptp_chardev.c
index a8d03ae..e7f301da2 100644
--- a/drivers/ptp/ptp_chardev.c
+++ b/drivers/ptp/ptp_chardev.c
@@ -46,7 +46,8 @@ long ptp_ioctl(struct posix_clock *pc, unsigned int cmd, unsigned long arg)
 		caps.n_ext_ts = ptp->info->n_ext_ts;
 		caps.n_per_out = ptp->info->n_per_out;
 		caps.pps = ptp->info->pps;
-		err = copy_to_user((void __user *)arg, &caps, sizeof(caps));
+		if (copy_to_user((void __user *)arg, &caps, sizeof(caps)))
+			err = -EFAULT;
 		break;
 
 	case PTP_EXTTS_REQUEST:
@@ -129,8 +130,10 @@ ssize_t ptp_read(struct posix_clock *pc,
 		return -ERESTARTSYS;
 	}
 
-	if (ptp->defunct)
+	if (ptp->defunct) {
+		mutex_unlock(&ptp->tsevq_mux);
 		return -ENODEV;
+	}
 
 	spin_lock_irqsave(&queue->lock, flags);
 
@@ -150,10 +153,8 @@ ssize_t ptp_read(struct posix_clock *pc,
 
 	mutex_unlock(&ptp->tsevq_mux);
 
-	if (copy_to_user(buf, event, cnt)) {
-		mutex_unlock(&ptp->tsevq_mux);
+	if (copy_to_user(buf, event, cnt))
 		return -EFAULT;
-	}
 
 	return cnt;
 }
diff --git a/drivers/rtc/interface.c b/drivers/rtc/interface.c
index ef6316a..df68618 100644
--- a/drivers/rtc/interface.c
+++ b/drivers/rtc/interface.c
@@ -318,7 +318,7 @@ int rtc_read_alarm(struct rtc_device *rtc, struct rtc_wkalrm *alarm)
 }
 EXPORT_SYMBOL_GPL(rtc_read_alarm);
 
-int __rtc_set_alarm(struct rtc_device *rtc, struct rtc_wkalrm *alarm)
+static int __rtc_set_alarm(struct rtc_device *rtc, struct rtc_wkalrm *alarm)
 {
 	struct rtc_time tm;
 	long now, scheduled;
diff --git a/drivers/rtc/rtc-dev.c b/drivers/rtc/rtc-dev.c
index d0e06ed..cace6d3 100644
--- a/drivers/rtc/rtc-dev.c
+++ b/drivers/rtc/rtc-dev.c
@@ -421,7 +421,8 @@ static long rtc_dev_ioctl(struct file *file,
 			err = ops->ioctl(rtc->dev.parent, cmd, arg);
 			if (err == -ENOIOCTLCMD)
 				err = -ENOTTY;
-		}
+		} else
+			err = -ENOTTY;
 		break;
 	}
 
