Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755029Ab1EQNZi (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 May 2011 09:25:38 -0400
Received: from www.linutronix.de ([62.245.132.108]:48782 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754881Ab1EQNZg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 May 2011 09:25:36 -0400
Date: Tue, 17 May 2011 15:25:20 +0200 (CEST)
From: Thomas Gleixner <tglx@linutronix.de>
To: Linus Torvalds <torvalds@linux-foundation.org>
cc: Andrew Morton <akpm@linux-foundation.org>, Ingo Molnar <mingo@elte.hu>,
        John Stultz <johnstul@us.ibm.com>, LKML <linux-kernel@vger.kernel.org>
Subject: [GIT pull] timer fixes for 2.6.39
Message-ID: <alpine.LFD.2.02.1105171521070.3078@ionos>
User-Agent: Alpine 2.02 (LFD 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: MULTIPART/MIXED; BOUNDARY="8323328-1096934113-1305638721=:3078"
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

  This message is in MIME format.  The first part should be readable text,
  while the remaining parts are likely unreadable without MIME-aware tools.

--8323328-1096934113-1305638721=:3078
Content-Type: TEXT/PLAIN; charset=ISO-8859-15
Content-Transfer-Encoding: 8BIT

Linus,

Please pull the latest timers-fixes-for-linus git tree from:

   git://git.kernel.org/pub/scm/linux/kernel/git/tip/linux-2.6-tip.git timers-fixes-for-linus

Two timer core code bug fixes and the last fallout of the RTC rework
(people started finally testing and got bitten by old - previously
harmless - init order problems in a bunch of drivers).

Thanks,

	tglx

------------------>
John Stultz (8):
      clocksource: Install completely before selecting
      rtc: ds1286: Initialize drvdata before registering device
      rtc: m41t80: Initialize clientdata before registering device
      rtc: max8925: Initialize drvdata before registering device
      rtc: max8998: Initialize drvdata before registering device
      rtc: msm6242: Initialize drvdata before registering device
      rtc: pcap: Initialize drvdata before registering device
      rtc: rp5c01: Initialize drvdata before registering device

Thomas Gleixner (1):
      tick: Clear broadcast active bit when switching to oneshot

Uwe Kleine-König (1):
      rtc: mc13xxx: Don't call rtc_device_register while holding lock

Wolfram Sang (3):
      rtc: mxc: Initialize drvdata before registering device
      rtc: davinci: Initialize drvdata before registering device
      rtc: ep93xx: Initialize drvdata before registering device


 drivers/rtc/rtc-davinci.c    |    5 +++--
 drivers/rtc/rtc-ds1286.c     |    2 +-
 drivers/rtc/rtc-ep93xx.c     |    5 ++---
 drivers/rtc/rtc-m41t80.c     |    5 +++--
 drivers/rtc/rtc-max8925.c    |    5 +++--
 drivers/rtc/rtc-max8998.c    |    5 +++--
 drivers/rtc/rtc-mc13xxx.c    |    8 ++++++--
 drivers/rtc/rtc-msm6242.c    |    3 ++-
 drivers/rtc/rtc-mxc.c        |   19 +++++++++++--------
 drivers/rtc/rtc-pcap.c       |    4 +++-
 drivers/rtc/rtc-rp5c01.c     |    5 +++--
 kernel/time/clocksource.c    |    4 ++--
 kernel/time/tick-broadcast.c |   12 +++++++++++-
 13 files changed, 53 insertions(+), 29 deletions(-)

diff --git a/drivers/rtc/rtc-davinci.c b/drivers/rtc/rtc-davinci.c
index 8d46838..755e1fe 100644
--- a/drivers/rtc/rtc-davinci.c
+++ b/drivers/rtc/rtc-davinci.c
@@ -524,6 +524,8 @@ static int __init davinci_rtc_probe(struct platform_device *pdev)
 		goto fail2;
 	}
 
+	platform_set_drvdata(pdev, davinci_rtc);
+
 	davinci_rtc->rtc = rtc_device_register(pdev->name, &pdev->dev,
 				    &davinci_rtc_ops, THIS_MODULE);
 	if (IS_ERR(davinci_rtc->rtc)) {
@@ -553,8 +555,6 @@ static int __init davinci_rtc_probe(struct platform_device *pdev)
 
 	rtcss_write(davinci_rtc, PRTCSS_RTC_CCTRL_CAEN, PRTCSS_RTC_CCTRL);
 
-	platform_set_drvdata(pdev, davinci_rtc);
-
 	device_init_wakeup(&pdev->dev, 0);
 
 	return 0;
@@ -562,6 +562,7 @@ static int __init davinci_rtc_probe(struct platform_device *pdev)
 fail4:
 	rtc_device_unregister(davinci_rtc->rtc);
 fail3:
+	platform_set_drvdata(pdev, NULL);
 	iounmap(davinci_rtc->base);
 fail2:
 	release_mem_region(davinci_rtc->pbase, davinci_rtc->base_size);
diff --git a/drivers/rtc/rtc-ds1286.c b/drivers/rtc/rtc-ds1286.c
index 60ce696..47e681d 100644
--- a/drivers/rtc/rtc-ds1286.c
+++ b/drivers/rtc/rtc-ds1286.c
@@ -355,6 +355,7 @@ static int __devinit ds1286_probe(struct platform_device *pdev)
 		goto out;
 	}
 	spin_lock_init(&priv->lock);
+	platform_set_drvdata(pdev, priv);
 	rtc = rtc_device_register("ds1286", &pdev->dev,
 				  &ds1286_ops, THIS_MODULE);
 	if (IS_ERR(rtc)) {
@@ -362,7 +363,6 @@ static int __devinit ds1286_probe(struct platform_device *pdev)
 		goto out;
 	}
 	priv->rtc = rtc;
-	platform_set_drvdata(pdev, priv);
 	return 0;
 
 out:
diff --git a/drivers/rtc/rtc-ep93xx.c b/drivers/rtc/rtc-ep93xx.c
index 11ae64d..335551d 100644
--- a/drivers/rtc/rtc-ep93xx.c
+++ b/drivers/rtc/rtc-ep93xx.c
@@ -151,6 +151,7 @@ static int __init ep93xx_rtc_probe(struct platform_device *pdev)
 		return -ENXIO;
 
 	pdev->dev.platform_data = ep93xx_rtc;
+	platform_set_drvdata(pdev, rtc);
 
 	rtc = rtc_device_register(pdev->name,
 				&pdev->dev, &ep93xx_rtc_ops, THIS_MODULE);
@@ -159,8 +160,6 @@ static int __init ep93xx_rtc_probe(struct platform_device *pdev)
 		goto exit;
 	}
 
-	platform_set_drvdata(pdev, rtc);
-
 	err = sysfs_create_group(&pdev->dev.kobj, &ep93xx_rtc_sysfs_files);
 	if (err)
 		goto fail;
@@ -168,9 +167,9 @@ static int __init ep93xx_rtc_probe(struct platform_device *pdev)
 	return 0;
 
 fail:
-	platform_set_drvdata(pdev, NULL);
 	rtc_device_unregister(rtc);
 exit:
+	platform_set_drvdata(pdev, NULL);
 	pdev->dev.platform_data = NULL;
 	return err;
 }
