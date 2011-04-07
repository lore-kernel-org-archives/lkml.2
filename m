Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755526Ab1DGRnE (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Apr 2011 13:43:04 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:38048 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754001Ab1DGRnC (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Apr 2011 13:43:02 -0400
Date: Thu, 7 Apr 2011 19:42:49 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, Thomas Gleixner <tglx@linutronix.de>,
        Alan Cox <alan@linux.intel.com>, "H. Peter Anvin" <hpa@zytor.com>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: [GIT PULL] timer fixes
Message-ID: <20110407174249.GA26266@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.20 (2009-08-17)
X-ELTE-SpamScore: -2.0
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-2.0 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.5
	-2.0 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Linus,

Please pull the latest timers-fixes-for-linus git tree from:

   git://git.kernel.org/pub/scm/linux/kernel/git/tip/linux-2.6-tip.git timers-fixes-for-linus

 Thanks,

	Ingo

------------------>
Feng Tang (2):
      rtc, x86/mrst/vrtc: Fix boot crash in rtc_read_alarm()
      x86/mrst/vrtc: Fix boot crash in mrst_rtc_init()


 arch/x86/platform/mrst/vrtc.c |    4 +++-
 drivers/rtc/rtc-mrst.c        |    7 ++++---
 2 files changed, 7 insertions(+), 4 deletions(-)

diff --git a/arch/x86/platform/mrst/vrtc.c b/arch/x86/platform/mrst/vrtc.c
index 04cf645..73d70d6 100644
--- a/arch/x86/platform/mrst/vrtc.c
+++ b/arch/x86/platform/mrst/vrtc.c
@@ -100,9 +100,11 @@ int vrtc_set_mmss(unsigned long nowtime)
 
 void __init mrst_rtc_init(void)
 {
-	unsigned long vrtc_paddr = sfi_mrtc_array[0].phys_addr;
+	unsigned long vrtc_paddr;
 
 	sfi_table_parse(SFI_SIG_MRTC, NULL, NULL, sfi_parse_mrtc);
+
+	vrtc_paddr = sfi_mrtc_array[0].phys_addr;
 	if (!sfi_mrtc_num || !vrtc_paddr)
 		return;
 
diff --git a/drivers/rtc/rtc-mrst.c b/drivers/rtc/rtc-mrst.c
index 332a2c4..b2f0968 100644
--- a/drivers/rtc/rtc-mrst.c
+++ b/drivers/rtc/rtc-mrst.c
@@ -342,6 +342,8 @@ vrtc_mrst_do_probe(struct device *dev, struct resource *iomem, int rtc_irq)
 
 	mrst_rtc.irq = rtc_irq;
 	mrst_rtc.iomem = iomem;
+	mrst_rtc.dev = dev;
+	dev_set_drvdata(dev, &mrst_rtc);
 
 	mrst_rtc.rtc = rtc_device_register(driver_name, dev,
 				&mrst_rtc_ops, THIS_MODULE);
@@ -350,8 +352,6 @@ vrtc_mrst_do_probe(struct device *dev, struct resource *iomem, int rtc_irq)
 		goto cleanup0;
 	}
 
-	mrst_rtc.dev = dev;
-	dev_set_drvdata(dev, &mrst_rtc);
 	rename_region(iomem, dev_name(&mrst_rtc.rtc->dev));
 
 	spin_lock_irq(&rtc_lock);
@@ -376,9 +376,10 @@ vrtc_mrst_do_probe(struct device *dev, struct resource *iomem, int rtc_irq)
 	return 0;
 
 cleanup1:
-	mrst_rtc.dev = NULL;
 	rtc_device_unregister(mrst_rtc.rtc);
 cleanup0:
+	dev_set_drvdata(dev, NULL);
+	mrst_rtc.dev = NULL;
 	release_region(iomem->start, iomem->end + 1 - iomem->start);
 	dev_err(dev, "rtc-mrst: unable to initialise\n");
 	return retval;
