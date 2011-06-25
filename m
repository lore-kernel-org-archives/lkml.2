Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751920Ab1FYQvp (ORCPT <rfc822;w@1wt.eu>);
	Sat, 25 Jun 2011 12:51:45 -0400
Received: from queueout04-winn.ispmail.ntl.com ([81.103.221.58]:32939 "EHLO
	queueout04-winn.ispmail.ntl.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751773Ab1FYQvj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 25 Jun 2011 12:51:39 -0400
From: Daniel Drake <dsd@laptop.org>
To: tglx@linutronix.de, mingo@redhat.com, hpa@zytor.com, x86@kernel.org,
        akpm@linux-foundation.org
Cc: linux-kernel@vger.kernel.org, dilinger@queued.net, bigeasy@linutronix.de,
        Daniel Drake <dsd@laptop.org>
Subject: [PATCH v3 08/11] x86, olpc-xo1-sci: Add lid switch functionality
Date: Sat, 25 Jun 2011 17:34:15 +0100
Message-Id: <1309019658-1712-9-git-send-email-dsd@laptop.org>
X-Mailer: git-send-email 1.7.5.4
In-Reply-To: <1309019658-1712-1-git-send-email-dsd@laptop.org>
References: <1309019658-1712-1-git-send-email-dsd@laptop.org>
X-Cloudmark-Analysis: v=1.1 cv=R50lirqlHffDPPkwUlkuVa99MrvKdVWo//yz83qex8g= c=1 sm=0 a=LrzjRJaOOPsA:10 a=vJ1w_8FsMGIA:10 a=Op-mwl0xAAAA:8 a=In_Hgl4hAAAA:8 a=XRJDNDRM7ZC5vxybvQAA:9 a=8vlz_MQLQWCzUMhW7PUA:7 a=d4CUUju0HPYA:10 a=ro211Ng2IWAA:10 a=HpAAvcLHHh0Zw7uRqdWCyQ==:117
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Configure the XO-1's lid switch GPIO to trigger an SCI interrupt,
and correctly expose this input device which can be used as a wakeup
source.

Signed-off-by: Daniel Drake <dsd@laptop.org>
Acked-by: Andres Salomon <dilinger@queued.net>
---
 arch/x86/Kconfig                      |    1 +
 arch/x86/platform/olpc/olpc-xo1-sci.c |  207 ++++++++++++++++++++++++++++++++-
 include/linux/cs5535.h                |    1 +
 3 files changed, 208 insertions(+), 1 deletions(-)

diff --git a/arch/x86/Kconfig b/arch/x86/Kconfig
index f527dfd..f5bc969 100644
--- a/arch/x86/Kconfig
+++ b/arch/x86/Kconfig
@@ -2092,6 +2092,7 @@ config OLPC_XO1_SCI
 	   - EC-driven system wakeups
 	   - Power button
 	   - Ebook switch
+	   - Lid switch
 
 endif # X86_32
 
diff --git a/arch/x86/platform/olpc/olpc-xo1-sci.c b/arch/x86/platform/olpc/olpc-xo1-sci.c
index 63f5050..ad0670b 100644
--- a/arch/x86/platform/olpc/olpc-xo1-sci.c
+++ b/arch/x86/platform/olpc/olpc-xo1-sci.c
@@ -32,9 +32,26 @@
 static unsigned long acpi_base;
 static struct input_dev *power_button_idev;
 static struct input_dev *ebook_switch_idev;
+static struct input_dev *lid_switch_idev;
 
 static int sci_irq;
 
+static bool lid_open;
+static bool lid_inverted;
+static int lid_wake_mode;
+
+enum lid_wake_modes {
+	LID_WAKE_ALWAYS,
+	LID_WAKE_OPEN,
+	LID_WAKE_CLOSE,
+};
+
+static const char * const lid_wake_mode_names[] = {
+	[LID_WAKE_ALWAYS] = "always",
+	[LID_WAKE_OPEN] = "open",
+	[LID_WAKE_CLOSE] = "close",
+};
+
 /* Report current ebook switch state through input layer */
 static void send_ebook_state(void)
 {
@@ -49,6 +66,70 @@ static void send_ebook_state(void)
 	input_sync(ebook_switch_idev);
 }
 
+static void flip_lid_inverter(void)
+{
+	/* gpio is high; invert so we'll get l->h event interrupt */
+	if (lid_inverted)
+		cs5535_gpio_clear(OLPC_GPIO_LID, GPIO_INPUT_INVERT);
+	else
+		cs5535_gpio_set(OLPC_GPIO_LID, GPIO_INPUT_INVERT);
+	lid_inverted = !lid_inverted;
+}
+
+static void detect_lid_state(void)
+{
+	/*
+	 * the edge detector hookup on the gpio inputs on the geode is
+	 * odd, to say the least.  See http://dev.laptop.org/ticket/5703
+	 * for details, but in a nutshell:  we don't use the edge
+	 * detectors.  instead, we make use of an anomoly:  with the both
+	 * edge detectors turned off, we still get an edge event on a
+	 * positive edge transition.  to take advantage of this, we use the
+	 * front-end inverter to ensure that that's the edge we're always
+	 * going to see next.
+	 */
+
+	int state;
+
+	state = cs5535_gpio_isset(OLPC_GPIO_LID, GPIO_READ_BACK);
+	lid_open = !state ^ !lid_inverted; /* x ^^ y */
+	if (!state)
+		return;
+
+	flip_lid_inverter();
+}
+
+/* Report current lid switch state through input layer */
+static void send_lid_state(void)
+{
+	input_report_switch(lid_switch_idev, SW_LID, !lid_open);
+	input_sync(lid_switch_idev);
+}
+
+static ssize_t lid_wake_mode_show(struct device *dev,
+				  struct device_attribute *attr, char *buf)
+{
+	const char *mode = lid_wake_mode_names[lid_wake_mode];
+	return sprintf(buf, "%s\n", mode);
+}
+static ssize_t lid_wake_mode_set(struct device *dev,
+				 struct device_attribute *attr,
+				 const char *buf, size_t count)
+{
+	int i;
+	for (i = 0; i < ARRAY_SIZE(lid_wake_mode_names); i++) {
+		const char *mode = lid_wake_mode_names[i];
+		if (strlen(mode) != count || strncasecmp(mode, buf, count))
+			continue;
+
+		lid_wake_mode = i;
+		return count;
+	}
+	return -EINVAL;
+}
+static DEVICE_ATTR(lid_wake_mode, S_IWUSR | S_IRUGO, lid_wake_mode_show,
+		   lid_wake_mode_set);
+
 /*
  * Process all items in the EC's SCI queue.
  *
@@ -111,6 +192,11 @@ static irqreturn_t xo1_sci_intr(int irq, void *dev_id)
 		schedule_work(&sci_work);
 	}
 
+	cs5535_gpio_set(OLPC_GPIO_LID, GPIO_NEGATIVE_EDGE_STS);
+	cs5535_gpio_set(OLPC_GPIO_LID, GPIO_POSITIVE_EDGE_STS);
+	detect_lid_state();
+	send_lid_state();
+
 	return IRQ_HANDLED;
 }
 
@@ -126,11 +212,32 @@ static int xo1_sci_suspend(struct platform_device *pdev, pm_message_t state)
 	else
 		olpc_ec_wakeup_clear(EC_SCI_SRC_EBOOK);
 
+	if (!device_may_wakeup(&lid_switch_idev->dev)) {
+		cs5535_gpio_clear(OLPC_GPIO_LID, GPIO_EVENTS_ENABLE);
+	} else if ((lid_open && lid_wake_mode == LID_WAKE_OPEN) ||
+		   (!lid_open && lid_wake_mode == LID_WAKE_CLOSE)) {
+		flip_lid_inverter();
+
+		/* we may have just caused an event */
+		cs5535_gpio_set(OLPC_GPIO_LID, GPIO_NEGATIVE_EDGE_STS);
+		cs5535_gpio_set(OLPC_GPIO_LID, GPIO_POSITIVE_EDGE_STS);
+
+		cs5535_gpio_set(OLPC_GPIO_LID, GPIO_EVENTS_ENABLE);
+	}
+
 	return 0;
 }
 
 static int xo1_sci_resume(struct platform_device *pdev)
 {
+	/*
+	 * We don't know what may have happened while we were asleep.
+	 * Reestablish our lid setup so we're sure to catch all transitions.
+	 */
+	detect_lid_state();
+	send_lid_state();
+	cs5535_gpio_set(OLPC_GPIO_LID, GPIO_EVENTS_ENABLE);
+
 	/* Enable all EC events */
 	olpc_ec_mask_write(EC_SCI_SRC_ALL);
 	return 0;
@@ -221,6 +328,43 @@ static void free_ec_sci(void)
 	gpio_free(OLPC_GPIO_ECSCI);
 }
 