diff --git a/drivers/rtc/rtc-m41t80.c b/drivers/rtc/rtc-m41t80.c
index 69fe664..eda128f 100644
--- a/drivers/rtc/rtc-m41t80.c
+++ b/drivers/rtc/rtc-m41t80.c
@@ -783,6 +783,9 @@ static int m41t80_probe(struct i2c_client *client,
 		goto exit;
 	}
 
+	clientdata->features = id->driver_data;
+	i2c_set_clientdata(client, clientdata);
+
 	rtc = rtc_device_register(client->name, &client->dev,
 				  &m41t80_rtc_ops, THIS_MODULE);
 	if (IS_ERR(rtc)) {
@@ -792,8 +795,6 @@ static int m41t80_probe(struct i2c_client *client,
 	}
 
 	clientdata->rtc = rtc;
-	clientdata->features = id->driver_data;
-	i2c_set_clientdata(client, clientdata);
 
 	/* Make sure HT (Halt Update) bit is cleared */
 	rc = i2c_smbus_read_byte_data(client, M41T80_REG_ALARM_HOUR);
diff --git a/drivers/rtc/rtc-max8925.c b/drivers/rtc/rtc-max8925.c
index 20494b5..3bc046f 100644
--- a/drivers/rtc/rtc-max8925.c
+++ b/drivers/rtc/rtc-max8925.c
@@ -258,6 +258,8 @@ static int __devinit max8925_rtc_probe(struct platform_device *pdev)
 	}
 
 	dev_set_drvdata(&pdev->dev, info);
+	/* XXX - isn't this redundant? */
+	platform_set_drvdata(pdev, info);
 
 	info->rtc_dev = rtc_device_register("max8925-rtc", &pdev->dev,
 					&max8925_rtc_ops, THIS_MODULE);
@@ -267,10 +269,9 @@ static int __devinit max8925_rtc_probe(struct platform_device *pdev)
 		goto out_rtc;
 	}
 
-	platform_set_drvdata(pdev, info);
-
 	return 0;
 out_rtc:
+	platform_set_drvdata(pdev, NULL);
 	free_irq(chip->irq_base + MAX8925_IRQ_RTC_ALARM0, info);
 out_irq:
 	kfree(info);
diff --git a/drivers/rtc/rtc-max8998.c b/drivers/rtc/rtc-max8998.c
index 3f7bc6b..2e48aa6 100644
--- a/drivers/rtc/rtc-max8998.c
+++ b/drivers/rtc/rtc-max8998.c
@@ -265,6 +265,8 @@ static int __devinit max8998_rtc_probe(struct platform_device *pdev)
 	info->rtc = max8998->rtc;
 	info->irq = max8998->irq_base + MAX8998_IRQ_ALARM0;
 
+	platform_set_drvdata(pdev, info);
+
 	info->rtc_dev = rtc_device_register("max8998-rtc", &pdev->dev,
 			&max8998_rtc_ops, THIS_MODULE);
 
@@ -274,8 +276,6 @@ static int __devinit max8998_rtc_probe(struct platform_device *pdev)
 		goto out_rtc;
 	}
 
-	platform_set_drvdata(pdev, info);
-
 	ret = request_threaded_irq(info->irq, NULL, max8998_rtc_alarm_irq, 0,
 			"rtc-alarm0", info);
 
@@ -293,6 +293,7 @@ static int __devinit max8998_rtc_probe(struct platform_device *pdev)
 	return 0;
 
 out_rtc:
+	platform_set_drvdata(pdev, NULL);
 	kfree(info);
 	return ret;
 }
diff --git a/drivers/rtc/rtc-mc13xxx.c b/drivers/rtc/rtc-mc13xxx.c
index c5ac037..a1a278b 100644
--- a/drivers/rtc/rtc-mc13xxx.c
+++ b/drivers/rtc/rtc-mc13xxx.c
@@ -349,11 +349,15 @@ static int __devinit mc13xxx_rtc_probe(struct platform_device *pdev)
 	if (ret)
 		goto err_alarm_irq_request;
 
+	mc13xxx_unlock(mc13xxx);
+
 	priv->rtc = rtc_device_register(pdev->name,
 			&pdev->dev, &mc13xxx_rtc_ops, THIS_MODULE);
 	if (IS_ERR(priv->rtc)) {
 		ret = PTR_ERR(priv->rtc);
 
+		mc13xxx_lock(mc13xxx);
+
 		mc13xxx_irq_free(mc13xxx, MC13XXX_IRQ_TODA, priv);
 err_alarm_irq_request:
 
@@ -365,12 +369,12 @@ err_reset_irq_status:
 		mc13xxx_irq_free(mc13xxx, MC13XXX_IRQ_RTCRST, priv);
 err_reset_irq_request:
 
+		mc13xxx_unlock(mc13xxx);
+
 		platform_set_drvdata(pdev, NULL);
 		kfree(priv);
 	}
 