+static int __devinit setup_lid_events(void)
+{
+	int r;
+
+	r = gpio_request(OLPC_GPIO_LID, "OLPC-LID");
+	if (r)
+		return r;
+
+	gpio_direction_input(OLPC_GPIO_LID);
+
+	cs5535_gpio_clear(OLPC_GPIO_LID, GPIO_INPUT_INVERT);
+	lid_inverted = 0;
+
+	/* Clear edge detection and event enable for now */
+	cs5535_gpio_clear(OLPC_GPIO_LID, GPIO_EVENTS_ENABLE);
+	cs5535_gpio_clear(OLPC_GPIO_LID, GPIO_NEGATIVE_EDGE_EN);
+	cs5535_gpio_clear(OLPC_GPIO_LID, GPIO_POSITIVE_EDGE_EN);
+	cs5535_gpio_set(OLPC_GPIO_LID, GPIO_NEGATIVE_EDGE_STS);
+	cs5535_gpio_set(OLPC_GPIO_LID, GPIO_POSITIVE_EDGE_STS);
+
+	/* Set the LID to cause an PME event on group 6 */
+	cs5535_gpio_setup_event(OLPC_GPIO_LID, 6, 1);
+
+	/* Set PME group 6 to fire the SCI interrupt */
+	cs5535_gpio_set_irq(6, sci_irq);
+
+	/* Enable the event */
+	cs5535_gpio_set(OLPC_GPIO_LID, GPIO_EVENTS_ENABLE);
+
+	return 0;
+}
+
+static void free_lid_events(void)
+{
+	gpio_free(OLPC_GPIO_LID);
+}
+
 static int __devinit setup_power_button(struct platform_device *pdev)
 {
 	int r;
@@ -283,6 +427,50 @@ static void free_ebook_switch(void)
 	input_free_device(ebook_switch_idev);
 }
 