-	mc13xxx_unlock(mc13xxx);
-
 	return ret;
 }
 
diff --git a/drivers/rtc/rtc-msm6242.c b/drivers/rtc/rtc-msm6242.c
index 6782062..fcb113c 100644
--- a/drivers/rtc/rtc-msm6242.c
+++ b/drivers/rtc/rtc-msm6242.c
@@ -214,6 +214,7 @@ static int __init msm6242_rtc_probe(struct platform_device *dev)
 		error = -ENOMEM;
 		goto out_free_priv;
 	}
+	platform_set_drvdata(dev, priv);
 
 	rtc = rtc_device_register("rtc-msm6242", &dev->dev, &msm6242_rtc_ops,
 				  THIS_MODULE);
@@ -223,10 +224,10 @@ static int __init msm6242_rtc_probe(struct platform_device *dev)
 	}
 
 	priv->rtc = rtc;
-	platform_set_drvdata(dev, priv);
 	return 0;
 
 out_unmap:
+	platform_set_drvdata(dev, NULL);
 	iounmap(priv->regs);
 out_free_priv:
 	kfree(priv);
diff --git a/drivers/rtc/rtc-mxc.c b/drivers/rtc/rtc-mxc.c
index 826ab64..d814417 100644
--- a/drivers/rtc/rtc-mxc.c
+++ b/drivers/rtc/rtc-mxc.c
@@ -418,14 +418,6 @@ static int __init mxc_rtc_probe(struct platform_device *pdev)
 		goto exit_put_clk;
 	}
 
-	rtc = rtc_device_register(pdev->name, &pdev->dev, &mxc_rtc_ops,
-				  THIS_MODULE);
-	if (IS_ERR(rtc)) {
-		ret = PTR_ERR(rtc);
-		goto exit_put_clk;
-	}
-
-	pdata->rtc = rtc;
 	platform_set_drvdata(pdev, pdata);
 
 	/* Configure and enable the RTC */
@@ -438,8 +430,19 @@ static int __init mxc_rtc_probe(struct platform_device *pdev)
 		pdata->irq = -1;
 	}
 
+	rtc = rtc_device_register(pdev->name, &pdev->dev, &mxc_rtc_ops,
+				  THIS_MODULE);
+	if (IS_ERR(rtc)) {
+		ret = PTR_ERR(rtc);
+		goto exit_clr_drvdata;
+	}
+
+	pdata->rtc = rtc;
+
 	return 0;
 
+exit_clr_drvdata:
+	platform_set_drvdata(pdev, NULL);
 exit_put_clk:
 	clk_disable(pdata->clk);
 	clk_put(pdata->clk);
diff --git a/drivers/rtc/rtc-pcap.c b/drivers/rtc/rtc-pcap.c
index a633abc..cd4f198 100644
--- a/drivers/rtc/rtc-pcap.c
+++ b/drivers/rtc/rtc-pcap.c
@@ -151,6 +151,8 @@ static int __devinit pcap_rtc_probe(struct platform_device *pdev)
 
 	pcap_rtc->pcap = dev_get_drvdata(pdev->dev.parent);
 
+	platform_set_drvdata(pdev, pcap_rtc);
+
 	pcap_rtc->rtc = rtc_device_register("pcap", &pdev->dev,
 				  &pcap_rtc_ops, THIS_MODULE);
 	if (IS_ERR(pcap_rtc->rtc)) {
@@ -158,7 +160,6 @@ static int __devinit pcap_rtc_probe(struct platform_device *pdev)
 		goto fail_rtc;
 	}
 
-	platform_set_drvdata(pdev, pcap_rtc);
 
 	timer_irq = pcap_to_irq(pcap_rtc->pcap, PCAP_IRQ_1HZ);
 	alarm_irq = pcap_to_irq(pcap_rtc->pcap, PCAP_IRQ_TODA);
@@ -177,6 +178,7 @@ fail_alarm:
 fail_timer:
 	rtc_device_unregister(pcap_rtc->rtc);
 fail_rtc:
+	platform_set_drvdata(pdev, NULL);
 	kfree(pcap_rtc);
 	return err;
 }
diff --git a/drivers/rtc/rtc-rp5c01.c b/drivers/rtc/rtc-rp5c01.c
index 694da39..359da6d 100644
--- a/drivers/rtc/rtc-rp5c01.c
+++ b/drivers/rtc/rtc-rp5c01.c
@@ -249,15 +249,15 @@ static int __init rp5c01_rtc_probe(struct platform_device *dev)
 
 	spin_lock_init(&priv->lock);
 
+	platform_set_drvdata(dev, priv);
+
 	rtc = rtc_device_register("rtc-rp5c01", &dev->dev, &rp5c01_rtc_ops,
 				  THIS_MODULE);
 	if (IS_ERR(rtc)) {
 		error = PTR_ERR(rtc);
 		goto out_unmap;
 	}
-
 	priv->rtc = rtc;
-	platform_set_drvdata(dev, priv);
 
 	error = sysfs_create_bin_file(&dev->dev.kobj, &priv->nvram_attr);
 	if (error)
@@ -268,6 +268,7 @@ static int __init rp5c01_rtc_probe(struct platform_device *dev)
 out_unregister:
 	rtc_device_unregister(rtc);
 out_unmap:
+	platform_set_drvdata(dev, NULL);
 	iounmap(priv->regs);
 out_free_priv:
 	kfree(priv);
diff --git a/kernel/time/clocksource.c b/kernel/time/clocksource.c
index 6519cf6..0e17c10 100644
--- a/kernel/time/clocksource.c
+++ b/kernel/time/clocksource.c
@@ -685,8 +685,8 @@ int __clocksource_register_scale(struct clocksource *cs, u32 scale, u32 freq)
 	/* Add clocksource to the clcoksource list */
 	mutex_lock(&clocksource_mutex);
 	clocksource_enqueue(cs);
-	clocksource_select();
 	clocksource_enqueue_watchdog(cs);
+	clocksource_select();
 	mutex_unlock(&clocksource_mutex);
 	return 0;
 }
@@ -706,8 +706,8 @@ int clocksource_register(struct clocksource *cs)
 
 	mutex_lock(&clocksource_mutex);
 	clocksource_enqueue(cs);
-	clocksource_select();
 	clocksource_enqueue_watchdog(cs);
+	clocksource_select();
 	mutex_unlock(&clocksource_mutex);
 	return 0;
 }
diff --git a/kernel/time/tick-broadcast.c b/kernel/time/tick-broadcast.c
index da800ff..723c763 100644
--- a/kernel/time/tick-broadcast.c
+++ b/kernel/time/tick-broadcast.c
@@ -522,10 +522,11 @@ static void tick_broadcast_init_next_event(struct cpumask *mask,
  */
 void tick_broadcast_setup_oneshot(struct clock_event_device *bc)
 {
+	int cpu = smp_processor_id();
+
 	/* Set it up only once ! */
 	if (bc->event_handler != tick_handle_oneshot_broadcast) {
 		int was_periodic = bc->mode == CLOCK_EVT_MODE_PERIODIC;
-		int cpu = smp_processor_id();
 
 		bc->event_handler = tick_handle_oneshot_broadcast;
 		clockevents_set_mode(bc, CLOCK_EVT_MODE_ONESHOT);
@@ -551,6 +552,15 @@ void tick_broadcast_setup_oneshot(struct clock_event_device *bc)
 			tick_broadcast_set_event(tick_next_period, 1);
 		} else
 			bc->next_event.tv64 = KTIME_MAX;
+	} else {
+		/*
+		 * The first cpu which switches to oneshot mode sets
+		 * the bit for all other cpus which are in the general
+		 * (periodic) broadcast mask. So the bit is set and
+		 * would prevent the first broadcast enter after this
+		 * to program the bc device.
+		 */
+		tick_broadcast_clear_oneshot(cpu);
 	}
 }
 
--8323328-1096934113-1305638721=:3078--