+static int __devinit setup_lid_switch(struct platform_device *pdev)
+{
+	int r;
+
+	lid_switch_idev = input_allocate_device();
+	if (!lid_switch_idev)
+		return -ENOMEM;
+
+	lid_switch_idev->name = "Lid Switch";
+	lid_switch_idev->phys = DRV_NAME "/input2";
+	set_bit(EV_SW, lid_switch_idev->evbit);
+	set_bit(SW_LID, lid_switch_idev->swbit);
+
+	lid_switch_idev->dev.parent = &pdev->dev;
+	device_set_wakeup_capable(&lid_switch_idev->dev, true);
+
+	r = input_register_device(lid_switch_idev);
+	if (r) {
+		dev_err(&pdev->dev, "failed to register lid switch: %d\n", r);
+		goto err_register;
+	}
+
+	r = device_create_file(&lid_switch_idev->dev, &dev_attr_lid_wake_mode);
+	if (r) {
+		dev_err(&pdev->dev, "failed to create wake mode attr: %d\n", r);
+		goto err_create_attr;
+	}
+
+	return 0;
+
+err_create_attr:
+	input_unregister_device(lid_switch_idev);
+err_register:
+	input_free_device(lid_switch_idev);
+	return r;
+}
+
+static void free_lid_switch(void)
+{
+	device_remove_file(&lid_switch_idev->dev, &dev_attr_lid_wake_mode);
+	input_unregister_device(lid_switch_idev);
+	input_free_device(lid_switch_idev);
+}
+
 static int __devinit xo1_sci_probe(struct platform_device *pdev)
 {
 	struct resource *res;
@@ -311,12 +499,21 @@ static int __devinit xo1_sci_probe(struct platform_device *pdev)
 	if (r)
 		goto err_ebook;
 
+	r = setup_lid_switch(pdev);
+	if (r)
+		goto err_lid;
+
+	r = setup_lid_events();
+	if (r)
+		goto err_lidevt;
+
 	r = setup_ec_sci();
 	if (r)
 		goto err_ecsci;
 
 	/* Enable PME generation for EC-generated events */
-	outl(CS5536_GPIOM7_PME_EN, acpi_base + CS5536_PM_GPE0_EN);
+	outl(CS5536_GPIOM6_PME_EN | CS5536_GPIOM7_PME_EN,
+		acpi_base + CS5536_PM_GPE0_EN);
 
 	/* Clear pending events */
 	outl(0xffffffff, acpi_base + CS5536_PM_GPE0_STS);
@@ -324,6 +521,8 @@ static int __devinit xo1_sci_probe(struct platform_device *pdev)
 
 	/* Initial sync */
 	send_ebook_state();
+	detect_lid_state();
+	send_lid_state();
 
 	r = setup_sci_interrupt(pdev);
 	if (r)
@@ -337,6 +536,10 @@ static int __devinit xo1_sci_probe(struct platform_device *pdev)
 err_sci:
 	free_ec_sci();
 err_ecsci:
+	free_lid_events();
+err_lidevt:
+	free_lid_switch();
+err_lid:
 	free_ebook_switch();
 err_ebook:
 	free_power_button();
@@ -349,6 +552,8 @@ static int __devexit xo1_sci_remove(struct platform_device *pdev)
 	free_irq(sci_irq, pdev);
 	cancel_work_sync(&sci_work);
 	free_ec_sci();
+	free_lid_events();
+	free_lid_switch();
 	free_ebook_switch();
 	free_power_button();
 	acpi_base = 0;
diff --git a/include/linux/cs5535.h b/include/linux/cs5535.h
index d7e9a7f..72954c6 100644
--- a/include/linux/cs5535.h
+++ b/include/linux/cs5535.h
@@ -102,6 +102,7 @@ static inline int cs5535_pic_unreqz_select_high(unsigned int group,
 
 /* CS5536_PM_GPE0_EN bits */
 #define CS5536_GPIOM7_PME_EN	(1 << 31)
+#define CS5536_GPIOM6_PME_EN	(1 << 30)
 
 /* VSA2 magic values */
 #define VSA_VRC_INDEX		0xAC1C
-- 
1.7.5.4

